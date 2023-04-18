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

INSERT INTO product (name, cool_uri) VALUES ('Užitečný produkt', 'uzitecny-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Levný produkt', 'levny-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Kvalitní produkt', 'kvalitni-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Luxusní produkt', 'luxusni-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Nádherný produkt', 'nadherny-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Další užitečný produkt', 'dalsi-uzitecny-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Produkt s uměleckou hodnotou', 'produkt-umeleckou-hodnotou');
INSERT INTO product (name, cool_uri) VALUES ('Zábavný produkt', 'zabavny-produkt');
INSERT INTO product (name, cool_uri) VALUES ('Příslušenství k užitečným produktům', 'prislusenstvi-k-uzitecnym-produktum');
INSERT INTO product (name, cool_uri) VALUES ('Nabíječka USB-C', 'nabijecka-usb-c');
INSERT INTO product (name, cool_uri) VALUES ('Produkt ve výprodeji', 'produkt-ve-vyprodeji');
INSERT INTO product (name, cool_uri) VALUES ('Zlevněný produkt', 'zlevneny-produkt');


INSERT INTO label (name) VALUES ('AKCE');
INSERT INTO label (name) VALUES ('SLEVA');
INSERT INTO label (name) VALUES ('NOVINKA');

INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Užitečný produkt'),(SELECT id FROM label WHERE name = 'NOVINKA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Levný produkt'),(SELECT id FROM label WHERE name = 'SLEVA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Kvalitní produkt'),(SELECT id FROM label WHERE name = 'AKCE'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Luxusní produkt'),(SELECT id FROM label WHERE name = 'NOVINKA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Další užitečný produkt'),(SELECT id FROM label WHERE name = 'SLEVA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Další užitečný produkt'),(SELECT id FROM label WHERE name = 'AKCE'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Další užitečný produkt'),(SELECT id FROM label WHERE name = 'NOVINKA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Zlevněný produkt'),(SELECT id FROM label WHERE name = 'AKCE'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Zlevněný produkt'),(SELECT id FROM label WHERE name = 'SLEVA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Zábavný produkt'),(SELECT id FROM label WHERE name = 'AKCE'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Zábavný produkt'),(SELECT id FROM label WHERE name = 'NOVINKA'));
INSERT INTO product_label (product_id, label_id) VALUES ((SELECT id FROM product WHERE name = 'Nádherný produkt'),(SELECT id FROM label WHERE name = 'NOVINKA'));


INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Užitečný produkt'), 'CZK', '1000.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Levný produkt'), 'CZK', '125.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Kvalitní produkt'), 'CZK', '5598.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Luxusní produkt'), 'CZK', '69800.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Nádherný produkt'), 'CZK', '25900.30');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Další užitečný produkt'), 'CZK', '1252.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Produkt s uměleckou hodnotou'), 'CZK', '33000.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Zábavný produkt'), 'CZK', '2340.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Příslušenství k užitečným produktům'), 'CZK', '15.20');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Nabíječka USB-C'), 'CZK', '230.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Produkt ve výprodeji'), 'CZK', '350.00');
INSERT INTO product_price (product_id, currency, amount) VALUES ((SELECT id FROM product WHERE name = 'Zlevněný produkt'), 'CZK', '222.00');

INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Užitečný produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Levný produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Kvalitní produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Luxusní produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Nádherný produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Další užitečný produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Produkt s uměleckou hodnotou'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Zábavný produkt'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Příslušenství k užitečným produktům'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Nabíječka USB-C'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Produkt ve výprodeji'), 'EUR');
INSERT INTO product_price (product_id, currency) VALUES ((SELECT id FROM product WHERE name = 'Zlevněný produkt'), 'EUR');
