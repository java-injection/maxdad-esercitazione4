-- funzioni
SET GLOBAL log_bin_trust_function_creators = 1;

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
drop user if exists 'account'@'localhost';
CREATE USER 'account'@'localhost' IDENTIFIED BY 'Massimobrutto' ;
GRANT EXECUTE
ON esercitazione4.*
TO 'account'@'localhost';
drop function if exists randnum;

delimiter $$
CREATE DEFINER='account'@'localhost' function RandNum ( 
 minimo int, massimo int
)
returns  int 
not deterministic

SQL SECURITY DEFINER 
begin
if(minimo is null or massimo is null)
then 
	SET @exception = 'PESCE METTIMI DEI NUMERI';
    signal sqlstate '45000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 1062;
END IF;
if(minimo = massimo)
then 
	set @mammt =1;
	SET @exception = 'PESCE sono identici';
    signal sqlstate '01000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 22023;
END IF;
return FLOOR(minimo + RAND()*(massimo - minimo + 1)) ; 
end $$
delimiter ;

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
drop function if exists generate_jsons1;
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