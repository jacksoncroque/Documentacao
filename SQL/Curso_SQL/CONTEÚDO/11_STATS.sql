SELECT 
    round(avg(qtdePontos), 2) AS MediaCarteira,
    sum(qtdePontos) / count(idCliente) AS MediaCarteiraRoots,
    min(qtdePontos) AS MinCarteira,
    max(qtdePontos) AS MaxCarteira,
    sum(flTwitch),
    sum(flEmail)
FROM clientes;
