/*============================
Drop all relations
============================*/

DROP TRIGGER before_bid_insert ON bid;
DROP TRIGGER after_bid_insert ON bid;
DROP TRIGGER after_bid_delete ON bid;

DROP FUNCTION update_highest_bid();
DROP FUNCTION check_valid_bid();
DROP FUNCTION next_highest_bid();

DROP TABLE bid;
DROP TABLE item;
DROP TABLE account;