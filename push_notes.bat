@echo off
cd /d E:\dataStore\node

REM 设置提交时间
set now=%date% %time%

REM 添加并提交所有变更
git add .
git commit -m "auto backup %now%"

REM 推送到 GitHub
git push origin main
