CREATE OR REPLACE PROCEDURE create_users_table()
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS users;
CREATE OR REPLACE TABLE  users(
  id INT PRIMARY KEY AUTO_INCREMENT,
  username varchar(15),
  sessionID varchar(50),
);
END;
$function$;

CREATE OR REPLACE PROCEDURE create_board()
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS board;
CREATE OR REPLACE TABLE board(
    board_id INT PRIMARY KEY AUTO_INCREMENT,
    player1ID INT,
    player2ID INT,
    move1 enum ('r','p','s','EMPTY') DEFAULT 'EMPTY',
    move2 enum ('r','p','s','EMPTY') DEFAULT 'EMPTY',
);
END;
$function$;

CREATE OR REPLACE PROCEDURE create_status()
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS game_status;
CREATE OR REPLACE TABLE game_status(
    status enum('not_active','initialized','started','ended','aborted') NOT NULL DEFAULT 'not_active',
    board_id INT,
    pl1_score INT DEFAULT 0,
    pl2_score INT DEFAULT 0,
    last_change timestamp NULL DEFAULT current_timestamp()
);
END;
$function$;



DELIMITER $$
CREATE OR REPLACE PROCEDURE create_status()
BEGIN
CREATE OR REPLACE TABLE game_status(
    status enum('not_active','initialized','started','ended','aborted') NOT NULL DEFAULT 'not_active',
    board_id INT,
    pl1_score INT DEFAULT 0,
    pl2_score INT DEFAULT 0,
    last_change timestamp NULL DEFAULT current_timestamp()
);
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE f1(board_id int)
--boolean
BEGIN
    DECLARE p1 ,p2 varchar(5);--player move for this round
    DECLARE s1 ,s2 INT;--score of player 1 and 2

    SET p1 :=(SELECT b.move1 from board b where b.board_id=board_id);
    SET p2 :=(SELECT b.move2 from board b where b.board_id=board_id);
    SET s1 :=(SELECT g.pl1_score from game_status g where g.board_id=board_id);
    SET s2 :=(SELECT g.pl2_score from game_status g where g.board_id=board_id);

    
    IF s1+s2==5 THEN
    RETURN FALSE;
    ELSE IF p1!='EMPTY' AND p2!='EMPTY' THEN
    RETURN FALSE;
    ELSE IF     
    END IF; 
END $$
DELIMITER ;


LANGUAGE plpgsql
AS $function$
declare
BEGIN
    END;
$function$;
