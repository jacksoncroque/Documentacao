-- SELECT *, qtdePontos + 10 AS QntdPontosPlus10
-- FROM clientes

SELECT idCliente, 
       DtCriacao,
       Substr(DtCriacao, 1, 10) AS StringCriacaoNova, -- Fatia a informação
       Datetime(Substr(DtCriacao, 1, 10)) AS DtCriacaoNova,
       Strftime ('%w', Datetime(Substr(DtCriacao, 1, 10))) AS DiaDaSemana -- Tranforma em data
FROM clientes;

