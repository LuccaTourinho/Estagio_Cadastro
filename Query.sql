
-- TABELA ENDERECO
DROP TABLE IF EXISTS Endereco;
CREATE TABLE Endereco (
    ID_endereco BIGSERIAL PRIMARY KEY,
    UF CHAR(2) NOT NULL CHECK (UF ~ '^[A-Z]{2}$'),
    municipio VARCHAR(100) NOT NULL CHECK (municipio ~ '^[a-zA-ZÀ-ÿ\s]+$'),
    CEP CHAR(9) NOT NULL CHECK (CEP ~ '^[0-9]{5}-[0-9]{3}$'),
    complemento VARCHAR(100) NOT NULL
);

/*

OBS: Eu não coloquei nenhum das informações unique pois ao fazer uma análise 
percebe que seria possível repetir os valores. UF, municipio não requer comentários,
porém, CEP pode ser repetido especialmente se considerarmos que moram no mesmo prédio.
E mesmo se consideramors o complemento ele depende muito de como o cliente vai escrever.
SSeria possivel que os cliente compartilhacem a mesma residencia. Um casal, uma grande familia
ou um colega ou amigo que divide as contas. Por isso o único realmente unique é o ID. 
*/

-- CRIAÇÃO DE ÍNDICE
CREATE INDEX idx_endereco_cep ON Endereco(CEP);


-- COMENTÁRIOS SOBRE COLUNAS
COMMENT ON COLUMN Endereco.UF IS 'Unidade Federativa';
COMMENT ON COLUMN Endereco.CEP IS 'Código de Endereçamento Postal';
COMMENT ON COLUMN Endereco.complemento IS 'Exemplo: Edifício Maranata, apartamento 501';

