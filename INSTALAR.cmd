@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Instalando Clinica Conecta...
node -e "if(Number(process.versions.node.split('.')[0])<24)process.exit(1)" >nul 2>&1
if errorlevel 1 (
  echo Instale o Node.js 24 LTS pelo site https://nodejs.org e execute novamente.
  pause
  exit /b 1
)
call npm ci --omit=dev --no-audit --no-fund
if errorlevel 1 (
  echo Falha na instalacao. Confira a internet e tente novamente.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\proteger.ps1"
if errorlevel 1 (
  echo Nao foi possivel proteger a pasta de dados. Confira as permissoes antes de usar.
  pause
  exit /b 1
)
echo Instalacao concluida. Abra INICIAR.cmd.
pause
