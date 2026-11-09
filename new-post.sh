#!/usr/bin/env bash
# ============================================================
# 生成 Hugo Page Bundle 文章框架
#
# 用法:
#   ./new-post.sh "文章标题" [slug] [输出目录]
#
# 示例:
#   ./new-post.sh "我的第一篇文章" my-first-post
#   ./new-post.sh "关于 Hugo 的笔记" hugo-notes content/posts
#
# 默认生成到 drafts/YYYY-MM-DD-slug/index.md，写好后把整个
# 文件夹移到 content/posts/ 即可。drafts/ 已在 .gitignore 中。
# ============================================================

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 1 ]; then
  echo "用法: $0 \"文章标题\" [slug] [输出目录]"
  echo "示例: $0 \"我的第一篇文章\" my-first-post"
  echo "      $0 \"文章标题\" my-post content/posts   # 直接生成到文章目录"
  exit 1
fi

TITLE="$1"
SLUG="${2:-}"
OUT_DIR="${3:-drafts}"

# 未提供 slug 时用时间生成，避免中文路径
if [ -z "$SLUG" ]; then
  SLUG="post-$(date +%H%M%S)"
fi

# 清理 slug 中的空格和路径分隔符
SLUG="${SLUG// /-}"
SLUG="${SLUG//\//-}"
SLUG="${SLUG//\\/-}"

DATE="$(date +%Y-%m-%d)"
STAMP="$(date +%Y-%m-%dT%H:%M:%S%:z)"
DEST="$ROOT/$OUT_DIR/$DATE-$SLUG"

IN_POSTS=0
case "$DEST" in
  "$ROOT/content/posts/"*) IN_POSTS=1 ;;
esac

if [ -e "$DEST" ]; then
  echo "错误：目录已存在：$DEST"
  exit 1
fi

mkdir -p "$DEST"

# 转义反斜杠和双引号，避免破坏 YAML
TITLE_ESC="${TITLE//\\/\\\\}"
TITLE_ESC="${TITLE_ESC//\"/\\\"}"

cat > "$DEST/index.md" <<EOF
---
title: "$TITLE_ESC"
date: $STAMP
draft: true
tags: []
categories: []
series: []
ShowToc: true
---

在这里写正文。

<!--
图片和小于 100MB 的附件直接放在本文件夹内，用文件名引用：
![图片说明](图片.png)

大于 100MB 的文件请上传 GitHub Releases 后放链接。
-->
EOF

echo "✅ 已生成文章框架："
echo "   $DEST/index.md"
echo
echo "接下来："
echo "  1. 编辑 index.md，图片放进同一个文件夹"
if [ "$IN_POSTS" -eq 1 ]; then
  echo "  2. 发布时把 front matter 里的 draft: true 改成 false"
  echo "  3. 提交发布："
else
  echo "  2. 写完后移到文章目录："
  echo "     mv \"$DEST\" \"$ROOT/content/posts/\""
  echo "  3. 把 front matter 里的 draft: true 改成 false"
  echo "  4. 提交发布："
fi
echo "     cd \"$ROOT\" && git add -A && git commit -m \"新文章: $TITLE\" && git push"
