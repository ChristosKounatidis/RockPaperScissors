DROP TABLE IF EXISTS game_status;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS move;
DROP TYPE IF EXISTS status;
CREATE TYPE move as ENUM ('r','p','s','EMPTY');
CREATE TYPE status as ENUM('not_active','initialized','started','ended','aborted');

CREATE OR REPLACE FUNCTION create_users_table()
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username varchar(15),
  sessionID varchar(50)
);
END;
$function$;

CREATE OR REPLACE FUNCTION create_board()
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS board;
CREATE TABLE board(
    id SERIAL PRIMARY KEY,
    player1ID INT,
    player2ID INT,
    move1 move DEFAULT 'EMPTY',
    move2 move DEFAULT 'EMPTY',
	CONSTRAINT fk_player1 
		FOREIGN KEY(player1ID) 
			REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT fk_player2
		FOREIGN KEY(player2ID) 
			REFERENCES users(id) ON DELETE CASCADE
);
END;
$function$;

CREATE OR REPLACE FUNCTION create_status()
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
DROP TABLE IF EXISTS game_status;
CREATE TABLE game_status(
	id SERIAL PRIMARY KEY,
    status status NOT NULL DEFAULT 'not_active',
    board_id INT,
    pl1_score INT DEFAULT 0,
    pl2_score INT DEFAULT 0,
    last_change timestamp NULL DEFAULT Current_timestamp,
	CONSTRAINT fk_board 
		FOREIGN KEY(board_id) 
			REFERENCES board(id) ON DELETE CASCADE
);
END;
$function$;

----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION play_hand(hand move, player int, boardid int)
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE board SET move1 = hand WHERE id = boardid AND player = 1;
    UPDATE board SET move2 = hand WHERE id = boardid AND player = 2;
END;
$function$;

----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION score_players(board_id int)
RETURNS Boolean
LANGUAGE plpgsql
AS $function$
    DECLARE 
    p1 varchar(5);--player move for this round
	p2 varchar(5);--player move for this round
    s1 INT;--score of player 1 
	s2 INT;--score of player 2
BEGIN
    p1 := (select b.move1 from board b where b.board_id=board_id);
	p2 := (select b.move2 from board b where b.board_id=board_id);
	
    IF p1=='EMPTY' || p2=='EMPTY' THEN
    RETURN FALSE;
    END IF;

    IF p1='r' AND p2 ='s' THEN --P1
	
	END IF;
END;
$function$;

SELECT create_users_table();
SELECT create_board();
SELECT create_status();
--SELECT score_players();
--test--test--test--test--test--test--test--test--test
insert into users(username) values('xristos');
insert into users(username) values('stratos');
select * from users;
insert into board(player1id, player2id) values(1,2);
select * from board;
SELECT play_hand('r',1,1);
SELECT play_hand('p',2,1);

--test--test--test--test--test--test--test--test--test