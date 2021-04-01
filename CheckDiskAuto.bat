set DEFAULT=/F /R /X
set F=%DEFAULT%
set D=c

echo Attempting to execute. Text file will be created on reboot. Make sure to login as the same user!
echo $UserDesktop = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop").Desktop; get-winevent -FilterHashTable @{logname="Application"; id="1001"}^| ?{$_.providername -match "wininit"} ^| fl timecreated, message; get-winevent -FilterHashTable @{logname="Application"; id="1001"}^| ?{$_.providername -match "wininit"} ^| fl timecreated, message ^| out-file "$UserDesktop\CHKDSKResults.txt" > "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\powershellresults.ps1"


<nul set/p "STRING= cd "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\" & PowerShell.exe -ExecutionPolicy Bypass -File .\powershellresults.ps1 & start /b "" cmd /c del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\invoke.bat" & cmd /c del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\powershellresults.ps1" &exit /b " > "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\invoke.bat"


echo y | CHKDSK %D%: %F%



pause
