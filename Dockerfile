# Use a imagem base do Windows com .NET Framework
#FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

# Use a imagem base do Windows Server 2022 com .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2022

SHELL ["powershell", "-Command"]

# Instalar serviços necessários (exemplo: RDP)
#RUN Install-WindowsFeature -Name Web-Server; `
#    Install-WindowsFeature -Name Remote-Desktop-Services

RUN Install-WindowsFeature -Name Web-Server 
RUN Install-WindowsFeature -Name Remote-Desktop-Services

# Definir o diretório de trabalho
WORKDIR /app

# Copiar os arquivos da aplicação
COPY . .

# Definir o comando a ser executado no container
CMD ["powershell", "Write-Host 'Servidor pronto.'"]


# Definir variáveis de ambiente
ENV USERNAME=adminuser
ENV PASSWORD=Passw0rd!

# Instalar componentes necessários
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Instalar o RDP e configurar o serviço
RUN Install-WindowsFeature -Name Remote-Desktop-Services

# Configurar o usuário para RDP
#RUN net user $env:USERNAME $env:PASSWORD /add && net localgroup administrators $env:USERNAME /add
RUN net user $env:USERNAME $env:PASSWORD /add 
RUN net localgroup administrators $env:USERNAME /add


# Configurar o usuário para RDP
#RUN net user $env:USERNAME $env:PASSWORD /add; `
#    net localgroup administrators $env:USERNAME /add

# Permitir conexões RDP no firewall
#RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0 && Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0 Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0 
#RUN Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Permitir conexões RDP alterando a configuração no registro
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

# Habilitar a regra do firewall para conexões de Remote Desktop
#RUN Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#RUN powershell -Command "Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'"
# Habilitar as regras do firewall para Remote Desktop
#RUN powershell -Command "Enable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)'; `
#    Enable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (UDP-In)'"
# Habilitar as regras do firewall para Remote Desktop
RUN powershell -Command "Enable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)'; Enable-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (UDP-In)'"


# Permitir conexões RDP no firewall
#RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0; `
#    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Copiar a aplicação compilada para o diretório de trabalho
WORKDIR /app
COPY ./bin/Release/ .

# Expor a porta RDP
EXPOSE 3389

# Iniciar o serviço RDP e a aplicação
CMD Start-Service TermService; Start-Process -FilePath "jogodogalo.exe"; powershell -NoExit
