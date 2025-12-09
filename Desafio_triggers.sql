-- CODE Company:
-- Atualização:  
-- Inserção de novos colaboradores e atualização do salário base 
-- (NAO SE PODE ATUALIZAR A TABELA EMPLOYEE E EXECUTAR UMA TRIGGER DE UPDATE NA MESMA TABELA, POIS LOOP INFINITO). 
-- COLOQUEI BEFORE UPDATE ON DEPARTMENT. ISSO QUE DÁ UTILIZAR EXEMPLOS SEM BASE EM EXEMPLOS DE CASOS REAIS.
DELIMITER $$
CREATE TRIGGER tgr_updt_salary
BEFORE UPDATE ON department 
FOR EACH ROW
BEGIN
    UPDATE employee
    SET salary = salary * 1.20
    WHERE Dnumber = 4;
END $$
DELIMITER ;

-- Tabela que receberá os dados deletados de Ecommerce:
CREATE TABLE deleted_clients(
	id_client INT PRIMARY KEY NOT NULL,
    Fname VARCHAR(100),
    Minit VARCHAR(100),
    Lname VARCHAR(100),
    CPF VARCHAR(20),
    Deleted_at DATETIME DEFAULT NOW()
);

-- CODE Ecommerce:
-- Remoção:  
-- Usuários podem excluir suas contas por algum motivo. Dessa forma, para não perder as informações sobre estes usuários, crie um gatilho before remove 
DELIMITER $$
CREATE TRIGGER tgr_move_deleted_clients 
BEFORE DELETE ON clients
FOR EACH ROW
BEGIN
	INSERT INTO deleted_clients(id_client, fname, minit, lname, cpf)
	VALUES (OLD.idClient, OLD.fname, OLD.minit, OLD.lname, OLD.cpf);
END $$
DELIMITER ;

