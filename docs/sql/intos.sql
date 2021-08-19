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




