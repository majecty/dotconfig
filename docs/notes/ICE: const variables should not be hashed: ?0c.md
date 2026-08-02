# ICE: const variables should not be hashed: ?0c


https://github.com/rust-lang/rust/issues/122214


```rust
#![feature(impl_trait_in_assoc_type, const_precise_live_drops)]

trait Trait {
    type Opaque1;
}

impl<const B: Word> Trait for &'a () {
    type Opaque1 = impl Sized;

    fn constrain(self) -> (Self::Opaque1,) {}
}
```
