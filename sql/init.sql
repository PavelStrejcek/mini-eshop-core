CREATE OR REPLACE FUNCTION update_at_column()
RETURNS TRIGGER AS $$
BEGIN
    IF row(NEW.*) IS DISTINCT FROM row(OLD.*) THEN
        NEW.changed_at = now();
RETURN NEW;
ELSE
        RETURN OLD;
END IF;
END;
$$ language 'plpgsql';

create table if not exists product
(
    id         uuid                     default gen_random_uuid() not null
    constraint products_pk
    primary key,
    name       text                                               not null,
    cool_uri   text                                               not null,
    changed_at timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null
);

create unique index if not exists product_cool_uri_uindex
    on product (cool_uri);

CREATE OR REPLACE TRIGGER update_product_time BEFORE UPDATE ON product FOR EACH ROW EXECUTE PROCEDURE update_at_column();

create table if not exists product_price
(
    product_id uuid                                               not null
    constraint product_price_product_id_fk
    references product
    on update cascade on delete cascade
    deferrable initially deferred,
    currency   text                                               not null,
    amount     numeric(18, 2),
    changed_at timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null,
                             constraint product_price_pk
                             primary key (product_id, currency)
    deferrable initially deferred
);

create index if not exists product_price_product_id_index
    on product_price (product_id);

CREATE OR REPLACE TRIGGER update_product_price_time BEFORE UPDATE ON product_price FOR EACH ROW EXECUTE PROCEDURE update_at_column();

create table if not exists label
(
    id         uuid default gen_random_uuid() not null
    constraint label_pk
    primary key,
    name       text                     not null,
    changed_at timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null
);

CREATE OR REPLACE TRIGGER update_label_time BEFORE UPDATE ON label FOR EACH ROW EXECUTE PROCEDURE update_at_column();

create table if not exists product_label
(
    product_id uuid not null
    constraint product_label_product__id_fk
    references product
    on update cascade on delete cascade
    deferrable initially deferred,
    label_id   uuid not null
    constraint product_label_label_id_fk
    references label
    on update cascade on delete cascade
    deferrable initially deferred,
    constraint product_label_pk
    primary key (product_id, label_id)
    );

create index if not exists product_label_label_id_index
    on product_label (label_id);

create index if not exists product_label_product_id_index
    on product_label (product_id);

create table if not exists exchange_rate
(
    id         uuid default gen_random_uuid() not null
    constraint exchange_rate_pk
    primary key,
    rate       numeric,
    currency   text                     not null,
    changed_at  timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null
);

CREATE OR REPLACE TRIGGER update_exchange_rate_time BEFORE UPDATE ON exchange_rate FOR EACH ROW EXECUTE PROCEDURE update_at_column();

create table if not exists "order"
(
    id         uuid default gen_random_uuid() not null
    constraint order_pk
    primary key,
    fullname   text                     not null,
    email      text                     not null,
    phone      text,
    total      numeric(18,2)            not null,
    changed_at timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null
);

CREATE OR REPLACE TRIGGER update_order_time BEFORE UPDATE ON "order" FOR EACH ROW EXECUTE PROCEDURE update_at_column();

create table if not exists order_item
(
    id         uuid default gen_random_uuid() not null
    constraint order_item_pk
    primary key,
    order_id   uuid                     not null
    constraint order_item_order_id_fk
    references "order"
    on update cascade on delete cascade
    deferrable initially deferred,
    product_id uuid                     not null
    constraint order_item_product_id_fk
    references product
    on update cascade on delete restrict
    deferrable initially deferred,
    name       text                     not null,
    price_czk  numeric(18,2)            not null,
    price_eur  numeric(18,2),
    quantity   integer                                            not null,
    changed_at timestamp with time zone,
    created_at timestamp with time zone default CURRENT_TIMESTAMP not null
);

create index if not exists order_item_order_id_index
    on order_item (order_id);

create index if not exists order_item_product_id_index
    on order_item (product_id);

CREATE OR REPLACE TRIGGER update_order_item_time BEFORE UPDATE ON "order_item" FOR EACH ROW EXECUTE PROCEDURE update_at_column();


-- DATA

INSERT INTO product (name, cool_uri) VALUES ('Useful Product', 'useful-product');
INSERT INTO product (name, cool_uri) VALUES ('Affordable Product', 'affordable-product');
INSERT INTO product (name, cool_uri) VALUES ('Quality Product', 'quality-product');
INSERT INTO product (name, cool_uri) VALUES ('Luxury Product', 'luxury-product');
INSERT INTO product (name, cool_uri) VALUES ('Beautiful Product', 'beautiful-product');
INSERT INTO product (name, cool_uri) VALUES ('Another Useful Product', 'another-useful-product');
INSERT INTO product (name, cool_uri) VALUES ('Product with Artistic Value', 'product-with-artistic-value');
INSERT INTO product (name, cool_uri) VALUES ('Fun Product', 'fun-product');
INSERT INTO product (name, cool_uri) VALUES ('Accessories for Useful Products', 'accessories-for-useful-products');
INSERT INTO product (name, cool_uri) VALUES ('USB-C Charger', 'usb-c-charger');
INSERT INTO product (name, cool_uri) VALUES ('Clearance Product', 'clearance-product');
INSERT INTO product (name, cool_uri) VALUES ('Discounted Product', 'discounted-product');


INSERT INTO label (name) VALUES ('PROMOTION');
INSERT INTO label (name) VALUES ('DISCOUNT');
INSERT INTO label (name) VALUES ('NEW ARRIVAL');

INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Useful Product'),(SELECT id FROM label WHERE name = 'NEW ARRIVAL'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Affordable Product'),(SELECT id FROM label WHERE name = 'DISCOUNT'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Quality Product'),(SELECT id FROM label WHERE name = 'PROMOTION'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Luxury Product'),(SELECT id FROM label WHERE name = 'NEW ARRIVAL'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Another Useful Product'),(SELECT id FROM label WHERE name = 'DISCOUNT'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Another Useful Product'),(SELECT id FROM label WHERE name = 'PROMOTION'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Another Useful Product'),(SELECT id FROM label WHERE name = 'NEW ARRIVAL'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Discounted Product'),(SELECT id FROM label WHERE name = 'PROMOTION'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Discounted Product'),(SELECT id FROM label WHERE name = 'DISCOUNT'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Fun Product'),(SELECT id FROM label WHERE name = 'PROMOTION'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Fun Product'),(SELECT id FROM label WHERE name = 'NEW ARRIVAL'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Beautiful Product'),(SELECT id FROM label WHERE name = 'NEW ARRIVAL'));


INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Useful Product'), 'CZK', '1000.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Affordable Product'), 'CZK', '125.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Quality Product'), 'CZK', '5598.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Luxury Product'), 'CZK', '69800.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Beautiful Product'), 'CZK', '25900.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Another Useful Product'), 'CZK', '1252.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Product with Artistic Value'), 'CZK', '33000.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Fun Product'), 'CZK', '2340.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Accessories for Useful Products'), 'CZK', '15.20');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'USB-C Charger'), 'CZK', '230.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Clearance Product'), 'CZK', '350.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Discounted Product'), 'CZK', '222.00');

INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Useful Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Affordable Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Quality Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Luxury Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Beautiful Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Another Useful Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Product with Artistic Value'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Fun Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Accessories for Useful Products'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'USB-C Charger'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Clearance Product'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Discounted Product'), 'EUR');
