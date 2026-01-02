-- LISTA DAS TRANSAÇÕES QUE COM O PRODUTO 'RESGATAR PONEI'

SELECT *

FROM transacao_produto AS t1

WHERE t1.IdProduto IN (
    SELECT IdProduto
    FROM produtos
    WHERE DescNomeProduto = 'Resgatar Ponei'
    );

--  Dos clientes que começaram o curso de SQL quantos chegaram no 5o dia?

SELECT count(DISTINCT idCliente)

FROM transacoes AS t1

WHERE IdCliente IN(
SELECT DISTINCT idCliente

FROM transacoes

WHERE substr(DtCriacao, 1,10) = '2025-08-25'
)
AND substr(DtCriacao, 1, 10) = '2025-08-29'
