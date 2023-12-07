#!/bin/bash

# Verifica o certificado SSL de uma lista de sites
# Use: ./verificar_ssl_lista.sh

ARQUIVO_LISTA="sites.txt"  # Assumindo que sites.txt está no mesmo diretório que o script

if [ ! -f "$ARQUIVO_LISTA" ]; then
  echo "O arquivo de lista não existe."
  exit 1
fi

echo "Verificando os certificados SSL da lista de sites em $ARQUIVO_LISTA..."

while IFS= read -r SITE
do
  echo "Site: $SITE"
  echo "---------------------"

  # Verifica a validade do certificado
  expiracao=$(echo | openssl s_client -connect "$SITE":443 2>/dev/null | openssl x509 -noout -enddate)
  validade=$(date -d "${expiracao#*=}" '+%s')
  hoje=$(date '+%s')

  if [ $validade -gt $hoje ]; then
    echo "Certificado válido até: ${expiracao#*=}"
    echo "---------------------"
  else
    echo "Certificado expirado ou inválido."
    echo "---------------------"
  fi

done < "$ARQUIVO_LISTA"
