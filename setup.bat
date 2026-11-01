@echo off
REM ============================================================================
REM  Chhoti Don — first-time setup for a fresh clone (Windows)
REM
REM  What this does:
REM    1. Installs Python dependencies (requirements.txt)
REM    2. Builds the React dashboard (chhoti-don-react/dist) so app.py can serve it
REM    3. Installs the Playwright Chromium browser for the browser agent
REM    4. Pulls the local Ollama models (skipped with a note if Ollama is absent)
REM
REM  Optional (voice mode), run separately:
REM    python -m pip install -r requirements-voice.txt
REM    python -m voice.download_voice
REM
REM  No admin rights, no secrets, nothing is uploaded anywhere.
REM ============================================================================
setlocal

echo.
echo  [1/4] Checking Python...
where python >nul 2>&1
if errorlevel 1 (
    echo  ERROR: 'python' was not found on PATH. Install Python 3.11+ and re-run setup.bat.
    exit /b 1
)
python --version

echo.
echo  [2/4] Installing Python dependencies...
python -m pip install -r requirements.txt
if errorlevel 1 (
    echo  ERROR: pip install failed. Fix the error above and re-run setup.bat.
    exit /b 1
)

echo.
echo  [3/4] Building the React dashboard...
where npm >nul 2>&1
if errorlevel 1 (
    echo  WARNING: 'npm' was not found. Install Node.js 18+ and re-run setup.bat
    echo           to build the dashboard. The CLI (python main.py) still works
    echo           without it.
) else (
    pushd chhoti-don-react
    call npm install
    if errorlevel 1 (
        echo  ERROR: npm install failed.
        popd
        exit /b 1
    )
    call npm run build
    if errorlevel 1 (
        echo  ERROR: npm run build failed.
        popd
        exit /b 1
    )
    popd
    echo  Dashboard built: chhoti-don-react\dist
)

echo.
echo  [4/4] Installing Playwright Chromium (browser agent)...
python -m playwright install chromium
if errorlevel 1 (
    echo  WARNING: Playwright browser install failed. Browser features will not
    echo           work until you run: python -m playwright install chromium
)

echo.
echo  Ollama models...
where ollama >nul 2>&1
if errorlevel 1 (
    echo  WARNING: 'ollama' was not found. Install Ollama from https://ollama.com
    echo           and then pull the models:
    echo             ollama pull qwen3.5:latest
    echo             ollama pull deepseek-coder-v2:16b-lite-instruct-q4_K_M
    echo             ollama pull llava:latest
    echo             ollama pull nomic-embed-text
) else (
    ollama pull qwen3.5:latest
    ollama pull deepseek-coder-v2:16b-lite-instruct-q4_K_M
    ollama pull llava:latest
    ollama pull nomic-embed-text
)

echo.
echo  Setup done.
echo    Web UI : python app.py   (then open http://localhost:8000)
echo    CLI    : python main.py
echo    Tests  : python -m pytest tests/ -q
endlocal
