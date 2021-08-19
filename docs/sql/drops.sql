DROP TRIGGER "buy_and_clear_basket" ON "public"."transaction"
DROP TRIGGER "add_comment_trigger" ON "public"."comments"


-- DELETES

-- delete prouct to basket
DELETE FROM "public"."basket_products" WHERE "product_id" = '10'
