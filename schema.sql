create extension if not exists pgcrypto;

create table if not exists usuarios(
 id uuid primary key default gen_random_uuid(), nome text not null, usuario text unique not null, senha text, senha_hash text,
 perfil text default 'admin', permissoes jsonb default '{"todas":true}', ativo boolean default true, created_at timestamptz default now()
);
create table if not exists configuracoes(id uuid primary key default gen_random_uuid(), chave text unique not null, valor jsonb, created_at timestamptz default now());
create table if not exists fornecedores(id uuid primary key default gen_random_uuid(), nome text not null, telefone text, whatsapp text, email text, cnpj text, cidade text, estado text, observacoes text, created_at timestamptz default now());
create table if not exists produtos(
 id uuid primary key default gen_random_uuid(), nome text not null, tipo text default 'INGREDIENTE', categoria text, unidade text default 'UN', codigo_barras text,
 custo_unitario numeric(14,4) default 0, custo_medio numeric(14,4) default 0, preco_venda numeric(14,2) default 0, margem_percentual numeric(12,2) default 0,
 estoque_atual numeric(14,3) default 0, estoque_minimo numeric(14,3) default 0, validade date, lote text,
 fornecedor_principal text, ultima_compra_valor numeric(14,4) default 0, ultima_compra_data date, quantidade_compras integer default 0,
 created_at timestamptz default now()
);
create table if not exists clientes(
 id uuid primary key default gen_random_uuid(), nome text not null, telefone text, whatsapp text, email text, cpf_cnpj text,
 rua text, numero text, complemento text, bairro text, cidade text, estado text, cep text, observacoes text, bloqueado boolean default false,
 created_at timestamptz default now()
);
create table if not exists receitas(
 id uuid primary key default gen_random_uuid(), nome text not null, categoria text, peso_base numeric(14,3) default 1, unidade_base text default 'KG', rendimento text,
 custo_total numeric(14,2) default 0, preco_venda numeric(14,2) default 0, margem_percentual numeric(12,2) default 100, modo_preparo text,
 created_at timestamptz default now()
);
create table if not exists receita_itens(
 id uuid primary key default gen_random_uuid(), receita_id uuid references receitas(id) on delete cascade, produto_id uuid references produtos(id), descricao text,
 quantidade numeric(14,3) default 0, unidade text default 'UN', custo_unitario numeric(14,4) default 0, created_at timestamptz default now()
);
create table if not exists arquivos_receitas(id uuid primary key default gen_random_uuid(), receita_id uuid references receitas(id) on delete cascade, nome_arquivo text, tipo text, texto_extraido text, created_at timestamptz default now());
create table if not exists pedidos(
 id uuid primary key default gen_random_uuid(), cliente_id uuid references clientes(id), cliente_nome text, telefone text, data_entrega date, hora_entrega text,
 endereco_entrega text, status text default 'AGENDADO', subtotal numeric(14,2) default 0, desconto numeric(14,2) default 0, total numeric(14,2) default 0,
 forma_pagamento text, observacoes text, created_at timestamptz default now()
);
create table if not exists pedido_itens(id uuid primary key default gen_random_uuid(), pedido_id uuid references pedidos(id) on delete cascade, produto_id uuid, receita_id uuid, descricao text, quantidade numeric(14,3), valor_unitario numeric(14,2), total numeric(14,2), created_at timestamptz default now());
create table if not exists vendas(id uuid primary key default gen_random_uuid(), cliente_id uuid, cliente_nome text default 'CONSUMIDOR', subtotal numeric(14,2) default 0, desconto numeric(14,2) default 0, total numeric(14,2) default 0, forma_pagamento text, status text default 'PAGO', created_at timestamptz default now());
create table if not exists venda_itens(id uuid primary key default gen_random_uuid(), venda_id uuid references vendas(id) on delete cascade, produto_id uuid, descricao text, quantidade numeric(14,3), valor_unitario numeric(14,2), total numeric(14,2), created_at timestamptz default now());
create table if not exists financeiro(
 id uuid primary key default gen_random_uuid(), descricao text not null, tipo text default 'DESPESA', categoria text, valor numeric(14,2) default 0,
 vencimento date, pagamento date, status text default 'ABERTO', forma_pagamento text, boleto_codigo text, pix_chave text, observacoes text, created_at timestamptz default now()
);
create table if not exists pro_labore(id uuid primary key default gen_random_uuid(), descricao text, valor numeric(14,2) default 0, data_referencia date default current_date, tipo text default 'RETIRADA', usuario_id uuid, created_at timestamptz default now());
create table if not exists compras(id uuid primary key default gen_random_uuid(), fornecedor_id uuid references fornecedores(id), numero_nf text, data_compra date default current_date, vencimento date, total numeric(14,2) default 0, status text default 'LANÇADA', observacoes text, created_at timestamptz default now());
create table if not exists compra_itens(id uuid primary key default gen_random_uuid(), compra_id uuid references compras(id) on delete cascade, produto_id uuid references produtos(id), quantidade numeric(14,3) default 0, valor_unitario numeric(14,4) default 0, total numeric(14,2) default 0, created_at timestamptz default now());
create table if not exists estoque_movimentos(id uuid primary key default gen_random_uuid(), produto_id uuid references produtos(id), tipo text, origem text, quantidade numeric(14,3), valor_unitario numeric(14,4), referencia text, created_at timestamptz default now());
create table if not exists producoes(id uuid primary key default gen_random_uuid(), receita_id uuid references receitas(id), descricao text, responsavel text, peso_desejado numeric(14,3), custo_total numeric(14,2) default 0, status text default 'ABERTO', created_at timestamptz default now());
create table if not exists campanhas_whatsapp(id uuid primary key default gen_random_uuid(), nome text not null, mensagem text, publico text, agendada_para timestamptz, status text default 'PROGRAMADA', enviados int default 0, entregues int default 0, falhas int default 0, created_at timestamptz default now());


