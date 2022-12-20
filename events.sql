-- event

-- event sensor_1
DROP EVENT IF EXISTS sensor_1;

DELIMITER $$
CREATE EVENT sensor_1
    ON SCHEDULE EVERY 1 SECOND
        STARTS now()
        ENDS now() + INTERVAL 40 SECOND
    ON COMPLETION PRESERVE
    DO BEGIN

    DECLARE errno INT;
    DECLARE msg TEXT;
	DECLARE execution INT;
    DECLARE _timestamp TIMESTAMP;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;
    SET _timestamp = NOW();
    SET execution = RAND_INTERVAL(1,3);
    IF
            execution = 1
    THEN
        BEGIN
            DECLARE voltage_value INT; -- value
            DECLARE current_value INT; -- value
            DECLARE voltage_value1 INT; -- value
            DECLARE current_value1 INT; -- value
            DECLARE execution1 INT;
            SET execution1 = RAND_INTERVAL(1,5);
            SET voltage_value = RAND_INTERVAL(0,10);
            SET current_value = RAND_INTERVAL(4,20);
            SET voltage_value1 = RAND_INTERVAL(0,10);
            SET current_value1 = RAND_INTERVAL(4,20);
            IF
                    execution1 = 1
            THEN
                BEGIN
                    INSERT INTO data_sensori
                    VALUES(
                              _timestamp,
                              generate_jsons1(voltage_value1,current_value1),

                              1
                          );
                END;
            END IF;

            INSERT INTO data_sensori
            VALUES(
                      _timestamp,
                      generate_jsons1(voltage_value, current_value),
                      1
                  );
        END;
    END IF;


END $$
DELIMITER ;
-- event sensor_2
DROP EVENT IF EXISTS sensor_2;

DELIMITER $$
CREATE EVENT IF NOT EXISTS sensor_2
    ON SCHEDULE EVERY 1 SECOND
        STARTS now()
        ENDS now() + INTERVAL 40 SECOND
    ON COMPLETION PRESERVE
    DO BEGIN
    DECLARE errno INT;
    DECLARE msg TEXT;
	DECLARE execution INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;
    SET execution = RAND_INTERVAL(1,2);
    IF
            execution = 1
    THEN
        BEGIN

            -- set @door_value=coalesce(@door_value,randnum(0,1)); --> tentativo di evitare anomalia 3
            -- set @door_value = not @door_value;

            -- verificare se il valore in tabella STATES è null
            DECLARE door_value INT;
            SET door_value = (SELECT _value FROM states WHERE _key = 'S2_LAST_VALUE');
            IF door_value IS NULL
                THEN
                    BEGIN
                        SET door_value = RAND_INTERVAL(0,1);

                    END;
                ELSE
                    BEGIN
                        SET door_value = NOT door_value;
                    END;
            END IF;
            UPDATE  states SET _value = door_value WHERE _key = 'S2_LAST_VALUE';
            INSERT INTO data_sensori
            VALUES(
                      NOW(),
                      generate_jsons2(door_value),
                      2
                  );
        END;
    END IF;
END $$
DELIMITER ;






