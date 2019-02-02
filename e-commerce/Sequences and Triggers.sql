-- SEQUENCES AND TRIGGERS
--------------------------------------------------------------------------
--SEQUENCE CLIENTE
DROP SEQUENCE cliente_seq;
CREATE SEQUENCE cliente_seq START WITH 1 INCREMENT BY 1;

--TRIGGER CLIENTE
CREATE OR REPLACE TRIGGER cliente_seq_tr
BEFORE INSERT ON CLIENTE FOR EACH ROW 
WHEN (NEW.cod_cliente is NULL)
BEGIN
	SELECT cliente_seq.NEXTVAL INTO 
	:NEW.cod_cliente FROM DUAL;
END;
--------------------------------------------------------------------------
--SEQUENCE PRODUTO
DROP SEQUENCE produto_seq;
CREATE SEQUENCE produto_seq START WITH 1 INCREMENT BY 1;

--TRIGGER PRODUTO
CREATE OR REPLACE TRIGGER produto_seq_tr
BEFORE INSERT ON PRODUTO FOR EACH ROW 
WHEN (NEW.cod_produto is NULL)
BEGIN
	SELECT produto_seq.NEXTVAL INTO 
	:NEW.cod_produto FROM DUAL;
END;
--------------------------------------------------------------------------
--SEQUENCE PEDIDO
DROP SEQUENCE pedido_seq;
CREATE SEQUENCE pedido_seq START WITH 1 INCREMENT BY 1;

--TRIGGER PEDIDO
CREATE OR REPLACE TRIGGER pedido_seq_tr
BEFORE INSERT ON PEDIDO FOR EACH ROW 
WHEN (NEW.cod_pedido is NULL)
BEGIN
	SELECT pedido_seq.NEXTVAL INTO 
	:NEW.cod_pedido FROM DUAL;
END;
--------------------------------------------------------------------------
--TRIGGER PRODUTO_PEDIDO
DROP INDEX idx_fk_cod_produto; 
 CREATE INDEX idx_fk_cod_produto ON PRODUTO_PEDIDO (cod_produto);
DROP INDEX idx_fk_cod_pedido;
 CREATE INDEX idx_fk_cod_pedido ON PRODUTO_PEDIDO (cod_pedido);

--------------------------------------------------------------------------
--SEQUENCE CATEGORIA
DROP SEQUENCE categoria_seq;
CREATE SEQUENCE categoria_seq START WITH 1 INCREMENT BY 1;

--TRIGGER PEDIDO_ENTREGA
CREATE OR REPLACE TRIGGER categoria_seq_tr
BEFORE INSERT ON CATEGORIA FOR EACH ROW 
WHEN (NEW.cod_categoria is NULL)
BEGIN
	SELECT categoria_seq.NEXTVAL INTO 
	:NEW.cod_categoria FROM DUAL;
END;
--------------------------------------------------------------------------
--SEQUENCE FRETE
DROP SEQUENCE frete_seq;
CREATE SEQUENCE frete_seq START WITH 1 INCREMENT BY 1;

--TRIGGER FRETE
CREATE OR REPLACE TRIGGER frete_seq_tr
BEFORE INSERT ON FRETE FOR EACH ROW 
WHEN (NEW.cod_frete is NULL)
BEGIN
	SELECT categoria_seq.NEXTVAL INTO 
	:NEW.cod_frete FROM DUAL;
END;
--------------------------------------------------------------------------
--SEQUENCE FORNECEDORES
DROP SEQUENCE fornecedores_seq;
CREATE SEQUENCE fornecedores_seq START WITH 1 INCREMENT BY 1;

--TRIGGER FRETE
CREATE OR REPLACE TRIGGER fornecedores_seq_tr
BEFORE INSERT ON FORNECEDORES FOR EACH ROW 
WHEN (NEW.cod_fornecedores is NULL)
BEGIN
	SELECT fornecedores_seq.NEXTVAL INTO 
	:NEW.cod_fornecedores FROM DUAL;
END;
--------------------------------------------------------------------------
--FORENING KEY TRIGGER cliente
DROP INDEX idx_fk_cod_pedido_cliente; 
 CREATE INDEX idx_fk_cod_pedido_cliente ON CLIENTE (cod_pedido);
 --------------------------------------------------------------------------
--FORENING KEY TRIGGER produto
DROP INDEX idx_fk_cod_categoria; 
 CREATE INDEX idx_fk_cod_categoria ON PRODUTO (cod_categoria);
 --------------------------------------------------------------------------
--FORENING KEY TRIGGER pedido
DROP INDEX idx_fk_cod_cliente; 
 CREATE INDEX idx_fk_cod_cliente ON PEDIDO (cod_cliente);
 DROP INDEX idx_fk_cod_produto_pedido; 
 CREATE INDEX idx_fk_cod_produto_pedido ON PEDIDO (cod_produto);
 --------------------------------------------------------------------------
--FORENING KEY TRIGGER pedido
--DROP INDEX idx_fk_cod_produto_estoque; 
 --CREATE INDEX idx_fk_cod_produto_estoque ON ESTOQUE (cod_produto);