-- MIGRAÇÃO SEGURA PARA BANCOS QUE JÁ TINHAM VERSÕES ANTIGAS
-- create table if not exists NÃO cria colunas novas em tabelas existentes, por isso estes ALTER são obrigatórios.
alter table produtos add column if not exists nome text;
alter table produtos add column if not exists tipo text default 'INGREDIENTE';
alter table produtos add column if not exists categoria text;
alter table produtos add column if not exists unidade text default 'UN';
alter table produtos add column if not exists codigo_barras text;
alter table produtos add column if not exists custo_unitario numeric(14,4) default 0;
alter table produtos add column if not exists custo_medio numeric(14,4) default 0;
alter table produtos add column if not exists preco_venda numeric(14,2) default 0;
alter table produtos add column if not exists margem_percentual numeric(12,2) default 0;
alter table produtos add column if not exists estoque_atual numeric(14,3) default 0;
alter table produtos add column if not exists estoque_minimo numeric(14,3) default 0;
alter table produtos add column if not exists validade date;
alter table produtos add column if not exists lote text;
alter table produtos add column if not exists fornecedor_principal text;
alter table produtos add column if not exists ultima_compra_valor numeric(14,4) default 0;
alter table produtos add column if not exists ultima_compra_data date;
alter table produtos add column if not exists quantidade_compras integer default 0;

alter table clientes add column if not exists rua text;
alter table clientes add column if not exists numero text;
alter table clientes add column if not exists complemento text;
alter table clientes add column if not exists bairro text;
alter table clientes add column if not exists cidade text;
alter table clientes add column if not exists estado text;
alter table clientes add column if not exists cep text;
alter table clientes add column if not exists bloqueado boolean default false;

alter table usuarios add column if not exists permissoes jsonb default '{"todas":true}';
alter table usuarios add column if not exists senha_hash text;
alter table usuarios add column if not exists ativo boolean default true;

insert into usuarios(nome,usuario,senha,perfil,permissoes,ativo) values('OLITECH','admin','admin','admin','{"todas":true}',true) on conflict(usuario) do nothing;
insert into configuracoes(chave,valor) values('whatsapp','{"url":"","apiKey":"","instance":"confeitaria"}') on conflict(chave) do nothing;

