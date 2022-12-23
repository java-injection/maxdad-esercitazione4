-- create table di tutte le tabelle

CREATE DATABASE IF NOT EXISTS esercitazione4;
USE esercitazione4;

DELETE FROM data_sensori;
DELETE FROM warnings;


DROP PROCEDURE IF EXISTS PROC_DROP_FOREIGN_KEY;
DELIMITER $$
CREATE PROCEDURE PROC_DROP_FOREIGN_KEY(IN tableName VARCHAR(64), IN constraintName VARCHAR(64))
BEGIN
    IF EXISTS(
            SELECT * FROM information_schema.table_constraints
            WHERE
                    table_schema    = DATABASE()     AND
                    table_name      = tableName      AND
                    constraint_name = constraintName AND
                    constraint_type = 'FOREIGN KEY')
    THEN
        SET @query = CONCAT('ALTER TABLE ', tableName, ' DROP FOREIGN KEY ', constraintName, ';');
        PREPARE stmt FROM @query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;


-- create table sensori
-- drop foreign kei if exists fk_sensori
-- ALTER TABLE data_sensori DROP FOREIGN KEY fk_id_sensor ;
CALL PROC_DROP_FOREIGN_KEY('data_sensori', 'fk_id_sensor');

DROP TABLE IF EXISTS sensori;

CREATE TABLE IF NOT EXISTS sensori(
      id_sensor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      nome VARCHAR(20) NOT NULL,
      brand VARCHAR(50) NOT NULL,
      UNIQUE(nome, brand)
);

-- create table data_sensori
DROP TABLE IF EXISTS data_sensori;

CREATE TABLE IF NOT EXISTS data_sensori(
    timestamp DATETIME NOT NULL,
    data JSON ,
    id_sensor INT UNSIGNED ,
    CONSTRAINT fk_id_sensor FOREIGN KEY (id_sensor) REFERENCES sensori(id_sensor)
);

-- create table states
DROP TABLE IF EXISTS states;

CREATE TABLE IF NOT EXISTS states(
    _key CHAR(20) PRIMARY KEY,
    _value CHAR(100)
)ENGINE = MEMORY;

-- crate table warnings
DROP TABLE IF EXISTS warnings;

CREATE TABLE IF NOT EXISTS warnings(
    timestamp DATETIME NOT NULL,
    message VARCHAR(255),
    level ENUM('INFO','MEDIUM','HIGH')
)ENGINE MEMORY;


DROP TABLE IF EXISTS anomalies;

CREATE TABLE IF NOT EXISTS anomalies(
                                       timestamp DATETIME NOT NULL,
                                       id_sensor INT UNSIGNED NOT NULL,
                                       type ENUM('ANOMALY 1','ANOMALY 2')
)ENGINE ARCHIVE;

-- nelle tabelle engine non ci possono essere FK
