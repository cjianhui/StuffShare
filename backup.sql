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

CREATE OR REPLACE FUNCTION update_highest_bid() RETURNS TRIGGER AS $update_highest_bid$
  BEGIN
    UPDATE item SET highest_bid_id = new.bid_id where item_id = new.item_id;

    RAISE NOTICE 'Updated highest_bid_id to %', new.bid_id;

	  RETURN new;
  END
$update_highest_bid$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_open_bidding() RETURNS TRIGGER AS $check_open_bidding$
  DECLARE
    target RECORD;
  BEGIN
    SELECT i.item_id, i.bid_end FROM item i INTO target WHERE i.item_id = old.item_id;

    IF target.bid_end < CURRENT_TIMESTAMP THEN
      RAISE EXCEPTION 'Unable to delete closed bid';
    END IF;

    RETURN old;
  END
$check_open_bidding$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION next_highest_bid() RETURNS TRIGGER AS $next_highest_bid$
  DECLARE
    curr_bid RECORD;
  BEGIN

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

CREATE TRIGGER before_bid_delete BEFORE DELETE ON bid
  FOR EACH ROW EXECUTE PROCEDURE check_open_bidding();

CREATE TRIGGER after_bid_delete AFTER DELETE ON bid
  FOR EACH ROW EXECUTE PROCEDURE next_highest_bid();
/*============================
Insert Accounts
============================*/

INSERT INTO account VALUES('eldriclim','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Eldriclim',92733303,'eldriclim@yahoo.com');
INSERT INTO account VALUES('cjianhui','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Cjianhui',92315620,'cjianhui@outlook.com');
INSERT INTO account VALUES('marlene','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Marlene',97684103,'marlene@outlook.com');
INSERT INTO account VALUES('zachary','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Zachary',99521386,'zachary@yahoo.com');
INSERT INTO account VALUES('jiaying','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Jiaying',98486036,'jiaying@hotmail.com');
INSERT INTO account VALUES('jiwen','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Jiwen',94565726,'jiwen@outlook.com');
INSERT INTO account VALUES('fresi','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Fresi',93417435,'fresi@hotmail.com');
INSERT INTO account VALUES('junkai','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Junkai',99247388,'junkai@hotmail.com');
INSERT INTO account VALUES('zoey','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Zoey',97143217,'zoey@gmail.com');
INSERT INTO account VALUES('dao','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Dao',92035411,'dao@gmail.com');
INSERT INTO account VALUES('amar','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Amar',98511232,'amar@yahoo.com');
INSERT INTO account VALUES('alina','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Alina',98652846,'alina@hotmail.com');
INSERT INTO account VALUES('liwen','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Liwen',98623945,'liwen@outlook.com');
INSERT INTO account VALUES('sean','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Sean',96294969,'sean@gmail.com');
INSERT INTO account VALUES('shengran','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Shengran',95129762,'shengran@hotmail.com');
INSERT INTO account VALUES('derek','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Derek',93977107,'derek@outlook.com');
INSERT INTO account VALUES('aiksheng','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Aiksheng',95961179,'aiksheng@outlook.com');
INSERT INTO account VALUES('andy','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Andy',96692385,'andy@outlook.com');
INSERT INTO account VALUES('daniel','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Daniel',93812373,'daniel@outlook.com');
INSERT INTO account VALUES('charlsie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Charlsie',97884702,'charlsie@yahoo.com');
INSERT INTO account VALUES('stan','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Stan',92597734,'stan@hotmail.com');
INSERT INTO account VALUES('lisandra','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Lisandra',98763649,'lisandra@yahoo.com');
INSERT INTO account VALUES('jeremy','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Jeremy',95667471,'jeremy@hotmail.com');
INSERT INTO account VALUES('boyd','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Boyd',98665575,'boyd@yahoo.com');
INSERT INTO account VALUES('kira','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Kira',91984688,'kira@outlook.com');
INSERT INTO account VALUES('karie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Karie',99691274,'karie@gmail.com');
INSERT INTO account VALUES('tynisha','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Tynisha',92880435,'tynisha@yahoo.com');
INSERT INTO account VALUES('tiera','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Tiera',95316938,'tiera@outlook.com');
INSERT INTO account VALUES('monika','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Monika',91296332,'monika@gmail.com');
INSERT INTO account VALUES('jarvis','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Jarvis',91752526,'jarvis@yahoo.com');
INSERT INTO account VALUES('alvera','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Alvera',92191447,'alvera@outlook.com');
INSERT INTO account VALUES('randall','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Randall',94654525,'randall@outlook.com');
INSERT INTO account VALUES('cathie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Cathie',98239832,'cathie@hotmail.com');
INSERT INTO account VALUES('nakesha','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Nakesha',92691626,'nakesha@gmail.com');
INSERT INTO account VALUES('rosalva','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Rosalva',99333188,'rosalva@hotmail.com');
INSERT INTO account VALUES('karina','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Karina',97536609,'karina@yahoo.com');
INSERT INTO account VALUES('nilda','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Nilda',97469884,'nilda@gmail.com');
INSERT INTO account VALUES('georgine','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Georgine',97278442,'georgine@outlook.com');
INSERT INTO account VALUES('chana','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Chana',93740959,'chana@gmail.com');
INSERT INTO account VALUES('melissia','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Melissia',98743298,'melissia@outlook.com');
INSERT INTO account VALUES('chad','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Chad',94331384,'chad@outlook.com');
INSERT INTO account VALUES('marquita','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Marquita',99000860,'marquita@hotmail.com');
INSERT INTO account VALUES('julissa','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Julissa',94231963,'julissa@outlook.com');
INSERT INTO account VALUES('irvin','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Irvin',95357032,'irvin@gmail.com');
INSERT INTO account VALUES('douglas','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Douglas',95449119,'douglas@hotmail.com');
INSERT INTO account VALUES('dot','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Dot',94089188,'dot@yahoo.com');
INSERT INTO account VALUES('britany','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Britany',94601795,'britany@outlook.com');
INSERT INTO account VALUES('colby','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Colby',91818051,'colby@gmail.com');
INSERT INTO account VALUES('roslyn','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Roslyn',92711718,'roslyn@outlook.com');
INSERT INTO account VALUES('masako','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Masako',95978025,'masako@yahoo.com');
INSERT INTO account VALUES('robbi','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Robbi',95137723,'robbi@yahoo.com');
INSERT INTO account VALUES('natalya','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Natalya',97361928,'natalya@yahoo.com');
INSERT INTO account VALUES('margie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Margie',98344353,'margie@yahoo.com');
INSERT INTO account VALUES('maricela','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Maricela',95880255,'maricela@gmail.com');
INSERT INTO account VALUES('mattie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Mattie',95635995,'mattie@yahoo.com');
INSERT INTO account VALUES('alejandrina','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Alejandrina',94954479,'alejandrina@yahoo.com');
INSERT INTO account VALUES('adalberto','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Adalberto',96963003,'adalberto@outlook.com');
INSERT INTO account VALUES('ray','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Ray',97336528,'ray@hotmail.com');
INSERT INTO account VALUES('holli','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Holli',94699404,'holli@yahoo.com');
INSERT INTO account VALUES('francesco','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Francesco',96750900,'francesco@hotmail.com');
INSERT INTO account VALUES('arturo','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Arturo',92652416,'arturo@yahoo.com');
INSERT INTO account VALUES('jim','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Jim',96897433,'jim@hotmail.com');
INSERT INTO account VALUES('luis','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Luis',96831763,'luis@yahoo.com');
INSERT INTO account VALUES('kristie','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Kristie',99126731,'kristie@hotmail.com');
INSERT INTO account VALUES('sharleen','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Sharleen',99081765,'sharleen@gmail.com');
INSERT INTO account VALUES('sixta','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Sixta',94653205,'sixta@hotmail.com');
INSERT INTO account VALUES('bernarda','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Bernarda',99185599,'bernarda@yahoo.com');
INSERT INTO account VALUES('kimberely','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Kimberely',99994248,'kimberely@gmail.com');
INSERT INTO account VALUES('freida','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','Freida',93082001,'freida@outlook.com');
INSERT INTO account VALUES('admin','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','admin','Jan',93082001,'admin@outlook.com');
/*============================
Insert Items
============================*/

