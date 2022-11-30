-- procedure
USE esercitazione4;

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
    DELETE FROM states;
    DELETE FROM warnings;
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
    ALTER EVENT sensor_2 DISABLE;
END $$
DELIMITER ;

-- procedure enable_all_events
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
    ALTER EVENT sensor_2 DISABLE;
END $$
DELIMITER ;

-- procedura warn
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


