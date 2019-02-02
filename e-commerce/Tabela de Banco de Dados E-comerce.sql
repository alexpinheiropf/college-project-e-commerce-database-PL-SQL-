--TABELA DO BANCO DE DADOS E-COMMERCE

-- CATEGORIA
CREATE TABLE CATEGORIA (
	cod_categoria NUMBER(3) check (cod_categoria > 0) NOT NULL,
	nome VARCHAR2 (40),
	descricao VARCHAR2 (80),

	CONSTRAINT pk_cod_categoria PRIMARY KEY (cod_categoria)
);

-- PRODUTO
CREATE TABLE PRODUTO(
	cod_produto NUMBER(3) check (cod_produto > 0) NOT NULL,
	nome VARCHAR2(40),
	status NUMBER(1),
	preco_unitario FLOAT,
	cor VARCHAR2(40),
	cod_categoria NUMBER(3) check (cod_categoria > 0) NOT NULL,

	CONSTRAINT pk_cod_produto PRIMARY KEY (cod_produto)
);

ALTER TABLE PRODUTO ADD CONSTRAINT fk_cod_categoria FOREIGN KEY (cod_categoria)
	REFERENCES CATEGORIA (cod_categoria);

-- CLIENTE
CREATE TABLE CLIENTE (
	cod_cliente NUMBER(3) check (cod_cliente > 0) NOT NULL,
	endereco VARCHAR2(40),
	cidade VARCHAR2(40),
	uf CHAR(2),
	telefone_principal NUMBER(11),
	cod_pedido NUMBER(3) check (cod_pedido > 0 ) NOT NULL,

	CONSTRAINT pk_cod_cliente PRIMARY KEY (cod_cliente)
);

ALTER TABLE CLIENTE ADD CONSTRAINT fk_cod_pedido FOREIGN KEY (cod_pedido)
	REFERENCES PEDIDO (cod_pedido);

-- ESTOQUE
CREATE TABLE ESTOQUE(
	cod_produto NUMBER(3) check (cod_produto > 0) NOT NULL,
	quantidade NUMBER(10),
	estoque_minimo NUMBER(10)

);

ALTER TABLE ESTOQUE ADD CONSTRAINT pk_cod_produto_estoque PRIMARY KEY (cod_produto);

ALTER TABLE ESTOQUE ADD CONSTRAINT fk_cod_produto FOREIGN KEY (cod_produto)
		REFERENCES PRODUTO (cod_produto);

ALTER TABLE PEDIDO ADD CONSTRAINT fk_cod_pedido_produto FOREIGN KEY (cod_pedido)
	REFERENCES PRODUTO (cod_produto);

	
-- PEDIDO
CREATE TABLE PEDIDO(
	cod_pedido NUMBER(4) check (cod_pedido > 0) NOT NULL,
	data_pedido DATE,
	prazo_entrega NUMBER,
	data_envio DATE,
	data_entrega DATE,
	valor_frete FLOAT,
	desconto FLOAT,
	cod_cliente NUMBER(3) check (cod_cliente > 0) NOT NULL,
	cod_produto NUMBER(3) check (cod_produto > 0) NOT NULL,

	CONSTRAINT pk_cod_pedido PRIMARY KEY (cod_pedido)
);

ALTER TABLE PEDIDO ADD CONSTRAINT fk_cod_cliente FOREIGN KEY (cod_cliente)
	REFERENCES CLIENTE (cod_cliente);

-- PEDIDO_ENTREGA
CREATE TABLE PEDIDO_ENTREGA (
	cod_pedido NUMBER(3) check (cod_pedido > 0) NOT NULL,
	nome_destinatario VARCHAR2(40),
	endereco_destinatario VARCHAR2(40),
	cidade VARCHAR2 (40),
	uf CHAR(2),
	cep NUMBER(8)
);

ALTER TABLE PEDIDO_ENTREGA ADD CONSTRAINT 
pk_cod_pedido_entrega PRIMARY KEY (cod_pedido);
	

	ALTER TABLE PEDIDO_ENTREGA ADD CONSTRAINT 
	fk_cod_pedido_entrega FOREIGN KEY (cod_pedido)
		REFERENCES PEDIDO (cod_pedido); 

-- PRODUTO_PEDIDO
CREATE TABLE PRODUTO_PEDIDO(
	cod_produto NUMBER(3) check (cod_produto > 0) NOT NULL,
	cod_pedido NUMBER(3) check (cod_pedido > 0) NOT NULL,
	quantidade NUMBER(4),
	desconto FLOAT
	
);

ALTER TABLE PRODUTO_PEDIDO ADD 
	CONSTRAINT pk_cod_prod_pedido PRIMARY KEY (cod_produto, cod_pedido);
ALTER TABLE PRODUTO_PEDIDO ADD	
	CONSTRAINT fk_cod_prod_pedido FOREIGN KEY (cod_produto)
		REFERENCES PRODUTO (cod_produto);
ALTER TABLE PRODUTO_PEDIDO ADD	
	CONSTRAINT fk_cod_pedido_prod FOREIGN KEY (cod_pedido)
		REFERENCES PEDIDO (cod_pedido);



-- FRETE
CREATE TABLE FRETE(
	cod_frete NUMBER(3) check (cod_frete > 0) NOT NULL,
	cidade VARCHAR2(40),
	uf CHAR(2),
	valor FLOAT,
	prazo NUMBER(3),

	CONSTRAINT pk_cod_frete PRIMARY KEY (cod_frete)

);

ALTER TABLE FRETE ADD	
	CONSTRAINT uni_cidade UNIQUE (cidade,uf);

-- FORNECEDORES
CREATE TABLE FORNECEDORES( 
	cod_fornecedores NUMBER(3) check (cod_fornecedores > 0) NOT NULL,
	nome VARCHAR2(40),
	endereco VARCHAR2(40),
	cidade VARCHAR2(40),
	uf CHAR(2),
	cep NUMBER(8),
	pais VARCHAR2 (40),
	telefone NUMBER(11),

	CONSTRAINT pk_cod_fornecedores PRIMARY KEY (cod_fornecedores)
);