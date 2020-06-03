
CREATE DATABASE dllDml
GO
USE dllDml
GO

CREATE TABLE users (
    id				INT             NOT NULL    IDENTITY(1,1),
    [name]			NVARCHAR(45)    NOT NULL,
    username		NVARCHAR(45)    NOT NULL    CONSTRAINT unique_user UNIQUE,
    [password]		NVARCHAR(45)    NOT NULL    DEFAULT ('123mudar'),
    email			NVARCHAR(45)    NOT NULL
    
    PRIMARY KEY(id)
)
GO

CREATE TABLE projects(
    id					INT             NOT NULL    IDENTITY(10001,1),
    [name]				NVARCHAR(45)    NOT NULL,
    descripition		NVARCHAR(45),
    [date]				NVARCHAR(45)    CHECK (date > CONVERT(DATE, '01/09/2014'))

    PRIMARY KEY(id)
)
GO

CREATE TABLE user_has_projects(
    users_id    INT NOT NULL,
    projects_id INT NOT NULL

    PRIMARY KEY (users_id, projects_id),
    FOREIGN KEY (users_id) REFERENCES users (id),
    FOREIGN KEY (projects_id) REFERENCES projects (id)
)
GO

ALTER TABLE users DROP CONSTRAINT unique_user
ALTER TABLE users
ALTER COLUMN username NVARCHAR(10)
ALTER TABLE users ADD CONSTRAINT unique_user UNIQUE(username)

ALTER TABLE users
ALTER COLUMN password NVARCHAR(8)

INSERT INTO users(name, username, password, email) VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects (name, descripition, date) VALUES
('Re‐folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PCs', 'Manutenção PC ́s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')

INSERT INTO user_has_projects (users_id, projects_id) VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

UPDATE projects
SET date = '12/09/2014'
WHERE name = 'Manutenção PCs'

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET password = '888@*'
WHERE username = 'Rh_maria'
    AND password = '123mudar'

DELETE user_has_projects
WHERE users_id = 2

ALTER TABLE projects
ADD budget DECIMAL (7,2)

UPDATE projects
SET budget = 5750.00
WHERE id = 10001

UPDATE projects
SET budget = 7850.00
WHERE id = 10002

UPDATE projects
SET budget = 9530.00
WHERE id = 10003

SELECT username as Usuário, password as Senha
FROM users
WHERE name = 'Ana'

SELECT name as Nome, budget as Orçamento, CAST (budget * 1.25 AS DECIMAL(7,2)) AS NovoOrçamento
FROM projects

SELECT id, name, email
FROM users
WHERE [password] = '123mudar'

SELECT id, name
FROM projects
WHERE budget BETWEEN 2000 AND 8000
