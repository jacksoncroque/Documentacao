-- Transações acumuladas durante a data do curso 

WITH tb_sumario_dias AS (

    SELECT substr(DtCriacao, 1, 10) AS dtDia,
        count(DISTINCT IdTransacao) AS qntdTransacao
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    GROUP BY dtDia
)

SELECT *,
       sum(qntdTransacao) OVER(ORDER BY dtDia) as qntdTransacaoAcumulada
FROM tb_sumario_dias

-- Quantidade de transações por pessoa ao dia

WITH tb_cliente_dia AS (
    SELECT idCliente,
        substr(DtCriacao, 1, 10) AS dtDia,
        count(DISTINCT IdTransacao) as qntdTransacao
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    GROUP BY idCliente, dtDia
)

SELECT *,
       sum(qntdTransacao) OVER(PARTITION BY IdCliente ORDER BY dtDia) AS transAcumulada,
       lag(qntdTransacao) OVER(PARTITION BY IdCliente ORDER BY dtDia) AS  lagTransacao
FROM tb_cliente_dia

-- Qual a recorrência que as pessoas assistem ao TéoMeWhy

WITH cliente_dia AS (

    SELECT DISTINCT idCliente,
        substr(DtCriacao, 1, 10) AS dtDia
    FROM transacoes
    WHERE substr(DtCriacao, 1, 4) = '2025'
    ORDER BY idCliente, dtDia 
),

tb_lag AS (

    SELECT *,
        lag(dtDia) OVER(PARTITION BY idCliente ORDER BY dtDia) AS lagDia
    FROM cliente_dia
),

tb_diff_dt  AS (

    SELECT *,
        julianday(dtDia) - julianday(lagDia) AS DiaDiff
    FROM tb_lag
),
avg_cliente AS (

    SELECT idCliente,
        avg(DiaDiff) as avgDia
    FROM tb_diff_dt
    GROUP BY IdCliente
)

SELECT avg(avgDia)
FROM avg_cliente