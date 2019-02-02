--Functions

--a.	Retornar o estoque atual de determinado produto (código do produto) e disparar uma exceção caso este produto esteja descontinuado;
CREATE OR REPLACE FUNCTION estoque_produto (in_cod_produto IN Number)
	return integer
AS
-- Declaracao de variavel
v_status Number;
v_estoque integer;

BEGIN
-- Codigo PL/SQL

-- Setando os valores para dentro das variáveis
	Select status Into v_status from produto 
	where cod_produto = in_cod_produto;

--Primeira verificação
	if v_status = 0 THEN
  		raise_application_error(-20000,'Produto Descontinuado');
	end if;

--Select do que o relatorio esta pedindo incluindo nas variaveis
	select e.quantidade into v_estoque
	from estoque e, produto p
	where p.cod_produto = e.cod_produto
    AND p.cod_produto = in_cod_produto;

return v_estoque;

END;

--Chamar a function estoque_produto
select estoque_produto(2) from dual;

-- b.	Retornar a soma de todos os estoques de produtos de determinada categoria (código da categoria);
CREATE OR REPLACE FUNCTION soma_estoque_produto (in_cod_categoria IN Number)
	return number
AS
-- Declaracao de variavel
v_quantidade number;

BEGIN
-- Codigo PL/SQL

--Select do que o relatorio esta pedindo incluindo nas variaveis
	select sum(e.quantidade) into v_quantidade
	from estoque e, produto p, categoria c
	where p.cod_produto = e.cod_produto
    AND c.cod_categoria = p.cod_categoria
    AND c.cod_categoria = in_cod_categoria;

return v_quantidade;

END;

--Chamar a function soma_estoque_produto
select soma_estoque_produto(3) from dual;

-- c.	Retornar o total de produtos enviados, mas ainda não entregues para determinado período de envio. Caso o período de envio seja maior que a data atual (SYSDATE), disparar uma exceção.
CREATE OR REPLACE FUNCTION total_produtos_enviados(in_cod_pedido IN NUMBER)
RETURN NUMBER
AS
 v_data_atual DATE DEFAULT SYSDATE;
 v_data_envio DATE;
 v_quantidade NUMBER;
BEGIN

  select data_envio into v_data_envio from pedido 
  where cod_pedido = in_cod_pedido;
  
  if v_data_envio > v_data_atual THEN
     raise_application_error(-20000,'Data do Envio Maior que data atual');
	end if;
  
  select pp.quantidade into v_quantidade
  from produto_pedido pp, produto pr, pedido p
  where pp.cod_produto = pr.cod_produto
    AND pp.cod_pedido = p.cod_pedido
    AND p.cod_pedido = in_cod_pedido;

  return v_quantidade; 
  
END;

--Chamar a function total_produtos_enviados
SELECT total_produtos_enviados(27) FROM DUAL;