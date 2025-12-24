-- SELECIONE TODOS OS CLIENTES COM EMAIL CADASTRADO

/* SELECT * 
FROM clientes 
WHERE flEmail = '1'; */

--WHERE flEmail != '1';
--WHERE flEmail <> 0;

-- SELECIONE TODAS AS TRANSACOES DE 50 PONTOS

/*SELECT *
FROM transacoes
WHERE qtdePontos = 50*/ 

-- SELECIONE TODOS OS CLIENTES COM MAIS DE 500 PONTOS

/* SELECT idCliente, qtdePontos 
FROM clientes
WHERE qtdePontos> 500 */

-- SELECIONE PRODUTOS QUE CONTENHAM CHURN NO NOME

-- Churn_5pp
-- Churn_2pp
-- Churn_10pp

/* SELECT *
FROM produtos
WHERE DescNomeProduto = 'Churn_5pp'
OR DescNomeProduto = 'Churn_2pp'
OR DescNomeProduto = 'Churn_10pp' */

/* SELECT * 
FROM produtos 
WHERE DescNomeProduto IN ('Churn_5pp', 'Churn_2pp', 'Churn_10pp'); */

SELECT * 
FROM produtos
WHERE DescNomeProduto 
LIKE 'Churn%';


