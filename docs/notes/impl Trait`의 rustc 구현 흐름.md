# impl Trait`의 rustc 구현 흐름

이 문서는 `fn foo() -> impl Trait` 처럼 **return‑position `impl Trait`(RPIT)** 를 중심으로, 현재 rustc 코드베이스에서 `impl Trait`이 어떻게 파싱・HIR lowering・타입 수집・타입 검사・트레이트 풀림・코드 생성까지 처리되는지를 정리한 것입니다.

> 참고: 아래 파일 경로와 줄 번호는 `/home/juhyung/code/rust` 기준의 최신 코드를 기반으로 합니다. 코드가 리팩토링되면 줄 번호는 달라질 수 있으나 함수/구조체 이름은 안정적입니다.

---

## 1. `impl Trait`이란?

`impl Trait`은 **불투명 타입(opaque type)** 입니다. 호출자는 해당 타입이 어떤 구체 타입인지 알 수 없고, `impl Trait` 뒤에 나열한 트레이트 바운드만 볼 수 있습니다. 컴파일러는 함수 본문을 검사하면서 실제 반환 표현식의 타입을 “숨겨진 타입(hidden type)”으로 기록해 둡니다.

```rust
fn foo() -> impl Iterator<Item = i32> {
    vec![1, 2, 3].into_iter()
}
```

위 코드는 개념적으로 다음처럼 해석됩니다.

```rust
type FooReturn = impl Iterator<Item = i32>;
fn foo() -> FooReturn {
    vec![1, 2, 3].into_iter()
}
```

---

## 2. `impl Trait`의 여러 형태와 feature gate

| 형태 | 예시 | 상태 | 관련 feature gate |
|------|------|------|-------------------|
| **RPIT** (return position) | `fn f() -> impl Trait` | stable 1.26 | `conservative_impl_trait` |
| **APIT** (argument position) | `fn f(x: impl Trait)` | stable 1.26 | `universal_impl_trait` |
| **TAIT** (type alias) | `type T = impl Trait;` | unstable | `type_alias_impl_trait` |
| **bindings** | `let x: impl Trait = ...;` | unstable | `impl_trait_in_bindings` |
| **RPITIT** (trait 메서드 반환) | `trait T { fn f() -> impl Trait; }` | stable 1.75 | `return_position_impl_trait_in_trait` |
| **fn trait return** | `Fn() -> impl Trait` | unstable | `impl_trait_in_fn_trait_return` |

Feature gate 등록 위치:

- `compiler/rustc_feature/src/accepted.rs`
  - `conservative_impl_trait` (line 128)
  - `universal_impl_trait` (line 462)
  - `return_position_impl_trait_in_trait` (line 396)
- `compiler/rustc_feature/src/unstable.rs`
  - `type_alias_impl_trait` (line 766)
  - `impl_trait_in_bindings` (line 599)
  - `impl_trait_in_fn_trait_return` (line 601)

---

## 3. 컴파일러 파이프라인 개요

```
소스 텍스트
  → parse: TyKind::ImplTrait
  → AST lowering: ImplTraitContext에 따라 Universal / OpaqueTy / InBinding / Disallowed
  → HIR: TyKind::OpaqueDef 또는 TyKind::TraitAscription
  → type collection: opaque 타입 생성, 제네릭/바운드 수집
  → type checking: hidden type 추론, defining use 검사
  → trait solving: auto trait leakage 등
  → borrowck / codegen: hidden type 최종 확정 후 사용
```

---

## 4. 파싱

`impl Trait` 구문은 `compiler/rustc_parse/src/parser/ty.rs`의 `parse_impl_ty`에서 파싱됩니다.

```rust
// compiler/rustc_parse/src/parser/ty.rs:943
fn parse_impl_ty(&mut self, impl_dyn_multi: &mut bool) -> PResult<'a, TyKind> {
    let bounds = self.parse_generic_bounds()?;
    *impl_dyn_multi = bounds.len() > 1 || self.prev_token == TokenKind::Plus;
    Ok(TyKind::ImplTrait(ast::DUMMY_NODE_ID, bounds))
}
```

