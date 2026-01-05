--DROP TABLE IF EXISTS clientes_d28;

CREATE TABLE IF NOT EXISTS cliente_d28 (
    idCliente varchar(250) PRIMARY KEY,
    qntdTransacao INTEGER
);
DELETE FROM cliente_d28;

INSERT INTO cliente_d28
SELECT
    idCliente,
    count(DISTINCT IdTransacao) AS qntdTransacao
    
FROM transacoes
WHERE julianday('now') - julianday(strftime(substr(DtCriacao, 1, 10))) <= 28
GROUP BY idCliente;

SELECT *
FROM cliente_d28