INSERT INTO item VALUES(DEFAULT, 'pastry making board, 100% new','2018-11-01 19:49:07',25,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Appliances', 'big enough pastry making board, material with bamboo wood, 100% new, size:67cm x 41cm  also good for hand made noodle or dumplings', '231ed91fa6e7687305ef349e0f83137.jpg', 10, 'Caldecott MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, '25pcs Dinnerware  Teapot Set','2018-11-07 19:49:07',128,'2018-11-11 19:49:07','2018-11-13 23:59:59', 'Appliances', '25pcs Dinnerware  Teapot Set  Price : $128 free delivery Material : Porcelain', 'cf7c9ad01d30c55971d72fd1ea7281.jpg', 9, 'Expo MRT station', NULL, 'kira');
INSERT INTO item VALUES(DEFAULT, 'INSTOCKS METAL STRAW','2018-11-07 19:49:07',1,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Appliances', 'INSTOCKS!!! 7 COLORS AVAILABLE‼️ UPDATED: 06/10/18 304 STAINLESS STEEL STRAW ALL THE PHOTOS TAKEN BY ME!!  SAVE THE EARTH 🌏 🍀 GREAT FOR GIFTS 🎁   👉ITEM BASED ON FIRST PAY FIRST SERVE!!  LIMITED STOCK ONLY‼️  READY STOCK!!  AVAILABLE IN', '5e6b3a5cb9c8266ee51ecb6c9ea32114.jpg', 10, 'Choa Chu Kang MRT/LRT station', NULL, 'dao');
INSERT INTO item VALUES(DEFAULT, 'Toilet curtain','2018-11-07 19:49:07',2,'2018-11-12 19:49:07','2018-11-15 23:59:59', 'Appliances', 'Bought it 2years ago but never use it at all.   Self-collect only at 150089.', '492a971b47996391bf5940f3d9c50a9c.jpg', 3, 'HarbourFront MRT station', NULL, 'kristie');
INSERT INTO item VALUES(DEFAULT, 'Fridge Commercial Refrigerator Quick Budget Repair Service','2018-11-03 19:49:07',1,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Appliances', 'Commercial fridge refrigerator all type design  Cheapest gas topping , repairing gas leakage  On the spot fix @ 68818662 ...  Display cake / sushi chiller , wine chiller , counter fridge , top freezer , drink glass display chiller , condenser compressor m', 'ad219e5f7727186316affa898fcdf0da.jpg', 4, 'Prince Edward Road MRT station', NULL, 'sean');
INSERT INTO item VALUES(DEFAULT, '9.5kg Hitachi Washing Machine','2018-11-05 19:49:07',80,'2018-11-06 19:49:07','2018-11-07 23:59:59', 'Appliances', '9.5kg Hitachi washing machine for sale.', '11cfc01b6458a2797b5ad6759ca6f8de.jpg', 9, 'MacPherson MRT station', NULL, 'rosalva');
INSERT INTO item VALUES(DEFAULT, 'Le Creuset mini cocotte stoneware mist gray','2018-11-07 19:49:07',35,'2018-11-08 19:49:07','2018-11-09 23:59:59', 'Appliances', 'Brand new in box Color :mist gray 0.25liter 8oz  250℃ oven safe / microwave   Double oil /steam', 'be39ed76b6e03045d8076ff766d3a099.jpg', 3, 'Jurong West MRT station', NULL, 'roslyn');
INSERT INTO item VALUES(DEFAULT, 'Vitamix Professional Series 750 Blender Black Self-Cleaning, Programmable','2018-11-03 19:49:07',1188,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Appliances', 'BNIB Selling this because I have extra set. Vitamix has been one of the most powerful blender I used but you cannot use two at once, so selling this. ---------------------------------- Colour: Black 2.2 Horsepower Product specs: 17.5 x 9.4 x 7.7 in This p', 'ad444c1dea2da6dd5fb3c91617a9c751.jpg', 7, 'Bishan MRT station', NULL, 'dot');
INSERT INTO item VALUES(DEFAULT, 'Philips 55PUT6103 4k UHD Smart Led Tv','2018-11-03 19:49:07',1078,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Appliances', '. Philips 2018 New Model . Brand New In Box . 4k Resolution @ 3840 x 2160p . Pixel Precise Ultra HD . Micro Dimming Clarity . Ultra Slim  Refined Design . 4k HDR+ Enchancer  . Quad Core Processor . Built In WiFi  Smart Tv . 3 HDMI  2 USB Inputs  Freebies:', 'dcbe710ee745a619cc12f8fdfcc4572.jpg', 9, 'Caldecott MRT station', NULL, 'alvera');
INSERT INTO item VALUES(DEFAULT, 'Dehumidifier','2018-11-05 19:49:07',25,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Appliances', 'Cooling  Air Care', '5cefea7c4aaec4aa1fe93596642419e8.jpg', 3, 'Kovan MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Used TV','2018-11-08 19:49:07',50,'2018-11-12 19:49:07','2018-11-13 23:59:59', 'Appliances', 'Theres 3 Tv. 2 of it is 42 inch and 1 Is 50inch. All have power source. Only 1 x 42inch is faulty. Come and view first.', 'bb68e1d29c41351cc5291adc1dad34b.jpg', 9, 'Bukit Gombak MRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'Mitsubishi folio fridge','2018-11-02 19:49:07',300,'2018-11-05 19:49:07','2018-11-08 23:59:59', 'Appliances', 'Still in good condition  Moving house  Cash carry arrange your own delivery.  Blk 264C compassvale bow', '404b2d2cd993c850aa3dfc27cbaa58ce.jpg', 6, 'Farrer Park MRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'Philips Table Grill HD4419','2018-11-02 19:49:07',50,'2018-11-03 19:49:07','2018-11-04 23:59:59', 'Appliances', 'Philips electric table grill. Used only once. As good as new.', 'e27b754848b19e4a781198305dca8285.jpg', 6, 'Bayshore MRT station', NULL, 'robbi');
INSERT INTO item VALUES(DEFAULT, 'Food storage containers','2018-11-06 19:49:07',10,'2018-11-10 19:49:07','2018-11-13 23:59:59', 'Appliances', 'Brand new food storage container set  49 pcs within one box  Pm me if keen', 'd9aabe71c3a0e410fd4cf73ac932ed5f.jpg', 7, 'Beauty World MRT station', NULL, 'natalya');
INSERT INTO item VALUES(DEFAULT, 'WMF Cutlery Set 12 new','2018-11-08 19:49:07',45,'2018-11-13 19:49:07','2018-11-15 23:59:59', 'Appliances', 'Cromargan 18/10 stainless steel.  6 spoon and 6 forks.', '33cc8129053e979528f06996234600a1.jpg', 8, 'Jurong Pier MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, 'BNIB Slow Cooker','2018-11-03 19:49:07',10,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Appliances', 'Brand new in box, model: KSC-15(W). Buy now and get free used Juicer Maker', 'b58f6741ceedc3a43a033491704e89b2.jpg', 9, 'Bugis MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, '*Brand New* Starbucks Doodle It Coffee / Tea Tumbler','2018-11-08 19:49:07',20,'2018-11-13 19:49:07','2018-11-16 23:59:59', 'Appliances', 'Brand new  never used before! Capacity: 16oz / 473ml (approximately)  Keep your drinks cold or hot however you like it! Doodle on the tumbler to keep track of your tasks for the day and erase it at the end of the day! Comes with non-permanent marker  Guar', '41eeeb69e5bdebcd15a52511b392b067.jpg', 4, 'Newton MRT station', NULL, 'sean');
INSERT INTO item VALUES(DEFAULT, '22” LED TV','2018-11-07 19:49:07',129,'2018-11-11 19:49:07','2018-11-12 23:59:59', 'Appliances', 'Seldom use 22” LED TV.   Used as Monitor  Seldom use', '3eba941b26142f84bab258bc840caa55.jpg', 3, 'Woodleigh MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, 'LG Washing Machine','2018-11-07 19:49:07',180,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Appliances', 'Cleaning  Laundry', '21908547bc8d04a3410268e4a9d5c6a6.jpg', 10, 'Lavender MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, 'Apple TV 3rd Gen','2018-11-05 19:49:07',50,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Appliances', 'Brand: Others Screen Size: Up to 23 in', '5dfc946988d012514461032c8715866f.jpg', 7, 'Jurong East MRT station', NULL, 'sharleen');
INSERT INTO item VALUES(DEFAULT, 'Panasonic Inventor Fridge','2018-11-02 19:49:07',350,'2018-11-07 19:49:07','2018-11-08 23:59:59', 'Appliances', 'Large size fridge Excellent condition 4 years old Transport not included please arrange your own', '1c8b5831b62afbdd7bea38d8b5b46b2.jpg', 10, 'Kovan MRT station', NULL, 'jeremy');
INSERT INTO item VALUES(DEFAULT, 'Powerpac 0.6L Rice cooker','2018-11-08 19:49:07',8,'2018-11-13 19:49:07','2018-11-15 23:59:59', 'Appliances', '0.6 litre rice cooker (1-3 pax)', '3e59a61a608af03143e909ec8abb3e25.jpg', 9, 'Esplanade MRT station', NULL, 'margie');
INSERT INTO item VALUES(DEFAULT, 'ELECTRIC OVEN','2018-11-02 19:49:07',88,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Appliances', 'BRAND NEW IN BOX 30L STAINLESS STEEL ELECTRIC OVEN  RECEIVED AS A GIFT', '3367468ddbfe88eabf462aaf1e13c949.jpg', 10, 'Bendemeer MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Toyomi Clip Fan 1810s - Brand New in Box!','2018-11-05 19:49:07',25,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Appliances', 'Purchased online, opened it and realized that the clip doesnt fit onto my headboard. Cant be bothered to ship it back. Purchased today (have receipt for proof), comes with one year warranty. It has been taken out of the box, and packed back in - never plu', 'fdec77fea09dda9f21578bf10ab7b823.jpg', 5, 'Orchard MRT station', NULL, 'eldriclim');
INSERT INTO item VALUES(DEFAULT, 'Pot Glass','2018-11-08 19:49:07',5,'2018-11-13 19:49:07','2018-11-16 23:59:59', 'Appliances', 'Only 1 available', 'e90af5c9d1c9029ecd26dc8bfdcd57bb.jpg', 5, 'Bukit Panjang MRT/LRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, 'Mookata BBQ Hot Pot','2018-11-06 19:49:07',80,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Appliances', 'BNIB 2 in 1  Mookata BBQ Hot Pot', 'dea7955eb87c4a061f207f66436072d7.jpg', 10, 'Bedok North MRT station', NULL, 'freida');
INSERT INTO item VALUES(DEFAULT, '43-inch HD TV (Near Thompson Plaza)','2018-11-08 19:49:07',450,'2018-11-10 19:49:07','2018-11-14 23:59:59', 'Appliances', '6 months old, seldom used, almost brand new, 43-inch big screen, HD, wall mount rack + original TV box. Self collection. Asking for 450 SGD. Negotiable.', 'b62d664ee963e177dae9959e9f02f45a.jpg', 5, 'Changi Airport MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'RARE Starbucks iconic Mug - Vancouver','2018-11-08 19:49:07',90,'2018-11-10 19:49:07','2018-11-11 23:59:59', 'Appliances', 'Discontinued -  Rare Vancouver Mugs . I’m a Starbucks collector . Selling my extras mug', '86c8290c69271f2c288a76bf686cd41e.jpg', 9, 'Little India MRT station', NULL, 'melissia');
INSERT INTO item VALUES(DEFAULT, 'IKEA iron stand excellent Condition','2018-11-05 19:49:07',0,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Appliances', 'Cleaning  Laundry', '5d5dab5fc7908317836eb10b17404b8a.jpg', 6, 'Kembangan MRT station', NULL, 'irvin');
INSERT INTO item VALUES(DEFAULT, 'Kenwood smoothie maker - blend xtract and go','2018-11-08 19:49:07',50,'2018-11-11 19:49:07','2018-11-16 23:59:59', 'Appliances', 'Kitchenware', 'e9962d97cbc586883a43e2a3b3ba5fd1.jpg', 9, 'Bedok MRT station', NULL, 'alejandrina');
INSERT INTO item VALUES(DEFAULT, 'Samsung 55 inch UA55D7000 Series 7 Full HD 3D LED TV','2018-11-02 19:49:07',200,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Appliances', 'Only faulty : Picture has green lines other  Key functions are fine: Resolution: 1,920 x 1,080 Picture Engine: 3D HyperReal Engine Ultra Clear Panel Clear Motion Rate 600 Dolby Digital Plus / Dolby Pulse SRS TheatreSound HD Wide Colour Enhancer Plus Speak', 'f81f99fdbee160adca5c7eec204a1bf2.jpg', 6, 'Mayflower MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'INVINCIBLE IRON MAN (1968) #128','2018-11-08 19:49:07',95,'2018-11-13 19:49:07','2018-11-15 23:59:59', 'Books', 'Title : Demon In a Bottle! Synopsis : Tony Stark battles alcoholism Credits : Bob Layton (Co-Plot) David Michelinie (Script), John Romita, Jr. (Pencils), Bob Layton (Inks), Bob Sharen (Colors), John Costanza (Letters)', '3fb76c445a0d71d4944ac478cec73665.jpg', 6, 'Beauty World MRT station', NULL, 'melissia');
INSERT INTO item VALUES(DEFAULT, 'The Road We Must Travel','2018-11-08 19:49:07',7,'2018-11-13 19:49:07','2018-11-16 23:59:59', 'Books', 'Christian living book - in good condition   $5 for fast deal. For local mail, add $1  #francis Chan #eugene Peterson #bill hybels', 'dd7516d56ba3f0fc55f4076c2917fb1b.jpg', 7, 'Choa Chu Kang MRT/LRT station', NULL, 'colby');
INSERT INTO item VALUES(DEFAULT, 'White Polymailers','2018-11-07 19:49:07',2,'2018-11-07 19:49:07','2018-11-11 23:59:59', 'Books', 'One of the cheapest white poly mailers envelope bags or postbag courier mailers with adhesive tape at the flap area for all your blog shop and carousell sellers posting or mailing needs.  All these are the same polymailers which I use to mail my items to ', '91647d32618df2fd357ce872bd7ea87.jpg', 10, 'Marine Terrace MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, '🚚 Books, books, books!','2018-11-01 19:49:07',0,'2018-11-05 19:49:07','2018-11-08 23:59:59', 'Books', 'Get a 20% discount if you get 3 or more books from any of my listings.  1. The Korean Pentecost (William Blair and Bruce Hunt) $5 2. Cultivating the Gifts and Fruits of the Holy Spirit (Fuchsia Pickett) $6 reserved 3. Prophets and Personal Prophecy (Vol 1', '6338eb3660e196c86a9550229fa4bd75.jpg', 4, 'Tampines MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'Geronimo Stilton 11-20','2018-11-01 19:49:07',40,'2018-11-02 19:49:07','2018-11-04 23:59:59', 'Books', 'Brand new in box  Book 11-20 as a set  Piece is fixed  Self collect at Punggol', '2e8cd0065473ccca4310eb8b23af66f1.jpg', 6, 'Promenade MRT station', NULL, 'monika');
INSERT INTO item VALUES(DEFAULT, 'bullet journal supplies','2018-11-02 19:49:07',0,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Books', 'hello !!  im able to help you purchase affordable supplies for your bullet journal. let me know what kind of items youre looking for and ill give you my best rates 🌿🏹  🏹tags: bujo bullet journal moleskin washi tape daiso aesthetic affordable diar', 'd8b6894767087a1c3752eb55ccbbd34f.jpg', 6, 'Dhoby Ghaut MRT station', NULL, 'andy');
INSERT INTO item VALUES(DEFAULT, 'customisable sketches!!','2018-11-01 19:49:07',3,'2018-11-01 19:49:07','2018-11-02 23:59:59', 'Books', '[customisable sketches]   please read till the end so it’ll be less troublesome when you’ll order 💖              [🌞]   basic info!  -[these are basic sketches which are hand drawn by yours truly ∠( ᐛ 」∠)＿ the sketches are original,, wh', '476b10400a43165698cf68cc54d002c5.jpg', 10, 'Choa Chu Kang MRT/LRT station', NULL, 'alejandrina');
INSERT INTO item VALUES(DEFAULT, '[PO] striped cat stickers','2018-11-05 19:49:07',2,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Books', '⭐️Super cute preorder cat stickers for planners :)   ⭐️Price 1 for $2.80 2 for $5.00  ⭐️ 45 stickers per box  Size of stickers: 4.4 x 4.4cm   ⭐️ PO closing date: refer to profile :)  Processing time: 3-4 weeks       ⭐️ Normal mail: +$1', 'bdc41cad2bf3cc504fc6da089bd0f841.jpg', 3, 'Jurong Town Hall MRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, '🚚 Pastel Gradient Post-It','2018-11-01 19:49:07',2,'2018-11-04 19:49:07','2018-11-06 23:59:59', 'Books', 'Pastel Gradient Post-It Available in multiple colors. Choose your preference or I can also randomly give you a color. Buy any 3 Pen/ Post-it from my shop for $5 or 7 for $10.  Local Mail Included :)', '46a722cf5d08351250588dd5cd4869d3.jpg', 9, 'Botanic Gardens MRT station', NULL, 'aiksheng');
INSERT INTO item VALUES(DEFAULT, 'Buku2 madrasah','2018-11-02 19:49:07',0,'2018-11-02 19:49:07','2018-11-03 23:59:59', 'Books', 'Textbooks', '62fcf0eb393b8cd48608f12779abfd11.jpg', 8, 'Toa Payoh MRT station', NULL, 'derek');
INSERT INTO item VALUES(DEFAULT, 'Caffeine - Nov 2018 | English | 40 pages | True PDF | 26.5 MB','2018-11-01 19:49:07',2,'2018-11-01 19:49:07','2018-11-04 23:59:59', 'Books', '✔️This is a soft copy in pdf format.  ✔️If you are interested, kindly provide me your email and your prefer mode of payment either bank transfer or payNow.  ✔️The soft copy will be emailed to you after payment is confirmed. Thanks.', '5ab410e9795a29490aee7148d52bea66.jpg', 3, 'Bendemeer MRT station', NULL, 'jiwen');
INSERT INTO item VALUES(DEFAULT, 'Snoopy beverage carrier','2018-11-03 19:49:07',6,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Books', 'Brand new cup holder for your takeaway bubble tea or any beverage. It is 100% reusable and lets you enjoy your drink without wasting any plastic bag in the process. Look cute and environmentally friendly when you sport one of these cute designs in your ha', '5a0c74f7b263f49ac02297d03a9dda9f.jpg', 10, 'Changi Airport MRT station', NULL, 'daniel');
INSERT INTO item VALUES(DEFAULT, 'Ring for cards','2018-11-07 19:49:07',1,'2018-11-10 19:49:07','2018-11-13 23:59:59', 'Books', 'Two big one small $1.', 'c6f10a5d84d41e5242aeac0aed12206f.jpg', 10, 'Bayshore MRT station', NULL, 'aiksheng');
INSERT INTO item VALUES(DEFAULT, '💚2019💚 Deuter School Bag GOGO Daypack Backpack Work | School | Travel','2018-11-01 19:49:07',71,'2018-11-05 19:49:07','2018-11-10 23:59:59', 'Books', '💚2019💚 Deuter GOGO Daypack Backpack School Bag Work | School | Travel   Retail Price @ $119.00  Have limited stocks only.   Authentic product and is Brand New.  Our Gogo is such a classic that we were pretty cautious to revise it. But we did – and', '3a76284a2c24e5edd826d955f546283e.jpg', 9, 'Tawas MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, '[ORIGINAL] Goodnight Moon','2018-11-07 19:49:07',2,'2018-11-10 19:49:07','2018-11-14 23:59:59', 'Books', 'In a great green room, tucked away in bed, is a little bunny. “Goodnight room, goodnight moon.” And to all the familiar things in the softly lit room—to the picture of the three little bears sitting on chairs, to the clocks and his socks, to the mit', '31bb929031250b6ded33f3528e42673.jpg', 5, 'Tengah MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, 'Sarah Dessen/ Keeping The Moon','2018-11-07 19:49:07',5,'2018-11-12 19:49:07','2018-11-14 23:59:59', 'Books', 'Books  Stationery', 'ba7611049b6f6bd27c7a70254e8ddcb0.jpg', 4, 'Pasir Panjang MRT station', NULL, 'mattie');
INSERT INTO item VALUES(DEFAULT, 'This Lullaby by Sarah Dessen','2018-11-05 19:49:07',8,'2018-11-07 19:49:07','2018-11-12 23:59:59', 'Books', 'Book Size: 210 x 139 mm Extent: 368 pages (Paperback)  Publisher: Penguin Young Readers Good condition, Yellowed on side of the pages + Free Postage		  Meet up at MRT Stations or Bus Interchanges in the West at my convenience.', 'fe2579b387753b8565025eca57d43960.jpg', 3, 'Paya Lebar MRT station', NULL, 'julissa');
INSERT INTO item VALUES(DEFAULT, 'Murakami’s Men Without Women','2018-11-08 19:49:07',15,'2018-11-12 19:49:07','2018-11-14 23:59:59', 'Books', '9/10 condition  Nego for fast deals', '2675052cb2ee02d8664f8fef940a8089.jpg', 8, 'Rochor MRT station', NULL, 'shengran');
INSERT INTO item VALUES(DEFAULT, 'Marble Pattern Post It Notes','2018-11-07 19:49:07',2,'2018-11-12 19:49:07','2018-11-15 23:59:59', 'Books', 'Square: 7.2cm X 7.2cm  Rectangle: 7.5cm X 4.5cm  3 Designs -Marble -Water droplets -Red stripe', '57b5f4dbe5aee22bcd484864685b4f33.jpg', 4, 'Maxwell MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, 'Water Doodle Colouring book','2018-11-04 19:49:07',2,'2018-11-07 19:49:07','2018-11-11 23:59:59', 'Books', 'Water Doodle colouring book Item Code: LO167 Price: $6.90 excludes postage Description:  No-mess painting for kids! This exciting paint-with-water coloring book includes four reusable pages and a refillable water pen. Simply use the pen to color in each s', '268e1b9789a8fef91eb89764bc9a2291.jpg', 8, 'Bukit Batok MRT station', NULL, 'alvera');
INSERT INTO item VALUES(DEFAULT, 'Geronimo Stilton Hardcover books','2018-11-06 19:49:07',10,'2018-11-07 19:49:07','2018-11-09 23:59:59', 'Books', '10 each.They are readable and only a few tears on the cover page.', 'b8abc98601bf5b966fdbbaeb3096aa66.jpg', 7, 'Marine Parade MRT station', NULL, 'nakesha');
INSERT INTO item VALUES(DEFAULT, 'Vintage Tintin Comics','2018-11-05 19:49:07',10,'2018-11-09 19:49:07','2018-11-11 23:59:59', 'Books', 'Selling off my Tintin collection of 17 titles I had since 1990s. Each of them are wrapped with plastic covers   . Condition is 7/10. $10 for 1 and entire collection  of 17 goes for $120', '7c1382679888eec2ba1ec9a5ac985a87.jpg', 4, 'Tawas MRT station', NULL, 'nilda');
INSERT INTO item VALUES(DEFAULT, 'Penco BIC Black ballpoint pen','2018-11-08 19:49:07',4,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Books', '- black ink - add on $0.60 for local postage (not liable for lost mail) or $2.50 for registered post', '61fba6ebc2e354fa2da3f4abada2fda9.jpg', 6, 'Buangkok MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'Penco BIC fieldnotes ballpoint pen','2018-11-07 19:49:07',5,'2018-11-07 19:49:07','2018-11-09 23:59:59', 'Books', '- black ink - add on $0.60 for local postage (not liable for lost mail) or $2.50 for registered post', 'b11c6f66b31fc0e4bfd16a767c353d7c.jpg', 4, 'Admiralty MRT station', NULL, 'freida');
INSERT INTO item VALUES(DEFAULT, 'Tintin comics','2018-11-01 19:49:07',120,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Books', '22 comics from the Tintin collection including the rare Tintin  the Lake of Sharks. Original release from the 80s. In decent condition except for some yellowing due to age. Viewing  collection from my home.', 'dedd824e143efe81e7bc901acac2225.jpg', 10, 'Mayflower MRT station', NULL, 'bernarda');
INSERT INTO item VALUES(DEFAULT, 'BUJO GRAB BAGS [EDITION 2.0]','2018-11-01 19:49:07',8,'2018-11-02 19:49:07','2018-11-03 23:59:59', 'Books', '💓💓cool stationery grab bags, with many many items!! PERFECT for bujo journalling, scrapbooking, card making, or can be given as birthday presents or christmas gifts wOW ✔aesthetic🔥🔥 ____________________________________________ Set A: THE lit', '6b3afc53dc2eebbce5dbab41dcb8ba71.jpg', 4, 'Lorong Chuan MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, 'GQ Australia - Nov 2018 | English | 180 pages | True PDF | 25.2 MB','2018-11-01 19:49:07',2,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Books', '✔️This is a soft copy in pdf format.  ✔️If you are interested, kindly provide me your email and your prefer mode of payment either bank transfer or payNow.  ✔️The soft copy will be emailed to you after payment is confirmed. Thanks.', '4eafffb865710396ed50dab3f1b20829.jpg', 7, 'Orchard MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'A4 Sticker/Label/ Adhesive Paper','2018-11-05 19:49:07',1,'2018-11-05 19:49:07','2018-11-07 23:59:59', 'Books', 'Cheapest in town. Not pre-cut.  10cents per piece if buy in bulk (above 50 pcs)     Tags: label, sticker, matte, self-printing, glossy, cheapest, adhesive, paper', '4a4c32c6fdbb9102059dc06d670a296d.jpg', 4, 'Sungei Bedok MRT station', NULL, 'britany');
INSERT INTO item VALUES(DEFAULT, 'Sharpie Black','2018-11-04 19:49:07',2,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Books', '💡hello CREATIVE! Welcome to Crafters Hub !  ✉ Free delivery for deals  $50 🚉 Strictly by Mail only, estimated 2 - 3 working days for delivery 📮 or Self Collect at Block 28D Dover Crescent ⛴ Restock every 2 weeks  Sharpie marks bright, strong ', '4e3bbe2a354882c47e820037dfbeffa3.jpg', 5, 'Botanic Gardens MRT station', NULL, 'sharleen');
INSERT INTO item VALUES(DEFAULT, '[STI]Cute Totoro Stickers','2018-11-08 19:49:07',2,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Books', 'Cute Totoro stickers, great for scrapbooking, diary, journal, sealing etc. Check my listing for other design. Spesification: Size: Various size approximately 4 x 3.5 cm Package includes: 1 x 38 stickers Status: IN STOCK', '82f1b2a431a78bcdcd966472bdf4d7b5.jpg', 10, 'Bahar Junction MRT station', NULL, 'chad');
INSERT INTO item VALUES(DEFAULT, 'Polar M400 with Heart Sensor Unit (Neg.)','2018-11-02 19:49:07',300,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Electronics', 'Brand New Polar Watch with heart Beat Sensor and stripe  Won On Marathon Event', '3c262359f1118ecbf5f159cab86d385.jpg', 3, 'Corporation MRT station', NULL, 'junkai');
INSERT INTO item VALUES(DEFAULT, 'Digital Tv Antenna','2018-11-03 19:49:07',27,'2018-11-04 19:49:07','2018-11-06 23:59:59', 'Electronics', 'Brand New Digital Tv Antenna  Brand: NewMedia Solutions  For use together with digital set top box (not included)  Come with copy of receipt.', '30b34c5e9526fc449ffc35388bc7533.jpg', 8, 'Kallang MRT station', NULL, 'karie');
INSERT INTO item VALUES(DEFAULT, 'IBM 500gb HDD 2.5 Inch','2018-11-04 19:49:07',40,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Electronics', 'Desktops', 'bb10e2b69b5d6b8b4d0640c4d5eeaba5.jpg', 10, 'Jurong Hill MRT station', NULL, 'monika');
INSERT INTO item VALUES(DEFAULT, 'NETAPP 2TB SATA Disk','2018-11-03 19:49:07',70,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Electronics', 'SP-306A-R6', '16479bed98a4d43b07fe8d4d81e9c91.jpg', 8, 'Stevens MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'NETAPP 600GB SAS DISK','2018-11-04 19:49:07',70,'2018-11-09 19:49:07','2018-11-12 23:59:59', 'Electronics', 'SP-412A-R6', '73ca4932f2a05d2390dd445521ea74b3.jpg', 4, 'Tampines West MRT station', NULL, 'jarvis');
INSERT INTO item VALUES(DEFAULT, 'Gigabyte AORUS GTX 1080 Ti 11G GeForce®..,','2018-11-01 19:49:07',1265,'2018-11-05 19:49:07','2018-11-08 23:59:59', 'Electronics', 'https://www.youtube.com/watch?v=ffPD6ghOspQ   Alliance https://www.youtube.com/watch?v=R92sIh6EHCQ https://www.youtube.com/watch?v=1YzdbAZ9Tk0  Gigabyte AORUS GTX 1080 Ti 11G GeForce®.., Official Local Distributor warranty.  Price $1265 neg... or Walk in', 'bc1a35649741970a84655c913a00831f.jpg', 9, 'Lorong Chuan MRT station', NULL, 'julissa');
INSERT INTO item VALUES(DEFAULT, 'JBL Charge 3 by HARMAN (Black)','2018-11-05 19:49:07',190,'2018-11-07 19:49:07','2018-11-10 23:59:59', 'Electronics', 'Brand new JBL Charge 3 by HARMAN Portable Bluetooth Speaker  Original, NOT a replica ( can demonstrate by connecting to JBL connect app before buying ) 20 hours of playtime  6000mAh power bank Speakerphone  IPX7 Waterproof  Box has opened just for checkin', 'd50ddff5d0b2ae8d823af47c8755cd59.jpg', 9, 'Stevens MRT station', NULL, 'andy');
INSERT INTO item VALUES(DEFAULT, 'WEST AREA 🔶️ We Buy Sell Repair your good or spoil laptop','2018-11-01 19:49:07',88888888,'2018-11-02 19:49:07','2018-11-07 23:59:59', 'Electronics', 'We buy in any condition good or spoil laptop we also do repair and refurbishing of laptop and pc with NO DIAGNOSTIC CHARGES', '166be3b538ad86be1efbe9ac7ce9fd73.jpg', 6, 'Somerset MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, '(1262) iPhone cable - Pink','2018-11-04 19:49:07',10,'2018-11-05 19:49:07','2018-11-09 23:59:59', 'Electronics', 'Others', 'd550543be43c252a18e921f62077d25d.jpg', 3, 'Marina Bay MRT station', NULL, 'derek');
INSERT INTO item VALUES(DEFAULT, 'Dell 2340L 24 inch monitor','2018-11-08 19:49:07',95,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Electronics', 'Good working condition', 'd68dafc0efc3799e69899510812c0e0c.jpg', 4, 'Little India MRT station', NULL, 'francesco');
INSERT INTO item VALUES(DEFAULT, 'Laptop Stand with cooling fan','2018-11-08 19:49:07',10,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Electronics', 'Lightly used, considered new all functions good  Cooling fan by USB', '3f8e836506a8fc466322043fe16a742.jpg', 8, 'Orchard Boulevard MRT station', NULL, 'cathie');
INSERT INTO item VALUES(DEFAULT, 'Fitbit versa','2018-11-03 19:49:07',220,'2018-11-07 19:49:07','2018-11-08 23:59:59', 'Electronics', 'Used for a month', '7d5dc73ed47091484c6b91f7953fb248.jpg', 6, 'Jurong Hill MRT station', NULL, 'jarvis');
INSERT INTO item VALUES(DEFAULT, 'Roli Blocks','2018-11-08 19:49:07',180,'2018-11-10 19:49:07','2018-11-11 23:59:59', 'Electronics', '6 months Old Rolis. Still in very good condition.', '7a7cff7821984b2ef77a7c5df9f703e6.jpg', 8, 'Springleaf MRT station', NULL, 'kira');
INSERT INTO item VALUES(DEFAULT, 'Drone - Last one offer $83 only.  Fast hand you get','2018-11-07 19:49:07',85,'2018-11-11 19:49:07','2018-11-12 23:59:59', 'Electronics', 'Others', '4fd3e3a3ef4a4637e2eb66f933a1085b.jpg', 10, 'Redhill MRT station', NULL, 'andy');
INSERT INTO item VALUES(DEFAULT, '💻 MiniFit XL Aluminum Notebook Cooler/Stand (Up to 15-inch Laptop) Also can be used as book stand','2018-11-05 19:49:07',10,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Electronics', '✨ Used for only a few times  ✨ Very Good Condition  Fully Working  Features: - Changeable fan location. Cool effectively and smartly - By using optional stand support, you can use the cooler as notebook stand. Simple assembly of stand support transfor', 'd31ed98c56910d51411e50f81239ab95.jpg', 7, 'Buona Vista MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Instock JANSIN New Samsung Galaxy 42mm and 46mm STRAP','2018-11-05 19:49:07',20,'2018-11-07 19:49:07','2018-11-08 23:59:59', 'Electronics', 'Luxury Milanese Magnetic Loop Stainless Steel Metal Bracelet Wristband Strap For Samsung Galaxy Watch   Model  42mm 46mm  Price $20 Mailing $1 . By JANSIN', '62d8c58120727668268a9992e684d329.jpg', 8, 'Redhill MRT station', NULL, 'nakesha');
INSERT INTO item VALUES(DEFAULT, 'Steelseries Arctis Pro Gaming Headset','2018-11-07 19:49:07',279,'2018-11-07 19:49:07','2018-11-09 23:59:59', 'Electronics', 'BNIB Sealed 1 Year Warranty by Eternal Asia Singapore  Peerless High Resolution PC Gaming Headset Industry-leading hi-res capable speaker drivers Lightweight aluminum alloy and steel construction DTS Headphone:X v2.0 surround sound ClearCast, the best mic', 'e91608243fde64a707d6c55d978ba148.jpg', 7, 'Upper Changi MRT station', NULL, 'dot');
INSERT INTO item VALUES(DEFAULT, 'Wts macbook pro 15 2018 space grey','2018-11-05 19:49:07',3200,'2018-11-09 19:49:07','2018-11-11 23:59:59', 'Electronics', 'Hi wanna sell macbook pro 15 2018 6 core i7 2.2 ghz Radeon pro 555 x  Impulse buy cause of work Used about 3 time checking email and some pphoto editing   Reson to sell cause prefer window Only can deal when i back from japan  No 92300482', 'e7187c216e0c47584f10400885eaf865.jpg', 7, 'Shenton Way MRT station', NULL, 'sharleen');
INSERT INTO item VALUES(DEFAULT, 'Slim DVB T2 Boosted Active Antenna Indoor ATSC  HD TV Mediacorp Digital Signal','2018-11-01 19:49:07',18,'2018-11-03 19:49:07','2018-11-05 23:59:59', 'Electronics', 'No Digital TV, get this: https://sg.carousell.com/p/95081608  Why Choose Us?  Weve over 1700+ positive reviews 🇸🇬We cover local warranty and exchange.   Frequency Range：174-230/470-860Mhz Gain：30dbi VSWR：≤2.0 Nominal Impedance-Ω：75 Polari', '363406d8cc6b586a136061ed2a58c3b4.jpg', 6, 'Choa Chu Kang MRT/LRT station', NULL, 'kira');
INSERT INTO item VALUES(DEFAULT, 'acer gd working conditions computer to let go...','2018-11-02 19:49:07',200,'2018-11-04 19:49:07','2018-11-06 23:59:59', 'Electronics', 'Cash on spot.  All in one computer. 3 years old. Good working condition.', '5de9a96db6d70a433c5f98f54b448f92.jpg', 3, 'Pioneer MRT station', NULL, 'mattie');
INSERT INTO item VALUES(DEFAULT, 'TV Box  tv box android','2018-11-02 19:49:07',50,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Electronics', 'Shop rent expires，Brand New TV Box, original price $ 169.9, Offer price $ 50        Model：X96 CPU	Rock chip-4 Core A53  GPU Mali-450MP  DDR3 eMMC 3D Games playing 1080p online video chat Android 7.1.2 H265 HEVC 10 Bit HDR Memory(RAM)	1GB  DDR3   Stora', 'd5dc3c50a5b4713e06449ced96d87eaf.jpg', 4, 'Beauty World MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, 'MacBook Pro (13-inch, 2018, Four Thunderbolt 3 Ports)','2018-11-03 19:49:07',1599,'2018-11-07 19:49:07','2018-11-12 23:59:59', 'Electronics', 'OVERVIEW  Introduced	July 2018 Discontinued	-- Model Identifier	MacBookPro15,2 Model Number	A1989 EMC	3214 Order Number	 MR9V2LL/A (2.3 GHz with 512 GB storage Silver) MR9R2LL/A (2.3           GHz with 512 GB storage Space Gray) Colors	Silver or Space Gra', '29d63bd40fa8033d9a3ddea0ca823f9c.jpg', 9, 'Hougang MRT station', NULL, 'nakesha');
INSERT INTO item VALUES(DEFAULT, 'Macbook Air 13 Inch 1.8Ghz i5, 4GB RAM 128GB SSD Laptop','2018-11-07 19:49:07',650,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Electronics', 'Used Good condition No problems except battery only lasts for 4-5 hours instead of 8-9 hours No issues when plugged in to power source Comes with charger, casing and silicone keyboard protector  Mid 2012 model Updated to latest Mac OS Sierra  1.8Ghz Intel', 'cb032eeff0cd5a52aefd90aede2ec445.jpg', 9, 'Little India MRT station', NULL, 'adalberto');
INSERT INTO item VALUES(DEFAULT, 'Mi Band 3','2018-11-06 19:49:07',36,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Electronics', 'BNIB. Genuine. Last few sets to go. Sync Mi Band 3 with your phone and use the Xiaomi app to update the band from Chinese to English version.   It shows your phone notifications on your wrist, tracks your steps and heart beat and gives you reminders when ', 'e41661e8a084d6998fa6e1cdf9e30074.jpg', 9, 'Choa Chu Kang West MRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'Shure SE215 SPE BLUE','2018-11-06 19:49:07',88,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Electronics', 'Shure SE215 Special Edition Blue BNIP BNIB NEW AND SEALED! Selling a brand new set because I received it as a gift, but already had one. Hence reason for the sale. $88! GOOD DEAL! Outside selling 170++ Can do mailing as well.  Under warranty still. From 1', 'cd7cb2b1ae6cd5b818f6d461793edb73.jpg', 6, 'Marymount MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'JBL T110BT Bluetooth earphone with free charging case','2018-11-05 19:49:07',55,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Electronics', '2 color, grey  white Both color available', '313687a3b49958207ba01ee100488f89.jpg', 7, 'Changi Airport MRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, 'UE Boom 100% authentic','2018-11-07 19:49:07',120,'2018-11-12 19:49:07','2018-11-15 23:59:59', 'Electronics', '1st gen. UE boom...seldom use 9.8/ condition', '7d2f62bc7a5edb7be5fe311689fa1b52.jpg', 4, 'Outram Park MRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'MSI Optix G24C 24” 144mhz 1ms Curved Monitor','2018-11-05 19:49:07',376,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Electronics', 'Specs check at  https://www.msi.com/Monitor/Optix-G24C', 'd0c493201bf401830c451e19c4fffbef.jpg', 5, 'Bayshore MRT station', NULL, 'cjianhui');
INSERT INTO item VALUES(DEFAULT, 'MARSHALL ACTON (Official, Local Product Support)','2018-11-08 19:49:07',489,'2018-11-12 19:49:07','2018-11-16 23:59:59', 'Electronics', 'We usually do Cash on Delivery, but if you prefer to purchase by Credit Card or Paypal, you may order at http://bit.ly/loudnwirelessnew  Product comes with 1 year official warranty.  Free local shipping within 3 working days.  Catch us on YouTube at www.y', 'ba406ee598e1c0329d5e24d4fc2a9771.jpg', 4, 'Toh Guan MRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, 'Apple airpods iPhone 8 7 xs x','2018-11-02 19:49:07',170,'2018-11-02 19:49:07','2018-11-03 23:59:59', 'Electronics', 'Perfect working condition  Kept in casing so condition good!  No nego', '7c88f174d4535ecab83a94b1eaea1f10.jpg', 4, 'Telok Ayer MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'MSI Optic G24C (24/144Hz) Gaming Monitor','2018-11-04 19:49:07',390,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Electronics', 'Features: - MSI Optic G24C Gaming Monitor - 144 Hz - 1920 x 1080 - Response Time 1 ms - 3 years warranty  Item is brand new, sealed, unused, unopened. Official invoice will be issued on purchase.  We do not offer refund for any form of compatibility issue', 'eb22d71dea12aed5b115c60dcc23b281.jpg', 8, 'Bugis MRT station', NULL, 'francesco');
INSERT INTO item VALUES(DEFAULT, 'LYH Electric Wine Aerator','2018-11-02 19:49:07',69,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Electronics', 'New Innovative product from LYH: Electric Wine Aerator. Instantly aerate your wine to bring the best flavor and aroma. Easy to use and clean. Ideal gift for wine lovers.  Find more details at https://www.lyh.com.sg/electric-wine-aerator  Use the code NEWL', '2c7f6544dae2c000a9bc7eda6ac9ac65.jpg', 9, 'Marina South MRT station', NULL, 'jiwen');
INSERT INTO item VALUES(DEFAULT, 'BN Gaming mouse 4-speed LED backlighting free postage','2018-11-08 19:49:07',7,'2018-11-13 19:49:07','2018-11-17 23:59:59', 'Electronics', 'Free postage!', '9af1a75ce41f7ffd4cb9d049c0e07e95.jpg', 5, 'City Hall MRT station', NULL, 'melissia');
INSERT INTO item VALUES(DEFAULT, 'Sony Audio Home Surround System','2018-11-06 19:49:07',100,'2018-11-08 19:49:07','2018-11-13 23:59:59', 'Electronics', 'Sony Home Surround Audio System, letting go at a very cheap deal.', '38e36bcceb9ca5bf0363fd28783fc3db.jpg', 3, 'Farrer Park MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Clearance Gss Sf -a12 In Ear Stereo Earpiece Iem Brand New','2018-11-04 19:49:07',6,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Electronics', '5.90 free postage!', '1bba60bb56df096c14732cf128bc0362.jpg', 5, 'Kent Ridge MRT station', NULL, 'freida');
INSERT INTO item VALUES(DEFAULT, 'Edirol by Roland M-10DX Audio Mixer','2018-11-03 19:49:07',280,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Electronics', 'Barely used 10-Channel 24-Bit / 96kHz Digital Audio Mixer. Comes with original box, charger and manual.', '6466a08597798ec1451f7ed4fd04022b.jpg', 7, 'Bayfront MRT station', NULL, 'holli');
INSERT INTO item VALUES(DEFAULT, 'PLINIUS SA-100 MKiii','2018-11-05 19:49:07',2600,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Electronics', 'Power Amplifier    Tag:  jbl, denon,  marantz, pioneer, onkyo,  mcintosh,  sony, sherwood,  teac,  technics, kenwood.', '8bf34558092bf24284cbef955cf8331a.jpg', 5, 'Holland Village MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Bedsheet','2018-11-04 19:49:07',0,'2018-11-07 19:49:07','2018-11-11 23:59:59', 'Furniture', 'Queen size  King size  Material: velvet  Order now. The item will be shipped to your address around 10-15 days.', '9ff8a637b6c425dc938c2f4c9c425417.jpg', 4, 'Tukang MRT station', NULL, 'douglas');
INSERT INTO item VALUES(DEFAULT, 'White Kitchen Trolley cabinet','2018-11-06 19:49:07',120,'2018-11-09 19:49:07','2018-11-12 23:59:59', 'Furniture', 'Beautiful and Unique Trolley Cabinet.  In good condition. With shelves and 2 drawers.  Self-collect from West Coast Park.  Can fit in back of a car.', 'c2e8915fa7eac9fdd03e866aca5cb532.jpg', 10, 'Kent Ridge MRT station', NULL, 'monika');
INSERT INTO item VALUES(DEFAULT, 'My President Hotel Mattress Factory Sales!!!','2018-11-01 19:49:07',399,'2018-11-05 19:49:07','2018-11-07 23:59:59', 'Furniture', 'My Honey 4 zone pocket Spring queen mattress at $399 with Free Delivery 😊😊😊  Buy Any 2 Hotel Mattress from $799 and Get 1 for Free  Clearance Sales for all Storage bedframe Showroom Display Set Up to 50% Discount 😊😊  All Mattress Display Se', 'bbb37dde7efdf21a9b2e568851113ca2.jpg', 10, 'Great World MRT station', NULL, 'colby');
INSERT INTO item VALUES(DEFAULT, 'IKEA carpet','2018-11-03 19:49:07',20,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Furniture', 'Ikea carpet available in red and green.   Good condition. Lightly used.  133x195 cm  IKEA selling $69 I’m selling $20 each.   Self pick up at Cck', '3e64e38c352ed9187b09c0de10ce2487.jpg', 8, 'Chinese Garden MRT station', NULL, 'shengran');
INSERT INTO item VALUES(DEFAULT, 'Decorative Rectangle Wall Shelf (3-in-1)','2018-11-05 19:49:07',45,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Furniture', 'One Set consists of 1 Big and 2 Small rectangles (Similar Colour).  📐 Specifications 📐 Big Rectangular Dimensions: L40xW10xH32cm  Small Rectangular Dimensions: L27.5xW10xH16cm  Materials: MDF board with PU Paint  Thickness: 1.8cm  Colour: Black or W', '273c3118831908c8e5e54fcca0816d7c.jpg', 5, 'Great World MRT station', NULL, 'kira');
INSERT INTO item VALUES(DEFAULT, 'Solid Frame Double Decker Bunk Bed frame for children','2018-11-01 19:49:07',250,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Furniture', 'Still in good condition double deck bunk bed frame for children/kids. Mattress not included. Self carried. Bought at retail price of $500. Selling cheap at $250 only. Kids outgrown. Self collect at Punggol Central.', '8633c860381d06406ef638522590c185.jpg', 9, 'Kovan MRT station', NULL, 'jarvis');
INSERT INTO item VALUES(DEFAULT, 'Super King Bed  Mattress','2018-11-07 19:49:07',1700,'2018-11-07 19:49:07','2018-11-08 23:59:59', 'Furniture', 'NZ wooden bed in mint condition with extremely comfortable mattress. Please note the side tables are not included. Bought in NZ for $2.5k. Flat packed. Viewing can be arranged. Buyer needs to arrange transport. Price negotiable.', '380249e49ac4f5027598e69aa2d5d464.jpg', 7, 'Labrador Park MRT station', NULL, 'stan');
INSERT INTO item VALUES(DEFAULT, '🚚 Rose Gold Stationary Set, Pen holder, Storage Divider','2018-11-02 19:49:07',10,'2018-11-05 19:49:07','2018-11-07 23:59:59', 'Furniture', 'Get the perfect storage solution to vamp up a boring study table with a touch of rose gold sparkle.   Designs available A - Pen holder 9 x 10.5 cm - $9.5 B - Small Divider H6 x W12 x L17 cm - $13 C - Medium Divider H6.5 x W16.5 x L24.7 cm - $18 Get 1 full', 'fac3f6400b30b51512f6e95fe61d6954.jpg', 4, 'Bendemeer MRT station', NULL, 'melissia');
INSERT INTO item VALUES(DEFAULT, 'BN FREE DELIVERY Foldable Mattress with Free Pillow','2018-11-01 19:49:07',65,'2018-11-02 19:49:07','2018-11-03 23:59:59', 'Furniture', 'Brand new, ready stock, free delivery foldable mattress. Removable cover. Free pillow.  Junior Single (70×178cm) - $65 Single (90×178cm) - $75 Color: Grey or Coffee Brown 4cm thickness  Perfect for guest room, kids play room, maid room, travelling. No C', 'b9b1939e76978a70d5d317a7fd973953.jpg', 6, 'Bedok North MRT station', NULL, 'rosalva');
INSERT INTO item VALUES(DEFAULT, 'Teak Wood Bar Stool 48 cm TeakCo Brand New Sale Oct8-14','2018-11-06 19:49:07',55,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Furniture', 'Meet Up Location Visit our Factory Outlet Sale or Order Online Teak-Warehouse-Sale.com TeakCo.com Classic-Furniture-Sale.com  Price for First Picture   Price range from $49- 499, 499 - 999  LIKE Us, Follow Us on Carousell for Additional Discout $10 with P', 'b36be9668947e2dc34787917b1381547.jpg', 3, 'Dhoby Ghaut MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'Rattan- Teak wood Coffee Table','2018-11-04 19:49:07',100,'2018-11-05 19:49:07','2018-11-10 23:59:59', 'Furniture', 'Pre-own Rattan- Teak wood coffee table Unique and beautiful design Not for fussy buyer', '60fb5ee3877694b0ee15c3e824107d8e.jpg', 6, 'Lentor MRT station', NULL, 'fresi');
INSERT INTO item VALUES(DEFAULT, 'PRICE REDUCD! Seagrass Laundry Baskets - 3 sizes available','2018-11-06 19:49:07',30,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Furniture', 'Available now - get organised in style!  Super practical (and good looking!) laundry baskets in 3 sizes. Store toys, pillows, throws or, its namesake - laundry - while not compromising style. While they’re super versatile and match any decor, they would', '7eb4d9c781156cd4851ed6be2e8090ab.jpg', 4, 'Marsiling MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'Victoria bed','2018-11-05 19:49:07',400,'2018-11-10 19:49:07','2018-11-13 23:59:59', 'Furniture', 'Customade brand new victoria bed non storage Queen $400 King $600  Whatapp me for more colour n design 96753336 sen', '8178493498d75525c8facc21e14243f8.jpg', 9, 'Dakota MRT station', NULL, 'julissa');
INSERT INTO item VALUES(DEFAULT, 'Queen Size Mattress x3','2018-11-01 19:49:07',0,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Furniture', '3 Queen Size Mattresses for Free, please do take all', '8964c100bdaddcc3358553ad648ab79b.jpg', 5, 'Tukang MRT station', NULL, 'georgine');
INSERT INTO item VALUES(DEFAULT, 'Shelf (IKEA Discontinued)','2018-11-03 19:49:07',100,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Furniture', 'In pristine condition. Fits the IKEA boxes perfectly.  Height 151cm. Length 108cm  Pick up at Punggol place.', 'e2d17aae2cc0068eebf6c852abef9746.jpg', 8, 'Bayshore MRT station', NULL, 'chana');
INSERT INTO item VALUES(DEFAULT, '🚚 10meter 100leds Battery Operated Fairy Lights','2018-11-07 19:49:07',10,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Furniture', 'Battery operated 10meter 100leds fairy lights Wholesale available.   Refer image 2 for different type of fairy lights    $9.90 10meter Battery operated String Fairy Lights, 100 LEDs (in Stock) Portable and Operated by 3pcs x AA Batteries (not included) Co', '65aea2cfaf00d62c664dea0610e774b4.jpg', 4, 'Beauty World MRT station', NULL, 'colby');
INSERT INTO item VALUES(DEFAULT, 'TV Cabinet white INSTOCK','2018-11-07 19:49:07',210,'2018-11-07 19:49:07','2018-11-10 23:59:59', 'Furniture', 'INSTOCK FREE DELIVERY FREE INSTALLATION  -measurement: see 2nd picture -color: white -solid wooden legs -spacious storage -beautiful modern minimalist tv cabinet -FREE delivery -simple assemble required', '14ead42c0875063b4ed3b96baef57fd0.jpg', 5, 'Pioneer MRT station', NULL, 'adalberto');
INSERT INTO item VALUES(DEFAULT, 'Red 2+3 Seat Sofa','2018-11-07 19:49:07',280,'2018-11-12 19:49:07','2018-11-14 23:59:59', 'Furniture', '2  3 Seat Sofa Colour: Red Condition: 9/10  2 Seater: 145cm x 81cm x 89cm height 3 Seater: 201cm x 81cm x 89 cm height  Can come check it out or view before purchase.', '72b0d6d219d52c3878bfcfa387c5e7fd.jpg', 8, 'Bugis MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'PO - Bench w Cushion 00G','2018-11-01 19:49:07',129,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Furniture', 'Brand new：  Material: PU, Iron in Golden, Iron in Black Dimension and Price: L45xW45xH42cm - $129 L90xW45xH42cm - $229  Customization option is available ( length, width, height, thickness and color ). Pre-order, Min 3 weeks waiting time  DIY Self-assem', '83468cefeba68e87d00f098e8d593abc.jpg', 5, 'Upper Thomson MRT station', NULL, 'margie');
INSERT INTO item VALUES(DEFAULT, 'Bedsheet','2018-11-07 19:49:07',0,'2018-11-09 19:49:07','2018-11-12 23:59:59', 'Furniture', 'Queen size  King size  Material: velvet  Order now. The item will be shipped to your address around 10-15 days.', 'cf1893f32adb9ea60f25ae25121d182e.jpg', 6, 'Sembawang MRT station', NULL, 'fresi');
INSERT INTO item VALUES(DEFAULT, 'Cheap IKEA Large Wardrobe. 3 Doors DOMBAS Wardrobe. 90% New!','2018-11-05 19:49:07',105,'2018-11-07 19:49:07','2018-11-10 23:59:59', 'Furniture', '1 Year Old IKEA Wardrobe. 90% New. Lightly Used.  Collection Only - Near Farrer Park  Can pay on Collection  Will Deconstruct for You.  See link below for full details on item: https://www.ikea.com/sg/en/catalog/products/90358429/', 'ea05f32de81b3bd6780f9a1be0866fdf.jpg', 6, 'Siglap MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'Window Solar Film #Tint','2018-11-01 19:49:07',25,'2018-11-01 19:49:07','2018-11-02 23:59:59', 'Furniture', 'Installation of one way mirror reflective solar film with 20% VLT and overall heat rejection of 76%.  Ideal for privacy against closely built blocks/corridor units and look through service yard.  Using 3M  OYAMA Brand Automotive/Office/HDB #Window tint fi', 'ee88324d402d97fdf16fea37d56e03f7.jpg', 3, 'Woodlands North MRT station', NULL, 'alvera');
INSERT INTO item VALUES(DEFAULT, '[READY STOCK]Bedside Table Lamp👌','2018-11-08 19:49:07',39,'2018-11-11 19:49:07','2018-11-16 23:59:59', 'Furniture', '[READY STOCK]Bedside Table Lamp👌  👉order is process after transfer of payment 👉inclusive of tracking/ door to door delivery for safe and worry free delivery. 👉 2 days delivery after payment excluding Sundays.☺ 👉👌👌👌  Question not ', 'd828e2acaf184433631d2f884fa7a0f6.jpg', 5, 'Little India MRT station', NULL, 'kristie');
INSERT INTO item VALUES(DEFAULT, '(To bless) Big Wardrobe','2018-11-01 19:49:07',1,'2018-11-02 19:49:07','2018-11-07 23:59:59', 'Furniture', 'To bless this big Wardrobe..need to fix the door..Self collect at 760665,Yishun ave 4 Can collect anydate before 20oct..', '18b786b1c72e8887d476f3e031c57de9.jpg', 5, 'Gek Poh MRT station', NULL, 'robbi');
INSERT INTO item VALUES(DEFAULT, 'Handtufted Carpet 100% New Zealand Wool','2018-11-08 19:49:07',8,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Furniture', 'One of a kind 100% New Zealand wool handtufted square carpet. 45 x 45cm. Camo design, can be used as door mat. Sample piece, only available in one piece. See other designs in my listing. Self pickup at Bedok South Avenue 1 or Bedok Central.', 'd72244cc6615d307407cb841b2de3c3c.jpg', 7, 'Bedok Reservoir MRT station', NULL, 'cathie');
INSERT INTO item VALUES(DEFAULT, 'Macy’s (New York) Solid Wood Dining Table and 4 Chairs','2018-11-07 19:49:07',200,'2018-11-08 19:49:07','2018-11-09 23:59:59', 'Furniture', '8/10 condition. Bought in New York for USD2,100 less than 3 years ago. Great for compact places as still very slick and the color is beautiful. We are sadly swapping this for a square dining table for new apartment', 'ab2d7d48b1c1198ee66d5580ba9bd7c3.jpg', 10, 'Beauty World MRT station', NULL, 'francesco');
INSERT INTO item VALUES(DEFAULT, 'Tempered Glass Top dinning Table with 6 chairs','2018-11-08 19:49:07',150,'2018-11-11 19:49:07','2018-11-15 23:59:59', 'Furniture', 'Moving out! Collection end of NOV18 / Early Dec18 Tempered Glass Top dinning Table with 6 chairs  Table in excellent good condition. 6 chairs metal area abit rusty.', 'e3c0efa44bbfd391ff602548f20f5fbe.jpg', 8, 'Bukit Panjang MRT/LRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'Wardrobe','2018-11-05 19:49:07',150,'2018-11-07 19:49:07','2018-11-08 23:59:59', 'Furniture', 'Wardrobe with compartment in walnut color (64” L x 95” H)', '74677ca2ad1c1a8ea46f09b45de13eb5.jpg', 9, 'Boon Lay MRT station', NULL, 'marquita');
INSERT INTO item VALUES(DEFAULT, 'Pineapple Table Lamp','2018-11-05 19:49:07',28,'2018-11-10 19:49:07','2018-11-14 23:59:59', 'Furniture', 'Good luck is coming your way this Chinese New Year! - featuring our pineapple table lamp, S$28 per set!  Size of Acrylic: 201 x 97mm  4mm Clear Acrylic Size of LED stand: 85 x 85 x 35mm  Multi-coloured LED Lights  Battery-operated (3 x AA batteries) / com', '86fc26ddf5a06ab9cce3955eee1a916e.jpg', 10, 'Dhoby Ghaut MRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, 'Carpet | Plush Faux Fur Rug | Pristine Whites','2018-11-03 19:49:07',37,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Furniture', 'Lusciously long, pristine white faux fur. Add a notch of posh  luxe immedaitely with this rug!  Great for animal lovers who do not want to use sheepskin rugs.  Round or Rectangular  Round Rugs Dia 40cm $37 Dia 50cm $43 Dia 60cm $52 Dia 70cm $72 Dia 80cm $', 'bb6aaddc1bac66a5a650a19fe0eabe2e.jpg', 6, 'Hougang MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Preorder chairs with writing board ,foldable chairs,','2018-11-03 19:49:07',39,'2018-11-04 19:49:07','2018-11-08 23:59:59', 'Furniture', '$39  Plastic chair with writing boards   Preorder :2-3 weeks time   COLOUR	: PLASTIC BOARD	Black,Light Gray,Dark Gray,Light Blue,Dark Blue,Orange,Red,Green MATERIAL	: A3 electroplate steel + PP origin safe Plastic SUIT FOR	Lecture halls,Training classroom', '1b1b9441d437e9b4deaec06c815195ee.jpg', 9, 'Gul Circle MRT station', NULL, 'nilda');
INSERT INTO item VALUES(DEFAULT, 'Wine bucket stand','2018-11-03 19:49:07',30,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Furniture', 'Wooden wine stand - perfect for parties or just your home decor.', '944d6d382186fa44352544523bf3db8e.jpg', 9, 'Bishan MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Promotion extended till 22 oct','2018-11-06 19:49:07',589,'2018-11-07 19:49:07','2018-11-12 23:59:59', 'Furniture', 'Promotion price ends 22nd oct (while stocks lasts)  $589 with (Free delivery and free installation)   (Normal Price $699 takes effect back on 22nd oct)  Tv console with feature wall whole set Laminate material. Pls Ensure you have a concrete wall.   2 col', 'cc692cb0570d7242e477fe46726f187a.jpg', 7, 'Botanic Gardens MRT station', NULL, 'jim');
INSERT INTO item VALUES(DEFAULT, '🚚 Gaming Chair / Office Chair ,-available for Quantity Order!!','2018-11-04 19:49:07',119,'2018-11-06 19:49:07','2018-11-07 23:59:59', 'Furniture', 'Professional Gaming Chair Series   Free Massage Function! Ergonomics Design Best Quality Stainless Steel Dual - Wheel Support Design Breathable Mesh SGS Certified Free Massage Function at Back Support Color Option: Black Frame with Black Mesh, White Frame', '9268a1e6979816a5de607b088c1c0b36.jpg', 8, 'King Albert Park MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'IKEA Wardrobe','2018-11-07 19:49:07',50,'2018-11-07 19:49:07','2018-11-10 23:59:59', 'Furniture', '2 units for sale (50 each). Only 4 months used in very good condition. Arrange your own pick up. (Original price 99 each)  Dimension 80x50x180cm', 'eedf19295423a10331593749d947e9c2.jpg', 7, 'Outram Park MRT station', NULL, 'georgine');
INSERT INTO item VALUES(DEFAULT, 'Circa Rope Swinging Chair','2018-11-01 19:49:07',200,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Furniture', 'Create your escape with the Circa Rope Swinging Chair. This white hand woven cotton rope chair features an iron frame for durability and hangs easily from one point of contact. With decorative tassels all in dreamy white, this hanging chair is ready to be', 'ff8b1d51cbdc5b9434c8b8e6a13b43a4.jpg', 9, 'Simei MRT station', NULL, 'liwen');
INSERT INTO item VALUES(DEFAULT, 'TMDT 02 Marble Coffee/Cafe/Tea/Side/Outdoor Table TMDT','2018-11-03 19:49:07',149,'2018-11-04 19:49:07','2018-11-06 23:59:59', 'Furniture', 'Brand new  Material: Marble, Iron in Golden, Iron in Black Color: Black, White  Dimensions and Price of the table:  40x40x40cm - $149 50x50x40cm - $179 60x60x45cm - $209 70x70x45cm - $249 80x80x50cm - $299 Customization option is available.  Minimum two p', '83aee8e553075b3a5eeff4b8ef4e6ea1.jpg', 5, 'Tuas Crescent MRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, 'Bedsheet','2018-11-02 19:49:07',0,'2018-11-03 19:49:07','2018-11-07 23:59:59', 'Furniture', 'Queen size  King size  Material: velvet  Order now. The item will be shipped to your address around 10-15 days.', '596b10bf4b0a6ed73fea0134d1513d34.jpg', 6, 'Xilin MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'Ikea King Bed Frame','2018-11-05 19:49:07',150,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Furniture', 'Used almost a year. Able to nego.   please find your own transport.  I will dismantle it for you 😄  RTP: 200$++  Reason of selling: Moving house!', '7f83fbb0a630de5e66702d59ac3f9494.jpg', 4, 'Keppel MRT station', NULL, 'natalya');
INSERT INTO item VALUES(DEFAULT, 'Floor protector - Kolon','2018-11-05 19:49:07',30,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Furniture', 'Ikea 120 x 100 cm', 'b06a427b944a1f2a676ad128961aea94.jpg', 7, 'Nanyang Crescent MRT station', NULL, 'jeremy');
INSERT INTO item VALUES(DEFAULT, 'Guitar Hardcase','2018-11-08 19:49:07',100,'2018-11-10 19:49:07','2018-11-11 23:59:59', 'Music', 'Hardcase for guitar or bass Good condition No keys Price nego  Not gator, warwick, fusion, mono, ritter', '7cf24a6bf6ecd4d10aa49f9969ec793c.jpg', 7, 'King Albert Park MRT station', NULL, 'jim');
INSERT INTO item VALUES(DEFAULT, 'Cort Earth Mini','2018-11-04 19:49:07',200,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Music', 'Pre-loved, Newly Setup (worth $150), well maintained Cort Earth Mini. Selling as I need the same size with pick up. Meet up at Bishan MRT.  New Strings (ELIXIR 11-52S NANOWEB)', '1e30f4ee78f63720a0b00f2f195bd107.jpg', 3, 'Woodlands North MRT station', NULL, 'adalberto');
INSERT INTO item VALUES(DEFAULT, '[Music Empire] Ed Sheeran - Divide CD Album','2018-11-01 19:49:07',18,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Music', 'EU Edition  Brand new and sealed  By post or self collect', 'b46f00229aa007eb4e6787acf9a6c319.jpg', 6, 'Bugis MRT station', NULL, 'kimberely');
INSERT INTO item VALUES(DEFAULT, 'Ed Sheeran - Divide [VINYL LP]','2018-11-02 19:49:07',45,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Music', 'Authentic, mint  sealed.  Divide (2LP 45rpm 180-Gram Vinyl) Ed Sheeran  One of the most anticipated global releases of 2017, ÷ sees the 25-year-old in his finest form yet. Drawing inspiration from a wide array of experiences and subjects, Sheeran takes y', '4011e325e05f7a7bfdb94f7a675fde1.jpg', 8, 'Novena MRT station', NULL, 'francesco');
INSERT INTO item VALUES(DEFAULT, 'Marvel A1 size poster','2018-11-04 19:49:07',10,'2018-11-08 19:49:07','2018-11-13 23:59:59', 'Music', 'CDs, DVDs  Other Media', 'a9ce3695d5f1782d87d61f5b628a3bcf.jpg', 7, 'Jurong West MRT station', NULL, 'shengran');
INSERT INTO item VALUES(DEFAULT, 'WTS: Laney Cub 12R Tube Amp','2018-11-03 19:49:07',250,'2018-11-06 19:49:07','2018-11-10 23:59:59', 'Music', 'Used 15watt tube combo amplifier (EL84 output stage) with 1x12” Laney speaker. Vintage British voicing amp perfect for small gigs and has a separate low wattage input for home practice. Good choice for those venturing into tube territory.   Used but not', '2521a9acbff56f751fd93584aa56ba3a.jpg', 8, 'Dhoby Ghaut MRT station', NULL, 'dao');
INSERT INTO item VALUES(DEFAULT, 'Guitar pick','2018-11-03 19:49:07',5,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Music', 'Music Accessories', '75528955a894f3d35153eee646b4c248.jpg', 5, 'Tawas MRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, 'Flight Case','2018-11-07 19:49:07',350,'2018-11-07 19:49:07','2018-11-09 23:59:59', 'Music', 'Brand New!  Selling off cheap. 04 units available - serious buyer get bulk discount. Come and view to know. Thanks!', '958a24161c6bc4e1c865947d84a3426e.jpg', 7, 'Marymount MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'ALctron  - Broadcasting  Recording Stand(MA614)','2018-11-08 19:49:07',100,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Music', 'MA614 is a Luxury broadcasting stand, all aluminumconstruction, silver and sleek paint, make it very strong and nice looking. Built in strong tension spring, can hold heavy professional microphones for rough studio work.The half elliptic aluminum tube giv', 'd0be25066e840540f22d1326ce9cce2b.jpg', 4, 'Hougang MRT station', NULL, 'masako');
INSERT INTO item VALUES(DEFAULT, 'Fender champ 12 amp','2018-11-05 19:49:07',400,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Music', 'Selling Fender Champ 12 amp Condition is as it is in the pic Working fine and sound good  Selling at 400 by this month  Tag: fender gibson ibanez jackson esp ltd marshall blackheart orange metal blues jazz champ amp rock', '20e247db8bbc25ba0f3de3cf2fce3b19.jpg', 4, 'Outram Park MRT station', NULL, 'dot');
INSERT INTO item VALUES(DEFAULT, 'Martin 000RSGT','2018-11-01 19:49:07',1150,'2018-11-04 19:49:07','2018-11-08 23:59:59', 'Music', 'Local dealer SRP: SGD1,875. ONLY Interested to trade with: Taylor 214ce-N (nylon)  In very good condition.  Sounds amazing. Comes with Martin hardcase. PM for more photos.  The 000RSGT is an affordable 14-fret 000 Road Series guitar with a polished gloss ', 'b9daddc5af562f099aa6153064e9bc61.jpg', 6, 'Orchard MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'Mini Pedal board','2018-11-04 19:49:07',600,'2018-11-06 19:49:07','2018-11-07 23:59:59', 'Music', 'Selling everything on this board as it is. Not selling individually. Not looking for trades with anything either strictly cash.  The idea behind this board was to have a go to samples gigging solution to cover both rhythm and lead tones.  The Mooer preamp', '6c82cf14710c05c69a86214fa44cded9.jpg', 9, 'Tuas Link MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'Epiphone EB-O 4-String Bass Guitar, Cherry','2018-11-05 19:49:07',280,'2018-11-05 19:49:07','2018-11-09 23:59:59', 'Music', 'Music Instruments', 'ad09c2a8aef764698ceda0ee5fd68b34.jpg', 8, 'Stevens MRT station', NULL, 'aiksheng');
INSERT INTO item VALUES(DEFAULT, 'Yamaha EG-303 Electric guitar','2018-11-05 19:49:07',150,'2018-11-05 19:49:07','2018-11-07 23:59:59', 'Music', 'Good condition Yamaha EG303 Electric guitar. Fully functional, and sounds good. Tone knob is a little loose. Classic stratocaster shape used by john mayer, shawn mendes and ed sheeran! 6 way pickup switch, good action. Plays like on day one! Great for a b', '4e012f6e9b92a45e1760aa7bbe25da72.jpg', 8, 'Nicoll Highway MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, 'SIA earphones','2018-11-04 19:49:07',5,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Music', 'Original from Singapore Airlines.  Never open the packet before.   Price inclusive of normal delivery.', '636c6fbe12fade49ca64f6df25127a27.jpg', 8, 'Stadium MRT station', NULL, 'karie');
INSERT INTO item VALUES(DEFAULT, '🚚 Yamaha Piano Fair! Yamaha P-45 Digital Piano (Without Stand)','2018-11-07 19:49:07',680,'2018-11-09 19:49:07','2018-11-13 23:59:59', 'Music', 'Yamaha Piano Fair @ Absolute Piano  Yamaha Digital Piano P-45 Portable Piano  Absolute Piano - Your Trusted Local Authorized Dealer for Yamaha, Casio, Korg, Roland (ISO 9001:2008)  Free Gifts ✔ Single Sustain Pedal ✔ Yamaha Headphones ✔ 1 Year Warra', 'a347e43e1bd012216e095ce4fd63034f.jpg', 5, 'Changi Airport MRT station', NULL, 'daniel');
INSERT INTO item VALUES(DEFAULT, 'Boss GT-10','2018-11-03 19:49:07',400,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Music', 'Selling an under utilised Boss GT-10.  Comes with Flight case and original Power Supply.  Also spare knobs ordered from Roland if I can find it.', '9ed48344bcd3bf360f6177c8023d302a.jpg', 7, 'HarbourFront MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, 'Martin Dreadnaught JR with Pickup','2018-11-02 19:49:07',800,'2018-11-07 19:49:07','2018-11-11 23:59:59', 'Music', 'Conditon: 10/10 Will replace with new strings. Deals in town or east', '2414f749ad98703480efba44b8209922.jpg', 4, 'Kallang MRT station', NULL, 'cathie');
INSERT INTO item VALUES(DEFAULT, 'Taylor Baby BT-1 with pickup','2018-11-08 19:49:07',329,'2018-11-10 19:49:07','2018-11-12 23:59:59', 'Music', 'Taylor Baby BT1 w/ pickup  Cosmetic: 8/10 Function: 10/10  - needs no intro for this awesome  - stock taylor pickups - some dings and scratches  - just replaced strings - comes w/ its standard bag - free strap  #taylor #taylor baby #bt1', '9a3771e262cfa3d1ab5baa6df41140ff.jpg', 9, 'Tuas Link MRT station', NULL, 'cjianhui');
INSERT INTO item VALUES(DEFAULT, 'GEBR. PERZINA 122 UPRIGHT PIANO','2018-11-05 19:49:07',2800,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Music', 'Music Instruments', 'fc13d6c90f34fe83a1bea5045542346c.jpg', 3, 'Kranji MRT station', NULL, 'tynisha');
INSERT INTO item VALUES(DEFAULT, 'Swing S2 + Sound Drive SG-15','2018-11-01 19:49:07',200,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Music', 'E-Guitar - Swing S2 Cherry Sunburst Amplifier - Sound Drive SG-15  Condition: Guitar - Good (Seldom use) Amp - Open Box (Never use)  Guitar c/w carry bag and tuner Amp in original box', '4aec281f544cdecb6f22aa5fd3ebe6bc.jpg', 9, 'Marina South MRT station', NULL, 'alina');
INSERT INTO item VALUES(DEFAULT, 'Drum pedal hard case','2018-11-08 19:49:07',35,'2018-11-10 19:49:07','2018-11-15 23:59:59', 'Music', 'Handy hard case for drum pedal.   Can be used to carry other stuffs like pedals etc...   Good condition.', '36a9394578f448b48016e0e1f8083d61.jpg', 6, 'Khatib MRT station', NULL, 'junkai');
INSERT INTO item VALUES(DEFAULT, 'Sakae single drum pedal','2018-11-07 19:49:07',90,'2018-11-09 19:49:07','2018-11-13 23:59:59', 'Music', 'Brand new condition. Never used before. Self collect at Khatib MRT station.', '573eaab97692767e8198209aa8da38cf.jpg', 10, 'Tengah Plantation MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, '郭美美Jocie no more panic!! (Autograph)','2018-11-07 19:49:07',5,'2018-11-11 19:49:07','2018-11-14 23:59:59', 'Music', 'CDs, DVDs  Other Media', '727ed34e0d678513fc1a11f1b90d65d7.jpg', 9, 'Marina South MRT station', NULL, 'margie');
INSERT INTO item VALUES(DEFAULT, '棒棒糖 Lollipop (autograph)','2018-11-04 19:49:07',8,'2018-11-05 19:49:07','2018-11-09 23:59:59', 'Music', 'CDs, DVDs  Other Media', '75c9f0c9d82d75814eef8d9b82891eaa.jpg', 5, 'Woodlands MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'INSTOCK  unofficial BT21 face plushies','2018-11-04 19:49:07',7,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Music', 'Unofficial but looks exactly like the official one. It is just a little smaller.  Still cute like our boys  More than 2, $5 each RJ (10/10 condition)  Chimmy (10/10 condition)  VAN(10/10 condition)  Mang(10/10 condition)  Tata(8/10 condition)  Koya(10/10 ', '163859dd7157293520ab71207d9b8703.jpg', 7, 'Bartley MRT station', NULL, 'jeremy');
INSERT INTO item VALUES(DEFAULT, 'Cristofori Piano','2018-11-03 19:49:07',90,'2018-11-04 19:49:07','2018-11-08 23:59:59', 'Music', 'Selling off The Little Mozart by Cristofori. Item in a good condition. All keys working except one you have to push a little hard to get the sound. Can be sold without the piano bench but you can easily replace the bench cover with a customised cover. See', '8fbf39e12fa52e05757dc2f57636cf15.jpg', 5, 'Woodlands North MRT station', NULL, 'adalberto');
INSERT INTO item VALUES(DEFAULT, 'Male to Female headset','2018-11-05 19:49:07',5,'2018-11-10 19:49:07','2018-11-11 23:59:59', 'Music', 'Music Accessories', 'e021a35d7407eb449b8d8e28d083295a.jpg', 5, 'Khatib MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Electron Oktatrack MkII','2018-11-01 19:49:07',1900,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Music', 'Elektron Octatrack MkII for sale. Perfect condition and in full working order. Includes protective lid which is usually sold separately. This unit is less than 6 months old and still under warranty from Elektron. I purchased it thinking I would use it mor', 'ccc9fbd2ac93fe7ecb6d979beffe013d.jpg', 5, 'HarbourFront MRT station', NULL, 'stan');
INSERT INTO item VALUES(DEFAULT, 'Flight case for sell','2018-11-05 19:49:07',0,'2018-11-10 19:49:07','2018-11-15 23:59:59', 'Music', 'Music Accessories', 'a81334d9bc80f283d0e0904cfd6860f0.jpg', 10, 'Enterprise MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, '🚚 Music Streaming Service','2018-11-04 19:49:07',25,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Music', 'PM me for more info   Warrenty for 1 year  (lifetime is bullshit as they will be closed down)   #spotify #premium music #streaming music  #stream music', '8538e52d7887da52c360101a0ccc52fa.jpg', 6, 'Marina South MRT station', NULL, 'sharleen');
INSERT INTO item VALUES(DEFAULT, 'Kawai','2018-11-05 19:49:07',150,'2018-11-10 19:49:07','2018-11-15 23:59:59', 'Music', 'Getting new piano. This is more than 15 yrs. self collect by thursday. Yishun ave 4. Including bench. Needs tuning. No potential buyer by tmr, will throw away. Really need space.', '8fef3807cf8881e829f920a0718599a5.jpg', 9, 'Bukit Panjang MRT/LRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, 'Mint Green Earphones','2018-11-03 19:49:07',5,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Music', 'Original from EVA Air. Sealed.   Price inclusive of normal delivery.', 'd69ee8d35486a1c9663b1fdf9734212a.jpg', 3, 'Dakota MRT station', NULL, 'freida');
INSERT INTO item VALUES(DEFAULT, 'Foldable Guitar Stand','2018-11-02 19:49:07',20,'2018-11-02 19:49:07','2018-11-03 23:59:59', 'Music', 'Used for a short while to display the guitars and kept it in store room.', 'f8a6e41cbed08afdd0287d00a44b6bbc.jpg', 7, 'Punggol MRT/LRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'Yamaha C70','2018-11-01 19:49:07',80,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Music', 'Classical guitar, got a scratch on the back of the neck but it does not affect playing. It goes with guitar bag.', '64cc960663f92dfef4c1802f99a8bcd2.jpg', 3, 'Bartley MRT station', NULL, 'chad');
INSERT INTO item VALUES(DEFAULT, '28th SEA GAMES Singapore jersey','2018-11-04 19:49:07',8,'2018-11-05 19:49:07','2018-11-08 23:59:59', 'Sports', 'Condition 9/10 Used twice  Size L', 'edf542c5f6a5a5cd503eb9bbfdbfde5a.jpg', 9, 'Serangoon MRT station', NULL, 'kimberely');
INSERT INTO item VALUES(DEFAULT, 'Abs roller','2018-11-06 19:49:07',12,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Sports', '31cm x 11.5cm x 26cm  Material: PVC Colour: black with red   ✔️Train your abs!  ✔️comfortable spongy handles  ✔️Grooves for anti-slip  ✔️Withstand up to 200kg ✔️unisex', '88c00eed816b7b126097de5da1b8ffb5.jpg', 7, 'Esplanade MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Dark Matter G Tungsten Soft Tips Darts','2018-11-01 19:49:07',38,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Sports', 'DARK MATTER SERIES TUNGSTEN SOFT TIPS DARTS  Professional Darts Barrels 90% Tungsten  - Dimplex Super Grip, Matte Black Coated Surface To Further Enhance Users Grip and prevent oxidation.  - 2BA Threading. - 19g Precision Darts - Balanced Darts   Barrels ', '78dadb0aabbf5a82d0919fbbbdd4ed6f.jpg', 7, 'Outram Park MRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, '🚚 Muscle Pharm Protein Bar','2018-11-01 19:49:07',29,'2018-11-02 19:49:07','2018-11-07 23:59:59', 'Sports', 'Overbought so I decided to let some boxes go 👉🏻Flavor:  - white chocolate raspberry*,  - chocolate coconut*,  👉🏻 12 bars/box 👉🏻 20g protein/ bar (*: very nice flavor) #protein bar, muscle, gym, fitness, healthy snack, gluten free,', 'e8d8aff97f92bc439cb60be3a2616f7d.jpg', 7, 'Toh Guan MRT station', NULL, 'bernarda');
INSERT INTO item VALUES(DEFAULT, 'Adidas bomber Jacket','2018-11-06 19:49:07',40,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Sports', 'black with pink stripes  authentic from adidas !!  Ptp : 50cm Length down : 58cm Sleeves : 48cm  Looking for trades as well with other adidas jackets just ctb !!', 'ecddeba1fae4db0a249cc6c0a7dd46d.jpg', 6, 'Punggol Coast MRT station', NULL, 'junkai');
INSERT INTO item VALUES(DEFAULT, 'DECATHLON Weight  / Dumbbell 8KG','2018-11-08 19:49:07',25,'2018-11-10 19:49:07','2018-11-13 23:59:59', 'Sports', '1 Weight Training Bar 35cm 28mm 2KG  2 Cast Iron Weight Training Discs 1KG  2 Cast Iron Weight Training Discs 2KG  Original price in DECATHLON S$38 ($14+$8+$8+$4+$4)', 'b0868ae82017a4898c12c856e0751d79.jpg', 10, 'Tengah MRT station', NULL, 'jiaying');
INSERT INTO item VALUES(DEFAULT, 'Nittaku penhold blade','2018-11-04 19:49:07',120,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Sports', 'Nittaku Ludeack power with DHS Hurricane 3 and Neptune Milky Way long pip rubber', '480125eca95aafff9d4a2e600c90520.jpg', 6, 'Marina Bay MRT station', NULL, 'stan');
INSERT INTO item VALUES(DEFAULT, 'Nike Hypervenom Phantom Football Boots','2018-11-05 19:49:07',150,'2018-11-05 19:49:07','2018-11-09 23:59:59', 'Sports', 'Brand new Nike Hypervenom Phantom Football Boots  Size UK8.5/US9.5 Include stringbag and box', 'b9f7f9c7338033703b52c2dd43f1b9b0.jpg', 9, 'Stevens MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'Authentic Manchester United Jersey','2018-11-05 19:49:07',30,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Sports', 'Authentic size L. Mint condition except slight pulled thread as circled at the front bottom,  the strap peeling off slight at the back of the neck area.', '9e33341305037fd02ddad02bafdda5db.jpg', 3, 'MacPherson MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'Adidas Bags','2018-11-08 19:49:07',23,'2018-11-12 19:49:07','2018-11-17 23:59:59', 'Sports', 'For Feedbacks and Pics Catalogue do add our Facebook -  Soccerking Jerseys  For PreOrder, Adidas Bags  *A Simple Bagpack suitable for Light,Sport and Casual Activities.  Price - $23 only  Do check out my other Listings   Interested do Chat me up or WhatsA', '64a4d2f438d6dc26b41dc7b41b6d3c2c.jpg', 9, 'Bukit Batok West MRT station', NULL, 'fresi');
INSERT INTO item VALUES(DEFAULT, 'Nitrotech Whey Protein (muscletech)','2018-11-02 19:49:07',35,'2018-11-05 19:49:07','2018-11-08 23:59:59', 'Sports', 'Not planning to drink already. This is my extra tub.  Its the smaller tub so it’ll be a good try!  Milk chocolate flavour Exp date: 2021', '85223a3ad61ac7a50cf5d0377db48be3.jpg', 6, 'Newton MRT station', NULL, 'monika');
INSERT INTO item VALUES(DEFAULT, 'Perrygear Ladies Golf Gloves Size 17','2018-11-01 19:49:07',10,'2018-11-03 19:49:07','2018-11-07 23:59:59', 'Sports', 'Hardly used.', '84f8401d9a34da27e67eec500b9b4966.jpg', 5, 'Upper Thomson MRT station', NULL, 'georgine');
INSERT INTO item VALUES(DEFAULT, 'Speedo Goggles for Female','2018-11-01 19:49:07',39,'2018-11-03 19:49:07','2018-11-07 23:59:59', 'Sports', '- BN  Authentic Speedo Goggles for female - Intelligent Fit  comes with mesh pouch for easy carry - Self collect at Yishun', '6601c2b33918fb1dd27c90f08ac9e182.jpg', 8, 'Lakeside MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, '🌟FREE DELIVERY🌟 3pcs X  Skateboard','2018-11-01 19:49:07',99,'2018-11-01 19:49:07','2018-11-05 23:59:59', 'Sports', 'Clearance sales  🚚 FREE DELIVERY ( lift level )', 'b11fb071d916c4c02ce15c47150d5b37.jpg', 8, 'Upper Changi MRT station', NULL, 'aiksheng');
INSERT INTO item VALUES(DEFAULT, '🎉reduced🎉 Adidas 💯% Authentic alternate Brooklyn Nets jersey for SGD$20 (size youth L)','2018-11-08 19:49:07',20,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Sports', 'Adidas 💯% Authentic alternate Brooklyn Nets jersey for SGD$20 (size youth L). Purchased online from the official NBA store. Worn lightly only. Condition 9/10.  NO NEGO.  NO TRADES. Lowballers will not be entertained!', '926a7969054dd5b4d7750b84bf37921.jpg', 7, 'Khatib MRT station', NULL, 'douglas');
INSERT INTO item VALUES(DEFAULT, 'Deuter Futura 32','2018-11-07 19:49:07',105,'2018-11-10 19:49:07','2018-11-12 23:59:59', 'Sports', 'Deuter Futura 32 Backpack Colour: black-granite (black-grey) In stock now! 🤣 😂 😁 😀 😛 🤹‍♂️ 🤹‍♀️ 😍   SPECIFICATIONS: Weight:	1580 g Volume:	32 litres Size:	68 / 32 / 21 (H x W x D) cm  FEATURES: - AIRCOMFORT Flexlite Vent', '4f6952247739a76e4d4583e35f2185ac.jpg', 9, 'Tampines West MRT station', NULL, 'kira');
INSERT INTO item VALUES(DEFAULT, '🚚 5KG / 11LB Dumbbell','2018-11-08 19:49:07',8,'2018-11-08 19:49:07','2018-11-10 23:59:59', 'Sports', '5KG / 11 LB Matte Green Vinyl Fixed Dumbbell  - Used item.  - Slightly rough surface due to friction - Great for beginners.  - Condition: 6/10', 'e39a593c8d6a5b08a8647b9689834f8c.jpg', 7, 'Braddell MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'Dumbbell','2018-11-05 19:49:07',20,'2018-11-09 19:49:07','2018-11-10 23:59:59', 'Sports', 'Sell these two cheaply', 'b51efd9133eaccbb3441e2d409b60624.jpg', 5, 'Tampines West MRT station', NULL, 'chad');
INSERT INTO item VALUES(DEFAULT, 'Speedo goggles','2018-11-02 19:49:07',30,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Sports', 'Sports  Games Equipment', '82c0be707ef455680c03cc666fbf5eb8.jpg', 10, 'Clarke Quay MRT station', NULL, 'luis');
INSERT INTO item VALUES(DEFAULT, 'THE NORTH FACE FUSEBOX FUSE BOX | BACKPACK | HAVERSACK | REMOVABLE ORGANIZER  Color : RED STICKER','2018-11-08 19:49:07',125,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Sports', 'THE NORTH FACE FUSEBOX FUSE BOX | BACKPACK | HAVERSACK | REMOVABLE ORGANIZER  Color : RED STICKER   If youre fumbling around your dark apartment, feeling around for the fuse box, youre bound to be thrown for a loop when you stumble over this pack. Designe', 'f64848616419f97bac594feee8edb96d.jpg', 7, 'Bartley MRT station', NULL, 'margie');
INSERT INTO item VALUES(DEFAULT, 'Yonex Duora 10 Lcw version badminton racket','2018-11-02 19:49:07',110,'2018-11-04 19:49:07','2018-11-05 23:59:59', 'Sports', 'Yonex Duora 10 Lcw version badminton racket with new yonex bg66um string at 24lbs and new handgrip. No carrying case.  A few small chip off, pls see pictures.  Condition : 8.5/10.  Self collect at amk, bishan mrt or blk 230 ang mo kio ave 3.  Tag yonex li', 'fda09ffe19efd7690ad748d24f2bb0a9.jpg', 10, 'Bahar Junction MRT station', NULL, 'alejandrina');
INSERT INTO item VALUES(DEFAULT, 'McCoy Grenade II Tungsten Darts Barrels','2018-11-07 19:49:07',35,'2018-11-11 19:49:07','2018-11-13 23:59:59', 'Sports', 'McCoy Grenade ll Darts Barrels 90% Tungsten 18g Precision Darts Perfect Balanced Sawtooth Grip    Barrels Only : S$35 One Set : S$40 Set includes black slim box, soft tips, shafts and flight. (Example of a set at Pic 4)  Upgrade black slim box to Drop In ', '4306e5a093ba3534d0bde0ce88ff75c2.jpg', 5, 'Upper Thomson MRT station', NULL, 'dao');
INSERT INTO item VALUES(DEFAULT, 'New D40+ DHS 1 Star Table Tennis Training Ball (1 Box = 10 Balls)','2018-11-01 19:49:07',5,'2018-11-01 19:49:07','2018-11-06 23:59:59', 'Sports', 'Deal in the east - Tampines, Simei mrt stations or other places at my convenience.  Please use the Chat to Buy to communicate if you are interested.  Thank you   For sale D40+ DHS 1 star table tennis training ball  Material: New material Condition: New in', '1963a1ddcaeaeb59fe1f25cd3109b1d4.jpg', 10, 'Bendemeer MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'McCoy Grenade Tungsten 90% Darts','2018-11-07 19:49:07',35,'2018-11-08 19:49:07','2018-11-09 23:59:59', 'Sports', 'GRENADE BARRELS McCoy Professional Darts Barrels 90% Tungsten 16g Precision Barrels (18g Dart) Ringed Sawtooth Grip Balanced Darts  Barrels Only : S$35 One Set : S$40 Set includes black slim box , 3 full darts, 3 spare shafts and 3 spare tips.   Upgrade b', 'dbf99714830069a4770ac4ef6c104b8.jpg', 7, 'Tai Seng MRT station', NULL, 'karina');
INSERT INTO item VALUES(DEFAULT, 'Man U martial jersey','2018-11-03 19:49:07',15,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Sports', 'Manchester United Jersey  Worn only once Selling cheap', 'b5d187080f23ab8e41d9b20cac729bf5.jpg', 6, 'HarbourFront MRT station', NULL, 'derek');
INSERT INTO item VALUES(DEFAULT, 'Brand New Nalgene Oasis Gray Everyday w/Blue Loop Top 1000ml','2018-11-01 19:49:07',19,'2018-11-06 19:49:07','2018-11-07 23:59:59', 'Sports', 'Remember the old metal canteen? Well it’s been re-imagined for the new century. Sometimes you challenge yourself other times you’re challenged by the elements. In either case, you need the new Nalgene Oasis. Large enough to pack a serious hydrating pu', '9a78b36a6c01f86da194857bedb28137.jpg', 6, 'Gardens by the Bay MRT station', NULL, 'natalya');
INSERT INTO item VALUES(DEFAULT, 'Alo Yoga Sports Bra Size XS','2018-11-04 19:49:07',45,'2018-11-08 19:49:07','2018-11-12 23:59:59', 'Sports', 'Sports Apparel', 'c87711a30e43166c86021b4dee563e10.jpg', 8, 'Beauty World MRT station', NULL, 'nilda');
INSERT INTO item VALUES(DEFAULT, 'FUEL BELT☆ #HydrationBelt','2018-11-08 19:49:07',38,'2018-11-10 19:49:07','2018-11-15 23:59:59', 'Sports', 'Brand New FUEL BELT☆ #HeliumH2O #HydrationBelt (adjustable waist to fit 28-36 waist) *with two 4oz water-bottles, zipper-closure waterproof pouch/pocket for phone/coins/keys. Fastex Velcro closure', '2e0af13b47b364ac6ea03a6f052fd809.jpg', 4, 'Bright Hill MRT station', NULL, 'jiwen');
INSERT INTO item VALUES(DEFAULT, 'Manchester United Jersey','2018-11-04 19:49:07',10,'2018-11-09 19:49:07','2018-11-10 23:59:59', 'Sports', 'Sports Apparel', 'd89642dd9292fcdd2a05778d7761e485.jpg', 10, 'Xilin MRT station', NULL, 'aiksheng');
INSERT INTO item VALUES(DEFAULT, 'Preloved gym yoga mat 10mm thickness','2018-11-03 19:49:07',9,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Sports', 'Rarely used less than 4 times. Regular wiped.  Does not absorb sweat and lightweight!  Self collect at my unit at Yishun, not near to mrt.  *there is slight folding mark on the mat due to storing it in rolling state and I have misplaced the bag. It has be', 'c4c290b20d7eb2c5e5b6a767bd8bda32.jpg', 4, 'Upper Thomson MRT station', NULL, 'maricela');
INSERT INTO item VALUES(DEFAULT, 'Daiwa SL 20 brand new in box','2018-11-02 19:49:07',180,'2018-11-02 19:49:07','2018-11-05 23:59:59', 'Sports', 'Bought this reel new in box come with 15lb sufix  mono line. Will consider trade or swap with round abu garcia reel. Please take note price is fix non nego.', '96537c895c37068e4ad8b65186d2c672.jpg', 5, 'Simei MRT station', NULL, 'randall');
INSERT INTO item VALUES(DEFAULT, 'Manchester United track pants','2018-11-08 19:49:07',20,'2018-11-11 19:49:07','2018-11-15 23:59:59', 'Sports', 'Sports Apparel', '1acc5f9a04433564bed2410a130d1796.jpg', 6, 'HarbourFront MRT station', NULL, 'boyd');
INSERT INTO item VALUES(DEFAULT, '18 Daiwa Freams LT Series Light Tough','2018-11-03 19:49:07',200,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Sports', '18 DAIWA FREAMS LT SERIES  Light  Tough  🔖$180 ~ LT 2500 D 🔖$200 ~ LT 5000 D-CXH 🔖$200~ LT 6000 D-H  PM ME NOW FOR THESE BEAUTIFUL REELS.  Blk 399 Yung Sheng Road #01-57 Singapore 610399  Operating hours : Monday - Saturday , 10am - 7pm.  Closed ', '4ade2344a910be0457ae1943248acdfb.jpg', 5, 'Bayshore MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Lululemon Train Times 7/8 Pant','2018-11-07 19:49:07',108,'2018-11-10 19:49:07','2018-11-13 23:59:59', 'Sports', 'Worn twice only. Size 4.', 'c87c5619f418ec79c86291526ca207ec.jpg', 8, 'Marsiling MRT station', NULL, 'jarvis');
INSERT INTO item VALUES(DEFAULT, '🚚 Men’s Armour sleeveless Compression Shirt','2018-11-05 19:49:07',30,'2018-11-07 19:49:07','2018-11-12 23:59:59', 'Sports', '🏋️‍♂️Gain maximum support with this nifty item from Under Armour🏋️‍♂️ 👉Thanks to it’s compression quality, it will ease muscle stiffness and quicken recovery. 👍An asset for those who live a sporty life. 👉For product info p', 'b4f040716c5d275b96c72a5c3445e552.jpg', 3, 'Jurong Pier MRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, '[SALES] McCoy Torpedo Darts Set','2018-11-01 19:49:07',33,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Sports', '[INSTOCKS]  MCCOY TORNADO DARTS Professional Darts Barrels 90% Tungsten 18g Precision Barrels (16g Barrel) Slight Front Load  Shark Grip  Barrels only SGD 33 Full Set (black slim case darts set with extra 3 tips  spare shafts) - SGD 37 Upgrade Black Slim ', '61d3c6a433413a686282188e7580604c.jpg', 6, 'Maxwell MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'Yonex voltric 1DG','2018-11-02 19:49:07',40,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Sports', 'I bought it but didnt use it. Rfs clearing out my badminton items cuz not playing anym. Location can be changed but not too far.', '990ef8582b070d3834fc7498c50641b.jpg', 8, 'Dhoby Ghaut MRT station', NULL, 'eldriclim');
INSERT INTO item VALUES(DEFAULT, '🚚 Nalgene 1l Canteen Oasis 1l water bottle','2018-11-02 19:49:07',10,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Sports', 'Brand new canteen from nalgene.   Comes in red as listed in pictures. Great for those looking for your army design bottle, but with more class.  EACH bottle holds 1 liter of water and is made in USA.   Delivery via courier available at +$3.50, normal Sing', 'd7f719efdbfdbbb1133fbdfa08f9e28b.jpg', 4, 'Marine Terrace MRT station', NULL, 'kimberely');
INSERT INTO item VALUES(DEFAULT, 'Nike Sports Bra White','2018-11-03 19:49:07',15,'2018-11-05 19:49:07','2018-11-06 23:59:59', 'Sports', 'Nike Pro Core Fierce Compression Medium Support Sports Bra  Size s.  New, but I cut off the tag and washed it (I wash all new cloths before I ware them)  Bought at $30+', '94cd2192c7b7b88f0f4fd39955a1da6.jpg', 9, 'Lorong Chuan MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, 'DIADORA #BorgElite Tennis Shoes','2018-11-01 19:49:07',68,'2018-11-05 19:49:07','2018-11-10 23:59:59', 'Sports', 'Brand new in box. US 8 (Mens). Diadora #HeritageLine relaunch of Bjorn Borgs original Grand Slam Championship tennis shoes', '4292618325df52ca51d47aa2e9f6459c.jpg', 6, 'Tuas Link MRT station', NULL, 'bernarda');
INSERT INTO item VALUES(DEFAULT, 'Hotronix Fusion Heatpress','2018-11-03 19:49:07',3150,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Tools', 'Imported from the USA. Have been used for abt 1 year plus. We seldom use this and its as good as new. (This is made to last for more than 10 years.)   Description 16″ x 20″, 140lbs Will provide a red trolley FOC to make it easier to move around. Troll', '35fdc331215ff2cb0370df0974848bb6.jpg', 10, 'Bishan MRT station', NULL, 'irvin');
INSERT INTO item VALUES(DEFAULT, '[DREMEL 3D Printer] Dremel DigiLab 3D45 ALL in one 3D printer','2018-11-03 19:49:07',2888,'2018-11-05 19:49:07','2018-11-10 23:59:59', 'Tools', 'Dremel Digilab 3D Printer 3D45 Package comes with  1x DREMEL® 3D Eco-ABS Filament Black  1x DREMEL® 3D Nylon Filament Black  1x USB Cable  1x USB Flashdrive  1x Unclog Tool  1x Object Removal Tool  1x Glue Stick for Printing on Heated Bed  TECHNICAL SPE', '31a40cf2dd1c4e86d64516ae149be33e.jpg', 8, 'Hillview MRT station', NULL, 'zoey');
INSERT INTO item VALUES(DEFAULT, 'Sherline CNC 8 Directional Mill / Desktop Milling Machine','2018-11-06 19:49:07',2099,'2018-11-11 19:49:07','2018-11-13 23:59:59', 'Tools', 'Purchase from :-   SG Tooling Pte Ltd   150 South Bridge Road #B1-28   Fook Hai Building Singapore 058727   Monday to Friday: 11.00am to 5.45pm  Saturday: 11.00am to 5.00pm   www.sgtooling.com  Nearest MRT station: Chinatown Exit F  Tags: #Dremel #Proxxon', '3224163283384421697fbf32e5fe90de.jpg', 8, 'Paya Lebar MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, 'TCW810N - Teng Tools 8 Series 10 Drawer Roller Cabinet','2018-11-05 19:49:07',2029,'2018-11-09 19:49:07','2018-11-14 23:59:59', 'Tools', 'Roller cabinet with two swivel castors with brakes.  Equipped with 10 lockable drawers fitted with ball bearing slides (height: 6 x 50 mm, 3 x 75 mm 1 x 150 mm).  Combination lock.  Each drawer has a protective mat in the bottom.  Heavy duty handle for tr', 'a16df56acf3899e8b15f8ec32aa6e1fa.jpg', 4, 'Pasir Panjang MRT station', NULL, 'chana');
INSERT INTO item VALUES(DEFAULT, 'Sherline 2-IN-1 LATHE MILL Combo','2018-11-07 19:49:07',1699,'2018-11-08 19:49:07','2018-11-11 23:59:59', 'Tools', '#1 ULTIMATE SETUP, MILL and LATHE Function in 1 machine#   SHERLINE Desktop System - MADE IN USA  SHERLINE 4530A Lathe Machine  + Vertical Column with adjustable handwheel  Recommended mill accessories ( not included ) :-  3551 Milling Vise  3013 Clamping', 'fd36aa2de1358e5ef709fcc182cc77df.jpg', 6, 'Bugis MRT station', NULL, 'jeremy');
INSERT INTO item VALUES(DEFAULT, 'Sherline Desktop Mill / Milling Machine','2018-11-08 19:49:07',1495,'2018-11-12 19:49:07','2018-11-15 23:59:59', 'Tools', 'Purchase from :-   SG Tooling Pte Ltd   150 South Bridge Road #B1-28   Fook Hai Building Singapore 058727   Monday to Friday: 11.00am to 5.45pm  Saturday: 11.00am to 5.00pm   www.sgtooling.com  Nearest MRT station: Chinatown Exit F  Tags: #Dremel #Proxxon', 'a600bfba028af628592da1339ea0939f.jpg', 8, 'Kranji MRT station', NULL, 'douglas');
INSERT INTO item VALUES(DEFAULT, 'LNIB - Brother Sewing Machine NV980K Hello Kitty','2018-11-01 19:49:07',1300,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Tools', 'RETAILING AT $1800 SELLING AT $1300  Price is fixed Non-Negotiable   Condition: 10/10 (Plastics still intact)  Includes: Embroidery software and hardware  Embroidery tools  Fabrics Zips  Reason for selling: Impulse buy, rarely use it', 'dc8386bd724748c674d6819373b5cc02.jpg', 7, 'Orchard Boulevard MRT station', NULL, 'cathie');
INSERT INTO item VALUES(DEFAULT, 'WS4E CEL Power8Workshop Pro','2018-11-02 19:49:07',1250,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Tools', 'The Workshops Multi-Award Winning Design is centred around an armoured, innovative case and unique and Patented POWERhandle system. The POWERhandle design incorporates Lithium Ion batteries, variable trigger and handle into one unit allowing the tools to ', 'e429b593250f6e3dae257bb0bd4a105c.jpg', 8, 'Potong Pasir MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'Lie Nielsen No.9 iron mitre plane.','2018-11-08 19:49:07',1199,'2018-11-13 19:49:07','2018-11-18 23:59:59', 'Tools', 'Discontinued from the Lie-Nielsen. No.9 iron mitre plane based on the scarce STANLEY No.9  Fully adjustable mouth. Ductile iron body, bronze lever cap. Cherry wood rear and side handles. Fitted with the 2 inch wide A2 tool steel blade iron.', 'a7d18ca1cfad33243f16edb0445c751.jpg', 5, 'Joo Koon MRT station', NULL, 'natalya');
INSERT INTO item VALUES(DEFAULT, 'GRAB BAG','2018-11-07 19:49:07',999,'2018-11-12 19:49:07','2018-11-17 23:59:59', 'Tools', 'sooooooo i kinda lost the interest of scrapbooking n im trying to clear my supplies at a v v v low price so do help me thankieww   I HAVE stamps, inks, blender, stamp cleaner, stickles, tapes, stickers, ribbons, craft punch, printed papers, brads, heating', 'd65d6a3d5a30d478744cd9c6ec0b3cb8.jpg', 6, 'Buangkok MRT station', NULL, 'francesco');
INSERT INTO item VALUES(DEFAULT, '3D printing service','2018-11-02 19:49:07',999,'2018-11-03 19:49:07','2018-11-08 23:59:59', 'Tools', 'We provides one-stop 3D printing service. We can help you in your project (architecture project, interior design, cosplay, screw, special tool needed for your machine, prototype etc)! Print out your designed 3D files, or tel us ur idea! Let your product n', '9a32c8e70a1c98ef7d67b3cf3fb215bb.jpg', 4, 'Xilin MRT station', NULL, 'roslyn');
INSERT INTO item VALUES(DEFAULT, '🚚 lathe for wood','2018-11-02 19:49:07',900,'2018-11-03 19:49:07','2018-11-04 23:59:59', 'Tools', 'Used wood lathe for sale. 4 jaw chuck with retrofitted tool rest. will include table the tool is on and 2 sets of lathe chisels as well as other tools needed to use the lathe.  1.5m lathe for wood turning of any size!   Max turning of 1000mm piece', '28640ea977fa4cb8b1e631e7d090e96.jpg', 4, 'Sembawang MRT station', NULL, 'jiwen');
INSERT INTO item VALUES(DEFAULT, 'Tips for a bergeon 7825 owner','2018-11-08 19:49:07',888,'2018-11-13 19:49:07','2018-11-16 23:59:59', 'Tools', 'Many have bought the bergeon 7825 from me. And owning one set myself, I felt the price is well worth it if u like myself, is a Strap fantastic and take pleasure in swapping and changing straps/bracelets for exploration and many new looks 😅  The pincer ', '3b7bc40098d335618ddeb8bbf11da2fa.jpg', 7, 'Canberra MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'Cordless POWERQuattro _PQ02','2018-11-08 19:49:07',739,'2018-11-11 19:49:07','2018-11-15 23:59:59', 'Tools', 'LAST UNITS TO GO.. FAST   Powerful cordless tool. 2 power tools with 4 functions.  10mm Light Drill Head (LD01), Circular Saw Head (CS01), 18V 2.6Ah POWERhandle (PH11), Built-in Charger, Post/Fence (PF01), Protractor (PT01), Push Lever (PF01), 2x Accessor', 'e01b0b4a404122e1483f53fcbfaac1d.jpg', 8, 'Woodlands South MRT station', NULL, 'zachary');
INSERT INTO item VALUES(DEFAULT, 'Lathe for wood','2018-11-04 19:49:07',700,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Tools', '1.5m lathe. Can turn wood of maximum 1000mm.  4 jaw chuck with retrofitted tool rest. Will include the stand the lathe is on, as well as 2 sets of lathe tools (as seen in picture 2).', '42c79f2a3cd2704192281e5a44ff55f0.jpg', 4, 'Dhoby Ghaut MRT station', NULL, 'rosalva');
INSERT INTO item VALUES(DEFAULT, 'Boxo 7 Drawer Tool Trolley','2018-11-07 19:49:07',688,'2018-11-10 19:49:07','2018-11-14 23:59:59', 'Tools', 'Boxo 7 Drawer Tool Trolley Dimension: H1000mm x L681mm x D459mm Material : Steel Thickness: 0.8mm Per Drawing Upload Capacity: 35kg  - Extra drawer handle for easy open. - Gas lifts on top chest for opening lid. - Ball bearing slide - 5 1-1/4 PP casters', '3631e604d8ebb4c5feedd04f8ac60528.jpg', 3, 'Downtown MRT station', NULL, 'ray');
INSERT INTO item VALUES(DEFAULT, 'Dremel 4000 Platinum Wolfcraft Master 700 Combo','2018-11-05 19:49:07',599,'2018-11-09 19:49:07','2018-11-13 23:59:59', 'Tools', 'Limited Units Only! Dremel 4000 Platinum + Wolfcraft Master 700 Now S$599.90 ONLY!!! Remember Limited time limited QTY. Hurry !!  Purchase from :-   SG Tooling Pte Ltd   150 South Bridge Road #B1-28   Fook Hai Building Singapore 058727   Monday to Friday:', 'd935a364501a00df9a7c295adf72cb31.jpg', 6, 'Queenstown MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'Bosch 18V Cordless Jigsaw (GST 18V-Li) 6.0AH','2018-11-04 19:49:07',599,'2018-11-08 19:49:07','2018-11-13 23:59:59', 'Tools', 'Visit our e-store at : https://www.viborg.com.sg/collections/battery-drill-combo-kits/products/bosch-18v-cordless-jigsaw-gst-18v-li-6-0ah  The most compact 18 volt professional cordless jigsaw   • Extremely compact cordless jigsaw with the shortest leng', '7cdcb0a19a0215b1e397e45b70de3d87.jpg', 6, 'Lorong Chuan MRT station', NULL, 'arturo');
INSERT INTO item VALUES(DEFAULT, 'Bad Axe Tool Works 12 Hybrid Dovetail/Small Tenon Saw','2018-11-03 19:49:07',599,'2018-11-03 19:49:07','2018-11-05 23:59:59', 'Tools', '14 ppi, Hybrid-cut filing, copper plated saw back, wisconsin black walnut handle, gun blue-steel slotted nuts', 'c48e3ffde511cd7c2f4744ef8ae89e42.jpg', 6, 'MacPherson MRT station', NULL, 'irvin');
INSERT INTO item VALUES(DEFAULT, 'Bosch 18V Cordless Circular Saw (GKS 18V-Li) 6.0AH','2018-11-01 19:49:07',556,'2018-11-06 19:49:07','2018-11-07 23:59:59', 'Tools', 'Visit our e-store at : https://www.viborg.com.sg/collections/battery-drill-combo-kits/products/bosch-18v-cordless-circular-saw-gks-18v-li  Best-in-class cutting performance  • Cut up to 50 chipboards (900 x 19 mm) to length with only one battery charge ', 'fea56059870e5dc401af9b00c06db895.jpg', 5, 'Lakeside MRT station', NULL, 'douglas');
INSERT INTO item VALUES(DEFAULT, 'Makita 18V Cordless Multi Tool (DTM51RFEX8)','2018-11-01 19:49:07',525,'2018-11-02 19:49:07','2018-11-04 23:59:59', 'Tools', 'Visit our e-store at : https://www.viborg.com.sg/products/makita-18v-cordless-multi-tool-dtm51rfex8  Tool-less accessory clamp for quick installation and replacement. 12 angle setting of accessories at every 30°from 0°to 360°. Variable speed control by', '834b751768e3300d5a7c3dd7dd16d911.jpg', 5, 'Tawas MRT station', NULL, 'karie');
INSERT INTO item VALUES(DEFAULT, 'Engraving Machine','2018-11-02 19:49:07',500,'2018-11-03 19:49:07','2018-11-06 23:59:59', 'Tools', 'All-purpose U.S. Engraving Machine Comes with Alphanumeric Templates Templates may not be complete Templates come in one size only Operating Voltage: 110V (Free adaptor) Weight: Heavy. Size: Bulky.  Old machine that has been used for making acryllic namet', '48a77f3892d64aba3d296d5ef0530582.jpg', 8, 'Woodlands MRT station', NULL, 'eldriclim');
INSERT INTO item VALUES(DEFAULT, 'Makita pw5001c marble granite wet polisher','2018-11-06 19:49:07',450,'2018-11-11 19:49:07','2018-11-12 23:59:59', 'Tools', 'Like new pw5001c for sale. Bought and used once to try and polish my family granite top table and marble vanity top. Theres some water marks on the tool, but otherwise its almost new. Will include one entire set of wet polishing discs 4. It costed me anot', '4f8e50034835c650921d27fc7f162197.jpg', 5, 'Tai Seng MRT station', NULL, 'julissa');
INSERT INTO item VALUES(DEFAULT, 'Cordless Multi Tool ( MT 18 LTX )','2018-11-01 19:49:07',440,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Tools', 'Cordless Multi Tool ( MT 18 LTX ) The Multi Tool is a all in one tool for your Cutting and Sanding needs. It uses Oscillating technology to cut multiple kind of materials ( e.g. Wood, Leather, textiles, Ceramics ). It can be use as a sanding machine when ', '402f94eed08288f9205ee44135a6aca2.jpg', 7, 'Bukit Panjang MRT/LRT station', NULL, 'mattie');
INSERT INTO item VALUES(DEFAULT, 'DREMEL 4000 PLATINUM WORKSTATION COMBO','2018-11-08 19:49:07',439,'2018-11-13 19:49:07','2018-11-15 23:59:59', 'Tools', '#DREMEL ULTIMATE PLATINUM PACKAGE#   ONLY our DREMEL tools listing are covered with 6 months local warranty because we ARE the authorized distributor for DREMEL Singapore.   All NEW DREMEL 4000 comes with  ✔ 6 attachment ✔ 128 accessories ✔ Now with', 'a181bdc3ca4bd1a1bcad95c809654fab.jpg', 7, 'Bedok MRT station', NULL, 'marlene');
INSERT INTO item VALUES(DEFAULT, 'BN Silhouette Cameo 3 - Electronic Cutting Tool','2018-11-04 19:49:07',425,'2018-11-06 19:49:07','2018-11-09 23:59:59', 'Tools', 'The Silhouette CAMEO® is the ultimate DIY machine. It uses a small blade to cut over 100 materials, including paper, cardstock, vinyl, and fabric up to 12 in. wide. The CAMEO has the ability to register and cut printed materials and is PixScan™ compati', 'dad2c40ad4a5c4e558e4ecdb8cc0f577.jpg', 3, 'Marina Bay MRT station', NULL, 'derek');
INSERT INTO item VALUES(DEFAULT, 'Weldy energy HT1600 plastic kit','2018-11-07 19:49:07',420,'2018-11-08 19:49:07','2018-11-13 23:59:59', 'Tools', 'Hot-air hand tool energy HT1600 - Variable temperature control up to 700 °C - Ceramic heating element - Robust brush motor - Ergonomic handle - Dust filter   Technical data Attribute	Unit	Value Voltage	V~	230 Power	W	1600 Temperature	°C	40 – 700 Air v', '47c97634e354937b4c00b8363c357aa.jpg', 7, 'Bayfront MRT station', NULL, 'margie');
INSERT INTO item VALUES(DEFAULT, 'Power Tools Set','2018-11-03 19:49:07',400,'2018-11-04 19:49:07','2018-11-07 23:59:59', 'Tools', 'All working 1 to 2 years old, no accessories only what is in the picture. Prefer not to split and sell as a set', '456bdacb99aee7760702c99e5ace7c8b.jpg', 3, 'Rochor MRT station', NULL, 'marquita');
INSERT INTO item VALUES(DEFAULT, 'Cordless Power Jigsaw Tools - CEL','2018-11-01 19:49:07',399,'2018-11-01 19:49:07','2018-11-02 23:59:59', 'Tools', 'Powerful cordless Jigsaw tools.   Jigsaw Head (JS02), Fast Charger (PHFC1), 2.6Ah Li-ion POWERhandle (PH11), packed in Blow Mould Case (BMC-A)', 'e5ed3744fe307893d62ad59f1706cd0b.jpg', 5, 'Eunos MRT station', NULL, 'karie');
INSERT INTO item VALUES(DEFAULT, 'MAKITA 12 V CORDLESS DRIVER DRILL COMBO SET','2018-11-08 19:49:07',382,'2018-11-11 19:49:07','2018-11-15 23:59:59', 'Tools', 'Makita 12V Cordless Driver Drill (DF331Z) -Increased motor power for higher application speed and max tightening torque -Best possible ergonomic handle for drilling/driving applications -Battery protection circuit is activated on high battery temperature ', '5fbd93445b2ed933bb8b997f727ec86f.jpg', 7, 'Outram Park MRT station', NULL, 'fresi');
INSERT INTO item VALUES(DEFAULT, 'PROXXON Woodturning lathe DB 250','2018-11-06 19:49:07',369,'2018-11-10 19:49:07','2018-11-12 23:59:59', 'Tools', 'Brand New Unit Special Offer  Purchase from :-   SG Tooling Pte Ltd   150 South Bridge Road #B1-28   Fook Hai Building Singapore 058727   Monday to Friday: 11.00am to 5.45pm   Saturday: 11.00am to 5.00pm   www.sgtooling.com  Nearest MRT station: Chinatown', '652a091cf6ac34bf8a3b64bc712cd447.jpg', 6, 'Sengkang MRT/LRT station', NULL, 'nilda');
INSERT INTO item VALUES(DEFAULT, 'Print Gocco PG-11 Unit with extensive supplies','2018-11-02 19:49:07',350,'2018-11-04 19:49:07','2018-11-09 23:59:59', 'Tools', 'This is the remainders of  my mobile zine-printing-station I deployed in Tokyo several years ago.  There are lots of meshes, light-bulbs, and inks.  There are also some accessory tools like filter-blues, ink-blockings, etc.    I am only selling this as th', 'c08ba764bc53aebc48ff7e81a5d5fa22.jpg', 9, 'Kallang MRT station', NULL, 'lisandra');
INSERT INTO item VALUES(DEFAULT, 'Used Cameo Silhouette Ver 3','2018-11-02 19:49:07',350,'2018-11-07 19:49:07','2018-11-10 23:59:59', 'Tools', 'Silhouette CAMEO® 3 The Silhouette CAMEO® is the ultimate DIY machine. It uses a small blade to cut over 100 materials, including paper, cardstock, vinyl, and fabric up to 12 in. wide. The CAMEO has the ability to register and cut printed materials and ', '1c2e693562a4a219a6915842d05e84f3.jpg', 9, 'Serangoon MRT station', NULL, 'amar');
INSERT INTO item VALUES(DEFAULT, 'Crafting of cement flower pots with tools. 2 days lessons for 2 person (1hr per lesson).','2018-11-01 19:49:07',300,'2018-11-01 19:49:07','2018-11-02 23:59:59', 'Tools', 'Lesson include 5kg worth of cement powder, 6 silicone moulds, cement sealer, cement wash and cement paint Including 2 days lesson at your place.', '2d369ed0f5eb312fe34f2fa982de2242.jpg', 9, 'Marina South Pier MRT station', NULL, 'randall');
INSERT INTO item VALUES(DEFAULT, 'MAKITA BRUSHLESS 10MM(3/8”) CORDLESS DRIVER DRILL - DF032DSAE','2018-11-05 19:49:07',297,'2018-11-09 19:49:07','2018-11-10 23:59:59', 'Tools', 'BRUSHLESS DRIVER DRILL. @MISTERKIO.COM  Best possible ergonomic handle for drilling/driving applications Battery protection circuit is activated on high battery temperature to protect the battery from damages due to over discharge, high temperature or ove', '26e4d753e3825d31def2c0f6a5baa39e.jpg', 6, 'Choa Chu Kang MRT/LRT station', NULL, 'alvera');
INSERT INTO item VALUES(DEFAULT, 'Bosch concrete drill driver cordless','2018-11-02 19:49:07',289,'2018-11-06 19:49:07','2018-11-11 23:59:59', 'Tools', 'Brand New Sealed Bosch latest model cordless 18V drill / driver that can drill concrete like HDB walls, metal, wood and drive screws. Model 18-2-Li with 1x Drill, 1x AL 1860CV fast charger, 2x 2.0Ah 18V Battery, tool case, warranty card for local 6 months', 'bb042137467384ac78ad4ca242298356.jpg', 4, 'Cantonment MRT station', NULL, 'freida');
INSERT INTO item VALUES(DEFAULT, 'WORX WX572 650W Blade Runner Table Saw','2018-11-06 19:49:07',289,'2018-11-06 19:49:07','2018-11-08 23:59:59', 'Tools', 'Ideal tool that cuts through wood, metal, tiles, plasterboard and plastics with ease  Always ready for scroll cuts, mitre cuts, rip cuts and more  Quick blade change and fitting  Variable speed control for different materials  Compatible with any T-Shank ', 'a7b937a0286f1999b606daba171b4e25.jpg', 10, 'Hougang MRT station', NULL, 'dao');
INSERT INTO item VALUES(DEFAULT, 'Makita 1/2 Impact Wrench (TW0200)','2018-11-01 19:49:07',289,'2018-11-02 19:49:07','2018-11-04 23:59:59', 'Tools', 'Visit our e-store at : https://www.viborg.com.sg/products/makita-1-2-impact-wrench-tw0200  Powerful 380 watt motor with an impressive 200Nm of torque to handle nuts or bolts up to M16 Tool less detachable belt clip for easy storage or temporary resting be', '6e17febc81155ed13f001fe7292b0017.jpg', 7, 'Tuas Crescent MRT station', NULL, 'tiera');
INSERT INTO item VALUES(DEFAULT, '🚚 Airbrush Twin cylinder Air compressor with tank','2018-11-06 19:49:07',280,'2018-11-11 19:49:07','2018-11-12 23:59:59', 'Tools', 'MODEL AS196 Twin cylinder Compressor for AirbrushingAir tank, providing smooth air flow, zero pulse.  - Twin cylinder, supply high air flow for many airbrushes. - Oil free, piston type No air polluted. - With water filter, pressure adjustor and pressure g', '68789737b9b2f035aa207fc1dcbff40a.jpg', 7, 'Corporation MRT station', NULL, 'natalya');
/*============================
Insert Bids
============================*/

INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 2, 'charlsie',3);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 3, 'luis',3);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 4, 'colby',3);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 81, 'kimberely',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 82, 'dao',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 83, 'shengran',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 84, 'fresi',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 85, 'sean',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 86, 'nakesha',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 87, 'melissia',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:15', 88, 'dao',6);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 36, 'chana',7);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 37, 'bernarda',7);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 38, 'jim',7);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 1189, 'kira',8);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 1190, 'alvera',8);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 1079, 'adalberto',9);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 26, 'sean',10);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 301, 'arturo',12);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 51, 'masako',13);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 11, 'charlsie',16);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 12, 'douglas',16);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 181, 'francesco',19);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 51, 'jeremy',20);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 52, 'shengran',20);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 53, 'julissa',20);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 351, 'chad',21);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 352, 'fresi',21);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 353, 'robbi',21);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 354, 'andy',21);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 89, 'jeremy',23);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 26, 'robbi',24);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 81, 'bernarda',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 82, 'eldriclim',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 83, 'britany',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 84, 'zachary',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 85, 'stan',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 86, 'douglas',26);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 1, 'julissa',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 2, 'karie',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 3, 'sixta',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 4, 'freida',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 5, 'marquita',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 6, 'chana',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 7, 'robbi',29);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 201, 'colby',31);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 202, 'andy',31);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 203, 'alina',31);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 3, 'kira',34);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 4, 'jarvis',34);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 1, 'mattie',35);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 2, 'irvin',35);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 3, 'ray',35);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 41, 'tynisha',36);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 42, 'randall',36);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 43, 'daniel',36);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 44, 'masako',36);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 1, 'dao',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 2, 'cathie',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 3, 'chad',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 4, 'nilda',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 5, 'dot',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 6, 'rosalva',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 7, 'chad',37);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 4, 'robbi',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:09', 5, 'cjianhui',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:10', 6, 'mattie',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:11', 7, 'daniel',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:12', 8, 'derek',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:13', 9, 'jiwen',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:14', 10, 'arturo',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:15', 11, 'chana',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:16', 12, 'randall',38);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 3, 'holli',40);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 1, 'melissia',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 2, 'zachary',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 3, 'douglas',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 4, 'andy',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:12', 5, 'alina',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:13', 6, 'jiwen',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:14', 7, 'sixta',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:15', 8, 'bernarda',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:16', 9, 'tiera',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:17', 10, 'marquita',41);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 3, 'nilda',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:09', 4, 'natalya',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:10', 5, 'cjianhui',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:11', 6, 'francesco',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:12', 7, 'douglas',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:13', 8, 'aiksheng',42);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 7, 'jim',43);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 8, 'chad',43);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 9, 'charlsie',43);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 9, 'kimberely',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 10, 'sean',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 11, 'natalya',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 12, 'liwen',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:12', 13, 'tiera',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:13', 14, 'adalberto',48);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 11, 'jiaying',52);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 5, 'chana',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 6, 'karie',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 7, 'nakesha',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 8, 'roslyn',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 9, 'charlsie',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 10, 'britany',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 11, 'jiaying',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:15', 12, 'stan',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:16', 13, 'derek',54);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 9, 'chad',57);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 10, 'britany',57);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 11, 'irvin',57);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 3, 'zoey',58);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 2, 'robbi',59);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 3, 'aiksheng',59);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 3, 'masako',61);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 301, 'jim',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 302, 'jeremy',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 303, 'stan',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 304, 'chana',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:12', 305, 'marlene',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:13', 306, 'dot',62);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 28, 'fresi',63);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 29, 'shengran',63);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 30, 'jeremy',63);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 41, 'julissa',64);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 42, 'sean',64);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 71, 'cathie',65);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 72, 'alejandrina',65);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 1266, 'karie',67);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 1267, 'holli',67);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 1268, 'irvin',67);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 1269, 'ray',67);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 191, 'zoey',68);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 192, 'bernarda',68);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 88888889, 'daniel',69);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 88888890, 'nakesha',69);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 88888891, 'britany',69);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 88888892, 'margie',69);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 11, 'luis',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 12, 'nakesha',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 13, 'karie',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 14, 'colby',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:12', 15, 'colby',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:13', 16, 'mattie',70);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 221, 'roslyn',73);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 222, 'ray',73);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 223, 'randall',73);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 224, 'stan',73);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:12', 225, 'stan',73);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 11, 'derek',76);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 280, 'alina',78);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 281, 'charlsie',78);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 282, 'aiksheng',78);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 283, 'masako',78);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 19, 'kimberely',80);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 201, 'alejandrina',81);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 202, 'marlene',81);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 203, 'nilda',81);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 204, 'dao',81);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:12', 205, 'chana',81);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 1600, 'adalberto',83);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 1601, 'alvera',83);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 1602, 'bernarda',83);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 37, 'nilda',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 38, 'fresi',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 39, 'sixta',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 40, 'aiksheng',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 41, 'eldriclim',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 42, 'roslyn',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 43, 'karina',85);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 89, 'sean',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 90, 'britany',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 91, 'tynisha',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 92, 'cjianhui',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 93, 'rosalva',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 94, 'liwen',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 95, 'dot',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:15', 96, 'karina',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:16', 97, 'lisandra',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:17', 98, 'jeremy',86);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 377, 'chad',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 378, 'stan',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 379, 'jim',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 380, 'douglas',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 381, 'kimberely',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 382, 'cathie',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 383, 'junkai',89);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 171, 'tynisha',91);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 172, 'aiksheng',91);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 173, 'irvin',91);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 174, 'georgine',91);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 101, 'charlsie',95);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 7, 'monika',96);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 8, 'boyd',96);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 9, 'nilda',96);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 10, 'chana',96);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 1, 'zachary',99);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 2, 'liwen',99);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 400, 'karie',101);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 401, 'jim',101);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 402, 'boyd',101);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 403, 'nakesha',101);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 21, 'francesco',102);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 22, 'junkai',102);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 23, 'rosalva',102);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 24, 'junkai',102);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 25, 'stan',102);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 251, 'junkai',104);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 1701, 'randall',105);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 1702, 'marlene',105);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 1703, 'jarvis',105);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 1704, 'adalberto',105);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 11, 'randall',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 12, 'tynisha',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 13, 'marlene',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 14, 'arturo',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:12', 15, 'francesco',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:13', 16, 'irvin',106);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 66, 'kira',107);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 56, 'jiaying',108);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 57, 'stan',108);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 58, 'julissa',108);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 31, 'derek',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 32, 'melissia',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 33, 'irvin',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 34, 'karie',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 35, 'marlene',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 36, 'marlene',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 37, 'eldriclim',110);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 1, 'tiera',112);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 2, 'sharleen',112);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 3, 'irvin',112);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 4, 'randall',112);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 211, 'andy',115);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 130, 'sixta',117);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 106, 'stan',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 107, 'sharleen',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 108, 'francesco',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:11', 109, 'alina',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:12', 110, 'natalya',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:13', 111, 'marquita',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:14', 112, 'marquita',119);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 2, 'randall',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 3, 'marquita',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 4, 'melissia',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 5, 'zachary',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:12', 6, 'alejandrina',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:13', 7, 'ray',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:14', 8, 'dao',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:15', 9, 'masako',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:16', 10, 'chad',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:17', 11, 'chad',122);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 9, 'zoey',123);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 201, 'monika',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 202, 'dao',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 203, 'jim',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 204, 'lisandra',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 205, 'irvin',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 206, 'adalberto',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 207, 'liwen',124);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 38, 'dao',128);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 40, 'roslyn',129);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 41, 'chana',129);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 42, 'masako',129);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 51, 'rosalva',133);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 52, 'nilda',133);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:10', 53, 'irvin',133);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 150, 'marlene',135);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 151, 'andy',135);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 152, 'luis',135);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 1, 'alina',136);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 2, 'ray',136);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 3, 'georgine',136);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 151, 'jim',137);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 201, 'robbi',140);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 202, 'chana',140);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 19, 'sean',141);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 20, 'robbi',141);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 21, 'douglas',141);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 46, 'monika',142);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 47, 'jeremy',142);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 48, 'aiksheng',142);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 11, 'adalberto',143);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 12, 'stan',143);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 13, 'sharleen',143);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 14, 'kimberely',143);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 251, 'junkai',144);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 252, 'lisandra',144);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 253, 'chana',144);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 254, 'randall',144);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 255, 'alejandrina',144);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 101, 'nilda',147);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 1151, 'derek',149);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 1152, 'cjianhui',149);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 1153, 'sean',149);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 151, 'shengran',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 152, 'stan',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 153, 'stan',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 154, 'jim',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:12', 155, 'jarvis',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:13', 156, 'junkai',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:14', 157, 'melissia',152);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 6, 'holli',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 7, 'adalberto',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 8, 'daniel',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 9, 'roslyn',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 10, 'arturo',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 11, 'maricela',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 12, 'andy',153);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 401, 'marquita',155);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 801, 'kristie',156);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:09', 802, 'chana',156);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 2801, 'cjianhui',158);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 2802, 'lisandra',158);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 201, 'nakesha',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 202, 'marquita',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 203, 'sharleen',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 204, 'margie',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:12', 205, 'jeremy',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:13', 206, 'cathie',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:14', 207, 'charlsie',159);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 9, 'eldriclim',163);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 8, 'randall',164);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 91, 'jeremy',165);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 92, 'colby',165);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 93, 'shengran',165);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 1901, 'masako',167);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 1902, 'kristie',167);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 1903, 'arturo',167);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 1904, 'liwen',167);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 1905, 'eldriclim',167);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 26, 'jiaying',169);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 27, 'alvera',169);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 28, 'jim',169);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 21, 'jarvis',172);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 81, 'derek',173);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 82, 'derek',173);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 83, 'ray',173);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 9, 'andy',174);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 30, 'marquita',177);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:09', 31, 'rosalva',177);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:10', 32, 'britany',177);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:11', 33, 'nilda',177);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 41, 'aiksheng',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 42, 'sharleen',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 43, 'kimberely',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 44, 'kira',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 45, 'alvera',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 46, 'bernarda',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 47, 'jim',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:15', 48, 'alvera',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:16', 49, 'freida',178);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 151, 'charlsie',181);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 152, 'amar',181);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 153, 'julissa',181);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 154, 'jiwen',181);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 36, 'sharleen',184);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 37, 'kira',184);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 38, 'junkai',184);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 39, 'marquita',184);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 11, 'margie',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 12, 'dao',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 13, 'arturo',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 14, 'tynisha',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:12', 15, 'jiaying',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:13', 16, 'derek',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:14', 17, 'adalberto',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:15', 18, 'karie',185);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 40, 'freida',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 41, 'boyd',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 42, 'adalberto',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 43, 'fresi',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:12', 44, 'masako',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:13', 45, 'britany',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:14', 46, 'britany',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:15', 47, 'andy',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:16', 48, 'alvera',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:17', 49, 'cjianhui',186);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 100, 'boyd',187);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 21, 'holli',188);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 22, 'lisandra',188);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 23, 'dao',188);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 24, 'holli',188);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 9, 'stan',190);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 126, 'freida',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 127, 'luis',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 128, 'douglas',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 129, 'arturo',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 130, 'jiwen',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 131, 'monika',193);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 111, 'randall',194);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 112, 'sixta',194);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 113, 'andy',194);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 114, 'adalberto',194);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 6, 'britany',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:09', 7, 'nilda',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:10', 8, 'dot',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:11', 9, 'tiera',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:12', 10, 'marlene',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:13', 11, 'karie',196);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 36, 'marlene',197);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 16, 'alina',198);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 17, 'jeremy',198);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 18, 'karie',198);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 19, 'mattie',198);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 20, 'zoey',199);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 21, 'luis',199);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 22, 'douglas',199);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 46, 'cjianhui',200);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 47, 'jim',200);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 48, 'jeremy',200);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 10, 'rosalva',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 11, 'shengran',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 12, 'eldriclim',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 13, 'luis',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:12', 14, 'kira',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:13', 15, 'cjianhui',203);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 31, 'jiwen',208);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 34, 'britany',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 35, 'randall',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 36, 'zachary',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 37, 'shengran',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:12', 38, 'luis',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:13', 39, 'liwen',209);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 41, 'arturo',210);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 42, 'sean',210);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 43, 'junkai',210);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 44, 'junkai',210);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 11, 'kristie',211);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 12, 'francesco',211);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 13, 'maricela',211);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 14, 'jim',211);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 3151, 'derek',214);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:08', 2889, 'chad',215);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:09', 2890, 'sharleen',215);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:10', 2891, 'britany',215);
INSERT INTO bid VALUES(DEFAULT, '2018-11-05 19:49:11', 2892, 'alejandrina',215);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 1700, 'karie',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 1701, 'karina',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 1702, 'jiwen',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 1703, 'chad',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 1704, 'nilda',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 1705, 'andy',218);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 1251, 'colby',221);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 901, 'robbi',225);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 701, 'margie',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 702, 'tynisha',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 703, 'alejandrina',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 704, 'bernarda',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 705, 'kimberely',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 706, 'kristie',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 707, 'colby',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:15', 708, 'arturo',228);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 600, 'melissia',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 601, 'cjianhui',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 602, 'jiaying',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:11', 603, 'tiera',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:12', 604, 'karie',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:13', 605, 'liwen',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:14', 606, 'tynisha',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:15', 607, 'sharleen',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:16', 608, 'fresi',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:17', 609, 'kira',231);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 600, 'stan',232);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 601, 'georgine',232);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 602, 'dot',232);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 603, 'kira',232);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 557, 'holli',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 558, 'chad',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 559, 'nilda',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:11', 560, 'cathie',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:12', 561, 'jiaying',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:13', 562, 'jarvis',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:14', 563, 'jiaying',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:15', 564, 'charlsie',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:16', 565, 'junkai',233);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:08', 501, 'marlene',235);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:09', 502, 'kristie',235);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:10', 503, 'jiaying',235);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:11', 504, 'aiksheng',235);
INSERT INTO bid VALUES(DEFAULT, '2018-11-03 19:49:12', 505, 'liwen',235);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 441, 'derek',237);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:08', 421, 'chad',240);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:09', 422, 'alejandrina',240);
INSERT INTO bid VALUES(DEFAULT, '2018-11-08 19:49:10', 423, 'nilda',240);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 401, 'tiera',241);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 400, 'jiaying',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:09', 401, 'sixta',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:10', 402, 'melissia',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:11', 403, 'georgine',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:12', 404, 'daniel',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:13', 405, 'bernarda',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:14', 406, 'natalya',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:15', 407, 'masako',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:16', 408, 'roslyn',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:17', 409, 'jeremy',242);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:08', 351, 'kristie',245);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:09', 352, 'jarvis',245);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:10', 353, 'jim',245);
INSERT INTO bid VALUES(DEFAULT, '2018-11-04 19:49:11', 354, 'nilda',245);
INSERT INTO bid VALUES(DEFAULT, '2018-11-07 19:49:08', 351, 'masako',246);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:08', 301, 'kira',247);
INSERT INTO bid VALUES(DEFAULT, '2018-11-01 19:49:09', 302, 'freida',247);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 290, 'aiksheng',249);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:09', 291, 'jeremy',249);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:10', 292, 'douglas',249);
INSERT INTO bid VALUES(DEFAULT, '2018-11-06 19:49:08', 290, 'junkai',250);
INSERT INTO bid VALUES(DEFAULT, '2018-11-02 19:49:08', 290, 'liwen',251);
