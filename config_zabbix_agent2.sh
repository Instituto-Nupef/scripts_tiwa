#!/bin/bash

# Autor: Moacir Neto - (moacirbmn)
# Descrição: Script para configuração do Zabbix Agent 2

# Função para imprimir uma caixa de destaque
print_box() {
    local text="$1"
    local width=${#text}
    local line=""

    for ((i = 0; i < width + 4; i++)); do
        line+="="
    done

    echo "$line"
    echo "| $text |"
    echo "$line"
}

# Crie o arquivo de configuração
config_file="/etc/zabbix/zabbix_agent2.conf"

# Verifique se o arquivo já existe e faça um backup, se necessário
if [ -f "$config_file" ]; then
    backup_file="${config_file}_backup_$(date +'%Y%m%d%H%M%S')"
    mv "$config_file" "$backup_file"
    echo "Arquivo de configuração existente movido para: $backup_file"
fi

# Execute o comando openssl para gerar a chave PSK
psk_file="/etc/zabbix/zabbix_agentd.psk"
openssl rand -hex 32 > "$psk_file"
chmod 600 "$psk_file"

# Pergunte ao usuário sobre as informações de configuração
read -p "Endereço do servidor Zabbix: " server_address
read -p "Endereço do servidor ativo Zabbix: " active_server_address
read -p "Nome do host: " hostname
read -p "TLS Connect (none, unencrypted, psk, cert): " tls_connect
read -p "TLS Accept (none, unencrypted, psk, cert): " tls_accept
read -p "TLSPSKIdentity: " psk_identity

# Pergunte ao usuário se irá monitorar um container Docker
read -p "Deseja monitorar um container Docker? (s/n): " monitor_docker

# Crie o novo arquivo de configuração
cat << EOF > "$config_file"
# Arquivo de configuração do Zabbix Agent 2

# Configurações gerais
Server=$server_address
ServerActive=$active_server_address
Hostname=$hostname

# Configurações de TLS
TLSConnect=$tls_connect
TLSAccept=$tls_accept
TLSPSKFile=$psk_file
TLSPSKIdentity=$psk_identity

# Outras configurações
PidFile=/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=0
Include=/etc/zabbix/zabbix_agent2.d/*.conf
ControlSocket=/tmp/agent.sock

EOF

# Adicione a configuração para monitorar container Docker, se selecionado
if [ "$monitor_docker" = "s" ]; then
    echo "Plugins.Docker.Endpoint=unix:///var/run/docker.sock" >> "$config_file"
fi

echo "Arquivo de configuração criado em: $config_file"
echo

# Imprima as informações de TLSPSKIdentity e $psk_file dentro de uma caixa
print_box "Informações de TLS PSK"
echo "TLSPSKIdentity: $psk_identity"
echo "Arquivo TLSPSK: $(cat "$psk_file")"
echo
echo "Certifique-se de configurar esses dados no seu servidor Zabbix."
