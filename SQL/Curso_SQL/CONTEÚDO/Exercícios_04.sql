-- Como foi a curva de Churn do Curso de SQL?
SELECT
    substr (DtCriacao, 1, 10) AS dtDIA,
    count(DISTINCT idCliente) AS qntdDeCliente

FROM
    transacoes
WHERE
    DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

GROUP BY substr (DtCriacao, 1, 10);

WITH tb_clientes_d1 AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'

),

SELECT *
FROM tb_clientes_d1 AS t1
LEFT JOIN transacoes AS t2
ON t1.idCliente = t2.IdCliente

WHERE DtCriacao >= '2025-08-25'
AND DtCriacao < '2025-08-30' 