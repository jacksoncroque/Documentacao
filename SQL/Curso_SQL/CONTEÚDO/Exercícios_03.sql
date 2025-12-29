-- Qual categoria de produti foi mais vendida?

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

LIMIT 100