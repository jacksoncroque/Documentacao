-- Quantos clientes têm email cadastrado?

SELECT count(*),
    CASE
        WHEN flEmail = 1 THEN 'Possui'
        ELSE 'Não Possui'
        END AS flEmail
FROM clientes
GROUP BY flEmail;

-- Qual cliente juntou mais pontos positivos em 2025-05?

SELECT idCliente,
       sum(qtdePontos) AS TotalPontos
FROM transacoes
WHERE DtCriacao >= '2025-05-01'
AND DtCriacao < '2025-06-01'
AND qtdePontos > 0
GROUP BY idCliente
ORDER BY sum(qtdePontos) DESC
LIMIT 1;


-- Qual cliente fez mais transações no ano de 2024?

SELECT idCliente,
       count(DISTINCT IdTransacao) AS TotalTransações
FROM transacoes
WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'
GROUP BY idCliente
ORDER BY count (IdTransacao) DESC
LIMIT 1;

-- Quantos produtos são do RPG?

SELECT DescCategoriaProduto,
       count (*)
FROM produtos
GROUP BY DescCategoriaProduto;


-- Qual o valor médio de pontos positivos por dia?

SELECT qtdePontos,
       DtCriacao,
       sum(qtdePontos) AS TotalPontos,
       count(DISTINCT(substr(DtCriacao, 1, 10))) AS QntdDiasUnicos,
       sum(qtdePontos) / count(DISTINCT(substr(DtCriacao, 1, 10))) AS AvgQntdDia
FROM transacoes
WHERE QtdePontos> 0;

-- Qual dia da semana teve mais pedidos em 2025?

SELECT strftime('%w', substr(DtCriacao, 1,10)) AS DiaSemana,
       count(DISTINCT IdTransacao) AS TransaçãoDia
FROM transacoes
WHERE substr (DtCriacao, 1, 4) ='2025'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Qual o produto mais transacionado?

SELECT IdProduto,
    IdTransacao,
    count(*) AS Contagem
FROM transacao_produto
GROUP BY IdProduto
ORDER BY 3 DESC
LIMIT 1;

-- Qual o produto com mais pontos transacionados?

SELECT IdProduto,
       SUM(vlProduto * QtdeProduto)
FROM transacao_produto
GROUP BY IdProduto 
ORDER BY SUM(vlProduto * QtdeProduto) DESC;