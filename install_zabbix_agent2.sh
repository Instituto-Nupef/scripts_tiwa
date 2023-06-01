#!/bin/bash

# Verifique se o serviço do Zabbix Agent 2 já está instalado
if systemctl is-active --quiet zabbix-agent2; then
    echo "O Zabbix Agent 2 já está instalado."
    read -p "Você já configurou o arquivo de configuração? (S/N): " answer
    if [ "$answer" == "S" ] || [ "$answer" == "s" ]; then
        systemctl restart zabbix-agent2
        systemctl enable zabbix-agent2
        echo "O serviço do Zabbix Agent 2 foi reiniciado."
    else
        echo "Por favor, execute o script 'config_zabbix_agent2.sh' em outro terminal para configurar o arquivo de configuração."
        echo "Após a configuração, execute novamente este script."
    fi
else
    # Adicione o repositório oficial do Zabbix Agent 2
    wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
    dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
    apt update

    # Instale o Zabbix Agent 2
    apt install -y zabbix-agent2

    echo "O Zabbix Agent 2 foi instalado com sucesso."

    # Verifique se o arquivo de configuração do Zabbix Agent 2 já existe
    if [ -f /etc/zabbix/zabbix_agent2.conf ]; then
        echo "O arquivo de configuração do Zabbix Agent 2 já existe."
        read -p "Você já configurou o arquivo de configuração? (S/N): " answer
        if [ "$answer" == "S" ] || [ "$answer" == "s" ]; then
            systemctl restart zabbix-agent2
            systemctl enable zabbix-agent2
            echo "O serviço do Zabbix Agent 2 foi reiniciado."
        else
            echo "Por favor, execute o script 'config_zabbix_agent2.sh' em outro terminal para configurar o arquivo de configuração."
            echo "Após a configuração, execute novamente este script."
        fi
    else
        echo "O arquivo de configuração do Zabbix Agent 2 não existe."
        echo "Por favor, execute o script 'config_zabbix_agent2.sh' em outro terminal para configurar o arquivo de configuração."
        echo "Após a configuração, execute novamente este script."
    fi
fi

