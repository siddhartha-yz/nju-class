#!/usr/bin/env bash
set -euo pipefail

# 无论从哪个目录调用，都在脚本所属仓库操作。
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
git rev-parse --is-inside-work-tree >/dev/null
branch=$(git symbolic-ref --quiet --short HEAD) || {
  echo "当前处于 detached HEAD 状态，请先切换到分支。" >&2
  exit 1
}
git remote get-url origin >/dev/null

message="${*:-更新课程笔记：$(date '+%Y-%m-%d %H:%M:%S')}"
git add --all
if ! git diff --cached --quiet; then
  git commit -m "$message"
else
  echo "没有新的文件改动，检查并推送已有提交。"
fi

git push --set-upstream origin "$branch"
echo "推送完成：$branch"
