CREATE OR REPLACE FUNCTION update_highest_bid() RETURNS TRIGGER AS $update_highest_bid$
    BEGIN
        UPDATE ITEM SET highest_bid_id = new.bid_id where item_id = new.item_id;
	RETURN new;
    END
$update_highest_bid$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_bid_insert AFTER INSERT ON bid
    FOR EACH ROW EXECUTE PROCEDURE update_highest_bid();
