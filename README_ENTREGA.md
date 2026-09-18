# Atividade Azure — Biblioteca/Livros

**Integrante:** Bruno Alves de Souza  
**Tema:** Biblioteca/Livros

## 1. Fork e preparação do repositório

1. Acesse o repositório `karlosmiguell/atividade-azure-devops` no GitHub.
2. Clique em **Fork** e crie o fork na sua conta.
3. Copie para o fork os arquivos desta pasta ou use este projeto como conteúdo da branch `main`.
4. Confirme que `package.json` está na raiz e `app/index.js` contém o SELECT da tabela `Livros`.

## 2. Pré-requisitos locais

- Azure CLI instalado.
- Uma assinatura Azure ativa.
- Acesso ao Portal do Azure para executar o SQL no Query Editor.

Confira a instalação:

```bash
az version
```

## 3. Provisionamento

Abra `infra/provisionar-azure.sh`, substitua `REPO_URL` pela URL HTTPS do seu fork e execute:

```bash
chmod +x infra/provisionar-azure.sh
./infra/provisionar-azure.sh
```

O script solicita a senha do administrador do SQL sem gravá-la no arquivo. Guarde essa senha temporariamente, pois ela será necessária no Query Editor.

Se o SKU gratuito `F1` não estiver disponível na assinatura, troque por `B1`. O `B1` pode gerar cobrança; apague o Resource Group após a entrega.

## 4. Criação da tabela e inserts

1. No Portal Azure, abra o banco `sqldb-livros`.
2. Entre em **Query editor (preview)**.
3. Autentique-se com `brunoadmin` e a senha criada.
4. Abra `database/livros.sql`, copie todo o conteúdo e execute.
5. Capture um print mostrando a tabela, os cinco registros e o nome do banco.

Se o Query Editor informar bloqueio de firewall, use a opção para adicionar o IP atual e tente novamente.

## 5. Direct Deploy do GitHub

O script já executa o vínculo quando `REPO_URL` está preenchida. Se os recursos foram criados antes do fork, execute separadamente:

```bash
az webapp deployment source config \
  --resource-group rg-atividade-livros \
  --name NOME_REAL_DO_WEBAPP \
  --repo-url URL_HTTPS_DO_SEU_FORK \
  --branch main
```

Depois, confira **Deployment Center > Logs** no WebApp. Capture o print quando o deploy aparecer como concluído com sucesso.

## 6. Validação

Abra as duas URLs impressas pelo script:

- `https://NOME_REAL_DO_WEBAPP.azurewebsites.net`
- `https://NOME_REAL_DO_WEBAPP.azurewebsites.net/tema`

A rota `/tema` deve retornar um JSON com os cinco livros. Capture o print com a URL e os registros visíveis.

Depois de acessar as rotas algumas vezes, abra o Application Insights e consulte **Transaction search** ou **Live Metrics**. Capture um print que mostre requisições da aplicação.

## 7. Evidências obrigatórias no PDF

1. Capa com tema e nome do integrante.
2. Arquitetura da solução (`arquitetura/arquitetura.drawio`).
3. Comandos Azure CLI utilizados.
4. Banco com a tabela e os cinco inserts.
5. Deployment Center com deploy concluído.
6. Application Insights recebendo telemetria.
7. WebApp em execução na rota `/tema`.

## 8. Exclusão após a entrega

Somente depois de enviar e conferir a atividade:

```bash
az group delete --name rg-atividade-livros --yes --no-wait
```

Esse comando apaga todos os recursos do trabalho e evita cobranças futuras.
