-- create table di tutte le tabelle
USE esercitazione4;

-- create table sensori
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
    data JSON NOT NULL,
    id_sensor INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_sensor) REFERENCES sensori(id_sensor)
);

-- create table states
DROP TABLE IF EXISTS states;

CREATE TABLE IF NOT EXISTS states(
    chiave CHAR(20) PRIMARY KEY,
    _value CHAR(100)
)ENGINE = MEMORY;

-- crate table warnings
DROP TABLE IF EXISTS warnings;

CREATE TABLE IF NOT EXISTS warnings(
    timestamp DATETIME NOT NULL,
    message VARCHAR(255),
    level ENUM('INFO','MEDIUM','HIGH')
)ENGINE MEMORY;

