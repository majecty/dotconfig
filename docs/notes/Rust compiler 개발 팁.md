# Rust compiler 개발 팁

- https://rustc-dev-guide.rust-lang.org/building/quickstart.html
- https://rust-lang.zulipchat.com/#narrow/channel/364551-t-types.2Ftrait-system-refactor/topic/call.20for.20participation/with/613377018 여기에 기여해봄직한 내용이랑 멘토링 인스트럭션이 잘 나와있는데
- jitsi


규호의 꿀팁.

1. 레포 클론, 포크. 

subtree : 컴파일러 바꾸면 바로 영향.
submodule : 컴파일러 바꾸는 거에 영향 없음.

josh : subtree sync용 utility

rust dev guide 자주 참고.


 ./x build 자주 쓸 거임.
rust 빌드할 때는 이전 버전의 rust 사용.
바이너리를 리모트 캐시에서 가져와서 빌드. 이 러스트를 stage 0 컴파일러라고 함.

개발 환경에 섹팅하는 설정에서 linked project에 라이브러리는 빼 놓는 게 컴파일러 개별할 때 편함.
수정할 때마다 재빌드 설정은 귀찬찮을 수 있음.

./x build --keep-stage-1-std ... 요거 하면 스탠다드 라이브러리 재빌드 안하고, 컴파일러랑 러스트독만 돌릴 수 있음.


## 디버깅 꿀팁

- logging:( RUSTC_LOG=debug  


./x test 커맨드로 테스트 돌림.

## 어떤 이슈를 찾을 것인가.

- github issue label filter.
- easy: 경쟁자가 너무 많음.
- mentor 이슈도 이미 가져가있음.
- docs도 인기가 너무 많음.

needs test 괜찮음.
diagnostic 라벨 괜찮음.(에러메시지 개선)

compile 단계. lexing, parisng, ast, ast lowering,   hir, mir, oprimization, codegen,

## . 

julip 을 볼 것.

rustc dev guide

pr comment에 r? 로 달면 리뷰 담당자가 달림. 

r? compiler

아무나 만든 이슈에 대해서 작업할 필요는 없음. 유명한 사람이 만든 이슈에 대해서 작업하는 게 좋음. 

triage 팀 만만.

## rust forge

governance?? 

rustbot claim 같은 걸 해서 라벨 달거나 이슈 가져가는 거 등등 할 수 있음.

## types trait system refactor

call for participation
tcnr 아저씨 친절함.


## 질문.

고치고 나서 누구에게 요청하고 어떻게 소통하는가.

