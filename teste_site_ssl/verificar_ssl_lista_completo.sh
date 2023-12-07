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

  # Extrai informações do certificado SSL
  echo | openssl s_client -connect "$SITE":443 2>/dev/null | openssl x509 -noout -text

  # Verifica a validade do certificado
  echo | openssl s_client -connect "$SITE":443 2>/dev/null | openssl x509 -noout -dates

  # Verifica o emissor do certificado
  echo | openssl s_client -connect "$SITE":443 2>/dev/null | openssl x509 -noout -issuer

  echo "---------------------"
done < "$ARQUIVO_LISTA"
