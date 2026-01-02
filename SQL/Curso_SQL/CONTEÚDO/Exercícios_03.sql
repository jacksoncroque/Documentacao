-- QUAL CATEGORIA DE PRODUTO FOI MAIS VENDIDA?

SELECT t1.idTransacaoProduto,
       t2.DescCategoriaProduto,
       count(DISTINCT t1.IdTransacao)
FROM transacao_produto AS t1

LEFT JOIN produtos AS t2
ON t1.IdProduto = t2.IdProduto

GROUP BY DescCategoriaProduto
ORDER BY count(DISTINCT t1.IdTransacao) DESC
LIMIT 1;

--EM 2024 QUANTAS TRANSAÇÕES DE LOVERS HOUVERAM?

SELECT t3.DescCategoriaProduto,
       count(t3.DescCategoriaProduto)
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos as t3
ON t2.IdProduto = t3.IdProduto

WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'
GROUP BY t3.DescCategoriaProduto
ORDER BY count(DISTINCT t1.IdTransacao) DESC;

-- QUAL MÊS TEVE MAIS LISTA DE PRESENÇA ASSINADA?

SELECT t1.IdTransacao,
       t1.DtCriacao,
       t3.DescNomeProduto,
       substr(DtCriacao,1,7) AS AnoMes,
       count(DISTINCT t1.IdTransacao) AS qntdTransacao
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE DescNomeProduto = 'Lista de presença'

GROUP BY substr(DtCriacao,1,7) 
ORDER BY count(DISTINCT t1.IdTransacao) DESC

LIMIT 100;

-- QUAIS CLIENTES PERDERAM PONTOS POR 'LOVER'?

SELECT t1.idCliente,
       --t1.IdTransacao,
       --t2.IdProduto,
       --t3.DescCategoriaProduto,
       --t3.DescNomeProduto,
       --t1.qtdePontos,
       sum(t1.qtdePontos) AS qntdPontos

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE DescCategoriaProduto = 'lovers'

GROUP BY t1.idCliente

ORDER BY sum(t1.qtdePontos) ASC

LIMIT 10;

-- QUAIS CLIENTES ASSINARAM A LISTA DE PRESENÇA NO DIA 2025/08/25?

SELECT t1.idCliente,
       substr(t1.DtCriacao, 1, 10) AS dtCriacao,
       t3.DescNomeProduto
FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE substr(t1.DtCriacao, 1, 10) = '2025-08-25'
AND DescNomeProduto = 'Lista de presença'

GROUP BY t1.idCliente;

-- Do início ao fim do nosso curso (2025/08/25 a 2025/08/29), quantos clientes
-- assinaram a lista de presença?

SELECT t1.idCliente,
       substr(t1.DtCriacao, 1, 10) AS dtCriacao,
       t3.DescNomeProduto,
       count(DISTINCT t1.idCliente)

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE DtCriacao >= '2025-08-25'
AND DtCriacao < '2025-08-29'
AND DescNomeProduto = 'Lista de presença'

GROUP BY t1.idCliente;