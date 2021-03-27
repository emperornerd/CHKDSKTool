$UserDesktop = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop").Desktop

get-winevent -FilterHashTable @{logname="Application"; id="1001"}| ?{$_.providername -match "wininit"} | fl timecreated, message

get-winevent -FilterHashTable @{logname="Application"; id="1001"}| ?{$_.providername -match "wininit"} | fl timecreated, message | out-file "$UserDesktop\CHKDSKResults.txt"