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

-----------------------------------------------

WITH tb_clientes_d1 AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'

)

SELECT substr(t2.DtCriacao,1, 10) AS dtDia,
       count(DISTINCT t1.idCliente) AS qntdCliente
FROM tb_clientes_d1 AS t1
LEFT JOIN transacoes AS t2
ON t1.idCliente = t2.IdCliente

WHERE t2.DtCriacao >= '2025-08-25'
AND t2.DtCriacao < '2025-08-30' 

GROUP BY dtDia;

--Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?

WITH tb_clientes_janeiro AS (

    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE DtCriacao >='2025-01-01'
    AND DtCriacao <'2025-02-01'
    ),
tb_clientes_curso AS (

SELECT DISTINCT idCliente
FROM transacoes
WHERE DtCriacao >='2025-08-25'
AND DtCriacao < '2025-08-30'

)

SELECT count(DISTINCT t1.idCliente) as ClientesJaneiro,
       count(DISTINCT t2.idCliente) as ClientesCurso
FROM tb_clientes_janeiro AS t1
LEFT JOIN tb_clientes_curso AS t2
ON t1.idCliente = t2.idCliente;

