@echo off
echo Necessario ter a permissao "Gerenciador de Segurança de SQL" ou "SQL Security Manager" no SQL Azure Server que deseja se conectar.
pause
echo # Get the ID and security principal of the current user account > %temp%\AddSQLAzureFirewallRule.ps1
echo $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent() >> %temp%\AddSQLAzureFirewallRule.ps1
echo $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID) >> %temp%\AddSQLAzureFirewallRule.ps1
echo # Get the security principal for the Administrator role >> %temp%\AddSQLAzureFirewallRule.ps1
echo $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator >> %temp%\AddSQLAzureFirewallRule.ps1
echo # Check to see if we are currently running "as Administrator" >> %temp%\AddSQLAzureFirewallRule.ps1
echo if ($myWindowsPrincipal.IsInRole($adminRole)) >> %temp%\AddSQLAzureFirewallRule.ps1
echo    { >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # We are running "as Administrator" - so change the title and background color to indicate this >> %temp%\AddSQLAzureFirewallRule.ps1
echo    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)" >> %temp%\AddSQLAzureFirewallRule.ps1
echo    $Host.UI.RawUI.BackgroundColor = "DarkBlue" >> %temp%\AddSQLAzureFirewallRule.ps1
echo    clear-host >> %temp%\AddSQLAzureFirewallRule.ps1
echo    } >> %temp%\AddSQLAzureFirewallRule.ps1
echo else >> %temp%\AddSQLAzureFirewallRule.ps1
echo    { >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # We are not running "as Administrator" - so relaunch as administrator >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # Create a new process object that starts PowerShell >> %temp%\AddSQLAzureFirewallRule.ps1
echo    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"; >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # Specify the current script path and name as a parameter >> %temp%\AddSQLAzureFirewallRule.ps1
echo    $newProcess.Arguments = $myInvocation.MyCommand.Definition; >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # Indicate that the process should be elevated >> %temp%\AddSQLAzureFirewallRule.ps1
echo    $newProcess.Verb = "runas"; >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # Start the new process >> %temp%\AddSQLAzureFirewallRule.ps1
echo    [System.Diagnostics.Process]::Start($newProcess); >> %temp%\AddSQLAzureFirewallRule.ps1
echo    # Exit from the current, unelevated, process >> %temp%\AddSQLAzureFirewallRule.ps1
echo    exit >> %temp%\AddSQLAzureFirewallRule.ps1
echo    } >> %temp%\AddSQLAzureFirewallRule.ps1
echo # Run your code that needs to be elevated here >> %temp%\AddSQLAzureFirewallRule.ps1
echo Write-Host -NoNewLine "Elevacao para administrador concluida, pressione qualquer tecla para continuar e aguarde alguns segundos" >> %temp%\AddSQLAzureFirewallRule.ps1
echo $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") >> %temp%\AddSQLAzureFirewallRule.ps1
echo #instala o PowerShellGet >> %temp%\AddSQLAzureFirewallRule.ps1
echo if (Get-InstalledModule -Name "PowerShellGet" -MinimumVersion 1.1.2.0) { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "o Modulo necessario PowerShellGet existe" >> %temp%\AddSQLAzureFirewallRule.ps1
echo } else { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "Sera instalado a versão mais atual do PowerShellGet - Requerimento - Por favor aguarde" >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Install-Module PowerShellGet -Force >> %temp%\AddSQLAzureFirewallRule.ps1
echo } >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Instala e importa o AzureRM >> %temp%\AddSQLAzureFirewallRule.ps1
echo if (Get-InstalledModule -Name "AzureRM.Profile" -MinimumVersion 4.0.0) { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "o Modulo necessario AzureRM.Profile existe" >> %temp%\AddSQLAzureFirewallRule.ps1
echo } else { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "Sera instalado a versao mais atual do AzureRM - Por favor aguarde" >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Install-Module -Name AzureRM -AllowClobber -Force >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Import-Module -Name AzureRM >> %temp%\AddSQLAzureFirewallRule.ps1
echo } >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Login no AzureRM >> %temp%\AddSQLAzureFirewallRule.ps1
echo Connect-AzureRmAccount -ErrorAction Stop >> %temp%\AddSQLAzureFirewallRule.ps1
echo # Prompting the user to select the subscription >> %temp%\AddSQLAzureFirewallRule.ps1
echo Get-AzureRmSubscription ^| Out-GridView -OutputMode Single -Title "Please select a subscription" ^| ForEach-Object {$selectedSubscriptionID = $PSItem.SubscriptionId ; $selectedSubscriptionName = $PSItem.Name ; $selectedSubscriptionAccount = $PSItem.ExtendedProperties  } >> %temp%\AddSQLAzureFirewallRule.ps1
echo $selectedSubscriptionAccount = $selectedSubscriptionAccount.Account >> %temp%\AddSQLAzureFirewallRule.ps1
echo Write-Host "Voce selecionou a Subscription: $selectedSubscriptionID de nome $selectedSubscriptionName. `n" -ForegroundColor green >> %temp%\AddSQLAzureFirewallRule.ps1
echo # Setting the selected subscription >> %temp%\AddSQLAzureFirewallRule.ps1
echo Select-AzureRmSubscription -SubscriptionId $selectedSubscriptionID >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Captura IP de internet >> %temp%\AddSQLAzureFirewallRule.ps1
echo $ip = Invoke-RestMethod http://ipinfo.io/json ^| Select -exp ip >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Lista Resource Groups >> %temp%\AddSQLAzureFirewallRule.ps1
echo Get-AzureRmSqlServer ^| Out-GridView -OutputMode Single -Title "Selecione o SQL Server que se encontra seu banco de dados" ^| ForEach-Object {$selectedSQL = $PSItem.ServerName ; $selectedSQLRG = $PSItem.ResourceGroupName } >> %temp%\AddSQLAzureFirewallRule.ps1
echo write-host "Voce selecionou o ResourceGroup $selectedSQL" >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Lista Bancos de Dados >> %temp%\AddSQLAzureFirewallRule.ps1
echo $ruleexit = Get-AzureRmSqlServerFirewallRule -ServerName $selectedSQL -ResourceGroupName $selectedSQLRG >> %temp%\AddSQLAzureFirewallRule.ps1
echo $ruleexit = $ruleexit.FirewallRuleName >> %temp%\AddSQLAzureFirewallRule.ps1
echo #Configura Regra >> %temp%\AddSQLAzureFirewallRule.ps1
echo if ($ruleexit.Contains($selectedSubscriptionAccount)) { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "Ja existe uma regra para sua conta - reconfigurando para o IP atual" >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Set-AzureRmSqlServerFirewallRule -ResourceGroupName $selectedSQLRG -ServerName "$selectedSQL" -FirewallRuleName "$selectedSubscriptionAccount" -StartIpAddress "$ip" -EndIpAddress "$ip" >> %temp%\AddSQLAzureFirewallRule.ps1
echo } else { >> %temp%\AddSQLAzureFirewallRule.ps1
echo     Write-Host "Sera Adicionada a regra para que voce possa se conectar" >> %temp%\AddSQLAzureFirewallRule.ps1
echo     New-AzureRmSqlServerFirewallRule -ResourceGroupName $selectedSQLRG -ServerName "$selectedSQL" -FirewallRuleName "$selectedSubscriptionAccount" -StartIpAddress "$ip" -EndIpAddress "$ip" >> %temp%\AddSQLAzureFirewallRule.ps1
echo } >> %temp%\AddSQLAzureFirewallRule.ps1
echo Write-Host -NoNewLine "Comando Concluido, pressione qualquer tecla para finalizar" >> %temp%\AddSQLAzureFirewallRule.ps1
PowerShell.exe -ExecutionPolicy Bypass -File %temp%\AddSQLAzureFirewallRule.ps1