insert into fornecedores(nome,telefone,whatsapp,cidade,estado) values('FORNECEDOR TESTE','(00) 0000-0000','(00) 00000-0000','DESCALVADO','SP') on conflict do nothing;
insert into produtos(nome,tipo,categoria,unidade,custo_unitario,custo_medio,preco_venda,margem_percentual,estoque_atual,estoque_minimo) values
('FARINHA DE TRIGO','INGREDIENTE','MASSAS','KG',5.50,5.50,0,0,20,5),('AÇÚCAR','INGREDIENTE','MERCEARIA','KG',4.80,4.80,0,0,15,3),('OVO','INGREDIENTE','PERECÍVEIS','UN',0.80,0.80,0,0,60,12),('LEITE','INGREDIENTE','PERECÍVEIS','L',5.00,5.00,0,0,10,2),('CHOCOLATE EM PÓ','INGREDIENTE','CHOCOLATE','KG',24.00,24.00,0,0,4,1),('CENOURA','INGREDIENTE','HORTIFRUTI','KG',6.00,6.00,0,0,5,1),('FERMENTO','INGREDIENTE','MERCEARIA','KG',35.00,35.00,0,0,1,0.2),('QUEIJO MUSSARELA','INGREDIENTE','FRIOS','KG',38.00,38.00,0,0,5,1),('MOLHO DE TOMATE','INGREDIENTE','MOLHOS','KG',12.00,12.00,0,0,3,1),('BOLO DE CHOCOLATE 1KG','PRODUTO','BOLOS','UN',22.00,22.00,55.00,150,0,0),('BOLO DE CENOURA 1KG','PRODUTO','BOLOS','UN',18.00,18.00,45.00,150,0,0),('PIZZA MÉDIA','PRODUTO','PIZZAS','UN',20.00,20.00,55.00,175,0,0) on conflict do nothing;
insert into clientes(nome,telefone,whatsapp,rua,numero,bairro,cidade,estado,cep) values('CONSUMIDOR','', '', '', '', '', '', '', '') on conflict do nothing;
insert into receitas(nome,categoria,peso_base,unidade_base,rendimento,custo_total,preco_venda,margem_percentual,modo_preparo) values
('BOLO DE CHOCOLATE TESTE','BOLOS',1,'KG','1 BOLO DE 1KG',22,55,150,'MISTURE OS INGREDIENTES, ASSE EM FORNO MÉDIO E FINALIZE COM COBERTURA.'),
('BOLO DE CENOURA TESTE','BOLOS',1,'KG','1 BOLO DE 1KG',18,45,150,'BATA CENOURA, OVOS E LÍQUIDOS. MISTURE COM SECOS E ASSE EM FORNO MÉDIO.'),
('PIZZA MÉDIA TESTE','PIZZAS',1,'UN','1 PIZZA MÉDIA',20,55,175,'PREPARE A MASSA, ADICIONE MOLHO, QUEIJO E RECHEIO. ASSE ATÉ DOURAR.') on conflict do nothing;

-- V4.3 MELHORIAS: CAMPANHAS, LOGO, VENDAS, FINANCEIRO
alter table vendas add column if not exists juros numeric(14,2) default 0;
alter table vendas add column if not exists motivo_cancelamento text;
alter table vendas add column if not exists cancelada_em timestamptz;
alter table vendas add column if not exists observacoes text;

alter table financeiro add column if not exists nome_empresa text;
alter table financeiro add column if not exists cpf_cnpj text;

alter table campanhas_whatsapp add column if not exists cliente_id uuid;
alter table campanhas_whatsapp add column if not exists anexo_nome text;
alter table campanhas_whatsapp add column if not exists anexo_tipo text;
alter table campanhas_whatsapp add column if not exists falhas integer default 0;

insert into configuracoes(chave,valor) values
('empresa','{"nome":"CONFEITARIA OLITECH","cnpj":"","whatsapp":"","logo_data":""}'),
('formas_pagamento','{"formas":["DINHEIRO","PIX","DÉBITO","CRÉDITO","CREDIÁRIO","BOLETO"]}')
on conflict(chave) do nothing;


