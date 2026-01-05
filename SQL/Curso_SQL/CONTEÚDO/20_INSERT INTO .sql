DELETE FROM relatorio_diario;

WITH tb_diario AS (
    SELECT 
        substr(DtCriacao, 1, 10) as dtDia,
        count(DISTINCT IdTransacao) as qntdTransacao
    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),
tb_acum AS (

SELECT *,
       sum(qntdTransacao) OVER(ORDER BY dtDia) AS qntdTransacaoAcumulada
FROM tb_diario
)

INSERT INTO relatorio_diario

SELECT *
FROM tb_acum;

SELECT *
FROM relatorio_diario;

--ATENÇÃO QUANTO AO INSERT, SEM UM DELETE INICIL, O COMANDO PODE
--TRAZER INFORMAÇÕES DUPLICADAS;