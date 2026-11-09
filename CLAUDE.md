# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Hugo static blog with PaperMod theme, deployed to GitHub Pages. Supports two workflows: USB portable (Windows) and GitHub Codespaces (browser).

## Commands

```bash
# Dev server (with drafts)
hugo server -D --bind 0.0.0.0

# Build for production
hugo --minify

# New post
hugo new posts/YYYY-MM-DD-slug/index.md

# Update PaperMod theme
git submodule update --remote themes/PaperMod

# Upload large attachment (>100MB)
gh release upload assets-v1 filename.zip
```

## Architecture

- **Theme**: PaperMod via git submodule at `themes/PaperMod`
- **Deploy**: GitHub Actions (`.github/workflows/hugo-deploy.yml`) builds and deploys on push to `main`
- **Comments**: Giscus via `layouts/_partials/comments.html`, configured in `hugo.toml` → `[params.giscus]`
- **Search**: PaperMod built-in Fuse.js, requires `content/search.md`
- **Images**: Hugo page bundles — images go in the same directory as the post's `index.md`, referenced by relative filename
- **Large attachments (100MB–2GB)**: Uploaded to a permanent GitHub Release (`assets-v1` tag), linked via URL in posts
- **Codespaces**: `.devcontainer/devcontainer.json` auto-installs Hugo Extended, forwards port 1313
- **USB portable**: `portable.bat` sets PATH for portable Hugo/Git/gh, runs `git pull`, starts `hugo server`

## Key files

| File | Purpose |
|------|---------|
| `hugo.toml` | Site config, PaperMod params, Giscus settings, nav menu |
| `layouts/_partials/comments.html` | Giscus JS embed |
| `.github/workflows/hugo-deploy.yml` | Auto-deploy to GitHub Pages |
| `.devcontainer/devcontainer.json` | Codespaces zero-config env |
| `portable.bat` | USB one-click launcher |
| `archetypes/default.md` | Template for new posts |
| `assets/css/extended.css` | Custom CSS (auto-loaded by PaperMod) |