결과는 `ast::TyKind::ImplTrait(NodeId, GenericBounds)`입니다.

정의: `compiler/rustc_ast/src/ast.rs:2545`

```rust
pub enum TyKind {
    // ...
    ImplTrait(NodeId, #[visitable(extra = BoundKind::Impl)] GenericBounds),
    // ...
}
```

---

## 5. AST → HIR lowering

`compiler/rustc_ast_lowering/src/lib.rs`에서 `impl Trait`의 위치별 의미를 결정합니다. 핵심은 `ImplTraitContext` 열거형입니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:389
enum ImplTraitContext {
    /// 인자 위치: `fn f(x: impl Debug)` -> 새로운 universal 제네릭 파라미터
    Universal,
    /// 반환 위치: `fn f() -> impl Debug` -> 새로운 opaque 타입
    OpaqueTy { origin: hir::OpaqueTyOrigin<LocalDefId> },
    /// let 바인딩: `let x: impl Debug = ...`
    InBinding,
    /// 허용되지 않는 위치
    Disallowed(ImplTraitPosition),
    /// 불안정한 위치
    FeatureGated(ImplTraitPosition, Symbol),
}
```

### 5.1 RPIT: 반환 위치

`lower_fn_decl`에서 반환 타입에 대해 `ImplTraitContext::OpaqueTy`를 사용합니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1988
let itctx = match kind {
    FnDeclKind::Fn | FnDeclKind::Inherent => ImplTraitContext::OpaqueTy {
        origin: hir::OpaqueTyOrigin::FnReturn {
            parent: self.owner.def_id,
            in_trait_or_impl: None,
        },
    },
    // trait / impl 도 비슷하게 OpaqueTy { origin: FnReturn { ..., in_trait_or_impl: Some(...) } }
    // ...
};
hir::FnRetTy::Return(self.lower_ty_alloc(ty, itctx))
```

`lower_ty`는 `TyKind::ImplTrait`를 만나면 `ImplTraitContext::OpaqueTy`에 따라 `lower_opaque_impl_trait`를 호출합니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1679
TyKind::ImplTrait(def_node_id, bounds) => {
    match itctx {
        ImplTraitContext::OpaqueTy { origin } => {
            self.lower_opaque_impl_trait(span, origin, *def_node_id, bounds, itctx)
        }
        // ...
    }
}
```

`lower_opaque_impl_trait`는 `lower_opaque_inner`를 호출해 실제 `hir::OpaqueTy`를 생성하고, `hir::TyKind::OpaqueDef`를 반환합니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1846
fn lower_opaque_impl_trait(...) -> hir::TyKind<'hir> {
    let opaque_ty_span = self.mark_span_with_reason(DesugaringKind::OpaqueTy, span, None);
    self.lower_opaque_inner(opaque_ty_node_id, origin, opaque_ty_span, |this| {
        this.lower_param_bounds(bounds, RelaxedBoundPolicy::Allowed(&mut Default::default()), itctx)
    })
}

// compiler/rustc_ast_lowering/src/lib.rs:1870
fn lower_opaque_inner(...) -> hir::TyKind<'hir> {
    let opaque_ty_def = hir::OpaqueTy {
        hir_id: opaque_ty_hir_id,
        def_id: opaque_ty_def_id,
        bounds,
        origin,
        span: self.lower_span(opaque_ty_span),
    };
    hir::TyKind::OpaqueDef(self.arena.alloc(opaque_ty_def))
}
```

HIR에 `OpaqueTy`가 정의됩니다.

```rust
// compiler/rustc_hir/src/hir.rs:3941
pub enum TyKind<'hir, Unambig = ()> {
    // ...
    /// An opaque type definition itself. This is only used for `impl Trait`.
    OpaqueDef(&'hir OpaqueTy<'hir>),
    /// A trait ascription type, which is `impl Trait` within a local binding.
    TraitAscription(GenericBounds<'hir>),
    // ...
}
```

