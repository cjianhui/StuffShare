/*============================
Drop all relations
============================*/

DROP TRIGGER before_bid_insert on bid;
DROP TRIGGER after_bid_insert on bid;
DROP FUNCTION update_highest_bid();
DROP FUNCTION check_valid_bid();
DROP TABLE bid;
DROP TABLE item;
DROP TABLE account;