CREATE TYPE move as ENUM ('r','p','s','EMPTY');
CREATE TYPE status as ENUM('not_active','initialized','started','ended','aborted');


CREATE OR REPLACE FUNCTION init()
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
	DROP TABLE IF EXISTS game_status;
	DROP TABLE IF EXISTS board;
	DROP TABLE IF EXISTS users;
	PERFORM create_users_table();
	PERFORM create_board();
	PERFORM create_status();
END;
$function$;


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
    UPDATE board SET move1 = hand::move WHERE id = boardid AND player = 1;
    UPDATE board SET move2 = hand::move WHERE id = boardid AND player = 2;
	PERFORM score_players(boardid);
END;
$function$;

----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION score_players(bid int)
RETURNS Boolean
LANGUAGE plpgsql
AS $function$
    DECLARE 
    p1 varchar(5);--player move for this round
	p2 varchar(5);--player move for this round
    s1 INT;--score of player 1 
	s2 INT;--score of player 2
BEGIN
    p1 := (select b.move1 from board b where b.id=bid);
	p2 := (select b.move2 from board b where b.id=bid);
	
    IF p1='EMPTY' or p2='EMPTY' THEN
    RETURN FALSE;
    END IF;
	
	s1 :=(select pl1_score from game_status where bid=game_status.board_id);
	s2 :=(select pl2_score from game_status where bid=game_status.board_id);
	
	IF s1=3 or s2=3 then return false;END IF;
	
    IF p1='r' AND p2 ='s'
	THEN 
	s1=s1+1;
	update game_status set pl1_score=s1 where board_id=bid;
	ELSIF p1='s' AND p2 ='p'
	THEN 
	s1=s1+1;
	update game_status set pl1_score=s1 where board_id=bid;
	ELSIF p1='p' AND p2 ='r'
	THEN s1=s1+1;
	update game_status set pl1_score=s1 where board_id=bid;
	ELSIF p2='r' AND p1 ='s'
	THEN s2=s2+1;
	update game_status set pl2_score=s2 where board_id=bid;
	ELSIF p2='s' AND p1 ='p'
	THEN 
	s2=s2+1;
	update game_status set pl2_score=s2 where board_id=bid;
	ELSIF p2='p' AND p1 ='r'
	THEN 
	s2=s2+1;
	update game_status set pl2_score=s2 where board_id=bid;
	END IF;
	update board set move1='EMPTY',move2='EMPTY';
	RETURN TRUE;
END;
$function$;

select init();
--test--test--test--test--test--test--test--test--test
insert into users(username) values('xristos');
insert into users(username) values('stratos');
select * from users;
insert into board(player1id, player2id) values(1,2);
select * from board;
insert into game_status(status,board_id,pl1_score,pl2_score,last_change) values ('initialized',1,0,0,now());
select * from game_status;
SELECT play_hand('r',1,1);
SELECT play_hand('p',2,1);
select score_players(1);

--test--test--test--test--test--test--test--test--test


--this is a test for webhooks