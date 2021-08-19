--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_comment_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_comment_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.add_comment_trigger_function() OWNER TO postgres;

--
-- Name: basket_clear_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.basket_clear_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM "public"."basket_products"
    WHERE "basket_id" = OLD."basket_id"
        AND "product_id" = OLD."product_id";
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.basket_clear_trigger_function() OWNER TO postgres;

--
-- Name: basket_payment_method_door_pay_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.basket_payment_method_door_pay_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.basket_payment_method_door_pay_trigger_function() OWNER TO postgres;

--
-- Name: buy_and_clear_basket_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.buy_and_clear_basket_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM "public"."basket_products"
    WHERE "basket_id" = OLD."basket_id"
        AND "product_id" = OLD."product_id";
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.buy_and_clear_basket_trigger() OWNER TO postgres;

--
-- Name: calculate_protein_rate(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_protein_rate(protein_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN (
        SELECT
            AVG("rate")
        FROM
            "public"."comments"
        WHERE
            "product_id" = $1);
END;
$_$;


ALTER FUNCTION public.calculate_protein_rate(protein_id integer) OWNER TO postgres;

--
-- Name: get_dealer_proteins(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_dealer_proteins(dealer_id integer) RETURNS TABLE("productId" integer, weight double precision, "for" character varying, rate integer, "typeId" integer)
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.get_dealer_proteins(dealer_id integer) OWNER TO postgres;

--
-- Name: get_dealer_vitamins(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_dealer_vitamins(dealer_id integer) RETURNS TABLE("productId" integer, weight double precision, usage character varying)
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.get_dealer_vitamins(dealer_id integer) OWNER TO postgres;

--
-- Name: search_products(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_products(search_query character varying) RETURNS TABLE(id integer, name character varying, brand_id integer, price double precision)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN query
    SELECT
        *
    FROM
        "public"."products"
    WHERE
        "public"."products"."name" LIKE $1;
END;
$_$;


ALTER FUNCTION public.search_products(search_query character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_materials (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    weight double precision NOT NULL
);


ALTER TABLE public.active_materials OWNER TO postgres;

--
-- Name: active_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_materials_id_seq OWNER TO postgres;

--
-- Name: active_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_materials_id_seq OWNED BY public.active_materials.id;


--
-- Name: active_materials_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_materials_products (
    product_id integer NOT NULL,
    active_material_id integer NOT NULL
);


ALTER TABLE public.active_materials_products OWNER TO postgres;

--
-- Name: adress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adress (
    id integer NOT NULL,
    adress character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.adress OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adress_id_seq OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adress_id_seq OWNED BY public.adress.id;


--
-- Name: basket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basket (
    id integer NOT NULL,
    user_id integer NOT NULL,
    payment_method_id integer NOT NULL
);


ALTER TABLE public.basket OWNER TO postgres;

--
-- Name: basket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.basket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.basket_id_seq OWNER TO postgres;

--
-- Name: basket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.basket_id_seq OWNED BY public.basket.id;


--
-- Name: basket_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basket_products (
    basket_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.basket_products OWNER TO postgres;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    rate integer NOT NULL
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brands_id_seq OWNER TO postgres;

--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- Name: campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    start_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    end_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rate integer NOT NULL
);


ALTER TABLE public.campaign OWNER TO postgres;

--
-- Name: campaign_brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_brands (
    campaign_id integer NOT NULL,
    brand_id integer NOT NULL
);


ALTER TABLE public.campaign_brands OWNER TO postgres;

--
-- Name: campaign_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.campaign_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaign_id_seq OWNER TO postgres;

--
-- Name: campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.campaign_id_seq OWNED BY public.campaign.id;


--
-- Name: campaign_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_products (
    campaign_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.campaign_products OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    comment character varying(255) NOT NULL,
    rate integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: dealers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.dealers OWNER TO postgres;

--
-- Name: dealers_brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealers_brands (
    dealer_id integer NOT NULL,
    brand_id integer NOT NULL
);


ALTER TABLE public.dealers_brands OWNER TO postgres;

--
-- Name: dealers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dealers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dealers_id_seq OWNER TO postgres;

--
-- Name: dealers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dealers_id_seq OWNED BY public.dealers.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_dealers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors_dealers (
    doctor_id integer NOT NULL,
    dealer_id integer NOT NULL
);


ALTER TABLE public.doctors_dealers OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.payment_methods OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_methods_id_seq OWNER TO postgres;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    brand_id integer NOT NULL,
    price double precision
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: proteins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proteins (
    product_id integer NOT NULL,
    weight double precision NOT NULL,
    "for" character varying(255),
    rate integer NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.proteins OWNER TO postgres;

--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    id integer NOT NULL,
    basket_id integer NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total double precision NOT NULL
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_id_seq OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- Name: transaction_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_users (
    transaction_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.transaction_users OWNER TO postgres;

--
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.types OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.types_id_seq OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: vitamins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vitamins (
    product_id integer NOT NULL,
    weight double precision NOT NULL,
    usage character varying(255) NOT NULL
);


ALTER TABLE public.vitamins OWNER TO postgres;

--
-- Name: active_materials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_materials ALTER COLUMN id SET DEFAULT nextval('public.active_materials_id_seq'::regclass);


--
-- Name: adress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adress ALTER COLUMN id SET DEFAULT nextval('public.adress_id_seq'::regclass);


--
-- Name: basket id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket ALTER COLUMN id SET DEFAULT nextval('public.basket_id_seq'::regclass);


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: campaign id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign ALTER COLUMN id SET DEFAULT nextval('public.campaign_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: dealers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers ALTER COLUMN id SET DEFAULT nextval('public.dealers_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: active_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_materials (id, name, weight) FROM stdin;
10	C	1000
20	D	1000
\.


--
-- Data for Name: active_materials_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_materials_products (product_id, active_material_id) FROM stdin;
10	10
20	20
\.


--
-- Data for Name: adress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adress (id, adress, city, user_id) FROM stdin;
20	Alem Mah. Dar Sok. No: 01	Sakarya	20
10	Dunya Mah. Agac Sok. No: 1	Istanbul	10
\.


--
-- Data for Name: basket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.basket (id, user_id, payment_method_id) FROM stdin;
10	10	10
20	20	10
919616	10	10
405376	10	10
\.


--
-- Data for Name: basket_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.basket_products (basket_id, product_id) FROM stdin;
10	20
10	10
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brands (id, name, rate) FROM stdin;
10	Apple	100
20	MyVitamins	80
\.


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign (id, name, description, start_date, end_date, rate) FROM stdin;
10	CAMPAIGN 1	ilk kampanya	2021-08-19 20:52:10.125852	2021-08-19 20:52:10.125852	10
20	CAMPAIGN 2	ikinci kampanya	2021-08-19 20:52:10.125852	2021-08-19 20:52:10.125852	5
\.


--
-- Data for Name: campaign_brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign_brands (campaign_id, brand_id) FROM stdin;
10	10
20	10
\.


--
-- Data for Name: campaign_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campaign_products (campaign_id, product_id) FROM stdin;
10	10
20	20
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, user_id, product_id, comment, rate, created_at) FROM stdin;
10	10	10	Comment 1	80	2021-08-19 20:52:10.125852
20	10	10	Comment 2	80	2021-08-19 20:52:10.125852
30	10	30	Comment 3	80	2021-08-19 20:52:10.125852
\.


--
-- Data for Name: dealers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealers (id, name, email, password) FROM stdin;
10	KOC	k@k.com	123456
20	SAB	s@s.com	asdfg
\.


--
-- Data for Name: dealers_brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealers_brands (dealer_id, brand_id) FROM stdin;
10	10
10	20
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, name) FROM stdin;
10	Dr. Cooper
20	Dr. Koot
\.


--
-- Data for Name: doctors_dealers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors_dealers (doctor_id, dealer_id) FROM stdin;
10	10
20	10
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_methods (id, name) FROM stdin;
10	CARD
20	ON_DOOR
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, brand_id, price) FROM stdin;
10	C Vitamini	20	100
20	D Vitamini	10	200
30	Magnezyum Karbon	10	300
40	Magnezyum Zinc	10	400
\.


--
-- Data for Name: proteins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proteins (product_id, weight, "for", rate, type_id) FROM stdin;
30	1000	CARDIO	100	10
40	1000	POWER	99	20
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (id, basket_id, date, total) FROM stdin;
10	10	2021-08-19 20:52:10.125852	1
20	10	2021-08-19 20:52:10.125852	2
\.


--
-- Data for Name: transaction_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction_users (transaction_id, user_id) FROM stdin;
10	10
20	10
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types (id, name) FROM stdin;
10	A
20	Z
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, password) FROM stdin;
10	Adam	a@m.com	1234
20	Eve	e@m.com	1111
\.


--
-- Data for Name: vitamins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vitamins (product_id, weight, usage) FROM stdin;
10	1000	ORAL
20	1000	ORAL
\.


--
-- Name: active_materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_materials_id_seq', 1, false);


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adress_id_seq', 1, false);


--
-- Name: basket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.basket_id_seq', 1, false);


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brands_id_seq', 1, false);


--
-- Name: campaign_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campaign_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: dealers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealers_id_seq', 1, false);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 1, false);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_methods_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 1, false);


--
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_id_seq', 1, false);


--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 1, false);


--
-- Name: active_materials active_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_materials
    ADD CONSTRAINT active_materials_pkey PRIMARY KEY (id);


--
-- Name: adress adress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adress
    ADD CONSTRAINT adress_pkey PRIMARY KEY (id);


--
-- Name: basket basket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket
    ADD CONSTRAINT basket_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: campaign campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: dealers dealers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user basket_clear_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER basket_clear_trigger AFTER UPDATE ON public."user" FOR EACH ROW EXECUTE FUNCTION public.basket_clear_trigger_function();


--
-- Name: transaction basket_payment_method_door_pay_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER basket_payment_method_door_pay_trigger AFTER UPDATE ON public.transaction FOR EACH ROW EXECUTE FUNCTION public.basket_payment_method_door_pay_trigger_function();


--
-- Name: active_materials_products active_materials_products_active_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_materials_products
    ADD CONSTRAINT active_materials_products_active_material_id_fkey FOREIGN KEY (active_material_id) REFERENCES public.active_materials(id);


--
-- Name: active_materials_products active_materials_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_materials_products
    ADD CONSTRAINT active_materials_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: adress adress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adress
    ADD CONSTRAINT adress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: basket basket_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket
    ADD CONSTRAINT basket_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: basket_products basket_products_basket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket_products
    ADD CONSTRAINT basket_products_basket_id_fkey FOREIGN KEY (basket_id) REFERENCES public.basket(id);


--
-- Name: basket_products basket_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket_products
    ADD CONSTRAINT basket_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: basket basket_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basket
    ADD CONSTRAINT basket_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: campaign_brands campaign_brands_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_brands
    ADD CONSTRAINT campaign_brands_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: campaign_brands campaign_brands_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_brands
    ADD CONSTRAINT campaign_brands_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaign(id);


--
-- Name: campaign_products campaign_products_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_products
    ADD CONSTRAINT campaign_products_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaign(id);


--
-- Name: campaign_products campaign_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_products
    ADD CONSTRAINT campaign_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: comments comments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: dealers_brands dealers_brands_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers_brands
    ADD CONSTRAINT dealers_brands_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: dealers_brands dealers_brands_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers_brands
    ADD CONSTRAINT dealers_brands_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- Name: doctors_dealers doctors_dealers_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors_dealers
    ADD CONSTRAINT doctors_dealers_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- Name: doctors_dealers doctors_dealers_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors_dealers
    ADD CONSTRAINT doctors_dealers_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: proteins proteins_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proteins
    ADD CONSTRAINT proteins_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: proteins proteins_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proteins
    ADD CONSTRAINT proteins_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: transaction transaction_basket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_basket_id_fkey FOREIGN KEY (basket_id) REFERENCES public.basket(id);


--
-- Name: transaction_users transaction_users_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_users
    ADD CONSTRAINT transaction_users_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transaction(id);


--
-- Name: transaction_users transaction_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_users
    ADD CONSTRAINT transaction_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: vitamins vitamins_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vitamins
    ADD CONSTRAINT vitamins_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- PostgreSQL database dump complete
--

