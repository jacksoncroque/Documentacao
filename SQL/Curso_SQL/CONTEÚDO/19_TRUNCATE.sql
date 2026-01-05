DELETE FROM relatorio_diario;

/* TRUNCATE é um comando SQL usado para apagar todos os registros de uma tabela de forma
rápida e definitiva, mantendo a estrutura da tabela (colunas, tipos, índices). 

Dá para fazer DELETE FROM também de dados específicos, supondo que eu queria a table relatorio_diario
mas sem contar algum da semana */

DELETE FROM relatorio_diario
WHERE strftime('%w', substr(dtDia, 1, 10)) = '0';

SELECT *
FROM relatorio_diario
