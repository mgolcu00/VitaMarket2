
-- CREATE DATABASE VitaMarketDB;

CREATE SCHEMA IF NOT EXISTS "public";

-- USER TABLE
CREATE TABLE "public"."user" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "email" varchar(255) NOT NULL,
    "password" varchar(255) NOT NULL
);

-- Adress TABLE
CREATE TABLE "public"."adress" (
    "id" serial NOT NULL PRIMARY KEY,
    "adress" varchar(255) NOT NULL,
    "city" varchar(255) NOT NULL,
    "user_id" integer NOT NULL REFERENCES "public"."user" ("id")
);

-- Brand TABLE
CREATE TABLE "public"."brands" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "rate" integer NOT NULL
);

-- Product TABLE
CREATE TABLE "public"."products" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "brand_id" integer NOT NULL,
    "price" double precision
);

-- Comments TABLE
CREATE TABLE "public"."comments" (
    "id" serial NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL REFERENCES "public"."user" ("id"),
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id"),
    "comment" varchar(255) NOT NULL,
    "rate" integer NOT NULL,
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Active Materials TABLE
CREATE TABLE "public"."active_materials" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "weight" double precision NOT NULL
);

-- Type TABLE
CREATE TABLE "public"."types" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

-- Vitamins TABLE
CREATE TABLE "public"."vitamins" (
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id"),
    "weight" double precision NOT NULL,
    "usage" varchar(255) NOT NULL
);

-- Proteins TABLE
CREATE TABLE "public"."proteins" (
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id"),
    "weight" double precision NOT NULL,
    "for" varchar(255),
    "rate" integer NOT NULL,
    "type_id" integer NOT NULL REFERENCES "public"."types" ("id")
);

-- Active Materials and product TABLE
CREATE TABLE "public"."active_materials_products" (
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id"),
    "active_material_id" integer NOT NULL REFERENCES "public"."active_materials" ("id")
);

--CREATE PAYMET METHODS TABLE
CREATE TABLE "public"."payment_methods" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

-- Basket TaBLE
CREATE TABLE "public"."basket" (
    "id" serial NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL REFERENCES "public"."user" ("id"),
    "payment_method_id" integer NOT NULL REFERENCES "public"."payment_methods" ("id")
);

-- Basket Products TABLE
CREATE TABLE "public"."basket_products" (
    "basket_id" integer NOT NULL REFERENCES "public"."basket" ("id"),
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id")
);

-- TRANSACTION TABLE
CREATE TABLE "public"."transaction" (
    "id" serial NOT NULL PRIMARY KEY,
    "basket_id" integer NOT NULL REFERENCES "public"."basket" ("id"),
    "date" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "total" double precision NOT NULL
);

-- transaction_users TABLE
CREATE TABLE "public"."transaction_users" (
    "transaction_id" integer NOT NULL REFERENCES "public"."transaction" ("id"),
    "user_id" integer NOT NULL REFERENCES "public"."user" ("id")
);

-- dealers table
CREATE TABLE "public"."dealers" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "email" varchar(255) NOT NULL,
    "password" varchar(255) NOT NULL
);

-- dealers brands table
CREATE TABLE "public"."dealers_brands" (
    "dealer_id" integer NOT NULL REFERENCES "public"."dealers" ("id"),
    "brand_id" integer NOT NULL REFERENCES "public"."brands" ("id")
);

-- CREATE CAMPAIGN TABLE
CREATE TABLE "public"."campaign" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "description" varchar(255),
    "start_date" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_date" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "rate" integer NOT NULL
);

--CREATE CAMPAIGN PRODUCTS TABLE
CREATE TABLE "public"."campaign_products" (
    "campaign_id" integer NOT NULL REFERENCES "public"."campaign" ("id"),
    "product_id" integer NOT NULL REFERENCES "public"."products" ("id")
);

-- CREATE CAMPAIGN BRAND TABLE
CREATE TABLE "public"."campaign_brands" (
    "campaign_id" integer NOT NULL REFERENCES "public"."campaign" ("id"),
    "brand_id" integer NOT NULL REFERENCES "public"."brands" ("id")
);

