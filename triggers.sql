-- triggers
DROP TRIGGER IF EXISTS Anomalia2_Before_Insert;

DELIMITER &&
CREATE TRIGGER Anomalia2_Before_Insert
    BEFORE INSERT ON data_sensori
    FOR EACH ROW
    BEGIN
        IF(NEW.data is null)
        THEN
            BEGIN
                INSERT into anomalies VALUES (NEW.timestamp, NEW.id_sensor, 'ANOMALY 2');
                SET @exception = 'È STATO TROVATO UN VALORE NULL';
                SIGNAL SQLSTATE '02000'
                SET MESSAGE_TEXT = @exception;
            END ;
        END IF;
    END &&
DELIMITER ;


DROP TRIGGER IF EXISTS Anomalia1_Before_Insert;

DELIMITER $$
CREATE TRIGGER Anomalia1_Before_Insert
    BEFORE INSERT ON data_sensori
    FOR EACH ROW
    BEGIN
        IF(1 <= (SELECT count(*)
                FROM data_sensori
                WHERE timestamp = NEW.timestamp AND id_sensor = NEW.id_sensor))
        THEN
                BEGIN
                    INSERT INTO anomalies VALUES (new.timestamp, new.id_sensor, 'ANOMALY 1');
                    -- DELETE FROM data_sensori WHERE timestamp = NEW.timestamp AND id_sensor = NEW.id_sensor;
                    SET @exception = CONCAT('SONO STATI TROVATI 2 O PIU VALORI CON LO STESSO TIMESTAMP');
                    SIGNAL SQLSTATE '02000'
                    SET MESSAGE_TEXT = @exception;
                END;
        END IF;
    END $$
DELIMITER ;










