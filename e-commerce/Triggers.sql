--5)	Criar triggers:
--a.	Ao excluir pedido, não efetivar caso este já possua data de envio preenchida.
create or replace trigger controla_exclusao_pedido
	before delete
	on PEDIDO
	for each row
	
begin
	if :old.data_envio is not null then
	raise_application_error (-20001, 'Não foi possivel excluir, pedido já enviado!');
	else
	dbms_output.put_line('Pedido Deletado com sucesso');
end if;
end controla_exclusao_pedido;

--b.	Ao excluir cliente, não efetivar caso este ainda possua pedidos não enviados ou entregues.
--c.	Criar uma tabela chamada alerta que armazenará: código sequencial, data, código do produto, nome do produto, estoque atual e estoque mínimo.
--i.	Inserir registro nessa tabela quando houver UPDATE na tabela estoque e o valor da coluna quantidade tenha ficado menor que o estoque_minimo.
--ii.	Remover registro caso o estoque de determinado produto volte a ficar superior ou igual ao mínimo.
