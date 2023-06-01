#!/bin/bash

# Adicione o repositório oficial do Zabbix Agent 2
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
apt update

# Instale o Zabbix Agent 2
apt install -y zabbix-agent2

# Configure o arquivo de configuração do Zabbix Agent 2
echo "Server=<IP_DO_SERVIDOR_ZABBIX>" >> /etc/zabbix/zabbix_agent2.conf
echo "ServerActive=<IP_DO_SERVIDOR_ZABBIX>" >> /etc/zabbix/zabbix_agent2.conf
echo "Hostname=$(hostname)" >> /etc/zabbix/zabbix_agent2.conf

# Reinicie o serviço do Zabbix Agent 2
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2
