CONFEITARIA OLITECH ERP V5.4

Correções principais:
- Corrigido menu de ações/produtos em Receitas, agora com botões diretos.
- Produtos da receita: adicionar/excluir produtos pegando do cadastro de produtos, com quantidade/unidade/custo.
- Impressão da receita com valor e sem valor.
- Produtos: importar XML e importar PDF/DANFE da NF-e.
- Importação PDF lê fornecedor, número da NF e itens como no DANFE enviado.
- Pedido/agendamento: salvamento reforçado, vários itens, editar/cancelar/excluir e finalizar.
- Finalizar pedido gera venda, altera status para BAIXADO/VENDIDO e baixa estoque opcional.
- Pedido finalizado fica apenas para consulta.

Render:
Build Command: npm install --package-lock=false --omit=dev --no-audit --no-fund
Start Command: node server.js

Após subir, execute o schema.sql no Supabase caso tenha colunas faltando.
