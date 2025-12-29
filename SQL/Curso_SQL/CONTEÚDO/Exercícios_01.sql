--LISTE TODAS AS TRANSAÇÕES DE APENAS 1 PONTO
SELECT * 
FROM transacoes
WHERE qtdePontos = 1;

--LISTE TODOS OS PEDIDOS REALIZADOS NO FIM DE SEMANA
SELECT * , Strftime ('%w', Datetime(Substr(DtCriacao, 1, 10))) AS DiasDaSemana
FROM transacoes
WHERE Strftime ('%w', Datetime(Substr(DtCriacao, 1, 10))) IN ('0', '6');

--LISTE TODOS OS CLIENTES COM ZERO PONTOS
SELECT idCliente, qtdePontos
FROM clientes
WHERE QtdePontos = 0;

--LISTE TODOS OS CLIENTES COM 100 A 200 PONTOS (INCLUSIVE AMBOS)
SELECT *
FROM clientes
WHERE qtdePontos>=100 AND qtdePontos<=200;

--LISTE TODOS OS REGISTROS QUE COMEÇAM COM 'VENDA DE'
SELECT * 
FROM produtos
WHERE DescNomeProduto LIKE 'Venda de%';

--LISTE TODOS OS PRODUTOS COM NOME TERMINADO EM 'LOVER'
SELECT *
FROM produtos
Where DescNomeProduto LIKE '%Lover';

--LISTE TODOS OS PRODUTOS QUE SÃO UM CHAPÉU
SELECT * 
FROM produtos
WHERE DescNomeProduto LIKE '%Chapéu%';

--LISTE TODAS AS TRANSAÇÕES COM O PRODUTO RESGATAR PONEI
SELECT *
FROM transacao_produto
WHERE IdProduto = 15

/* LISTAR TODAS AS TRANSAÇÕES ADICIONANDO UMA COLUNA NOVA SINALIZANDO “ALTO”, “MÉDIO” E “BAIXO” PARA O
 VALOR DOS PONTOS (<10; <500; >=500) */
SELECT idCliente,
       qtdePontos,
       IdTransacao,
       CASE      
              WHEN QtdePontos < 10 THEN 'BAIXO'    
              WHEN qtdePontos < 500 THEN 'MÉDIO'
              ELSE 'ALTO'
              END AS FlQntdPontos
FROM transacoes
ORDER BY QtdePontos DESC

 SELECT *, QtdePontos>=500 AS 'ALTO',
        QtdePontos<10 AS 'BAIXO',
        QtdePontos<500 AND QtdePontos>10 AS 'MÉDIO'
 FROM transacoes