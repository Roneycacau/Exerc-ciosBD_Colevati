
CREATE DATABASE selects
GO
USE selects
GO
 
CREATE TABLE funcionario(
id          INT				NOT NULL	IDENTITY(1,1),
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL	CHECK(numero > 0 AND numero < 100000),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL		CHECK(LEN(cep) = 8),
ddd         CHAR(2)         NULL		DEFAULT('11'),
telefone    CHAR(8)         NULL		CHECK(LEN(telefone) = 8),
data_nasc   DATETIME        NOT NULL	CHECK(data_nasc < GETDATE()),
salario     DECIMAL(7,2)    NOT NULL	CHECK(salario > 0.00)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL	IDENTITY(1001,1),
nome        VARCHAR(200)    NOT NULL	UNIQUE,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL,
CONSTRAINT chk_dt CHECK(data_fim > data_inicio),
PRIMARY KEY (id_funcionario, codigo_projeto),
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo)
)


--DBCC CHECKIDENT (nome_tabela, RESEED, novo_valor)
DBCC CHECKIDENT ('funcionario', RESEED, 0)
DBCC CHECKIDENT ('projeto', RESEED, 1001)

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',	'da Silva',	'R. Voluntários da Patria',	8150,	'Santana',	'05423110',	'76895248',	'15/05/1974',	4350.00),
('Cicrano',	'De Souza',	'R. Anhaia', 353,	'Barra Funda',	'03598770',	'99568741',	'25/08/1984',	1552.00),
('Beltrano',	'Dos Santos',	'R. ABC', 1100,	'Artur Alvim',	'05448000',	'25639854',	'02/06/1963',	2250.00)

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',	'De Souza',	'Avenida Águia de Haia', 4430,	'Artur Alvim',	'05448000',	NULL,	NULL,	'15/10/1975',	2804.00)

INSERT INTO projeto VALUES
('Implantação de Sistemas ','Colocar o sistema no ar'),
('Implantação de Sistemas Novos','Colocar o sistema novo no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)

INSERT INTO funcproj VALUES
(1, 1001, '18/04/2015', '30/04/2015'),
(3, 1001, '18/04/2015', '30/04/2015'),
(1, 1002, '06/05/2015', '10/05/2015'),
(2, 1002, '06/05/2015', '10/05/2015'),
(3, 1003, '11/05/2015', '13/05/2015')


INSERT INTO funcionario VALUES 
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','09/09/1990',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','65879852','19/08/1973',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','03/05/1982',4550.00)

-- -https://pastebin.com/Ys2YV0Jn

USE selects

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--Funções Importantes (Char e Datas)
--SUBSTRING & TRIM(RTRIM, LTRIM)
--SUBSTRING(CHAR, POSIÇÃO_INICIAL, QTD_POSIÇÕES)
SELECT SUBSTRING('Banco de Dados', 1, 5) AS sub
SELECT SUBSTRING('Banco de Dados', 7, 2) AS sub
SELECT SUBSTRING('Banco de Dados', 10, 5) AS sub

SELECT SUBSTRING('Banco de Dados', 1, 6) AS sub
SELECT RTRIM(SUBSTRING('Banco de Dados', 1, 6)) AS sub_rtrim

SELECT SUBSTRING('Banco de Dados', 6, 4) AS sub
SELECT LTRIM(RTRIM(SUBSTRING('Banco de Dados', 6, 4))) AS sub_lrtrim

SELECT SUBSTRING('Banco de Dados', 9, 6) AS sub
SELECT LTRIM(SUBSTRING('Banco de Dados', 9, 6)) AS sub_ltrim

SELECT GETDATE() AS hoje_agora
SELECT 
	CAST(SUBSTRING(CONVERT(CHAR(10), GETDATE(), 103),1,2) AS INT) 
	AS dia_hoje_convert
SELECT DAY(GETDATE()) AS dia_hoje
SELECT MONTH(GETDATE()) AS mes_hoje
SELECT YEAR(GETDATE()) AS ano_hoje
--DATEPART
SELECT DATEPART(DAY, GETDATE()) AS dia_hoje
SELECT DATEPART(MONTH, GETDATE()) AS mes_hoje
SELECT DATEPART(YEAR, GETDATE()) AS ano_hoje
SELECT DATEPART(WEEKDAY, GETDATE()) AS dia_semana_hoje
SELECT DATEPART(WEEK, GETDATE()) AS semana_ano_hoje
SELECT DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano_hoje

--DATEADD(TIPO_OPERAÇÃO, INCREMENTO, DATETIME) RET DATETIME
SELECT CONVERT(CHAR(10),DATEADD(DAY, 7, GETDATE()),103) AS daqui_1_semana
SELECT CONVERT(CHAR(10),DATEADD(MONTH, -1, GETDATE()),103) AS mes_passado

--DATEDIFF(TIPO, DATA_INICIAL, DATA_FINAL) RET INT
SELECT DATEDIFF(DAY, '20/05/2020', GETDATE()) AS qtd_dias,
		CASE WHEN (DATEDIFF(DAY, '20/05/2020', GETDATE()) - 7 > 0) THEN
			DATEDIFF(DAY, '20/05/2020', GETDATE()) - 7
		ELSE
			0
		END AS dias_passados,
		CASE WHEN (DATEDIFF(DAY, '20/05/2020', GETDATE()) - 7 > 0) THEN
			(DATEDIFF(DAY, '20/05/2020', GETDATE()) - 7) * 2.00 
		ELSE
			0.00
		END AS multa



--Consultar id, nome completo,
--endereco ==> logradouro, numero e o bairro (junto)
--CEP(XXXXX-XXX) mascarado, 
--com telefone mascarado
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		CASE WHEN (bairro IS NOT NULL) THEN
			logradouro+','+CAST(numero AS VARCHAR(5)) +' - ' + bairro 
		ELSE 
			logradouro+','+CAST(numero AS VARCHAR(5))	
		END AS endereco,
		SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep,		
		CASE WHEN (CAST(SUBSTRING(telefone,1,1) AS INT) >= 6) THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4) 
		ELSE
			'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4) 
		END AS telefone,
		CONVERT(CHAR(10), data_nasc, 103) AS data_nasc
