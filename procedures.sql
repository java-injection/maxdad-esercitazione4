-- procedure

USE esercitazione4;

DROP PROCEDURE SHUT_DOWN;
DELIMITER &&
CREATE PROCEDURE SHUT_DOWN()
BEGIN
    DROP EVENT IF EXISTS SENSOR_1;
    DROP EVENT IF EXISTS SENSOR_2;
    CALL CLEANUP();
    CALL activate_anomaly_1(TRUE);
    CALL activate_anomaly_2(TRUE);
END &&
DELIMITER ;


CALL SHUT_DOWN();



-- procedura tester
DROP PROCEDURE IF EXISTS tester;

DELIMITER $$
CREATE PROCEDURE tester()
BEGIN
    SET @door_value=coalesce(@door_value,RAND_INTERVAL(0,1));
-- select @door_value;
    SET @door_value = NOT @door_value;
-- select @door_value;
END $$
DELIMITER ;






-- procedura cleanup
DROP PROCEDURE IF EXISTS cleanup;

DELIMITER $$
CREATE PROCEDURE cleanup()
BEGIN
    DELETE FROM data_sensori;
    UPDATE  states SET _value = null WHERE _key = 'S2_LAST_VALUE';
    UPDATE  states SET _value = false WHERE _key = 'ANOMALY1_ACTIVE';
    UPDATE  states SET _value = false WHERE _key = 'ANOMALY2_ACTIVE';
    DELETE FROM warnings;
    ALTER TABLE anomalies ENGINE = INNODB;
    DELETE FROM anomalies;
    ALTER TABLE anomalies ENGINE = ARCHIVE;
    DROP EVENT IF EXISTS sensor_1;
    DROP EVENT IF EXISTS sensor_2;
    SELECT * FROM data_sensori;
    SELECT * FROM states;
    SELECT * FROM warnings;
END $$
DELIMITER ;










-- procedura enable_events
DROP PROCEDURE IF EXISTS enable_events;

DELIMITER $$
CREATE PROCEDURE enable_events(
    enable_sensor1 BOOL,
    enable_sensor2 BOOL
)
BEGIN
    DECLARE errno INT;
    DECLARE msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;
    IF
        enable_sensor1
    THEN
        ALTER EVENT sensor_1 ENABLE;
    ELSE
        ALTER EVENT sensor_1 DISABLE;
    END IF;

    IF
        enable_sensor2
    THEN
        ALTER EVENT sensor_2 ENABLE;
    ELSE
        ALTER EVENT sensor_2 DISABLE;
    END IF;
END $$
DELIMITER ;












-- procedura enable_all_events
DROP PROCEDURE IF EXISTS enable_all_events;

DELIMITER $$
CREATE PROCEDURE enable_all_events()
BEGIN
    DECLARE errno INT;
    DECLARE msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;
    ALTER EVENT sensor_1 ENABLE;
    ALTER EVENT sensor_2 ENABLE;
END $$
DELIMITER ;






-- procedura warn??
DROP PROCEDURE IF EXISTS warn;

DELIMITER $$
CREATE PROCEDURE warn(
    message VARCHAR(255),
    level ENUM('INFO','MEDIUM','HIGH')
)
BEGIN
    INSERT INTO warnings VALUES(NOW(),message,level);
END $$
DELIMITER ;








DELIMITER $$
CREATE PROCEDURE activate_anomaly_1(
    anomaly BOOLEAN
)
 BEGIN
     DECLARE errno INT;
     DECLARE msg TEXT;
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
         BEGIN
             GET DIAGNOSTICS CONDITION 1
                 errno =  MYSQL_ERRNO,
                 msg = MESSAGE_TEXT;
             CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
         END;

     UPDATE states SET _value = anomaly WHERE _key = 'ANOMALY1_ACTIVE';

END $$
DELIMITER ;











DELIMITER $$
CREATE PROCEDURE activate_anomaly_2(
    anomaly BOOLEAN
)
BEGIN
    DECLARE errno INT;
    DECLARE msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;

    UPDATE states SET _value = anomaly WHERE _key = 'ANOMALY2_ACTIVE';

END $$
DELIMITER ;

