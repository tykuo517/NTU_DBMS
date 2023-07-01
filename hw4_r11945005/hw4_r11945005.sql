/***** use database *****/
USE DB_class;

/***** info *****/
DROP TABLE IF EXISTS self;
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r11945005', '生醫電資所', 1, '郭庭沂');

SELECT DATABASE();
SELECT * FROM self;

/* Prepared statement */
PREPARE department FROM 'SELECT * FROM student WHERE 系所=?';
SET @dep = '生醫電資所';
EXECUTE department USING @dep;

SET @dep = '資工系';
EXECUTE department USING @dep;


/* Stored-function */
DROP FUNCTION IF EXISTS chinese_name;
CREATE FUNCTION chinese_name(input varchar(40))
RETURNS varchar(40) DETERMINISTIC
RETURN SUBSTRING_INDEX(input, '(', 1);

DROP FUNCTION IF EXISTS english_name;
CREATE FUNCTION english_name(input varchar(40))
RETURNS varchar(40) DETERMINISTIC
RETURN regexp_replace(input, '[^a-zA-Z-, ]', '');

SELECT chinese_name(姓名), english_name(姓名) FROM student
WHERE final_group=8;


/* Stored procedure */
DELIMITER $$
DROP PROCEDURE IF EXISTS students_count$$
CREATE PROCEDURE students_count(input varchar(40))
BEGIN
	SELECT COUNT(*) INTO @STCOUNT FROM student WHERE 系所=input;
END$$
DELIMITER ;

CALL students_count('生醫電資所');
SELECT @STCOUNT; 

CALL students_count('資工系');
SELECT @STCOUNT; 


/* Trigger I  */
DROP TRIGGER IF EXISTS captains_count;
CREATE TRIGGER captains_count AFTER UPDATE ON student
FOR EACH ROW SELECT COUNT(*) INTO @NUMCAPS FROM student WHERE final_captain=1;

UPDATE student SET final_captain=1 WHERE 學號 IN ('R10227105','R10455001','R11521616','R10724039','B07610058');
SELECT * FROM student WHERE final_captain=1;
SELECT @NUMCAPS; 


/* Trigger II */
DROP TABLE IF EXISTS record;
CREATE TABLE record (
    userid varchar(40) NOT NULL,
    event_type ENUM ('insert','delete'),
    time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS insert_change;
CREATE TRIGGER insert_change AFTER INSERT ON student
FOR EACH ROW INSERT INTO record(userid, event_type) VALUES(user(),'insert');

DROP TRIGGER IF EXISTS delete_change;
CREATE TRIGGER delete_change AFTER DELETE ON student
FOR EACH ROW INSERT INTO record(userid, event_type) VALUES(user(),'delete');

SELECT * FROM record;

INSERT INTO student
VALUES 
('學生', '獸醫系', '3', 'B07000001','Allen','B07000001@ntu.edu.tw','資料庫系統-從SQL到NoSQL (EE5178)',0 ,0),
('學生', '獸醫系', '3', 'B07000002','Jackson','B07000002@ntu.edu.tw','資料庫系統-從SQL到NoSQL (EE5178)', 0, 0),
('學生', '獸醫系', '3', 'B07000003','Zoey','B07000003@ntu.edu.tw','資料庫系統-從SQL到NoSQL (EE5178)', 0, 0);

DELETE FROM student WHERE 學號 IN ('R10H41004','R11H41003');

SELECT * FROM record;

/* drop database */