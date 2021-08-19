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

