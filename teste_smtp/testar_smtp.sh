#!/bin/bash

# Testa a conexão SMTP com um servidor de email em diversas portas
# Use: ./testar_todas_portas_email.sh

read -p "Digite o servidor de email que deseja testar: " SERVIDOR

echo "Testando conexões em diversas portas com o servidor de email $SERVIDOR..."

# Portas usadas em conexões de email
declare -A PORTAS_PROTOCOLOS=(
    [25]="SMTP"
    [587]="SMTP (STARTTLS)"
    [465]="SMTPS"
    [2525]="SMTP alternativo"
    [110]="POP3"
    [995]="POP3S"
    [143]="IMAP"
    [993]="IMAPS"
)

echo "Servidor de Email: $SERVIDOR"
echo "---------------------"

for PORTA in "${!PORTAS_PROTOCOLOS[@]}"
do
  echo -n "Testing connection to $SERVIDOR on port $PORTA (${PORTAS_PROTOCOLOS[$PORTA]})... "

  if nc -z -w5 "$SERVIDOR" "$PORTA" >/dev/null 2>&1; then
    echo -e "\e[32mConexão bem-sucedida com $SERVIDOR na porta $PORTA\e[0m"
  else
    echo -e "\e[31mErro ao conectar ao $SERVIDOR na porta $PORTA\e[0m"
  fi
done

echo "---------------------"
