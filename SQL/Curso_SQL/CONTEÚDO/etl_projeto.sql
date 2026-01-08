-- Feature Store por cliente (base até 2025-07-01)

DROP TABLE IF EXISTS tb_feature_store_cliente;

CREATE TABLE tb_feature_store_cliente AS
WITH tb_transacoes AS (

    SELECT IdTransacao,
           IdCliente,
           qtdePontos,
           datetime(substr(DtCriacao, 1, 19)) AS DtCriacao,
           julianday('2025-07-01') - julianday(substr(DtCriacao, 1, 10)) AS diffTime,
           CAST(strftime('%H', substr(DtCriacao, 1, 19)) AS INTEGER) AS dtHora
    FROM transacoes
    WHERE DtCriacao < '2025-07-01'
),

tb_cliente AS (

    SELECT idCliente,
           julianday('2025-07-01') - julianday(substr(DtCriacao, 1, 10)) AS idadeBase
    FROM clientes
),

tb_sumario_transacoes AS (

    SELECT idCliente,
           COUNT(IdTransacao) AS qntdTransacoesVida,
           COUNT(CASE WHEN diffTime <= 56 THEN 1 END) AS qntdTransacao56,
           COUNT(CASE WHEN diffTime <= 28 THEN 1 END) AS qntdTransacao28,
           COUNT(CASE WHEN diffTime <= 14 THEN 1 END) AS qntdTransacao14,
           COUNT(CASE WHEN diffTime <= 7  THEN 1 END) AS qntdTransacao7,
           MIN(diffTime) AS diaUltimaTransacao,
           SUM(qtdePontos) AS SaldoPontos
    FROM tb_transacoes
    GROUP BY idCliente
),

tb_transacao_produto AS (

    SELECT t1.IdTransacao,
           t1.IdCliente,
           t1.diffTime,
           t3.DescNomeProduto
    FROM tb_transacoes t1
    LEFT JOIN transacao_produto t2 ON t1.IdTransacao = t2.IdTransacao
    LEFT JOIN produtos t3 ON CAST(t2.IdProduto AS INTEGER) = CAST(t3.IdProduto AS INTEGER)
),

tb_cliente_produto AS (

    SELECT idCliente,
           DescNomeProduto,
           COUNT(*) AS qntdVida,
           COUNT(CASE WHEN diffTime <= 28 THEN 1 END) AS qntd28
    FROM tb_transacao_produto
    GROUP BY idCliente, DescNomeProduto
),

tb_cliente_produto_rn AS (

    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qntdVida DESC) AS rnVida,
           ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qntd28 DESC) AS rn28
    FROM tb_cliente_produto
),

tb_cliente_periodo AS (

    SELECT IdCliente,
           CASE 
               WHEN dtHora BETWEEN 7  AND 12 THEN 'Manhã'
               WHEN dtHora BETWEEN 13 AND 18 THEN 'Tarde'
               WHEN dtHora BETWEEN 19 AND 23 THEN 'Noite'
               ELSE 'Madrugada'
           END AS periodo,
           COUNT(*) AS qntd
    FROM tb_transacoes
    WHERE diffTime <= 28
    GROUP BY IdCliente, periodo
),

tb_cliente_periodo_rn AS (

    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qntd DESC) AS rnPeriodo
    FROM tb_cliente_periodo
),

tb_join AS (

    SELECT t1.idCliente,
           t1.qntdTransacoesVida,
           t1.qntdTransacao56,
           t1.qntdTransacao28,
           t1.qntdTransacao14,
           t1.qntdTransacao7,
           t1.diaUltimaTransacao,
           t1.SaldoPontos,
           t2.idadeBase,
           p1.DescNomeProduto AS produtoVida,
           p2.DescNomeProduto AS produto28,
           COALESCE(pr.periodo, 'Madrugada') AS periodo28
    FROM tb_sumario_transacoes t1
    LEFT JOIN tb_cliente t2 ON t1.idCliente = t2.idCliente
    LEFT JOIN tb_cliente_produto_rn p1 ON t1.idCliente = p1.idCliente AND p1.rnVida = 1
    LEFT JOIN tb_cliente_produto_rn p2 ON t1.idCliente = p2.idCliente AND p2.rn28 = 1
    LEFT JOIN tb_cliente_periodo_rn pr ON t1.idCliente = pr.IdCliente AND pr.rnPeriodo = 1
)

SELECT *,
       '2025-07-01' AS dtReff,
       1.0 * qntdTransacao28 / NULLIF(qntdTransacoesVida, 0) AS engajamento28Vida
FROM tb_join;

SELECT *
FROM tb_feature_store_cliente