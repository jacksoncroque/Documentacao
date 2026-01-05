-- Quantidade de transações acumuladas ao longo do tempo?
DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS
WITH tb_diario AS (
    SELECT 
        substr(DtCriacao, 1, 10) as dtDia,
        count(DISTINCT IdTransacao) as qntdTransacao
    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
)

SELECT *,
       sum(qntdTransacao) OVER(ORDER BY dtDia) AS qntdTransacaoAcumulada
FROM tb_diario;

SELECT *
FROM relatorio_diario;