### 5.2 APIT: 인자 위치

`lower_fn_decl`에서 인자는 `ImplTraitContext::Universal`로 lowering됩니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1964
let itctx = match kind {
    FnDeclKind::Fn | FnDeclKind::Inherent | FnDeclKind::Impl | FnDeclKind::Trait => {
        ImplTraitContext::Universal
    }
    // ...
};
self.lower_ty(&param.ty, itctx)
```

`lower_ty`는 `Universal` 모드에서 `impl Trait`를 새로운 제네릭 파라미터로 바꿉니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1685
ImplTraitContext::Universal => {
    let (param, bounds, path) = self.lower_universal_param_and_bounds(...);
    self.impl_trait_defs.push(param);
    if let Some(bounds) = bounds {
        self.impl_trait_bounds.push(bounds);
    }
    path
}
```

이렇게 모은 `impl_trait_defs`/`impl_trait_bounds`는 함수의 `Generics`에 삽입됩니다.

```rust
// compiler/rustc_ast_lowering/src/item.rs:1901
let impl_trait_defs = std::mem::take(&mut self.impl_trait_defs);
params.extend(impl_trait_defs.into_iter());

let impl_trait_bounds = std::mem::take(&mut self.impl_trait_bounds);
predicates.extend(impl_trait_bounds.into_iter());
```

따라서 `fn f(x: impl Debug)`는 개념적으로 `fn f<T: Debug>(x: T)`와 동일하게 HIR에 남습니다.

### 5.3 `impl Trait` in bindings

`let x: impl Trait = ...`는 `ImplTraitContext::InBinding`로 처리되며, `hir::TyKind::TraitAscription`이 됩니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:1708
ImplTraitContext::InBinding => {
    hir::TyKind::TraitAscription(self.lower_param_bounds(...))
}
```

### 5.4 비허용/불안정 위치

`impl Trait`이 허용되지 않는 위치에 있으면 `ImplTraitContext::Disallowed(...)`로 lowering되어 `MisplacedImplTrait` 에러가 발생합니다. 불안정 기능은 `FeatureGated(...)`를 통해 feature gate 에러가 발생합니다.

---

## 6. 타입 수집 (Type collection)

`rustc_hir_analysis` crate가 HIR에서 중간 표현 타입(`ty::Ty`)을 생성합니다.

### 6.1 HIR `OpaqueDef` → `ty::Ty`

`compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs:3210`에서 `OpaqueDef`를 만나면 `lower_opaque_ty`를 호출합니다.

```rust
&hir::TyKind::OpaqueDef(opaque_ty) => {
    let in_trait = match opaque_ty.origin { /* RPITIT인지 판단 */ };
    self.lower_opaque_ty(opaque_ty.def_id, in_trait)
}
```

`lower_opaque_ty`는 대부분의 경우 `Ty::new_opaque(...)`를 만들고, **trait 메서드의 반환 위치(RPITIT)** 인 경우에는 synthetic associated type으로 매핑해 `Ty::new_projection_from_args(...)`를 만듭니다.

```rust
// compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs:3640
if in_trait.is_some() {
    Ty::new_projection_from_args(tcx, ty::IsRigid::No, def_id, args)
} else {
    Ty::new_opaque(tcx, ty::IsRigid::No, def_id, args)
}
```

타입 IR 내부에서 opaque 타입은 `ty::Alias`에 `AliasTyKind::Opaque`로 표현됩니다.

```rust
// compiler/rustc_type_ir/src/ty_kind.rs:34
pub enum AliasTyKind<I: Interner> {
    // ...
    Opaque { def_id: I::OpaqueTyId },
    // ...
}

