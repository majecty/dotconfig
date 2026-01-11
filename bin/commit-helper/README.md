# commit helper

## spec

- rust 사용.
- diff 바탕으로 커밋 메시지 생성.
- 커밋 메시지 수정 -> proofread -> 수정을 반복할 수 있음.
- 최종 컨펌받으면 커밋
- openrouter api 사용.

## Configuration

API 키는 다음 세 가지 방법 중 하나로 제공할 수 있습니다:

1. `--api-key` 명령줄 옵션
2. `OPENROUTER_API_KEY` 환경 변수
3. `~/.config/commit-helper/config.toml` 파일

### config.toml 파일 형식

```toml
api_key = "your-openrouter-api-key-here"
```