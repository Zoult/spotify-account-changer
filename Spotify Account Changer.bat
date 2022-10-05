@echo off
title Spotify Account Changer
set spotify=%appdata%\Spotify
set soggfy=full-path-to-soggfy

:menu
cls
echo [t] List
echo [s] Save
echo [r] Rename
echo [d] Delete
echo [l] Load
echo [g] Soggfy load
echo [u] Unload
echo [e] Export
echo [i] Import
set /p k=Select option: 

if not defined k goto :invalid
if "%k%"=="t" goto :list
if "%k%"=="s" call :account save
if "%k%"=="r" call :account rename
if "%k%"=="d" call :account delete
if "%k%"=="l" call :account load
if "%k%"=="g" call :account soggload
if "%k%"=="u" call :prefs unload
if "%k%"=="e" call :prefs export
if "%k%"=="i" goto :import
goto :invalid

:account
cls
set action=%~1
set /p account=Enter account name: 
if not defined account goto :invalid
if "%action%" neq "save" (
    dir /b /a-d %spotify%\Users\%account% >nul 2>&1 || (
        echo Account "%account%" does not exist!
        pause >nul
        goto :menu
    )
)
call :%action% %account%
pause >nul
goto :menu

:prefs
cls
set action=%~1
if not exist %spotify%\prefs (
    echo No account loaded!
    pause >nul
    goto :menu
)
call :%action%
pause >nul
goto :menu

:save
if not exist %spotify%\prefs (
    echo No account loaded!
    pause >nul
    goto :menu
)
if exist %spotify%\Users\%account% set /p overwrite=Account exists, overwrite? [y/n]: 
if /i "%overwrite%"=="n" goto :menu
copy %spotify%\prefs %spotify%\Users\%account% >nul 2>&1
echo Account "%account%" saved!
goto :EOF

:rename
set /p newname=Enter new name: 
if not defined newname goto :invalid
ren %spotify%\Users\%account% %newname% >nul 2>&1
echo Account renamed to "%newname%"!
goto :EOF

:delete
del /q %spotify%\Users\%account% >nul 2>&1
echo Account "%account%" deleted!
goto :EOF

:load
taskkill /f /im spotify.exe >nul 2>&1
del /q %spotify%\prefs 2>nul
copy %spotify%\Users\%account% %spotify%\prefs >nul 2>&1
echo Account "%account%" loaded!
goto :EOF

:list
cls
dir /b /a-d %spotify%\Users 2>nul || (
    echo No saved accounts found!
    pause >nul
    goto :menu
)
pause >nul
goto :menu

:soggload
cls
if "%soggfy%"=="full-path-to-soggfy" call :setSoggfyDir
taskkill /f /im spotify.exe >nul 2>&1
del /q %spotify%\prefs 2>nul
copy %spotify%\Users\%account% %soggfy%\prefs >nul 2>&1
echo Account "%account%" loaded via Soggfy!
goto :EOF

:unload
cls
taskkill /f /im spotify.exe >nul 2>&1
del /q %spotify%\prefs 2>nul
echo Account unloaded!
goto :EOF

:export
cls
set /p export=Enter export folder path: 
if not defined export goto :invalid
if not exist %export% goto :invalid
copy %spotify%\prefs %export% >nul 2>&1
echo Account exported!
goto :EOF

:import
cls
set /p import=Enter prefs file path: 
if not defined import goto :invalid
if not exist %import% goto :invalid
taskkill /f /im spotify.exe >nul 2>&1
copy %import% %spotify% >nul 2>&1
echo Account imported!
pause >nul
goto :menu

:setSoggfyDir
set /p o=Change soggfy directory? [y/n]: 
if /i "%o%"=="n" goto :menu
set /p soggfy=Path: 
if not exist %soggfy% goto :invalid
echo Path set!
goto :EOF

:invalid
cls
echo Invalid input!
pause >nul
goto :menu