// compiler/rustc_type_ir/src/ty_kind.rs:302
Alias(IsRigid, AliasTy<I>),
```

### 6.2 Opaque 타입의 제네릭

Opaque 타입은 부모 함수의 제네릭을 상속하고, 필요한 lifetime만 추가로 캡처합니다.

- `compiler/rustc_hir_analysis/src/collect/generics_of.rs:374`
- `compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs:523` (`opaque_captured_lifetimes`)

```rust
// generics_of.rs:374
if let Node::OpaqueTy(&hir::OpaqueTy { .. }) = node {
    assert!(own_params.is_empty());
    let lifetimes = tcx.opaque_captured_lifetimes(def_id);
    own_params.extend(lifetimes.iter().map(|&(_, param)| ty::GenericParamDef {
        // ...
        kind: ty::GenericParamDefKind::Lifetime,
    }))
}
```

### 6.3 Opaque 타입의 바운드 수집

`compiler/rustc_hir_analysis/src/collect/item_bounds.rs:360`의 `opaque_type_bounds`가 명시적 바운드와 `Sized` 등의 묵시적 바운드를 모읍니다.

```rust
fn opaque_type_bounds<'tcx>(...) {
    icx.lowerer().lower_bounds(item_ty, hir_bounds, &mut bounds, ...);
    icx.lowerer().add_implicit_sizedness_bounds(...);
    icx.lowerer().add_default_traits(...);
}
```

---

## 7. 타입 검사 (Type checking)

`rustc_hir_typeck`가 함수 본문을 검사하면서 `impl Trait`의 실제 hidden type을 추론합니다.

### 7.1 `InferCtxt`와 `TypingMode`

`TypeckRootCtxt::new`에서 본문에 대해 `TypingMode::typeck_for_body`를 만듭니다. 이 모드는 해당 본문이 정의할 수 있는 opaque 타입들을 포함합니다.

```rust
// compiler/rustc_hir_typeck/src/typeck_root_ctxt.rs:88
let infcx = tcx
    .infer_ctxt()
    .ignoring_regions()
    .in_hir_typeck()
    .build(TypingMode::typeck_for_body(tcx, def_id));
