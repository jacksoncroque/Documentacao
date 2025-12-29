/* SELECT SUM (qtdePontos)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
AND qtdePontos >0
ORDER BY DtCriacao DESC */

SELECT sum (qtdePontos),
    sum (CASE
        WHEN qtdePontos > 0 THEN QtdePontos
    END) AS qtdePontosPositivos,
    sum (CASE
        WHEN QtdePontos < 0 THEN qtdePontos
    END) AS qtdePontosNegativos
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY qtdePontos
