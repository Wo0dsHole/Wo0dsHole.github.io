# Blog 搭建与使用指南

Hugo + PaperMod + GitHub Pages + Giscus 个人博客，支持 **U盘便携** 和 **Codespaces** 两种工作流。

> **当前进度（2026-11-09）**：第 1、2、4、5 步已完成 —— 博客已上线：https://Wo0dsHole.github.io/ ，Giscus 评论已配置，已有测试文章、关于页和按分类生成的目录页。第 3 步为配置说明；第 6-8 步（大附件 Release、Codespaces、U盘便携）可选，随时可补。

---

## 目录

- [前置准备](#前置准备)
- [第 1 步：创建 GitHub 仓库](#第-1-步创建-github-仓库)
- [第 2 步：本地初始化（git + 主题 + 配置）](#第-2-步本地初始化git--主题--配置)
- [第 3 步：配置文件说明](#第-3-步配置文件说明)
- [第 4 步：配置 Giscus 评论](#第-4-步配置-giscus-评论)
- [第 5 步：启用 GitHub Pages 部署](#第-5-步启用-github-pages-部署)
- [第 6 步：创建大附件 Release](#第-6-步创建大附件-release)
- [第 7 步：配置 Codespaces（可选）](#第-7-步配置-codespaces可选)
- [第 8 步：配置 U盘便携环境（可选）](#第-8-步配置-u盘便携环境可选)
- [日常使用](#日常使用)
- [环境同步策略](#环境同步策略)
- [常见问题](#常见问题)

---

## 前置准备

| 工具 | 用途 | 安装 |
|------|------|------|
| **Hugo Extended** | 博客生成器（PaperMod 需要 Extended 版） | `winget install Hugo.Hugo.Extended` 或 [手动下载](https://github.com/gohugoio/hugo/releases) |
| **Git** | 版本控制 | `winget install Git.Git` |
| **GitHub CLI** (`gh`) | 登录与上传大附件 | `winget install GitHub.cli` |

验证：

```bash
hugo version    # 应显示 v0.xxx+extended
git --version
gh --version
```

另外需要 **GitHub 账号**（用于托管代码、评论、部署）。

---

## 第 1 步：创建 GitHub 仓库

1. 打开 https://github.com/new
2. 仓库名：`Wo0dsHole.github.io`（用户站点，地址为根路径 `https://Wo0dsHole.github.io/`；若用其他名字如 `Blog`，地址会变成 `https://Wo0dsHole.github.io/Blog/`）
3. **必须选 Public**（Giscus 评论系统要求公开仓库）
4. 不要勾选 "Add a README file"（本目录已有）
5. 创建后，进入 **Settings → Features**，勾选 **Discussions**（Giscus 依赖）

✅ **已完成**，仓库地址：

```
https://github.com/Wo0dsHole/Wo0dsHole.github.io.git
```

---

## 第 2 步：本地初始化（git + 主题 + 配置）

> ✅ 已完成（2026-11-09）：git 仓库、PaperMod submodule、配置和首次提交均已就绪。

本目录已经是初始化好的 Hugo 站点，直接做以下操作（在本目录 `D:\ai\Blog` 下）：

### 2.1 初始化 git 并引入 PaperMod 主题

```bash
git init
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

> 主题以 submodule 方式引入，部署、Codespaces、U盘三处环境靠它保持同步。

### 2.2 填写 hugo.toml 占位符

✅ 本目录的 `hugo.toml` 已填入仓库信息，无需再改：
- `baseURL = 'https://Wo0dsHole.github.io/'`
- `[params.giscus] repo = 'Wo0dsHole/Wo0dsHole.github.io'`

`repoId`、`categoryId` 也已填入，见第 4 步。

> **baseURL 规则**：仓库名是 `<用户名>.github.io` 时，`baseURL = 'https://<用户名>.github.io/'`；其他仓库名（如 `Blog`）则 `baseURL = 'https://<用户名>.github.io/Blog/'`。

### 2.3 配置 Git 身份并首次提交

```bash
git config user.name "你的名字"
git config user.email "你的邮箱"
git add .
git commit -m "初始化博客"
git branch -M main
git remote add origin https://github.com/Wo0dsHole/Wo0dsHole.github.io.git
git push -u origin main
```

> `git add .` 会连同 submodule 记录一起提交，GitHub Actions 部署时需要它。

### 2.4 验证本地预览

```bash
hugo server -D --bind 0.0.0.0
# 浏览器打开 http://localhost:1313
```

---

## 第 3 步：配置文件说明

| 文件 | 作用 |
|------|------|
| `hugo.toml` | 主配置：站点信息、PaperMod 参数、导航菜单、Giscus、代码高亮 |
| `layouts/_partials/comments.html` | Giscus 评论模板，PaperMod 自动加载 |
| `content/search.md` / `archives.md` | 搜索页 / 归档页（PaperMod 内置） |
| `archetypes/default.md` | 新文章模板（`hugo new` 时自动套用） |
| `assets/css/extended.css` | 自定义 CSS（PaperMod 自动加载） |
| `content/about.md` | 关于页 |
| `content/directory.md` + `layouts/directory.html` | 按分类自动生成的文章目录页 |
| `.github/workflows/hugo-deploy.yml` | GitHub Actions：push 后自动构建部署 |
| `.devcontainer/devcontainer.json` | Codespaces 零配置环境 |
| `.gitignore` | 忽略 `public/`、`tools/` 等 |
| `portable.bat` | U盘便携一键启动脚本 |

---

## 第 4 步：配置 Giscus 评论

> ✅ 已完成（2026-11-09）：`repo`、`repoId`（`R_kgDOVn4JrQ`）、`categoryId`（`DIC_kwDOVn4Jrc4DKtgh`）均已填入，Giscus 应用已安装。

Giscus 用 GitHub Discussions 存储评论，免费、无广告。

1. 打开 https://github.com/apps/giscus → **Install** → 选择博客仓库
2. 打开 https://giscus.app/zh-CN
3. "仓库" 填入 `Wo0dsHole/Wo0dsHole.github.io`，页面自动验证并生成配置代码，形如：

```html
<script src="https://giscus.app/client.js"
    data-repo="Wo0dsHole/Wo0dsHole.github.io"
    data-repo-id="R_kgDOxxxxxx"
    data-category="Announcements"
    data-category-id="DIC_kwDOxxxxxx" ...>
</script>
```

4. 把 `data-repo-id`、`data-category-id`（以及确认 `repo`）填回 `hugo.toml` 的 `[params.giscus]`

验证：`hugo server -D --bind 0.0.0.0`，打开任意文章，底部应出现评论区（草稿文章默认不显示，需 `draft: false`）。

---

## 第 5 步：启用 GitHub Pages 部署

> ✅ 已完成：Pages 已设为 GitHub Actions，首次部署成功，博客已上线。

1. 打开仓库 **Settings → Pages**，**Source** 选择 **GitHub Actions**
2. Push 代码后，**Actions** 标签页应看到 `Deploy Hugo to Pages` 运行
3. 完成后博客地址：`https://Wo0dsHole.github.io/`

> 首次部署约 1-2 分钟，之后每次 push 自动触发。

---

## 第 6 步：创建大附件 Release

博客中的大文件（100MB ~ 2GB）不提交到 Git，上传到 GitHub Releases 作为永久外链。

```bash
git tag assets-v1
git push origin assets-v1
```

然后到仓库 **Releases** 页面 → **Create a new release** → Tag 选 `assets-v1`，标题写 `📦 Blog Assets`，发布。

之后上传附件：

```bash
gh auth login   # 首次使用需登录
gh release upload assets-v1 你的大文件.zip

# 公开 URL：https://github.com/Wo0dsHole/Wo0dsHole.github.io/releases/download/assets-v1/你的大文件.zip
```

更新同名附件时先删后传：

```bash
gh release delete-asset assets-v1 你的大文件.zip
gh release upload assets-v1 新版本.zip
```

---

## 第 7 步：配置 Codespaces（可选）

任何有浏览器的设备都能写博客，无需安装工具。

1. 打开仓库页面，按键盘 **`.`** 键（或 **Code → Codespaces → Create codespace on main**）
2. 等待 1-2 分钟自动配置完成（`.devcontainer/devcontainer.json` 会自动装 Hugo Extended、拉 submodule、转发 1313 端口）
3. 终端运行 `hugo server -D --bind 0.0.0.0`，浏览器自动打开预览
4. 首次使用先配置身份并登录：`git config --global user.name "..."` / `user.email "..."` / `gh auth login`

---

## 第 8 步：配置 U盘便携环境（可选）

### 目录结构

```
U:\
├── Blog\                ← 从 GitHub clone 的仓库
├── tools\
│   ├── hugo.exe         ← Hugo Extended 单文件
│   ├── gh.exe           ← GitHub CLI 单文件
│   └── PortableGit\     ← PortableGit 解压目录
└── portable.bat         ← 一键启动脚本
```

### 准备

1. 下载 `hugo_extended_*_windows-amd64.zip` 解压出 `hugo.exe` → `U:\tools\`
2. 下载 `PortableGit-*-64-bit.7z.exe` 自解压到 `U:\tools\PortableGit\`
3. 下载 `gh_*_windows_amd64.zip` 解压出 `gh.exe` → `U:\tools\`
4. 从 GitHub clone 仓库到 `U:\Blog`

### 使用

双击 `portable.bat`，自动完成：设置便携工具 PATH → 首次自动建 git 身份/登录（`git config`、`gh auth login`）→ `git pull` → 启动预览并打开浏览器。`Ctrl+C` 停止后 `git push` 提交。

> PortableGit 的 HOME 指向 `U:\tools\PortableGit\home`，身份配置不留在所用电脑上。

---

## 日常使用

```bash
# 开始写作前（先同步）
git pull --rebase && git submodule update --init --recursive

# 创建新文章（在 content/posts/ 下生成同名目录）
hugo new posts/2026-08-04-文章标题/index.md

# 本地预览（草稿需 -D）
hugo server -D --bind 0.0.0.0
```

文章目录结构（Page Bundle）：

```
content/posts/2026-08-04-文章标题/
├── index.md           ← 正文
└── 配图.png            ← 图片放同一目录
```

```markdown
---
title: "文章标题"
date: 2026-08-04T12:00:00+08:00
draft: true            # 发布时改为 false
tags: ["标签1"]
categories: ["分类名"]
series: ["系列名"]       # 可选
ShowToc: true
---

![配图说明](配图.png)
```

**发布**：`draft: false` → `git add . && git commit -m "新文章: xxx" && git push` → 等 1-2 分钟自动部署。

**插入大附件**：先 `gh release upload assets-v1 文件.zip`，再在文章里放链接：

```markdown
[📥 下载](https://github.com/Wo0dsHole/Wo0dsHole.github.io/releases/download/assets-v1/文件.zip)
```

**更新 PaperMod 主题**：`git submodule update --remote themes/PaperMod`，提交并推送。

### 添加自定义页面

在 `content/` 下新建 Markdown 文件即可，例如 `content/about.md` 会生成 `/about/`。导航菜单在 `hugo.toml` 的 `[[menu.main]]` 中配置，`weight` 控制顺序。

需要特殊排版时，在页面 front matter 指定 `layout`，并在 `layouts/` 下创建同名模板。本站的目录页就是这样实现的：

- `content/directory.md` → `layout: "directory"`
- `layouts/directory.html` → 按文章分类自动生成目录

页面常用 front matter 开关：`comments: false`（关评论）、`searchHidden: true`（不进搜索）、`hideMeta: true`（隐藏日期等信息）、`ShowToc: false`（关目录）。

---

## 环境同步策略

```
离开环境前:  git push    ← 成果推送到 GitHub
到达环境后:  git pull    ← 拉取最新
```

⚠️ **铁律：永远不要在两个环境同时编辑**。大附件在 GitHub Releases 上，URL 公开，两个环境引用相同链接，无需同步。

---

## 常见问题

**`hugo server` 看不到文章？** 草稿需要 `-D` 参数：`hugo server -D`。

**搜索框是灰色/搜不到内容？** PaperMod 搜索依赖首页生成的 `index.json`，确认 `hugo.toml` 中包含：

```toml
[outputs]
  home = ['HTML', 'RSS', 'JSON']
```

**Giscus 不显示？** 检查：仓库是 Public；Discussions 已启用；`repoId`/`categoryId` 正确；文章不是草稿。

**`gh release upload` 报 "release not found"？** 还没创建 `assets-v1` 的 Release（第 6 步）。

**Pages 部署失败？** 到 Actions 标签页看日志；常见原因：`baseURL` 格式错误、submodule 未提交。

**portable.bat 启动失败？** 检查 `tools\` 下有无 `hugo.exe`、`gh.exe`、`PortableGit\`，以及 `Blog\` 目录。

**图片太大？** < 100MB 直接放 Page Bundle；100MB~2GB 传 Releases 放链接；> 2GB 用 7-Zip 分卷后传 Releases。
