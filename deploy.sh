#!/bin/bash
# 우리가족 대시보드 GitHub Pages 배포 스크립트
# 리포지토리(sn2327-afk/family-dashboard)가 이미 존재해야 합니다.
set -euo pipefail
cd "$(dirname "$0")"

OWNER="sn2327-afk"
REPO="family-dashboard"
URL="https://sn2327-afk.github.io/family-dashboard/"

git add -A
if ! git diff --cached --quiet; then
  git -c user.name="sn2327-afk" -c user.email="sn2327-afk@users.noreply.github.com" \
      commit -m "우리가족 대시보드 배포" >/dev/null
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$OWNER/$REPO.git"

# 원격이 비어 있으면 push -u, 이미 커밋이 있으면 merge 후 push
if git ls-remote --exit-code --heads origin main >/dev/null 2>&1; then
  git pull --rebase origin main
fi
git push -u origin main

echo "--- Pages 설정 ---"
gh api "repos/$OWNER/$REPO/pages" >/dev/null 2>&1 || \
  gh api "repos/$OWNER/$REPO/pages" -X POST -f "source[branch]=main" -f "source[path]=/" || true
gh api "repos/$OWNER/$REPO/pages" 2>&1 | head -20 || true

echo "--- 빌드 대기 ---"
for i in $(seq 1 40); do
  code=$(curl -s -o /dev/null -w '%{http_code}' -L "$URL" || true)
  echo "try $i: HTTP $code"
  if [ "$code" = "200" ]; then echo "OK $URL"; exit 0; fi
  sleep 10
done
echo "not ready yet: $URL"
exit 1
