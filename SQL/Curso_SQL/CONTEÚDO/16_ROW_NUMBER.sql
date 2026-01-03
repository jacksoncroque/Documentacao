-- Qual o dia do curso com maior engajamento de cada aluno?

WITH alunos_dia01 AS (
    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

tb_dia_cliente AS (
    SELECT t1.idCliente,
        substr(t2.DtCriacao, 1, 10) AS dtDia,
        count(*) AS qntdInteracoes
    FROM alunos_dia01 AS t1
    LEFT JOIN transacoes AS t2
    ON t1.idCliente = t2.idCliente
    AND t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao <'2025-08-30'

    GROUP BY t1.idCliente, substr(t2.DtCriacao, 1, 10)
),
    max_Interacoes AS (
    SELECT idCliente,
           max(qntdInteracoes) AS maxInter
    FROM tb_dia_cliente
    GROUP BY idCliente
),
tb_rn AS (
SELECT *,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qntdInteracoes DESC, dtDia) AS rn
FROM tb_dia_cliente
)

SELECT *
FROM tb_rn
WHERE rn = 1