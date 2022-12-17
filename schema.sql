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

CREATE OR REPLACE PROCEDURE score_players(board_id int)
RETURNS Boolean
LANGUAGE plpgsql
AS $function$
    DECLARE 
    p1 ,p2 varchar(5);--player move for this round
    s1 ,s2 INT;--score of player 1 and 2
BEGIN
    p1 := (select b.move1 from board b where b.board_id=board_id);
	p2 := (select b.move2 from board b where b.board_id=board_id);
	
    IF p1=='EMPTY' || p2=='EMPTY' THEN
    RETURN FALSE;
    END IF;

    IF p1='r' AND p2 ='s' THEN --P1
END;
$function$;

