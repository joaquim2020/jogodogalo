# Use a imagem base do Windows com .NET Framework
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

# Definir variáveis de ambiente
ENV USERNAME=adminuser
ENV PASSWORD=Passw0rd!

# Instalar componentes necessários
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Instalar o RDP e configurar o serviço
RUN Install-WindowsFeature -Name Remote-Desktop-Services

# Configurar o usuário para RDP
RUN net user $env:USERNAME $env:PASSWORD /add `
    && net localgroup administrators $env:USERNAME /add

# Permitir conexões RDP no firewall
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0 `
    && Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Copiar a aplicação compilada para o diretório de trabalho
WORKDIR /app
COPY ./bin/Release/ .

# Expor a porta RDP
EXPOSE 3389

# Iniciar o serviço RDP e a aplicação
CMD Start-Service TermService; Start-Process -FilePath "jogodogalo.exe"; powershell -NoExit
