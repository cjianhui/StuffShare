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