-- insert
USE esercitazione4;
SET SQL_SAFE_UPDATES = 0;
-- insert table sensori
DELETE FROM data_sensori;
DELETE FROM sensori;
INSERT INTO sensori VALUES (1,'EL-100','SAMSUNG');
INSERT INTO sensori VALUES (2,'DOOR-007','OBS');
DELETE FROM states;
INSERT INTO states VALUES('S2_LAST_VALUE',NULL);
INSERT INTO states VALUES('ANOMALY1_ACTIVE','0');
INSERT INTO states VALUES('ANOMALY2_ACTIVE','0');