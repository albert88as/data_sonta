# Launch the RDP session
Start-Process "mstsc.exe" -ArgumentList "C:\Users\SONTA\Desktop\vps_mt5.rdp"

# Wait for 10 seconds
Start-Sleep -Seconds 60

# Attempt to close the RDP session
Get-Process | Where-Object { $_.MainWindowTitle -like "*Remote Desktop Connection*" } | Stop-Process
