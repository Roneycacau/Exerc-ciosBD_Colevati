CREATE DATABASE livraria
GO

USE livraria
GO

CREATE TABLE livro(
	Codigo_Livro	INT			    NOT NULL,
	Nome			NVARCHAR(100)	NULL,
	Lingua			NVARCHAR(50)	NULL,
	Ano				INT				NULL
	PRIMARY KEY(Codigo_Livro)
)
GO

CREATE TABLE autor(
	Codigo_Autor	INT			    NOT NULL,
	Nome			NVARCHAR(100)	NULL,
	Nascimento		DATE			NULL,
	Pais			NVARCHAR(50)	NULL,
	Biografia		NVARCHAR(MAX)	NULL
	PRIMARY KEY(Codigo_Autor)
)
GO

CREATE TABLE edicoes(
	ISBN			INT			NOT NULL,
	Preco			DECIMAL(7,2)	NULL,
	Ano				INT			NULL,
	Num_Paginas		INT			NULL,
	Qtd_Estoque		INT			NULL
	PRIMARY KEY(ISBN)
)
GO

CREATE TABLE editora(
	Codigo_Editora	INT			    NOT NULL, 
	Nome			NVARCHAR(50)	NULL, 
	Logradouro		NVARCHAR(255)	NULL,
	Numero			INT			    NULL,
	CEP				NCHAR(8)		NULL, 
	TELEFONE		NCHAR(11)		NULL
	PRIMARY KEY(Codigo_Editora)
)
GO

CREATE TABLE livro_autor(
	LivroCodigo_Livro	INT		NOT NULL,
	AutorCodigo_Autor	INT		NOT NULL
	PRIMARY KEY(LivroCodigo_Livro, AutorCodigo_Autor)
	FOREIGN KEY(LivroCodigo_Livro) REFERENCES livro (Codigo_Livro),
	FOREIGN KEY(AutorCodigo_Autor) REFERENCES autor (Codigo_Autor)
)
GO

CREATE TABLE livro_edicoes_editora(
	EdicoesISBN				INT	NOT NULL,
	EditoraCodigo_Editora	INT	NOT NULL, 
	LivroCodigo_Livro		INT	NOT NULL
	PRIMARY KEY(EdicoesISBN, EditoraCodigo_Editora, LivroCodigo_Livro)
	FOREIGN KEY(EdicoesISBN) REFERENCES edicoes(ISBN),
	FOREIGN KEY(EditoraCodigo_Editora) REFERENCES editora(Codigo_Editora),
	FOREIGN KEY(LivroCodigo_Livro) REFERENCES livro(Codigo_Livro)
)
GO

EXEC sp_rename 'dbo.edicoes.Ano','AnoEdicao','column'

ALTER TABLE editora
ALTER COLUMN Nome NVARCHAR(30) NULL

ALTER TABLE autor
ALTER COLUMN Nascimento nvarchar(100) NULL
ALTER TABLE autor
ALTER COLUMN Nascimento INT NULL

INSERT INTO livro VALUES
(1001, 'CCNA 4.1', 'PT-BR', 2015),
(1002, 'HTML 5', 'PT-BR', 2017),
(1003, 'Redes de Computadores', 'EN', 2010),
(1004, 'Android em Ação', 'PT-BR', 2018)

INSERT INTO autor VALUES
(10001, 'Inácio da Silva', 1975, 'Brasil', 'Programador WEB desde 1995'),
(10002, 'Andrew Tannenbaum', 1944, 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij'),
(10003, 'Luis Rocha', 1967, 'Brasil', 'Programador Mobile desde 2000'),
(10004, 'David Halliday', 1916, 'EUA', 'Físico PH.D desde 1941')

INSERT INTO livro_autor VALUES
(1001, 10001),
(1002, 10003),
(1003, 10002),
(1004, 10003)

INSERT INTO edicoes VALUES
(0130661023, 189.99, 2018, 653, 10)


SELECT * FROM livro
SELECT * FROM autor
SELECT * FROM livro_autor
SELECT * FROM edicoes


UPDATE autor 
SET Biografia = ('Chefe do Departamento de Sistemas de Computação da Universidade de Vrije')
WHERE Codigo_Autor = 10002

UPDATE edicoes
SET Qtd_Estoque = Qtd_Estoque - 2
WHERE ISBN = 0130661023

DELETE autor
WHERE Codigo_Autor = 10004

SELECT * FROM autor
SELECT * FROM edicoes
