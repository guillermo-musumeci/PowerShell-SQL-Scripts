# SQL Server Ports Firewall Rules
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound –Protocol TCP –LocalPort 1433 -Action allow
New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound –Protocol TCP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName "SQL Server Browser" -Direction Inbound –Protocol UDP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName "SQL Service Broker" -Direction Inbound –Protocol TCP –LocalPort 4022 -Action allow
New-NetFirewallRule -DisplayName "Transact-SQL Debugger / RPC" -Direction Inbound –Protocol TCP –LocalPort 135 -Action allow

# SQL Analysis Ports Firewall Rules
New-NetFirewallRule -DisplayName "SQL Analysis Service" -Direction Inbound –Protocol TCP –LocalPort 2383 -Action allow
New-NetFirewallRule -DisplayName "SQL Analysis Browser" -Direction Inbound –Protocol TCP –LocalPort 2382 -Action allow

# Shared Ports Firewall Rules
New-NetFirewallRule -DisplayName "HTTP" -Direction Inbound –Protocol TCP –LocalPort 80 -Action allow
New-NetFirewallRule -DisplayName "SSL" -Direction Inbound –Protocol TCP –LocalPort 443 -Action allow

# Enable Windows Firewall
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
