# Confeitaria Olitech ERP V4.3 Completo

Correções incluídas:
- Campanhas WhatsApp igual ao sistema de agendamentos: mensagem, imagem/vídeo, envio para um cliente ou todos.
- Importar clientes do celular via CSV e exportar clientes.
- Cadastro da API WhatsApp somente em Configurações.
- Vendas com editar, cancelar, desconto, juros e tipos de pagamento editáveis.
- Financeiro com nome/empresa/CNPJ para boletos, PIX e vencimentos.
- Usuários com permissões por aba/função.
- Cadastro de logo da empresa para impressões e campanhas.
- Mantido layout Olitech com fonte profissional e Upper Case.

Use o schema.sql no Supabase e depois faça Clear build cache & deploy no Render.


## V4.6
- Cadastro de receitas com vários produtos/ingredientes puxando do cadastro de produtos.
- Quantidade e unidade por item: ex. 100 GR de farinha, 1 L de leite.
- Impressão da ficha de receita com valor e sem valor.
- Permissão específica: ver/imprimir valores das receitas.
- Recalcula custo da receita ao adicionar/excluir ingrediente.


## V5.1
Correções: WhatsApp salva configuração e permite desconectar/trocar número; botão QR removido do topo; PDV corrigido; novo pedido corrigido; campanhas podem reenviar; compras com fornecedores CRUD; importação XML NF-e com vínculo anti-duplicidade; layout compacto/mobile; login padrão OLITECH/olitech/051309.
