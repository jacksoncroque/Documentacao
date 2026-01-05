-- CUIDADO AO FAZER UPDATES, TALVEZ NÃO TENHA VOLTA
------------- OBRIGATÓRIO USAR WHERE---------------

SELECT *
FROM relatorio_diario;

UPDATE relatorio_diario
SET qntdTransacao = 100
WHERE dtDia = '2025-08-25';

SELECT *
FROM relatorio_diario
WHERE dtDia = '2025-08-25';