-- CREATE DOCTORS TABLE
CREATE TABLE "public"."doctors" (
    "id" serial NOT NULL PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

-- CREATE DOCTORS dealers TABLE
CREATE TABLE "public"."doctors_dealers" (
    "doctor_id" integer NOT NULL REFERENCES "public"."doctors" ("id"),
    "dealer_id" integer NOT NULL REFERENCES "public"."dealers" ("id")
);

-- ADD FUNCTIONS
-- GET DEALER PRODUCTS
CREATE OR REPLACE FUNCTION "public"."get_dealer_vitamins" (dealer_id integer)
    RETURNS TABLE (
        "productId" integer,
        "weight" double precision,
        "usage" varchar(255)
    )
    AS $$
BEGIN
    RETURN query
    SELECT
        "id",
        "name",
        "brand_id",
        "price",
        "weight",
        "usage"
    FROM
        "public"."products"
    WHERE
        "brand_id" IN (
            SELECT
                "brand_id"
            FROM
                "public"."dealers_brands"
            WHERE
                "dealer_id" = $1);
END;
$$
LANGUAGE plpgsql;

-- GET DEALER proteins
CREATE OR REPLACE FUNCTION "public"."get_dealer_proteins" (dealer_id integer)
    RETURNS TABLE (
        "productId" integer,
        "weight" double precision,
        "for" varchar(255),
        "rate" integer,
        "typeId" integer
    )
    AS $$
BEGIN
    RETURN query
    SELECT
        "id",
        "name",
        "brand_id",
        "price",
        "weight",
        "for",
        "rate",
        "typeId"
    FROM
        "public"."products"
    WHERE
        "brand_id" IN (
            SELECT
                "brand_id"
            FROM
                "public"."dealers_brands"
            WHERE
                "dealer_id" = $1);
END;
$$
LANGUAGE plpgsql;

-- SEARCH all products by name
CREATE OR REPLACE FUNCTION "public"."search_products" (search_query varchar(255))
    RETURNS TABLE (
    "id" integer,
    "name"  varchar,
    "brand_id" integer  ,
    "price" double precision)
    AS $$
BEGIN
    RETURN query
    SELECT
        *
    FROM
        "public"."products"
    WHERE
        "public"."products"."name" LIKE $1;
END;
$$
LANGUAGE plpgsql;


-- Calculate protein rate
CREATE OR REPLACE FUNCTION "public"."calculate_protein_rate" (protein_id integer)
    RETURNS integer
    AS $$
BEGIN
    RETURN (
        SELECT
            AVG("rate")
        FROM
            "public"."comments"
        WHERE
            "product_id" = $1);
END;
$$
LANGUAGE plpgsql;






-- ADD TRIGGERS
-- CREATE TRIGGER for add transaction to clear basket
-- FUNC buy_and_clear_basket_trigger
CREATE OR REPLACE FUNCTION "public"."buy_and_clear_basket_trigger" ()
    RETURNS TRIGGER
    AS $$
BEGIN
    DELETE FROM "public"."basket_products"
    WHERE "basket_id" = OLD."basket_id"
        AND "product_id" = OLD."product_id";
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER "buy_and_clear_basket"
    AFTER INSERT ON "public"."transaction"
    FOR EACH ROW
    EXECUTE PROCEDURE "public"."buy_and_clear_basket_trigger" ();

-- CREATE TRIGGER ADD COMMENT RE CALCULATE PROTEIN RATE
-- FUNC add_comment_trigger
CREATE OR REPLACE FUNCTION "public"."add_comment_trigger_function" ()
    RETURNS TRIGGER
    AS $$
BEGIN
    UPDATE
        "public"."proteins"
    SET
        "rate" = (
            SELECT
                AVG("rate")
            FROM
                "public"."comments"
            WHERE
                "product_id" = NEW."product_id")
    WHERE
        "id" = NEW."product_id";
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--TRIGGER
CREATE TRIGGER "add_comment_trigger"
    AFTER INSERT ON "public"."comments"
    FOR EACH ROW
    EXECUTE PROCEDURE "public"."add_comment_trigger_function" ();

-- CREATE TRIGGER AND FUNCTION USER PASSWORD CHANGE AND DELETE ALL BASKET and products
-- FUNC add_comment_trigger
CREATE OR REPLACE FUNCTION "public"."basket_clear_trigger_function" ()
    RETURNS TRIGGER
    AS $$
BEGIN
    DELETE FROM "public"."basket_products"
    WHERE "basket_id" = OLD."basket_id"
        AND "product_id" = OLD."product_id";
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- FUNC add_comment_trigger
CREATE TRIGGER "basket_clear_trigger"
    AFTER UPDATE ON "public"."user"
    FOR EACH ROW
    EXECUTE PROCEDURE "public"."basket_clear_trigger_function" ();

-- CREATE FUNCTION AND TRIGGER BASKET PAYMENTMETHOD IS DOOR_PAY
-- FUNC add_comment_trigger
CREATE OR REPLACE FUNCTION "public"."basket_payment_method_door_pay_trigger_function" ()
    RETURNS TRIGGER
    AS $$
BEGIN
    UPDATE
        "public"."transaction"
    SET
        "total" = 5 + "total"
    WHERE
        "payment_method" = 'DOOR_PAY';
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER "basket_payment_method_door_pay_trigger"
    AFTER UPDATE ON "public"."transaction"
    FOR EACH ROW
    EXECUTE PROCEDURE "public"."basket_payment_method_door_pay_trigger_function" ();


-- DROPS
DROP TRIGGER "buy_and_clear_basket" ON "public"."transaction"
DROP TRIGGER "add_comment_trigger" ON "public"."comments"

-- INSERTS
-- USER
INSERT INTO "public"."user" VALUES (10,'Adam','a@m.com','1234');;
INSERT INTO "public"."user" VALUES (20,'Eve','e@m.com','1111');;

-- ADRESS
INSERT INTO "public"."adress" VALUES (10,'Dunya Mah. Agac Sok. No: 44','Istanbul',10);;
INSERT INTO "public"."adress" VALUES (20,'Alem Mah. Dar Sok. No: 01','Sakarya',20);;

-- BRANDS
INSERT INTO "public"."brands" VALUES (10,'Apple',100);
INSERT INTO "public"."brands" VALUES (20,'MyVitamins',80);

-- PRODUCTS
INSERT INTO "public"."products" VALUES (10,'C Vitamini',20,100);
INSERT INTO "public"."products" VALUES (20,'D Vitamini',10,200);
INSERT INTO "public"."products" VALUES (30,'Magnezyum Karbon',10,300);
INSERT INTO "public"."products" VALUES (40,'Magnezyum Zinc',10,400);

-- COMMENTS 
INSERT INTO "public"."comments" VALUES (10,10,10,'Comment 1',80);
INSERT INTO "public"."comments" VALUES (20,10,10,'Comment 2',80);
INSERT INTO "public"."comments" VALUES (30,10,30,'Comment 3',80);

-- active_materials 
INSERT INTO "public"."active_materials" VALUES (10,'C',1000);
INSERT INTO "public"."active_materials" VALUES (20,'D',1000);

-- types
INSERT INTO "public"."types" VALUES (10,'A');
INSERT INTO "public"."types" VALUES (20,'Z');

-- vitamins 
INSERT INTO "public"."vitamins" VALUES(10,1000,'ORAL');
INSERT INTO "public"."vitamins" VALUES(20,1000,'ORAL');

-- proteins
INSERT INTO "public"."proteins" VALUES(30,1000,'CARDIO',100,10);
INSERT INTO "public"."proteins" VALUES(40,1000,'POWER',99,20);

-- active_materials_products
INSERT INTO "public"."active_materials_products" VALUES(10,10);
INSERT INTO "public"."active_materials_products" VALUES(20,20);

-- payment_methods
INSERT INTO "public"."payment_methods" VALUES(10,'CARD');
INSERT INTO "public"."payment_methods" VALUES(20,'ON_DOOR');

-- basket
INSERT INTO "public"."basket" VALUES(10,10,10);
INSERT INTO "public"."basket" VALUES(20,20,10);

-- basket_products
INSERT INTO "public"."basket_products" VALUES(10,10);
INSERT INTO "public"."basket_products" VALUES(10,20);

-- transaction
INSERT INTO "public"."transaction" ("id","basket_id","total")  VALUES(10,10,1);
INSERT INTO "public"."transaction" ("id","basket_id","total")  VALUES(20,10,2);

-- transaction_users
INSERT INTO "public"."transaction_users" VALUES(10,10);
INSERT INTO "public"."transaction_users" VALUES(20,10);

-- dealers
INSERT INTO "public"."dealers" VALUES(10,'KOC','k@k.com','123456');
INSERT INTO "public"."dealers" VALUES(20,'SAB','s@s.com','asdfg');

-- dealers brands
INSERT INTO "public"."dealers_brands" VALUES(10,10);
INSERT INTO "public"."dealers_brands" VALUES(10,20);

-- campaign
INSERT INTO "public"."campaign" ("id","name","description","rate") VALUES(10,'CAMPAIGN 1','ilk kampanya',10);
INSERT INTO "public"."campaign" ("id","name","description","rate") VALUES(20,'CAMPAIGN 2','ikinci kampanya',5);

-- campaign_products
INSERT INTO "public"."campaign_products" VALUES(10,10);
INSERT INTO "public"."campaign_products" VALUES(20,20);

-- campaign_brands  
INSERT INTO "public"."campaign_brands" VALUES(10,10);
INSERT INTO "public"."campaign_brands" VALUES(20,10);

-- doctors
INSERT INTO "public"."doctors" VALUES(10,'Dr. Cooper');
INSERT INTO "public"."doctors" VALUES(20,'Dr. Koot');

-- doctors_dealers
INSERT INTO "public"."doctors_dealers" VALUES(10,10);
INSERT INTO "public"."doctors_dealers" VALUES(20,10);





-- SEELCTS


-- get users
SELECT * FROM "public"."user";

-- get vitamins 
SELECT * FROM "public"."vitamins";

-- get brands
SELECT * FROM "public"."brands";

-- get adress where user_id 
SELECT * FROM "public"."adress" WHERE "user_id" = 10;