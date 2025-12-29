/*SELECT *
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC

OU*/

SELECT COUNT(*),
       COUNT (DISTINCT IdCliente),
       COUNT (DISTINCT IdTransacao)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC
