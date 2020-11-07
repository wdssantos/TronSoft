@echo off

echo Cleaning files ...

echo.

del *.~* /s/q >nul 2>&1

del *.local /s/q >nul 2>&1

del *.identcache /s/q >nul 2>&1

del *.dcu /s/q >nul 2>&1

del *.dres /s/q >nul 2>&1

del *.skincfg /s/q >nul 2>&1

del *.stat /s/q >nul 2>&1

del *.rc /s/q >nul 2>&1

del *.res /s/q >nul 2>&1

del *.exe /s/q >nul 2>&1

del *.tvsconfig /s/q >nul 2>&1



echo Removing build folders ...

echo.

for /d /r . %%d in (Library __history __recovery Debug Release Win32 Win64) do @if exist "%%d" echo "%%d" && rd /s/q "%%d"

echo Done!