-- FUNCTION PARA INSERIR
DROP FUNCTION IF EXISTS insertEndereco;
CREATE OR REPLACE FUNCTION insertEndereco(
    p_UF CHAR(2),
    p_municipio VARCHAR(100),
    p_CEP CHAR(9),
    p_complemento VARCHAR(100)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        INSERT INTO Endereco (UF, municipio, CEP, complemento)
        VALUES (p_UF, p_municipio, p_CEP, p_complemento);
        
        resultado := 'Endereço inserido com sucesso';
    EXCEPTION
        WHEN others THEN
            resultado := 'Erro ao inserir endereço: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;

-- FUNCTIO PARA ATUALIZAR
DROP FUNCTION IF EXISTS updateEndereco;
CREATE OR REPLACE FUNCTION updateEndereco(
    p_ID_endereco BIGINT,
    p_UF CHAR(2),
    p_municipio VARCHAR(100),
    p_CEP CHAR(9),
    p_complemento VARCHAR(100)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Endereco WHERE ID_endereco = p_ID_endereco) THEN
            resultado = 'Endereço não encontrado. Atualização não realizada.';
        ELSE
            UPDATE Endereco
            SET UF = p_UF,
                municipio = p_municipio,
                CEP = p_CEP,
                complemento = p_complemento
            WHERE ID_endereco = p_ID_endereco;
            
            resultado = 'Endereço atualizado com sucesso';
        END IF;
    EXCEPTION
        WHEN others THEN
             resultado = 'Erro ao atualizar endereço: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;



-- FUNCTION DELETAR ENDERECO
DROP FUNCTION IF EXISTS deleteEndereco;
CREATE OR REPLACE FUNCTION deleteEndereco(
    p_ID_endereco BIGINT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Endereco WHERE ID_endereco = p_ID_endereco) THEN
            resultado = 'Endereço não encontrado. Exclusão não realizada.';
        ELSE
            DELETE FROM Endereco
            WHERE ID_endereco = p_ID_endereco;
            
            resultado = 'Endereço excluído com sucesso';
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao excluir endereço: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;


-- FUNCTION LER ENDERECO
DROP FUNCTION IF EXISTS readEndereco;
CREATE OR REPLACE FUNCTION readEndereco(
    p_ID_endereco BIGINT
)
RETURNS TABLE (
    endereco_UF CHAR(2),
    endereco_municipio VARCHAR(100),
    endereco_CEP CHAR(9),
    endereco_complemento VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Endereco WHERE ID_endereco = p_ID_endereco) THEN
        RETURN QUERY VALUES (NULL::CHAR(2), NULL::VARCHAR(100), NULL::CHAR(9), NULL::VARCHAR(100));
    ELSE
        RETURN QUERY
        SELECT UF AS endereco_UF,
               municipio AS endereco_municipio,
               CEP AS endereco_CEP,
               complemento AS endereco_complemento
        FROM Endereco
        WHERE ID_endereco = p_ID_endereco;
    END IF;
END;
$$;






-- EXEMPLO PARA TESTE
DELETE FROM Endereco;

SELECT insertEndereco('SP', 'São Paulo', '12345-678', 'Edifício Maranata, apto 501');
SELECT updateEndereco(3, 'RJ', 'Rio de Janeiro', '54321-876', 'Novo endereço');
SELECT * FROM readEndereco(2);
SELECT deleteEndereco(3);


SELECT * FROM Endereco;
-----------------------------------------------------------------------------------------------
-- ESTADO CIVIL
DROP TYPE status;
CREATE TYPE status AS ENUM ('CASADO','SOLTEIRO');

-- TABELA CADASTRO
DROP TABLE IF EXISTS Cadastro;
CREATE TABLE Cadastro(
	ID_cadastro BIGSERIAL PRIMARY KEY,
	ID_endereco BIGINT UNIQUE REFERENCES Endereco(ID_endereco) ON DELETE CASCADE,
	nome VARCHAR(60) NOT NULL CHECK (nome ~ '^[a-zA-ZÀ-ÿ\s]+$'),
	data_nascimento DATE NOT NULL,
	RG CHAR(13) NOT NULL UNIQUE CHECK (RG ~ '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}-[0-9Xx]{2}$'),
	CPF CHAR(14) NOT NULL UNIQUE CHECK (CPF ~ '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}$'),
	telefone_primario VARCHAR(18) NOT NULL UNIQUE CHECK (telefone_primario ~ '^\(\d{1,3}\) \d{5}-\d{4}$'),
	telefone_secundario VARCHAR(18) DEFAULT NULL UNIQUE CHECK (telefone_secundario IS NULL OR telefone_secundario ~ '^\(\d{1,3}\) \d{5}-\d{4}$'),
	email_principal VARCHAR(40) NOT NULL UNIQUE CHECK (email_principal ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
	email_alternativo VARCHAR(40) DEFAULT NULL UNIQUE CHECK (email_alternativo IS NULL OR email_alternativo ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
	estado_civil status NOT NULL,
	usuario VARCHAR(11) NOT NULL UNIQUE CHECK (usuario ~ '^[a-zA-Z]+$'),
	senha VARCHAR(14) NOT NULL UNIQUE CHECK (senha ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*[@])(?=.*[0-9]).{8,}$')
);

-- CRIAÇÃO DE INDEX
CREATE INDEX idx_cadastro_usuario ON Cadastro(usuario);
CREATE INDEX idx_cadastro_senha ON Cadastro(senha);

-- COMENTÁRIOS DAS COLUNAS
COMMENT ON COLUMN Cadastro.RG IS 'Registro geral';
COMMENT ON COLUMN Cadastro.CPF IS 'Comprovante de Pessoa Física';


-- FUNCTION PARA FAZER CADASTRO
DROP FUNCTION IF EXISTS insertCadastro;
CREATE OR REPLACE FUNCTION insertCadastro(
    p_ID_endereco BIGINT,
    p_nome VARCHAR(60),
    p_data_nascimento DATE,
    p_RG CHAR(12),
    p_CPF CHAR(14),
    p_telefone_primario VARCHAR(15),
    p_telefone_secundario VARCHAR(15),
    p_email_principal VARCHAR(40),
    p_email_alternativo VARCHAR(40),
    p_estado_civil status,
    p_usuario VARCHAR(11),
    p_senha VARCHAR(14)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        INSERT INTO Cadastro (
            ID_endereco, nome, data_nascimento, RG, CPF,
            telefone_primario, telefone_secundario, email_principal, email_alternativo,
            estado_civil, usuario, senha
        )
        VALUES (
            p_ID_endereco, p_nome, p_data_nascimento, p_RG, p_CPF,
            p_telefone_primario, p_telefone_secundario, p_email_principal, p_email_alternativo,
            p_estado_civil, p_usuario, p_senha
        );
        
        resultado = 'Cadastro inserido com sucesso';
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao inserir cadastro: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;



-- FUNCTION PARA ATUALIZAR CADASTRO
DROP FUNCTION IF EXISTS updateCadastro;
CREATE OR REPLACE FUNCTION updateCadastro(
    p_ID_cadastro BIGINT,
    p_ID_endereco BIGINT,
    p_nome VARCHAR(60),
    p_data_nascimento DATE,
    p_RG CHAR(12),
    p_CPF CHAR(14),
    p_telefone_primario VARCHAR(15),
    p_telefone_secundario VARCHAR(15),
    p_email_principal VARCHAR(40),
    p_email_alternativo VARCHAR(40),
    p_estado_civil status,
    p_usuario VARCHAR(11),
    p_senha VARCHAR(14)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Cadastro WHERE ID_cadastro = p_ID_cadastro) THEN
            resultado = 'Cadastro não encontrado. Nenhum update realizado.';
        ELSE
            UPDATE Cadastro
            SET
                ID_endereco = p_ID_endereco,
                nome = p_nome,
                data_nascimento = p_data_nascimento,
                RG = p_RG,
                CPF = p_CPF,
                telefone_primario = p_telefone_primario,
                telefone_secundario = p_telefone_secundario,
                email_principal = p_email_principal,
                email_alternativo = p_email_alternativo,
                estado_civil = p_estado_civil,
                usuario = p_usuario,
                senha = p_senha
            WHERE ID_cadastro = p_ID_cadastro;
            
            resultado = 'Cadastro atualizado com sucesso';
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao atualizar cadastro: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;


-- FUNCTION PARA LER CADASTRO
DROP FUNCTION IF EXISTS readCadastro;
CREATE OR REPLACE FUNCTION readCadastro(
    p_usuario VARCHAR(11),
    p_senha VARCHAR(14)
)
RETURNS TABLE (
    ID_cadastro BIGINT,
    ID_endereco BIGINT,
    nome VARCHAR(60),
    data_nascimento DATE,
    RG CHAR(12),
    CPF CHAR(14),
    telefone_primario VARCHAR(15),
    telefone_secundario VARCHAR(15),
    email_principal VARCHAR(40),
    email_alternativo VARCHAR(40),
    estado_civil status,
    usuario VARCHAR(11),
    senha VARCHAR(14)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM Cadastro c
    WHERE c.usuario = p_usuario AND c.senha = p_senha;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Cadastro não encontrado para o usuário e senha fornecidos.';
    END IF;
END;
$$;


-- FUNCTION PARA DELETAR CADASTRO
DROP FUNCTION IF EXISTS deleteCadastro;
CREATE OR REPLACE FUNCTION deleteCadastro(
    p_usuario VARCHAR(11),
    p_senha VARCHAR(14)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        DELETE FROM Cadastro
        WHERE usuario = p_usuario AND senha = p_senha
        RETURNING ID_cadastro INTO resultado;
        
        IF resultado IS NOT NULL THEN
            resultado = 'Cadastro excluído com sucesso';
        ELSE
            resultado = 'Cadastro não encontrado para o usuário e senha fornecidos';
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao excluir cadastro: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;














-- EXEMPLOS PARA TESTE
SELECT insertCadastro(
    4, 
    'Nome do Indivíduo', 
    '2000-01-01', 
    '12.345.678-90', 
    '123.456.789-01', 
    '(123) 45678-9000', 
    '(123) 45678-9001', 
    'email@example.com',
    'email2@example.com', 
    'SOLTEIRO', 
    'username', 
    'Pass@word123' 
);

SELECT updateCadastro(
    1, 
    4, 
    'Novo Nome', 
    '2000-02-02', 
    '11.222.333-44', 
    '555.666.777-88', 
    '(99) 98765-4321', 
    NULL, 
    'novo@email.com', 
    NULL, 
    'CASADO', 
    'novusuario', 
    'New@Pass123' 
);

SELECT *
FROM readCadastro('novusuario', 'New@Pass123');

SELECT deleteCadastro('novusuario', 'New@Pass123');


DELETE FROM Cadastro;
SELECT * FROM Cadastro;
-----------------------------------------------------------------------------------------------

-- TABELA ENTRADA_SAIDA
DROP TABLE IF EXISTS Entrada_Saida;
CREATE TABLE Entrada_Saida(
	ID_ea BIGSERIAL PRIMARY KEY,
	ID_cadastro BIGINT NOT NULL REFERENCES Cadastro(ID_cadastro) ON DELETE CASCADE,
	entrada TIMESTAMP NOT NULL,
	saida TIMESTAMP DEFAULT NULL,
	CHECK (saida IS NULL OR entrada <= saida)
);

CREATE INDEX idx_ea_entrada ON Entrada_Saida(entrada);
CREATE INDEX idx_ea_saida ON Entrada_Saida(saida);


-- FUNCTION PARA INSERIR ENTRADA
DROP FUNCTION IF EXISTS insertEntrada;
CREATE OR REPLACE FUNCTION insertEntrada(
    p_ID_cadastro BIGINT,
    p_entrada TIMESTAMP
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        INSERT INTO Entrada_Saida (ID_cadastro, entrada)
        VALUES (p_ID_cadastro, p_entrada);
        
        resultado = 'Registro de entrada inserido com sucesso';
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao inserir registro de entrada: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;


-- FUNCTION PARA INSERIR SAIDA
DROP FUNCTION IF EXISTS insertSaida;
CREATE OR REPLACE FUNCTION insertSaida(
    p_ID_cadastro BIGINT,
    p_entrada TIMESTAMP,
    p_saida TIMESTAMP
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        UPDATE Entrada_Saida
        SET saida = p_saida
        WHERE ID_cadastro = p_ID_cadastro AND entrada = p_entrada;
        
        IF FOUND THEN
            resultado = 'Registro de saída inserido com sucesso';
        ELSE
            resultado = 'Nenhum registro de entrada correspondente encontrado';
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao inserir registro de saída: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;


-- FUNCTION LER A ENTRADA ATUAL
DROP FUNCTION IF EXISTS readEntradaAtual;
CREATE OR REPLACE FUNCTION readEntradaAtual(
    p_ID_cadastro BIGINT
)
RETURNS TABLE (
    entrada_atual TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT entrada
    FROM Entrada_Saida ea
    WHERE ea.ID_cadastro = p_ID_cadastro AND ea.saida IS NULL;
END;
$$;



-- FUNCTION LER HISTORICO
DROP FUNCTION IF EXISTS readHistorico;
CREATE OR REPLACE FUNCTION readHistorico(
    p_ID_cadastro BIGINT
)
RETURNS TABLE (
    entrada_historica TIMESTAMP,
    saida_historica TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT ea.entrada, ea.saida
    FROM Entrada_Saida ea
    WHERE ea.ID_cadastro = p_ID_cadastro;
END;
$$;


-- FUNCTION CANCELAR ENTRADA
DROP FUNCTION IF EXISTS cancelarEntrada;
CREATE OR REPLACE FUNCTION cancelarEntrada(
    p_ID_cadastro BIGINT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    resultado TEXT;
BEGIN
    BEGIN
        DELETE FROM Entrada_Saida ea
        WHERE ea.ID_cadastro = p_ID_cadastro AND ea.saida IS NULL;
        
        IF FOUND THEN
            resultado = 'Entrada cancelada com sucesso';
        ELSE
            resultado = 'Nenhuma entrada correspondente encontrada ou entradas já possuem saída';
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado = 'Erro ao cancelar entrada: ' || SQLERRM;
    END;
    
    RETURN resultado;
END;
$$;




SELECT insertEntrada(2, '2023-08-25 10:00:00');
SELECT insertSaida(2, '2023-08-25 10:00:00', '2023-08-25 18:00:00');

SELECT insertEntrada(2, '2023-08-27 10:00:00');

SELECT * FROM readEntradaAtual(2);

SELECT * FROM readHistorico(2);

SELECT cancelarEntrada(2);


SELECT * FROM Entrada_Saida;


DELETE FROM Entrada_Saida;






-- APLICANDO REGRA DA ÚNICA ENTRADA SEM SAIDA

--INSERT
DROP FUNCTION IF EXISTS checkBeforeInsert;
CREATE OR REPLACE FUNCTION checkBeforeInsert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.saida IS NULL AND EXISTS (
        SELECT 1
        FROM Entrada_Saida ea
        WHERE ea.ID_cadastro = NEW.ID_cadastro AND ea.saida IS NULL
    ) THEN
        RAISE EXCEPTION 'Cadastro já possui uma entrada ';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER before_insert_entrada
BEFORE INSERT ON Entrada_Saida
FOR EACH ROW
EXECUTE FUNCTION checkBeforeInsert();

-- UPDATE
DROP FUNCTION checkBeforeUpdate;
CREATE OR REPLACE FUNCTION checkBeforeUpdate()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.saida IS NULL AND EXISTS (
        SELECT 1
        FROM Entrada_Saida
        WHERE ID_cadastro = NEW.ID_cadastro AND saida IS NULL AND ID_ea <> NEW.ID_ea
    ) THEN
        RAISE EXCEPTION 'Cadastro já possui uma entrada ';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER before_update_entrada
BEFORE UPDATE ON Entrada_Saida
FOR EACH ROW
EXECUTE FUNCTION checkBeforeUpdate();


-- DELETE
DROP FUNCTION checkBeforeDelete;
CREATE OR REPLACE FUNCTION checkBeforeDelete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.saida IS NULL AND EXISTS (
        SELECT 1
        FROM Entrada_Saida
        WHERE ID_cadastro = OLD.ID_cadastro AND saida IS NULL AND ID_ea <> OLD.ID_ea
    ) THEN
        RAISE EXCEPTION 'Cadastro possui uma entrada sem saída correspondente';
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER before_delete_entrada
BEFORE DELETE ON Entrada_Saida
FOR EACH ROW
EXECUTE FUNCTION checkBeforeDelete();







-- VIEWS 

-- VIEW infoPessoal
DROP VIEW IF EXISTS infoPessoal;
CREATE OR REPLACE VIEW infoPessoal AS
SELECT
    c.ID_cadastro,
    c.nome,
    c.data_nascimento,
    c.RG,
    c.CPF,
    c.telefone_primario,
    c.telefone_secundario,
    c.email_principal,
    c.email_alternativo,
    c.estado_civil,
    c.usuario,
    c.senha,
    e.UF,
    e.municipio,
    e.CEP,
    e.complemento
FROM Cadastro c
INNER JOIN Endereco e ON c.ID_endereco = e.ID_endereco;

SELECT * FROM infoPessoal;





-- VIEW cadastrosEntradas
DROP VIEW IF EXISTS cadastrosEntradas;
CREATE OR REPLACE VIEW cadastrosEntradas AS
SELECT
    ip.*,
    ea.entrada
FROM infoPessoal ip
INNER JOIN Entrada_Saida ea ON ip.ID_cadastro = ea.ID_cadastro
WHERE ea.saida IS NULL;

SELECT * FROM cadastrosEntradas;


-- VIEW cadastrosEA
DROP VIEW IF EXISTS cadastrosEA;
CREATE OR REPLACE VIEW cadastroEA AS
SELECT
    ip.*,
    es.entrada,
    es.saida
FROM infoPessoal ip
JOIN Entrada_Saida es ON ip.ID_cadastro = es.ID_cadastro
WHERE es.saida IS NOT NULL;

SELECT * FROM cadastroEA;


-- VIEW EstadoCivilCadastro
DROP FUNCTION IF EXISTS EstadoCivilCadastro;
CREATE OR REPLACE VIEW EstadoCivilCadastro AS
SELECT
    estado_civil,
    COUNT(*) AS quantidade,
    CONCAT((COUNT(*)::FLOAT / (SELECT COUNT(*) FROM Cadastro)) * 100) AS porcentagem
FROM Cadastro
GROUP BY estado_civil;

SELECT * FROM EstadoCivilCadastro


-- VIEW FaixaEtaria
DROP VIEW IF EXISTS FaixaEtariaCadastros;
CREATE OR REPLACE VIEW FaixaEtariaCadastros AS
SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) < 18 THEN 'Menor que 18 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 18 AND 25 THEN 'Entre 18 e 25 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 26 AND 35 THEN 'Entre 26 e 35 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 36 AND 60 THEN 'Entre 36 e 60 anos'
        ELSE 'Maior que 60 anos'
    END AS faixa_etaria,
    COUNT(*) AS cadastros
FROM cadastroEA c
GROUP BY faixa_etaria;

DROP VIEW FaixaEtariaEntradas;
CREATE OR REPLACE VIEW FaixaEtariaEntradas AS
SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) < 18 THEN 'Menor que 18 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 18 AND 25 THEN 'Entre 18 e 25 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 26 AND 35 THEN 'Entre 26 e 35 anos'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.data_nascimento)) BETWEEN 36 AND 60 THEN 'Entre 36 e 60 anos'
        ELSE 'Maior que 60 anos'
    END AS faixa_etaria,
    COUNT(*) AS entradas
FROM cadastroEA c
JOIN Entrada_Saida es ON c.ID_cadastro = es.ID_cadastro
GROUP BY faixa_etaria;

SELECT * FROM FaixaEtariaCadastros;
SELECT * FROM FaixaEtariaEntradas;