```

`typeck_for_body`는 `opaque_types_and_coroutines_defined_by(body_def_id)`를 통해 이 본문이 정의하는 모든 opaque 타입을 수집합니다.

```rust
// compiler/rustc_type_ir/src/infer_ctxt.rs:308
pub fn typeck_for_body(cx: I, body_def_id: I::LocalDefId) -> TypingMode<I> {
    TypingMode::Typeck {
        defining_opaque_types_and_generators: cx
            .opaque_types_and_coroutines_defined_by(body_def_id),
    }
}
```

### 7.2 Opaque 타입의 사용 기록

타입 검사 중 opaque 타입에 대한 각 등장은 `infcx.opaque_type_storage`에 기록됩니다. 이 저장소는 `rustc_infer/src/infer/mod.rs`의 `opaque_type_storage` 필드로 관리됩니다.

```rust
// compiler/rustc_infer/src/infer/mod.rs:161
opaque_type_storage: OpaqueTypeStorage<'tcx>,
```

### 7.3 Defining use 찾기

`compiler/rustc_hir_typeck/src/opaque_types.rs`에서 `handle_opaque_type_uses_next` / `try_handle_opaque_type_uses_next`가 모든 opaque 타입 사용을 살펴보고, **defining use**를 찾습니다.

```rust
// compiler/rustc_hir_typeck/src/opaque_types.rs:46
pub(super) fn handle_opaque_type_uses_next(&mut self) {
    let opaque_types: Vec<_> = self.infcx.clone_opaque_types();
    // ...
    self.compute_definition_site_hidden_types(opaque_types, true);
}
```

`consider_opaque_type_use`는 한 사용이 defining use인지 검사합니다.

- non‑lifetime 인자가 모두 유일한 generic parameter여야 함
- hidden type에 추론 변수(inference variable)가 없어야 함

```rust
// compiler/rustc_hir_typeck/src/opaque_types.rs:215
fn consider_opaque_type_use(&self, opaque_type_key, hidden_type) -> UsageKind<'tcx> {
    if let Err(err) = opaque_type_has_defining_use_args(&self, opaque_type_key, hidden_type.span, DefiningScopeKind::HirTypeck) {
        // ...
    }
    // ...
}
```

Defining use 규칙은 `compiler/rustc_trait_selection/src/opaque_types.rs:66`의 `opaque_type_has_defining_use_args`에 구현되어 있습니다.

```rust
pub fn opaque_type_has_defining_use_args<'tcx>(
    infcx: &InferCtxt<'tcx>,
    opaque_type_key: OpaqueTypeKey<'tcx>,
    span: Span,
    defining_scope_kind: DefiningScopeKind,
) -> Result<(), NonDefiningUseReason<'tcx>> {
    for (i, arg) in opaque_type_key.iter_captured_args(tcx) {
        let arg_is_param = match arg.kind() {
            GenericArgKind::Lifetime(_) => /* lifetime는 special 처리 */,
            GenericArgKind::Type(ty) => matches!(ty.kind(), ty::Param(_)),
            GenericArgKind::Const(ct) => matches!(ct.kind(), ty::ConstKind::Param(_)),
        };
        // ...
    }
}
```

### 7.4 Writeback

검사가 끝나면 `compiler/rustc_hir_typeck/src/writeback.rs`의 `visit_opaque_types`가 hidden type을 `TypeckResults`에 저장합니다.

```rust
// compiler/rustc_hir_typeck/src/writeback.rs:571
fn visit_opaque_types(&mut self) {
    let opaque_types = self.fcx.infcx.clone_opaque_types();
    for (opaque_type_key, hidden_type) in opaque_types {
        // ...
        if let Err(err) = opaque_type_has_defining_use_args(...) {
            // non‑defining use 에러 처리
        }
        let hidden_type = hidden_type.remap_generic_params_to_declaration_params(...);
        self.typeck_results.hidden_types.insert(opaque_type_key.def_id, hidden_type);
    }
}
```

---

## 8. 트레이트 풀림과 auto trait leakage

`impl Trait`은 타입 검사 시에는 불투명하지만, **auto trait**(`Send`, `Sync` 등)에 대해서는 실제 hidden type의 성질이 “새어 나오는” 것이 허용됩니다.

### 8.1 Auto trait 후보 생성

`compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs:848`에서 opaque 타입에 대한 auto trait 후보를 만듭니다.

- defining scope **밖**에서는 `AutoImplCandidate`를 추가하고, hidden type을 살펴봅니다.
- defining scope **안**에서는 `candidates.ambiguous = true`로 두어 아직 풀지 않습니다.

```rust
ty::Alias(_, ty::AliasTy { kind: ty::Opaque { def_id }, args, .. }) => {
    if self.infcx.can_define_opaque_ty(def_id) {
        candidates.ambiguous = true;
    } else {
        candidates.vec.push(AutoImplCandidate)
    }
}
```

### 8.2 Hidden type으로 auto trait 검사

`compiler/rustc_trait_selection/src/traits/select/mod.rs:2443`에서 auto trait 구성 요소를 수집할 때, opaque 타입의 hidden type을 `type_of_opaque`로 얻어와 그 구성 요소를 검사합니다.

```rust
ty::Alias(_, ty::AliasTy { kind: ty::Opaque { def_id }, args, .. }) => {
    if self.infcx.can_define_opaque_ty(def_id) {
        unreachable!()
    } else {
        let ty = self.tcx().type_of_opaque(def_id);
        ty::Binder::dummy(AutoImplConstituents {
            types: vec![ty.instantiate(self.tcx(), args).skip_norm_wip()],
            assumptions: vec![],
        })
    }
}
```

`can_define_opaque_ty`는 현재 `InferCtxt`의 `TypingMode`에 따라 정의 가능 여부를 결정합니다.

```rust
// compiler/rustc_infer/src/infer/mod.rs:1182
pub fn can_define_opaque_ty(&self, id: impl Into<DefId>) -> bool {
    match self.typing_mode_raw().assert_not_erased() {
        TypingMode::Typeck { defining_opaque_types_and_generators }
        | TypingMode::PostTypeckUntilBorrowck { defining_opaque_types } => {
            id.into().as_local().is_some_and(|def_id| defining_opaque_types.contains(&def_id))
        }
        // ...
        _ => false,
    }
}
```

---

## 9. `type_of_opaque`: hidden type 최종 확정

`compiler/rustc_hir_analysis/src/collect/type_of.rs`의 `type_of_opaque`와 `type_of_opaque_hir_typeck`가 opaque 타입의 최종 구체 타입을 반환합니다.

```rust
// compiler/rustc_hir_analysis/src/collect/type_of.rs:261
pub(super) fn type_of_opaque(tcx: TyCtxt<'_>, def_id: DefId) -> ty::EarlyBinder<'_, Ty<'_>> {
    // ...
    opaque::find_opaque_ty_constraints_for_rpit(tcx, def_id, owner, DefiningScopeKind::MirBorrowck)
}
```

RPIT의 경우 `find_opaque_ty_constraints_for_rpit`는 다음을 순서대로 시도합니다.

1. `typeck` 결과에서 `hidden_types`를 찾습니다.
2. 없으면 `mir_borrowck` 결과에서 hidden type을 찾습니다.
3. 실패하면 fallback(현재 `()`)을 사용합니다.

```rust
// compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs:237
pub(super) fn find_opaque_ty_constraints_for_rpit<'tcx>(...) {
    if !tcx.opaque_types_defined_by(owner_def_id).contains(&def_id) {
        // stranded opaque type 처리
    }
    match opaque_types_from {
        DefiningScopeKind::HirTypeck => {
            let tables = tcx.typeck(owner_def_id);
            if let Some(hidden_ty) = tables.hidden_types.get(&def_id) {
                hidden_ty.ty
            } else { /* fallback */ }
        }
        DefiningScopeKind::MirBorrowck => match tcx.mir_borrowck(owner_def_id) {
            Ok(hidden_types) => { /* hidden type 사용 */ }
            // ...
        },
    }
}
```

`type_of_opaque`는 codegen, trait auto impl, MIR borrowck 등에서 호출되어 opaque 타입을 실제 타입으로 대체합니다.

---

## 10. 변형: APIT, TAIT, RPITIT, bindings, async

### 10.1 APIT (Universal)

`impl Trait` 인자는 lowering 단계에서 새로운 제네릭 파라미터로 바뀌며, 이후 타입 검사에서는 일반 제네릭과 동일하게 취급됩니다.

### 10.2 TAIT (Type alias impl trait)

```rust
type Foo<T> = impl Trait<T>;
```

`type_alias_impl_trait` feature 아래에서 `OpaqueTyOrigin::TyAlias { parent, ... }`로 lowering됩니다. `type_of` 경로에서 `find_opaque_ty_constraints_for_tait`를 통해 hidden type이 결정됩니다.

### 10.3 RPITIT (Return position impl trait in trait)

```rust
trait Foo {
    fn bar() -> impl Trait;
}
```

trait 측에서는 `impl Trait`가 **synthetic associated type**으로 lowering되어 `Ty::new_projection_from_args`가 됩니다. impl 측에서는 `collect_return_position_impl_trait_in_trait_tys` 쿼리가 hidden type을 수집합니다.

- `compiler/rustc_hir_analysis/src/collect/type_of.rs:28`
- `compiler/rustc_hir_analysis/src/check/compare_impl_item.rs:457`

### 10.4 `impl Trait` in bindings

```rust
let x: impl Trait = value;
```

`hir::TyKind::TraitAscription`으로 lowering되며, `hir_ty_lowering/mod.rs:3238`에서 추론 변수 + 바운드 집합으로 처리됩니다. 이 바운드는 `trait_ascriptions` 맵에 저장되어 borrowck에서도 검사됩니다.

### 10.5 `async fn` / `gen fn`

`async fn foo() -> T`는 반환 타입을 `impl Future<Output = T>`로 desugar합니다. `lower_coroutine_fn_ret_ty`가 `OpaqueTyOrigin::AsyncFn`을 생성합니다.

```rust
// compiler/rustc_ast_lowering/src/lib.rs:2057
fn lower_coroutine_fn_ret_ty(...) -> hir::FnRetTy<'hir> {
    let opaque_ty_ref = self.lower_opaque_inner(
        opaque_ty_node_id,
        hir::OpaqueTyOrigin::AsyncFn { parent: fn_def_id, in_trait_or_impl },
        // ...
    );
}
```

---

## 11. 테스트

`impl Trait` 관련 UI 테스트는 `tests/ui/impl-trait/` 아래에 모여 있습니다.

- `tests/ui/impl-trait/in-trait/`
- `tests/ui/impl-trait/opaque_type_bounds/`
- `tests/ui/impl-trait/alias/`
- `tests/ui/impl-trait/impl_trait_in_bindings/`

---

## 12. 핵심 파일 요약

| 단계 | 주요 파일 | 역할 |
|------|-----------|------|
| 파싱 | `compiler/rustc_parse/src/parser/ty.rs` | `parse_impl_ty` |
| AST | `compiler/rustc_ast/src/ast.rs` | `TyKind::ImplTrait` |
| lowering | `compiler/rustc_ast_lowering/src/lib.rs` | `ImplTraitContext`, `lower_opaque_impl_trait` |
| lowering | `compiler/rustc_ast_lowering/src/item.rs` | APIT 제네릭 삽입 |
| HIR | `compiler/rustc_hir/src/hir.rs` | `TyKind::OpaqueDef`, `TraitAscription` |
| 타입 lowering | `compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs` | `lower_opaque_ty` |
| 제네릭 수집 | `compiler/rustc_hir_analysis/src/collect/generics_of.rs` | opaque 제네릭 구성 |
| lifetime 캡처 | `compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs` | `opaque_captured_lifetimes` |
| 바운드 수집 | `compiler/rustc_hir_analysis/src/collect/item_bounds.rs` | `opaque_type_bounds` |
| hidden type | `compiler/rustc_hir_analysis/src/collect/type_of.rs` | `type_of_opaque`, `type_of_opaque_hir_typeck` |
| hidden type | `compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs` | `find_opaque_ty_constraints_for_rpit` |
| 타입 검사 | `compiler/rustc_hir_typeck/src/lib.rs` | `typeck` 본문 검사 |
| 타입 검사 | `compiler/rustc_hir_typeck/src/typeck_root_ctxt.rs` | `TypingMode::typeck_for_body` |
| 타입 검사 | `compiler/rustc_hir_typeck/src/opaque_types.rs` | defining use 처리 |
| 타입 검사 | `compiler/rustc_hir_typeck/src/writeback.rs` | hidden type 저장 |
| defining use 검사 | `compiler/rustc_trait_selection/src/opaque_types.rs` | `opaque_type_has_defining_use_args` |
| auto trait | `compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs` | `AutoImplCandidate` |
| auto trait | `compiler/rustc_trait_selection/src/traits/select/mod.rs` | hidden type로 구성 요소 검사 |
| 정의 범위 | `compiler/rustc_infer/src/infer/mod.rs` | `can_define_opaque_ty` |
| opaque 수집 | `compiler/rustc_ty_utils/src/opaque_types.rs` | `opaque_types_defined_by` |

---

## 13. 참고 자료

- RFC 1522 – *Conservative impl Trait* (return position)
- RFC 1951 – *Universal impl Trait* (argument position)
- RFC 2071 – *Type alias impl Trait* (TAIT)
- rustc-dev-guide: “Opaque Types & Region Inference”
- rust-lang/rust PR #35091 – `impl Trait` 최초 구현 병합 커밋 (`f55ac6944a8`)
