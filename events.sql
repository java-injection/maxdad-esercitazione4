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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;

    DECLARE execution INT;
    DECLARE _timestamp TIMESTAMP;
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
                              CONCAT('{
                                  "values": {
                                    "value": [
                                      {
                                        "measure": "voltage",
                                        "unit": "V",
                                        "value": ',voltage_value1,'
                                      },
                                      {
                                        "measure": "current",
                                        "unit": "mA",
                                        "value": ',current_value1,'
                                      }
                                    ]
                                  }
                                }'),

                              1
                          );
                END;
            END IF;

            INSERT INTO data_sensori
            VALUES(
                      _timestamp,
                      CONCAT('{
                                  "values": {
                                    "value": [
                                      {
                                        "measure": "voltage",
                                        "unit": "V",
                                        "value": ',voltage_value,'
                                      },
                                      {
                                        "measure": "current",
                                        "unit": "mA",
                                        "value": ',current_value,'
                                      }
                                    ]
                                  }
                                }'),
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                errno =  MYSQL_ERRNO,
                msg = MESSAGE_TEXT;
            CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
        END;
    DECLARE execution INT;
    SET execution = RAND_INTERVAL(1,5);
    IF
            execution = 1
    THEN
        BEGIN
            -- set @door_value=coalesce(@door_value,randnum(0,1)); --> tentativo di evitare anomalia 3
            -- set @door_value = not @door_value;
            CALL tester();
            INSERT INTO data_sensori
            VALUES(
                      NOW(),
                      generate_jsons2(@door_value),
                      2
                  );
        END;
    END IF;
END $$
DELIMITER ;