-- V5.0 - PEDIDOS, FORMAS DE PAGAMENTO E CANCELAMENTO
alter table pedidos add column if not exists entrega_tipo text default 'ENTREGA';
alter table pedidos add column if not exists juros numeric(14,2) default 0;
alter table pedidos add column if not exists multa_cancelamento numeric(14,2) default 0;
alter table pedidos add column if not exists motivo_cancelamento text;
alter table pedidos add column if not exists cancelada_em timestamptz;
alter table pedidos add column if not exists venda_id uuid;
alter table pedidos add column if not exists pago_em timestamptz;
alter table pedidos add column if not exists prazo_cancelamento_horas numeric(14,2) default 24;
alter table pedidos add column if not exists multa_percentual numeric(14,2) default 0;
alter table vendas add column if not exists juros numeric(14,2) default 0;
update configuracoes set valor='{"formas":[{"nome":"DINHEIRO","tipo":"DESCONTO","percentual":5},{"nome":"PIX","tipo":"DESCONTO","percentual":5},{"nome":"CARTÃO DE CRÉDITO","tipo":"JUROS","percentual":15},{"nome":"CARTÃO DE DÉBITO","tipo":"JUROS","percentual":3},{"nome":"CHEQUE","tipo":"JUROS","percentual":5}]}'::jsonb where chave='formas_pagamento' and (valor->'formas' is null or jsonb_typeof(valor->'formas'->0)='string');


-- V5.1 - usuário padrão único solicitado e vínculos XML
insert into configuracoes(chave,valor) values('xml_vinculos','{"fornecedores":{},"produtos":{}}'::jsonb) on conflict(chave) do nothing;
update usuarios set nome='OLITECH', usuario='olitech', senha='051309', perfil='admin', permissoes='{"todas":true,"ver_valores_receitas":true}'::jsonb, ativo=true where usuario in ('admin','olitech');
insert into usuarios(nome,usuario,senha,perfil,permissoes,ativo) values('OLITECH','olitech','051309','admin','{"todas":true,"ver_valores_receitas":true}',true) on conflict(usuario) do update set nome='OLITECH', senha='051309', perfil='admin', permissoes='{"todas":true,"ver_valores_receitas":true}'::jsonb, ativo=true;
-- Remova o comentário abaixo se quiser apagar todos os usuários antigos e manter somente OLITECH:
-- delete from usuarios where usuario <> 'olitech';

-- V5.2 - reforço: manter somente usuário padrão solicitado
update usuarios set nome='OLITECH', usuario='olitech', senha='051309', perfil='admin', permissoes='{"todas":true,"ver_valores_receitas":true}'::jsonb, ativo=true where usuario='olitech';
insert into usuarios(nome,usuario,senha,perfil,permissoes,ativo)
values('OLITECH','olitech','051309','admin','{"todas":true,"ver_valores_receitas":true}'::jsonb,true)
on conflict(usuario) do update set nome='OLITECH', senha='051309', perfil='admin', permissoes='{"todas":true,"ver_valores_receitas":true}'::jsonb, ativo=true;
-- Caso queira remover usuários de teste antigos, execute manualmente a linha abaixo no Supabase:
-- delete from usuarios where usuario <> 'olitech';

-- V5.5 reforço CRUD receitas/pedidos/produtos
alter table receita_itens add column if not exists descricao text;
alter table receita_itens add column if not exists custo_unitario numeric(14,4) default 0;
alter table receita_itens add column if not exists unidade text default 'UN';
alter table pedido_itens add column if not exists receita_id uuid;
alter table pedidos add column if not exists venda_id uuid;
alter table pedidos add column if not exists pago_em timestamptz;
alter table pedidos add column if not exists juros numeric(14,2) default 0;
alter table pedidos add column if not exists multa_cancelamento numeric(14,2) default 0;
alter table pedidos add column if not exists motivo_cancelamento text;
alter table pedidos add column if not exists cancelada_em timestamptz;
alter table pedidos add column if not exists multa_percentual numeric(14,2) default 0;
alter table pedidos add column if not exists prazo_cancelamento_horas numeric(14,2) default 24;
alter table vendas add column if not exists juros numeric(14,2) default 0;
update usuarios set nome='OLITECH', usuario='olitech', senha='051309', perfil='admin', permissoes='{"todas":true,"ver_valores_receitas":true}'::jsonb, ativo=true where usuario='olitech';
