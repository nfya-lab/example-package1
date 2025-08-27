@echo off
setlocal EnableDelayedExpansion
echo ================================
echo VRChat Package Release Tool
echo ================================
echo.

REM Get current version
for /f "tokens=2 delims=:" %%a in ('findstr /r "\"version\":" package.json') do (
    set current_version=%%a
)
set current_version=!current_version: =!
set current_version=!current_version:"=!
set current_version=!current_version:,=!

echo Current version: !current_version!
echo.

REM Parse version format (major.minor.patch)
for /f "tokens=1,2,3 delims=." %%a in ("!current_version!") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

REM Version increment options
echo Version increment options:
echo 1. Patch (e.g., !current_version! -^> !major!.!minor!.!patch!+1)
echo 2. Minor (e.g., !current_version! -^> !major!.!minor!+1.0)
echo 3. Major (e.g., !current_version! -^> !major!+1.0.0)
echo 4. Custom version
echo.
set /p version_type="Select version type (1-4): "

if "!version_type!"=="1" (
    set /a new_patch=!patch!+1
    set new_version=!major!.!minor!.!new_patch!
) else if "!version_type!"=="2" (
    set /a new_minor=!minor!+1
    set new_version=!major!.!new_minor!.0
) else if "!version_type!"=="3" (
    set /a new_major=!major!+1
    set new_version=!new_major!.0.0
) else if "!version_type!"=="4" (
    set /p new_version="Enter custom version (e.g., 1.0.4): "
    if "!new_version!"=="" (
        echo Error: Version cannot be empty
        pause
        exit /b 1
    )
) else (
    echo Error: Invalid selection
    pause
    exit /b 1
)

REM Release notes input
set /p release_notes="Enter release notes (optional): "
if "!release_notes!"=="" (
    set release_notes=Version !new_version!
)

echo.
echo ================================
echo Release Summary
echo ================================
echo Package: Example Package 1
echo From: !current_version!
echo To: !new_version!
echo Notes: !release_notes!
echo.
set /p confirm="Proceed with release? (y/N): "
if /i not "!confirm!"=="y" (
    echo Release cancelled.
    pause
    exit /b 0
)

echo.
echo Starting release process...

REM Update package.json version
echo Updating package.json...
powershell -Command "(Get-Content package.json) -replace '\"version\": \"!current_version!\"', '\"version\": \"!new_version!\"' | Set-Content package.json"

REM Update CHANGELOG.md
echo Updating CHANGELOG.md...
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set current_date=%%c-%%a-%%b
)

REM Add new entry to CHANGELOG
powershell -Command "$content = Get-Content CHANGELOG.md; $newEntry = @('', '## [!new_version!] - !current_date!', '', '### Changed', '- !release_notes!'); $content = $content[0..2] + $newEntry + $content[3..$content.Length]; $content | Set-Content CHANGELOG.md"

REM Git commit
echo Committing changes...
git add package.json CHANGELOG.md
git commit -m "Release !new_version! - !release_notes!"

if !errorlevel! neq 0 (
    echo Error: Failed to commit changes
    pause
    exit /b 1
)

REM Push
echo Pushing to GitHub...
git push

if !errorlevel! neq 0 (
    echo Error: Failed to push to GitHub
    pause
    exit /b 1
)

echo.
echo ================================
echo Release Completed Successfully!
================================
echo Version !new_version! has been released
echo GitHub Actions will automatically:
echo - Create release and ZIP file
echo - Update VPM repository
echo - Deploy to GitHub Pages
echo.
echo Check the progress at:
echo https://github.com/nfya-lab/example-package1/actions
echo.
pause