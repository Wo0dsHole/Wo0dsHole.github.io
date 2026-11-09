@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: Blog Portable — U盘便携一键启动脚本
:: 放在 U盘根目录，双击即可启动 Hugo 预览
:: ============================================================

:: 获取脚本所在目录（U盘根目录）
set "U_ROOT=%~dp0"
set "U_ROOT=%U_ROOT:~0,-1%"

:: 设置便携工具 PATH
set "PATH=%U_ROOT%\tools;%U_ROOT%\tools\PortableGit\bin;%U_ROOT%\tools\PortableGit\cmd;%U_ROOT%\tools\PortableGit\usr\bin;%PATH%"

:: 设置 PortableGit 的 HOME（避免与系统 Git 冲突）
set "HOME=%U_ROOT%\tools\PortableGit\home"
if not exist "%HOME%" mkdir "%HOME%"

:: 进入博客仓库
if not exist "%U_ROOT%\Blog" (
    echo [错误] 找不到 Blog 目录，请确保目录结构为:
    echo   %U_ROOT%\Blog\
    echo   %U_ROOT%\tools\
    echo   %U_ROOT%\portable.bat
    pause
    exit /b 1
)
cd /d "%U_ROOT%\Blog"

:: ============================================================
:: 检查便携工具
:: ============================================================
if not exist "%U_ROOT%\tools\hugo.exe" (
    echo [警告] 未找到 Hugo 便携版 (%U_ROOT%\tools\hugo.exe)
    echo   请从 https://github.com/gohugoio/hugo/releases 下载
    echo   文件: hugo_extended_*_windows-amd64.zip
    echo   解压出 hugo.exe 放入 tools\ 目录
    pause
    exit /b 1
)

:: ============================================================
:: 拉取最新内容
:: ============================================================
echo.
echo    拉取最新内容...
echo.
git pull --rebase 2>&1
if errorlevel 1 (
    echo [警告] git pull 失败，可能有未提交的更改
    echo 继续使用本地版本...
)
git submodule update --init --recursive 2>&1

:: ============================================================
:: 启动 Hugo
:: ============================================================
echo.
echo    启动预览服务器...
echo    http://localhost:1313
echo    按 Ctrl+C 停止
echo.

:: 尝试打开浏览器
start "" http://localhost:1313 2>nul

hugo server -D --bind 0.0.0.0

pause
