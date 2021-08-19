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

