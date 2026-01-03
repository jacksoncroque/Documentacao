-- Quantidade de transações acumuladas ao longo do tempo?

WITH tb_diario AS (
    SELECT substr(DtCriacao, 1, 10) as dtDia,
        count(DISTINCT IdTransacao) as qntdTransacao,
        IdTransacao
    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia

-- Primeiro descobre as transações acumuladas dia/dia
)

SELECT *,
       sum(qntdTransacao) OVER(ORDER BY dtDia) AS qntdTransacaoAcumulada
FROM tb_diario;

-- Soma as transações

--Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?

WITH cliente_diario AS (
    SELECT count(DISTINCT IdCliente) as qntdClientes,
           substr(DtCriacao, 1, 7) as dtDia
    FROM clientes
    GROUP BY dtDia
    ORDER BY dtDia
) 

SELECT *,
       sum(qntdClientes) OVER(ORDER BY dtDia) as qntdClientesAcumulados
FROM cliente_diario;

--Qual o dia da semana mais ativo de cada usuário?

WITH tb_cliente_semana AS (
    SELECT idCliente,
           strftime('%w',substr(DtCriacao, 1, 10)) as dtDia,
           count(DISTINCT IdTransacao) as qntdTransacao
    FROM transacoes
    GROUP BY idCliente, dtDia
),
    tb_rn AS (
    SELECT *,
           ROW_NUMBER () OVER(PARTITION BY idCliente ORDER BY dtDia DESC) AS rn 
    FROM tb_cliente_semana;
)

SELECT *
FROM tb_rn 
WHERE rn = 1 

--Saldo de pontos acumulados de cada usuario

WITH tb_clientes AS (
SELECT idCliente,
       sum(qtdePontos) AS totalPontos,
       substr(DtCriacao, 1, 10) AS dtDia
FROM transacoes
GROUP BY idCliente, dtDia
) 

SELECT *,
       sum(totalPontos) OVER(PARTITION BY idCliente ORDER BY dtDia DESC)  as saldoPontos
FROM tb_clientes
