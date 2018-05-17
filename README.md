# fwrule-sqlazure-add
EN: This .BAT file make a PowerShell Scripts who add Firewall Rules in SQL Azure
PT: Esse arquivo .BAT cria um script PowerShell que adiciona regras de Firewall no SQL Azure

# How It Works | Como Funciona.
EN:
1 - The .BAT file generates an "powershell" script in the "% temp%" path (The need to use Bat occurs due to the limitations of the powershell policies for scripts)
2 - The BAT runs Powershell and rises to administrator rights.
3 - The ps1 script checks if the Powershell modules to perform the action are in the minimum required version.
4 - Script ps1 requests azure account login
5 - The ps1 script captures the user's current internet IP.
6 - The script prompts the user to make the choices until they reach the database that they want to use.
7 - The script adds a firewall rule in SQL Azure limited to only the user's IP and the name of the rule is the user's Email.

PT:
1 - o arquivo .BAT gera através de "echo" no caminho "%temp%" um script powershell (A necessidade do uso do Bat ocorre devido as limitações das politicas do powershell para scripts)
2 - O BAT executa o Powershell e sobe para direitos de administrador.
3 - O script ps1 verifica se os módulos Powershell para executar a ação estão na versão minima necessária.
4 - O Script ps1 pede o login da conta azure
5 - O script ps1 captura o IP de internet atual do usuário.
6 - O script solicita que o usuário faça as escolhas até chegar no banco de dados que quer usar.
7 - O script adiciona uma regra de firewall no SQL Azure limitado a somente o IP do usuário e o nome da regra é o E-mail do usuário.
