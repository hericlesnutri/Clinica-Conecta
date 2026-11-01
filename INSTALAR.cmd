@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Instalando Clinica Conecta...
if not exist "%~dp0src\server.mjs" goto :incompleto
if not exist "%~dp0src\core.mjs" goto :incompleto
if not exist "%~dp0public\index.html" goto :incompleto
if not exist "%~dp0windows\proteger.ps1" goto :incompleto
goto :instalar

:incompleto
echo ERRO: Este pacote historico esta incompleto e nao pode ser instalado.
echo Para a integracao atual, use a pasta conecta-windows do repositorio ZoeConnect.
echo Manual: https://github.com/hericlesnutri/CRM-Clinica-Girlane-Ferreira
pause
exit /b 1

:instalar
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
