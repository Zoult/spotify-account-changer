@echo off
set title=Spotify Account Changer
set spotify=%appdata%\Spotify
set soggfy=full-path-to-soggfy

set exitKey=x
set listKey=t
set saveKey=s
set renameKey=r
set deleteKey=d
set loadKey=l
set soggfy_loadKey=g
set unloadKey=u

:menu
title %title%
cls
echo [%exitKey%] Exit......................Closes Spotify Account Changer & echo [%listKey%] List......................Prints a list of all saved accounts & echo [%saveKey%] Save......................Saves an account & echo [%renameKey%] Rename....................Renames an account to a new name & echo [%deleteKey%] Delete....................Deletes an account & echo [%loadKey%] Load......................Loads an account & echo [%soggfy_loadKey%] Soggfy load...............Loads an account and opens Soggfy & echo [%unloadKey%] Unload....................Logs you out from Spotify
echo.
set /p key=Select an option: 
if not defined key goto :invalid
if %key% == %exitKey% exit
if %key% == %listKey% goto :list
if %key% == %saveKey% goto :save
if %key% == %renameKey% goto :rename
if %key% == %deleteKey% goto :delete
if %key% == %loadKey% goto :load
if %key% == %soggfy_loadKey% goto :soggfy_load
if %key% == %unloadKey% goto :unload
goto :invalid

:invalid
title %title% - Invalid option
cls
echo Choose a valid option!
goto :back

:list
title %title% - List
cls
dir /b /a-d %spotify%\Users|find /v "." >nul
if errorlevel 1 (
	echo Currently there are no saved accounts
	goto :back
)
echo Currently saved accounts [A to Z]
echo.
dir /b /a-d %spotify%\Users
goto :back

:save
title %title% - Save
cls
if not exist %spotify%\prefs (
	echo Login to Spotify first!
	goto :back
)
set /p accountname=Save account as: 
if not defined accountname goto :invalid
if not exist %spotify%\Users\%accountname% (
taskkill /f /im Spotify.exe /t >nul 2>&1
copy %spotify%\prefs %spotify%\Users\%accountname% >nul
echo.
echo Account "%accountname%" saved!
goto :back
)
echo.
set /p option=An account named as "%accountname%" already exists, would you like to overwrite? [y/n] 
if not defined option goto :invalid
if %option% == y (
	taskkill /f /im Spotify.exe /t >nul 2>&1
	copy %spotify%\prefs %spotify%\Users\%accountname% >nul
	echo.
	echo Account "%accountname%" saved!
	goto :back
)
if %option% == n goto :menu
goto :invalid

:rename
title %title% - Rename
cls
dir /b /a-d %spotify%\Users|find /v "." >nul
if errorlevel 1 (
	echo Save an account first!
	goto :back
)
set /p account=Account to rename: 
if not defined account goto :invalid
if not exist %spotify%\Users\%account% (
	echo.
	echo The account "%account%" doesn't exists!
	goto :back
)
echo.
set /p newname=New name: 
if not defined newname goto :invalid
if %account% == %newname% (
	echo.
	echo You can't rename the account to the same name!
	goto :back
)
if not exist %spotify%\Users\%newname% (
	ren %spotify%\Users\%account% %newname% >nul
	echo.
	echo Account "%account%" has been renamed to "%newname%"!
	goto :back
)
echo.
set /p option=An account named as "%newname%" already exists, would you like to overwrite? [y/n] 
if not defined option goto :invalid
if %option% == y (
	del /q %spotify%\Users\%newname% >nul
	ren %spotify%\Users\%account% %newname% >nul
	echo.
	echo Account "%account%" has been renamed to "%newname%"!
	goto :back
)
if %option% == n goto :menu
goto :invalid

:delete
title %title% - Delete
cls
dir /b /a-d %spotify%\Users|find /v "." >nul
if errorlevel 1 (
	echo Save an account first!
	goto :back
)
set /p account=Account to delete: 
if not defined account goto :invalid
if not exist %spotify%\Users\%account% (
	echo.
	echo The account "%account%" doesn't exists!
	goto :back
)
del /q %spotify%\Users\%account% >nul
echo.
echo Account "%account%" deleted!
goto :back

:load
title %title% - Load
cls
dir /b /a-d %spotify%\Users|find /v "." >nul
if errorlevel 1 (
	echo Save an account first!
	goto :back
)
set /p account=Account to load: 
if not defined account goto :invalid
if not exist %spotify%\Users\%account% (
	echo.
	echo The account "%account%" doesn't exists!
	goto :back
)
taskkill /f /im Spotify.exe /t >nul 2>&1
del /q %spotify%\prefs 2>nul
copy %spotify%\Users\%account% %spotify%\prefs >nul
start /D %spotify% Spotify.exe
echo.
echo Account "%account%" loaded!
goto :back

:soggfy_dir
set /p option=The "soggfy" value of this script hasn't been changed, would you like to change it now? [y/n] 
if not defined option goto :invalid
if %option% == y (
	echo.
	echo Ok, drag the soggfy folder to this window
	echo.
	set /p soggfy=- 
	if not defined soggfy goto :invalid
	echo.
	echo Path set, but it will work until you don't close this process!
	echo To save it, edit this file at the 4th line with your path!
	goto :back
)
if %option% == n goto :menu
goto :invalid

:soggfy_load
title %title% - Soggfy load
cls
if %soggfy% == full-path-to-soggfy goto :soggfy_dir
dir /b /a-d %spotify%\Users|find /v "." >nul
if errorlevel 1 (
	echo Save an account first!
	goto :back
) 
set /p account=Account to load: 
if not defined account goto :invalid
if not exist %spotify%\Users\%account% (
	echo.
	echo The account "%account%" doesn't exists!
	goto :back
)
taskkill /f /im Spotify.exe /t >nul 2>&1
del /q %spotify%\prefs 2>nul
copy %spotify%\Users\%account% %spotify% >nul
ren %spotify%\%account% prefs >nul
cd %soggfy%
start "" Injector.exe
echo.
echo Account "%account%" loaded!
goto :back

:unload
title %title% - Unload
cls
if not exist %spotify%\prefs (
	echo There is no loaded account!
	goto :back
)
taskkill /f /im Spotify.exe /t >nul 2>&1
del /q %spotify%\prefs 2>nul
echo Account unloaded!
goto :back

:back
echo.
echo Press any key to go back . . .
pause >nul
goto :menu