-- funzioni
USE esercitazione4;
--
DROP FUNCTION IF EXISTS s2_last_value_key;
DELIMITER &&
CREATE FUNCTION S2_LAST_VALUE_KEY()
    RETURNS CHAR(15)
    DETERMINISTIC
BEGIN
    RETURN 's2_last_value';
END &&
DELIMITER ;

-- random number generator
DROP FUNCTION IF EXISTS randnum;
delimiter $$
CREATE
    DEFINER = 'account'@'localhost' FUNCTION RandNum(
    minimo INT, massimo INT
)
    RETURNS INT
    NOT DETERMINISTIC
    SQL SECURITY DEFINER
BEGIN
    IF (minimo is null or massimo is null)
    then
        SET @exception = 'PESCE METTIMI DEI NUMERI';
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = @exception,
                MYSQL_ERRNO = 1062;
    END IF;
    IF (minimo = massimo)
    THEN
        BEGIN
            SET @mammt = 1;
            SET @exception = 'PESCE sono identici';
            SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = @exception,
                MYSQL_ERRNO = 22023;
        END;
    END IF;
END $$
DELIMITER ;

-- JSON GENERATOR FOR door_value

drop function if exists generate_jsons2;
DELIMITER $$
CREATE FUNCTION generate_jsons2(
    door_value BOOLEAN)
    RETURNS JSON
    DETERMINISTIC
BEGIN
    RETURN CONCAT(' {
                        "values": [
                                      {
                                        "measure": "open_closed",
                                        "unit":"open",
                                        "value": ', @door_value, '
                                      }
                        ]
    }');
END $$
DELIMITER ;

-- json generator for current and volt

DELIMITER $$
CREATE FUNCTION generate_jsons1(
    voltage_value INT,
    current_value INT)
    RETURNS JSON
    DETERMINISTIC
BEGIN
    RETURN CONCAT('{
                                  "values": {
                                    "value": [
                                      {
                                        "measure": "voltage",
                                        "unit": "V",
                                        "value": ', voltage_value, '
                                      },
                                      {
                                        "measure": "current",
                                        "unit": "mA",
                                        "value": ', current_value, '
                                      }
                                    ]
                                  }
                                }');
END $$
DELIMITER ;