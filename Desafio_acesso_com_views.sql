-- --//--Neste desafio você irá criar visões para os seguintes cenários:--\\--

-- 1. Número de empregados por departamento e localidade (NÃO É POSSÍVEL ADICIONAR LOCALIDADE, POIS DEPARTAMENTO 5, POSSUI VÁRIAS LOCALIDADES, LOGO
-- GROUP BY DA ERRO, POIS NÃO SABE O QUE FAZER COM AS LOCALIDADES DIFERENTES DE UM MESMO NÚMERO DE DEPARTAMENTO).
CREATE OR REPLACE VIEW vw_employee_by_dept AS
SELECT d.Dname AS Department_Name, COUNT(e.ssn) AS Number_of_Employes
FROM employee e JOIN department d
ON e.Dnumber = d.Dnumber
GROUP BY d.Dname;

-- 2. Lista de departamentos e seus gerentes 
CREATE OR REPLACE VIEW vw_mgr_by_dept AS
SELECT d.Dname AS Department_Name, CONCAT(e.fname, ' ', minit, ' ', lname) AS Mgr_Name, d.Mgr_ssn
FROM department d
JOIN employee e
	ON d.Mgr_ssn = e.ssn;

-- 3. Projetos com maior número de empregados (ex: por ordenação desc) 
CREATE OR REPLACE VIEW vw_employee_by_projects AS
SELECT p.pname AS Project_Name, COUNT(w.essn) AS Number_of_Employee
FROM works_on w 
JOIN project p
	ON w.pnumber = p.pnumber
GROUP BY p.pname
ORDER BY Number_of_Employee DESC;

-- 4. Lista de projetos, departamentos e gerentes 
CREATE OR REPLACE VIEW vw_proj_with_dept_and_mgr AS
SELECT p.pname AS Project_Name, d.dname AS Department_Name, CONCAT(e.fname, ' ', minit, ' ', lname) AS Mgr_Name
FROM project p
JOIN department d
	ON p.dno = d.dnumber
JOIN employee e
	ON d.mgr_ssn = e.ssn;

-- 5. Quais empregados possuem dependentes e se são gerentes 
CREATE OR REPLACE VIEW vw_mgrEmployee_with_dependent AS
SELECT CONCAT(e.fname, ' ', e.minit, ' ', e.lname) AS Employee_With_Dependents,
    CASE WHEN e.ssn = dept.mgr_ssn THEN 'True' ELSE 'False' END AS Manager
FROM employee e
JOIN department dept
    ON e.dnumber = dept.dnumber
WHERE EXISTS (
    SELECT 1
    FROM dependent d
    WHERE d.essn = e.ssn
);

-- Além disso, serão definidas as permissões de acesso as views de acordo com o tipo de conta de usuários. 
-- Lembre-se que as views ficam armazaneadas no banco de dados como uma “tabela”. 
-- Assim podemos definir permissão de acesso a este item do banco de dados.  
-- Você poderá criar um usuário gerente que terá acesso as informações de employee e departamento. 
-- Contudo, employee não terá acesso as informações relacionadas aos departamentos ou gerentes. 

CREATE USER 'manager_1'@localhost IDENTIFIED BY '11111111';
GRANT SELECT ON company.vw_employee_by_dept TO 'manager_1'@localhost;
GRANT SELECT ON company.vw_employee_by_projects TO 'manager_1'@localhost;
GRANT SELECT ON company.vw_mgr_by_dept TO 'manager_1'@localhost;
GRANT SELECT ON company.vw_proj_with_dept_and_mgr TO 'manager_1'@localhost;

CREATE USER 'employee_2'@localhost IDENTIFIED BY '22222222';
GRANT SELECT ON company.vw_employee_by_projects TO 'employee_2'@localhost;