FROM funcionario
--WHERE id % 2 <> 0

--Qualquer operação com NULL (INT, CHAR, DATE) RET NULL

--1o digito 6,7,8 ou 9 , ganha um 9 na frente
--CASE 2 formas
/* 
Forma 1:
coluna = CASE(valor)
	WHEN numero			THEN resultado
	WHEN outro_numero	THEN outro_resultado
	WHEN mais_um_numero	THEN mais_um_resutado
	ELSE resultado_nao_previsto_anteriormente
END

Forma 2:
CASE WHEN (TESTE_LÓGICO) THEN
	RESULTADO_SE_VERDADEIRO
ELSE
	RESULTADO_SE_FALSO
END AS alias_coluna

CASE WHEN (TESTE_LÓGICO) THEN
	RESULTADO_SE_VERDADEIRO
ELSE
	CASE WHEN (TESTE_LÓGICO2) THEN
		RESULTADO_SE_VERDADEIRO
	ELSE
		RESULTADO_SE_FALSO
	END
END AS alias_coluna
*/

SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		telefone = CASE(CAST(SUBSTRING(telefone,1,1) AS INT))
			WHEN 6 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			WHEN 7 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			WHEN 8 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			WHEN 9 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE
			'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END
FROM funcionario


--Consultar id, nome completo e telefone mascarado XXXX-XXXX, com ddd
--(XX)XXXX-XXXX

--Caso seja celular ?

--Pode melhorar ?

--id, Consultar nome completo, 
--com endereço completo com bairro (possível NULL)

--Consultar nome completo, endereço completo, cep mascarado, 
--telefone com ddd mascarado e validação de celular




--Quantos dias trabalhados, por funcionário em cada projeto
--Ganham R$75.00 / dia trabalhado
SELECT id_funcionario, 
		codigo_projeto, 
		DATEDIFF(DAY, data_inicio, data_fim) AS dias_trabalhados,
		DATEDIFF(DAY, data_inicio, data_fim) * 75.00 AS salario
FROM funcproj

--Funcionario 3 do projeto 1003 pediu mais 3 dias para finalizar 
--o projeto, 
--qual será sua nova data final, convertida (BR) ?
SELECT CONVERT(CHAR(10), data_fim, 103) AS data_fim,
		CONVERT(CHAR(10), DATEADD(DAY, 3, data_fim), 103) AS nova_data_fim
FROM funcproj
WHERE id_funcionario = 3 AND codigo_projeto = 1003

--Quantos codigos de projetos distintos tem menos de 10 dias 
--trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10

--Nomes e descrições de projetos distintos que tem menos de 10 dias 
--trabalhados (tabelas diferentes)
--SUBQUERY OU SUBSELECT
/*
SELECT colA, colB, ..., colN
FROM tabela
WHERE colX IN OU NOT IN
(SELECT 1_OU_N_VALORES_DE_UMA_UNICA_COLUNA FROM tabela WHERE condições)
*/

SELECT codigo, 
		nome,
		descricao
FROM projeto
WHERE codigo IN --PK
(SELECT DISTINCT codigo_projeto --FK
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10)
----------------------------------
SELECT id,
		nome+' '+sobrenome AS nome_completo
FROM funcionario
WHERE id IN --PK
(SELECT DISTINCT id_funcionario --FK
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10)




--Exercícios

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--Nomes completos dos Funcionários que estão no
--projeto Modificação do Módulo de Cadastro

SELECT  nome + ' ' + sobrenome AS Nome_Completo
FROM    funcionario
WHERE id IN (
    SELECT DISTINCT id_funcionario
    FROM funcproj
    WHERE codigo_projeto IN(
        SELECT DISTINCT codigo
        FROM projeto
        WHERE nome =  'Modificação do módulo de cadastro'
    )
)




--Nomes completos e Idade, em anos (considere se fez ou ainda fará
--aniversário esse ano), dos funcionários
SELECT  nome + ' ' + sobrenome as Nome_Completo,
        data_nasc AS Nacido_EM,
        FLOOR (DATEDIFF(DAY, data_nasc, GETDATE()) / 365.25) as Idade
FROM funcionario

--Vi essa forma no StackOverflow e fiquei curioso se (aaaaMMddd_atual - aaaMMdd_Nasc)/10000 = idade
SELECT  nome + ' ' + sobrenome as Nome_Completo,
        data_nasc AS Nacido_EM,
        (CONVERT
            (int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),data_nasc,112))/10000 
        AS AgeIntYears
FROM funcionario