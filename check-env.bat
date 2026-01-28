@echo off
cls
echo ========================================
echo    🔍 Azure DevOps MCP Diagnostic Tool
echo ========================================
echo.
echo Checking your setup...
echo.

set ISSUES=0

REM Check current directory
echo 📁 Current Directory:
echo    %CD%
echo.

REM Check .env file location
echo 🔍 Checking .env file...
if exist .env (
    echo    ✅ .env file found in ROOT folder (correct location!)
    echo    📄 Location: %CD%\.env
    
    REM Check if it has content
    for %%A in (.env) do (
        if %%~zA==0 (
            echo    ⚠️  WARNING: .env file is empty!
            set /a ISSUES+=1
        ) else (
            echo    ✅ .env file has content
        )
    )
) else (
    echo    ❌ .env file NOT FOUND in root folder!
    echo    📍 It should be here: %CD%\.env
    set /a ISSUES+=1
    
    REM Check common wrong locations
    if exist src\.env (
        echo    ⚠️  Found .env in src\ folder - WRONG LOCATION!
        echo    👉 Move it to: %CD%\.env
    )
    if exist dist\.env (
        echo    ⚠️  Found .env in dist\ folder - WRONG LOCATION!
        echo    👉 Move it to: %CD%\.env
    )
)
echo.

REM Check environment variables (backup method)
echo 🔍 Checking environment variables...
if defined AZURE_DEVOPS_ORG (
    echo    ✅ AZURE_DEVOPS_ORG is set to: %AZURE_DEVOPS_ORG%
) else (
    echo    ℹ️  AZURE_DEVOPS_ORG not set (OK if using .env)
)

if defined AZURE_DEVOPS_PAT (
    echo    ✅ AZURE_DEVOPS_PAT is set (hidden for security)
) else (
    echo    ℹ️  AZURE_DEVOPS_PAT not set (OK if using .env)
)
echo.

REM Check if project is built
echo 🔍 Checking build status...
if exist dist\index.js (
    echo    ✅ Project is built (dist\index.js exists)
) else (
    echo    ❌ Project NOT built!
    echo    👉 Run: npm run build
    set /a ISSUES+=1
)
echo.

REM Check package.json
echo 🔍 Checking project files...
if exist package.json (
    echo    ✅ package.json found
) else (
    echo    ❌ package.json NOT found - wrong directory?
    set /a ISSUES+=1
)

if exist node_modules (
    echo    ✅ node_modules exists (dependencies installed)
) else (
    echo    ❌ node_modules NOT found
    echo    👉 Run: npm install
    set /a ISSUES+=1
)
echo.

REM Summary and recommendations
echo ========================================
echo 📊 DIAGNOSTIC SUMMARY
echo ========================================
echo.

if %ISSUES%==0 (
    echo ✅ Everything looks good!
    echo.
    echo Next steps:
    echo 1. Make sure VSCode is configured with the correct path
    echo 2. Restart VSCode if you haven't already
    echo 3. Test with: node test-connection.js
) else (
    echo ❌ Found %ISSUES% issue(s) that need fixing:
    echo.
    
    if not exist .env (
        echo 🔧 FIX #1: Create .env file
        echo    Option A: Run setup.bat
        echo    Option B: Create .env manually in: %CD%
        echo    With content:
        echo      AZURE_DEVOPS_ORG=your-org-name
        echo      AZURE_DEVOPS_PAT=your-token
        echo.
    )
    
    if not exist dist\index.js (
        echo 🔧 FIX #2: Build the project
        echo    Run: npm run build
        echo.
    )
    
    if not exist node_modules (
        echo 🔧 FIX #3: Install dependencies
        echo    Run: npm install
        echo.
    )
)

echo ========================================
echo 💡 Quick Commands:
echo    setup.bat         - Create .env file
echo    install.bat       - Install and build
echo    test-connection   - Test Azure DevOps connection
echo ========================================
echo.
pause 