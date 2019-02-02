--PROCEDURES
--a.	modificar_estoque(cod_produto IN NUMBER, quantidade IN NUMBER)
--i.	Disparar exceção caso não exista o cod_produto informado;
--ii.	Não permitir estoque negativo;
CREATE OR REPLACE PROCEDURE modificar_estoque (in_cod_produto in number)
IS
v_cod_produto NUMBER;
v_quantidade NUMBER;

BEGIN
  
  SELECT cod_produto into v_cod_produto from estoque
  where cod_produto = in_cod_produto;
  
  select quantidade into v_quantidade from estoque
  where cod_produto = in_cod_produto;
  
  if v_cod_produto IS null THEN
    raise_application_error(-20000,'Produto se Codigo');
	end if;
  
  if v_quantidade < 0 THEN
    raise_application_error(-20000,'Quantidade Negativa');
	end if;

END modificar_estoque;

--Chamar a procedure modificar_estoque;
begin
  modificar_estoque(4);
end;

--b.	criar_pedido(data_pedido IN DATE)
--i.	Deve incluir dados nas tabelas de pedido;
--ii.	Deve retornar como OUT o código do pedido gerado.
CREATE OR REPLACE PROCEDURE criar_pedido(
	   p_data_pedido IN PEDIDO.data_pedido%TYPE,
	   p_prazo_entrega IN PEDIDO.prazo_entrega%TYPE,
     p_data_envio IN PEDIDO.data_envio%TYPE,
     p_data_entrega IN PEDIDO.data_entrega%TYPE,
     p_valor_frete IN PEDIDO.valor_frete%TYPE,
     p_desconto IN PEDIDO.desconto%TYPE,
     p_cod_cliente IN PEDIDO.cod_cliente%TYPE,
     p_cod_produto IN PEDIDO.cod_produto%TYPE,
     p_cod_pedido OUT PEDIDO.cod_pedido%TYPE )
IS
BEGIN

  INSERT INTO PEDIDO (data_pedido, prazo_entrega, data_envio, data_entrega, valor_frete, desconto, cod_cliente, cod_produto)
  VALUES (p_data_pedido, p_prazo_entrega, p_data_envio, p_data_entrega, p_valor_frete, p_desconto, p_cod_cliente, p_cod_produto);

  --COMMIT;

END criar_pedido;

--c.	incluir_produto_pedido(cod_pedido IN NUMBER, cod_produto IN NUMBER, quantidade IN NUMBER, desconto IN NUMBER)
--i.	Deve disparar uma exceção caso o cod_pedido não existir ou produto estiver sem estoque, não executando as demais ações;
--ii.	Deve dar baixa na quantidade em estoque do produto indicado;
--iii.	Por padrão, deverá setar desconto como zero caso usuário passe valor null.
CREATE OR REPLACE PROCEDURE incluir_produto_pedido 
                  (
                  p_cod_produto IN NUMBER,
                  p_cod_pedido IN NUMBER,
                  p_quantidade IN NUMBER,
                  p_desconto IN PRODUTO_PEDIDO.desconto%TYPE
                  )
IS

v_cod_pedido NUMBER;
v_quantidade NUMBER;
v_cod_produto NUMBER;
v_desconto NUMBER;

BEGIN

  SELECT cod_pedido INTO v_cod_pedido FROM produto_pedido
  WHERE cod_pedido = p_cod_pedido;

  IF v_cod_pedido is null THEN
    raise_application_error(-20000,'Coluna COD_PEDIDO Não EXISTE');
  END IF;
  
  SELECT quantidade INTO v_quantidade FROM ESTOQUE
  WHERE cod_produto = p_cod_produto;
  
  IF v_quantidade <= 0 THEN
     raise_application_error(-20000,'Quantidade de Estoque de Produto Zerada');
  END IF;
  
  IF p_desconto IS NULL THEN
    v_desconto := 0;
  ELSE
    v_desconto := p_desconto;  
  END IF;

  INSERT INTO PRODUTO_PEDIDO (cod_produto, cod_pedido, quantidade, desconto)
  VALUES (p_cod_produto, p_cod_pedido, p_quantidade, v_desconto);
  
  SELECT cod_produto INTO v_cod_produto FROM PRODUTO
  WHERE cod_produto = p_cod_produto;
  
  IF v_cod_produto = p_cod_produto THEN
    UPDATE estoque set quantidade = quantidade - p_quantidade
    where cod_produto = p_cod_produto;
  END IF;

END incluir_produto_pedido;

--d.	definir_entrega(cod_pedido IN NUMBER, nome_destinatario IN VARCHAR2, endereco_destinatario IN VARCHAR2, cidade IN VARCHAR2, uf IN CHAR(2), cep CHAR(9))
--i.	Incluir dados na tabela pedido_entrega e setar o valor do frete na tabela pedido, conforme o valor presente na tabela de frete, bem como o prazo_entrega.
CREATE OR REPLACE PROCEDURE definir_entrega
                            (
                            p_cod_pedido IN NUMBER,
                            p_nome_destinatario IN VARCHAR2,
                            p_endereco_destinatario IN VARCHAR2,
                            p_cidade IN VARCHAR2,
                            p_uf IN CHAR,
                            p_cep IN NUMBER
                            )
IS

v_valor NUMBER;
v_cidade VARCHAR2;
BEGIN

  INSERT INTO pedido_entrega (cod_pedido, nome_destinatario, endereco_destinatario, cidade, uf, cep)
  VALUES (p_cod_pedido, p_nome_destinatario, p_endereco_destinatario, p_cidade, p_uf, p_cep);
  
  SELECT cidade INTO v_cidade FROM FRETE
  WHERE uf = p_uf;
  
  --IF cod_pedido = p_cod_pedido THEN
    
  
  
  --  UPDATE FRETE set valor = v_valor
  --  where cod_produto = p_cod_produto;
 -- END IF;
  

END definir_entrega;



--e.	devolucao_pedido(cod_pedido IN NUMBER)
--i.	Deve atualizar os estoques dos produtos pertencentes ao pedido;
--a)	Usar CURSOR!
--ii.	Deve remover a entrada da tabela pedido_entrega;
--iii.	Deve remover a entrada da tabela produto_pedido;
--iv.	Setar a data de envio para vazio na tabela pedido;
--v.	Por fim, deverá remover a entrada da tabela pedido.