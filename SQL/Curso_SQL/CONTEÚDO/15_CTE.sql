-- Dos clientes que iniciaram o curso, quantos chegaram na 5a aula?

WITH tb_cliente_primeiro_dia AS (
    SELECT DISTINCT idCliente
    FROM transacoes 
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'

), 

tb_cliente_ultimo_dia AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-29'

)

SELECT *
FROM tb_cliente_primeiro_dia AS t1
LEFT JOIN tb_cliente_ultimo_dia AS t2
ON t1.idCliente = t2.idCliente;

-- Quem iniciou o curso no primeiro dia, em média assistiu quantas aulas?

WITH tb_primeiro_dia AS (

    SELECT * 
    FROM transacoes
    WHERE substr(DtCriacao,1 ,10) = '2025-08-25'
-- QUEM PARTICIPOU DA PRIMEIRA AULA
),

tb_dias_curso AS (

    SELECT DISTINCT 
           idCliente,
           substr(DtCriacao, 1, 10) AS presenteDia
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    ORDER BY idCliente, presenteDia
-- QUEM PARTICIPOU DO CURSO INTEIRO
),
tb_cliente_dia AS (

    SELECT t1.idCliente,
        count(DISTINCT t2.presenteDia) AS QntdDias
    FROM tb_primeiro_dia AS t1
    LEFT JOIN tb_dias_curso AS t2
    ON t1.idCliente = t2.idCliente

    GROUP BY t1.idCliente
-- CONTAGEM DE QUANTAS VEZES QUEM PARTICIPOU DO 1o DIA VOLTOU
)

SELECT avg(QntdDias)
FROM tb_cliente_dia;
-- CÁLCULO DA MÉDIA