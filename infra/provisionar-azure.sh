#!/usr/bin/env bash
set -euo pipefail

# Ajuste somente estes valores antes de executar.
SUFIXO="bruno$(date +%m%d%H%M)"
LOCAL="brazilsouth"
RESOURCE_GROUP="rg-atividade-livros"
SQL_SERVER="sql-${SUFIXO}"
SQL_DATABASE="sqldb-livros"
SQL_ADMIN="brunoadmin"
APP_PLAN="plan-${SUFIXO}"
WEBAPP="webapp-${SUFIXO}"
APP_INSIGHTS="appi-${SUFIXO}"
REPO_URL="COLE_AQUI_A_URL_DO_SEU_FORK"

read -r -s -p "Crie e informe a senha do administrador do Azure SQL: " SQL_PASSWORD
echo

az login
az account show --output table

az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCAL"

az sql server create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$SQL_SERVER" \
  --location "$LOCAL" \
  --admin-user "$SQL_ADMIN" \
  --admin-password "$SQL_PASSWORD"

az sql db create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQL_SERVER" \
  --name "$SQL_DATABASE" \
  --service-objective Basic \
  --backup-storage-redundancy Local

# Permite conexões originadas por serviços hospedados no Azure, incluindo o WebApp.
az sql server firewall-rule create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQL_SERVER" \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

az appservice plan create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_PLAN" \
  --location "$LOCAL" \
  --sku F1 \
  --is-linux

az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$APP_PLAN" \
  --name "$WEBAPP" \
  --runtime "NODE:20-lts"

az monitor app-insights component create \
  --resource-group "$RESOURCE_GROUP" \
  --app "$APP_INSIGHTS" \
  --location "$LOCAL" \
  --application-type web

APPINSIGHTS_CONNECTION_STRING="$(az monitor app-insights component show \
  --resource-group "$RESOURCE_GROUP" \
  --app "$APP_INSIGHTS" \
  --query connectionString \
  --output tsv)"

az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP" \
  --settings \
    DB_SERVER="${SQL_SERVER}.database.windows.net" \
    DB_NAME="$SQL_DATABASE" \
    DB_USER="$SQL_ADMIN" \
    DB_PASSWORD="$SQL_PASSWORD" \
    APPLICATIONINSIGHTS_CONNECTION_STRING="$APPINSIGHTS_CONNECTION_STRING" \
    SCM_DO_BUILD_DURING_DEPLOYMENT=true

if [[ "$REPO_URL" == "COLE_AQUI_A_URL_DO_SEU_FORK" ]]; then
  echo "Recursos criados. Edite REPO_URL e execute o comando de deploy indicado no README."
else
  az webapp deployment source config \
    --resource-group "$RESOURCE_GROUP" \
    --name "$WEBAPP" \
    --repo-url "$REPO_URL" \
    --branch main
fi

echo "WebApp: https://${WEBAPP}.azurewebsites.net"
echo "Rota do tema: https://${WEBAPP}.azurewebsites.net/tema"
echo "Não apague o Resource Group antes de capturar os prints e enviar a atividade."
