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


