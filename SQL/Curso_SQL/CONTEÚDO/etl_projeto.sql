-- Quantidade de transações por cliente nos últimos = 7d, 14d, 28d, 56d e AllTime 

WITH tb_transacoes AS (

    SELECT IdTransacao,
           IdCliente,
           qtdePontos,
           datetime(substr(DtCriacao, 1, 19)) AS DtCriacao,
           julianday('now') - julianday(strftime(substr(DtCriacao, 1, 10))) AS diffTime,
           CAST(strftime('%H', substr(DtCriacao, 1, 19)) AS INTEGER) as dtHora

    FROM transacoes
),

tb_cliente AS (

    SELECT idCliente,
           datetime(substr(DtCriacao, 1, 10)) AS dtCriacao,
           julianday('now') - julianday(strftime(substr(DtCriacao, 1, 10))) AS idadeBase

    FROM clientes
),

tb_sumario_transacoes AS (

SELECT idCliente,
       count(IdTransacao) AS qntdTransacoesVida,
       count(CASE WHEN diffTime <= 56 THEN IdTransacao END) AS qntdTransacao56,
       count(CASE WHEN diffTime <= 28 THEN IdTransacao END) AS qntdTransacao28,
       count(CASE WHEN diffTime <= 14 THEN IdTransacao END) AS qntdTransacao14,
       count(CASE WHEN diffTime <= 7 THEN IdTransacao END) AS qntdTransacao7,

       min(diffTime) AS diaUltimaTransacao,

       sum(qtdePontos) AS SaldoPontos,

       sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS qntdPontosPosVida,
       sum(CASE WHEN QtdePontos > 0 AND diffTime < 56 THEN qtdePontos END) AS qntdPontosPosVida56, 
       sum(CASE WHEN QtdePontos > 0 AND diffTime < 28 THEN qtdePontos END) AS qntdPontosPosVida28, 
       sum(CASE WHEN QtdePontos > 0 AND diffTime < 14 THEN qtdePontos END) AS qntdPontosPosVida14, 
       sum(CASE WHEN QtdePontos > 0 AND diffTime < 7 THEN qtdePontos END) AS qntdPontosPosVida7,

       sum(CASE WHEN qtdePontos < 0 THEN qtdePontos ELSE 0 END) AS qntdPontosNegVida,
       sum(CASE WHEN QtdePontos < 0 AND diffTime < 56 THEN qtdePontos END) AS qntdPontosNegVida56, 
       sum(CASE WHEN QtdePontos < 0 AND diffTime < 28 THEN qtdePontos END) AS qntdPontosNegVida28, 
       sum(CASE WHEN QtdePontos < 0 AND diffTime < 14 THEN qtdePontos END) AS qntdPontosNegVida14, 
       sum(CASE WHEN QtdePontos < 0 AND diffTime < 7 THEN qtdePontos END) AS qntdPontosNegVida7


    FROM tb_transacoes
    GROUP BY idCliente
),

tb_transacao_produto AS (

    SELECT t1.*,
        t3.DescNomeProduto,
        t3.DescCategoriaProduto

    FROM tb_transacoes AS t1
    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON CAST(t2.IdProduto AS INTEGER) = CAST(t3.IdProduto AS INTEGER)
),

tb_cliente_produto AS (

SELECT idCliente,
       DescNomeProduto,
       count() AS qntdVida,
       count(CASE WHEN diffTime <=56 THEN IdTransacao END) AS qntd56,
       count(CASE WHEN diffTime <=28 THEN IdTransacao END) as qntd28,
       count(CASE WHEN diffTime <=14 THEN IdTransacao END) as qntd14,
       count(CASE WHEN diffTime <= 7 THEN IdTransacao END) as qntd7

FROM tb_transacao_produto
GROUP BY idCliente, DescNomeProduto

),

tb_cliente_produto_rn AS (

    SELECT *,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntdVida DESC) AS rnVida,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntd56 DESC) AS rn56,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntd28 DESC) AS rn28,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntd14 DESC) AS rn14,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntd7 DESC) AS rn7

    FROM tb_cliente_produto
),

tb_cliente_dia AS (


    SELECT idCliente,
        strftime('%w', DtCriacao) AS dtDia,
        count(*) AS qntdTransacao
    FROM tb_transacoes
    GROUP BY idCliente, dtDia
),

tb_cliente_dia_rn AS (

    SELECT *,
        row_number() OVER (PARTITION BY idCliente ORDER BY qntdTransacao DESC) AS rnDia

    FROM tb_cliente_dia
),

tb_cliente_periodo AS (

SELECT IdTransacao,
       IdCliente,
       CASE 
          WHEN dtHora BETWEEN 7 AND 12 THEN 'Manhã'
          WHEN dtHora BETWEEN 13 AND 18 THEN 'Tarde'
          WHEN dtHora BETWEEN 19 AND 23 THEN 'Noite'
          ELSE 'Madrugada'
        END AS periodo,
      count(*) AS qntdTransacao

FROM tb_transacoes
WHERE diffTime <= 28

GROUP BY 1,2
),

tb_cliente_periodo_rn AS (

    SELECT *,
        row_number() OVER(PARTITION BY idCliente ORDER BY qntdTransacao DESC) AS rnPeriodo

    FROM tb_cliente_periodo
),

tb_join AS (

    SELECT t1.*,
           t2.idadeBase,
           t3.DescNomeProduto AS DescVida,
           t4.DescNomeProduto AS Desc56,
           t5.DescNomeProduto AS Desc28,
           t6.DescNomeProduto AS Desc14,
           t7.DescNomeProduto AS Desc7,
           COALESCE(t8.dtDia, -1) AS dtDia,
           t9.periodo,
           COALESCE(t9.periodo, 'Madrugada') AS periodo28

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.idCliente = t2.idCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente AND t5.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente AND t6.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente AND t7.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente AND t8.rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.idCliente = t9.idCliente AND t9.rnPeriodo = 1

)

SELECT *,
       1. * periodo28 / qntdTransacoesVida AS engajamento28Vida
FROM tb_join
