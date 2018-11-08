/*============================
Create Tables
============================*/

CREATE TABLE account (
  username VARCHAR(50) PRIMARY KEY,
  password CHAR(64) NOT NULL,
  role VARCHAR(5) NOT NULL CHECK (role IN ('admin', 'user')),
  full_name VARCHAR(255) NOT NULL,
  phone NUMERIC NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE item (
  item_id SERIAL PRIMARY KEY,
  item_name VARCHAR(255) NOT NULL,
  time_created TIMESTAMP NOT NULL CHECK (time_created<=bid_start),
  start_price NUMERIC NOT NULL DEFAULT 0.0,
  bid_start TIMESTAMP NOT NULL,
  bid_end TIMESTAMP NOT NULL CHECK (bid_start<bid_end),
  type VARCHAR(64) NOT NULL CHECK (type IN ('Electronics', 'Tools', 'Appliances', 
  'Furniture', 'Books', 'Music', 'Sports')),
  description VARCHAR(255) NOT NULL,
  img_src VARCHAR(255) NOT NULL,
  borrow_duration INTEGER NOT NULL,
  address VARCHAR(255) NOT NULL,
  highest_bid_id INTEGER UNIQUE,
  username VARCHAR(50) REFERENCES account(username)
   ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE bid (
  bid_id SERIAL PRIMARY KEY,
  time_created TIMESTAMP NOT NULL,
  bid_amount NUMERIC NOT NULL,
  username VARCHAR(50) REFERENCES account(username) 
  ON UPDATE CASCADE ON DELETE CASCADE,
  item_id INTEGER REFERENCES item(item_id)
  ON UPDATE CASCADE ON DELETE CASCADE
);

/*============================
Create Functions
============================*/

CREATE OR REPLACE FUNCTION update_highest_bid() RETURNS TRIGGER AS $update_highest_bid$
  BEGIN
    UPDATE item SET highest_bid_id = new.bid_id where item_id = new.item_id;

    RAISE NOTICE 'Updated highest_bid_id to %', new.bid_id;

	  RETURN new;
  END
$update_highest_bid$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_valid_bid() RETURNS TRIGGER AS $check_valid_bid$
  DECLARE
    target RECORD;
  BEGIN
    SELECT i.highest_bid_id, i.bid_start, i.bid_end, i.username,
    CASE WHEN i.highest_bid_id IS NULL THEN i.start_price ELSE b.bid_amount END AS curr_bid_amt
    INTO STRICT target
    FROM item i LEFT OUTER JOIN bid b ON i.highest_bid_id = b.bid_id
    WHERE i.item_id = new.item_id;

    IF new.time_created < target.bid_start OR target.bid_end < new.time_created THEN
      RAISE EXCEPTION 'Item not open for bidding';
    ELSIF new.username = target.username THEN
   	  RAISE EXCEPTION 'Unable to bid for own item';
   	ELSIF new.bid_amount <= target.curr_bid_amt THEN
      RAISE EXCEPTION 'Min bid amount not met';
 	  END IF;

    RAISE NOTICE 'Check bid success';

    RETURN new;
  END
$check_valid_bid$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION next_highest_bid() RETURNS TRIGGER AS $next_highest_bid$
  DECLARE
    target RECORD;
    curr_bid RECORD;
  BEGIN
    SELECT i.item_id, i.bid_end FROM item i INTO target WHERE i.item_id = old.item_id;

    IF target.bid_end < CURRENT_TIMESTAMP THEN
      RAISE EXCEPTION 'Unable to delete closed bid';
    END IF;

    FOR curr_bid IN
      SELECT b.bid_id
      FROM bid b
      WHERE b.item_id = old.item_id AND b.bid_amount >= ALL(
        SELECT b1.bid_amount FROM bid b1
        WHERE b1.item_id=old.item_id
      )
    LOOP
      UPDATE item SET highest_bid_id = curr_bid.bid_id
      WHERE item_id = old.item_id;

      RAISE NOTICE 'Updated highest_bid_id to %', curr_bid.bid_id;

      RETURN old;
    END LOOP;

    UPDATE item SET highest_bid_id = NULL where item_id = old.item_id;
    RAISE NOTICE 'Set highest_bid_id to NULL';

    RETURN old;
  END
$next_highest_bid$
LANGUAGE plpgsql;

/*============================
Create Triggers
============================*/

CREATE TRIGGER before_bid_insert BEFORE INSERT ON bid
  FOR EACH ROW EXECUTE PROCEDURE check_valid_bid();

CREATE TRIGGER after_bid_insert AFTER INSERT ON bid
  FOR EACH ROW EXECUTE PROCEDURE update_highest_bid();

CREATE TRIGGER after_bid_delete AFTER DELETE ON bid
  FOR EACH ROW EXECUTE PROCEDURE next_highest_bid();