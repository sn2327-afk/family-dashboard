# 우리가족 대시보드

가족용 체크리스트 대시보드입니다. `index.html` 파일 하나로 동작하고, 인터넷이 없어도 열립니다.

- 주소: https://sn2327-afk.github.io/family-dashboard/
- 화면: 오늘의 루틴 · 도마뱀 밥 주기 · 은우/다윤 루틴 · 용돈 통장 · 가족 랜덤 미션 · 공부 타이머 · 우리집 한줄 톡 · 주말 수업 횟수 · 장보기/가족 메모 · 오늘의 저녁 메뉴

## 실시간 동기화

- 엄마·아빠·은우·다윤 폰이 같은 기록을 함께 봅니다. 한 기기에서 체크하면 다른 기기에 몇 초 안에 나타납니다.
- 저장소: Firebase Realtime Database (`rooms/saenam-family-2026/state`)
  - 읽기/쓰기: REST `GET`/`PUT` + `EventSource`(SSE) 실시간 스트림
  - 스트림이 끊기면 4초마다, 붙어 있으면 20초마다 안전망 확인
- 화면 위쪽 뱃지: `☁️ 실시간 공유 중` / `🔄 저장 중…` / `⚠️ 오프라인` (눌러서 새로고침)
- 인터넷이 끊겨도 이 기기(localStorage)에는 저장되고, 다시 연결되면 자동으로 맞춰집니다.
- 기기별로 따로 두는 값: 공부 타이머, 보고 있는 탭, 한줄 톡에 쓸 내 이름
- 처음 접속할 때 서버에 기록이 있으면 서버 기록을 쓰고, 서버가 완전히 비어 있을 때만 이 기기 기록을 올립니다.

## 배포

```bash
bash tmp/deploy_sync.sh   # 빌드 → index.html(robots noindex) → git push
```

- 빌드 원본: `tmp/template.html`(화면) + `tmp/app.js`(동작) → `python3 tmp/build.py 우리가족_대시보드.html`
- 검증: `python3 tmp/sync_e2e.py [URL]` (두 기기 실시간 동기화 E2E), `python3 tmp/sync_offline.py` (오프라인 복귀)
- 초기 상태로 되돌리기: `python3 tmp/reset_and_shot.py`
