---
title: "测试文章：验证博客与评论系统"
date: 2026-11-09T16:46:19+08:00
draft: false
tags: ["测试"]
categories: ["随笔"]
series: []
ShowToc: true
---

这是一篇用于验证博客各项功能的测试文章，验证完成后可随时删除。

## 验证清单

- [x] 中文显示
- [x] Markdown 渲染
- [x] 代码高亮
- [x] 目录（TOC）
- [ ] Giscus 评论（在下方留言测试）

## 代码高亮

```python
def hello(name: str) -> None:
    print(f"Hello, {name}!")

hello("Blog")
```

## 表格

| 功能 | 状态 |
|------|------|
| Hugo 构建 | ✅ |
| Pages 部署 | ✅ |
| Giscus 评论 | 待验证 |

---

欢迎在下方评论区留言，验证 Giscus 是否正常工作。
