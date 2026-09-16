--
-- PostgreSQL database dump
--

\restrict pdtEc0kic1iIFVLZXobU1PaL3zFcGz1iLyPmqDWEqFen7wpLLDqOxyzDfJYUtan

-- Dumped from database version 17.11 (Debian 17.11-0+deb13u1)
-- Dumped by pg_dump version 17.11 (Debian 17.11-0+deb13u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA drizzle;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: -
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: -
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: -
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: accounting_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounting_transactions (
    id integer NOT NULL,
    type character varying(24) NOT NULL,
    amount integer NOT NULL,
    description text NOT NULL,
    reference_type character varying(40),
    reference_id character varying(80),
    status character varying(24) DEFAULT 'posted'::character varying NOT NULL,
    created_by character varying(180) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: accounting_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounting_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounting_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounting_transactions_id_seq OWNED BY public.accounting_transactions.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    label character varying(80) DEFAULT 'منزل'::character varying NOT NULL,
    province character varying(80) NOT NULL,
    city character varying(80) NOT NULL,
    full_address text NOT NULL,
    postal_code character varying(16) NOT NULL,
    plate character varying(20),
    unit character varying(20),
    recipient character varying(160) NOT NULL,
    phone character varying(20) NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admin_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_audit_logs (
    id integer NOT NULL,
    admin_email character varying(180) NOT NULL,
    action character varying(80) NOT NULL,
    entity_type character varying(60) NOT NULL,
    entity_id character varying(80),
    before jsonb,
    after jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: admin_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_audit_logs_id_seq OWNED BY public.admin_audit_logs.id;


--
-- Name: admin_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_notifications (
    id integer NOT NULL,
    kind character varying(40) NOT NULL,
    title character varying(160) NOT NULL,
    body text DEFAULT ''::text NOT NULL,
    href character varying(200),
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: admin_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_notifications_id_seq OWNED BY public.admin_notifications.id;


--
-- Name: allergens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.allergens (
    id integer NOT NULL,
    label character varying(80) NOT NULL
);


--
-- Name: allergens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.allergens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allergens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.allergens_id_seq OWNED BY public.allergens.id;


--
-- Name: auth_challenges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_challenges (
    id integer NOT NULL,
    purpose character varying(32) NOT NULL,
    identifier character varying(180) NOT NULL,
    code_hash text NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 5 NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    consumed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: auth_challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_challenges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_challenges_id_seq OWNED BY public.auth_challenges.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.banners (
    id integer NOT NULL,
    title character varying(180) NOT NULL,
    subtitle text DEFAULT ''::text NOT NULL,
    image text NOT NULL,
    image_alt text NOT NULL,
    href text DEFAULT '/'::text NOT NULL,
    placement character varying(40) DEFAULT 'homepage'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banners_id_seq OWNED BY public.banners.id;


--
-- Name: beverage_pairings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.beverage_pairings (
    id integer NOT NULL,
    pair character varying(200) NOT NULL,
    drink character varying(200) NOT NULL,
    note text DEFAULT ''::text NOT NULL
);


--
-- Name: beverage_pairings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.beverage_pairings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: beverage_pairings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.beverage_pairings_id_seq OWNED BY public.beverage_pairings.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaigns (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    banner text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    start_date character varying(20) NOT NULL,
    end_date character varying(20) NOT NULL,
    discount integer DEFAULT 0 NOT NULL,
    category character varying(60) DEFAULT 'all'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campaigns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    short_description text DEFAULT ''::text NOT NULL,
    image text DEFAULT ''::text NOT NULL,
    image_alt text DEFAULT ''::text NOT NULL,
    icon character varying(40) DEFAULT 'leaf'::character varying NOT NULL,
    subs jsonb DEFAULT '[]'::jsonb NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    seo_title character varying(180),
    seo_description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_messages (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(160) DEFAULT ''::character varying NOT NULL,
    subject character varying(200) DEFAULT ''::character varying NOT NULL,
    message text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_messages_id_seq OWNED BY public.contact_messages.id;


--
-- Name: corporate_gift_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.corporate_gift_requests (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    company_name character varying(200) NOT NULL,
    contact_name character varying(160) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(180) DEFAULT ''::character varying NOT NULL,
    package_slug character varying(200),
    quantity integer DEFAULT 1 NOT NULL,
    occasion character varying(120) DEFAULT ''::character varying NOT NULL,
    desired_delivery_date character varying(40) DEFAULT ''::character varying NOT NULL,
    branding_requirements text DEFAULT ''::text NOT NULL,
    packaging_notes text DEFAULT ''::text NOT NULL,
    recipient_notes text DEFAULT ''::text NOT NULL,
    additional_notes text DEFAULT ''::text NOT NULL,
    indicative_total integer,
    status character varying(32) DEFAULT 'new'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: corporate_gift_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.corporate_gift_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: corporate_gift_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.corporate_gift_requests_id_seq OWNED BY public.corporate_gift_requests.id;


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coupons (
    code character varying(40) NOT NULL,
    type character varying(20) DEFAULT 'percent'::character varying NOT NULL,
    value integer NOT NULL,
    minimum_purchase integer DEFAULT 0 NOT NULL,
    maximum_discount integer,
    start_date character varying(20) NOT NULL,
    end_date character varying(20) NOT NULL,
    usage_limit integer DEFAULT 100 NOT NULL,
    used_count integer DEFAULT 0 NOT NULL,
    product_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    category_slugs jsonb DEFAULT '[]'::jsonb NOT NULL,
    active boolean DEFAULT true NOT NULL,
    label text DEFAULT ''::text NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    name character varying(160) NOT NULL,
    phone character varying(20),
    email character varying(180),
    password_hash text,
    password_updated_at timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    national_id character varying(10),
    nid_verified_at timestamp without time zone,
    identity_provider character varying(24)
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: gift_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gift_packages (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    kind character varying(24) DEFAULT 'personal'::character varying NOT NULL,
    short_description text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    image text DEFAULT ''::text NOT NULL,
    image_alt text DEFAULT ''::text NOT NULL,
    base_price integer NOT NULL,
    old_price integer,
    stock integer DEFAULT 0 NOT NULL,
    min_qty integer DEFAULT 1 NOT NULL,
    max_qty integer DEFAULT 20 NOT NULL,
    contents jsonb DEFAULT '[]'::jsonb NOT NULL,
    occasions jsonb DEFAULT '[]'::jsonb NOT NULL,
    packaging_options jsonb DEFAULT '[]'::jsonb NOT NULL,
    allows_message boolean DEFAULT true NOT NULL,
    allows_recipient boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    seo_title character varying(180),
    seo_description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: gift_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gift_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gift_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gift_packages_id_seq OWNED BY public.gift_packages.id;


--
-- Name: gift_quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gift_quotes (
    id integer NOT NULL,
    package_id integer NOT NULL,
    config jsonb NOT NULL,
    unit_price integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    total integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: gift_quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gift_quotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gift_quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gift_quotes_id_seq OWNED BY public.gift_quotes.id;


--
-- Name: instagram_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instagram_posts (
    id integer NOT NULL,
    image_url text NOT NULL,
    caption text DEFAULT ''::text NOT NULL,
    permalink text,
    product_slug character varying(120),
    likes integer,
    comments integer,
    posted_at timestamp without time zone DEFAULT now() NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    kind character varying(16) DEFAULT 'post'::character varying NOT NULL,
    title text
);


--
-- Name: instagram_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instagram_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instagram_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.instagram_posts_id_seq OWNED BY public.instagram_posts.id;


--
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_movements (
    id integer NOT NULL,
    product_id integer,
    tray_id integer,
    variant_id integer,
    quantity_change integer NOT NULL,
    previous_quantity integer NOT NULL,
    new_quantity integer NOT NULL,
    reason character varying(32) NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    created_by character varying(180) NOT NULL,
    reference_type character varying(40),
    reference_id character varying(80),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_movements_id_seq OWNED BY public.inventory_movements.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    number character varying(60) NOT NULL,
    order_id integer NOT NULL,
    customer_id integer,
    subtotal integer DEFAULT 0 NOT NULL,
    discount integer DEFAULT 0 NOT NULL,
    shipping integer DEFAULT 0 NOT NULL,
    total integer DEFAULT 0 NOT NULL,
    payment_method character varying(32),
    provider character varying(50),
    status character varying(24) DEFAULT 'issued'::character varying NOT NULL,
    paid_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: mazeh_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mazeh_categories (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    code character varying(30) NOT NULL
);


--
-- Name: mazeh_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mazeh_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mazeh_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mazeh_categories_id_seq OWNED BY public.mazeh_categories.id;


--
-- Name: mazeh_tray_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mazeh_tray_items (
    id integer NOT NULL,
    tray_id integer NOT NULL,
    product_id integer,
    title character varying(200) NOT NULL,
    quantity character varying(60) DEFAULT ''::character varying NOT NULL,
    section character varying(30) DEFAULT 'SAVORY'::character varying NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: mazeh_tray_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mazeh_tray_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mazeh_tray_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mazeh_tray_items_id_seq OWNED BY public.mazeh_tray_items.id;


--
-- Name: mazeh_trays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mazeh_trays (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    sku character varying(64),
    short_description text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    image text DEFAULT ''::text NOT NULL,
    image_alt text DEFAULT ''::text NOT NULL,
    base_price integer NOT NULL,
    old_price integer,
    cost_price integer,
    stock integer DEFAULT 0 NOT NULL,
    low_stock_threshold integer DEFAULT 2 NOT NULL,
    weight character varying(60),
    size character varying(40) DEFAULT 'متوسط'::character varying NOT NULL,
    serves_min integer DEFAULT 2 NOT NULL,
    serves_max integer DEFAULT 6 NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    allergens jsonb DEFAULT '[]'::jsonb NOT NULL,
    pairings jsonb DEFAULT '[]'::jsonb NOT NULL,
    occasions jsonb DEFAULT '[]'::jsonb NOT NULL,
    contents jsonb DEFAULT '[]'::jsonb NOT NULL,
    storage text DEFAULT ''::text NOT NULL,
    freshness text DEFAULT ''::text NOT NULL,
    seo_title character varying(180),
    seo_description text,
    archived_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: mazeh_trays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mazeh_trays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mazeh_trays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mazeh_trays_id_seq OWNED BY public.mazeh_trays.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer,
    tray_id integer,
    variant_id integer,
    item_type character varying(20) DEFAULT 'product'::character varying NOT NULL,
    name_snapshot character varying(220) NOT NULL,
    sku_snapshot character varying(64),
    unit_price integer NOT NULL,
    quantity integer NOT NULL,
    subtotal integer NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    customer_id integer,
    customer jsonb NOT NULL,
    address jsonb,
    items jsonb NOT NULL,
    subtotal integer DEFAULT 0 NOT NULL,
    discount integer DEFAULT 0 NOT NULL,
    shipping integer DEFAULT 0 NOT NULL,
    total integer DEFAULT 0 NOT NULL,
    coupon_code character varying(40),
    payment_status character varying(32) DEFAULT 'pending'::character varying NOT NULL,
    payment_method character varying(32),
    payment_reference character varying(120),
    shipping_method character varying(80),
    status character varying(40) DEFAULT 'pending'::character varying NOT NULL,
    idempotency_key character varying(64),
    paid_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    note text,
    is_gift boolean DEFAULT false NOT NULL,
    gift_recipient character varying(120),
    gift_message text,
    gift_packaging boolean DEFAULT false NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: party_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.party_packages (
    id integer NOT NULL,
    max_guests integer NOT NULL,
    tray_slug character varying(120) NOT NULL,
    title character varying(200) NOT NULL,
    note text DEFAULT ''::text NOT NULL
);


--
-- Name: party_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.party_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: party_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.party_packages_id_seq OWNED BY public.party_packages.id;


--
-- Name: payment_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_logs (
    id integer NOT NULL,
    payment_id integer,
    order_id integer,
    event character varying(40) NOT NULL,
    provider character varying(50),
    method character varying(32),
    amount integer,
    authority character varying(160),
    detail jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_logs_id_seq OWNED BY public.payment_logs.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    order_id integer NOT NULL,
    provider character varying(50) NOT NULL,
    method character varying(32) NOT NULL,
    amount integer NOT NULL,
    status character varying(32) DEFAULT 'pending'::character varying NOT NULL,
    authority character varying(160),
    reference character varying(160),
    verified_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp without time zone
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: product_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_images (
    id integer NOT NULL,
    product_id integer NOT NULL,
    url text NOT NULL,
    alt text NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    requires_replacement boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variants (
    id integer NOT NULL,
    product_id integer NOT NULL,
    name character varying(120) NOT NULL,
    sku character varying(64) NOT NULL,
    price integer NOT NULL,
    compare_at_price integer,
    cost_price integer,
    stock integer DEFAULT 0 NOT NULL,
    weight integer,
    unit character varying(24) DEFAULT 'گرم'::character varying NOT NULL,
    flavor character varying(80),
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: product_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_variants_id_seq OWNED BY public.product_variants.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    category character varying(120) NOT NULL,
    category_id integer,
    sku character varying(64) NOT NULL,
    brand character varying(100) DEFAULT 'هلسا ایرانیان'::character varying NOT NULL,
    short_description text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    price integer NOT NULL,
    old_price integer,
    cost_price integer,
    discount integer DEFAULT 0 NOT NULL,
    currency character varying(12) DEFAULT 'TOMAN'::character varying NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    stock_status character varying(24) DEFAULT 'in_stock'::character varying NOT NULL,
    low_stock_threshold integer DEFAULT 5 NOT NULL,
    min_order_qty integer DEFAULT 1 NOT NULL,
    max_order_qty integer,
    weight character varying(60) DEFAULT ''::character varying NOT NULL,
    unit character varying(32) DEFAULT 'بسته'::character varying NOT NULL,
    packaging text DEFAULT ''::text NOT NULL,
    ingredients text DEFAULT ''::text NOT NULL,
    origin text DEFAULT ''::text NOT NULL,
    storage text DEFAULT ''::text NOT NULL,
    image text DEFAULT ''::text NOT NULL,
    image_alt text DEFAULT ''::text NOT NULL,
    image_status character varying(32) DEFAULT 'seed_reference'::character varying NOT NULL,
    gallery jsonb DEFAULT '[]'::jsonb NOT NULL,
    rating real DEFAULT 0 NOT NULL,
    reviews integer DEFAULT 0 NOT NULL,
    badge character varying(40),
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    features jsonb DEFAULT '[]'::jsonb NOT NULL,
    nutrition jsonb DEFAULT '[]'::jsonb NOT NULL,
    allergens jsonb DEFAULT '[]'::jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    is_visible boolean DEFAULT true NOT NULL,
    seo_title character varying(180),
    seo_description text,
    archived_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    product_id integer NOT NULL,
    customer_id integer,
    author character varying(80) NOT NULL,
    rating integer NOT NULL,
    title character varying(120) NOT NULL,
    text text NOT NULL,
    is_approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    verified_phone character varying(20),
    verified_purchase boolean DEFAULT false NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: shipping_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipping_methods (
    id integer NOT NULL,
    code character varying(40) NOT NULL,
    label character varying(120) NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    estimated_time character varying(100) DEFAULT ''::character varying NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: shipping_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shipping_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipping_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shipping_methods_id_seq OWNED BY public.shipping_methods.id;


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_settings (
    key character varying(64) NOT NULL,
    value text NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: tray_customizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tray_customizations (
    id integer NOT NULL,
    group_id character varying(30) NOT NULL,
    option_id character varying(40) NOT NULL,
    label character varying(120) NOT NULL,
    price integer NOT NULL
);


--
-- Name: tray_customizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tray_customizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tray_customizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tray_customizations_id_seq OWNED BY public.tray_customizations.id;


--
-- Name: tray_occasions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tray_occasions (
    id integer NOT NULL,
    label character varying(80) NOT NULL
);


--
-- Name: tray_occasions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tray_occasions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tray_occasions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tray_occasions_id_seq OWNED BY public.tray_occasions.id;


--
-- Name: tray_quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tray_quotes (
    id integer NOT NULL,
    config jsonb NOT NULL,
    total integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: tray_quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tray_quotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tray_quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tray_quotes_id_seq OWNED BY public.tray_quotes.id;


--
-- Name: tray_sizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tray_sizes (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    label character varying(60) NOT NULL,
    base_price integer NOT NULL,
    factor real DEFAULT 1 NOT NULL
);


--
-- Name: tray_sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tray_sizes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tray_sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tray_sizes_id_seq OWNED BY public.tray_sizes.id;


--
-- Name: wholesale_businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wholesale_businesses (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    business_name character varying(200) NOT NULL,
    business_type character varying(40) NOT NULL,
    contact_name character varying(160) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(180) DEFAULT ''::character varying NOT NULL,
    city character varying(80) DEFAULT ''::character varying NOT NULL,
    address text DEFAULT ''::text NOT NULL,
    economic_code character varying(40) DEFAULT ''::character varying NOT NULL,
    monthly_volume character varying(80) DEFAULT ''::character varying NOT NULL,
    interests text DEFAULT ''::text NOT NULL,
    notes text DEFAULT ''::text NOT NULL,
    discount_percent integer DEFAULT 0 NOT NULL,
    status character varying(32) DEFAULT 'pending'::character varying NOT NULL,
    customer_id integer,
    admin_note text DEFAULT ''::text NOT NULL,
    reviewed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: wholesale_businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wholesale_businesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wholesale_businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wholesale_businesses_id_seq OWNED BY public.wholesale_businesses.id;


--
-- Name: wholesale_inquiries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wholesale_inquiries (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    business_type character varying(40) NOT NULL,
    company_name character varying(200) NOT NULL,
    contact_name character varying(160) NOT NULL,
    mobile character varying(20) NOT NULL,
    email character varying(180) DEFAULT ''::character varying NOT NULL,
    city character varying(80) DEFAULT ''::character varying NOT NULL,
    estimated_monthly_volume character varying(80) DEFAULT ''::character varying NOT NULL,
    product_interests text DEFAULT ''::text NOT NULL,
    notes text DEFAULT ''::text NOT NULL,
    status character varying(32) DEFAULT 'new'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: wholesale_inquiries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wholesale_inquiries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wholesale_inquiries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wholesale_inquiries_id_seq OWNED BY public.wholesale_inquiries.id;


--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Name: accounting_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounting_transactions ALTER COLUMN id SET DEFAULT nextval('public.accounting_transactions_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admin_audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.admin_audit_logs_id_seq'::regclass);


--
-- Name: admin_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_notifications ALTER COLUMN id SET DEFAULT nextval('public.admin_notifications_id_seq'::regclass);


--
-- Name: allergens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergens ALTER COLUMN id SET DEFAULT nextval('public.allergens_id_seq'::regclass);


--
-- Name: auth_challenges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_challenges ALTER COLUMN id SET DEFAULT nextval('public.auth_challenges_id_seq'::regclass);


--
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners ALTER COLUMN id SET DEFAULT nextval('public.banners_id_seq'::regclass);


--
-- Name: beverage_pairings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.beverage_pairings ALTER COLUMN id SET DEFAULT nextval('public.beverage_pairings_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: contact_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_messages ALTER COLUMN id SET DEFAULT nextval('public.contact_messages_id_seq'::regclass);


--
-- Name: corporate_gift_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_gift_requests ALTER COLUMN id SET DEFAULT nextval('public.corporate_gift_requests_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: gift_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_packages ALTER COLUMN id SET DEFAULT nextval('public.gift_packages_id_seq'::regclass);


--
-- Name: gift_quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_quotes ALTER COLUMN id SET DEFAULT nextval('public.gift_quotes_id_seq'::regclass);


--
-- Name: instagram_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instagram_posts ALTER COLUMN id SET DEFAULT nextval('public.instagram_posts_id_seq'::regclass);


--
-- Name: inventory_movements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movements ALTER COLUMN id SET DEFAULT nextval('public.inventory_movements_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: mazeh_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_categories ALTER COLUMN id SET DEFAULT nextval('public.mazeh_categories_id_seq'::regclass);


--
-- Name: mazeh_tray_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_tray_items ALTER COLUMN id SET DEFAULT nextval('public.mazeh_tray_items_id_seq'::regclass);


--
-- Name: mazeh_trays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_trays ALTER COLUMN id SET DEFAULT nextval('public.mazeh_trays_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: party_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.party_packages ALTER COLUMN id SET DEFAULT nextval('public.party_packages_id_seq'::regclass);


--
-- Name: payment_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_logs ALTER COLUMN id SET DEFAULT nextval('public.payment_logs_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Name: product_variants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN id SET DEFAULT nextval('public.product_variants_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: shipping_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_methods ALTER COLUMN id SET DEFAULT nextval('public.shipping_methods_id_seq'::regclass);


--
-- Name: tray_customizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_customizations ALTER COLUMN id SET DEFAULT nextval('public.tray_customizations_id_seq'::regclass);


--
-- Name: tray_occasions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_occasions ALTER COLUMN id SET DEFAULT nextval('public.tray_occasions_id_seq'::regclass);


--
-- Name: tray_quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_quotes ALTER COLUMN id SET DEFAULT nextval('public.tray_quotes_id_seq'::regclass);


--
-- Name: tray_sizes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_sizes ALTER COLUMN id SET DEFAULT nextval('public.tray_sizes_id_seq'::regclass);


--
-- Name: wholesale_businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_businesses ALTER COLUMN id SET DEFAULT nextval('public.wholesale_businesses_id_seq'::regclass);


--
-- Name: wholesale_inquiries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_inquiries ALTER COLUMN id SET DEFAULT nextval('public.wholesale_inquiries_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: -
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
\.


--
-- Data for Name: accounting_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.accounting_transactions (id, type, amount, description, reference_type, reference_id, status, created_by, created_at) FROM stdin;
1	SALE	405000	فروش سفارش HLA-B0EC6B31	ORDER	HLA-B0EC6B31	posted	owner@helsa.dev	2026-09-11 22:19:16.167022
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.addresses (id, customer_id, label, province, city, full_address, postal_code, plate, unit, recipient, phone, is_default, created_at, updated_at) FROM stdin;
2	10	منزل	تهران	تهران	خیابان آزادی، کوچه بهار، پلاک ۱۲	1234567890			سارا تستی	09129896265	f	2026-09-11 22:49:17.157309	2026-09-11 22:49:17.157309
3	12	منزل	تهران	تهران	خیابان تست پرداخت، پلاک ۱۲	1234567890			پرداخت تستی	09123308583	f	2026-09-12 07:36:24.051447	2026-09-12 07:36:24.051447
4	14	منزل	تهران	تهران	خیابان تست پرداخت، پلاک ۱۲	1234567890			پرداخت تستی	09123308603	f	2026-09-12 07:36:43.214275	2026-09-12 07:36:43.214275
5	17	منزل	تهران	تهران	خیابان تست پرداخت، پلاک ۱۲	1234567890			پرداخت تستی	09123308683	f	2026-09-12 07:38:03.145235	2026-09-12 07:38:03.145235
6	19	منزل	تهران	تهران	خیابان تست پرداخت، پلاک ۱۲	1234567890			پرداخت تستی	09123308769	f	2026-09-12 07:39:29.263728	2026-09-12 07:39:29.263728
7	21	منزل	تهران	تهران	خیابان آزادی، کوچه بهار، پلاک ۱۲	1234567890			سارا تستی	09121770849	f	2026-09-12 07:40:33.021511	2026-09-12 07:40:33.021511
10	30	منزل	تهران	تهران	خیابان تست، پلاک ۱	1111111111			ممیز تست	09122401213	f	2026-09-15 15:19:12.177749	2026-09-15 15:19:12.177749
11	34	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09124315224	f	2026-09-15 17:15:38.994911	2026-09-15 17:15:38.994911
12	36	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09124805726	f	2026-09-15 18:25:48.567534	2026-09-15 18:25:48.567534
13	38	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09124754798	f	2026-09-16 07:37:41.132395	2026-09-16 07:37:41.132395
14	40	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09121807183	f	2026-09-16 09:08:49.205354	2026-09-16 09:08:49.205354
15	42	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09121623130	f	2026-09-16 09:44:07.618748	2026-09-16 09:44:07.618748
16	43	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09124213312	f	2026-09-16 10:01:46.624539	2026-09-16 10:01:46.624539
17	48	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09127995594	f	2026-09-16 10:43:50.221563	2026-09-16 10:43:50.221563
18	62	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09125202525	f	2026-09-16 11:09:42.789365	2026-09-16 11:09:42.789365
19	63	منزل	تهران	تهران	خیابان ولیعصر، کوچه بهار، پلاک ۱۲	1234567890			سارا تستی	09125556677	f	2026-09-16 11:17:49.006336	2026-09-16 11:17:49.006336
20	72	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09129931079	f	2026-09-16 13:39:05.01206	2026-09-16 13:39:05.01206
21	74	منزل	تهران	تهران	خیابان مهمان، پلاک ۹	1111111111			مهمان تستی	09126085274	f	2026-09-16 14:10:09.985641	2026-09-16 14:10:09.985641
\.


--
-- Data for Name: admin_audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_audit_logs (id, admin_email, action, entity_type, entity_id, before, after, created_at) FROM stdin;
1	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "pending", "paymentStatus": "pending"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-11 22:19:16.167022
2	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-11 22:19:16.182296
3	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-11 22:19:16.1931
4	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-11 22:19:16.203283
5	owner@helsa.dev	CREATE	PRODUCT	184	\N	{"id": 184, "sku": "QA-QA-AUDIT-65156", "name": "پک تست ممیزی", "slug": "qa-audit-65156", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:16.229Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:16.231Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-11 22:19:16.229552
6	owner@helsa.dev	UPDATE	PRODUCT	184	{"id": 184, "sku": "QA-QA-AUDIT-65156", "name": "پک تست ممیزی", "slug": "qa-audit-65156", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:16.229Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:16.231Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 184, "sku": "QA-QA-AUDIT-65156", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-65156", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:16.229Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:16.264Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-11 22:19:16.262
7	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	184	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-11 22:19:16.317819
8	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	184	{"stock": 2}	{"stock": 32, "reason": "ورود کالا"}	2026-09-11 22:19:16.331492
9	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "delivered", "paymentStatus": "paid"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-11 22:19:58.050459
10	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-11 22:19:58.061975
11	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-11 22:19:58.074085
12	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-11 22:19:58.087529
13	owner@helsa.dev	CREATE	PRODUCT	185	\N	{"id": 185, "sku": "QA-QA-AUDIT-65198", "name": "پک تست ممیزی", "slug": "qa-audit-65198", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:58.106Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:58.108Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-11 22:19:58.106566
29	owner@helsa.dev	CREATE	PRODUCT	187	\N	{"id": 187, "sku": "QA-QA-AUDIT-65212", "name": "پک تست ممیزی", "slug": "qa-audit-65212", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:12.087Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:12.089Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-11 22:20:12.087922
14	owner@helsa.dev	UPDATE	PRODUCT	185	{"id": 185, "sku": "QA-QA-AUDIT-65198", "name": "پک تست ممیزی", "slug": "qa-audit-65198", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:58.106Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:58.108Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 185, "sku": "QA-QA-AUDIT-65198", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-65198", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:19:58.106Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:19:58.137Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-11 22:19:58.134556
15	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	185	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-11 22:19:58.182514
16	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	185	{"stock": 2}	{"stock": 32, "reason": "ورود کالا"}	2026-09-11 22:19:58.193589
17	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "delivered", "paymentStatus": "paid"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-11 22:20:11.409269
18	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-11 22:20:11.421739
19	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-11 22:20:11.433331
20	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-11 22:20:11.445228
21	owner@helsa.dev	CREATE	PRODUCT	186	\N	{"id": 186, "sku": "QA-QA-AUDIT-65211", "name": "پک تست ممیزی", "slug": "qa-audit-65211", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:11.462Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:11.464Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-11 22:20:11.46277
22	owner@helsa.dev	UPDATE	PRODUCT	186	{"id": 186, "sku": "QA-QA-AUDIT-65211", "name": "پک تست ممیزی", "slug": "qa-audit-65211", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:11.462Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:11.464Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 186, "sku": "QA-QA-AUDIT-65211", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-65211", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:11.462Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:11.504Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-11 22:20:11.491436
23	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	186	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-11 22:20:11.568962
24	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	186	{"stock": 2}	{"stock": 32, "reason": "ورود کالا"}	2026-09-11 22:20:11.587058
25	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "delivered", "paymentStatus": "paid"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-11 22:20:12.038377
26	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-11 22:20:12.049289
27	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-11 22:20:12.059106
28	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-11 22:20:12.06993
30	owner@helsa.dev	UPDATE	PRODUCT	187	{"id": 187, "sku": "QA-QA-AUDIT-65212", "name": "پک تست ممیزی", "slug": "qa-audit-65212", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:12.087Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:12.089Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 187, "sku": "QA-QA-AUDIT-65212", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-65212", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:20:12.087Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:20:12.119Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-11 22:20:12.117783
31	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	187	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-11 22:20:12.155346
32	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "delivered", "paymentStatus": "paid"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-11 22:21:43.065098
33	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-11 22:21:43.079276
34	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-11 22:21:43.090574
35	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-11 22:21:43.101951
36	owner@helsa.dev	CREATE	PRODUCT	188	\N	{"id": 188, "sku": "QA-QA-AUDIT-65303", "name": "پک تست ممیزی", "slug": "qa-audit-65303", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:21:43.125Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:21:43.129Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-11 22:21:43.125257
37	owner@helsa.dev	UPDATE	PRODUCT	188	{"id": 188, "sku": "QA-QA-AUDIT-65303", "name": "پک تست ممیزی", "slug": "qa-audit-65303", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:21:43.125Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:21:43.129Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 188, "sku": "QA-QA-AUDIT-65303", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-65303", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-11T22:21:43.125Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-11T22:21:43.166Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-11 22:21:43.163923
38	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	188	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-11 22:21:43.214176
39	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	188	{"stock": 2}	{"stock": 32, "reason": "ورود کالا"}	2026-09-11 22:21:43.22609
40	owner@helsa.dev	STATUS_UPDATE	ORDER	6	{"status": "pending", "paymentStatus": "pending"}	{"status": "cancelled", "paymentStatus": "pending"}	2026-09-12 07:39:12.390224
41	owner@helsa.dev	STATUS_UPDATE	ORDER	5	{"status": "pending", "paymentStatus": "pending"}	{"status": "cancelled", "paymentStatus": "pending"}	2026-09-12 07:39:12.406572
42	owner@helsa.dev	STATUS_UPDATE	ORDER	4	{"status": "pending", "paymentStatus": "pending"}	{"status": "cancelled", "paymentStatus": "pending"}	2026-09-12 07:39:12.419513
43	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "delivered", "paymentStatus": "paid"}	{"status": "paid", "paymentStatus": "paid"}	2026-09-12 07:41:00.145044
44	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "paid", "paymentStatus": "paid"}	{"status": "preparing", "paymentStatus": "paid"}	2026-09-12 07:41:00.161466
45	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "preparing", "paymentStatus": "paid"}	{"status": "shipped", "paymentStatus": "paid"}	2026-09-12 07:41:00.170937
46	owner@helsa.dev	STATUS_UPDATE	ORDER	1	{"status": "shipped", "paymentStatus": "paid"}	{"status": "delivered", "paymentStatus": "paid"}	2026-09-12 07:41:00.18076
47	owner@helsa.dev	CREATE	PRODUCT	189	\N	{"id": 189, "sku": "QA-QA-AUDIT-98860", "name": "پک تست ممیزی", "slug": "qa-audit-98860", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-12T07:41:00.197Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-12T07:41:00.199Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	2026-09-12 07:41:00.197602
48	owner@helsa.dev	UPDATE	PRODUCT	189	{"id": 189, "sku": "QA-QA-AUDIT-98860", "name": "پک تست ممیزی", "slug": "qa-audit-98860", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 250000, "stock": 5, "origin": "", "rating": 0, "weight": "۵۰۰ گرم", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی هلسا", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-12T07:41:00.197Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-12T07:41:00.199Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت برای راستی‌آزمایی پنل مدیریت", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "محصول تست ممیزی کیفیت", "lowStockThreshold": 5}	{"id": 189, "sku": "QA-QA-AUDIT-98860", "name": "پک تست ممیزی (ویرایش)", "slug": "qa-audit-98860", "tags": [], "unit": "بسته", "badge": null, "brand": "هلسا ایرانیان", "image": "/images/opt/mazafati-dates.jpg", "price": 199000, "stock": 5, "origin": "", "rating": 0, "weight": "", "gallery": [], "reviews": 0, "storage": "", "category": "dates", "currency": "TOMAN", "discount": 0, "features": [], "imageAlt": "پک تست ممیزی ویرایش‌شده", "isActive": true, "oldPrice": null, "seoTitle": null, "allergens": [], "costPrice": null, "createdAt": "2026-09-12T07:41:00.197Z", "isVisible": true, "nutrition": [], "packaging": "", "updatedAt": "2026-09-12T07:41:00.228Z", "archivedAt": null, "categoryId": 1, "isFeatured": false, "description": "محصول تست ممیزی کیفیت نسخه ویرایش‌شده", "imageStatus": "admin_selected", "ingredients": "", "maxOrderQty": null, "minOrderQty": 1, "stockStatus": "low_stock", "seoDescription": null, "shortDescription": "", "lowStockThreshold": 5}	2026-09-12 07:41:00.226464
49	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	189	{"stock": 5}	{"stock": 2, "reason": "اصلاح موجودی"}	2026-09-12 07:41:00.296921
50	owner@helsa.dev	INVENTORY_UPDATE	PRODUCT	189	{"stock": 2}	{"stock": 32, "reason": "ورود کالا"}	2026-09-12 07:41:00.309258
\.


--
-- Data for Name: admin_notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_notifications (id, kind, title, body, href, is_read, created_at) FROM stdin;
\.


--
-- Data for Name: allergens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.allergens (id, label) FROM stdin;
1	مغزها
2	لبنیات
3	گلوتن
4	کنجد
5	سویا
6	تخم‌مرغ
\.


--
-- Data for Name: auth_challenges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_challenges (id, purpose, identifier, code_hash, attempts, max_attempts, expires_at, consumed_at, created_at) FROM stdin;
70	password_reset	ghost@nowhere.ir	33771e99d689eb84c8377168dea5ced315310aca89aa9d4cedff3ae188a79d9a	0	5	2026-09-16 14:20:49.26	\N	2026-09-16 14:10:49.261263
69	password_reset	zahra.qa@helsa-test.ir	7f401bbc4bf84a9b01e10aabc2fca0e0faa03b2d4c6819efbcabacd5bf66008b	1	5	2026-09-16 14:20:49.255	2026-09-16 14:10:50.471	2026-09-16 14:10:49.256426
71	password_reset	zahra.qa@helsa-test.ir	f16f7d07c03ed0bb20b3fc0b730bed1c72521debbb00c12bebe1a0ff915351dc	1	5	2026-09-16 14:20:50.471	2026-09-16 14:10:50.527	2026-09-16 14:10:50.472776
72	otp_login	09123334455	81d13edc1c1d1dc98094d6f0b160491370fa1b12ed5d7736ec831855459abc1b	1	5	2026-09-16 14:16:45.127	\N	2026-09-16 14:11:45.130293
\.


--
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.banners (id, title, subtitle, image, image_alt, href, placement, is_active, sort_order, starts_at, ends_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: beverage_pairings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.beverage_pairings (id, pair, drink, note) FROM stdin;
1	پنیر + انگور + گردو	چای سیاه لاهیجان	تعادل کلاسیک شور و شیرین
2	زیتون + پنیر	نان‌چوب و چای سبز	شروع سبک یک عصرانه
3	خرما + شکلات دست‌ساز	قهوه ترک	تلخی قهوه، شیرینی خرما
4	خرما مجول + قهوه	اسپرسو دوبل	پرطرفدارترین ترکیب هلسا
5	انجیر خشک + پنیر	موکتل انار و رزماری	برای مهمانی‌های شبانه
6	پسته + میوه خشک	دمنوش گل‌گاوزبان	آرام‌بخش و ایرانی
7	آجیل چهارمغز + برگه	آبمیوه انار طبیعی	انرژی عصر ورزش
8	سینی ایرانی + پنیر لیقوان	چای با نبات و عرق بیدمشک	نوستالژی سفره ایرانی
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campaigns (id, title, slug, banner, description, start_date, end_date, discount, category, active) FROM stdin;
1	جشنواره خرما	dates-festival	/images/opt/medjool-dates.jpg	طعم اصیل جنوب، در بسته‌بندی هلسا؛ تا ۲۵٪ تخفیف روی همه خرماهای منتخب امسال.	2025-09-01	2026-03-20	25	dates	t
2	جشنواره آجیل و خشکبار	nuts-festival	/images/opt/premium-mixed-nuts.jpg	انتخابی تازه برای لحظه‌های خاص؛ آجیل‌های بو داده هفته جاری و خشکبار سایه‌خشک.	2025-10-01	2026-02-28	20	nuts	t
3	جشنواره شب یلدا	yalda	/images/opt/dried-figs.jpg	یلدای هلسا؛ سینی‌های انار و هندوانه، آجیل ویژه یلدایی و بسته‌های هدیه شب چله.	2025-11-20	2026-01-01	30	all	t
4	جشنواره نوروز	norooz	/images/opt/party-nuts.jpg	پذیرایی نوروزی با آجیل چهارمغز، شیرینی خرما و سینی‌های مزه بهاری هلسا.	2026-02-20	2026-04-05	22	nuts	t
5	جشنواره رمضان	ramadan	/images/opt/herbal-tea-borage.jpg	سفره افطار تا سحر؛ خرما مضافتی، زولبیا و بامیه طبیعی، شیره و دمنوش‌های آرام‌بخش.	2026-02-10	2026-03-25	18	dates	t
6	جشنواره محصولات طبیعی	natural-festival	/images/opt/natural-gon-honey.jpg	عسل با آنالیز، زعفران نگین و ارده سنگی؛ هفته محصولات طبیعی هلسا.	2025-08-01	2026-06-01	15	natural	t
7	پیشنهادهای مناسبتی هدیه	gifts	/images/opt/date-chocolate-walnut.jpg	جعبه‌های هدیه هلسا برای تولد، سالگرد و تقدیر سازمانی؛ با کارت پیام شخصی‌سازی‌شده.	2025-01-01	2026-12-30	12	date-products	t
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, slug, description, short_description, image, image_alt, icon, subs, sort_order, is_active, seo_title, seo_description, created_at, updated_at) FROM stdin;
2	فرآورده‌های خرما	date-products	شکلات دست‌ساز خرما، قند خرما، شیره و پودر خرما با دستور انحصاری هلسا		/images/opt/handmade-date-chocolate.jpg		chocolate	["شکلات خرمایی", "شکلات دست‌ساز خرما", "قند خرما", "شیره خرما", "پودر خرما"]	2	t	\N	\N	2026-09-11 22:07:56.872142	2026-09-11 22:07:56.872142
3	آجیل	nuts	آجیل ممتاز، چهارمغز، پذیرایی و تک‌مغزهای تازه از باغ‌های ایران		/images/opt/premium-mixed-nuts.jpg		nut	["آجیل ممتاز", "آجیل چهارمغز", "آجیل پذیرایی", "آجیل اقتصادی", "آجیل ویژه"]	3	t	\N	\N	2026-09-11 22:07:56.872142	2026-09-11 22:07:56.872142
4	خشکبار	dried-fruits	کشمش، انجیر خشک، توت خشک، برگه زردآلو و میوه خشک با خشک‌کردن طبیعی		/images/opt/dried-figs.jpg		fig	["کشمش", "انجیر خشک", "توت خشک", "برگه زردآلو", "آلو خشک", "میوه خشک"]	4	t	\N	\N	2026-09-11 22:07:56.872142	2026-09-11 22:07:56.872142
5	محصولات طبیعی	natural	عسل، زعفران، ارده، شیره‌ها، چای، دمنوش، عرقیات و ادویه‌های اصیل		/images/opt/natural-gon-honey.jpg		honey	["عسل", "زعفران", "ارده", "شیره‌ها", "چای", "دمنوش", "عرقیات", "ادویه"]	5	t	\N	\N	2026-09-11 22:07:56.872142	2026-09-11 22:07:56.872142
9	عسل	honey	عسل‌های منتخب با تمرکز بر مبدأ، طعم و بافت	عسل‌های منتخب با تمرکز بر مبدأ، طعم و بافت	/images/opt/natural-gon-honey.jpg	تصویر دسته عسل هلسا	leaf	["کنار", "بهارنارنج", "کوهستان"]	23	t	عسل هلسا | خرید آنلاین	عسل‌های منتخب با تمرکز بر مبدأ، طعم و بافت. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.081603	2026-09-13 10:32:57.143
16	شکلات	chocolate	شکلات تلخ، شیری، مغزدار و پذیرایی	شکلات تلخ، شیری، مغزدار و پذیرایی	/images/chocolate-craft.jpg	تصویر دسته شکلات هلسا	leaf	["تلخ", "شیری", "مغزدار", "دست‌ساز"]	30	t	شکلات هلسا | خرید آنلاین	شکلات تلخ، شیری، مغزدار و پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.097446	2026-09-13 10:32:57.153
24	بیسکویت و کیک ویژه هلسا	biscuits-cakes	بیسکویت، کیک خرمایی و شیرینی خشک پذیرایی	بیسکویت، کیک خرمایی و شیرینی خشک پذیرایی	/images/chocolate-craft.jpg	تصویر دسته بیسکویت و کیک ویژه هلسا هلسا	leaf	["بیسکویت", "کیک خرمایی", "شیرینی خشک"]	38	t	بیسکویت و کیک ویژه هلسا هلسا | خرید آنلاین	بیسکویت، کیک خرمایی و شیرینی خشک پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.122869	2026-09-13 10:32:57.164
6	آجیل و خشکبار	nuts-dried-fruits	آجیل‌های مخلوط و خشکبار منتخب هلسا برای پذیرایی و مصرف روزانه	آجیل‌های مخلوط و خشکبار منتخب هلسا برای پذیرایی و مصرف روزانه	/images/opt/premium-mixed-nuts.jpg	تصویر دسته آجیل و خشکبار هلسا	leaf	["آجیل مخلوط", "چهارمغز", "آجیل مهمانی", "خشکبار"]	20	t	آجیل و خشکبار هلسا | خرید آنلاین	آجیل‌های مخلوط و خشکبار منتخب هلسا برای پذیرایی و مصرف روزانه. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.073572	2026-09-13 10:32:57.132
17	پک‌های ویژه هلسا	special-packs	پک‌های هدیه و پذیرایی برای مناسبت‌ها	پک‌های هدیه و پذیرایی برای مناسبت‌ها	/images/tray-vip.jpg	تصویر دسته پک‌های ویژه هلسا هلسا	leaf	["هدیه", "پذیرایی", "صبحانه", "نوروز", "یلدا", "سازمانی"]	31	t	پک‌های ویژه هلسا هلسا | خرید آنلاین	پک‌های هدیه و پذیرایی برای مناسبت‌ها. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.099543	2026-09-13 10:32:57.154
64	کیک و دسر	cakes-desserts	کیک تیرامیسو، چیزکیک، موس و شیرینی‌های تازه هلسا	کیک تیرامیسو، چیزکیک، موس و شیرینی‌های تازه هلسا	/images/opt/tiramisu-cake.jpg	تصویر دسته کیک و دسر هلسا	leaf	["تیرامیسو", "چیزکیک", "موس", "رولت", "براونی", "پاناکوتا"]	49	t	کیک و دسر هلسا | خرید آنلاین	کیک تیرامیسو، چیزکیک، موس و شیرینی‌های تازه هلسا. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-13 10:32:57.177975	2026-09-13 10:32:57.177
65	مربا	jams	مرباهای سنتی ایرانی با بستهٔ شیشه‌ای هلسا	مرباهای سنتی ایرانی با بستهٔ شیشه‌ای هلسا	/images/opt/quince-jam.jpg	تصویر دسته مربا هلسا	leaf	["به", "هویج", "بالنگ", "آلبالو", "هندونه", "گل محمدی"]	50	t	مربا هلسا | خرید آنلاین	مرباهای سنتی ایرانی با بستهٔ شیشه‌ای هلسا. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-13 10:32:57.179453	2026-09-13 10:32:57.178
13	آبنبات	candy	آبنبات پذیرایی با طعم‌های منتخب	آبنبات پذیرایی با طعم‌های منتخب	/images/opt/candy.jpg	تصویر دسته آبنبات هلسا	leaf	["ساده", "زعفرانی", "میوه‌ای", "مغزدار"]	27	t	آبنبات هلسا | خرید آنلاین	آبنبات پذیرایی با طعم‌های منتخب. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.09111	2026-09-13 10:32:57.149
14	ادویه	spices	ادویه‌های خالص و ترکیبی مناسب آشپزی ایرانی	ادویه‌های خالص و ترکیبی مناسب آشپزی ایرانی	/images/opt/spice-blend.jpg	تصویر دسته ادویه هلسا	leaf	["پلویی", "خورشتی", "مرغ", "گوشت", "فلفل", "دارچین"]	28	t	ادویه هلسا | خرید آنلاین	ادویه‌های خالص و ترکیبی مناسب آشپزی ایرانی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.093115	2026-09-13 10:32:57.15
25	ارده	tahini	ارده کنجد با بافت روان و بسته‌بندی شیشه‌ای	ارده کنجد با بافت روان و بسته‌بندی شیشه‌ای	/images/opt/tahini.jpg	تصویر دسته ارده هلسا	leaf	["سنتی", "کنجد"]	39	t	ارده هلسا | خرید آنلاین	ارده کنجد با بافت روان و بسته‌بندی شیشه‌ای. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.126873	2026-09-13 10:32:57.165
12	بادام زمینی	peanuts	بادام زمینی خام، شور و بوداده	بادام زمینی خام، شور و بوداده	/images/opt/peanuts-roasted.jpg	تصویر دسته بادام زمینی هلسا	leaf	["خام", "شور", "بوداده"]	26	t	بادام زمینی هلسا | خرید آنلاین	بادام زمینی خام، شور و بوداده. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.089132	2026-09-13 10:32:57.147
33	بار خرما	date-bars	بار خرما و مغزها برای میان‌وعده	بار خرما و مغزها برای میان‌وعده	/images/opt/date-bar.jpg	تصویر دسته بار خرما هلسا	leaf	["مغزها", "کنجد", "شکلات"]	47	t	بار خرما هلسا | خرید آنلاین	بار خرما و مغزها برای میان‌وعده. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.143448	2026-09-13 10:32:57.174
34	بار کنجد	sesame-bars	بار کنجد ساده و ترکیبی	بار کنجد ساده و ترکیبی	/images/opt/sesame-bar.jpg	تصویر دسته بار کنجد هلسا	leaf	["خرما", "مغزها"]	48	t	بار کنجد هلسا | خرید آنلاین	بار کنجد ساده و ترکیبی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.145036	2026-09-13 10:32:57.176
7	تخمه	seeds	تخمه‌های خام، شور، بوداده و طعم‌دار هلسا	تخمه‌های خام، شور، بوداده و طعم‌دار هلسا	/images/opt/sunflower-seeds.jpg	تصویر دسته تخمه هلسا	leaf	["کدو", "آفتابگردان", "ژاپنی", "هندوانه"]	21	t	تخمه هلسا | خرید آنلاین	تخمه‌های خام، شور، بوداده و طعم‌دار هلسا. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.077259	2026-09-13 10:32:57.139
23	ترشیجات	pickles	ترشی‌های ایرانی مناسب سفره و سینی مزه	ترشی‌های ایرانی مناسب سفره و سینی مزه	/images/opt/pickles.jpg	تصویر دسته ترشیجات هلسا	leaf	["مخلوط", "لیته", "سیر"]	37	t	ترشیجات هلسا | خرید آنلاین	ترشی‌های ایرانی مناسب سفره و سینی مزه. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.121134	2026-09-13 10:32:57.162
11	زرشک	barberry	زرشک پفکی و دانه‌اناری منتخب	زرشک پفکی و دانه‌اناری منتخب	/images/opt/barberry.jpg	تصویر دسته زرشک هلسا	leaf	["پفکی", "دانه‌اناری"]	25	t	زرشک هلسا | خرید آنلاین	زرشک پفکی و دانه‌اناری منتخب. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.085561	2026-09-13 10:32:57.146
22	زیتون	olives	زیتون سبز، سیاه، بدون هسته و پرورده	زیتون سبز، سیاه، بدون هسته و پرورده	/images/opt/olives-green.jpg	تصویر دسته زیتون هلسا	leaf	["سبز", "سیاه", "بدون هسته", "پرورده"]	36	t	زیتون هلسا | خرید آنلاین	زیتون سبز، سیاه، بدون هسته و پرورده. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.119451	2026-09-13 10:32:57.161
26	حلوا ارده	halva-tahini	حلوا ارده ساده و پسته‌ای برای صبحانه	حلوا ارده ساده و پسته‌ای برای صبحانه	/images/opt/halva-arde.jpg	تصویر دسته حلوا ارده هلسا	leaf	["ساده", "پسته‌ای"]	40	t	حلوا ارده هلسا | خرید آنلاین	حلوا ارده ساده و پسته‌ای برای صبحانه. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.129157	2026-09-13 10:32:57.166
21	پنیر	cheese	پنیرهای مناسب صبحانه و سینی پذیرایی	پنیرهای مناسب صبحانه و سینی پذیرایی	/images/opt/cheese.jpg	تصویر دسته پنیر هلسا	leaf	["پذیرایی", "سنتی"]	35	t	پنیر هلسا | خرید آنلاین	پنیرهای مناسب صبحانه و سینی پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.117915	2026-09-13 10:32:57.159
31	قند خرما	date-sugar	قند خرما برای نوشیدنی و پذیرایی	قند خرما برای نوشیدنی و پذیرایی	/images/opt/date-sugar.jpg	تصویر دسته قند خرما هلسا	leaf	["قند خرما"]	45	t	قند خرما هلسا | خرید آنلاین	قند خرما برای نوشیدنی و پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.139252	2026-09-13 10:32:57.172
10	نبات	rock-candy	نبات ساده و زعفرانی برای چای و پذیرایی	نبات ساده و زعفرانی برای چای و پذیرایی	/images/opt/rock-candy.jpg	تصویر دسته نبات هلسا	leaf	["ساده", "زعفرانی", "چوبی", "شاخه‌ای"]	24	t	نبات هلسا | خرید آنلاین	نبات ساده و زعفرانی برای چای و پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.083528	2026-09-13 10:32:57.144
18	نقل	noghl	نقل ساده، زعفرانی، بیدمشکی و مغزدار	نقل ساده، زعفرانی، بیدمشکی و مغزدار	/images/opt/noghl.jpg	تصویر دسته نقل هلسا	leaf	["ساده", "زعفرانی", "بیدمشکی", "مغزدار"]	32	t	نقل هلسا | خرید آنلاین	نقل ساده، زعفرانی، بیدمشکی و مغزدار. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.101486	2026-09-13 10:32:57.156
15	عرقیات	distillates	عرقیات سنتی با توضیح طعم و شیوه مصرف	عرقیات سنتی با توضیح طعم و شیوه مصرف	/images/opt/distillate.jpg	تصویر دسته عرقیات هلسا	leaf	["نعناع", "کاسنی", "بهارنارنج", "گل محمدی", "بیدمشک"]	29	t	عرقیات هلسا | خرید آنلاین	عرقیات سنتی با توضیح طعم و شیوه مصرف. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.095177	2026-09-13 10:32:57.152
30	گل محمدی	rosebuds	غنچه و گل محمدی خشک مناسب چای و تزئین	غنچه و گل محمدی خشک مناسب چای و تزئین	/images/opt/rosebuds.jpg	تصویر دسته گل محمدی هلسا	leaf	["غنچه", "گل خشک"]	44	t	گل محمدی هلسا | خرید آنلاین	غنچه و گل محمدی خشک مناسب چای و تزئین. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.137381	2026-09-13 10:32:57.171
19	شیره	syrups	شیره خرما، انگور و توت برای صبحانه و آشپزی	شیره خرما، انگور و توت برای صبحانه و آشپزی	/images/opt/date-syrup.jpg	تصویر دسته شیره هلسا	leaf	["خرما", "انگور", "توت"]	33	t	شیره هلسا | خرید آنلاین	شیره خرما، انگور و توت برای صبحانه و آشپزی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.10964	2026-09-13 10:32:57.157
29	روغن	oils	روغن زیتون و کنجد برای مصرف خوراکی	روغن زیتون و کنجد برای مصرف خوراکی	/images/opt/olive-oil.jpg	تصویر دسته روغن هلسا	leaf	["زیتون", "کنجد"]	43	t	روغن هلسا | خرید آنلاین	روغن زیتون و کنجد برای مصرف خوراکی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.135496	2026-09-13 10:32:57.17
20	حبوبات	legumes	حبوبات پاک‌شده و بسته‌بندی‌شده هلسا	حبوبات پاک‌شده و بسته‌بندی‌شده هلسا	/images/opt/legumes.jpg	تصویر دسته حبوبات هلسا	leaf	["عدس", "نخود", "لوبیا", "لپه", "ماش"]	34	t	حبوبات هلسا | خرید آنلاین	حبوبات پاک‌شده و بسته‌بندی‌شده هلسا. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.116143	2026-09-13 10:32:57.158
1	خرما	dates	خرمای اصیل ایرانی با بسته‌بندی مناسب پذیرایی	خرمای اصیل ایرانی با بسته‌بندی مناسب پذیرایی	/images/opt/mazafati-premium.jpg	تصویر دسته خرما هلسا	palm	["پیارم", "مضافتی", "کبکاب", "زاهدی", "خاصویی", "مجول"]	1	t	خرما هلسا | خرید آنلاین	خرمای اصیل ایرانی با بسته‌بندی مناسب پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:56.872142	2026-09-13 10:32:57.141
27	دمنوش‌های ویژه هلسا	herbal-tea	دمنوش‌های گل، میوه و ترکیبی برای پذیرایی	دمنوش‌های گل، میوه و ترکیبی برای پذیرایی	/images/opt/herbal-tea.jpg	تصویر دسته دمنوش‌های ویژه هلسا هلسا	leaf	["گل محمدی", "بهارنارنج", "میوه‌ای", "ترکیبی"]	41	t	دمنوش‌های ویژه هلسا هلسا | خرید آنلاین	دمنوش‌های گل، میوه و ترکیبی برای پذیرایی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.131605	2026-09-13 10:32:57.167
32	شکلات خرما	date-chocolate	شکلات خرمایی ساده، مغزدار، نارگیلی و کنجدی	شکلات خرمایی ساده، مغزدار، نارگیلی و کنجدی	/images/opt/date-chocolate.jpg	تصویر دسته شکلات خرما هلسا	leaf	["ساده", "مغزدار", "نارگیلی", "کنجدی"]	46	t	شکلات خرما هلسا | خرید آنلاین	شکلات خرمایی ساده، مغزدار، نارگیلی و کنجدی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.142023	2026-09-13 10:32:57.173
28	کره بادام زمینی	peanut-butter	کره بادام زمینی ساده، کرانچی و شکلاتی	کره بادام زمینی ساده، کرانچی و شکلاتی	/images/opt/peanut-butter.jpg	تصویر دسته کره بادام زمینی هلسا	leaf	["ساده", "کرانچی", "شکلاتی"]	42	t	کره بادام زمینی هلسا | خرید آنلاین	کره بادام زمینی ساده، کرانچی و شکلاتی. مشاهده محصولات، قیمت و موجودی به‌روز در هلسا مارکت.	2026-09-11 22:07:58.13381	2026-09-13 10:32:57.168
\.


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contact_messages (id, name, mobile, email, subject, message, created_at) FROM stdin;
1	عضو خبرنامه (صفحهٔ اصلی)	09121234567		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09121234567	2026-09-14 09:14:19.893446
2	عضو خبرنامه (صفحهٔ اصلی)		buyer-1789379051394@helsa.ir	عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: buyer-1789379051394@helsa.ir | موبایل: —	2026-09-14 09:44:11.505726
3	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 06:23:06.436236
4	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 06:34:13.27395
5	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 06:37:50.065519
6	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 06:47:17.054796
7	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 06:52:55.868608
8	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 15:39:46.576719
9	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 15:40:25.652866
10	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 16:12:45.026825
11	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 17:16:08.104147
12	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 18:26:36.554446
13	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-15 18:27:48.584207
14	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 07:36:22.439142
15	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 09:07:23.385798
16	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 09:43:28.564819
17	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 10:02:20.095615
18	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 10:04:56.417926
19	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 10:22:13.591897
20	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 10:42:28.922616
21	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 11:10:19.236658
22	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 11:19:06.245258
23	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 13:01:48.471656
24	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 13:38:30.035089
25	عضو خبرنامه (صفحهٔ اصلی)	09125556677		عضویت در خبرنامهٔ هلسا + کوپن اولین خرید	عضویت در خبرنامه از فرم صفحهٔ اصلی — ایمیل: — | موبایل: 09125556677	2026-09-16 14:09:35.876303
\.


--
-- Data for Name: corporate_gift_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.corporate_gift_requests (id, code, company_name, contact_name, mobile, email, package_slug, quantity, occasion, desired_delivery_date, branding_requirements, packaging_notes, recipient_notes, additional_notes, indicative_total, status, created_at, updated_at) FROM stdin;
1	CGR-65156390	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-11 22:19:16.391412	2026-09-11 22:19:16.39
2	CGR-65198241	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-11 22:19:58.242651	2026-09-11 22:19:58.242
3	CGR-65211631	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-11 22:20:11.63152	2026-09-11 22:20:11.631
4	CGR-65212199	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-11 22:20:12.200089	2026-09-11 22:20:12.199
5	CGR-65303277	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-11 22:21:43.278054	2026-09-11 22:21:43.277
6	CGR-98860360	شرکت تست ممیزی	مدیر خرید	09127770011	corp@test.ir	corporate-staff-gift	120	سال نو	۱۴۰۵/۰۷/۰۱	لوگو روی جعبه				93600000	new	2026-09-12 07:41:00.361125	2026-09-12 07:41:00.36
\.


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.coupons (code, type, value, minimum_purchase, maximum_discount, start_date, end_date, usage_limit, used_count, product_ids, category_slugs, active, label) FROM stdin;
MAZEH15	percent	15	2000000	900000	2025-06-01	2026-12-30	500	0	[]	[]	t	۱۵٪ تخفیف سینی‌های مزه
YALDA20	percent	20	3000000	1200000	2025-11-15	2026-01-05	300	0	[]	[]	t	۲۰٪ تخفیف جشنواره یلدا
SEFID100	fixed	100000	1000000	\N	2025-01-01	2026-12-30	800	0	[]	[]	t	۱۰ هزار تومان تخفیف مستقیم
WELCOME-UAMA	fixed	200000	1000000	\N	2026-09-14	2026-10-14	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-QYF2	fixed	200000	1000000	\N	2026-09-14	2026-10-14	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-X7CD	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-P97P	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-7Q7C	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-2BGX	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-R8A7	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-9LS7	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-MBFE	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-722A	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-87AE	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-64GU	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-UC7V	fixed	200000	1000000	\N	2026-09-15	2026-10-15	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-9WS7	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-QEYG	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-HM2Y	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-PAY7	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-UBLK	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-FQG7	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-YG3U	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-2HTJ	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-XZ6V	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-93SM	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
WELCOME-9M9Y	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
HELSA10	percent	10	0	500000	2025-01-01	2026-12-30	1000	18	[]	[]	t	۱۰٪ تخفیف برای اولین خرید
WELCOME-393E	fixed	200000	1000000	\N	2026-09-16	2026-10-16	1	0	[]	[]	t	هدیهٔ اولین خرید — ویژهٔ خبرنامهٔ هلسا
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customers (id, name, phone, email, password_hash, password_updated_at, is_active, created_at, updated_at, national_id, nid_verified_at, identity_provider) FROM stdin;
4	رضا کافه‌دار	09124445156	demo5156.cafe@helsa-test.ir	scrypt$b6bfdcf35b43685a76722b7a11b75dc7$97bd2dc48643b72b9495bfa6ab79742e3a30a76bff31619465fbfb24e4066d6565e1d675825225fdf498aa40bbb7d607e108bd26bd2c3a37742843d74112b3ee	\N	t	2026-09-11 22:19:16.471305	2026-09-11 22:19:16.47	\N	\N	\N
5	رضا کافه‌دار	09124445198	demo5198.cafe@helsa-test.ir	scrypt$b2984261b961105f0a4539c67296abb9$5b0abdb611e65d3ea011b7ee283476b6da67e3e26a3e27ec759fe065d8dbb1f9c463bd86e6dd28bf9addc351e81983e8cc80b97ff44646240d76e64ea076cb48	\N	t	2026-09-11 22:19:58.302126	2026-09-11 22:19:58.301	\N	\N	\N
6	رضا کافه‌دار	09124445211	demo5211.cafe@helsa-test.ir	scrypt$95539901c1274ec98b5bf503afc43bcf$015ba4b678ce2fabb77497d3e0dec4444ff1dd9ed918e285fcbb880204be6ca5d620710ed3236b8fa2e22fa11fe44c5ad858722cf2bf626af2499011d8daa74e	\N	t	2026-09-11 22:20:11.692625	2026-09-11 22:20:11.691	\N	\N	\N
7	رضا کافه‌دار	09124445212	demo5212.cafe@helsa-test.ir	scrypt$6ccc982b4eb9c81de3e10f87acebab08$9811df13c6139999fdfac2c8819889ed9afdb5220caab8a298906209aa5a37de7f585bb7f0dea80594274b1984e8e073f41c83e2f2bbcfecb8edc06b0230dec2	\N	t	2026-09-11 22:20:12.253966	2026-09-11 22:20:12.253	\N	\N	\N
8	رضا کافه‌دار	09124445303	demo5303.cafe@helsa-test.ir	scrypt$d628cd3af0e2bfe5e59bc81547b67538$44113b9cd00854eb155f6a6d30e4c4d6a60b76f59c2af3ef369e40df63a3991a996032aca5d4751a15d24d19668248b83d4ff9480c0e66bf9f681a82798afb8c	\N	t	2026-09-11 22:21:43.340217	2026-09-11 22:21:43.339	\N	\N	\N
9	سارا تستی	09129631404	ui-6631404@helsa-test.ir	scrypt$45c3182f72277beac087c53e13856be5$154b49bc905fad98ed0e7cf121c1f79a07a86e2ac671ff5fb1d0a7526455a5f87c4df95519ba4adfc82892434419f6a7dcca7d1241cafcc2022a3a1fa91116ad	\N	t	2026-09-11 22:43:55.557454	2026-09-11 22:43:55.556	\N	\N	\N
10	سارا تستی	09129896265	ui-6896265@helsa-test.ir	scrypt$94d3b1bd0e584d5b54061d3590ddcfd6$0afdda72317bf206e40ea62416ccefee35424417eb3d97a6dc8cc832fb66d7eb951ed17149e7cc921a7d4a471de2e165cd4b8456d0f248ecded161241542a15f	\N	t	2026-09-11 22:48:20.827568	2026-09-11 22:49:17.163	\N	\N	\N
12	پرداخت تستی	09123308583	psp-98583@helsa-test.ir	scrypt$2ed9c7e11cbd84e0d2c8cd2f011e009a$4ce0978b2f20aa0cdf5fe884ffd9b9714af821b1469984e420a3b8a9207549bd90089e69e7adbec674875e8c105c242bcffe625f956c188b23e3054874fd1fcd	\N	t	2026-09-12 07:36:23.958466	2026-09-12 07:36:24.058	\N	\N	\N
14	پرداخت تستی	09123308603	psp-98603@helsa-test.ir	scrypt$41dd57e842c164f1bf84561c63c9f037$042e99eaba543553b642ab6a26c1450f614afa7bfb45e709313a7d877356b94c0d86e4936f3ca09bb71d518a9d2ef72bf0d8d201876fafbc522cfd501da8b950	\N	t	2026-09-12 07:36:43.14729	2026-09-12 07:37:04.34	\N	\N	\N
17	پرداخت تستی	09123308683	psp-98683@helsa-test.ir	scrypt$1b8325cbab268c6ac8f783fd15592d06$cefbb870676c1156383f892496f4f7a19293e3c1b5b76b8f537e24499d59cd8e22b0f0a452bbe6a1a0392f15e02140e755c28e5333377eb875622dd77b9430d4	\N	t	2026-09-12 07:38:03.094792	2026-09-12 07:38:03.148	\N	\N	\N
19	پرداخت تستی	09123308769	psp-98769@helsa-test.ir	scrypt$f9533bee3ad449624ff65ed313f810b1$d0dc24f7dfce1658aa1c2475f93bc39fc818536e4c471c623d0a75e6938d0c10382677f02721ac62101af53482b2dd0ba8b5761dbe344cb85a6b2be4a1207e68	\N	t	2026-09-12 07:39:29.190922	2026-09-12 07:39:29.267	\N	\N	\N
21	سارا تستی	09121770849	ui-8770849@helsa-test.ir	scrypt$f053533e6a2f8d17be57ee180c7e61f8$f55742e8255673e0ec269acd9d111a8d54d355ff56cf3bf272a5e0d5a17437460a6e5d9bef616f980c3a94c0dfc51ebeda664b43ffbe04b8de854e0a45dd86f1	\N	t	2026-09-12 07:39:36.451857	2026-09-12 07:40:33.028	\N	\N	\N
23	رضا کافه‌دار	09124448860	demo8860.cafe@helsa-test.ir	scrypt$09185307f882f9e846615c89e27c5083$7e42ba7f4429977e31cd5a7267f61077dbc357b34757e16403308c88d834d3d239024f066bee9c7f075ace503294eb12918f00457244965a23fc76c4ec403d0f	\N	t	2026-09-12 07:41:00.436694	2026-09-12 07:41:00.436	\N	\N	\N
29	ممیز تست	09128263732	audit-826373203@test.local	scrypt$0a922bc9bf7a9e97920afa8b1fb2f9dc$800fb964be03b38ac1e96b1c0aab5864821033a65352cc2f35890b5395bc34e9613b27567e2236f53091afcf29a455e8028ead203b953861c2aafcd46257cb44	\N	t	2026-09-15 15:17:35.83845	2026-09-15 15:17:35.837	\N	\N	\N
30	ممیز تست	09122401213	audit-240121384@test.local	scrypt$256af391e60f126def343841aeac9c01$2efb9a99949a2f58b9ba153a0fab3f94a83ee299d153d6c77fc5cdb1f0a319e4655b27cbf0126725bff75df3b6554f9981a5543a0635ead0a7650178ea99972c	\N	t	2026-09-15 15:18:41.561737	2026-09-15 15:19:12.182	0012345679	2026-09-15 15:19:12.182	checkout
34	مهمان تستی	09124315224	\N	\N	\N	t	2026-09-15 17:15:38.994911	2026-09-15 17:15:39	0012345679	2026-09-15 17:15:39	checkout
1	مدیر هلسا	09126667788	owner@helsa.dev	scrypt$32c79051df5443cd095c0a58d15a7507$ecae3526d77b000ffae196458c26151d8b08ec5027957b9268d73550d048065ddbeb3da2c2049d64a36c693988e08c4d9269e149face16570cbd4a2ec92c1cb6	\N	t	2026-09-11 22:19:15.861857	2026-09-11 22:19:15.86	\N	\N	\N
36	مهمان تستی	09124805726	\N	\N	\N	t	2026-09-15 18:25:48.567534	2026-09-15 18:25:48.577	0012345679	2026-09-15 18:25:48.577	checkout
38	مهمان تستی	09124754798	\N	\N	\N	t	2026-09-16 07:37:41.132395	2026-09-16 07:37:41.146	0012345679	2026-09-16 07:37:41.146	checkout
42	مهمان تستی	09121623130	\N	\N	\N	t	2026-09-16 09:44:07.618748	2026-09-16 09:44:07.622	0012345679	2026-09-16 09:44:07.622	checkout
40	مهمان تستی	09121807183	\N	\N	\N	t	2026-09-16 09:08:49.205354	2026-09-16 09:08:49.214	0012345679	2026-09-16 09:08:49.214	checkout
51	آزمون فرم	09135557799	helsa-qa-debug-2@example.com	scrypt$fc09b8671684f3fb748014875917c021$72946c4e99fcc08792263c0c10f27c6231a49d5185843af8095e217534a95eb4eb1ce548d58b66518ea35ad62a9590d5cda1a2ef05948f51e9bea4354a8a5cc8	\N	t	2026-09-16 11:04:18.035802	2026-09-16 11:04:18.034	\N	\N	\N
52	آزمون فرم	09125969168	helsa-qa-form-5969168@example.com	scrypt$1e218a335ac9e30998e10f19ad67517c$c108a6427876fe7fbd1c2280adc03efbe2799836c8c3f1929159df6dda67196ac3535509b57b63e3d51e30c0b14b0775486201df11b60a168b53e3ad28913629	\N	t	2026-09-16 11:05:03.720566	2026-09-16 11:05:03.719	\N	\N	\N
43	مهمان تستی	09124213312	\N	\N	\N	t	2026-09-16 10:01:46.624539	2026-09-16 10:01:46.631	0012345679	2026-09-16 10:01:46.631	checkout
48	مهمان تستی	09127995594	\N	\N	\N	t	2026-09-16 10:43:50.221563	2026-09-16 10:43:50.226	0012345679	2026-09-16 10:43:50.226	checkout
49	آزمون فرم	09122072173	helsa-qa-form-2072173@example.com	scrypt$f5a3cb248856e3ddc7b77ca544f18473$dec3ea64bad79edf5b5e69c2b67c9f89414440eafa5455948f53885b0746fae1ef0e066618940ec639b7041768118c32bab8c86766a8e5712d8b813c8072144b	\N	t	2026-09-16 11:03:23.84578	2026-09-16 11:03:23.842	\N	\N	\N
50	آزمون فرم	09129998877	helsa-qa-debug-1@example.com	scrypt$12af7b6d833ff3c0348bb3fd320aad7c$c86d64460e5ecc05f7eaecd8eade45b842267c36abb5030533756e7b242e30d121a7bb233f5b0f0d9e8acdd9185944b7e25d58197b4e4d46738f23768c001cd1	\N	t	2026-09-16 11:03:48.025244	2026-09-16 11:03:48.024	\N	\N	\N
53	آزمون فرم	09122687167	helsa-qa-form-2687167@example.com	scrypt$7b743c1e0a555f570a374e5d082be787$ebc2044d1e88c92b8064e049fa4eba5fa1ccdb7aba66d485d38f3b49d8b34e0b4ee5e6431a36d623172ecb12a3596e204bb9208b28801d7061d9be4d61d21f96	\N	t	2026-09-16 11:05:55.040107	2026-09-16 11:05:55.039	\N	\N	\N
55	رضا کافه‌دار	09124446767	demo6767.cafe@helsa-test.ir	scrypt$e6b320c50435942feebb6eb3416bb47e$ab845d2f220497ead837dabd64972aae5838a6e232f9691034384a68897be7f73b1eca18164fdfaac7d50090b6ceb1b6a953e4e4b9ba009f8ee332a505deaa6a	\N	t	2026-09-16 11:06:07.686199	2026-09-16 11:06:07.682	\N	\N	\N
56	رضا کافه‌دار	09124446855	demo6855.cafe@helsa-test.ir	scrypt$8d877a3e1f439346368e2fe29f46597a$67e2bdfd9da829bd86b20654325eeb46d30bfeaa6e2b2863f81e11596db08cfd8a2edb611b8397710d9771c76ed19303121f278b38197ac10bdd35eeca884842	\N	t	2026-09-16 11:07:36.066007	2026-09-16 11:07:36.065	\N	\N	\N
58	رضا کافه‌دار	09124446881	demo6881.cafe@helsa-test.ir	scrypt$651a3dcfa026f1bf671544b40fac535d$bc8e51c4d6a31782b3f2313d2b22345176e6b82d5f006ecfd9d2c77459c4ddf5786dfe2366ff6985d74cfcf8730afb19075f50f3edbb92847bce16f62ee66f7e	\N	t	2026-09-16 11:08:01.230304	2026-09-16 11:08:01.229	\N	\N	\N
60	رضا کافه‌دار	09124446915	demo6915.cafe@helsa-test.ir	scrypt$a603f31c719707caf370430a89549c86$25d91cc84daea27f349dc9fa5008938ed458ca657b976906b82c03c0e73a543b71fa4b800b692f4be3de866803db42247e69871de22bbb65099d69ba02e1e14e	\N	t	2026-09-16 11:08:35.235605	2026-09-16 11:08:35.234	\N	\N	\N
61	آزمون فرم	09124193274	helsa-qa-form-4193274@example.com	scrypt$df7591b8080fc318647dc7a52857cdf7$8afdc3a76276a1947a1785b403f59884db5c995439058c4a5354fe1ab640d69ac7d3b401027842a4df9e8e3bb5e1461750366f37e9d2402d22f9323de521d1fc	\N	t	2026-09-16 11:08:49.43298	2026-09-16 11:08:49.432	\N	\N	\N
62	مهمان تستی	09125202525	\N	\N	\N	t	2026-09-16 11:09:42.789365	2026-09-16 11:09:42.8	0012345679	2026-09-16 11:09:42.8	checkout
65	آزمون فرم	09125381914	helsa-qa-form-5381914@example.com	scrypt$08c5fe6fa17f9d0bada0a096c1686b9e$75789cb6178c35c20589482fe1318ce89f867b6b0d5ca702f7aaff4f1dadc9bca34da4187434a51d25fbd0676858cf739f751f4703694935bcb56087b44897dc	\N	t	2026-09-16 12:34:15.401995	2026-09-16 12:34:15.395	\N	\N	\N
66	آزمون فرم	09126379538	helsa-qa-form-6379538@example.com	scrypt$ecb1240dc5587210e0036d136c45ea6a$ff2f849564c5533d9959078a109c2baa823865d21e8c2128d8369f9573aafc153713438550032fd706ef312f77eec5288fd284474dd6ed8c556af59ac8bef44d	\N	t	2026-09-16 12:53:04.557074	2026-09-16 12:53:04.553	\N	\N	\N
67	آزمون فرم	09127901083	helsa-qa-form-7901083@example.com	scrypt$5b3e42e3325fea28b5cec284bc92b266$25c8ecd000a8a3fa05a6d2b3b73d597454a609ea64387d6d7ea83d14a3bc208b7ac6993cf4eab0ab6c7c6ade9a3bef1783085198b0f5f1b8ff51f2b29e928f8b	\N	t	2026-09-16 12:53:56.203625	2026-09-16 12:53:56.202	\N	\N	\N
68	آزمون فرم	09123466003	helsa-qa-form-3466003@example.com	scrypt$2f29107c1f32ca1a57ec81e97de7ccfd$b9b89a569700a8f5782bf4b29ce20a76f86a2917486babd8848c59de933a7e64dcfcf0569d5e0c540361e3402b0f38800234cd578b8a8e06cdb90357d53b29df	\N	t	2026-09-16 12:55:52.720264	2026-09-16 12:55:52.718	\N	\N	\N
70	کیوای هلسا	09120009485	qa-j31-ui@helsa-test.ir	scrypt$073886f17ed997535b6c5557e598dc30$95b066d283009a23cb5ced6d01ec61a8db56ac339a5b7cb68e5f5668b32ff72884fc4cd5df09b781248bb03e8219e2a2e2a680990172f4450eb1722b081762bf	\N	t	2026-09-16 12:57:04.444602	2026-09-16 12:57:04.443	\N	\N	\N
72	مهمان تستی	09129931079	\N	\N	\N	t	2026-09-16 13:39:05.01206	2026-09-16 13:39:05.035	0012345679	2026-09-16 13:39:05.035	checkout
63	سارا تستی	09125556677	sara.qa@helsa-test.ir	scrypt$a5f90db6d033810bc59748bb799bf4dd$fb602f7f94ee03c63a0681f08ae24aa5206514ead7797c6347d6571a968f7a862013c6f95fad023122f7945346f153ba478e21f6c0145e46df76105540b4cc38	\N	t	2026-09-16 11:17:18.551745	2026-09-16 14:08:21.49	0012345679	2026-09-16 14:08:21.49	checkout
74	مهمان تستی	09126085274	\N	\N	\N	t	2026-09-16 14:10:09.985641	2026-09-16 14:10:09.991	0012345679	2026-09-16 14:10:09.991	checkout
75	آزمون فرم	09121091678	helsa-qa-form-1091678@example.com	scrypt$07fb028a7d2dec4197d6c4409587860d$d9099f9cb4e1da21a080b9479560a554e15ca68fe27a84fc61e77d50666fb7a28bacd922d3c40afae16eee962054d0fb393ad5f3f2718510069c5e0cad4c97bc	\N	t	2026-09-16 14:10:43.375673	2026-09-16 14:10:43.374	\N	\N	\N
77	رضا کافه‌دار	09124447847	demo7847.cafe@helsa-test.ir	scrypt$f8fbf5ac2820f774ed7387649395c418$eb811c6cd931078abf6617baa3e5984941584e19dec934dd873f649ef02b9afe6ec6e106818ca389e437aa93c70c33b4bf22057e73a41c050639ee954d47317d	\N	t	2026-09-16 14:10:47.716298	2026-09-16 14:10:47.715	\N	\N	\N
76	زهرا محمدی	09123334455	zahra.qa@helsa-test.ir	scrypt$2bdf1a3a08a682f8cf51efb501c180e2$524469366490a4e8466f5b9e251cd2b87268c0116ce0a0829e85b30e713659d64261e6e61d5efdcc52ddba6ee0beb9dd73af6faca3b735e1355f76a534363102	2026-09-16 14:10:50.526	t	2026-09-16 14:10:47.617845	2026-09-16 14:10:50.526	\N	\N	\N
\.


--
-- Data for Name: gift_packages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.gift_packages (id, name, slug, kind, short_description, description, image, image_alt, base_price, old_price, stock, min_qty, max_qty, contents, occasions, packaging_options, allows_message, allows_recipient, is_active, is_featured, seo_title, seo_description, created_at, updated_at) FROM stdin;
1	جعبه هدیه کلاسیک هلسا	classic-personal-gift	personal	ترکیب خرما، آجیل و شکلات خرمایی در بسته‌بندی شکیل.	جعبه هدیه کلاسیک هلسا برای تقدیرهای صمیمی؛ شامل خرمای منتخب، آجیل ممتاز و شکلات خرمایی دست‌ساز با کارت پیام.	/images/chocolate-craft.jpg	جعبه هدیه کلاسیک هلسا	890000	980000	40	1	12	["خرما منتخب", "آجیل ممتاز", "شکلات خرمایی", "کارت پیام هلسا"]	["تولد", "تشکر", "دید و بازدید", "هدیه عمومی"]	[{"id": "standard", "label": "بسته‌بندی استاندارد هلسا", "price": 0}, {"id": "premium", "label": "جعبه پریمیوم با روبان طلایی", "price": 120000}, {"id": "velvet", "label": "جعبه مخملی هدیه", "price": 180000}]	t	t	t	t	جعبه هدیه کلاسیک هلسا	ترکیب خرما، آجیل و شکلات خرمایی در بسته‌بندی شکیل.	2026-09-11 22:08:00.162974	2026-09-11 22:08:00.123
2	هدیه یلدای هلسا	yalda-personal-gift	personal	انار خشک، آجیل یلدایی و شکلات خرمایی برای شب چله.	پکیج یلدای هلسا با چیدمان شب‌چله‌ای؛ مناسب هدیه خانوادگی و دوستانه.	/images/tray-yalda.jpg	هدیه یلدای هلسا	1150000	\N	25	1	10	["آجیل یلدایی", "خشکبار شب‌چله", "شکلات خرمایی", "کارت یلدا"]	["یلدا", "خانوادگی", "دوستانه"]	[{"id": "standard", "label": "بسته‌بندی یلدایی هلسا", "price": 0}, {"id": "premium", "label": "جعبه یلدایی پریمیوم", "price": 150000}]	t	t	t	t	هدیه یلدای هلسا	انار خشک، آجیل یلدایی و شکلات خرمایی برای شب چله.	2026-09-11 22:08:00.168764	2026-09-11 22:08:00.165
3	هدیه نوروزی هلسا	nowruz-personal-gift	personal	عیدی طبیعی هلسا با خرما، آجیل و شیرینی خشک.	جعبه نوروزی هلسا برای عیدی و تقدیر ابتدای سال؛ بسته‌بندی روشن و محتوای تازه.	/images/tray-norooz.jpg	هدیه نوروزی هلسا	1080000	1180000	30	1	15	["آجیل نوروزی", "خرما", "شیرینی خشک", "کارت نوروز"]	["نوروز", "عیدی", "تقدیر"]	[{"id": "standard", "label": "جعبه نوروزی هلسا", "price": 0}, {"id": "premium", "label": "جعبه نوروزی پریمیوم", "price": 140000}]	t	t	t	f	هدیه نوروزی هلسا	عیدی طبیعی هلسا با خرما، آجیل و شیرینی خشک.	2026-09-11 22:08:00.170511	2026-09-11 22:08:00.169
4	هدیه لوکس شخصی هلسا	luxury-personal-gift	personal	انتخاب ویژه با خرما مجول، زعفران و شکلات دست‌ساز.	هدیه لوکس هلسا برای مناسبت‌های خاص؛ محتوای ممتاز و بسته‌بندی فاخر.	/images/mazeh-board.jpg	هدیه لوکس شخصی هلسا	1650000	\N	18	1	8	["خرما مجول", "زعفران", "شکلات دست‌ساز", "آجیل ویژه"]	["سالگرد", "تقدیر ویژه", "مناسبت خاص"]	[{"id": "premium", "label": "جعبه پریمیوم هلسا", "price": 0}, {"id": "velvet", "label": "جعبه مخملی طلایی", "price": 220000}]	t	t	t	t	هدیه لوکس شخصی هلسا	انتخاب ویژه با خرما مجول، زعفران و شکلات دست‌ساز.	2026-09-11 22:08:00.173259	2026-09-11 22:08:00.171
5	پکیج سازمانی کارکنان هلسا	corporate-staff-gift	corporate	هدیه یکدست و شکیل برای تقدیر از کارکنان.	پکیج سازمانی کارکنان هلسا با امکان کارت سازمانی، تیراژ بالا و فاکتور رسمی پس از تأیید.	/images/tray-classic.jpg	پکیج سازمانی کارکنان هلسا	780000	\N	200	10	500	["آجیل مخلوط", "خرما", "شکلات خرمایی", "کارت سازمانی"]	["تقدیر سازمانی", "رویداد داخلی", "پایان سال"]	[{"id": "standard", "label": "بسته‌بندی سازمانی یکدست", "price": 0}, {"id": "branded", "label": "بسته‌بندی با فضای لوگو", "price": 90000}]	t	f	t	t	پکیج سازمانی کارکنان هلسا	هدیه یکدست و شکیل برای تقدیر از کارکنان.	2026-09-11 22:08:00.175172	2026-09-11 22:08:00.174
6	پکیج سازمانی مشتریان هلسا	corporate-client-gift	corporate	هدیه حرفه‌ای برای مشتریان و شرکای تجاری.	پکیج مشتریان هلسا برای B2B؛ امکان پیام سازمانی، لوگو و زمان‌بندی تحویل هماهنگ.	/images/tray-vip.jpg	پکیج سازمانی مشتریان هلسا	1250000	\N	120	5	300	["آجیل ویژه", "شکلات دست‌ساز", "عسل کوچک", "کارت سازمانی"]	["تقدیر مشتری", "افتتاحیه", "مناسبت شرکتی"]	[{"id": "premium", "label": "جعبه پریمیوم سازمانی", "price": 0}, {"id": "branded", "label": "جعبه با فضای لوگو و کارت", "price": 150000}]	t	t	t	t	پکیج سازمانی مشتریان هلسا	هدیه حرفه‌ای برای مشتریان و شرکای تجاری.	2026-09-11 22:08:00.180889	2026-09-11 22:08:00.179
7	پکیج اجرایی مدیریت هلسا	corporate-executive-gift	corporate	انتخاب فاخر برای مدیران و مهمانان ویژه.	پکیج اجرایی هلسا با محتوای ممتاز برای هدیه‌های سطح مدیریتی و رویدادهای رسمی.	/images/hero-helsa.jpg	پکیج اجرایی مدیریت هلسا	2100000	\N	60	3	100	["خرما مجول", "زعفران", "آجیل VIP", "شکلات ویژه"]	["مدیریتی", "رویداد رسمی", "مهمان ویژه"]	[{"id": "velvet", "label": "جعبه مخملی اجرایی", "price": 0}, {"id": "branded", "label": "جعبه اجرایی با فضای لوگو", "price": 250000}]	t	t	t	f	پکیج اجرایی مدیریت هلسا	انتخاب فاخر برای مدیران و مهمانان ویژه.	2026-09-11 22:08:00.182458	2026-09-11 22:08:00.181
8	کیت خوش‌آمد کارکنان هلسا	corporate-welcome-kit	corporate	هدیه روز اول؛ کیت خوش‌آمد برای همکاران تازه‌وارد.	کیت خوش‌آمد هلسا برای سازمان‌هایی که روز اول همکاران را متفاوت می‌کنند. محتوای سبک و شکیل، امکان چاپ پیام خوش‌آمد سازمانی و تیراژ بالا با یکدستی کامل.	/images/mazeh-light.jpg	کیت خوش‌آمد کارکنان هلسا	520000	\N	300	10	1000	["چای معطر", "عسل کوچک", "شکلات خرمایی", "کارت خوش‌آمد"]	["تقدیر سازمانی", "شروع همکاری", "رویداد داخلی"]	[{"id": "standard", "label": "جعبه سازمانی یکدست", "price": 0}, {"id": "branded", "label": "جعبه با فضای لوگو و پیام خوش‌آمد", "price": 70000}]	t	f	t	f	کیت خوش‌آمد کارکنان هلسا	هدیه روز اول؛ کیت خوش‌آمد برای همکاران تازه‌وارد.	2026-09-11 22:08:00.185176	2026-09-11 22:08:00.183
9	پکیج همایش و رویداد هلسا	corporate-event-pack	corporate	پذیرایی و هدیه یکدست برای همایش‌ها و رویدادها.	پکیج همایش هلسا برای رخدادهای سازمانی با تعداد مهمان زیاد: میان‌وعده‌های فردی بهداشتی، هدیه یادگاری شرکت‌کنندگان و امکان چاپ لوگو روی بسته‌بندی. تحویل هماهنگ در محل رویداد.	/images/mazeh-board.jpg	پکیج همایش و رویداد هلسا	380000	\N	500	25	2000	["میان‌وعده فردی", "آجیل پک", "خرما", "کارت رویداد"]	["رویداد رسمی", "همایش", "مناسبت شرکتی"]	[{"id": "standard", "label": "بسته فردی رویداد", "price": 0}, {"id": "branded", "label": "بسته فردی با لوگوی رویداد", "price": 60000}, {"id": "eco", "label": "بسته بازیافت‌پذیر (کرفت)", "price": 40000}]	t	f	t	t	پکیج همایش و رویداد هلسا	پذیرایی و هدیه یکدست برای همایش‌ها و رویدادها.	2026-09-11 22:08:00.186958	2026-09-11 22:08:00.185
10	یلدای سازمانی هلسا	corporate-yalda-gift	corporate	سینی یلدای شرکتی؛ انار، خرما، آجیل و شیرینی مجاز.	یلدای سازمانی هلسا ترکیبی از سنت و نظم سازمانی است: سینی یا جعبه یلدا با انار، خرما، آجیل، میوه خشک و شیرینی، با امکان کارت تبریک سازمانی و تحویل هماهنگ قبل از شب یلدا.	/images/tray-yalda.jpg	یلدای سازمانی هلسا با انار و خرما و آجیل	940000	\N	150	10	600	["انار", "خرما", "آجیل یلدا", "میوه خشک", "کارت تبریک"]	["یلدا", "یلدای سازمانی"]	[{"id": "standard", "label": "جعبه یلدای سازمانی", "price": 0}, {"id": "tray", "label": "سینی یلدای چوبی", "price": 220000}, {"id": "branded", "label": "جعبه یلدا با فضای لوگو", "price": 110000}]	t	f	t	t	یلدای سازمانی هلسا	سینی یلدای شرکتی؛ انار، خرما، آجیل و شیرینی مجاز.	2026-09-11 22:08:00.188949	2026-09-11 22:08:00.187
11	نوروز سازمانی هلسا	corporate-norooz-gift	corporate	بسته نوروزی شرکتی با آجیل، شیرینی و سبزه.	نوروز سازمانی هلسا برای سال نوِ پرکار سازمان‌ها: بسته نوروزی با آجیل، شیرینی مجاز، خشکبار و کارت سال نو، با زمان‌بندی تحویل قبل از تعطیلات و امکان برندینگ کامل.	/images/tray-norooz.jpg	نوروز سازمانی هلسا با آجیل و شیرینی	860000	\N	200	10	800	["آجیل نوروزی", "شیرینی مجاز", "خشکبار", "کارت سال نو"]	["نوروز", "نوروز سازمانی", "پایان سال"]	[{"id": "standard", "label": "جعبه نوروزی سازمانی", "price": 0}, {"id": "branded", "label": "جعبه نوروزی با فضای لوگو", "price": 95000}]	t	f	t	f	نوروز سازمانی هلسا	بسته نوروزی شرکتی با آجیل، شیرینی و سبزه.	2026-09-11 22:08:00.19112	2026-09-11 22:08:00.189
12	پکیج کاملاً سفارشی سازمانی	corporate-custom-gift	corporate	هر چیزی که سازمان شما نیاز دارد؛ کاملاً سفارشی.	پکیج سفارشی هلسا برای سازمان‌هایی که چشم‌انداز مشخص خودشان را دارند: انتخاب آزاد محتوا، بسته‌بندی اختصاصی، برندینگ کامل و بودجه‌بندی مشارکتی با کارشناس هلسا. قیمت پس از استعلام کارشناسی نهایی می‌شود.	/images/chocolate-craft.jpg	پکیج کاملاً سفارشی سازمانی هلسا	450000	\N	0	20	3000	["انتخاب آزاد محتوا", "بسته‌بندی اختصاصی", "برندینگ کامل"]	["سفارشی", "مناسبت شرکتی"]	[{"id": "consult", "label": "مشاوره آزاد با کارشناس هلسا", "price": 0}]	t	t	t	f	پکیج کاملاً سفارشی سازمانی	هر چیزی که سازمان شما نیاز دارد؛ کاملاً سفارشی.	2026-09-11 22:08:00.194664	2026-09-11 22:08:00.193
\.


--
-- Data for Name: gift_quotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.gift_quotes (id, package_id, config, unit_price, quantity, total, created_at) FROM stdin;
1	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-11 22:19:16.380273
2	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-11 22:19:58.234887
3	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-11 22:20:11.624693
4	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-11 22:20:12.190269
5	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-11 22:21:43.268135
6	1	{"image": "/images/chocolate-craft.jpg", "message": "تست", "occasion": "", "packageName": "جعبه هدیه کلاسیک هلسا", "packageSlug": "classic-personal-gift", "packagingId": "standard", "recipientName": "", "packagingLabel": "بسته‌بندی استاندارد هلسا"}	890000	3	2670000	2026-09-12 07:41:00.351622
\.


--
-- Data for Name: instagram_posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.instagram_posts (id, image_url, caption, permalink, product_slug, likes, comments, posted_at, sort_order, is_active, created_at, updated_at, kind, title) FROM stdin;
1	/images/opt/dates-mazafati.jpg	خرمای مضافتی بم، تازه و لطیف 🌴 تازه رسیده — مستقیم از نخلستان‌های بم	\N	mazafati-dates	\N	\N	2026-09-10 08:23:45.575	1	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
2	/images/opt/saffron-rock-candy.jpg	نبات زعفرانی هلسا با چای عصرانه ☕ عصرِ خوب، ساده شروع می‌شود	\N	saffron-rock-candy	\N	\N	2026-09-08 08:23:45.575	2	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
3	/images/opt/gift-pack.jpg	پک‌های هدیهٔ هلسا برای مناسبت‌های ویژه 🎁 انتخابی که فراموش نمی‌شود	\N	helsa-gift-pack	\N	\N	2026-09-06 08:23:45.575	3	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
4	/images/opt/cheese.jpg	پنیر سنتی و زیتونِ پذیرایی؛ ساده، تازه و خوشمزه 🫒	\N	traditional-cheese	\N	\N	2026-09-04 08:23:45.575	4	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
5	/images/opt/spice-blend.jpg	ادویه‌های ترکیبی هلسا؛ راز طعم‌های خانهٔ شما 🌿 تازه آسیاب‌شده	\N	helsa-spice-blend	\N	\N	2026-09-02 08:23:45.575	5	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
6	/images/opt/tahini.jpg	اردهٔ کنجد هلسا + عسل طبیعی = صبحانهٔ کامل 🍯	\N	sesame-tahini	\N	\N	2026-08-31 08:23:45.575	6	t	2026-09-12 08:23:45.579258	2026-09-12 08:23:45.579258	post	\N
8	/images/opt/dates-piaram.jpg	خرمای پیارم؛ خشک، شیرین و پرخاصیت — سوغات جنوب	\N	piaram-dates	\N	\N	2026-09-10 10:27:27.891	1	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
9	/images/opt/medjool-dates.jpg	خرما مجول؛ پادشاه خرما روی سفرهٔ شما 👑	\N	medjool-dates	\N	\N	2026-09-08 10:27:27.891	2	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
10	/images/opt/dates-kabkab.jpg	خرمای کبکاب؛ عطر بهشتی نخلستان‌های جنوب	\N	kabkab-dates	\N	\N	2026-09-06 10:27:27.891	3	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
11	/images/opt/handmade-date-chocolate.jpg	شکلات دست‌ساز خرما؛ امضای کارگاه هلسا 🍫	\N	helsa-handmade-chocolate	\N	\N	2026-09-04 10:27:27.891	4	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
12	/images/opt/date-chocolate.jpg	شکلات خرمایی؛ تلاقی طعم و سلامت	\N	date-chocolate	\N	\N	2026-09-02 10:27:27.891	5	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
13	/images/opt/date-chocolate-walnut.jpg	شکلات خرمایی مغزدار؛ با مغز گردوی تازه	\N	filled-date-chocolate	\N	\N	2026-08-31 10:27:27.891	6	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
14	/images/opt/date-bar.jpg	بار خرما؛ انرژی طبیعی برای روزهای شلوغ	\N	date-bar	\N	\N	2026-08-29 10:27:27.891	7	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
15	/images/opt/date-sugar.jpg	قند خرما؛ شیرینی طبیعی، بدون شکر سفید	\N	helsa-date-sugar	\N	\N	2026-08-27 10:27:27.891	8	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
16	/images/opt/date-syrup.jpg	شیرهٔ خرما؛ روی نان صبحانه یا داخل شیر گرم	\N	date-syrup	\N	\N	2026-08-25 10:27:27.891	9	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
17	/images/opt/halva-arde.jpg	حلوا ارده؛ صبحانهٔ اصیل ایرانی	\N	helsa-halva-tahini	\N	\N	2026-08-23 10:27:27.891	10	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
18	/images/opt/natural-gon-honey.jpg	عسل گون؛ طعم واقعی کوهستان، با آنالیز آزمایشگاهی	\N	natural-honey	\N	\N	2026-08-21 10:27:27.891	11	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
19	/images/opt/honey-jar.jpg	عسل کنار؛ غلیظ، معطر و پرخاصیت	\N	sidr-honey	\N	\N	2026-08-19 10:27:27.891	12	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
20	/images/opt/premium-mixed-nuts.jpg	آجیل مخلوط هلسا؛ تازه‌پوست‌کنیده، بدون نمک اضافه	\N	helsa-mixed-nuts	\N	\N	2026-08-17 10:27:27.891	13	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
21	/images/opt/party-nuts.jpg	آجیل مهمانی؛ سینی پذیرایی شما کامل می‌شود	\N	party-nuts-collection	\N	\N	2026-08-15 10:27:27.891	14	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
22	/images/opt/four-nut-mix.jpg	آجیل چهارمغز؛ پسته، بادام، فندق و گردو	\N	four-kernel-nuts	\N	\N	2026-08-13 10:27:27.891	15	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
23	/images/opt/walnut-kernels.jpg	مغز گردوی تازه؛ روشن و روغنی	\N	walnut-kernels	\N	\N	2026-08-11 10:27:27.891	16	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
24	/images/opt/dried-figs.jpg	انجیر خشک استهبان؛ شیرینی طبیعت در یک لقمه	\N	helsa-dried-fruit-selection	\N	\N	2026-08-09 10:27:27.891	17	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
25	/images/opt/dried-fruit-mix.jpg	خشکبار ویژهٔ هلسا؛ چیدمان رنگی سفرهٔ شما	\N	helsa-dried-fruit-selection	\N	\N	2026-08-07 10:27:27.891	18	t	2026-09-12 10:27:27.897638	2026-09-12 10:27:27.897638	post	\N
26	/images/opt/handmade-date-chocolate.jpg	پشت‌صحنهٔ کارگاه	\N	helsa-handmade-chocolate	\N	\N	2026-09-12 04:27:27.891	1	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	پشت‌صحنهٔ کارگاه
27	/images/opt/halva-arde.jpg	صبحانهٔ هلسایی	\N	helsa-halva-tahini	\N	\N	2026-09-11 22:27:27.891	2	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	صبحانهٔ هلسایی
28	/images/opt/natural-gon-honey.jpg	عسل خالص	\N	natural-honey	\N	\N	2026-09-11 16:27:27.891	3	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	عسل خالص
29	/images/opt/premium-mixed-nuts.jpg	آجیل تازه	\N	helsa-mixed-nuts	\N	\N	2026-09-11 10:27:27.891	4	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	آجیل تازه
30	/images/opt/date-sugar.jpg	شیرینی طبیعی	\N	helsa-date-sugar	\N	\N	2026-09-11 04:27:27.891	5	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	شیرینی طبیعی
31	/images/tray-classic.jpg	سینی مزه	\N	\N	\N	\N	2026-09-10 22:27:27.891	6	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	سینی مزه
32	/images/opt/fruit-tea.jpg	دمنوش عصرانه	\N	helsa-fruit-tea	\N	\N	2026-09-10 16:27:27.891	7	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	دمنوش عصرانه
33	/images/opt/special-yalda-nuts.jpg	یلدا با هلسا	\N	helsa-yalda-pack	\N	\N	2026-09-10 10:27:27.891	8	t	2026-09-12 10:27:27.900552	2026-09-12 10:27:27.900552	story	یلدا با هلسا
34	/images/opt/sumac.jpg	سماق پرک	\N	sumac	\N	\N	2026-09-12 04:28:56.25	1	t	2026-09-12 10:28:56.253603	2026-09-12 10:28:56.253603	story	سماق پرک
35	/images/opt/sesame-bar.jpg	بار کنجد	\N	sesame-bar	\N	\N	2026-09-11 22:28:56.25	2	t	2026-09-12 10:28:56.253603	2026-09-12 10:28:56.253603	story	بار کنجد
\.


--
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_movements (id, product_id, tray_id, variant_id, quantity_change, previous_quantity, new_quantity, reason, note, created_by, reference_type, reference_id, created_at) FROM stdin;
1	35	\N	\N	28	0	28	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.304731
2	36	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.318979
3	37	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.342005
4	38	\N	\N	34	0	34	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.358497
5	39	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.377326
6	40	\N	\N	10	0	10	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.394339
7	41	\N	\N	9	0	9	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.402959
8	42	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.411101
9	43	\N	\N	44	0	44	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.42408
10	44	\N	\N	36	0	36	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.449868
11	45	\N	\N	55	0	55	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.462272
12	46	\N	\N	31	0	31	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.47273
13	47	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.485646
14	48	\N	\N	40	0	40	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.498796
15	49	\N	\N	38	0	38	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.507599
16	50	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.516071
17	1	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.523457
18	2	\N	\N	42	0	42	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.531452
19	3	\N	\N	35	0	35	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.539421
20	4	\N	\N	38	0	38	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.54718
21	5	\N	\N	28	0	28	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.554238
22	6	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.562346
23	57	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.566313
24	58	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.570467
25	59	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.57467
26	60	\N	\N	10	0	10	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.57887
27	61	\N	\N	11	0	11	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.583069
28	62	\N	\N	8	0	8	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.587012
29	63	\N	\N	35	0	35	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.591282
30	64	\N	\N	46	0	46	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.596145
31	65	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.600228
32	66	\N	\N	28	0	28	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.60433
33	67	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.608183
34	68	\N	\N	25	0	25	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.615139
35	69	\N	\N	29	0	29	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.622183
36	70	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.629937
37	71	\N	\N	44	0	44	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.638962
38	72	\N	\N	40	0	40	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.648948
39	73	\N	\N	36	0	36	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.658875
40	74	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.666267
41	75	\N	\N	52	0	52	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.670509
42	76	\N	\N	32	0	32	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.674816
43	77	\N	\N	36	0	36	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.679088
44	78	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.683568
45	79	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.687621
46	80	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.695486
47	81	\N	\N	40	0	40	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.702456
48	82	\N	\N	40	0	40	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.709328
49	83	\N	\N	36	0	36	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.719001
50	84	\N	\N	34	0	34	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.72613
51	85	\N	\N	45	0	45	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.733154
52	86	\N	\N	43	0	43	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.740296
53	87	\N	\N	50	0	50	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.747673
54	88	\N	\N	38	0	38	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.762877
55	89	\N	\N	29	0	29	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.770057
56	90	\N	\N	33	0	33	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.776804
57	91	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.783608
58	92	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.787889
59	93	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.792511
60	94	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.796431
61	95	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.800203
62	33	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.804456
63	97	\N	\N	21	0	21	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.808682
64	98	\N	\N	19	0	19	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.812739
65	99	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.816729
66	100	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.820627
67	101	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.824444
68	102	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.82817
69	103	\N	\N	10	0	10	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.832064
70	104	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.835894
71	105	\N	\N	10	0	10	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.839926
72	106	\N	\N	9	0	9	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.843895
73	107	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.847634
74	108	\N	\N	7	0	7	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.851476
75	109	\N	\N	6	0	6	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.85576
76	110	\N	\N	5	0	5	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.859601
77	111	\N	\N	8	0	8	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.863478
78	112	\N	\N	32	0	32	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.867541
79	113	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.871539
80	114	\N	\N	27	0	27	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.875304
81	115	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.879544
82	116	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.883549
83	10	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.887416
84	30	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.891078
85	119	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.895023
86	120	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.898999
87	121	\N	\N	48	0	48	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.905452
88	122	\N	\N	42	0	42	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.912153
89	123	\N	\N	40	0	40	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.918601
90	124	\N	\N	38	0	38	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.925116
91	125	\N	\N	44	0	44	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.931833
92	126	\N	\N	36	0	36	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.938915
93	127	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.945662
94	128	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.949771
95	129	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.954084
96	130	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.958649
97	131	\N	\N	25	0	25	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.962552
98	132	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.966434
99	133	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.970234
100	134	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.974031
101	135	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.977817
102	136	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.981553
103	137	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.985533
104	138	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.989229
105	139	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.993217
106	140	\N	\N	25	0	25	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:58.997005
107	141	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.000801
108	142	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.004603
109	143	\N	\N	28	0	28	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.008315
110	144	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.012059
111	145	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.015935
112	29	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.019849
113	147	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.023851
114	148	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.027657
115	149	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.031871
116	150	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.035752
117	151	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.039536
118	152	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.043248
119	153	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.047304
120	154	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.051128
121	155	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.054995
122	156	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.058776
123	157	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.062566
124	158	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.066467
125	159	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.070232
126	160	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.073916
127	161	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.077829
128	162	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.081475
129	163	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.085517
130	164	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.089261
131	165	\N	\N	28	0	28	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.096071
132	166	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.102624
133	167	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.109153
134	9	\N	\N	32	0	32	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.113047
135	169	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.117509
136	170	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.122398
137	171	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.126293
138	172	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.130308
139	173	\N	\N	17	0	17	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.134992
140	174	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.138873
141	175	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.142703
142	176	\N	\N	24	0	24	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.146807
143	177	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.15067
144	178	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.154795
145	179	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.1588
146	180	\N	\N	30	0	30	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.163327
147	181	\N	\N	26	0	26	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.166959
148	182	\N	\N	22	0	22	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.170591
149	183	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-11 22:07:59.174173
150	2	\N	\N	-1	42	41	فروش	رزرو سفارش HLA-B0EC6B31	order-system	ORDER	HLA-B0EC6B31	2026-09-11 22:19:16.128411
165	2	\N	55	-1	14	13	فروش	رزرو سفارش HLA-23A00872	order-system	ORDER	HLA-23A00872	2026-09-11 22:49:17.157309
166	90	\N	\N	-1	33	32	فروش	رزرو سفارش HLA-38AF1518	order-system	ORDER	HLA-38AF1518	2026-09-12 07:36:24.051447
167	147	\N	\N	-1	14	13	فروش	رزرو سفارش HLA-7E42375D	order-system	ORDER	HLA-7E42375D	2026-09-12 07:36:43.214275
168	147	\N	\N	-1	13	12	فروش	رزرو سفارش HLA-16F459B9	order-system	ORDER	HLA-16F459B9	2026-09-12 07:37:04.335892
169	82	\N	\N	-1	40	39	فروش	رزرو سفارش HLA-5914BE87	order-system	ORDER	HLA-5914BE87	2026-09-12 07:38:03.145235
170	82	\N	\N	1	39	40	مرجوعی	بازگردانی سفارش HLA-5914BE87	owner@helsa.dev	ORDER	HLA-5914BE87	2026-09-12 07:39:12.390224
171	147	\N	\N	1	12	13	مرجوعی	بازگردانی سفارش HLA-16F459B9	owner@helsa.dev	ORDER	HLA-16F459B9	2026-09-12 07:39:12.406572
172	147	\N	\N	1	13	14	مرجوعی	بازگردانی سفارش HLA-7E42375D	owner@helsa.dev	ORDER	HLA-7E42375D	2026-09-12 07:39:12.419513
173	171	\N	\N	-1	18	17	فروش	رزرو سفارش HLA-D09A92BC	order-system	ORDER	HLA-D09A92BC	2026-09-12 07:39:29.263728
174	2	\N	55	-1	13	12	فروش	رزرو سفارش HLA-10A2E42F	order-system	ORDER	HLA-10A2E42F	2026-09-12 07:40:33.021511
178	1	\N	53	-1	10	9	فروش	رزرو سفارش HLA-5DF840E9	order-system	ORDER	HLA-5DF840E9	2026-09-12 16:11:35.327714
179	333	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.726853
180	334	\N	\N	12	0	12	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.733443
181	335	\N	\N	16	0	16	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.739328
182	336	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.745093
183	337	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.751652
184	338	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.758415
185	339	\N	\N	18	0	18	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.764843
186	340	\N	\N	20	0	20	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.770885
187	341	\N	\N	14	0	14	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.777226
188	342	\N	\N	17	0	17	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.783425
189	343	\N	\N	15	0	15	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.789465
190	344	\N	\N	10	0	10	ورود کالا	موجودی اولیه seed توسعه	catalog-seed	\N	\N	2026-09-13 10:32:57.795584
191	9	\N	\N	-1	32	31	فروش	رزرو سفارش HLA-1F936E35	order-system	ORDER	HLA-1F936E35	2026-09-15 06:23:37.557858
192	7	\N	\N	-1	18	17	فروش	رزرو سفارش HLA-1F936E35	order-system	ORDER	HLA-1F936E35	2026-09-15 06:23:37.557858
193	9	\N	\N	-1	31	30	فروش	رزرو سفارش HLA-77E305BF	order-system	ORDER	HLA-77E305BF	2026-09-15 06:34:46.054641
194	7	\N	\N	-1	17	16	فروش	رزرو سفارش HLA-77E305BF	order-system	ORDER	HLA-77E305BF	2026-09-15 06:34:46.054641
195	9	\N	\N	-1	30	29	فروش	رزرو سفارش HLA-6F330042	order-system	ORDER	HLA-6F330042	2026-09-15 06:37:25.738278
196	7	\N	\N	-1	16	15	فروش	رزرو سفارش HLA-6F330042	order-system	ORDER	HLA-6F330042	2026-09-15 06:37:25.738278
197	9	\N	\N	-1	29	28	فروش	رزرو سفارش HLA-77800158	order-system	ORDER	HLA-77800158	2026-09-15 06:53:37.93452
198	7	\N	\N	-1	15	14	فروش	رزرو سفارش HLA-77800158	order-system	ORDER	HLA-77800158	2026-09-15 06:53:37.93452
199	170	\N	\N	-2	24	22	فروش	رزرو سفارش HLA-99A5A57D	order-system	ORDER	HLA-99A5A57D	2026-09-15 15:19:12.177749
200	9	\N	\N	-1	28	27	فروش	رزرو سفارش HLA-DB4D3856	order-system	ORDER	HLA-DB4D3856	2026-09-15 15:40:57.244
201	7	\N	\N	-1	14	13	فروش	رزرو سفارش HLA-DB4D3856	order-system	ORDER	HLA-DB4D3856	2026-09-15 15:40:57.244
202	9	\N	\N	-1	27	26	فروش	رزرو سفارش HLA-E24FF992	order-system	ORDER	HLA-E24FF992	2026-09-15 16:13:16.878491
203	7	\N	\N	-1	13	12	فروش	رزرو سفارش HLA-E24FF992	order-system	ORDER	HLA-E24FF992	2026-09-15 16:13:16.878491
204	9	\N	\N	-1	26	25	فروش	رزرو سفارش HLA-1829C204	order-system	ORDER	HLA-1829C204	2026-09-15 17:15:38.994911
205	9	\N	\N	-1	25	24	فروش	رزرو سفارش HLA-78FB7C40	order-system	ORDER	HLA-78FB7C40	2026-09-15 17:16:36.049619
206	7	\N	\N	-1	12	11	فروش	رزرو سفارش HLA-78FB7C40	order-system	ORDER	HLA-78FB7C40	2026-09-15 17:16:36.049619
207	9	\N	\N	-1	24	23	فروش	رزرو سفارش HLA-ED52EE9F	order-system	ORDER	HLA-ED52EE9F	2026-09-15 18:25:48.567534
208	9	\N	\N	-1	23	22	فروش	رزرو سفارش HLA-FEAF70F7	order-system	ORDER	HLA-FEAF70F7	2026-09-16 07:36:55.173579
209	7	\N	\N	-1	11	10	فروش	رزرو سفارش HLA-FEAF70F7	order-system	ORDER	HLA-FEAF70F7	2026-09-16 07:36:55.173579
210	9	\N	\N	-1	22	21	فروش	رزرو سفارش HLA-38DEDF17	order-system	ORDER	HLA-38DEDF17	2026-09-16 07:37:41.132395
211	9	\N	\N	-1	21	20	فروش	رزرو سفارش HLA-C0BD6D43	order-system	ORDER	HLA-C0BD6D43	2026-09-16 09:08:01.37354
212	7	\N	\N	-1	10	9	فروش	رزرو سفارش HLA-C0BD6D43	order-system	ORDER	HLA-C0BD6D43	2026-09-16 09:08:01.37354
213	9	\N	\N	-1	20	19	فروش	رزرو سفارش HLA-9589313A	order-system	ORDER	HLA-9589313A	2026-09-16 09:08:49.205354
214	9	\N	\N	-1	19	18	فروش	رزرو سفارش HLA-BB504D3E	order-system	ORDER	HLA-BB504D3E	2026-09-16 09:42:54.068574
215	7	\N	\N	-1	9	8	فروش	رزرو سفارش HLA-BB504D3E	order-system	ORDER	HLA-BB504D3E	2026-09-16 09:42:54.068574
216	9	\N	\N	-1	18	17	فروش	رزرو سفارش HLA-F65EF566	order-system	ORDER	HLA-F65EF566	2026-09-16 09:44:07.618748
217	9	\N	\N	-1	17	16	فروش	رزرو سفارش HLA-1AAD987E	order-system	ORDER	HLA-1AAD987E	2026-09-16 10:01:46.624539
218	9	\N	\N	-1	16	15	فروش	رزرو سفارش HLA-F3D2F7A3	order-system	ORDER	HLA-F3D2F7A3	2026-09-16 10:03:24.459325
219	7	\N	\N	-1	8	7	فروش	رزرو سفارش HLA-F3D2F7A3	order-system	ORDER	HLA-F3D2F7A3	2026-09-16 10:03:24.459325
220	9	\N	\N	-1	15	14	فروش	رزرو سفارش HLA-150C56AE	order-system	ORDER	HLA-150C56AE	2026-09-16 10:05:38.640907
221	7	\N	\N	-1	7	6	فروش	رزرو سفارش HLA-150C56AE	order-system	ORDER	HLA-150C56AE	2026-09-16 10:05:38.640907
222	9	\N	\N	-1	14	13	فروش	رزرو سفارش HLA-8BAC4FA9	order-system	ORDER	HLA-8BAC4FA9	2026-09-16 10:21:21.921747
223	7	\N	\N	-1	6	5	فروش	رزرو سفارش HLA-8BAC4FA9	order-system	ORDER	HLA-8BAC4FA9	2026-09-16 10:21:21.921747
224	9	\N	\N	-1	13	12	فروش	رزرو سفارش HLA-882DAD54	order-system	ORDER	HLA-882DAD54	2026-09-16 10:43:09.13784
225	7	\N	\N	-1	5	4	فروش	رزرو سفارش HLA-882DAD54	order-system	ORDER	HLA-882DAD54	2026-09-16 10:43:09.13784
226	9	\N	\N	-1	12	11	فروش	رزرو سفارش HLA-001AE12D	order-system	ORDER	HLA-001AE12D	2026-09-16 10:43:50.221563
227	9	\N	\N	-1	11	10	فروش	رزرو سفارش HLA-178C9C5F	order-system	ORDER	HLA-178C9C5F	2026-09-16 11:09:42.789365
228	9	\N	\N	-1	10	9	فروش	رزرو سفارش HLA-67B6F069	order-system	ORDER	HLA-67B6F069	2026-09-16 11:17:49.006336
229	7	\N	\N	-1	4	3	فروش	رزرو سفارش HLA-67B6F069	order-system	ORDER	HLA-67B6F069	2026-09-16 11:17:49.006336
230	9	\N	\N	-1	9	8	فروش	رزرو سفارش HLA-6F5E1927	order-system	ORDER	HLA-6F5E1927	2026-09-16 12:56:24.419665
231	7	\N	\N	-1	3	2	فروش	رزرو سفارش HLA-6F5E1927	order-system	ORDER	HLA-6F5E1927	2026-09-16 12:56:24.419665
232	9	\N	\N	-1	8	7	فروش	رزرو سفارش HLA-20F36710	order-system	ORDER	HLA-20F36710	2026-09-16 13:37:20.475694
233	7	\N	\N	-1	2	1	فروش	رزرو سفارش HLA-20F36710	order-system	ORDER	HLA-20F36710	2026-09-16 13:37:20.475694
234	9	\N	\N	-1	7	6	فروش	رزرو سفارش HLA-38FED6F4	order-system	ORDER	HLA-38FED6F4	2026-09-16 13:39:05.01206
235	1	\N	\N	-1	30	29	فروش	رزرو سفارش HLA-537025FD	order-system	ORDER	HLA-537025FD	2026-09-16 14:08:21.482633
236	13	\N	\N	-1	24	23	فروش	رزرو سفارش HLA-537025FD	order-system	ORDER	HLA-537025FD	2026-09-16 14:08:21.482633
237	1	\N	\N	-1	29	28	فروش	رزرو سفارش HLA-3F63BB17	order-system	ORDER	HLA-3F63BB17	2026-09-16 14:10:09.985641
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (id, number, order_id, customer_id, subtotal, discount, shipping, total, payment_method, provider, status, paid_at, created_at) FROM stdin;
\.


--
-- Data for Name: mazeh_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mazeh_categories (id, name, code) FROM stdin;
1	مزه‌های شور	SAVORY
2	مزه‌های شیرین	SWEET
3	مغزها و آجیل	NUTS
4	میوه تازه	FRUIT
5	نان و کراکر	BREAD
6	دیپ‌ها و مربا	DIP
7	چیدمان و امضای هلسا	DECORATION
\.


--
-- Data for Name: mazeh_tray_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mazeh_tray_items (id, tray_id, product_id, title, quantity, section, sort_order) FROM stdin;
1	1	\N	پنیر لیقوان و پنیر خامه‌ای	۲۵۰ گرم	SAVORY	0
2	1	\N	زیتون سبز و سیاه پرورده	۲۰۰ گرم	SAVORY	0
3	1	\N	رولت کالباس بوقلمون دودی	۱۵۰ گرم	SAVORY	0
4	1	13	پسته و بادام درختی	۱۵۰ گرم	NUTS	0
5	1	1	خرما پیارم هلسا	۲۰۰ گرم	SWEET	0
6	1	7	شکلات دست‌ساز خرما	۶ عدد	SWEET	0
7	1	21	انجیر خشک و برگه زردآلو	۱۵۰ گرم	SWEET	0
8	1	\N	کراکر و نان‌چوب	۱۲ عدد	BREAD	0
9	1	\N	دیپ زیتون و دیپ پنیر	۲ کاسه	DIP	0
10	1	\N	انگور و توت‌فرنگی تازه	۲۰ گرم	FRUIT	0
11	1	\N	مدالیون طلاکوب هلسا و شاخه رزماری	۱ ست	DECORATION	0
12	2	\N	پنیر کهنه، گودا و پنیر ترافل	۳۵۰ گرم	SAVORY	0
13	2	\N	زیتون مارینیت شده با مرکبات	۲۵۰ گرم	SAVORY	0
14	2	\N	کالدکات دودی و رژیون مرغ	۲۵۰ گرم	SAVORY	0
15	2	18	پسته اکبری و مغز گردوی سفید	۲۵۰ گرم	NUTS	0
16	2	6	خرما مجول سلطنتی	۲۵۰ گرم	SWEET	0
17	2	7	شکلات دست‌ساز با ورق طلا	۱۰ عدد	SWEET	0
18	2	27	عسل طبیعی گون با شان	۱۵۰ گرم	SWEET	0
19	2	\N	کراکر ژنوس و نان‌چوب زعفرانی	۱۸ عدد	BREAD	0
20	2	\N	دیپ انار و دیپ زعفران	۲ کاسه	DIP	0
21	2	\N	انگور، انجیر تازه و بری	۳۰ گرم	FRUIT	0
22	2	\N	مدالیون طلای هلسا و گل طبیعی	۱ ست	DECORATION	0
23	3	\N	پنیر لیقوان با گردو	۳۰۰ گرم	SAVORY	0
24	3	\N	زیتون پرورده گیلان	۲۰۰ گرم	SAVORY	0
25	3	\N	سبزی خوردن تازه و تربچه	۱ دسته	SAVORY	0
26	3	14	پسته، بادام و فندق	۲۰۰ گرم	NUTS	0
27	3	2	خرما مضافتی بم	۲۵۰ گرم	SWEET	0
28	3	26	کشمش، انجیر و توت خشک	۲۰۰ گرم	SWEET	0
29	3	27	عسل و شیره انگور	۲ کاسه	SWEET	0
30	3	\N	نان سنگک و کراکر سنتی	۱ ست	BREAD	0
31	3	\N	مربی بالنگ و مربا گل محمدی	۲ کاسه	DIP	0
32	3	\N	مدالیون مسی هلسا با نقش ترمه	۱ عدد	DECORATION	0
33	4	\N	پنیر چدار و پنیر خامه‌ای	۲۵۰ گرم	SAVORY	0
34	4	\N	زیتون و خیارشور خلالی	۲۰۰ گرم	SAVORY	0
35	4	\N	کالدکات مرغ و بوقلمون	۱۸۰ گرم	SAVORY	0
36	4	\N	کراکر نمکی و نان‌چوب	۱۴ عدد	BREAD	0
37	4	1	خرما پیارم و مجول	۲۵۰ گرم	SWEET	0
38	4	12	شکلات خرمایی و شیرینی طبیعی	۱۲ عدد	SWEET	0
39	4	26	میوه خشک مخلوط	۱۸۰ گرم	SWEET	0
40	4	27	عسل و مربای توت‌فرنگی	۲ کاسه	SWEET	0
41	4	13	بادام هندی و پسته	۱۵۰ گرم	NUTS	0
42	4	\N	انگور و پرتقال خلالی	۲۵۰ گرم	FRUIT	0
43	5	1	خرما پیارم هلسا	۲۵۰ گرم	SWEET	0
44	5	6	خرما مجول سلطنتی	۲۰۰ گرم	SWEET	0
45	5	\N	خرمای شکفته با گردو	۱۵۰ گرم	SWEET	0
46	5	7	شکلات دست‌ساز خرما	۱۰ عدد	SWEET	0
47	5	9	قند خرما و پودر خرما	۱ ست	SWEET	0
48	5	26	میوه خشک منتخب	۱۵۰ گرم	SWEET	0
49	5	18	پسته و بادام هندی	۱۵۰ گرم	NUTS	0
50	5	27	عسل طبیعی گون	۱ کاسه	SWEET	0
51	5	\N	کراکر شیرین و بیسکویت کره‌ای	۱۰ عدد	BREAD	0
52	5	\N	مدالیون شکلاتی هلسا	۱ عدد	DECORATION	0
53	6	\N	پنیر خامه‌ای و پنیر سفید	۲۰۰ گرم	SAVORY	0
54	6	\N	زیتون سبز	۱۵۰ گرم	SAVORY	0
55	6	14	آجیل چهارمغز	۱۲۰ گرم	NUTS	0
56	6	2	خرما مضافتی	۱۵۰ گرم	SWEET	0
57	6	7	شکلات خرمایی	۶ عدد	SWEET	0
58	6	26	میوه خشک	۱۰۰ گرم	SWEET	0
59	6	\N	کراکر و نان‌چوب	۱۰ عدد	BREAD	0
60	6	\N	انگور و سیب خلالی	۲۰ گرم	FRUIT	0
61	7	\N	سه نوع پنیر منتخب	۴۰۰ گرم	SAVORY	0
62	7	\N	زیتون سبز و سیاه	۲۵۰ گرم	SAVORY	0
63	7	\N	کالدکات و رژیون	۲۵۰ گرم	SAVORY	0
64	7	\N	خیارشور و سبزیجات تازه	۲۰۰ گرم	SAVORY	0
65	7	13	آجیل ممتاز شب‌چره	۲۵۰ گرم	NUTS	0
66	7	1	خرما پیارم و کبکاب	۳۰۰ گرم	SWEET	0
67	7	7	شکلات دست‌ساز خرما	۱۲ عدد	SWEET	0
68	7	26	میوه خشک و عسل	۲۵۰ گرم	SWEET	0
69	7	\N	کراکر، نان‌چوب و نان باگت	۲۰ عدد	BREAD	0
70	7	\N	دیپ زیتون، پنیر و انار	۳ کاسه	DIP	0
71	7	\N	میوه فصل تازه	۴۰ گرم	FRUIT	0
72	8	\N	پنیرهای کهنه، ترافل و خامه‌ای	۶۰۰ گرم	SAVORY	0
73	8	\N	زیتون‌های مارینیت سه‌رنگ	۳۵۰ گرم	SAVORY	0
74	8	\N	کالدکات دودی، رژیون و بوقلمون	۴۰۰ گرم	SAVORY	0
75	8	\N	خیارشور، سبزی و تربچه	۳۰۰ گرم	SAVORY	0
76	8	18	پسته اکبری، گردو و بادام هندی	۴۰۰ گرم	NUTS	0
77	8	6	خرما مجول و پیارم	۴۵۰ گرم	SWEET	0
78	8	7	شکلات دست‌ساز با ورق طلا	۲۰ عدد	SWEET	0
79	8	27	میوه خشک، عسل و مربا	۴۰۰ گرم	SWEET	0
80	8	\N	کراکر ژنوس، نان‌چوب و باگت	۳۰ عدد	BREAD	0
81	8	\N	دیپ‌های چهارگانه هلسا	۴ کاسه	DIP	0
82	8	\N	میوه فصل و بری	۶۰۰ گرم	FRUIT	0
83	8	\N	مدالیون طلای هلسا، گل طبیعی و کارت پیام	۱ ست	DECORATION	0
102	9	\N	تیرامیسو فنجانی هلسا	۸ عدد	SWEET	0
103	9	\N	مینی چیزکیک نیویورکی	۸ عدد	SWEET	1
104	9	\N	موس شکلات بلژیکی	۶ عدد	SWEET	2
105	9	\N	براونی فاج گردویی	۱۰ عدد	SWEET	3
106	9	\N	رولت شکلاتی هلسا	۸ برش	SWEET	4
107	9	\N	پاناکوتا وانیلی با سس کارامل	۶ عدد	SWEET	5
108	9	\N	مربای آلبالو و مربای به هلسا	۲ عدد	SWEET	6
109	9	\N	کراکر شیرینی و نان‌چوب	۱۴ عدد	BREAD	7
110	9	\N	پسته و بادام بوداده	۱۵۰ گرم	NUTS	8
111	9	\N	گل محمدی و پودر کاکائو	تزئین	FRUIT	9
112	10	\N	پنیر فتا و پنیر خامه‌ای	۲۵۰ گرم	SAVORY	0
113	10	\N	خامه سنتی	خامه محلی ۱۵۰ گرم	SAVORY	1
114	10	\N	عسل طبیعی و ارده کنجد	۲۵۰ گرم	SWEET	2
115	10	\N	مربای به، مربای آلبالو و مربای گل محمدی هلسا	۳ عدد	SWEET	3
116	10	\N	کره بادام زمینی و حلوا ارده	۲۰۰ گرم	SWEET	4
117	10	\N	نان تازه مینیاتوری و کراکر	۸ عدد	BREAD	5
118	10	\N	گردو و بادام تازه	۱۵۰ گرم	NUTS	6
119	10	\N	چای لاهیجان و دمنوش بهارنارنج	۲ نفره	FRUIT	7
\.


--
-- Data for Name: mazeh_trays; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mazeh_trays (id, name, slug, sku, short_description, description, image, image_alt, base_price, old_price, cost_price, stock, low_stock_threshold, weight, size, serves_min, serves_max, featured, active, allergens, pairings, occasions, contents, storage, freshness, seo_title, seo_description, archived_at, created_at, updated_at) FROM stdin;
7	سینی مزه هلسا مهمانی	party	TRAY-007	برای ۸ تا ۱۲ نفر؛ ستاره میز مهمانی شما	سینی بزرگ مهمانی با تنوع ۱۴ قلم؛ از پنیر و زیتون تا کالدکات، مغزها، خرما، شکلات و میوه فصل. چیدمان لایه‌ای با ارتفاع‌گذاری که میز را باشکوه می‌کند.	/images/opt/party.jpg	سینی مزه هلسا مهمانی شامل اقلام پذیرایی هلسا	2950000	3300000	\N	8	2	\N	بزرگ	8	12	t	t	["مغزها", "لبنیات", "گلوتن"]	["موکتل مرکبات", "چای زعفرانی", "قهوه"]	["مهمانی خانوادگی", "تولد", "یلدا"]	[{"qty": "۴۰۰ گرم", "title": "سه نوع پنیر منتخب", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "زیتون سبز و سیاه", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "کالدکات و رژیون", "section": "SAVORY"}, {"qty": "۲۰۰ گرم", "title": "خیارشور و سبزیجات تازه", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "آجیل ممتاز شب‌چره", "section": "NUTS", "productId": 13}, {"qty": "۳۰۰ گرم", "title": "خرما پیارم و کبکاب", "section": "SWEET", "productId": 1}, {"qty": "۱۲ عدد", "title": "شکلات دست‌ساز خرما", "section": "SWEET", "productId": 7}, {"qty": "۲۵۰ گرم", "title": "میوه خشک و عسل", "section": "SWEET", "productId": 26}, {"qty": "۲۰ عدد", "title": "کراکر، نان‌چوب و نان باگت", "section": "BREAD"}, {"qty": "۳ کاسه", "title": "دیپ زیتون، پنیر و انار", "section": "DIP"}, {"qty": "۴۰ گرم", "title": "میوه فصل تازه", "section": "FRUIT"}]	یخچال؛ دیپ‌ها جداگانه	مصرف تا ۲۴ ساعت پس از تحویل	سینی مزه هلسا مهمانی | سفارش سینی مزه هلسا	برای ۸ تا ۱۲ نفر؛ ستاره میز مهمانی شما	\N	2025-06-18 00:00:00	2026-09-13 10:32:57.802
2	سینی مزه هلسا طلایی	golden	TRAY-002	نسخه VIP با پنیرهای خاص، مغزهای درشت و شکلات دست‌ساز	سینی طلایی برای میزبان‌هایی است که جز بهترین را نمی‌پسندند؛ پنیرهای کهنه و خامه‌ای منتخب، کالدکات‌های درجه یک، پسته اکبری، خرما مجول و شکلات دست‌ساز خرما با ورق طلا، روی تخته چوب گردو با مدالیون طلای هلسا.	/images/opt/golden.jpg	سینی مزه هلسا طلایی شامل اقلام پذیرایی هلسا	3450000	3900000	\N	8	2	\N	بزرگ	6	10	t	t	["مغزها", "لبنیات", "گلوتن", "سویا"]	["قهوه اسپشیالتی", "موکتل انار و رزماری", "چای زعفرانی"]	["پذیرایی VIP", "عروسی", "هدیه"]	[{"qty": "۳۵۰ گرم", "title": "پنیر کهنه، گودا و پنیر ترافل", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "زیتون مارینیت شده با مرکبات", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "کالدکات دودی و رژیون مرغ", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "پسته اکبری و مغز گردوی سفید", "section": "NUTS", "productId": 18}, {"qty": "۲۵۰ گرم", "title": "خرما مجول سلطنتی", "section": "SWEET", "productId": 6}, {"qty": "۱۰ عدد", "title": "شکلات دست‌ساز با ورق طلا", "section": "SWEET", "productId": 7}, {"qty": "۱۵۰ گرم", "title": "عسل طبیعی گون با شان", "section": "SWEET", "productId": 27}, {"qty": "۱۸ عدد", "title": "کراکر ژنوس و نان‌چوب زعفرانی", "section": "BREAD"}, {"qty": "۲ کاسه", "title": "دیپ انار و دیپ زعفران", "section": "DIP"}, {"qty": "۳۰ گرم", "title": "انگور، انجیر تازه و بری", "section": "FRUIT"}, {"qty": "۱ ست", "title": "مدالیون طلای هلسا و گل طبیعی", "section": "DECORATION"}]	یخچال (۲ تا ۶ درجه)؛ اقلام تازه روز ارسال چیده می‌شوند	بهترین زمان مصرف تا ۲۴ ساعت پس از تحویل	سینی مزه هلسا طلایی | سفارش سینی مزه هلسا	نسخه VIP با پنیرهای خاص، مغزهای درشت و شکلات دست‌ساز	\N	2025-06-01 00:00:00	2026-09-13 10:32:57.803
4	سینی مزه هلسا شیرین و شور	sweet-savory	TRAY-004	دو دنیای طعم در یک سینی؛ تعادل هنرمندانه شور و شیرین	نیمی از سینی به شورها اختصاص دارد؛ پنیر، زیتون، کالدکات و کراکر، و نیم دیگر به شیرین‌ها؛ خرما، شکلات خرمایی، میوه خشک، عسل و شیرینی طبیعی. برای کسانی که هرگز نمی‌توانند بین این دو انتخاب کنند.	/images/opt/sweet-savory.jpg	سینی مزه هلسا شیرین و شور شامل اقلام پذیرایی هلسا	2350000	2650000	\N	8	2	\N	بزرگ	6	8	f	t	["مغزها", "لبنیات", "گلوتن"]	["قهوه لاته", "چای ماسالا", "آبمیوه انار"]	["تولد", "دورهمی", "هدیه"]	[{"qty": "۲۵۰ گرم", "title": "پنیر چدار و پنیر خامه‌ای", "section": "SAVORY"}, {"qty": "۲۰۰ گرم", "title": "زیتون و خیارشور خلالی", "section": "SAVORY"}, {"qty": "۱۸۰ گرم", "title": "کالدکات مرغ و بوقلمون", "section": "SAVORY"}, {"qty": "۱۴ عدد", "title": "کراکر نمکی و نان‌چوب", "section": "BREAD"}, {"qty": "۲۵۰ گرم", "title": "خرما پیارم و مجول", "section": "SWEET", "productId": 1}, {"qty": "۱۲ عدد", "title": "شکلات خرمایی و شیرینی طبیعی", "section": "SWEET", "productId": 12}, {"qty": "۱۸۰ گرم", "title": "میوه خشک مخلوط", "section": "SWEET", "productId": 26}, {"qty": "۲ کاسه", "title": "عسل و مربای توت‌فرنگی", "section": "SWEET", "productId": 27}, {"qty": "۱۵۰ گرم", "title": "بادام هندی و پسته", "section": "NUTS", "productId": 13}, {"qty": "۲۵۰ گرم", "title": "انگور و پرتقال خلالی", "section": "FRUIT"}]	یخچال (۲ تا ۶ درجه)	مصرف تا ۲۴ ساعت پس از تحویل	سینی مزه هلسا شیرین و شور | سفارش سینی مزه هلسا	دو دنیای طعم در یک سینی؛ تعادل هنرمندانه شور و شیرین	\N	2025-06-10 00:00:00	2026-09-13 10:32:57.804
1	سینی مزه هلسا کلاسیک	classic	TRAY-001	تعادل کامل شور و شیرین برای پذیرایی هر روزِ خاص	سینی کلاسیک هلسا نقطه شروع دنیای مزه‌هاست؛ ترکیبی متعادل از پنیر، زیتون، مغزها، خرما و میوه خشک که با کراکر تازه و دیپ‌های دست‌ساز کامل می‌شود. برای دورهمی‌های صمیمی و پذیرایی عصرانه طراحی شده است.	/images/opt/classic.jpg	سینی مزه هلسا کلاسیک شامل اقلام پذیرایی هلسا	1850000	2100000	\N	8	2	\N	متوسط	4	6	t	t	["مغزها", "لبنیات", "گلوتن"]	["چای سیاه لاهیجان", "قهوه ترک", "موکتل لیمو و نعنا"]	["دورهمی", "مهمانی خانوادگی", "جلسه کاری"]	[{"qty": "۲۵۰ گرم", "title": "پنیر لیقوان و پنیر خامه‌ای", "section": "SAVORY"}, {"qty": "۲۰۰ گرم", "title": "زیتون سبز و سیاه پرورده", "section": "SAVORY"}, {"qty": "۱۵۰ گرم", "title": "رولت کالباس بوقلمون دودی", "section": "SAVORY"}, {"qty": "۱۵۰ گرم", "title": "پسته و بادام درختی", "section": "NUTS", "productId": 13}, {"qty": "۲۰۰ گرم", "title": "خرما پیارم هلسا", "section": "SWEET", "productId": 1}, {"qty": "۶ عدد", "title": "شکلات دست‌ساز خرما", "section": "SWEET", "productId": 7}, {"qty": "۱۵۰ گرم", "title": "انجیر خشک و برگه زردآلو", "section": "SWEET", "productId": 21}, {"qty": "۱۲ عدد", "title": "کراکر و نان‌چوب", "section": "BREAD"}, {"qty": "۲ کاسه", "title": "دیپ زیتون و دیپ پنیر", "section": "DIP"}, {"qty": "۲۰ گرم", "title": "انگور و توت‌فرنگی تازه", "section": "FRUIT"}, {"qty": "۱ ست", "title": "مدالیون طلاکوب هلسا و شاخه رزماری", "section": "DECORATION"}]	یخچال (۲ تا ۶ درجه)؛ حداکثر ۲۴ ساعت پس از تحویل مصرف شود	آماده‌سازی در روز ارسال؛ بهترین زمان مصرف تا ۲۴ ساعت پس از تحویل	سینی مزه هلسا کلاسیک | سفارش سینی مزه هلسا	تعادل کامل شور و شیرین برای پذیرایی هر روزِ خاص	\N	2025-06-01 00:00:00	2026-09-13 10:32:57.801
8	سینی مزه هلسا VIP	vip	TRAY-008	برای ۱۲ تا ۲۰ نفر؛ پذیرایی در حد یک رویداد	بزرگ‌ترین و باشکوه‌ترین سینی هلسا؛ چیدمان چندلایه روی تخته چوب گردوی یکپارچه با مدالیون طلای هلسا، پنیرهای خاص، کالدکات‌های درجه یک، مغزهای درشت، خرما مجول، شکلات ورق‌طلا و میوه‌های منتخب فصل. همراه با کارت شخصی‌سازی پیام میزبان.	/images/tray-vip.jpg	سینی مزه هلسا VIP شامل اقلام پذیرایی هلسا	5450000	6200000	\N	8	2	\N	VIP	12	20	t	t	["مغزها", "لبنیات", "گلوتن", "سویا"]	["موکتل انار و رزماری", "قهوه اسپشیالتی", "چای زعفرانی", "نوشیدنی گازدار لیمو"]	["عروسی", "پذیرایی VIP", "جلسه کاری", "هدیه"]	[{"qty": "۶۰۰ گرم", "title": "پنیرهای کهنه، ترافل و خامه‌ای", "section": "SAVORY"}, {"qty": "۳۵۰ گرم", "title": "زیتون‌های مارینیت سه‌رنگ", "section": "SAVORY"}, {"qty": "۴۰۰ گرم", "title": "کالدکات دودی، رژیون و بوقلمون", "section": "SAVORY"}, {"qty": "۳۰۰ گرم", "title": "خیارشور، سبزی و تربچه", "section": "SAVORY"}, {"qty": "۴۰۰ گرم", "title": "پسته اکبری، گردو و بادام هندی", "section": "NUTS", "productId": 18}, {"qty": "۴۵۰ گرم", "title": "خرما مجول و پیارم", "section": "SWEET", "productId": 6}, {"qty": "۲۰ عدد", "title": "شکلات دست‌ساز با ورق طلا", "section": "SWEET", "productId": 7}, {"qty": "۴۰۰ گرم", "title": "میوه خشک، عسل و مربا", "section": "SWEET", "productId": 27}, {"qty": "۳۰ عدد", "title": "کراکر ژنوس، نان‌چوب و باگت", "section": "BREAD"}, {"qty": "۴ کاسه", "title": "دیپ‌های چهارگانه هلسا", "section": "DIP"}, {"qty": "۶۰۰ گرم", "title": "میوه فصل و بری", "section": "FRUIT"}, {"qty": "۱ ست", "title": "مدالیون طلای هلسا، گل طبیعی و کارت پیام", "section": "DECORATION"}]	یخچال؛ تحویل با خودرو یخچال‌دار	چیدمان ساعاتی پیش از رویداد؛ مصرف تا ۲۴ ساعت	سینی مزه هلسا VIP | سفارش سینی مزه هلسا	برای ۱۲ تا ۲۰ نفر؛ پذیرایی در حد یک رویداد	\N	2025-06-20 00:00:00	2026-09-13 10:32:57.803
6	سینی مزه هلسا دورهمی	doromi	TRAY-006	برای ۴ تا ۶ نفر؛ هم‌اندازه یک عصر صمیمی	اندازه‌ای که دقیقاً برای یک دورهمی کوچک کافی است؛ تنوع کامل بدون اسراف. پنیر، زیتون، مغز، خرما، میوه تازه و کراکر با چیدمان فشرده و شیک.	/images/opt/doromi.jpg	سینی مزه هلسا دورهمی شامل اقلام پذیرایی هلسا	1450000	\N	\N	8	2	\N	کوچک	4	6	f	t	["مغزها", "لبنیات", "گلوتن"]	["چای", "قهوه فرانسه", "دوغ سنتی"]	["دورهمی", "جلسه کاری"]	[{"qty": "۲۰۰ گرم", "title": "پنیر خامه‌ای و پنیر سفید", "section": "SAVORY"}, {"qty": "۱۵۰ گرم", "title": "زیتون سبز", "section": "SAVORY"}, {"qty": "۱۲۰ گرم", "title": "آجیل چهارمغز", "section": "NUTS", "productId": 14}, {"qty": "۱۵۰ گرم", "title": "خرما مضافتی", "section": "SWEET", "productId": 2}, {"qty": "۶ عدد", "title": "شکلات خرمایی", "section": "SWEET", "productId": 7}, {"qty": "۱۰۰ گرم", "title": "میوه خشک", "section": "SWEET", "productId": 26}, {"qty": "۱۰ عدد", "title": "کراکر و نان‌چوب", "section": "BREAD"}, {"qty": "۲۰ گرم", "title": "انگور و سیب خلالی", "section": "FRUIT"}]	یخچال	مصرف تا ۲۴ ساعت	سینی مزه هلسا دورهمی | سفارش سینی مزه هلسا	برای ۴ تا ۶ نفر؛ هم‌اندازه یک عصر صمیمی	\N	2025-06-15 00:00:00	2026-09-13 10:32:57.805
10	سینی صبحانه هلسا	breakfast-tray	TRAY-010	صبحانهٔ کامل ایرانی؛ پنیر، خامه، عسل، ارده و مرباهای هلسا	سینی صبحانه هلسا برای مهمانی‌های صبحگاهی و دورهمی‌های آخر هفته: پنیر فتا و خامهٔ سنتی، عسل طبیعی، ارده و حلوا ارده، کره بادام زمینی، مرباهای به، آلبالو و گل محمدی هلسا، نان تازهٔ مینیاتوری، گردو و بادام تازه و چای لاهیجان با دمنوش بهارنارنج.	/images/opt/breakfast-tray.jpg	سینی صبحانه هلسا با پنیر، عسل، مربا و نان تازه	2150000	\N	\N	8	2	\N	متوسط	4	6	f	t	["gluten", "nuts", "dairy", "egg"]	[]	[]	[{"qty": "۲۵۰ گرم", "title": "پنیر فتا و پنیر خامه‌ای", "section": "SAVORY"}, {"qty": "خامه محلی ۱۵۰ گرم", "title": "خامه سنتی", "section": "SAVORY"}, {"qty": "۲۵۰ گرم", "title": "عسل طبیعی و ارده کنجد", "section": "SWEET"}, {"qty": "۳ عدد", "title": "مربای به، مربای آلبالو و مربای گل محمدی هلسا", "section": "SWEET"}, {"qty": "۲۰۰ گرم", "title": "کره بادام زمینی و حلوا ارده", "section": "SWEET"}, {"qty": "۸ عدد", "title": "نان تازه مینیاتوری و کراکر", "section": "BREAD"}, {"qty": "۱۵۰ گرم", "title": "گردو و بادام تازه", "section": "NUTS"}, {"qty": "۲ نفره", "title": "چای لاهیجان و دمنوش بهارنارنج", "section": "FRUIT"}]	تحویل سرد؛ اقلام یخچالی تا ۲۴ ساعت	روز تحویل تازه آماده می‌شود	سینی صبحانه هلسا | سفارش آنلاین هلسا	صبحانهٔ کامل ایرانی؛ پنیر، خامه، عسل، ارده و مرباهای هلسا	\N	2026-09-13 10:34:16.988556	2026-09-13 10:34:30.111
9	سینی مزه هلسا دسر و شیرینی	dessert-sweets	TRAY-009	جشنوارهٔ دسر؛ تیرامیسو، چیزکیک، موس و براونی در یک چیدمان لوکس	سینی دسر و شیرینی هلسا برای تولد، سالگرد و مهمانی‌های چای‌بر اساس سلیقه. شامل تیرامیسو فنجانی، مینی‌چیزکیک نیویورکی، موس شکلات بلژیکی، براونی فاج گردویی، رولت شکلاتی و پاناکوتا وانیلی، همراه با مرباهای خانگی هلسا، کراکر شیرینی، پسته و بادام بوداده و تزئین گل محمدی. تمام اقلام روزِ تحویل به‌صورت تازه آماده می‌شوند.	/images/opt/dessert-tray.jpg	سینی دسر و شیرینی هلسا شامل تیرامیسو، چیزکیک و موس شکلاتی	2850000	\N	\N	8	2	\N	بزرگ	6	10	t	t	["gluten", "nuts", "dairy", "egg"]	[]	[]	[{"qty": "۸ عدد", "title": "تیرامیسو فنجانی هلسا", "section": "SWEET"}, {"qty": "۸ عدد", "title": "مینی چیزکیک نیویورکی", "section": "SWEET"}, {"qty": "۶ عدد", "title": "موس شکلات بلژیکی", "section": "SWEET"}, {"qty": "۱۰ عدد", "title": "براونی فاج گردویی", "section": "SWEET"}, {"qty": "۸ برش", "title": "رولت شکلاتی هلسا", "section": "SWEET"}, {"qty": "۶ عدد", "title": "پاناکوتا وانیلی با سس کارامل", "section": "SWEET"}, {"qty": "۲ عدد", "title": "مربای آلبالو و مربای به هلسا", "section": "SWEET"}, {"qty": "۱۴ عدد", "title": "کراکر شیرینی و نان‌چوب", "section": "BREAD"}, {"qty": "۱۵۰ گرم", "title": "پسته و بادام بوداده", "section": "NUTS"}, {"qty": "تزئین", "title": "گل محمدی و پودر کاکائو", "section": "FRUIT"}]	کمتر از ۴ ساعت در دمای اتاق؛ سپس یخچال	روز تحویل تازه آماده می‌شود	سینی مزه هلسا دسر و شیرینی | سفارش آنلاین هلسا	جشنوارهٔ دسر؛ تیرامیسو، چیزکیک، موس و براونی در یک چیدمان لوکس	\N	2026-09-13 10:34:16.98024	2026-09-13 10:34:30.101
5	سینی مزه هلسا خرما و شکلات	dates-chocolate	TRAY-005	امضای شیرین هلسا؛ مخصوص چای، قهوه و لحظه‌های دنج	سینی امضای هلسا برای عاشقان خرما؛ پیارم و مجول، خرمای شکفته با گردو، شکلات دست‌ساز خرما، قند خرما و میوه خشک، کنار عسل طبیعی و مغزها. همراه ایده‌آل برای عصرانه، قهوه و دسر.	/images/opt/date-chocolate.jpg	سینی مزه هلسا خرما و شکلات شامل اقلام پذیرایی هلسا	1950000	2200000	\N	8	2	\N	متوسط	4	6	t	t	["مغزها", "لبنیات", "سویا"]	["قهوه ترک", "چای سیاه", "شیر کاکائو طبیعی"]	["هدیه", "دورهمی", "یلدا"]	[{"qty": "۲۵۰ گرم", "title": "خرما پیارم هلسا", "section": "SWEET", "productId": 1}, {"qty": "۲۰۰ گرم", "title": "خرما مجول سلطنتی", "section": "SWEET", "productId": 6}, {"qty": "۱۵۰ گرم", "title": "خرمای شکفته با گردو", "section": "SWEET"}, {"qty": "۱۰ عدد", "title": "شکلات دست‌ساز خرما", "section": "SWEET", "productId": 7}, {"qty": "۱ ست", "title": "قند خرما و پودر خرما", "section": "SWEET", "productId": 9}, {"qty": "۱۵۰ گرم", "title": "میوه خشک منتخب", "section": "SWEET", "productId": 26}, {"qty": "۱۵۰ گرم", "title": "پسته و بادام هندی", "section": "NUTS", "productId": 18}, {"qty": "۱ کاسه", "title": "عسل طبیعی گون", "section": "SWEET", "productId": 27}, {"qty": "۱۰ عدد", "title": "کراکر شیرین و بیسکویت کره‌ای", "section": "BREAD"}, {"qty": "۱ عدد", "title": "مدالیون شکلاتی هلسا", "section": "DECORATION"}]	دمای ۱۸ تا ۲ درجه برای شکلات؛ خرما در یخچال	شکلات‌ها هفتگی تولید می‌شوند؛ بهترین مصرف تا ۷ روز	سینی مزه هلسا خرما و شکلات | سفارش سینی مزه هلسا	امضای شیرین هلسا؛ مخصوص چای، قهوه و لحظه‌های دنج	\N	2025-06-12 00:00:00	2026-09-13 10:32:57.8
3	سینی مزه هلسا ایرانی	iranian	TRAY-003	پذیرایی ایرانی با پنیر لیقوان، سبزی تازه و نان سنتی	روایت هلسا از سفره ایرانی؛ پنیر لیقوان با گردو، زیتون پرورده شمال، سبزی خوردن تازه، نان سنگک و کراکر سنتی، کنار خرما، کشمش، انجیر و توت خشک. چیدمان مدرن با ظرف مسی و ترمه یزد.	/images/opt/tray-iranian.jpg	سینی مزه هلسا ایرانی شامل اقلام پذیرایی هلسا	2150000	\N	\N	8	2	\N	متوسط	4	8	t	t	["مغزها", "لبنیات", "گلوتن"]	["چای سیاه با نبات", "عرق بیدمشک", "دمنوش گل‌گاوزبان"]	["نوروز", "رمضان", "مهمانی خانوادگی"]	[{"qty": "۳۰۰ گرم", "title": "پنیر لیقوان با گردو", "section": "SAVORY"}, {"qty": "۲۰۰ گرم", "title": "زیتون پرورده گیلان", "section": "SAVORY"}, {"qty": "۱ دسته", "title": "سبزی خوردن تازه و تربچه", "section": "SAVORY"}, {"qty": "۲۰۰ گرم", "title": "پسته، بادام و فندق", "section": "NUTS", "productId": 14}, {"qty": "۲۵۰ گرم", "title": "خرما مضافتی بم", "section": "SWEET", "productId": 2}, {"qty": "۲۰۰ گرم", "title": "کشمش، انجیر و توت خشک", "section": "SWEET", "productId": 26}, {"qty": "۲ کاسه", "title": "عسل و شیره انگور", "section": "SWEET", "productId": 27}, {"qty": "۱ ست", "title": "نان سنگک و کراکر سنتی", "section": "BREAD"}, {"qty": "۲ کاسه", "title": "مربی بالنگ و مربا گل محمدی", "section": "DIP"}, {"qty": "۱ عدد", "title": "مدالیون مسی هلسا با نقش ترمه", "section": "DECORATION"}]	یخچال؛ سبزیجات جداگانه در بسته مرطوب	چیدمان صبح روز ارسال؛ مصرف تا ۲۴ ساعت	سینی مزه هلسا ایرانی | سفارش سینی مزه هلسا	پذیرایی ایرانی با پنیر لیقوان، سبزی تازه و نان سنتی	\N	2025-06-05 00:00:00	2026-09-13 10:32:57.797
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_items (id, order_id, product_id, tray_id, variant_id, item_type, name_snapshot, sku_snapshot, unit_price, quantity, subtotal, metadata, created_at) FROM stdin;
1	1	2	\N	\N	product	خرما مضافتی	HLA-0002	320000	1	320000	{"unit": "بسته", "weight": "۱ کیلوگرم"}	2026-09-11 22:19:16.128411
2	2	\N	\N	\N	custom-tray	سینی مزه سفارشی هلسا	QUOTE-5	6530000	1	6530000	{"config": {"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}, "quoteId": 5}	2026-09-11 22:49:17.157309
3	2	2	\N	55	product	خرما مضافتی - ۲۵۰ گرم	HLA-0002-W250	176000	1	176000	{"unit": "گرم", "flavor": null, "weight": 250}	2026-09-11 22:49:17.157309
4	3	90	\N	\N	product	سماق	CAT-0056	145000	1	145000	{"unit": "بسته", "weight": "250 گرم"}	2026-09-12 07:36:24.051447
5	4	147	\N	\N	product	ارده ویژه هلسا	CAT-0113	310000	1	310000	{"unit": "بسته", "weight": "یک بسته"}	2026-09-12 07:36:43.214275
6	5	147	\N	\N	product	ارده ویژه هلسا	CAT-0113	310000	1	310000	{"unit": "بسته", "weight": "یک بسته"}	2026-09-12 07:37:04.335892
7	6	82	\N	\N	product	ادویه خورشتی	CAT-0048	125000	1	125000	{"unit": "بسته", "weight": "250 گرم"}	2026-09-12 07:38:03.145235
8	7	171	\N	\N	product	شکلات خرمایی مغزدار	CAT-0137	430000	1	430000	{"unit": "بسته", "weight": "یک بسته"}	2026-09-12 07:39:29.263728
9	8	\N	\N	\N	custom-tray	سینی مزه سفارشی هلسا	QUOTE-10	6530000	1	6530000	{"config": {"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}, "quoteId": 10}	2026-09-12 07:40:33.021511
10	8	2	\N	55	product	خرما مضافتی - ۲۵۰ گرم	HLA-0002-W250	176000	1	176000	{"unit": "گرم", "flavor": null, "weight": 250}	2026-09-12 07:40:33.021511
12	10	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 06:23:37.557858
13	10	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 06:23:37.557858
14	11	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 06:34:46.054641
15	11	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 06:34:46.054641
16	12	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 06:37:25.738278
17	12	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 06:37:25.738278
18	13	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 06:53:37.93452
19	13	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 06:53:37.93452
20	14	170	\N	\N	product	شکلات خرمایی	CAT-0136	395000	2	790000	{"unit": "بسته", "weight": "یک بسته"}	2026-09-15 15:19:12.177749
21	15	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 15:40:57.244
22	15	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 15:40:57.244
23	16	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 16:13:16.878491
24	16	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 16:13:16.878491
25	17	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 17:15:38.994911
26	18	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 17:16:36.049619
27	18	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-15 17:16:36.049619
28	19	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-15 18:25:48.567534
29	20	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 07:36:55.173579
30	20	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 07:36:55.173579
31	21	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 07:37:41.132395
32	22	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 09:08:01.37354
33	22	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 09:08:01.37354
34	23	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 09:08:49.205354
35	24	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 09:42:54.068574
36	24	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 09:42:54.068574
37	25	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 09:44:07.618748
38	26	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:01:46.624539
39	27	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:03:24.459325
40	27	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 10:03:24.459325
41	28	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:05:38.640907
42	28	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 10:05:38.640907
43	29	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:21:21.921747
44	29	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 10:21:21.921747
45	30	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:43:09.13784
46	30	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 10:43:09.13784
47	31	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 10:43:50.221563
48	32	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 11:09:42.789365
49	33	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 11:17:49.006336
50	33	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 11:17:49.006336
51	34	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 12:56:24.419665
52	34	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 12:56:24.419665
53	35	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 13:37:20.475694
54	35	7	\N	\N	product	شکلات دست‌ساز خرما	HLA-0007	395000	1	395000	{"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}	2026-09-16 13:37:20.475694
55	36	9	\N	\N	product	قند خرما	HLA-0009	185000	1	185000	{"unit": "بسته", "weight": "۵۰۰ گرم"}	2026-09-16 13:39:05.01206
56	37	1	\N	\N	product	خرما پیارم	HLA-0001	485000	1	485000	{"unit": "بسته", "weight": "۱ کیلوگرم"}	2026-09-16 14:08:21.482633
57	37	13	\N	\N	product	آجیل ممتاز شب‌چره	HLA-0013	890000	1	890000	{"unit": "بسته", "weight": "۱ کیلوگرم"}	2026-09-16 14:08:21.482633
58	38	1	\N	\N	product	خرما پیارم	HLA-0001	485000	1	485000	{"unit": "بسته", "weight": "۱ کیلوگرم"}	2026-09-16 14:10:09.985641
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders (id, code, customer_id, customer, address, items, subtotal, discount, shipping, total, coupon_code, payment_status, payment_method, payment_reference, shipping_method, status, idempotency_key, paid_at, created_at, updated_at, note, is_gift, gift_recipient, gift_message, gift_packaging) FROM stdin;
2	HLA-23A00872	10	{"email": "", "mobile": "09129896265", "lastName": "تستی", "firstName": "سارا"}	{"city": "تهران", "full": "خیابان آزادی، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09129896265", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "custom-quote-5", "sku": "QUOTE-5", "name": "سینی مزه سفارشی هلسا", "category": "mazeh-trays", "itemType": "custom-tray", "metadata": {"config": {"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}, "quoteId": 5}, "quantity": 1, "subtotal": 6530000, "unitPrice": 6530000}, {"key": "p-2-v-55", "sku": "HLA-0002-W250", "name": "خرما مضافتی - ۲۵۰ گرم", "category": "dates", "itemType": "product", "metadata": {"unit": "گرم", "flavor": null, "weight": 250}, "quantity": 1, "subtotal": 176000, "productId": 2, "unitPrice": 176000, "variantId": 55}]	6706000	0	0	6706000	\N	pending	cod	\N	express	pending	9bdcd682-5095-4a7f-a553-aaaa91c831d9	\N	2026-09-11 22:49:17.157309	2026-09-11 22:49:17.168	\N	f	\N	\N	f
3	HLA-38AF1518	12	{"email": "psp-98583@helsa-test.ir", "mobile": "09123308583", "lastName": "تستی", "firstName": "پرداخت"}	{"city": "تهران", "full": "خیابان تست پرداخت، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09123308583", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "پرداخت تستی"}	[{"key": "p-90", "sku": "CAT-0056", "name": "سماق", "category": "spices", "itemType": "product", "metadata": {"unit": "بسته", "weight": "250 گرم"}, "quantity": 1, "subtotal": 145000, "productId": 90, "unitPrice": 145000}]	145000	0	85000	230000	\N	pending	cod	\N	standard	pending	qa-psp-98583-A	\N	2026-09-12 07:36:24.051447	2026-09-12 07:36:24.064	\N	f	\N	\N	f
6	HLA-5914BE87	17	{"email": "psp-98683@helsa-test.ir", "mobile": "09123308683", "lastName": "تستی", "firstName": "پرداخت"}	{"city": "تهران", "full": "خیابان تست پرداخت، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09123308683", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "پرداخت تستی"}	[{"key": "p-82", "sku": "CAT-0048", "name": "ادویه خورشتی", "category": "spices", "itemType": "product", "metadata": {"unit": "بسته", "weight": "250 گرم"}, "quantity": 1, "subtotal": 125000, "productId": 82, "unitPrice": 125000}]	125000	0	85000	210000	\N	pending	online	\N	standard	cancelled	qa-psp-98683-A	\N	2026-09-12 07:38:03.145235	2026-09-12 07:39:12.391	\N	f	\N	\N	f
5	HLA-16F459B9	14	{"email": "psp-98603@helsa-test.ir", "mobile": "09123308603", "lastName": "تستی", "firstName": "پرداخت"}	{"city": "تهران", "full": "خیابان تست پرداخت، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09123308603", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "پرداخت تستی"}	[{"key": "p-147", "sku": "CAT-0113", "name": "ارده ویژه هلسا", "category": "tahini", "itemType": "product", "metadata": {"unit": "بسته", "weight": "یک بسته"}, "quantity": 1, "subtotal": 310000, "productId": 147, "unitPrice": 310000}]	310000	0	85000	395000	\N	pending	online	\N	standard	cancelled	qa-psp-98603-B	\N	2026-09-12 07:37:04.335892	2026-09-12 07:39:12.407	\N	f	\N	\N	f
4	HLA-7E42375D	14	{"email": "psp-98603@helsa-test.ir", "mobile": "09123308603", "lastName": "تستی", "firstName": "پرداخت"}	{"city": "تهران", "full": "خیابان تست پرداخت، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09123308603", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "پرداخت تستی"}	[{"key": "p-147", "sku": "CAT-0113", "name": "ارده ویژه هلسا", "category": "tahini", "itemType": "product", "metadata": {"unit": "بسته", "weight": "یک بسته"}, "quantity": 1, "subtotal": 310000, "productId": 147, "unitPrice": 310000}]	310000	0	85000	395000	\N	pending	online	\N	standard	cancelled	qa-psp-98603-A	\N	2026-09-12 07:36:43.214275	2026-09-12 07:39:12.42	\N	f	\N	\N	f
7	HLA-D09A92BC	19	{"email": "psp-98769@helsa-test.ir", "mobile": "09123308769", "lastName": "تستی", "firstName": "پرداخت"}	{"city": "تهران", "full": "خیابان تست پرداخت، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09123308769", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "پرداخت تستی"}	[{"key": "p-171", "sku": "CAT-0137", "name": "شکلات خرمایی مغزدار", "category": "date-chocolate", "itemType": "product", "metadata": {"unit": "بسته", "weight": "یک بسته"}, "quantity": 1, "subtotal": 430000, "productId": 171, "unitPrice": 430000}]	430000	0	85000	515000	\N	pending	cod	\N	standard	pending	qa-psp-98769-A	\N	2026-09-12 07:39:29.263728	2026-09-12 07:39:29.271	\N	f	\N	\N	f
8	HLA-10A2E42F	21	{"email": "", "mobile": "09121770849", "lastName": "تستی", "firstName": "سارا"}	{"city": "تهران", "full": "خیابان آزادی، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09121770849", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "custom-quote-10", "sku": "QUOTE-10", "name": "سینی مزه سفارشی هلسا", "category": "mazeh-trays", "itemType": "custom-tray", "metadata": {"config": {"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}, "quoteId": 10}, "quantity": 1, "subtotal": 6530000, "unitPrice": 6530000}, {"key": "p-2-v-55", "sku": "HLA-0002-W250", "name": "خرما مضافتی - ۲۵۰ گرم", "category": "dates", "itemType": "product", "metadata": {"unit": "گرم", "flavor": null, "weight": 250}, "quantity": 1, "subtotal": 176000, "productId": 2, "unitPrice": 176000, "variantId": 55}]	6706000	0	0	6706000	\N	pending	cod	\N	express	pending	6f9a9948-29b3-473a-bd82-c08ca891e30d	\N	2026-09-12 07:40:33.021511	2026-09-12 16:12:12.689527	\N	f	\N	\N	f
14	HLA-99A5A57D	30	{"email": "", "mobile": "09122401213", "lastName": "تست", "firstName": "ممیز", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان تست، پلاک ۱", "unit": "", "label": "منزل", "phone": "09122401213", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "ممیز تست"}	[{"key": "p-170", "sku": "CAT-0136", "name": "شکلات خرمایی", "category": "date-chocolate", "itemType": "product", "metadata": {"unit": "بسته", "weight": "یک بسته"}, "quantity": 2, "subtotal": 790000, "productId": 170, "unitPrice": 395000}]	790000	0	85000	875000	\N	pending	cod	\N	standard	pending	1bd21311-2d22-46ee-8a07-0fc0b1e839c0	\N	2026-09-15 15:19:12.177749	2026-09-15 15:19:12.185	\N	f	\N	\N	f
17	HLA-1829C204	34	{"email": "", "mobile": "09124315224", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09124315224", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	efb85fdc-1cdd-4f48-88fd-8bf9135d7cd9	\N	2026-09-15 17:15:38.994911	2026-09-15 17:15:39.005	\N	f	\N	\N	f
19	HLA-ED52EE9F	36	{"email": "", "mobile": "09124805726", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09124805726", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	3516b15f-3edc-4432-a382-fdbb1550c059	\N	2026-09-15 18:25:48.567534	2026-09-15 18:25:48.58	\N	f	\N	\N	f
21	HLA-38DEDF17	38	{"email": "", "mobile": "09124754798", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09124754798", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	7af828bd-d5f4-4401-be9c-ce289f015dc6	\N	2026-09-16 07:37:41.132395	2026-09-16 07:37:41.148	\N	f	\N	\N	f
10	HLA-1F936E35	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	005ba7bb-6a1d-40c6-8998-ee403db0b71d	\N	2026-09-15 06:23:37.557858	2026-09-15 06:23:37.568	\N	f	\N	\N	f
23	HLA-9589313A	40	{"email": "", "mobile": "09121807183", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09121807183", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	3b2ed8ae-3700-45bf-8fd1-d9a1790855bc	\N	2026-09-16 09:08:49.205354	2026-09-16 09:08:49.219	\N	f	\N	\N	f
25	HLA-F65EF566	42	{"email": "", "mobile": "09121623130", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09121623130", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	0cb2aac6-8438-418a-ba72-8b2a67c2e853	\N	2026-09-16 09:44:07.618748	2026-09-16 09:44:07.627	\N	f	\N	\N	f
26	HLA-1AAD987E	43	{"email": "", "mobile": "09124213312", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09124213312", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	7427f54b-5189-4ceb-a349-9bc37d6b2663	\N	2026-09-16 10:01:46.624539	2026-09-16 10:01:46.635	\N	f	\N	\N	f
11	HLA-77E305BF	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	cbcd1cb7-26b9-4680-84ad-60ea5662c4c1	\N	2026-09-15 06:34:46.054641	2026-09-15 06:34:46.064	\N	f	\N	\N	f
31	HLA-001AE12D	48	{"email": "", "mobile": "09127995594", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09127995594", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	61bf504b-aa42-4459-9895-bd414f5948a4	\N	2026-09-16 10:43:50.221563	2026-09-16 10:43:50.228	\N	f	\N	\N	f
1	HLA-B0EC6B31	\N	{"email": "sara.qa@helsa-test.ir", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا"}	{"city": "تهران", "full": "خیابان هلسا، پلاک ۵", "unit": "2", "label": "منزل", "phone": "09125556677", "plate": "5", "postal": "1234567890", "default": true, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-2", "sku": "HLA-0002", "name": "خرما مضافتی", "category": "dates", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۱ کیلوگرم"}, "quantity": 1, "subtotal": 320000, "productId": 2, "unitPrice": 320000}]	320000	0	85000	405000	\N	paid	cod	\N	standard	delivered	qa-admin-1789165156	2026-09-11 22:19:16.168	2026-09-11 22:19:16.128411	2026-09-12 07:41:00.181	\N	f	\N	\N	f
15	HLA-DB4D3856	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	ed06c6e7-6b97-482c-bf79-99a9c4c796b8	\N	2026-09-15 15:40:57.244	2026-09-15 15:40:57.253	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
12	HLA-6F330042	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	ae752576-cbd5-4e55-ac6a-670797f1e5be	\N	2026-09-15 06:37:25.738278	2026-09-15 06:37:25.748	لطفاً برای هدیه ارسال شود — تست ج۳۹	f	\N	\N	f
13	HLA-77800158	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	469644dd-c500-410b-8aa6-98df22d5980a	\N	2026-09-15 06:53:37.93452	2026-09-15 06:53:37.943	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
16	HLA-E24FF992	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	1117514e-c5dc-4744-9a0b-5056af455279	\N	2026-09-15 16:13:16.878491	2026-09-15 16:13:16.886	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
18	HLA-78FB7C40	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	45f87a29-ab01-405b-9900-3868018418d0	\N	2026-09-15 17:16:36.049619	2026-09-15 17:16:36.058	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
20	HLA-FEAF70F7	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	2868a026-6d6c-456a-bc6d-a9a908e32412	\N	2026-09-16 07:36:55.173579	2026-09-16 07:36:55.183	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
22	HLA-C0BD6D43	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	adacaf57-0597-4993-9390-bfb01fdf898f	\N	2026-09-16 09:08:01.37354	2026-09-16 09:08:01.382	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
24	HLA-BB504D3E	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	b37bce78-41ce-42a4-b070-6a892116ff46	\N	2026-09-16 09:42:54.068574	2026-09-16 09:42:54.099	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
27	HLA-F3D2F7A3	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	fb764905-abaa-4da7-8f06-4996a10c2c13	\N	2026-09-16 10:03:24.459325	2026-09-16 10:03:24.466	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
28	HLA-150C56AE	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	bff5a0dc-d459-473c-b83f-fbe2a03dab93	\N	2026-09-16 10:05:38.640907	2026-09-16 10:05:38.649	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
29	HLA-8BAC4FA9	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	22a00d65-b82d-4fda-a328-18b037e3d63f	\N	2026-09-16 10:21:21.921747	2026-09-16 10:21:21.937	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
30	HLA-882DAD54	\N	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	b175249d-83d8-4c60-be2c-6f85d3175034	\N	2026-09-16 10:43:09.13784	2026-09-16 10:43:09.147	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
32	HLA-178C9C5F	62	{"email": "", "mobile": "09125202525", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09125202525", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	0e62b1c4-2254-4d20-9b8b-efb462b1ab14	\N	2026-09-16 11:09:42.789365	2026-09-16 11:09:42.802	\N	f	\N	\N	f
33	HLA-67B6F069	63	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	ca7879d7-1c0b-4b86-bb49-4f61fd8651a6	\N	2026-09-16 11:17:49.006336	2026-09-16 11:17:49.014	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
34	HLA-6F5E1927	63	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	41baf05a-7048-4577-9dcc-a45d1bf2d56b	\N	2026-09-16 12:56:24.419665	2026-09-16 12:56:24.435	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
35	HLA-20F36710	63	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}, {"key": "p-7", "sku": "HLA-0007", "name": "شکلات دست‌ساز خرما", "category": "date-products", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۳۵۰ گرم (۱۴ عدد)"}, "quantity": 1, "subtotal": 395000, "productId": 7, "unitPrice": 395000}]	580000	58000	85000	607000	HELSA10	pending	cod	\N	standard	pending	870b6cb1-ce54-44f4-bf08-e88acfbafcb3	\N	2026-09-16 13:37:20.475694	2026-09-16 13:37:20.491	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
36	HLA-38FED6F4	72	{"email": "", "mobile": "09129931079", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09129931079", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-9", "sku": "HLA-0009", "name": "قند خرما", "category": "date-sugar", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۵۰۰ گرم"}, "quantity": 1, "subtotal": 185000, "productId": 9, "unitPrice": 185000}]	185000	0	85000	270000	\N	pending	cod	\N	standard	pending	b6ff50a8-faa7-42cf-b3d2-fa299b5ac488	\N	2026-09-16 13:39:05.01206	2026-09-16 13:39:05.05	\N	f	\N	\N	f
37	HLA-537025FD	63	{"email": "", "mobile": "09125556677", "lastName": "تستی", "firstName": "سارا", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان ولیعصر، کوچه بهار، پلاک ۱۲", "unit": "", "label": "منزل", "phone": "09125556677", "plate": "", "postal": "1234567890", "default": false, "province": "تهران", "recipient": "سارا تستی"}	[{"key": "p-1", "sku": "HLA-0001", "name": "خرما پیارم", "category": "dates", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۱ کیلوگرم"}, "quantity": 1, "subtotal": 485000, "productId": 1, "unitPrice": 485000}, {"key": "p-13", "sku": "HLA-0013", "name": "آجیل ممتاز شب‌چره", "category": "nuts", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۱ کیلوگرم"}, "quantity": 1, "subtotal": 890000, "productId": 13, "unitPrice": 890000}]	1375000	137500	85000	1322500	HELSA10	pending	cod	\N	standard	pending	facdb480-00bf-4808-9edf-d25fc6785431	\N	2026-09-16 14:08:21.482633	2026-09-16 14:08:21.492	لطفاً برای هدیه ارسال شود — تست ج۳۹	t	خانم محمدی	تبریک تولد از طرف هلسا	t
38	HLA-3F63BB17	74	{"email": "", "mobile": "09126085274", "lastName": "تستی", "firstName": "مهمان", "nationalId": "0012345679", "nidVerified": true, "identityProvider": "checkout"}	{"city": "تهران", "full": "خیابان مهمان، پلاک ۹", "unit": "", "label": "منزل", "phone": "09126085274", "plate": "", "postal": "1111111111", "default": false, "province": "تهران", "recipient": "مهمان تستی"}	[{"key": "p-1", "sku": "HLA-0001", "name": "خرما پیارم", "category": "dates", "itemType": "product", "metadata": {"unit": "بسته", "weight": "۱ کیلوگرم"}, "quantity": 1, "subtotal": 485000, "productId": 1, "unitPrice": 485000}]	485000	0	85000	570000	\N	pending	cod	\N	standard	pending	52f7734c-6da3-46d5-8c98-79269c76d34d	\N	2026-09-16 14:10:09.985641	2026-09-16 14:10:09.994	\N	f	\N	\N	f
\.


--
-- Data for Name: party_packages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.party_packages (id, max_guests, tray_slug, title, note) FROM stdin;
1	4	doromi	سینی مزه کلاسیک / دورهمی	یک سینی کوچک برای عصرهای صمیمی
2	8	classic	سینی مزه کلاسیک	تعادل کامل شور و شیرین
3	12	party	سینی مزه مهمانی	تنوع ۱۴ قلم برای میز بزرگ
4	20	vip	سینی مزه VIP	چیدمان چندلایه با مدالیون طلا
5	999	vip	پذیرایی سازمانی هلسا	چند سینی هماهنگ + تیم چیدمان در محل
\.


--
-- Data for Name: payment_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_logs (id, payment_id, order_id, event, provider, method, amount, authority, detail, created_at) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, order_id, provider, method, amount, status, authority, reference, verified_at, created_at, updated_at, expires_at) FROM stdin;
1	1	manual	cod	405000	pending	\N	\N	\N	2026-09-11 22:19:16.128411	2026-09-11 22:19:16.128411	\N
2	2	manual	cod	6706000	pending	\N	\N	\N	2026-09-11 22:49:17.157309	2026-09-11 22:49:17.157309	\N
3	3	manual	cod	230000	pending	\N	\N	\N	2026-09-12 07:36:24.051447	2026-09-12 07:36:24.051447	\N
4	4	zarinpal	online	395000	pending	\N	\N	\N	2026-09-12 07:36:43.214275	2026-09-12 07:36:43.214275	\N
5	5	zarinpal	online	395000	pending	\N	\N	\N	2026-09-12 07:37:04.335892	2026-09-12 07:37:04.335892	\N
6	6	zarinpal	online	210000	pending	\N	\N	\N	2026-09-12 07:38:03.145235	2026-09-12 07:38:03.145235	\N
7	7	manual	cod	515000	pending	\N	\N	\N	2026-09-12 07:39:29.263728	2026-09-12 07:39:29.263728	\N
8	8	manual	cod	6706000	pending	\N	\N	\N	2026-09-12 07:40:33.021511	2026-09-12 16:12:12.690044	\N
11	10	manual	cod	607000	pending	\N	\N	\N	2026-09-15 06:23:37.557858	2026-09-15 06:23:37.557858	\N
12	11	manual	cod	607000	pending	\N	\N	\N	2026-09-15 06:34:46.054641	2026-09-15 06:34:46.054641	\N
13	12	manual	cod	607000	pending	\N	\N	\N	2026-09-15 06:37:25.738278	2026-09-15 06:37:25.738278	\N
14	13	manual	cod	607000	pending	\N	\N	\N	2026-09-15 06:53:37.93452	2026-09-15 06:53:37.93452	\N
15	14	manual	cod	875000	pending	\N	\N	\N	2026-09-15 15:19:12.177749	2026-09-15 15:19:12.177749	\N
16	15	manual	cod	607000	pending	\N	\N	\N	2026-09-15 15:40:57.244	2026-09-15 15:40:57.244	\N
17	16	manual	cod	607000	pending	\N	\N	\N	2026-09-15 16:13:16.878491	2026-09-15 16:13:16.878491	\N
18	17	manual	cod	270000	pending	\N	\N	\N	2026-09-15 17:15:38.994911	2026-09-15 17:15:38.994911	\N
19	18	manual	cod	607000	pending	\N	\N	\N	2026-09-15 17:16:36.049619	2026-09-15 17:16:36.049619	\N
20	19	manual	cod	270000	pending	\N	\N	\N	2026-09-15 18:25:48.567534	2026-09-15 18:25:48.567534	\N
21	20	manual	cod	607000	pending	\N	\N	\N	2026-09-16 07:36:55.173579	2026-09-16 07:36:55.173579	\N
22	21	manual	cod	270000	pending	\N	\N	\N	2026-09-16 07:37:41.132395	2026-09-16 07:37:41.132395	\N
23	22	manual	cod	607000	pending	\N	\N	\N	2026-09-16 09:08:01.37354	2026-09-16 09:08:01.37354	\N
24	23	manual	cod	270000	pending	\N	\N	\N	2026-09-16 09:08:49.205354	2026-09-16 09:08:49.205354	\N
25	24	manual	cod	607000	pending	\N	\N	\N	2026-09-16 09:42:54.068574	2026-09-16 09:42:54.068574	\N
26	25	manual	cod	270000	pending	\N	\N	\N	2026-09-16 09:44:07.618748	2026-09-16 09:44:07.618748	\N
27	26	manual	cod	270000	pending	\N	\N	\N	2026-09-16 10:01:46.624539	2026-09-16 10:01:46.624539	\N
28	27	manual	cod	607000	pending	\N	\N	\N	2026-09-16 10:03:24.459325	2026-09-16 10:03:24.459325	\N
29	28	manual	cod	607000	pending	\N	\N	\N	2026-09-16 10:05:38.640907	2026-09-16 10:05:38.640907	\N
30	29	manual	cod	607000	pending	\N	\N	\N	2026-09-16 10:21:21.921747	2026-09-16 10:21:21.921747	\N
31	30	manual	cod	607000	pending	\N	\N	\N	2026-09-16 10:43:09.13784	2026-09-16 10:43:09.13784	\N
32	31	manual	cod	270000	pending	\N	\N	\N	2026-09-16 10:43:50.221563	2026-09-16 10:43:50.221563	\N
33	32	manual	cod	270000	pending	\N	\N	\N	2026-09-16 11:09:42.789365	2026-09-16 11:09:42.789365	\N
34	33	manual	cod	607000	pending	\N	\N	\N	2026-09-16 11:17:49.006336	2026-09-16 11:17:49.006336	\N
35	34	manual	cod	607000	pending	\N	\N	\N	2026-09-16 12:56:24.419665	2026-09-16 12:56:24.419665	\N
36	35	manual	cod	607000	pending	\N	\N	\N	2026-09-16 13:37:20.475694	2026-09-16 13:37:20.475694	\N
37	36	manual	cod	270000	pending	\N	\N	\N	2026-09-16 13:39:05.01206	2026-09-16 13:39:05.01206	\N
38	37	manual	cod	1322500	pending	\N	\N	\N	2026-09-16 14:08:21.482633	2026-09-16 14:08:21.482633	\N
39	38	manual	cod	570000	pending	\N	\N	\N	2026-09-16 14:10:09.985641	2026-09-16 14:10:09.985641	\N
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_images (id, product_id, url, alt, is_primary, sort_order, requires_replacement, created_at) FROM stdin;
1	35	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل مخلوط هلسا هلسا	t	0	f	2026-09-11 22:07:58.302185
2	36	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل چهارمغز هلسا	t	0	f	2026-09-11 22:07:58.316783
3	37	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.340206
4	38	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل اقتصادی هلسا	t	0	f	2026-09-11 22:07:58.356585
5	39	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل مهمانی هلسا	t	0	f	2026-09-11 22:07:58.375347
6	40	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل نوروزی هلسا	t	0	f	2026-09-11 22:07:58.392806
7	41	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل شب یلدا هلسا	t	0	f	2026-09-11 22:07:58.401414
8	42	/images/opt/premium-mixed-nuts.jpg	تصویر خشکبار ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.409651
9	43	/images/opt/golden-raisins.jpg	تصویر تخمه کدو هلسا	t	0	f	2026-09-11 22:07:58.419777
10	44	/images/opt/golden-raisins.jpg	تصویر تخمه کدو گوشتی هلسا	t	0	f	2026-09-11 22:07:58.448218
11	45	/images/opt/golden-raisins.jpg	تصویر تخمه آفتابگردان هلسا	t	0	f	2026-09-11 22:07:58.460721
12	46	/images/opt/golden-raisins.jpg	تصویر تخمه ژاپنی هلسا	t	0	f	2026-09-11 22:07:58.471203
13	47	/images/opt/golden-raisins.jpg	تصویر تخمه هندوانه هلسا	t	0	f	2026-09-11 22:07:58.484027
14	48	/images/opt/golden-raisins.jpg	تصویر تخمه شور هلسا	t	0	f	2026-09-11 22:07:58.497478
15	49	/images/opt/golden-raisins.jpg	تصویر تخمه بوداده هلسا	t	0	f	2026-09-11 22:07:58.506034
16	50	/images/opt/golden-raisins.jpg	تصویر تخمه طعم‌دار ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.51469
17	1	/images/opt/medjool-dates.jpg	تصویر خرما پیارم هلسا	t	0	f	2026-09-11 22:07:58.522084
18	2	/images/opt/medjool-dates.jpg	تصویر خرما مضافتی هلسا	t	0	f	2026-09-11 22:07:58.529969
19	3	/images/opt/medjool-dates.jpg	تصویر خرما کبکاب هلسا	t	0	f	2026-09-11 22:07:58.5381
20	4	/images/opt/medjool-dates.jpg	تصویر خرما زاهدی هلسا	t	0	f	2026-09-11 22:07:58.54595
21	5	/images/opt/medjool-dates.jpg	تصویر خرما خاصویی هلسا	t	0	f	2026-09-11 22:07:58.552981
22	6	/images/opt/medjool-dates.jpg	تصویر خرما مجول هلسا	t	0	f	2026-09-11 22:07:58.560975
23	57	/images/opt/natural-gon-honey.jpg	تصویر عسل طبیعی هلسا	t	0	f	2026-09-11 22:07:58.56514
24	58	/images/opt/natural-gon-honey.jpg	تصویر عسل کنار هلسا	t	0	f	2026-09-11 22:07:58.569245
25	59	/images/opt/natural-gon-honey.jpg	تصویر عسل بهارنارنج هلسا	t	0	f	2026-09-11 22:07:58.573355
26	60	/images/opt/natural-gon-honey.jpg	تصویر عسل خلیلو هلسا	t	0	f	2026-09-11 22:07:58.577507
27	61	/images/opt/natural-gon-honey.jpg	تصویر عسل کوهستان هلسا	t	0	f	2026-09-11 22:07:58.581808
28	62	/images/opt/natural-gon-honey.jpg	تصویر عسل ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.585813
29	63	/images/opt/dried-fruit-mix.jpg	تصویر نبات زعفرانی هلسا	t	0	f	2026-09-11 22:07:58.589902
30	64	/images/opt/dried-fruit-mix.jpg	تصویر نبات ساده هلسا	t	0	f	2026-09-11 22:07:58.594259
31	65	/images/opt/dried-fruit-mix.jpg	تصویر نبات چوبی هلسا	t	0	f	2026-09-11 22:07:58.598994
32	66	/images/opt/dried-fruit-mix.jpg	تصویر نبات شاخه‌ای هلسا	t	0	f	2026-09-11 22:07:58.603024
33	67	/images/opt/dried-fruit-mix.jpg	تصویر نبات ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.607017
34	68	/images/opt/dried-fruit-mix.jpg	تصویر زرشک پفکی هلسا	t	0	f	2026-09-11 22:07:58.613977
35	69	/images/opt/dried-fruit-mix.jpg	تصویر زرشک دانه‌اناری هلسا	t	0	f	2026-09-11 22:07:58.620933
36	70	/images/opt/dried-fruit-mix.jpg	تصویر زرشک ممتاز هلسا هلسا	t	0	f	2026-09-11 22:07:58.628561
37	71	/images/opt/premium-mixed-nuts.jpg	تصویر بادام زمینی شور هلسا	t	0	f	2026-09-11 22:07:58.6372
38	72	/images/opt/premium-mixed-nuts.jpg	تصویر بادام زمینی خام هلسا	t	0	f	2026-09-11 22:07:58.647166
39	73	/images/opt/premium-mixed-nuts.jpg	تصویر بادام زمینی بوداده هلسا	t	0	f	2026-09-11 22:07:58.657414
40	74	/images/opt/premium-mixed-nuts.jpg	تصویر بادام زمینی طعم‌دار هلسا	t	0	f	2026-09-11 22:07:58.665085
41	75	/images/opt/dried-fruit-mix.jpg	تصویر آبنبات ساده هلسا	t	0	f	2026-09-11 22:07:58.669261
42	76	/images/opt/dried-fruit-mix.jpg	تصویر آبنبات زعفرانی هلسا	t	0	f	2026-09-11 22:07:58.673482
43	77	/images/opt/dried-fruit-mix.jpg	تصویر آبنبات میوه‌ای هلسا	t	0	f	2026-09-11 22:07:58.677875
44	78	/images/opt/dried-fruit-mix.jpg	تصویر آبنبات مغزدار هلسا	t	0	f	2026-09-11 22:07:58.682266
45	79	/images/opt/dried-fruit-mix.jpg	تصویر آبنبات ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.68642
46	80	/images/opt/saffron-negin.jpg	تصویر ادویه مخصوص هلسا هلسا	t	0	f	2026-09-11 22:07:58.693652
47	81	/images/opt/saffron-negin.jpg	تصویر ادویه پلویی هلسا	t	0	f	2026-09-11 22:07:58.701247
48	82	/images/opt/saffron-negin.jpg	تصویر ادویه خورشتی هلسا	t	0	f	2026-09-11 22:07:58.708193
49	83	/images/opt/saffron-negin.jpg	تصویر ادویه مرغ هلسا	t	0	f	2026-09-11 22:07:58.717741
50	84	/images/opt/saffron-negin.jpg	تصویر ادویه گوشت هلسا	t	0	f	2026-09-11 22:07:58.724791
51	85	/images/opt/saffron-negin.jpg	تصویر فلفل سیاه هلسا	t	0	f	2026-09-11 22:07:58.731978
52	86	/images/opt/saffron-negin.jpg	تصویر فلفل قرمز هلسا	t	0	f	2026-09-11 22:07:58.738853
53	87	/images/opt/saffron-negin.jpg	تصویر زردچوبه هلسا	t	0	f	2026-09-11 22:07:58.746328
54	88	/images/opt/saffron-negin.jpg	تصویر دارچین هلسا	t	0	f	2026-09-11 22:07:58.761648
55	89	/images/opt/saffron-negin.jpg	تصویر گلپر هلسا	t	0	f	2026-09-11 22:07:58.768833
56	90	/images/opt/saffron-negin.jpg	تصویر سماق هلسا	t	0	f	2026-09-11 22:07:58.775541
57	91	/images/opt/saffron-negin.jpg	تصویر ادویه ترکیبی هلسا هلسا	t	0	f	2026-09-11 22:07:58.782296
58	92	/images/opt/lahijan-black-tea.jpg	تصویر عرق نعناع هلسا	t	0	f	2026-09-11 22:07:58.786266
59	93	/images/opt/lahijan-black-tea.jpg	تصویر عرق کاسنی هلسا	t	0	f	2026-09-11 22:07:58.791054
60	94	/images/opt/lahijan-black-tea.jpg	تصویر عرق بهارنارنج هلسا	t	0	f	2026-09-11 22:07:58.795201
61	95	/images/opt/lahijan-black-tea.jpg	تصویر عرق گل محمدی هلسا	t	0	f	2026-09-11 22:07:58.799033
62	33	/images/opt/lahijan-black-tea.jpg	تصویر عرق بیدمشک هلسا	t	0	f	2026-09-11 22:07:58.802945
63	97	/images/opt/lahijan-black-tea.jpg	تصویر عرق شاتره هلسا	t	0	f	2026-09-11 22:07:58.807274
64	98	/images/opt/lahijan-black-tea.jpg	تصویر عرق رازیانه هلسا	t	0	f	2026-09-11 22:07:58.811306
65	99	/images/chocolate-craft.jpg	تصویر شکلات تلخ هلسا	t	0	f	2026-09-11 22:07:58.815296
66	100	/images/chocolate-craft.jpg	تصویر شکلات شیری هلسا	t	0	f	2026-09-11 22:07:58.81941
67	101	/images/chocolate-craft.jpg	تصویر شکلات مغزدار هلسا	t	0	f	2026-09-11 22:07:58.823268
68	102	/images/chocolate-craft.jpg	تصویر شکلات دست‌ساز هلسا هلسا	t	0	f	2026-09-11 22:07:58.827014
69	103	/images/chocolate-craft.jpg	تصویر شکلات ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.830788
70	104	/images/chocolate-craft.jpg	تصویر شکلات پذیرایی هلسا	t	0	f	2026-09-11 22:07:58.834746
71	105	/images/tray-vip.jpg	تصویر پک هدیه هلسا هلسا	t	0	f	2026-09-11 22:07:58.838634
72	106	/images/tray-vip.jpg	تصویر پک پذیرایی هلسا هلسا	t	0	f	2026-09-11 22:07:58.842623
73	107	/images/tray-vip.jpg	تصویر پک صبحانه هلسا هلسا	t	0	f	2026-09-11 22:07:58.846479
74	108	/images/tray-vip.jpg	تصویر پک نوروز هلسا هلسا	t	0	f	2026-09-11 22:07:58.850238
75	109	/images/tray-vip.jpg	تصویر پک یلدای هلسا هلسا	t	0	f	2026-09-11 22:07:58.854601
76	110	/images/tray-vip.jpg	تصویر پک سازمانی هلسا هلسا	t	0	f	2026-09-11 22:07:58.858329
77	111	/images/tray-vip.jpg	تصویر پک ویژه مهمانی هلسا	t	0	f	2026-09-11 22:07:58.862292
78	112	/images/opt/dried-fruit-mix.jpg	تصویر نقل ساده هلسا	t	0	f	2026-09-11 22:07:58.866097
79	113	/images/opt/dried-fruit-mix.jpg	تصویر نقل زعفرانی هلسا	t	0	f	2026-09-11 22:07:58.870331
80	114	/images/opt/dried-fruit-mix.jpg	تصویر نقل بیدمشکی هلسا	t	0	f	2026-09-11 22:07:58.8742
81	115	/images/opt/dried-fruit-mix.jpg	تصویر نقل مغزدار هلسا	t	0	f	2026-09-11 22:07:58.878432
82	116	/images/opt/dried-fruit-mix.jpg	تصویر نقل ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.882295
83	10	/images/opt/natural-gon-honey.jpg	تصویر شیره خرما هلسا	t	0	f	2026-09-11 22:07:58.886191
84	30	/images/opt/natural-gon-honey.jpg	تصویر شیره انگور هلسا	t	0	f	2026-09-11 22:07:58.889991
85	119	/images/opt/natural-gon-honey.jpg	تصویر شیره توت هلسا	t	0	f	2026-09-11 22:07:58.893839
86	120	/images/opt/natural-gon-honey.jpg	تصویر شیره ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.897845
87	121	/images/opt/dried-fruit-mix.jpg	تصویر عدس هلسا	t	0	f	2026-09-11 22:07:58.904235
88	122	/images/opt/dried-fruit-mix.jpg	تصویر نخود هلسا	t	0	f	2026-09-11 22:07:58.910911
89	123	/images/opt/dried-fruit-mix.jpg	تصویر لوبیا قرمز هلسا	t	0	f	2026-09-11 22:07:58.917483
90	124	/images/opt/dried-fruit-mix.jpg	تصویر لوبیا چیتی هلسا	t	0	f	2026-09-11 22:07:58.923979
91	125	/images/opt/dried-fruit-mix.jpg	تصویر لپه هلسا	t	0	f	2026-09-11 22:07:58.930597
92	126	/images/opt/dried-fruit-mix.jpg	تصویر ماش هلسا	t	0	f	2026-09-11 22:07:58.937416
93	127	/images/opt/dried-fruit-mix.jpg	تصویر نخودچی هلسا	t	0	f	2026-09-11 22:07:58.944551
94	128	/images/tray-classic.jpg	تصویر پنیر پذیرایی هلسا	t	0	f	2026-09-11 22:07:58.948481
95	129	/images/tray-classic.jpg	تصویر پنیر سنتی هلسا	t	0	f	2026-09-11 22:07:58.952563
96	130	/images/tray-classic.jpg	تصویر پنیر ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.957459
97	131	/images/tray-classic.jpg	تصویر زیتون سبز هلسا	t	0	f	2026-09-11 22:07:58.961253
98	132	/images/tray-classic.jpg	تصویر زیتون سیاه هلسا	t	0	f	2026-09-11 22:07:58.965218
99	133	/images/tray-classic.jpg	تصویر زیتون بدون هسته هلسا	t	0	f	2026-09-11 22:07:58.969076
100	134	/images/tray-classic.jpg	تصویر زیتون پرورده هلسا	t	0	f	2026-09-11 22:07:58.972876
101	135	/images/tray-classic.jpg	تصویر زیتون ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.976612
102	136	/images/tray-classic.jpg	تصویر ترشی مخلوط هلسا	t	0	f	2026-09-11 22:07:58.980349
103	137	/images/tray-classic.jpg	تصویر ترشی لیته هلسا	t	0	f	2026-09-11 22:07:58.984402
104	138	/images/tray-classic.jpg	تصویر ترشی سیر هلسا	t	0	f	2026-09-11 22:07:58.988105
105	139	/images/tray-classic.jpg	تصویر ترشی ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:58.991895
106	140	/images/chocolate-craft.jpg	تصویر بیسکویت پذیرایی هلسا هلسا	t	0	f	2026-09-11 22:07:58.99583
107	141	/images/chocolate-craft.jpg	تصویر کیک خرمایی هلسا هلسا	t	0	f	2026-09-11 22:07:58.999564
108	142	/images/chocolate-craft.jpg	تصویر کیک خشک هلسا هلسا	t	0	f	2026-09-11 22:07:59.003424
109	143	/images/chocolate-craft.jpg	تصویر بیسکویت خرمایی هلسا	t	0	f	2026-09-11 22:07:59.007213
110	144	/images/chocolate-craft.jpg	تصویر شیرینی خشک ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.01089
111	145	/images/opt/natural-gon-honey.jpg	تصویر ارده سنتی هلسا	t	0	f	2026-09-11 22:07:59.014752
112	29	/images/opt/natural-gon-honey.jpg	تصویر ارده کنجد هلسا	t	0	f	2026-09-11 22:07:59.018557
113	147	/images/opt/natural-gon-honey.jpg	تصویر ارده ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.022455
114	148	/images/opt/premium-mixed-nuts.jpg	تصویر حلوا ارده ساده هلسا	t	0	f	2026-09-11 22:07:59.026473
115	149	/images/opt/premium-mixed-nuts.jpg	تصویر حلوا ارده پسته‌ای هلسا	t	0	f	2026-09-11 22:07:59.030565
116	150	/images/opt/premium-mixed-nuts.jpg	تصویر حلوا ارده ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.034457
117	151	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش گل محمدی هلسا	t	0	f	2026-09-11 22:07:59.038351
118	152	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش بهارنارنج هلسا	t	0	f	2026-09-11 22:07:59.042163
119	153	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش آرامش هلسا	t	0	f	2026-09-11 22:07:59.046214
120	154	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش ترکیبی هلسا هلسا	t	0	f	2026-09-11 22:07:59.050052
121	155	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش میوه‌ای هلسا هلسا	t	0	f	2026-09-11 22:07:59.053829
122	156	/images/opt/lahijan-black-tea.jpg	تصویر دمنوش ویژه پذیرایی هلسا	t	0	f	2026-09-11 22:07:59.057594
123	157	/images/opt/premium-mixed-nuts.jpg	تصویر کره بادام زمینی ساده هلسا	t	0	f	2026-09-11 22:07:59.061421
124	158	/images/opt/premium-mixed-nuts.jpg	تصویر کره بادام زمینی کرانچی هلسا	t	0	f	2026-09-11 22:07:59.065172
125	159	/images/opt/premium-mixed-nuts.jpg	تصویر کره بادام زمینی شکلاتی هلسا	t	0	f	2026-09-11 22:07:59.06915
126	160	/images/opt/premium-mixed-nuts.jpg	تصویر کره بادام زمینی ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.072788
127	161	/images/opt/dried-fruit-mix.jpg	تصویر روغن زیتون هلسا	t	0	f	2026-09-11 22:07:59.076604
128	162	/images/opt/dried-fruit-mix.jpg	تصویر روغن کنجد هلسا	t	0	f	2026-09-11 22:07:59.080324
129	163	/images/opt/dried-fruit-mix.jpg	تصویر روغن زیتون فرابکر هلسا	t	0	f	2026-09-11 22:07:59.084303
130	164	/images/opt/dried-fruit-mix.jpg	تصویر روغن کنجد ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.088127
131	165	/images/opt/lahijan-black-tea.jpg	تصویر غنچه گل محمدی هلسا	t	0	f	2026-09-11 22:07:59.094895
132	166	/images/opt/lahijan-black-tea.jpg	تصویر گل محمدی خشک هلسا	t	0	f	2026-09-11 22:07:59.101492
133	167	/images/opt/lahijan-black-tea.jpg	تصویر غنچه گل محمدی ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.108044
134	9	/images/opt/medjool-dates.jpg	تصویر قند خرما هلسا	t	0	f	2026-09-11 22:07:59.111848
135	169	/images/opt/medjool-dates.jpg	تصویر قند خرما ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.116031
136	170	/images/chocolate-craft.jpg	تصویر شکلات خرمایی هلسا	t	0	f	2026-09-11 22:07:59.120967
137	171	/images/chocolate-craft.jpg	تصویر شکلات خرمایی مغزدار هلسا	t	0	f	2026-09-11 22:07:59.125009
138	172	/images/chocolate-craft.jpg	تصویر شکلات خرمایی نارگیلی هلسا	t	0	f	2026-09-11 22:07:59.129043
139	173	/images/chocolate-craft.jpg	تصویر شکلات خرمایی کنجدی هلسا	t	0	f	2026-09-11 22:07:59.133679
140	174	/images/chocolate-craft.jpg	تصویر شکلات خرمایی ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.137712
141	175	/images/opt/medjool-dates.jpg	تصویر خرما بار هلسا	t	0	f	2026-09-11 22:07:59.141539
142	176	/images/opt/medjool-dates.jpg	تصویر بار خرما و مغزها هلسا	t	0	f	2026-09-11 22:07:59.145541
143	177	/images/opt/medjool-dates.jpg	تصویر بار خرما و کنجد هلسا	t	0	f	2026-09-11 22:07:59.149491
144	178	/images/opt/medjool-dates.jpg	تصویر بار خرما و شکلات هلسا	t	0	f	2026-09-11 22:07:59.153639
145	179	/images/opt/medjool-dates.jpg	تصویر بار خرما ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.157575
146	180	/images/opt/premium-mixed-nuts.jpg	تصویر بار کنجد هلسا	t	0	f	2026-09-11 22:07:59.161578
147	181	/images/opt/premium-mixed-nuts.jpg	تصویر بار کنجد و خرما هلسا	t	0	f	2026-09-11 22:07:59.165882
148	182	/images/opt/premium-mixed-nuts.jpg	تصویر بار کنجد و مغزها هلسا	t	0	f	2026-09-11 22:07:59.169472
149	183	/images/opt/premium-mixed-nuts.jpg	تصویر بار کنجد ویژه هلسا هلسا	t	0	f	2026-09-11 22:07:59.173146
162	333	/images/opt/tiramisu-cake.jpg	تصویر کیک تیرامیسو هلسا هلسا	t	0	f	2026-09-13 10:32:57.724905
163	334	/images/opt/new-york-cheesecake.jpg	تصویر چیزکیک نیویورکی هلسا هلسا	t	0	f	2026-09-13 10:32:57.732426
164	335	/images/opt/belgian-chocolate-mousse.jpg	تصویر موس شکلات بلژیکی هلسا هلسا	t	0	f	2026-09-13 10:32:57.73835
166	337	/images/opt/fudge-brownie.jpg	تصویر براونی فاج هلسا هلسا	t	0	f	2026-09-13 10:32:57.750141
168	339	/images/opt/quince-jam.jpg	تصویر مربای به هلسا هلسا	t	0	f	2026-09-13 10:32:57.763766
171	342	/images/opt/sour-cherry-jam.jpg	تصویر مربای آلبالو هلسا هلسا	t	0	f	2026-09-13 10:32:57.782335
172	343	/images/opt/watermelon-rind-jam.jpg	تصویر مربای هندونه هلسا هلسا	t	0	f	2026-09-13 10:32:57.788442
173	344	/images/opt/rose-petal-jam.jpg	تصویر مربای گل محمدی هلسا هلسا	t	0	f	2026-09-13 10:32:57.79452
165	336	/images/opt/chocolate-roulade.jpg	تصویر رولت شکلاتی هلسا هلسا	t	0	f	2026-09-13 10:32:57.744019
170	341	/images/opt/balang-jam.jpg	تصویر مربای بالنگ هلسا هلسا	t	0	f	2026-09-13 10:32:57.776175
169	340	/images/opt/carrot-jam.jpg	تصویر مربای هویج هلسا هلسا	t	0	f	2026-09-13 10:32:57.769796
167	338	/images/opt/vanilla-panna-cotta.jpg	تصویر پاناکوتا وانیلی هلسا هلسا	t	0	f	2026-09-13 10:32:57.757035
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variants (id, product_id, name, sku, price, compare_at_price, cost_price, stock, weight, unit, flavor, is_active, sort_order, created_at, updated_at) FROM stdin;
2	35	۵۰۰ گرم	CAT-0001-W500	690000	\N	\N	9	500	گرم	\N	t	1	2026-09-11 22:07:58.294986	2026-09-13 10:32:57.198
3	35	۱٬۰۰۰ گرم	CAT-0001-W1000	1311000	\N	\N	9	1000	گرم	\N	t	2	2026-09-11 22:07:58.297924	2026-09-13 10:32:57.199
4	36	۲۵۰ گرم	CAT-0002-W250	451000	\N	\N	6	250	گرم	\N	t	0	2026-09-11 22:07:58.309807	2026-09-13 10:32:57.205
5	36	۵۰۰ گرم	CAT-0002-W500	820000	\N	\N	6	500	گرم	\N	t	1	2026-09-11 22:07:58.311515	2026-09-13 10:32:57.207
6	36	۱٬۰۰۰ گرم	CAT-0002-W1000	1558000	\N	\N	6	1000	گرم	\N	t	2	2026-09-11 22:07:58.314184	2026-09-13 10:32:57.208
7	37	۲۵۰ گرم	CAT-0003-W250	539000	\N	\N	4	250	گرم	\N	t	0	2026-09-11 22:07:58.335406	2026-09-13 10:32:57.213
8	37	۵۰۰ گرم	CAT-0003-W500	980000	\N	\N	4	500	گرم	\N	t	1	2026-09-11 22:07:58.336761	2026-09-13 10:32:57.214
9	37	۱٬۰۰۰ گرم	CAT-0003-W1000	1862000	\N	\N	4	1000	گرم	\N	t	2	2026-09-11 22:07:58.338266	2026-09-13 10:32:57.215
10	38	۲۵۰ گرم	CAT-0004-W250	253000	\N	\N	11	250	گرم	\N	t	0	2026-09-11 22:07:58.345851	2026-09-13 10:32:57.219
11	38	۵۰۰ گرم	CAT-0004-W500	460000	\N	\N	11	500	گرم	\N	t	1	2026-09-11 22:07:58.347289	2026-09-13 10:32:57.22
12	38	۱٬۰۰۰ گرم	CAT-0004-W1000	874000	\N	\N	11	1000	گرم	\N	t	2	2026-09-11 22:07:58.354539	2026-09-13 10:32:57.221
13	39	۲۵۰ گرم	CAT-0005-W250	490000	\N	\N	6	250	گرم	\N	t	0	2026-09-11 22:07:58.370249	2026-09-13 10:32:57.226
14	39	۵۰۰ گرم	CAT-0005-W500	890000	\N	\N	6	500	گرم	\N	t	1	2026-09-11 22:07:58.371908	2026-09-13 10:32:57.227
16	40	۲۵۰ گرم	CAT-0006-W250	512000	\N	\N	3	250	گرم	\N	t	0	2026-09-11 22:07:58.388038	2026-09-13 10:32:57.232
17	40	۵۰۰ گرم	CAT-0006-W500	930000	\N	\N	3	500	گرم	\N	t	1	2026-09-11 22:07:58.38928	2026-09-13 10:32:57.233
18	40	۱٬۰۰۰ گرم	CAT-0006-W1000	1767000	\N	\N	3	1000	گرم	\N	t	2	2026-09-11 22:07:58.390576	2026-09-13 10:32:57.234
19	41	۲۵۰ گرم	CAT-0007-W250	506000	\N	\N	3	250	گرم	\N	t	0	2026-09-11 22:07:58.397805	2026-09-13 10:32:57.238
20	41	۵۰۰ گرم	CAT-0007-W500	920000	\N	\N	3	500	گرم	\N	t	1	2026-09-11 22:07:58.3989	2026-09-13 10:32:57.239
21	41	۱٬۰۰۰ گرم	CAT-0007-W1000	1748000	\N	\N	3	1000	گرم	\N	t	2	2026-09-11 22:07:58.399972	2026-09-13 10:32:57.24
22	42	۲۵۰ گرم	CAT-0008-W250	319000	\N	\N	7	250	گرم	\N	t	0	2026-09-11 22:07:58.405971	2026-09-13 10:32:57.244
23	42	۵۰۰ گرم	CAT-0008-W500	580000	\N	\N	7	500	گرم	\N	t	1	2026-09-11 22:07:58.407124	2026-09-13 10:32:57.245
24	42	۱٬۰۰۰ گرم	CAT-0008-W1000	1102000	\N	\N	7	1000	گرم	\N	t	2	2026-09-11 22:07:58.40813	2026-09-13 10:32:57.247
25	43	نمکی - ۵۰۰ گرم	CAT-0009-F1	240000	\N	\N	8	500	گرم	نمکی	t	0	2026-09-11 22:07:58.414075	2026-09-13 10:32:57.25
26	43	لیمویی - ۵۰۰ گرم	CAT-0009-F2	247000	\N	\N	8	500	گرم	لیمویی	t	1	2026-09-11 22:07:58.415052	2026-09-13 10:32:57.251
27	43	فلفلی - ۵۰۰ گرم	CAT-0009-F3	254000	\N	\N	8	500	گرم	فلفلی	t	2	2026-09-11 22:07:58.416113	2026-09-13 10:32:57.252
28	43	گلپر - ۵۰۰ گرم	CAT-0009-F4	262000	\N	\N	8	500	گرم	گلپر	t	3	2026-09-11 22:07:58.417208	2026-09-13 10:32:57.253
29	43	دودی - ۵۰۰ گرم	CAT-0009-F5	269000	\N	\N	8	500	گرم	دودی	t	4	2026-09-11 22:07:58.418399	2026-09-13 10:32:57.254
30	44	نمکی - ۵۰۰ گرم	CAT-0010-F1	285000	\N	\N	7	500	گرم	نمکی	t	0	2026-09-11 22:07:58.440689	2026-09-13 10:32:57.258
31	44	لیمویی - ۵۰۰ گرم	CAT-0010-F2	294000	\N	\N	7	500	گرم	لیمویی	t	1	2026-09-11 22:07:58.442171	2026-09-13 10:32:57.259
32	44	فلفلی - ۵۰۰ گرم	CAT-0010-F3	302000	\N	\N	7	500	گرم	فلفلی	t	2	2026-09-11 22:07:58.444141	2026-09-13 10:32:57.26
33	44	گلپر - ۵۰۰ گرم	CAT-0010-F4	311000	\N	\N	7	500	گرم	گلپر	t	3	2026-09-11 22:07:58.445322	2026-09-13 10:32:57.261
34	44	دودی - ۵۰۰ گرم	CAT-0010-F5	319000	\N	\N	7	500	گرم	دودی	t	4	2026-09-11 22:07:58.446506	2026-09-13 10:32:57.269
35	45	نمکی - ۵۰۰ گرم	CAT-0011-F1	155000	\N	\N	27	500	گرم	نمکی	t	0	2026-09-11 22:07:58.457277	2026-09-13 10:32:57.273
36	45	لیمویی - ۵۰۰ گرم	CAT-0011-F2	160000	\N	\N	27	500	گرم	لیمویی	t	1	2026-09-11 22:07:58.458725	2026-09-13 10:32:57.274
37	46	۲۵۰ گرم	CAT-0012-W250	116000	\N	\N	10	250	گرم	\N	t	0	2026-09-11 22:07:58.465804	2026-09-13 10:32:57.278
38	46	۵۰۰ گرم	CAT-0012-W500	210000	\N	\N	10	500	گرم	\N	t	1	2026-09-11 22:07:58.467229	2026-09-13 10:32:57.279
39	46	۱٬۰۰۰ گرم	CAT-0012-W1000	399000	\N	\N	10	1000	گرم	\N	t	2	2026-09-11 22:07:58.468675	2026-09-13 10:32:57.281
40	47	۲۵۰ گرم	CAT-0013-W250	107000	\N	\N	8	250	گرم	\N	t	0	2026-09-11 22:07:58.475533	2026-09-13 10:32:57.285
41	47	۵۰۰ گرم	CAT-0013-W500	195000	\N	\N	8	500	گرم	\N	t	1	2026-09-11 22:07:58.480719	2026-09-13 10:32:57.286
42	47	۱٬۰۰۰ گرم	CAT-0013-W1000	371000	\N	\N	8	1000	گرم	\N	t	2	2026-09-11 22:07:58.482175	2026-09-13 10:32:57.287
43	48	۲۵۰ گرم	CAT-0014-W250	96000	\N	\N	13	250	گرم	\N	t	0	2026-09-11 22:07:58.48915	2026-09-13 10:32:57.29
44	48	۵۰۰ گرم	CAT-0014-W500	175000	\N	\N	13	500	گرم	\N	t	1	2026-09-11 22:07:58.490459	2026-09-13 10:32:57.291
46	49	۲۵۰ گرم	CAT-0015-W250	102000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.502108	2026-09-13 10:32:57.296
47	49	۵۰۰ گرم	CAT-0015-W500	185000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.503295	2026-09-13 10:32:57.297
48	49	۱٬۰۰۰ گرم	CAT-0015-W1000	352000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.50454	2026-09-13 10:32:57.298
49	50	۲۵۰ گرم	CAT-0016-W250	124000	\N	\N	8	250	گرم	\N	t	0	2026-09-11 22:07:58.510676	2026-09-13 10:32:57.301
50	50	۵۰۰ گرم	CAT-0016-W500	225000	\N	\N	8	500	گرم	\N	t	1	2026-09-11 22:07:58.511887	2026-09-13 10:32:57.302
51	50	۱٬۰۰۰ گرم	CAT-0016-W1000	428000	\N	\N	8	1000	گرم	\N	t	2	2026-09-11 22:07:58.513096	2026-09-13 10:32:57.302
52	1	۲۵۰ گرم	HLA-0001-W250	267000	\N	\N	10	250	گرم	\N	t	0	2026-09-11 22:07:58.518696	2026-09-13 10:32:57.307
54	1	۱٬۰۰۰ گرم	HLA-0001-W1000	922000	\N	\N	10	1000	گرم	\N	t	2	2026-09-11 22:07:58.520709	2026-09-13 10:32:57.309
56	2	۵۰۰ گرم	HLA-0002-W500	320000	\N	\N	14	500	گرم	\N	t	1	2026-09-11 22:07:58.527453	2026-09-13 10:32:57.313
57	2	۱٬۰۰۰ گرم	HLA-0002-W1000	608000	\N	\N	14	1000	گرم	\N	t	2	2026-09-11 22:07:58.528333	2026-09-13 10:32:57.313
58	3	۲۵۰ گرم	HLA-0003-W250	146000	\N	\N	11	250	گرم	\N	t	0	2026-09-11 22:07:58.534293	2026-09-13 10:32:57.316
59	3	۵۰۰ گرم	HLA-0003-W500	265000	\N	\N	11	500	گرم	\N	t	1	2026-09-11 22:07:58.535458	2026-09-13 10:32:57.317
60	3	۱٬۰۰۰ گرم	HLA-0003-W1000	504000	\N	\N	11	1000	گرم	\N	t	2	2026-09-11 22:07:58.536657	2026-09-13 10:32:57.319
61	4	۲۵۰ گرم	HLA-0004-W250	116000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.542245	2026-09-13 10:32:57.322
62	4	۵۰۰ گرم	HLA-0004-W500	210000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.543414	2026-09-13 10:32:57.324
63	4	۱٬۰۰۰ گرم	HLA-0004-W1000	399000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.544536	2026-09-13 10:32:57.325
64	5	۲۵۰ گرم	HLA-0005-W250	132000	\N	\N	9	250	گرم	\N	t	0	2026-09-11 22:07:58.549655	2026-09-13 10:32:57.329
65	5	۵۰۰ گرم	HLA-0005-W500	240000	\N	\N	9	500	گرم	\N	t	1	2026-09-11 22:07:58.550612	2026-09-13 10:32:57.33
66	5	۱٬۰۰۰ گرم	HLA-0005-W1000	456000	\N	\N	9	1000	گرم	\N	t	2	2026-09-11 22:07:58.551552	2026-09-13 10:32:57.33
67	6	۲۵۰ گرم	HLA-0006-W250	429000	\N	\N	4	250	گرم	\N	t	0	2026-09-11 22:07:58.55692	2026-09-13 10:32:57.333
68	6	۵۰۰ گرم	HLA-0006-W500	780000	\N	\N	4	500	گرم	\N	t	1	2026-09-11 22:07:58.558192	2026-09-13 10:32:57.334
70	68	۲۵۰ گرم	CAT-0034-W250	215000	\N	\N	8	250	گرم	\N	t	0	2026-09-11 22:07:58.610584	2026-09-13 10:32:57.364
71	68	۵۰۰ گرم	CAT-0034-W500	390000	\N	\N	8	500	گرم	\N	t	1	2026-09-11 22:07:58.611604	2026-09-13 10:32:57.365
72	68	۱٬۰۰۰ گرم	CAT-0034-W1000	741000	\N	\N	8	1000	گرم	\N	t	2	2026-09-11 22:07:58.612644	2026-09-13 10:32:57.366
73	69	۲۵۰ گرم	CAT-0035-W250	176000	\N	\N	9	250	گرم	\N	t	0	2026-09-11 22:07:58.617622	2026-09-13 10:32:57.369
74	69	۵۰۰ گرم	CAT-0035-W500	320000	\N	\N	9	500	گرم	\N	t	1	2026-09-11 22:07:58.6186	2026-09-13 10:32:57.37
75	69	۱٬۰۰۰ گرم	CAT-0035-W1000	608000	\N	\N	9	1000	گرم	\N	t	2	2026-09-11 22:07:58.619604	2026-09-13 10:32:57.371
76	70	۲۵۰ گرم	CAT-0036-W250	242000	\N	\N	6	250	گرم	\N	t	0	2026-09-11 22:07:58.625061	2026-09-13 10:32:57.374
77	70	۵۰۰ گرم	CAT-0036-W500	440000	\N	\N	6	500	گرم	\N	t	1	2026-09-11 22:07:58.626124	2026-09-13 10:32:57.375
78	70	۱٬۰۰۰ گرم	CAT-0036-W1000	836000	\N	\N	6	1000	گرم	\N	t	2	2026-09-11 22:07:58.627185	2026-09-13 10:32:57.376
79	71	۲۵۰ گرم	CAT-0037-W250	102000	\N	\N	14	250	گرم	\N	t	0	2026-09-11 22:07:58.63304	2026-09-13 10:32:57.38
80	71	۵۰۰ گرم	CAT-0037-W500	185000	\N	\N	14	500	گرم	\N	t	1	2026-09-11 22:07:58.634189	2026-09-13 10:32:57.381
81	71	۱٬۰۰۰ گرم	CAT-0037-W1000	352000	\N	\N	14	1000	گرم	\N	t	2	2026-09-11 22:07:58.635409	2026-09-13 10:32:57.382
82	72	۲۵۰ گرم	CAT-0038-W250	91000	\N	\N	13	250	گرم	\N	t	0	2026-09-11 22:07:58.642299	2026-09-13 10:32:57.385
83	72	۵۰۰ گرم	CAT-0038-W500	165000	\N	\N	13	500	گرم	\N	t	1	2026-09-11 22:07:58.643735	2026-09-13 10:32:57.386
84	72	۱٬۰۰۰ گرم	CAT-0038-W1000	314000	\N	\N	13	1000	گرم	\N	t	2	2026-09-11 22:07:58.645002	2026-09-13 10:32:57.387
85	73	۲۵۰ گرم	CAT-0039-W250	99000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.652399	2026-09-13 10:32:57.39
86	73	۵۰۰ گرم	CAT-0039-W500	180000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.654227	2026-09-13 10:32:57.391
87	73	۱٬۰۰۰ گرم	CAT-0039-W1000	342000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.655702	2026-09-13 10:32:57.392
88	74	۲۵۰ گرم	CAT-0040-W250	116000	\N	\N	8	250	گرم	\N	t	0	2026-09-11 22:07:58.661622	2026-09-13 10:32:57.395
89	74	۵۰۰ گرم	CAT-0040-W500	210000	\N	\N	8	500	گرم	\N	t	1	2026-09-11 22:07:58.662639	2026-09-13 10:32:57.396
90	74	۱٬۰۰۰ گرم	CAT-0040-W1000	399000	\N	\N	8	1000	گرم	\N	t	2	2026-09-11 22:07:58.663638	2026-09-13 10:32:57.397
91	80	۲۵۰ گرم	CAT-0046-W250	102000	\N	\N	10	250	گرم	\N	t	0	2026-09-11 22:07:58.690169	2026-09-13 10:32:57.421
92	80	۵۰۰ گرم	CAT-0046-W500	185000	\N	\N	10	500	گرم	\N	t	1	2026-09-11 22:07:58.691249	2026-09-13 10:32:57.422
93	80	۱٬۰۰۰ گرم	CAT-0046-W1000	352000	\N	\N	10	1000	گرم	\N	t	2	2026-09-11 22:07:58.692256	2026-09-13 10:32:57.423
94	81	۲۵۰ گرم	CAT-0047-W250	69000	\N	\N	13	250	گرم	\N	t	0	2026-09-11 22:07:58.698118	2026-09-13 10:32:57.425
95	81	۵۰۰ گرم	CAT-0047-W500	125000	\N	\N	13	500	گرم	\N	t	1	2026-09-11 22:07:58.699074	2026-09-13 10:32:57.426
97	82	۲۵۰ گرم	CAT-0048-W250	69000	\N	\N	13	250	گرم	\N	t	0	2026-09-11 22:07:58.705053	2026-09-13 10:32:57.431
98	82	۵۰۰ گرم	CAT-0048-W500	125000	\N	\N	13	500	گرم	\N	t	1	2026-09-11 22:07:58.70599	2026-09-13 10:32:57.432
99	82	۱٬۰۰۰ گرم	CAT-0048-W1000	238000	\N	\N	13	1000	گرم	\N	t	2	2026-09-11 22:07:58.70694	2026-09-13 10:32:57.434
100	83	۲۵۰ گرم	CAT-0049-W250	74000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.71363	2026-09-13 10:32:57.437
101	83	۵۰۰ گرم	CAT-0049-W500	135000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.714893	2026-09-13 10:32:57.438
102	83	۱٬۰۰۰ گرم	CAT-0049-W1000	257000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.716195	2026-09-13 10:32:57.439
103	84	۲۵۰ گرم	CAT-0050-W250	80000	\N	\N	11	250	گرم	\N	t	0	2026-09-11 22:07:58.721513	2026-09-13 10:32:57.444
104	84	۵۰۰ گرم	CAT-0050-W500	145000	\N	\N	11	500	گرم	\N	t	1	2026-09-11 22:07:58.7225	2026-09-13 10:32:57.445
105	84	۱٬۰۰۰ گرم	CAT-0050-W1000	276000	\N	\N	11	1000	گرم	\N	t	2	2026-09-11 22:07:58.723442	2026-09-13 10:32:57.446
106	85	۲۵۰ گرم	CAT-0051-W250	88000	\N	\N	15	250	گرم	\N	t	0	2026-09-11 22:07:58.728626	2026-09-13 10:32:57.45
107	85	۵۰۰ گرم	CAT-0051-W500	160000	\N	\N	15	500	گرم	\N	t	1	2026-09-11 22:07:58.729604	2026-09-13 10:32:57.451
108	85	۱٬۰۰۰ گرم	CAT-0051-W1000	304000	\N	\N	15	1000	گرم	\N	t	2	2026-09-11 22:07:58.730583	2026-09-13 10:32:57.451
109	86	۲۵۰ گرم	CAT-0052-W250	66000	\N	\N	14	250	گرم	\N	t	0	2026-09-11 22:07:58.7355	2026-09-13 10:32:57.456
110	86	۵۰۰ گرم	CAT-0052-W500	120000	\N	\N	14	500	گرم	\N	t	1	2026-09-11 22:07:58.736574	2026-09-13 10:32:57.456
111	86	۱٬۰۰۰ گرم	CAT-0052-W1000	228000	\N	\N	14	1000	گرم	\N	t	2	2026-09-11 22:07:58.737524	2026-09-13 10:32:57.457
112	87	۲۵۰ گرم	CAT-0053-W250	61000	\N	\N	16	250	گرم	\N	t	0	2026-09-11 22:07:58.743039	2026-09-13 10:32:57.461
113	87	۵۰۰ گرم	CAT-0053-W500	110000	\N	\N	16	500	گرم	\N	t	1	2026-09-11 22:07:58.744042	2026-09-13 10:32:57.461
114	87	۱٬۰۰۰ گرم	CAT-0053-W1000	209000	\N	\N	16	1000	گرم	\N	t	2	2026-09-11 22:07:58.745012	2026-09-13 10:32:57.462
115	88	۲۵۰ گرم	CAT-0054-W250	96000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.758404	2026-09-13 10:32:57.466
116	88	۵۰۰ گرم	CAT-0054-W500	175000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.759326	2026-09-13 10:32:57.467
117	88	۱٬۰۰۰ گرم	CAT-0054-W1000	333000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.760389	2026-09-13 10:32:57.467
118	89	۲۵۰ گرم	CAT-0055-W250	72000	\N	\N	9	250	گرم	\N	t	0	2026-09-11 22:07:58.765482	2026-09-13 10:32:57.471
119	89	۵۰۰ گرم	CAT-0055-W500	130000	\N	\N	9	500	گرم	\N	t	1	2026-09-11 22:07:58.766488	2026-09-13 10:32:57.472
120	89	۱٬۰۰۰ گرم	CAT-0055-W1000	247000	\N	\N	9	1000	گرم	\N	t	2	2026-09-11 22:07:58.767456	2026-09-13 10:32:57.473
121	90	۲۵۰ گرم	CAT-0056-W250	80000	\N	\N	11	250	گرم	\N	t	0	2026-09-11 22:07:58.77244	2026-09-13 10:32:57.476
122	90	۵۰۰ گرم	CAT-0056-W500	145000	\N	\N	11	500	گرم	\N	t	1	2026-09-11 22:07:58.773333	2026-09-13 10:32:57.477
123	90	۱٬۰۰۰ گرم	CAT-0056-W1000	276000	\N	\N	11	1000	گرم	\N	t	2	2026-09-11 22:07:58.774269	2026-09-13 10:32:57.477
124	91	۲۵۰ گرم	CAT-0057-W250	107000	\N	\N	7	250	گرم	\N	t	0	2026-09-11 22:07:58.779039	2026-09-13 10:32:57.48
125	91	۵۰۰ گرم	CAT-0057-W500	195000	\N	\N	7	500	گرم	\N	t	1	2026-09-11 22:07:58.779972	2026-09-13 10:32:57.481
127	121	۲۵۰ گرم	CAT-0087-W250	88000	\N	\N	16	250	گرم	\N	t	0	2026-09-11 22:07:58.901205	2026-09-13 10:32:57.559
128	121	۵۰۰ گرم	CAT-0087-W500	160000	\N	\N	16	500	گرم	\N	t	1	2026-09-11 22:07:58.902137	2026-09-13 10:32:57.559
129	121	۱٬۰۰۰ گرم	CAT-0087-W1000	304000	\N	\N	16	1000	گرم	\N	t	2	2026-09-11 22:07:58.903064	2026-09-13 10:32:57.56
130	122	۲۵۰ گرم	CAT-0088-W250	83000	\N	\N	14	250	گرم	\N	t	0	2026-09-11 22:07:58.907707	2026-09-13 10:32:57.563
131	122	۵۰۰ گرم	CAT-0088-W500	150000	\N	\N	14	500	گرم	\N	t	1	2026-09-11 22:07:58.908669	2026-09-13 10:32:57.564
132	122	۱٬۰۰۰ گرم	CAT-0088-W1000	285000	\N	\N	14	1000	گرم	\N	t	2	2026-09-11 22:07:58.909589	2026-09-13 10:32:57.565
133	123	۲۵۰ گرم	CAT-0089-W250	96000	\N	\N	13	250	گرم	\N	t	0	2026-09-11 22:07:58.914415	2026-09-13 10:32:57.568
134	123	۵۰۰ گرم	CAT-0089-W500	175000	\N	\N	13	500	گرم	\N	t	1	2026-09-11 22:07:58.915236	2026-09-13 10:32:57.569
135	123	۱٬۰۰۰ گرم	CAT-0089-W1000	333000	\N	\N	13	1000	گرم	\N	t	2	2026-09-11 22:07:58.916177	2026-09-13 10:32:57.57
136	124	۲۵۰ گرم	CAT-0090-W250	102000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.920934	2026-09-13 10:32:57.573
1	35	۲۵۰ گرم	CAT-0001-W250	380000	\N	\N	9	250	گرم	\N	t	0	2026-09-11 22:07:58.291974	2026-09-13 10:32:57.195
15	39	۱٬۰۰۰ گرم	CAT-0005-W1000	1691000	\N	\N	6	1000	گرم	\N	t	2	2026-09-11 22:07:58.373428	2026-09-13 10:32:57.228
45	48	۱٬۰۰۰ گرم	CAT-0014-W1000	333000	\N	\N	13	1000	گرم	\N	t	2	2026-09-11 22:07:58.49148	2026-09-13 10:32:57.292
53	1	۵۰۰ گرم	HLA-0001-W500	485000	\N	\N	10	500	گرم	\N	t	1	2026-09-11 22:07:58.519726	2026-09-13 10:32:57.308
55	2	۲۵۰ گرم	HLA-0002-W250	176000	\N	\N	14	250	گرم	\N	t	0	2026-09-11 22:07:58.526268	2026-09-13 10:32:57.312
69	6	۱٬۰۰۰ گرم	HLA-0006-W1000	1482000	\N	\N	4	1000	گرم	\N	t	2	2026-09-11 22:07:58.559328	2026-09-13 10:32:57.335
96	81	۱٬۰۰۰ گرم	CAT-0047-W1000	238000	\N	\N	13	1000	گرم	\N	t	2	2026-09-11 22:07:58.700064	2026-09-13 10:32:57.427
126	91	۱٬۰۰۰ گرم	CAT-0057-W1000	371000	\N	\N	7	1000	گرم	\N	t	2	2026-09-11 22:07:58.780955	2026-09-13 10:32:57.482
137	124	۵۰۰ گرم	CAT-0090-W500	185000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.921806	2026-09-13 10:32:57.574
138	124	۱٬۰۰۰ گرم	CAT-0090-W1000	352000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.922693	2026-09-13 10:32:57.574
139	125	۲۵۰ گرم	CAT-0091-W250	94000	\N	\N	14	250	گرم	\N	t	0	2026-09-11 22:07:58.927444	2026-09-13 10:32:57.577
140	125	۵۰۰ گرم	CAT-0091-W500	170000	\N	\N	14	500	گرم	\N	t	1	2026-09-11 22:07:58.928436	2026-09-13 10:32:57.578
141	125	۱٬۰۰۰ گرم	CAT-0091-W1000	323000	\N	\N	14	1000	گرم	\N	t	2	2026-09-11 22:07:58.929311	2026-09-13 10:32:57.579
142	126	۲۵۰ گرم	CAT-0092-W250	91000	\N	\N	12	250	گرم	\N	t	0	2026-09-11 22:07:58.934123	2026-09-13 10:32:57.582
143	126	۵۰۰ گرم	CAT-0092-W500	165000	\N	\N	12	500	گرم	\N	t	1	2026-09-11 22:07:58.935008	2026-09-13 10:32:57.582
144	126	۱٬۰۰۰ گرم	CAT-0092-W1000	314000	\N	\N	12	1000	گرم	\N	t	2	2026-09-11 22:07:58.935928	2026-09-13 10:32:57.583
145	127	۲۵۰ گرم	CAT-0093-W250	107000	\N	\N	10	250	گرم	\N	t	0	2026-09-11 22:07:58.94131	2026-09-13 10:32:57.586
146	127	۵۰۰ گرم	CAT-0093-W500	195000	\N	\N	10	500	گرم	\N	t	1	2026-09-11 22:07:58.942275	2026-09-13 10:32:57.587
147	127	۱٬۰۰۰ گرم	CAT-0093-W1000	371000	\N	\N	10	1000	گرم	\N	t	2	2026-09-11 22:07:58.943176	2026-09-13 10:32:57.587
148	165	۲۵۰ گرم	CAT-0131-W250	107000	\N	\N	9	250	گرم	\N	t	0	2026-09-11 22:07:59.091556	2026-09-13 10:32:57.673
149	165	۵۰۰ گرم	CAT-0131-W500	195000	\N	\N	9	500	گرم	\N	t	1	2026-09-11 22:07:59.092569	2026-09-13 10:32:57.674
150	165	۱٬۰۰۰ گرم	CAT-0131-W1000	371000	\N	\N	9	1000	گرم	\N	t	2	2026-09-11 22:07:59.093649	2026-09-13 10:32:57.675
151	166	۲۵۰ گرم	CAT-0132-W250	96000	\N	\N	10	250	گرم	\N	t	0	2026-09-11 22:07:59.09832	2026-09-13 10:32:57.678
152	166	۵۰۰ گرم	CAT-0132-W500	175000	\N	\N	10	500	گرم	\N	t	1	2026-09-11 22:07:59.099247	2026-09-13 10:32:57.679
153	166	۱٬۰۰۰ گرم	CAT-0132-W1000	333000	\N	\N	10	1000	گرم	\N	t	2	2026-09-11 22:07:59.10022	2026-09-13 10:32:57.68
154	167	۲۵۰ گرم	CAT-0133-W250	127000	\N	\N	6	250	گرم	\N	t	0	2026-09-11 22:07:59.104909	2026-09-13 10:32:57.683
155	167	۵۰۰ گرم	CAT-0133-W500	230000	\N	\N	6	500	گرم	\N	t	1	2026-09-11 22:07:59.10587	2026-09-13 10:32:57.683
156	167	۱٬۰۰۰ گرم	CAT-0133-W1000	437000	\N	\N	6	1000	گرم	\N	t	2	2026-09-11 22:07:59.106797	2026-09-13 10:32:57.684
313	333	۵۰۰ گرم	CAT-0150-W500	640000	\N	\N	4	500	گرم	\N	t	0	2026-09-13 10:32:57.722033	2026-09-13 10:32:57.722033
314	333	۱٬۰۰۰ گرم	CAT-0150-W1000	1216000	\N	\N	4	1000	گرم	\N	t	1	2026-09-13 10:32:57.722942	2026-09-13 10:32:57.722942
315	333	۱٬۵۰۰ گرم	CAT-0150-W1500	1920000	\N	\N	4	1500	گرم	\N	t	2	2026-09-13 10:32:57.723761	2026-09-13 10:32:57.723761
316	334	۵۰۰ گرم	CAT-0151-W500	580000	\N	\N	4	500	گرم	\N	t	0	2026-09-13 10:32:57.729753	2026-09-13 10:32:57.729753
317	334	۱٬۰۰۰ گرم	CAT-0151-W1000	1102000	\N	\N	4	1000	گرم	\N	t	1	2026-09-13 10:32:57.730583	2026-09-13 10:32:57.730583
318	334	۱٬۵۰۰ گرم	CAT-0151-W1500	1740000	\N	\N	4	1500	گرم	\N	t	2	2026-09-13 10:32:57.731376	2026-09-13 10:32:57.731376
319	335	۵۰۰ گرم	CAT-0152-W500	520000	\N	\N	5	500	گرم	\N	t	0	2026-09-13 10:32:57.735629	2026-09-13 10:32:57.735629
320	335	۱٬۰۰۰ گرم	CAT-0152-W1000	988000	\N	\N	5	1000	گرم	\N	t	1	2026-09-13 10:32:57.736412	2026-09-13 10:32:57.736412
321	335	۱٬۵۰۰ گرم	CAT-0152-W1500	1560000	\N	\N	5	1500	گرم	\N	t	2	2026-09-13 10:32:57.737201	2026-09-13 10:32:57.737201
322	336	۵۰۰ گرم	CAT-0153-W500	460000	\N	\N	5	500	گرم	\N	t	0	2026-09-13 10:32:57.741399	2026-09-13 10:32:57.741399
323	336	۱٬۰۰۰ گرم	CAT-0153-W1000	874000	\N	\N	5	1000	گرم	\N	t	1	2026-09-13 10:32:57.742172	2026-09-13 10:32:57.742172
324	336	۱٬۵۰۰ گرم	CAT-0153-W1500	1380000	\N	\N	5	1500	گرم	\N	t	2	2026-09-13 10:32:57.742923	2026-09-13 10:32:57.742923
325	337	۵۰۰ گرم	CAT-0154-W500	380000	\N	\N	6	500	گرم	\N	t	0	2026-09-13 10:32:57.747326	2026-09-13 10:32:57.747326
326	337	۱٬۰۰۰ گرم	CAT-0154-W1000	722000	\N	\N	6	1000	گرم	\N	t	1	2026-09-13 10:32:57.74813	2026-09-13 10:32:57.74813
327	337	۱٬۵۰۰ گرم	CAT-0154-W1500	1140000	\N	\N	6	1500	گرم	\N	t	2	2026-09-13 10:32:57.749001	2026-09-13 10:32:57.749001
328	338	۵۰۰ گرم	CAT-0155-W500	340000	\N	\N	6	500	گرم	\N	t	0	2026-09-13 10:32:57.754131	2026-09-13 10:32:57.754131
329	338	۱٬۰۰۰ گرم	CAT-0155-W1000	646000	\N	\N	6	1000	گرم	\N	t	1	2026-09-13 10:32:57.754981	2026-09-13 10:32:57.754981
330	338	۱٬۵۰۰ گرم	CAT-0155-W1500	1020000	\N	\N	6	1500	گرم	\N	t	2	2026-09-13 10:32:57.755865	2026-09-13 10:32:57.755865
331	339	۲۵۰ گرم	CAT-0156-W250	187000	\N	\N	6	250	گرم	\N	t	0	2026-09-13 10:32:57.760841	2026-09-13 10:32:57.760841
332	339	۵۰۰ گرم	CAT-0156-W500	340000	\N	\N	6	500	گرم	\N	t	1	2026-09-13 10:32:57.761773	2026-09-13 10:32:57.761773
333	339	۱٬۰۰۰ گرم	CAT-0156-W1000	646000	\N	\N	6	1000	گرم	\N	t	2	2026-09-13 10:32:57.762618	2026-09-13 10:32:57.762618
334	340	۲۵۰ گرم	CAT-0157-W250	154000	\N	\N	6	250	گرم	\N	t	0	2026-09-13 10:32:57.76706	2026-09-13 10:32:57.76706
335	340	۵۰۰ گرم	CAT-0157-W500	280000	\N	\N	6	500	گرم	\N	t	1	2026-09-13 10:32:57.767881	2026-09-13 10:32:57.767881
336	340	۱٬۰۰۰ گرم	CAT-0157-W1000	532000	\N	\N	6	1000	گرم	\N	t	2	2026-09-13 10:32:57.768694	2026-09-13 10:32:57.768694
337	341	۲۵۰ گرم	CAT-0158-W250	198000	\N	\N	4	250	گرم	\N	t	0	2026-09-13 10:32:57.773022	2026-09-13 10:32:57.773022
338	341	۵۰۰ گرم	CAT-0158-W500	360000	\N	\N	4	500	گرم	\N	t	1	2026-09-13 10:32:57.773883	2026-09-13 10:32:57.773883
339	341	۱٬۰۰۰ گرم	CAT-0158-W1000	684000	\N	\N	4	1000	گرم	\N	t	2	2026-09-13 10:32:57.774931	2026-09-13 10:32:57.774931
340	342	۲۵۰ گرم	CAT-0159-W250	171000	\N	\N	5	250	گرم	\N	t	0	2026-09-13 10:32:57.779485	2026-09-13 10:32:57.779485
341	342	۵۰۰ گرم	CAT-0159-W500	310000	\N	\N	5	500	گرم	\N	t	1	2026-09-13 10:32:57.780336	2026-09-13 10:32:57.780336
342	342	۱٬۰۰۰ گرم	CAT-0159-W1000	589000	\N	\N	5	1000	گرم	\N	t	2	2026-09-13 10:32:57.781188	2026-09-13 10:32:57.781188
343	343	۲۵۰ گرم	CAT-0160-W250	160000	\N	\N	5	250	گرم	\N	t	0	2026-09-13 10:32:57.785618	2026-09-13 10:32:57.785618
344	343	۵۰۰ گرم	CAT-0160-W500	290000	\N	\N	5	500	گرم	\N	t	1	2026-09-13 10:32:57.786506	2026-09-13 10:32:57.786506
345	343	۱٬۰۰۰ گرم	CAT-0160-W1000	551000	\N	\N	5	1000	گرم	\N	t	2	2026-09-13 10:32:57.787357	2026-09-13 10:32:57.787357
346	344	۲۵۰ گرم	CAT-0161-W250	231000	\N	\N	3	250	گرم	\N	t	0	2026-09-13 10:32:57.791683	2026-09-13 10:32:57.791683
347	344	۵۰۰ گرم	CAT-0161-W500	420000	\N	\N	3	500	گرم	\N	t	1	2026-09-13 10:32:57.792534	2026-09-13 10:32:57.792534
348	344	۱٬۰۰۰ گرم	CAT-0161-W1000	798000	\N	\N	3	1000	گرم	\N	t	2	2026-09-13 10:32:57.793393	2026-09-13 10:32:57.793393
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, slug, category, category_id, sku, brand, short_description, description, price, old_price, cost_price, discount, currency, stock, stock_status, low_stock_threshold, min_order_qty, max_order_qty, weight, unit, packaging, ingredients, origin, storage, image, image_alt, image_status, gallery, rating, reviews, badge, tags, features, nutrition, allergens, is_active, is_featured, is_visible, seo_title, seo_description, archived_at, created_at, updated_at) FROM stdin;
171	شکلات خرمایی مغزدار	filled-date-chocolate	date-chocolate	32	CAT-0137	هلسا ایرانیان	شکلات خرمایی مغزدار، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات خرمایی مغزدار از محصولات منتخب هلسا در دسته شکلات خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	430000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات خرمایی مغزدار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-chocolate.jpg	تصویر شکلات خرمایی مغزدار هلسا	brand_asset	["/images/opt/date-chocolate.jpg"]	0	0	\N	["شکلات خرما", "شکلات خرمایی مغزدار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات خرمایی مغزدار"}]	[{"label": "انرژی", "value": "۴۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید شکلات خرمایی مغزدار هلسا	شکلات خرمایی مغزدار، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.123543	2026-09-13 10:59:48.073022
83	ادویه مرغ	chicken-spice	spices	14	CAT-0049	هلسا ایرانیان	ادویه مرغ، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه مرغ از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	135000	\N	\N	0	TOMAN	36	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه مرغ	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه مرغ هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه مرغ"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه مرغ"}]	[]	[]	t	f	t	خرید ادویه مرغ هلسا	ادویه مرغ، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.71209	2026-09-13 10:59:48.073022
40	آجیل نوروزی	nowruz-nuts	nuts-dried-fruits	6	CAT-0006	هلسا ایرانیان	آجیل نوروزی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل نوروزی از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	930000	\N	\N	0	TOMAN	10	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل نوروزی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل نوروزی هلسا	brand_asset	["/images/opt/premium-mixed-nuts.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل نوروزی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل نوروزی"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل نوروزی هلسا	آجیل نوروزی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.384378	2026-09-13 10:32:57.23
179	بار خرما ویژه هلسا	helsa-date-bar	date-bars	33	CAT-0145	هلسا ایرانیان	بار خرما ویژه هلسا، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار خرما ویژه هلسا از محصولات منتخب هلسا در دسته بار خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	270000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار خرما ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-bar.jpg	تصویر بار خرما ویژه هلسا هلسا	brand_asset	["/images/opt/date-bar.jpg"]	0	0	\N	["بار خرما", "بار خرما ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار خرما ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۸ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید بار خرما ویژه هلسا هلسا	بار خرما ویژه هلسا، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.156033	2026-09-13 10:59:48.073022
91	ادویه ترکیبی هلسا	mixed-spices	spices	14	CAT-0057	هلسا ایرانیان	ادویه ترکیبی هلسا، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه ترکیبی هلسا از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	22	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه ترکیبی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه ترکیبی هلسا هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه ترکیبی هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه ترکیبی هلسا"}]	[]	[]	t	f	t	خرید ادویه ترکیبی هلسا هلسا	ادویه ترکیبی هلسا، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.777962	2026-09-13 10:59:48.073022
4	خرما زاهدی	zahedi-dates	dates	1	HLA-0004	هلسا ایرانیان	خرما زاهدی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما زاهدی از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: خوزستان. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	245000	\N	14	TOMAN	38	in_stock	5	1	\N	۱ کیلوگرم	بسته	بسته‌بندی بهداشتی هلسا	خرما زاهدی	خوزستان	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/dates-zahedi.jpg	تصویر خرما زاهدی هلسا	seed_reference	["/images/opt/dates-zahedi.jpg"]	4.5	77	تخفیف	["خرما زاهدی"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "خرما زاهدی"}, {"label": "محل تولید", "value": "خوزستان"}, {"label": "نوع بسته‌بندی", "value": "بسته کرافت زیپ‌دار"}, {"label": "شرایط نگهداری", "value": "دمای محیط، دور از رطوبت"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما زاهدی هلسا	خرما زاهدی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
89	گلپر	golpar	spices	14	CAT-0055	هلسا ایرانیان	گلپر، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	گلپر از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	130000	\N	\N	0	TOMAN	29	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	گلپر	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/golpar.jpg	تصویر گلپر هلسا	brand_asset	["/images/opt/golpar.jpg"]	0	0	\N	["ادویه", "گلپر"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "گلپر"}]	[]	[]	t	f	t	خرید گلپر هلسا	گلپر، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.764136	2026-09-13 10:59:48.073022
98	عرق رازیانه	fennel-distillate	distillates	15	CAT-0064	هلسا ایرانیان	عرق رازیانه، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق رازیانه از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	135000	\N	\N	0	TOMAN	19	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق رازیانه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق رازیانه هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق رازیانه"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق رازیانه"}]	[]	[]	t	f	t	خرید عرق رازیانه هلسا	عرق رازیانه، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.80984	2026-09-13 10:59:48.073022
85	فلفل سیاه	black-pepper	spices	14	CAT-0051	هلسا ایرانیان	فلفل سیاه، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	فلفل سیاه از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	160000	\N	\N	0	TOMAN	45	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	فلفل سیاه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/black-pepper.jpg	تصویر فلفل سیاه هلسا	brand_asset	["/images/opt/black-pepper.jpg"]	0	0	\N	["ادویه", "فلفل سیاه"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "فلفل سیاه"}]	[]	[]	t	f	t	خرید فلفل سیاه هلسا	فلفل سیاه، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.72742	2026-09-13 10:59:48.073022
162	روغن کنجد	sesame-oil	oils	29	CAT-0128	هلسا ایرانیان	روغن کنجد، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی.	روغن کنجد از محصولات منتخب هلسا در دسته روغن است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	460000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	روغن کنجد	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-oil.jpg	تصویر روغن کنجد هلسا	brand_asset	["/images/opt/sesame-oil.jpg"]	0	0	\N	["روغن", "روغن کنجد"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "روغن کنجد"}]	[{"label": "انرژی", "value": "۸۸۴ کیلوکالری"}, {"label": "چربی کل", "value": "۱۰۰ گرم"}, {"label": "چربی اشباع", "value": "۱۵ گرم"}]	[]	t	f	t	خرید روغن کنجد هلسا	روغن کنجد، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.078958	2026-09-13 10:59:48.073022
121	عدس	lentils	legumes	20	CAT-0087	هلسا ایرانیان	عدس، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عدس از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	160000	\N	\N	0	TOMAN	48	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	عدس	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/lentils.jpg	تصویر عدس هلسا	brand_asset	["/images/opt/lentils.jpg"]	0	0	\N	["حبوبات", "عدس"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عدس"}]	[{"label": "انرژی", "value": "۳۵۲ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۶۳ گرم"}, {"label": "چربی", "value": "۱.۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱۱ گرم"}]	[]	t	f	t	خرید عدس هلسا	عدس، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.900103	2026-09-13 10:59:48.073022
123	لوبیا قرمز	red-beans	legumes	20	CAT-0089	هلسا ایرانیان	لوبیا قرمز، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	لوبیا قرمز از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	175000	\N	\N	0	TOMAN	40	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	لوبیا قرمز	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/red-beans.jpg	تصویر لوبیا قرمز هلسا	brand_asset	["/images/opt/red-beans.jpg"]	0	0	\N	["حبوبات", "لوبیا قرمز"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "لوبیا قرمز"}]	[{"label": "انرژی", "value": "۳۳۷ کیلوکالری"}, {"label": "پروتئین", "value": "۲۳ گرم"}, {"label": "کربوهیدرات", "value": "۶۱ گرم"}, {"label": "چربی", "value": "۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱۵ گرم"}]	[]	t	f	t	خرید لوبیا قرمز هلسا	لوبیا قرمز، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.913207	2026-09-13 10:59:48.073022
127	نخودچی	roasted-chickpeas	legumes	20	CAT-0093	هلسا ایرانیان	نخودچی، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نخودچی از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	30	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	نخودچی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/roasted-chickpeas.jpg	تصویر نخودچی هلسا	brand_asset	["/images/opt/roasted-chickpeas.jpg"]	0	0	\N	["حبوبات", "نخودچی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نخودچی"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۰ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۵ گرم"}, {"label": "فیبر رژیمی", "value": "۱۲ گرم"}]	[]	t	f	t	خرید نخودچی هلسا	نخودچی، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.940148	2026-09-13 10:59:48.073022
131	زیتون سبز	green-olives	olives	22	CAT-0097	هلسا ایرانیان	زیتون سبز، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی.	زیتون سبز از محصولات منتخب هلسا در دسته زیتون است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	220000	\N	\N	0	TOMAN	25	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	زیتون سبز	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olives-green.jpg	تصویر زیتون سبز هلسا	brand_asset	["/images/opt/olives-green.jpg"]	0	0	\N	["زیتون", "زیتون سبز"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زیتون سبز"}]	[{"label": "انرژی", "value": "۱۱۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۶ گرم"}, {"label": "چربی", "value": "۱۱ گرم"}, {"label": "فیبر رژیمی", "value": "۳ گرم"}]	[]	t	f	t	خرید زیتون سبز هلسا	زیتون سبز، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.959798	2026-09-13 10:59:48.073022
133	زیتون بدون هسته	pitted-olives	olives	22	CAT-0099	هلسا ایرانیان	زیتون بدون هسته، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی.	زیتون بدون هسته از محصولات منتخب هلسا در دسته زیتون است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	زیتون بدون هسته	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olives-green.jpg	تصویر زیتون بدون هسته هلسا	brand_asset	["/images/opt/olives-green.jpg"]	0	0	\N	["زیتون", "زیتون بدون هسته"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زیتون بدون هسته"}]	[{"label": "انرژی", "value": "۱۱۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۶ گرم"}, {"label": "چربی", "value": "۱۱ گرم"}, {"label": "فیبر رژیمی", "value": "۳ گرم"}]	[]	t	f	t	خرید زیتون بدون هسته هلسا	زیتون بدون هسته، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.967599	2026-09-13 10:59:48.073022
138	ترشی سیر	garlic-pickles	pickles	23	CAT-0104	هلسا ایرانیان	ترشی سیر، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی.	ترشی سیر از محصولات منتخب هلسا در دسته ترشیجات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ترشی سیر	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pickles.jpg	تصویر ترشی سیر هلسا	brand_asset	["/images/opt/pickles.jpg"]	0	0	\N	["ترشیجات", "ترشی سیر"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ترشی سیر"}]	[{"label": "انرژی", "value": "۳۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۷ گرم"}, {"label": "چربی", "value": "۰.۲ گرم"}, {"label": "فیبر رژیمی", "value": "۲ گرم"}]	[]	t	f	t	خرید ترشی سیر هلسا	ترشی سیر، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.986654	2026-09-13 10:59:48.073022
45	تخمه آفتابگردان	sunflower-seeds	seeds	7	CAT-0011	هلسا ایرانیان	تخمه آفتابگردان، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه آفتابگردان از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	155000	\N	\N	0	TOMAN	55	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه آفتابگردان	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sunflower-seeds.jpg	تصویر تخمه آفتابگردان هلسا	brand_asset	["/images/opt/sunflower-seeds.jpg"]	0	0	\N	["تخمه", "تخمه آفتابگردان"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه آفتابگردان"}]	[{"label": "انرژی", "value": "۵۸۴ کیلوکالری"}, {"label": "پروتئین", "value": "۲۱ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۱ گرم"}, {"label": "فیبر رژیمی", "value": "۹ گرم"}]	[]	t	f	t	خرید تخمه آفتابگردان هلسا	تخمه آفتابگردان، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.451384	2026-09-13 10:59:48.073022
156	دمنوش ویژه پذیرایی	hospitality-herbal-tea	herbal-tea	27	CAT-0122	هلسا ایرانیان	دمنوش ویژه پذیرایی، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش ویژه پذیرایی از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	250000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش ویژه پذیرایی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/herbal-tea.jpg	تصویر دمنوش ویژه پذیرایی هلسا	brand_asset	["/images/opt/herbal-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش ویژه پذیرایی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش ویژه پذیرایی"}]	[]	[]	t	f	t	خرید دمنوش ویژه پذیرایی هلسا	دمنوش ویژه پذیرایی، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.056145	2026-09-13 10:59:48.073022
166	گل محمدی خشک	dried-rose	rosebuds	30	CAT-0132	هلسا ایرانیان	گل محمدی خشک، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی.	گل محمدی خشک از محصولات منتخب هلسا در دسته گل محمدی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	175000	\N	\N	0	TOMAN	30	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	گل محمدی خشک	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rosebuds.jpg	تصویر گل محمدی خشک هلسا	brand_asset	["/images/opt/rosebuds.jpg"]	0	0	\N	["گل محمدی", "گل محمدی خشک"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "گل محمدی خشک"}]	[]	[]	t	f	t	خرید گل محمدی خشک هلسا	گل محمدی خشک، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.097201	2026-09-13 10:59:48.073022
124	لوبیا چیتی	pinto-beans	legumes	20	CAT-0090	هلسا ایرانیان	لوبیا چیتی، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	لوبیا چیتی از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	38	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	لوبیا چیتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pinto-beans.jpg	تصویر لوبیا چیتی هلسا	brand_asset	["/images/opt/pinto-beans.jpg"]	0	0	\N	["حبوبات", "لوبیا چیتی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "لوبیا چیتی"}]	[{"label": "انرژی", "value": "۳۴۷ کیلوکالری"}, {"label": "پروتئین", "value": "۲۱ گرم"}, {"label": "کربوهیدرات", "value": "۶۳ گرم"}, {"label": "چربی", "value": "۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱۶ گرم"}]	[]	t	f	t	خرید لوبیا چیتی هلسا	لوبیا چیتی، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.919834	2026-09-13 10:59:48.073022
64	نبات ساده	plain-rock-candy	rock-candy	10	CAT-0030	هلسا ایرانیان	نبات ساده، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نبات ساده از محصولات منتخب هلسا در دسته نبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	120000	\N	\N	0	TOMAN	46	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نبات ساده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rock-candy.jpg	تصویر نبات ساده هلسا	brand_asset	["/images/opt/rock-candy.jpg"]	0	0	\N	["نبات", "نبات ساده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نبات ساده"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۹ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید نبات ساده هلسا	نبات ساده، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.59263	2026-09-13 10:59:48.073022
70	زرشک ممتاز هلسا	helsa-premium-barberry	barberry	11	CAT-0036	هلسا ایرانیان	زرشک ممتاز هلسا، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی.	زرشک ممتاز هلسا از محصولات منتخب هلسا در دسته زرشک است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: خراسان جنوبی. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	440000	\N	\N	0	TOMAN	18	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	زرشک ممتاز هلسا	خراسان جنوبی	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/barberry.jpg	تصویر زرشک ممتاز هلسا هلسا	brand_asset	["/images/opt/barberry.jpg"]	0	0	\N	["زرشک", "زرشک ممتاز هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "خراسان جنوبی"}, {"label": "مواد اولیه", "value": "زرشک ممتاز هلسا"}]	[{"label": "انرژی", "value": "۱۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱.۵ گرم"}, {"label": "کربوهیدرات", "value": "۳۵ گرم"}, {"label": "چربی", "value": "۰.۵ گرم"}, {"label": "فیبر رژیمی", "value": "۹ گرم"}]	[]	t	f	t	خرید زرشک ممتاز هلسا هلسا	زرشک ممتاز هلسا، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.623673	2026-09-13 10:59:48.073022
115	نقل مغزدار	filled-noghl	noghl	18	CAT-0081	هلسا ایرانیان	نقل مغزدار، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی.	نقل مغزدار از محصولات منتخب هلسا در دسته نقل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نقل مغزدار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/noghl.jpg	تصویر نقل مغزدار هلسا	brand_asset	["/images/opt/noghl.jpg"]	0	0	\N	["نقل", "نقل مغزدار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نقل مغزدار"}]	[{"label": "انرژی", "value": "۳۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۹۵ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید نقل مغزدار هلسا	نقل مغزدار، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.876477	2026-09-13 10:59:48.073022
164	روغن کنجد ویژه هلسا	helsa-sesame-oil	oils	29	CAT-0130	هلسا ایرانیان	روغن کنجد ویژه هلسا، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی.	روغن کنجد ویژه هلسا از محصولات منتخب هلسا در دسته روغن است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	490000	\N	\N	0	TOMAN	14	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	روغن کنجد ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-oil.jpg	تصویر روغن کنجد ویژه هلسا هلسا	brand_asset	["/images/opt/sesame-oil.jpg"]	0	0	\N	["روغن", "روغن کنجد ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "روغن کنجد ویژه هلسا"}]	[{"label": "انرژی", "value": "۸۸۴ کیلوکالری"}, {"label": "چربی کل", "value": "۱۰۰ گرم"}, {"label": "چربی اشباع", "value": "۱۴ گرم"}]	[]	t	f	t	خرید روغن کنجد ویژه هلسا هلسا	روغن کنجد ویژه هلسا، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.086649	2026-09-13 10:59:48.073022
74	بادام زمینی طعم‌دار	flavored-peanuts	peanuts	12	CAT-0040	هلسا ایرانیان	بادام زمینی طعم‌دار، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	بادام زمینی طعم‌دار از محصولات منتخب هلسا در دسته بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	\N	\N	0	TOMAN	24	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	بادام زمینی طعم‌دار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanuts-roasted.jpg	تصویر بادام زمینی طعم‌دار هلسا	brand_asset	["/images/opt/peanuts-roasted.jpg"]	0	0	\N	["بادام زمینی", "بادام زمینی طعم‌دار"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بادام زمینی طعم‌دار"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید بادام زمینی طعم‌دار هلسا	بادام زمینی طعم‌دار، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.660432	2026-09-13 10:59:48.073022
159	کره بادام زمینی شکلاتی	chocolate-peanut-butter	peanut-butter	28	CAT-0125	هلسا ایرانیان	کره بادام زمینی شکلاتی، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	کره بادام زمینی شکلاتی از محصولات منتخب هلسا در دسته کره بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	310000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کره بادام زمینی شکلاتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanut-butter.jpg	تصویر کره بادام زمینی شکلاتی هلسا	brand_asset	["/images/opt/peanut-butter.jpg"]	0	0	\N	["کره بادام زمینی", "کره بادام زمینی شکلاتی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کره بادام زمینی شکلاتی"}]	[{"label": "انرژی", "value": "۵۸۸ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید کره بادام زمینی شکلاتی هلسا	کره بادام زمینی شکلاتی، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.067642	2026-09-13 10:59:48.073022
101	شکلات مغزدار	filled-chocolate	chocolate	16	CAT-0067	هلسا ایرانیان	شکلات مغزدار، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات مغزدار از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	390000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات مغزدار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات مغزدار هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات مغزدار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات مغزدار"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات مغزدار هلسا	شکلات مغزدار، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.821807	2026-09-13 10:59:48.073022
38	آجیل اقتصادی	everyday-nuts	nuts-dried-fruits	6	CAT-0004	هلسا ایرانیان	آجیل اقتصادی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل اقتصادی از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	460000	\N	\N	0	TOMAN	34	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل اقتصادی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل اقتصادی هلسا	brand_asset	["/images/opt/premium-mixed-nuts.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل اقتصادی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل اقتصادی"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل اقتصادی هلسا	آجیل اقتصادی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.343871	2026-09-13 10:32:57.217
39	آجیل مهمانی	party-nuts-collection	nuts-dried-fruits	6	CAT-0005	هلسا ایرانیان	آجیل مهمانی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل مهمانی از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	890000	\N	\N	0	TOMAN	18	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل مهمانی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل مهمانی هلسا	brand_asset	["/images/opt/premium-mixed-nuts.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل مهمانی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل مهمانی"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل مهمانی هلسا	آجیل مهمانی، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.360953	2026-09-13 10:32:57.224
130	پنیر ویژه هلسا	helsa-cheese	cheese	21	CAT-0096	هلسا ایرانیان	پنیر ویژه هلسا، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی.	پنیر ویژه هلسا از محصولات منتخب هلسا در دسته پنیر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	340000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پنیر ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/cheese.jpg	تصویر پنیر ویژه هلسا هلسا	brand_asset	["/images/opt/cheese.jpg"]	0	0	\N	["پنیر", "پنیر ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پنیر ویژه هلسا"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۴ گرم"}, {"label": "کربوهیدرات", "value": "۲ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید پنیر ویژه هلسا هلسا	پنیر ویژه هلسا، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.955324	2026-09-13 10:59:48.073022
137	ترشی لیته	liteh-pickles	pickles	23	CAT-0103	هلسا ایرانیان	ترشی لیته، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی.	ترشی لیته از محصولات منتخب هلسا در دسته ترشیجات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ترشی لیته	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pickles.jpg	تصویر ترشی لیته هلسا	brand_asset	["/images/opt/pickles.jpg"]	0	0	\N	["ترشیجات", "ترشی لیته"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ترشی لیته"}]	[{"label": "انرژی", "value": "۳۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۷ گرم"}, {"label": "چربی", "value": "۰.۲ گرم"}, {"label": "فیبر رژیمی", "value": "۲ گرم"}]	[]	t	f	t	خرید ترشی لیته هلسا	ترشی لیته، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.982817	2026-09-13 10:59:48.073022
49	تخمه بوداده	roasted-seeds	seeds	7	CAT-0015	هلسا ایرانیان	تخمه بوداده، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه بوداده از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	38	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه بوداده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sunflower-seeds.jpg	تصویر تخمه بوداده هلسا	brand_asset	["/images/opt/sunflower-seeds.jpg"]	0	0	\N	["تخمه", "تخمه بوداده"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه بوداده"}]	[{"label": "انرژی", "value": "۵۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۶ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۴۸ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید تخمه بوداده هلسا	تخمه بوداده، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.500111	2026-09-13 10:59:48.073022
60	عسل خلیلو	khalilo-honey	honey	9	CAT-0026	هلسا ایرانیان	عسل خلیلو، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل خلیلو از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	710000	\N	\N	0	TOMAN	10	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل خلیلو	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-jar.jpg	تصویر عسل خلیلو هلسا	brand_asset	["/images/opt/honey-jar.jpg"]	0	0	\N	["عسل", "عسل خلیلو"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عسل خلیلو"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل خلیلو هلسا	عسل خلیلو، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.575983	2026-09-13 10:59:48.073022
126	ماش	mung-beans	legumes	20	CAT-0092	هلسا ایرانیان	ماش، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	ماش از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	165000	\N	\N	0	TOMAN	36	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ماش	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/mung-beans.jpg	تصویر ماش هلسا	brand_asset	["/images/opt/mung-beans.jpg"]	0	0	\N	["حبوبات", "ماش"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ماش"}]	[{"label": "انرژی", "value": "۳۴۷ کیلوکالری"}, {"label": "پروتئین", "value": "۲۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۳ گرم"}, {"label": "چربی", "value": "۱.۲ گرم"}, {"label": "فیبر رژیمی", "value": "۱۶ گرم"}]	[]	t	f	t	خرید ماش هلسا	ماش، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.93303	2026-09-13 10:59:48.073022
69	زرشک دانه‌اناری	pomegranate-barberry	barberry	11	CAT-0035	هلسا ایرانیان	زرشک دانه‌اناری، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی.	زرشک دانه‌اناری از محصولات منتخب هلسا در دسته زرشک است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: خراسان جنوبی. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	320000	\N	\N	0	TOMAN	29	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	زرشک دانه‌اناری	خراسان جنوبی	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/barberry.jpg	تصویر زرشک دانه‌اناری هلسا	brand_asset	["/images/opt/barberry.jpg"]	0	0	\N	["زرشک", "زرشک دانه‌اناری"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "خراسان جنوبی"}, {"label": "مواد اولیه", "value": "زرشک دانه‌اناری"}]	[{"label": "انرژی", "value": "۱۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱.۵ گرم"}, {"label": "کربوهیدرات", "value": "۳۵ گرم"}, {"label": "چربی", "value": "۰.۵ گرم"}, {"label": "فیبر رژیمی", "value": "۹ گرم"}]	[]	t	f	t	خرید زرشک دانه‌اناری هلسا	زرشک دانه‌اناری، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.616353	2026-09-13 10:59:48.073022
112	نقل ساده	plain-noghl	noghl	18	CAT-0078	هلسا ایرانیان	نقل ساده، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی.	نقل ساده از محصولات منتخب هلسا در دسته نقل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	145000	\N	\N	0	TOMAN	32	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نقل ساده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/noghl.jpg	تصویر نقل ساده هلسا	brand_asset	["/images/opt/noghl.jpg"]	0	0	\N	["نقل", "نقل ساده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نقل ساده"}]	[{"label": "انرژی", "value": "۳۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۹۵ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید نقل ساده هلسا	نقل ساده، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.864656	2026-09-13 10:59:48.073022
163	روغن زیتون فرابکر	extra-virgin-olive-oil	oils	29	CAT-0129	هلسا ایرانیان	روغن زیتون فرابکر، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی.	روغن زیتون فرابکر از محصولات منتخب هلسا در دسته روغن است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	520000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	روغن زیتون فرابکر	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olive-oil.jpg	تصویر روغن زیتون فرابکر هلسا	brand_asset	["/images/opt/olive-oil.jpg"]	0	0	\N	["روغن", "روغن زیتون فرابکر"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "روغن زیتون فرابکر"}]	[{"label": "انرژی", "value": "۸۸۴ کیلوکالری"}, {"label": "چربی کل", "value": "۱۰۰ گرم"}, {"label": "چربی اشباع", "value": "۱۴ گرم"}]	[]	t	f	t	خرید روغن زیتون فرابکر هلسا	روغن زیتون فرابکر، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.082649	2026-09-13 10:59:48.073022
160	کره بادام زمینی ویژه هلسا	helsa-peanut-butter	peanut-butter	28	CAT-0126	هلسا ایرانیان	کره بادام زمینی ویژه هلسا، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	کره بادام زمینی ویژه هلسا از محصولات منتخب هلسا در دسته کره بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	340000	\N	\N	0	TOMAN	14	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کره بادام زمینی ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanut-butter.jpg	تصویر کره بادام زمینی ویژه هلسا هلسا	brand_asset	["/images/opt/peanut-butter.jpg"]	0	0	\N	["کره بادام زمینی", "کره بادام زمینی ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کره بادام زمینی ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۸۸ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید کره بادام زمینی ویژه هلسا هلسا	کره بادام زمینی ویژه هلسا، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.071326	2026-09-13 10:59:48.073022
102	شکلات دست‌ساز هلسا	helsa-handmade-chocolate	chocolate	16	CAT-0068	هلسا ایرانیان	شکلات دست‌ساز هلسا، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات دست‌ساز هلسا از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	460000	\N	\N	0	TOMAN	15	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات دست‌ساز هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات دست‌ساز هلسا هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات دست‌ساز هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات دست‌ساز هلسا"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات دست‌ساز هلسا هلسا	شکلات دست‌ساز هلسا، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.825594	2026-09-13 10:59:48.073022
82	ادویه خورشتی	stew-spice	spices	14	CAT-0048	هلسا ایرانیان	ادویه خورشتی، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه خورشتی از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	125000	\N	\N	0	TOMAN	40	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه خورشتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه خورشتی هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه خورشتی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه خورشتی"}]	[]	[]	t	f	t	خرید ادویه خورشتی هلسا	ادویه خورشتی، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.703873	2026-09-13 10:59:48.073022
145	ارده سنتی	traditional-tahini	tahini	25	CAT-0111	هلسا ایرانیان	ارده سنتی، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	ارده سنتی از محصولات منتخب هلسا در دسته ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ارده سنتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/tahini.jpg	تصویر ارده سنتی هلسا	brand_asset	["/images/opt/tahini.jpg"]	0	0	\N	["ارده", "ارده سنتی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ارده سنتی"}]	[{"label": "انرژی", "value": "۵۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۲۱ گرم"}, {"label": "چربی", "value": "۵۴ گرم"}]	[]	t	f	t	خرید ارده سنتی هلسا	ارده سنتی، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.013209	2026-09-13 10:59:48.073022
35	آجیل مخلوط هلسا	helsa-mixed-nuts	nuts-dried-fruits	6	CAT-0001	هلسا ایرانیان	آجیل مخلوط هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل مخلوط هلسا از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	690000	\N	\N	0	TOMAN	28	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل مخلوط هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل مخلوط هلسا هلسا	brand_asset	["/images/opt/premium-mixed-nuts.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل مخلوط هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل مخلوط هلسا"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل مخلوط هلسا هلسا	آجیل مخلوط هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.14914	2026-09-13 10:32:57.18
37	آجیل ویژه هلسا	helsa-signature-nuts	nuts-dried-fruits	6	CAT-0003	هلسا ایرانیان	آجیل ویژه هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل ویژه هلسا از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	980000	\N	\N	0	TOMAN	12	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل ویژه هلسا هلسا	brand_asset	["/images/opt/premium-mixed-nuts.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل ویژه هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل ویژه هلسا"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل ویژه هلسا هلسا	آجیل ویژه هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.333655	2026-09-13 10:32:57.21
337	براونی فاج هلسا	fudge-brownie	cakes-desserts	64	CAT-0154	هلسا ایرانیان	براونی فاج هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	براونی فاج هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	380000	\N	\N	0	TOMAN	20	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	براونی فاج هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/fudge-brownie.jpg	تصویر براونی فاج هلسا هلسا	brand_asset	["/images/opt/fudge-brownie.jpg"]	0	0	\N	["کیک و دسر", "براونی فاج هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "براونی فاج هلسا"}]	[{"label": "انرژی", "value": "۴۳۰ کیلوکالری"}, {"label": "پروتئین", "value": "۵ گرم"}, {"label": "کربوهیدرات", "value": "۵۵ گرم"}, {"label": "چربی", "value": "۲۲ گرم"}, {"label": "فیبر رژیمی", "value": "۲٫۵ گرم"}]	[]	t	f	t	خرید براونی فاج هلسا هلسا	براونی فاج هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.746271	2026-09-16 09:32:11.575
334	چیزکیک نیویورکی هلسا	new-york-cheesecake	cakes-desserts	64	CAT-0151	هلسا ایرانیان	چیزکیک نیویورکی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	چیزکیک نیویورکی هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	580000	\N	\N	0	TOMAN	12	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	چیزکیک نیویورکی هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/new-york-cheesecake.jpg	تصویر چیزکیک نیویورکی هلسا هلسا	brand_asset	["/images/opt/new-york-cheesecake.jpg"]	0	0	\N	["کیک و دسر", "چیزکیک نیویورکی هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "چیزکیک نیویورکی هلسا"}]	[{"label": "انرژی", "value": "۳۳۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۳۰ گرم"}, {"label": "چربی", "value": "۲۱ گرم"}, {"label": "فیبر رژیمی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید چیزکیک نیویورکی هلسا هلسا	چیزکیک نیویورکی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.728656	2026-09-16 09:32:11.583
147	ارده ویژه هلسا	helsa-tahini	tahini	25	CAT-0113	هلسا ایرانیان	ارده ویژه هلسا، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	ارده ویژه هلسا از محصولات منتخب هلسا در دسته ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	310000	\N	\N	0	TOMAN	14	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ارده ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/tahini.jpg	تصویر ارده ویژه هلسا هلسا	brand_asset	["/images/opt/tahini.jpg"]	0	0	\N	["ارده", "ارده ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ارده ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۲۱ گرم"}, {"label": "چربی", "value": "۵۴ گرم"}]	[]	t	f	t	خرید ارده ویژه هلسا هلسا	ارده ویژه هلسا، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.020997	2026-09-13 10:59:48.073022
341	مربای بالنگ هلسا	balang-jam	jams	65	CAT-0158	هلسا ایرانیان	مربای بالنگ هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای بالنگ هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	360000	\N	\N	0	TOMAN	14	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای بالنگ هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/balang-jam.jpg	تصویر مربای بالنگ هلسا هلسا	brand_asset	["/images/opt/balang-jam.jpg"]	0	0	\N	["مربا", "مربای بالنگ هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای بالنگ هلسا"}]	[{"label": "انرژی", "value": "۲۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱٫۵ گرم"}]	[]	t	f	t	خرید مربای بالنگ هلسا هلسا	مربای بالنگ هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.771987	2026-09-16 09:32:11.564
100	شکلات شیری	milk-chocolate	chocolate	16	CAT-0066	هلسا ایرانیان	شکلات شیری، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات شیری از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	310000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات شیری	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات شیری هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات شیری"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات شیری"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات شیری هلسا	شکلات شیری، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.817963	2026-09-13 10:59:48.073022
99	شکلات تلخ	dark-chocolate	chocolate	16	CAT-0065	هلسا ایرانیان	شکلات تلخ، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات تلخ از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	330000	\N	\N	0	TOMAN	26	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات تلخ	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات تلخ هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات تلخ"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات تلخ"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات تلخ هلسا	شکلات تلخ، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.813902	2026-09-13 10:59:48.073022
103	شکلات ویژه هلسا	helsa-signature-chocolate	chocolate	16	CAT-0069	هلسا ایرانیان	شکلات ویژه هلسا، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات ویژه هلسا از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	520000	\N	\N	0	TOMAN	10	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات ویژه هلسا هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات ویژه هلسا هلسا	شکلات ویژه هلسا، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.829318	2026-09-13 10:59:48.073022
104	شکلات پذیرایی	hospitality-chocolate	chocolate	16	CAT-0070	هلسا ایرانیان	شکلات پذیرایی، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات پذیرایی از محصولات منتخب هلسا در دسته شکلات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	420000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات پذیرایی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chocolate-assorted.jpg	تصویر شکلات پذیرایی هلسا	brand_asset	["/images/opt/chocolate-assorted.jpg"]	0	0	\N	["شکلات", "شکلات پذیرایی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات پذیرایی"}]	[{"label": "انرژی", "value": "۵۴۵ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	[]	t	f	t	خرید شکلات پذیرایی هلسا	شکلات پذیرایی، از مجموعه شکلات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.833224	2026-09-13 10:59:48.073022
172	شکلات خرمایی نارگیلی	coconut-date-chocolate	date-chocolate	32	CAT-0138	هلسا ایرانیان	شکلات خرمایی نارگیلی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات خرمایی نارگیلی از محصولات منتخب هلسا در دسته شکلات خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	420000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات خرمایی نارگیلی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-chocolate.jpg	تصویر شکلات خرمایی نارگیلی هلسا	brand_asset	["/images/opt/date-chocolate.jpg"]	0	0	\N	["شکلات خرما", "شکلات خرمایی نارگیلی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات خرمایی نارگیلی"}]	[{"label": "انرژی", "value": "۴۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید شکلات خرمایی نارگیلی هلسا	شکلات خرمایی نارگیلی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.127512	2026-09-13 10:59:48.073022
125	لپه	split-peas	legumes	20	CAT-0091	هلسا ایرانیان	لپه، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	لپه از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	170000	\N	\N	0	TOMAN	44	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	لپه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/split-peas.jpg	تصویر لپه هلسا	brand_asset	["/images/opt/split-peas.jpg"]	0	0	\N	["حبوبات", "لپه"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "لپه"}]	[{"label": "انرژی", "value": "۳۴۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۱.۵ گرم"}, {"label": "فیبر رژیمی", "value": "۱۰ گرم"}]	[]	t	f	t	خرید لپه هلسا	لپه، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.92629	2026-09-13 10:59:48.073022
122	نخود	chickpeas	legumes	20	CAT-0088	هلسا ایرانیان	نخود، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نخود از محصولات منتخب هلسا در دسته حبوبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	150000	\N	\N	0	TOMAN	42	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	نخود	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/chickpeas.jpg	تصویر نخود هلسا	brand_asset	["/images/opt/chickpeas.jpg"]	0	0	\N	["حبوبات", "نخود"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نخود"}]	[{"label": "انرژی", "value": "۳۶۴ کیلوکالری"}, {"label": "پروتئین", "value": "۱۹ گرم"}, {"label": "کربوهیدرات", "value": "۶۱ گرم"}, {"label": "چربی", "value": "۶ گرم"}, {"label": "فیبر رژیمی", "value": "۱۷ گرم"}]	[]	t	f	t	خرید نخود هلسا	نخود، از مجموعه حبوبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.906562	2026-09-13 10:59:48.073022
63	نبات زعفرانی	saffron-rock-candy	rock-candy	10	CAT-0029	هلسا ایرانیان	نبات زعفرانی، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نبات زعفرانی از محصولات منتخب هلسا در دسته نبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	35	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نبات زعفرانی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/saffron-rock-candy.jpg	تصویر نبات زعفرانی هلسا	brand_asset	["/images/opt/saffron-rock-candy.jpg"]	0	0	\N	["نبات", "نبات زعفرانی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نبات زعفرانی"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۹ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید نبات زعفرانی هلسا	نبات زعفرانی، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.588198	2026-09-13 10:59:48.073022
65	نبات چوبی	stick-rock-candy	rock-candy	10	CAT-0031	هلسا ایرانیان	نبات چوبی، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نبات چوبی از محصولات منتخب هلسا در دسته نبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	160000	\N	\N	0	TOMAN	30	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نبات چوبی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rock-candy.jpg	تصویر نبات چوبی هلسا	brand_asset	["/images/opt/rock-candy.jpg"]	0	0	\N	["نبات", "نبات چوبی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نبات چوبی"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۹ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید نبات چوبی هلسا	نبات چوبی، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.597445	2026-09-13 10:59:48.073022
66	نبات شاخه‌ای	branch-rock-candy	rock-candy	10	CAT-0032	هلسا ایرانیان	نبات شاخه‌ای، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نبات شاخه‌ای از محصولات منتخب هلسا در دسته نبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	145000	\N	\N	0	TOMAN	28	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نبات شاخه‌ای	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rock-candy.jpg	تصویر نبات شاخه‌ای هلسا	brand_asset	["/images/opt/rock-candy.jpg"]	0	0	\N	["نبات", "نبات شاخه‌ای"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نبات شاخه‌ای"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۹ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید نبات شاخه‌ای هلسا	نبات شاخه‌ای، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.601539	2026-09-13 10:59:48.073022
67	نبات ویژه هلسا	helsa-rock-candy	rock-candy	10	CAT-0033	هلسا ایرانیان	نبات ویژه هلسا، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	نبات ویژه هلسا از محصولات منتخب هلسا در دسته نبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نبات ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rock-candy.jpg	تصویر نبات ویژه هلسا هلسا	brand_asset	["/images/opt/rock-candy.jpg"]	0	0	\N	["نبات", "نبات ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نبات ویژه هلسا"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۹ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید نبات ویژه هلسا هلسا	نبات ویژه هلسا، از مجموعه نبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.605541	2026-09-13 10:59:48.073022
68	زرشک پفکی	puffy-barberry	barberry	11	CAT-0034	هلسا ایرانیان	زرشک پفکی، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی.	زرشک پفکی از محصولات منتخب هلسا در دسته زرشک است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: خراسان جنوبی. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	390000	\N	\N	0	TOMAN	25	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	زرشک پفکی	خراسان جنوبی	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/barberry.jpg	تصویر زرشک پفکی هلسا	brand_asset	["/images/opt/barberry.jpg"]	0	0	\N	["زرشک", "زرشک پفکی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "خراسان جنوبی"}, {"label": "مواد اولیه", "value": "زرشک پفکی"}]	[{"label": "انرژی", "value": "۱۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱.۵ گرم"}, {"label": "کربوهیدرات", "value": "۳۵ گرم"}, {"label": "چربی", "value": "۰.۵ گرم"}, {"label": "فیبر رژیمی", "value": "۹ گرم"}]	[]	t	f	t	خرید زرشک پفکی هلسا	زرشک پفکی، از مجموعه زرشک هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.609427	2026-09-13 10:59:48.073022
75	آبنبات ساده	plain-candy	candy	13	CAT-0041	هلسا ایرانیان	آبنبات ساده، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	آبنبات ساده از محصولات منتخب هلسا در دسته آبنبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	95000	\N	\N	0	TOMAN	52	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	آبنبات ساده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/candy.jpg	تصویر آبنبات ساده هلسا	brand_asset	["/images/opt/candy.jpg"]	0	0	\N	["آبنبات", "آبنبات ساده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آبنبات ساده"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۸ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید آبنبات ساده هلسا	آبنبات ساده، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.667645	2026-09-13 10:59:48.073022
77	آبنبات میوه‌ای	fruit-candy	candy	13	CAT-0043	هلسا ایرانیان	آبنبات میوه‌ای، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	آبنبات میوه‌ای از محصولات منتخب هلسا در دسته آبنبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	135000	\N	\N	0	TOMAN	36	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	آبنبات میوه‌ای	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/candy.jpg	تصویر آبنبات میوه‌ای هلسا	brand_asset	["/images/opt/candy.jpg"]	0	0	\N	["آبنبات", "آبنبات میوه‌ای"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آبنبات میوه‌ای"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۸ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید آبنبات میوه‌ای هلسا	آبنبات میوه‌ای، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.676237	2026-09-13 10:59:48.073022
78	آبنبات مغزدار	filled-candy	candy	13	CAT-0044	هلسا ایرانیان	آبنبات مغزدار، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	آبنبات مغزدار از محصولات منتخب هلسا در دسته آبنبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	180000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	آبنبات مغزدار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/candy.jpg	تصویر آبنبات مغزدار هلسا	brand_asset	["/images/opt/candy.jpg"]	0	0	\N	["آبنبات", "آبنبات مغزدار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آبنبات مغزدار"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۸ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید آبنبات مغزدار هلسا	آبنبات مغزدار، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.680636	2026-09-13 10:59:48.073022
79	آبنبات ویژه هلسا	helsa-candy	candy	13	CAT-0045	هلسا ایرانیان	آبنبات ویژه هلسا، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	آبنبات ویژه هلسا از محصولات منتخب هلسا در دسته آبنبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	آبنبات ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/candy.jpg	تصویر آبنبات ویژه هلسا هلسا	brand_asset	["/images/opt/candy.jpg"]	0	0	\N	["آبنبات", "آبنبات ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آبنبات ویژه هلسا"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۸ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید آبنبات ویژه هلسا هلسا	آبنبات ویژه هلسا، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.684971	2026-09-13 10:59:48.073022
114	نقل بیدمشکی	bidmeshk-noghl	noghl	18	CAT-0080	هلسا ایرانیان	نقل بیدمشکی، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی.	نقل بیدمشکی از محصولات منتخب هلسا در دسته نقل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	27	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نقل بیدمشکی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/noghl.jpg	تصویر نقل بیدمشکی هلسا	brand_asset	["/images/opt/noghl.jpg"]	0	0	\N	["نقل", "نقل بیدمشکی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نقل بیدمشکی"}]	[{"label": "انرژی", "value": "۳۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۹۵ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید نقل بیدمشکی هلسا	نقل بیدمشکی، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.872803	2026-09-13 10:59:48.073022
116	نقل ویژه هلسا	helsa-noghl	noghl	18	CAT-0082	هلسا ایرانیان	نقل ویژه هلسا، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی.	نقل ویژه هلسا از محصولات منتخب هلسا در دسته نقل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	275000	\N	\N	0	TOMAN	15	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نقل ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/noghl.jpg	تصویر نقل ویژه هلسا هلسا	brand_asset	["/images/opt/noghl.jpg"]	0	0	\N	["نقل", "نقل ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نقل ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۹۵ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید نقل ویژه هلسا هلسا	نقل ویژه هلسا، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.88073	2026-09-13 10:59:48.073022
161	روغن زیتون	olive-oil	oils	29	CAT-0127	هلسا ایرانیان	روغن زیتون، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی.	روغن زیتون از محصولات منتخب هلسا در دسته روغن است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	420000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	روغن زیتون	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olive-oil.jpg	تصویر روغن زیتون هلسا	brand_asset	["/images/opt/olive-oil.jpg"]	0	0	\N	["روغن", "روغن زیتون"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "روغن زیتون"}]	[{"label": "انرژی", "value": "۸۸۴ کیلوکالری"}, {"label": "چربی کل", "value": "۱۰۰ گرم"}, {"label": "چربی اشباع", "value": "۱۴ گرم"}]	[]	t	f	t	خرید روغن زیتون هلسا	روغن زیتون، از مجموعه روغن هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.075011	2026-09-13 10:59:48.073022
72	بادام زمینی خام	raw-peanuts	peanuts	12	CAT-0038	هلسا ایرانیان	بادام زمینی خام، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	بادام زمینی خام از محصولات منتخب هلسا در دسته بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	165000	\N	\N	0	TOMAN	40	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	بادام زمینی خام	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanuts-raw.jpg	تصویر بادام زمینی خام هلسا	brand_asset	["/images/opt/peanuts-raw.jpg"]	0	0	\N	["بادام زمینی", "بادام زمینی خام"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بادام زمینی خام"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید بادام زمینی خام هلسا	بادام زمینی خام، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.640834	2026-09-13 10:59:48.073022
71	بادام زمینی شور	salted-peanuts	peanuts	12	CAT-0037	هلسا ایرانیان	بادام زمینی شور، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	بادام زمینی شور از محصولات منتخب هلسا در دسته بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	44	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	بادام زمینی شور	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanuts-roasted.jpg	تصویر بادام زمینی شور هلسا	brand_asset	["/images/opt/peanuts-roasted.jpg"]	0	0	\N	["بادام زمینی", "بادام زمینی شور"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بادام زمینی شور"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید بادام زمینی شور هلسا	بادام زمینی شور، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.631595	2026-09-13 10:59:48.073022
73	بادام زمینی بوداده	roasted-peanuts	peanuts	12	CAT-0039	هلسا ایرانیان	بادام زمینی بوداده، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	بادام زمینی بوداده از محصولات منتخب هلسا در دسته بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	180000	\N	\N	0	TOMAN	36	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	بادام زمینی بوداده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanuts-roasted.jpg	تصویر بادام زمینی بوداده هلسا	brand_asset	["/images/opt/peanuts-roasted.jpg"]	0	0	\N	["بادام زمینی", "بادام زمینی بوداده"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بادام زمینی بوداده"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید بادام زمینی بوداده هلسا	بادام زمینی بوداده، از مجموعه بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.650772	2026-09-13 10:59:48.073022
148	حلوا ارده ساده	plain-halva-tahini	halva-tahini	26	CAT-0114	هلسا ایرانیان	حلوا ارده ساده، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	حلوا ارده ساده از محصولات منتخب هلسا در دسته حلوا ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	280000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	حلوا ارده ساده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/halva-arde.jpg	تصویر حلوا ارده ساده هلسا	brand_asset	["/images/opt/halva-arde.jpg"]	0	0	\N	["حلوا ارده", "حلوا ارده ساده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "حلوا ارده ساده"}]	[{"label": "انرژی", "value": "۵۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۳ گرم"}, {"label": "کربوهیدرات", "value": "۴۳ گرم"}, {"label": "چربی", "value": "۳۸ گرم"}]	[]	t	f	t	خرید حلوا ارده ساده هلسا	حلوا ارده ساده، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.024981	2026-09-13 10:59:48.073022
149	حلوا ارده پسته‌ای	pistachio-halva-tahini	halva-tahini	26	CAT-0115	هلسا ایرانیان	حلوا ارده پسته‌ای، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	حلوا ارده پسته‌ای از محصولات منتخب هلسا در دسته حلوا ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	380000	\N	\N	0	TOMAN	15	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	حلوا ارده پسته‌ای	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/halva-arde.jpg	تصویر حلوا ارده پسته‌ای هلسا	brand_asset	["/images/opt/halva-arde.jpg"]	0	0	\N	["حلوا ارده", "حلوا ارده پسته‌ای"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "حلوا ارده پسته‌ای"}]	[{"label": "انرژی", "value": "۵۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۳ گرم"}, {"label": "کربوهیدرات", "value": "۴۳ گرم"}, {"label": "چربی", "value": "۳۸ گرم"}]	[]	t	f	t	خرید حلوا ارده پسته‌ای هلسا	حلوا ارده پسته‌ای، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.028947	2026-09-13 10:59:48.073022
150	حلوا ارده ویژه هلسا	helsa-halva-tahini	halva-tahini	26	CAT-0116	هلسا ایرانیان	حلوا ارده ویژه هلسا، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	حلوا ارده ویژه هلسا از محصولات منتخب هلسا در دسته حلوا ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	420000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	حلوا ارده ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/halva-arde.jpg	تصویر حلوا ارده ویژه هلسا هلسا	brand_asset	["/images/opt/halva-arde.jpg"]	0	0	\N	["حلوا ارده", "حلوا ارده ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "حلوا ارده ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۳ گرم"}, {"label": "کربوهیدرات", "value": "۴۳ گرم"}, {"label": "چربی", "value": "۳۸ گرم"}]	[]	t	f	t	خرید حلوا ارده ویژه هلسا هلسا	حلوا ارده ویژه هلسا، از مجموعه حلوا ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.033002	2026-09-13 10:59:48.073022
157	کره بادام زمینی ساده	plain-peanut-butter	peanut-butter	28	CAT-0123	هلسا ایرانیان	کره بادام زمینی ساده، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	کره بادام زمینی ساده از محصولات منتخب هلسا در دسته کره بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	26	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کره بادام زمینی ساده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanut-butter.jpg	تصویر کره بادام زمینی ساده هلسا	brand_asset	["/images/opt/peanut-butter.jpg"]	0	0	\N	["کره بادام زمینی", "کره بادام زمینی ساده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کره بادام زمینی ساده"}]	[{"label": "انرژی", "value": "۵۸۸ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید کره بادام زمینی ساده هلسا	کره بادام زمینی ساده، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.059939	2026-09-13 10:59:48.073022
158	کره بادام زمینی کرانچی	crunchy-peanut-butter	peanut-butter	28	CAT-0124	هلسا ایرانیان	کره بادام زمینی کرانچی، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی.	کره بادام زمینی کرانچی از محصولات منتخب هلسا در دسته کره بادام زمینی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	280000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کره بادام زمینی کرانچی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/peanut-butter.jpg	تصویر کره بادام زمینی کرانچی هلسا	brand_asset	["/images/opt/peanut-butter.jpg"]	0	0	\N	["کره بادام زمینی", "کره بادام زمینی کرانچی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کره بادام زمینی کرانچی"}]	[{"label": "انرژی", "value": "۵۸۸ کیلوکالری"}, {"label": "پروتئین", "value": "۲۵ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید کره بادام زمینی کرانچی هلسا	کره بادام زمینی کرانچی، از مجموعه کره بادام زمینی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.063762	2026-09-13 10:59:48.073022
180	بار کنجد	sesame-bar	sesame-bars	34	CAT-0146	هلسا ایرانیان	بار کنجد، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار کنجد از محصولات منتخب هلسا در دسته بار کنجد است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	170000	\N	\N	0	TOMAN	30	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار کنجد	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-bar.jpg	تصویر بار کنجد هلسا	brand_asset	["/images/opt/sesame-bar.jpg"]	0	0	\N	["بار کنجد", "بار کنجد"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار کنجد"}]	[{"label": "انرژی", "value": "۵۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۲ گرم"}, {"label": "کربوهیدرات", "value": "۵۵ گرم"}, {"label": "چربی", "value": "۲۸ گرم"}]	[]	t	f	t	خرید بار کنجد هلسا	بار کنجد، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.160104	2026-09-13 10:59:48.073022
181	بار کنجد و خرما	sesame-date-bar	sesame-bars	34	CAT-0147	هلسا ایرانیان	بار کنجد و خرما، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار کنجد و خرما از محصولات منتخب هلسا در دسته بار کنجد است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	26	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار کنجد و خرما	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-bar.jpg	تصویر بار کنجد و خرما هلسا	brand_asset	["/images/opt/sesame-bar.jpg"]	0	0	\N	["بار کنجد", "بار کنجد و خرما"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار کنجد و خرما"}]	[{"label": "انرژی", "value": "۵۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۲ گرم"}, {"label": "کربوهیدرات", "value": "۵۵ گرم"}, {"label": "چربی", "value": "۲۸ گرم"}]	[]	t	f	t	خرید بار کنجد و خرما هلسا	بار کنجد و خرما، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.164529	2026-09-13 10:59:48.073022
182	بار کنجد و مغزها	sesame-nut-bar	sesame-bars	34	CAT-0148	هلسا ایرانیان	بار کنجد و مغزها، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار کنجد و مغزها از محصولات منتخب هلسا در دسته بار کنجد است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار کنجد و مغزها	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-bar.jpg	تصویر بار کنجد و مغزها هلسا	brand_asset	["/images/opt/sesame-bar.jpg"]	0	0	\N	["بار کنجد", "بار کنجد و مغزها"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار کنجد و مغزها"}]	[{"label": "انرژی", "value": "۵۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۲ گرم"}, {"label": "کربوهیدرات", "value": "۵۵ گرم"}, {"label": "چربی", "value": "۲۸ گرم"}]	[]	t	f	t	خرید بار کنجد و مغزها هلسا	بار کنجد و مغزها، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.168066	2026-09-13 10:59:48.073022
183	بار کنجد ویژه هلسا	helsa-sesame-bar	sesame-bars	34	CAT-0149	هلسا ایرانیان	بار کنجد ویژه هلسا، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار کنجد ویژه هلسا از محصولات منتخب هلسا در دسته بار کنجد است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار کنجد ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sesame-bar.jpg	تصویر بار کنجد ویژه هلسا هلسا	brand_asset	["/images/opt/sesame-bar.jpg"]	0	0	\N	["بار کنجد", "بار کنجد ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار کنجد ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۲ گرم"}, {"label": "کربوهیدرات", "value": "۵۵ گرم"}, {"label": "چربی", "value": "۲۸ گرم"}]	[]	t	f	t	خرید بار کنجد ویژه هلسا هلسا	بار کنجد ویژه هلسا، از مجموعه بار کنجد هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.171798	2026-09-13 10:59:48.073022
90	سماق	sumac	spices	14	CAT-0056	هلسا ایرانیان	سماق، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	سماق از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	145000	\N	\N	0	TOMAN	33	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	سماق	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sumac.jpg	تصویر سماق هلسا	brand_asset	["/images/opt/sumac.jpg"]	0	0	\N	["ادویه", "سماق"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "سماق"}]	[]	[]	t	f	t	خرید سماق هلسا	سماق، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.771269	2026-09-13 10:59:48.073022
80	ادویه مخصوص هلسا	helsa-spice-blend	spices	14	CAT-0046	هلسا ایرانیان	ادویه مخصوص هلسا، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه مخصوص هلسا از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	30	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه مخصوص هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه مخصوص هلسا هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه مخصوص هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه مخصوص هلسا"}]	[]	[]	t	f	t	خرید ادویه مخصوص هلسا هلسا	ادویه مخصوص هلسا، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.689005	2026-09-13 10:59:48.073022
81	ادویه پلویی	rice-spice	spices	14	CAT-0047	هلسا ایرانیان	ادویه پلویی، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه پلویی از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	125000	\N	\N	0	TOMAN	40	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه پلویی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه پلویی هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه پلویی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه پلویی"}]	[]	[]	t	f	t	خرید ادویه پلویی هلسا	ادویه پلویی، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.69691	2026-09-13 10:59:48.073022
84	ادویه گوشت	meat-spice	spices	14	CAT-0050	هلسا ایرانیان	ادویه گوشت، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	ادویه گوشت از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	145000	\N	\N	0	TOMAN	34	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	ادویه گوشت	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/spice-blend.jpg	تصویر ادویه گوشت هلسا	brand_asset	["/images/opt/spice-blend.jpg"]	0	0	\N	["ادویه", "ادویه گوشت"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ادویه گوشت"}]	[]	[]	t	f	t	خرید ادویه گوشت هلسا	ادویه گوشت، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.720232	2026-09-13 10:59:48.073022
86	فلفل قرمز	red-pepper	spices	14	CAT-0052	هلسا ایرانیان	فلفل قرمز، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	فلفل قرمز از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	120000	\N	\N	0	TOMAN	43	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	فلفل قرمز	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/red-pepper.jpg	تصویر فلفل قرمز هلسا	brand_asset	["/images/opt/red-pepper.jpg"]	0	0	\N	["ادویه", "فلفل قرمز"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "فلفل قرمز"}]	[]	[]	t	f	t	خرید فلفل قرمز هلسا	فلفل قرمز، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.734337	2026-09-13 10:59:48.073022
87	زردچوبه	turmeric	spices	14	CAT-0053	هلسا ایرانیان	زردچوبه، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	زردچوبه از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	110000	\N	\N	0	TOMAN	50	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	زردچوبه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/turmeric.jpg	تصویر زردچوبه هلسا	brand_asset	["/images/opt/turmeric.jpg"]	0	0	\N	["ادویه", "زردچوبه"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زردچوبه"}]	[]	[]	t	f	t	خرید زردچوبه هلسا	زردچوبه، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.741784	2026-09-13 10:59:48.073022
88	دارچین	cinnamon	spices	14	CAT-0054	هلسا ایرانیان	دارچین، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی.	دارچین از محصولات منتخب هلسا در دسته ادویه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	175000	\N	\N	0	TOMAN	38	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	دارچین	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/cinnamon.jpg	تصویر دارچین هلسا	brand_asset	["/images/opt/cinnamon.jpg"]	0	0	\N	["ادویه", "دارچین"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دارچین"}]	[]	[]	t	f	t	خرید دارچین هلسا	دارچین، از مجموعه ادویه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.757073	2026-09-13 10:59:48.073022
92	عرق نعناع	mint-distillate	distillates	15	CAT-0058	هلسا ایرانیان	عرق نعناع، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق نعناع از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	125000	\N	\N	0	TOMAN	30	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق نعناع	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق نعناع هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق نعناع"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق نعناع"}]	[]	[]	t	f	t	خرید عرق نعناع هلسا	عرق نعناع، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.784832	2026-09-13 10:59:48.073022
93	عرق کاسنی	chicory-distillate	distillates	15	CAT-0059	هلسا ایرانیان	عرق کاسنی، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق کاسنی از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	120000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق کاسنی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق کاسنی هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق کاسنی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق کاسنی"}]	[]	[]	t	f	t	خرید عرق کاسنی هلسا	عرق کاسنی، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.789544	2026-09-13 10:59:48.073022
94	عرق بهارنارنج	orange-blossom-distillate	distillates	15	CAT-0060	هلسا ایرانیان	عرق بهارنارنج، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق بهارنارنج از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	155000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق بهارنارنج	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق بهارنارنج هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق بهارنارنج"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق بهارنارنج"}]	[]	[]	t	f	t	خرید عرق بهارنارنج هلسا	عرق بهارنارنج، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.793809	2026-09-13 10:59:48.073022
95	عرق گل محمدی	rose-distillate	distillates	15	CAT-0061	هلسا ایرانیان	عرق گل محمدی، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق گل محمدی از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	165000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق گل محمدی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق گل محمدی هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق گل محمدی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق گل محمدی"}]	[]	[]	t	f	t	خرید عرق گل محمدی هلسا	عرق گل محمدی، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.797543	2026-09-13 10:59:48.073022
97	عرق شاتره	fumitory-distillate	distillates	15	CAT-0063	هلسا ایرانیان	عرق شاتره، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق شاتره از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	120000	\N	\N	0	TOMAN	21	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عرق شاتره	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق شاتره هلسا	brand_asset	["/images/opt/distillate.jpg"]	0	0	\N	["عرقیات", "عرق شاتره"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عرق شاتره"}]	[]	[]	t	f	t	خرید عرق شاتره هلسا	عرق شاتره، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.805621	2026-09-13 10:59:48.073022
151	دمنوش گل محمدی	rose-herbal-tea	herbal-tea	27	CAT-0117	هلسا ایرانیان	دمنوش گل محمدی، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش گل محمدی از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	175000	\N	\N	0	TOMAN	30	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش گل محمدی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/herbal-tea.jpg	تصویر دمنوش گل محمدی هلسا	brand_asset	["/images/opt/herbal-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش گل محمدی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش گل محمدی"}]	[]	[]	t	f	t	خرید دمنوش گل محمدی هلسا	دمنوش گل محمدی، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.03694	2026-09-13 10:59:48.073022
152	دمنوش بهارنارنج	orange-blossom-tea	herbal-tea	27	CAT-0118	هلسا ایرانیان	دمنوش بهارنارنج، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش بهارنارنج از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	26	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش بهارنارنج	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/herbal-tea.jpg	تصویر دمنوش بهارنارنج هلسا	brand_asset	["/images/opt/herbal-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش بهارنارنج"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش بهارنارنج"}]	[]	[]	t	f	t	خرید دمنوش بهارنارنج هلسا	دمنوش بهارنارنج، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.040772	2026-09-13 10:59:48.073022
153	دمنوش آرامش	calm-herbal-tea	herbal-tea	27	CAT-0119	هلسا ایرانیان	دمنوش آرامش، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش آرامش از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش آرامش	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/herbal-tea.jpg	تصویر دمنوش آرامش هلسا	brand_asset	["/images/opt/herbal-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش آرامش"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش آرامش"}]	[]	[]	t	f	t	خرید دمنوش آرامش هلسا	دمنوش آرامش، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.044854	2026-09-13 10:59:48.073022
154	دمنوش ترکیبی هلسا	helsa-herbal-blend	herbal-tea	27	CAT-0120	هلسا ایرانیان	دمنوش ترکیبی هلسا، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش ترکیبی هلسا از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	220000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش ترکیبی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/herbal-tea.jpg	تصویر دمنوش ترکیبی هلسا هلسا	brand_asset	["/images/opt/herbal-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش ترکیبی هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش ترکیبی هلسا"}]	[]	[]	t	f	t	خرید دمنوش ترکیبی هلسا هلسا	دمنوش ترکیبی هلسا، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.048619	2026-09-13 10:59:48.073022
155	دمنوش میوه‌ای هلسا	helsa-fruit-tea	herbal-tea	27	CAT-0121	هلسا ایرانیان	دمنوش میوه‌ای هلسا، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	دمنوش میوه‌ای هلسا از محصولات منتخب هلسا در دسته دمنوش‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	دمنوش میوه‌ای هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/fruit-tea.jpg	تصویر دمنوش میوه‌ای هلسا هلسا	brand_asset	["/images/opt/fruit-tea.jpg"]	0	0	\N	["دمنوش‌های ویژه هلسا", "دمنوش میوه‌ای هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "دمنوش میوه‌ای هلسا"}]	[]	[]	t	f	t	خرید دمنوش میوه‌ای هلسا هلسا	دمنوش میوه‌ای هلسا، از مجموعه دمنوش‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.052303	2026-09-13 10:59:48.073022
165	غنچه گل محمدی	rosebuds	rosebuds	30	CAT-0131	هلسا ایرانیان	غنچه گل محمدی، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی.	غنچه گل محمدی از محصولات منتخب هلسا در دسته گل محمدی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	28	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	غنچه گل محمدی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rosebuds.jpg	تصویر غنچه گل محمدی هلسا	brand_asset	["/images/opt/rosebuds.jpg"]	0	0	\N	["گل محمدی", "غنچه گل محمدی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "غنچه گل محمدی"}]	[]	[]	t	f	t	خرید غنچه گل محمدی هلسا	غنچه گل محمدی، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.090444	2026-09-13 10:59:48.073022
167	غنچه گل محمدی ویژه هلسا	helsa-rosebuds	rosebuds	30	CAT-0133	هلسا ایرانیان	غنچه گل محمدی ویژه هلسا، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی.	غنچه گل محمدی ویژه هلسا از محصولات منتخب هلسا در دسته گل محمدی است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	\N	\N	0	TOMAN	18	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	غنچه گل محمدی ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/rosebuds.jpg	تصویر غنچه گل محمدی ویژه هلسا هلسا	brand_asset	["/images/opt/rosebuds.jpg"]	0	0	\N	["گل محمدی", "غنچه گل محمدی ویژه هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "غنچه گل محمدی ویژه هلسا"}]	[]	[]	t	f	t	خرید غنچه گل محمدی ویژه هلسا هلسا	غنچه گل محمدی ویژه هلسا، از مجموعه گل محمدی هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.103801	2026-09-13 10:59:48.073022
128	پنیر پذیرایی	hospitality-cheese	cheese	21	CAT-0094	هلسا ایرانیان	پنیر پذیرایی، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی.	پنیر پذیرایی از محصولات منتخب هلسا در دسته پنیر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	285000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پنیر پذیرایی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/cheese.jpg	تصویر پنیر پذیرایی هلسا	brand_asset	["/images/opt/cheese.jpg"]	0	0	\N	["پنیر", "پنیر پذیرایی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پنیر پذیرایی"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۴ گرم"}, {"label": "کربوهیدرات", "value": "۲ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید پنیر پذیرایی هلسا	پنیر پذیرایی، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.946945	2026-09-13 10:59:48.073022
129	پنیر سنتی	traditional-cheese	cheese	21	CAT-0095	هلسا ایرانیان	پنیر سنتی، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی.	پنیر سنتی از محصولات منتخب هلسا در دسته پنیر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	250000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پنیر سنتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/cheese.jpg	تصویر پنیر سنتی هلسا	brand_asset	["/images/opt/cheese.jpg"]	0	0	\N	["پنیر", "پنیر سنتی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پنیر سنتی"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۴ گرم"}, {"label": "کربوهیدرات", "value": "۲ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید پنیر سنتی هلسا	پنیر سنتی، از مجموعه پنیر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.950995	2026-09-13 10:59:48.073022
135	زیتون ویژه هلسا	helsa-olives	olives	22	CAT-0101	هلسا ایرانیان	زیتون ویژه هلسا، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی.	زیتون ویژه هلسا از محصولات منتخب هلسا در دسته زیتون است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	320000	\N	\N	0	TOMAN	14	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	زیتون ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olives-green.jpg	تصویر زیتون ویژه هلسا هلسا	brand_asset	["/images/opt/olives-green.jpg"]	0	0	\N	["زیتون", "زیتون ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زیتون ویژه هلسا"}]	[{"label": "انرژی", "value": "۱۱۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۶ گرم"}, {"label": "چربی", "value": "۱۱ گرم"}, {"label": "فیبر رژیمی", "value": "۳ گرم"}]	[]	t	f	t	خرید زیتون ویژه هلسا هلسا	زیتون ویژه هلسا، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.975128	2026-09-13 10:59:48.073022
132	زیتون سیاه	black-olives	olives	22	CAT-0098	هلسا ایرانیان	زیتون سیاه، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی.	زیتون سیاه از محصولات منتخب هلسا در دسته زیتون است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	زیتون سیاه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olives-black.jpg	تصویر زیتون سیاه هلسا	brand_asset	["/images/opt/olives-black.jpg"]	0	0	\N	["زیتون", "زیتون سیاه"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زیتون سیاه"}]	[{"label": "انرژی", "value": "۱۱۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۶ گرم"}, {"label": "چربی", "value": "۱۱ گرم"}, {"label": "فیبر رژیمی", "value": "۳ گرم"}]	[]	t	f	t	خرید زیتون سیاه هلسا	زیتون سیاه، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.963731	2026-09-13 10:59:48.073022
134	زیتون پرورده	marinated-olives	olives	22	CAT-0100	هلسا ایرانیان	زیتون پرورده، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی.	زیتون پرورده از محصولات منتخب هلسا در دسته زیتون است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	295000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	زیتون پرورده	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/olives-black.jpg	تصویر زیتون پرورده هلسا	brand_asset	["/images/opt/olives-black.jpg"]	0	0	\N	["زیتون", "زیتون پرورده"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "زیتون پرورده"}]	[{"label": "انرژی", "value": "۱۱۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۶ گرم"}, {"label": "چربی", "value": "۱۱ گرم"}, {"label": "فیبر رژیمی", "value": "۳ گرم"}]	[]	t	f	t	خرید زیتون پرورده هلسا	زیتون پرورده، از مجموعه زیتون هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.971426	2026-09-13 10:59:48.073022
136	ترشی مخلوط	mixed-pickles	pickles	23	CAT-0102	هلسا ایرانیان	ترشی مخلوط، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی.	ترشی مخلوط از محصولات منتخب هلسا در دسته ترشیجات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ترشی مخلوط	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pickles.jpg	تصویر ترشی مخلوط هلسا	brand_asset	["/images/opt/pickles.jpg"]	0	0	\N	["ترشیجات", "ترشی مخلوط"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ترشی مخلوط"}]	[{"label": "انرژی", "value": "۳۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۷ گرم"}, {"label": "چربی", "value": "۰.۲ گرم"}, {"label": "فیبر رژیمی", "value": "۲ گرم"}]	[]	t	f	t	خرید ترشی مخلوط هلسا	ترشی مخلوط، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.978942	2026-09-13 10:59:48.073022
139	ترشی ویژه هلسا	helsa-pickles	pickles	23	CAT-0105	هلسا ایرانیان	ترشی ویژه هلسا، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی.	ترشی ویژه هلسا از محصولات منتخب هلسا در دسته ترشیجات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	285000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	ترشی ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pickles.jpg	تصویر ترشی ویژه هلسا هلسا	brand_asset	["/images/opt/pickles.jpg"]	0	0	\N	["ترشیجات", "ترشی ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "ترشی ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۵ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۷ گرم"}, {"label": "چربی", "value": "۰.۲ گرم"}, {"label": "فیبر رژیمی", "value": "۲ گرم"}]	[]	t	f	t	خرید ترشی ویژه هلسا هلسا	ترشی ویژه هلسا، از مجموعه ترشیجات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.990351	2026-09-13 10:59:48.073022
43	تخمه کدو	pumpkin-seeds	seeds	7	CAT-0009	هلسا ایرانیان	تخمه کدو، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه کدو از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	44	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه کدو	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pumpkin-seeds.jpg	تصویر تخمه کدو هلسا	brand_asset	["/images/opt/pumpkin-seeds.jpg"]	0	0	\N	["تخمه", "تخمه کدو"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه کدو"}]	[{"label": "انرژی", "value": "۵۵۹ کیلوکالری"}, {"label": "پروتئین", "value": "۳۰ گرم"}, {"label": "کربوهیدرات", "value": "۱۱ گرم"}, {"label": "چربی", "value": "۴۹ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید تخمه کدو هلسا	تخمه کدو، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.412595	2026-09-13 10:59:48.073022
44	تخمه کدو گوشتی	meaty-pumpkin-seeds	seeds	7	CAT-0010	هلسا ایرانیان	تخمه کدو گوشتی، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه کدو گوشتی از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	285000	\N	\N	0	TOMAN	36	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه کدو گوشتی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/pumpkin-seeds.jpg	تصویر تخمه کدو گوشتی هلسا	brand_asset	["/images/opt/pumpkin-seeds.jpg"]	0	0	\N	["تخمه", "تخمه کدو گوشتی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه کدو گوشتی"}]	[{"label": "انرژی", "value": "۵۵۹ کیلوکالری"}, {"label": "پروتئین", "value": "۳۰ گرم"}, {"label": "کربوهیدرات", "value": "۱۱ گرم"}, {"label": "چربی", "value": "۴۹ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید تخمه کدو گوشتی هلسا	تخمه کدو گوشتی، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.427481	2026-09-13 10:59:48.073022
48	تخمه شور	salted-seeds	seeds	7	CAT-0014	هلسا ایرانیان	تخمه شور، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه شور از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	175000	\N	\N	0	TOMAN	40	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه شور	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sunflower-seeds.jpg	تصویر تخمه شور هلسا	brand_asset	["/images/opt/sunflower-seeds.jpg"]	0	0	\N	["تخمه", "تخمه شور"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه شور"}]	[{"label": "انرژی", "value": "۵۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۶ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۴۸ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید تخمه شور هلسا	تخمه شور، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.487667	2026-09-13 10:59:48.073022
50	تخمه طعم‌دار ویژه هلسا	helsa-flavored-seeds	seeds	7	CAT-0016	هلسا ایرانیان	تخمه طعم‌دار ویژه هلسا، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه طعم‌دار ویژه هلسا از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	225000	\N	\N	0	TOMAN	24	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه طعم‌دار ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sunflower-seeds.jpg	تصویر تخمه طعم‌دار ویژه هلسا هلسا	brand_asset	["/images/opt/sunflower-seeds.jpg"]	0	0	\N	["تخمه", "تخمه طعم‌دار ویژه هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه طعم‌دار ویژه هلسا"}]	[{"label": "انرژی", "value": "۵۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۶ گرم"}, {"label": "کربوهیدرات", "value": "۱۶ گرم"}, {"label": "چربی", "value": "۴۸ گرم"}, {"label": "فیبر رژیمی", "value": "۶ گرم"}]	[]	t	f	t	خرید تخمه طعم‌دار ویژه هلسا هلسا	تخمه طعم‌دار ویژه هلسا، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.509189	2026-09-13 10:59:48.073022
46	تخمه ژاپنی	japanese-seeds	seeds	7	CAT-0012	هلسا ایرانیان	تخمه ژاپنی، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه ژاپنی از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	\N	\N	0	TOMAN	31	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه ژاپنی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/sunflower-seeds.jpg	تصویر تخمه ژاپنی هلسا	brand_asset	["/images/opt/sunflower-seeds.jpg"]	0	0	\N	["تخمه", "تخمه ژاپنی"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه ژاپنی"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۰ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید تخمه ژاپنی هلسا	تخمه ژاپنی، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.464206	2026-09-13 10:59:48.073022
47	تخمه هندوانه	watermelon-seeds	seeds	7	CAT-0013	هلسا ایرانیان	تخمه هندوانه، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی.	تخمه هندوانه از محصولات منتخب هلسا در دسته تخمه است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	195000	\N	\N	0	TOMAN	26	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	تخمه هندوانه	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/watermelon-seeds.jpg	تصویر تخمه هندوانه هلسا	brand_asset	["/images/opt/watermelon-seeds.jpg"]	0	0	\N	["تخمه", "تخمه هندوانه"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "تخمه هندوانه"}]	[{"label": "انرژی", "value": "۵۵۷ کیلوکالری"}, {"label": "پروتئین", "value": "۲۸ گرم"}, {"label": "کربوهیدرات", "value": "۱۵ گرم"}, {"label": "چربی", "value": "۴۷ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید تخمه هندوانه هلسا	تخمه هندوانه، از مجموعه تخمه هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.474185	2026-09-13 10:59:48.073022
57	عسل طبیعی	natural-honey	honey	9	CAT-0023	هلسا ایرانیان	عسل طبیعی، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل طبیعی از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	620000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل طبیعی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-jar.jpg	تصویر عسل طبیعی هلسا	brand_asset	["/images/opt/honey-jar.jpg"]	0	0	\N	["عسل", "عسل طبیعی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عسل طبیعی"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل طبیعی هلسا	عسل طبیعی، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.563634	2026-09-13 10:59:48.073022
58	عسل کنار	sidr-honey	honey	9	CAT-0024	هلسا ایرانیان	عسل کنار، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل کنار از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: جنوب ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	760000	\N	\N	0	TOMAN	15	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل کنار	جنوب ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-jar.jpg	تصویر عسل کنار هلسا	brand_asset	["/images/opt/honey-jar.jpg"]	0	0	\N	["عسل", "عسل کنار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "جنوب ایران"}, {"label": "مواد اولیه", "value": "عسل کنار"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل کنار هلسا	عسل کنار، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.567604	2026-09-13 10:59:48.073022
59	عسل بهارنارنج	orange-blossom-honey	honey	9	CAT-0025	هلسا ایرانیان	عسل بهارنارنج، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل بهارنارنج از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: شمال ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	690000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل بهارنارنج	شمال ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-jar.jpg	تصویر عسل بهارنارنج هلسا	brand_asset	["/images/opt/honey-jar.jpg"]	0	0	\N	["عسل", "عسل بهارنارنج"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "شمال ایران"}, {"label": "مواد اولیه", "value": "عسل بهارنارنج"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل بهارنارنج هلسا	عسل بهارنارنج، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.571718	2026-09-13 10:59:48.073022
62	عسل ویژه هلسا	helsa-signature-honey	honey	9	CAT-0028	هلسا ایرانیان	عسل ویژه هلسا، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل ویژه هلسا از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	820000	\N	\N	0	TOMAN	8	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-jar.jpg	تصویر عسل ویژه هلسا هلسا	brand_asset	["/images/opt/honey-jar.jpg"]	0	0	\N	["عسل", "عسل ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "عسل ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل ویژه هلسا هلسا	عسل ویژه هلسا، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.584308	2026-09-13 10:59:48.073022
119	شیره توت	mulberry-syrup	syrups	19	CAT-0085	هلسا ایرانیان	شیره توت، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی.	شیره توت از محصولات منتخب هلسا در دسته شیره است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شیره توت	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/mulberry-syrup.jpg	تصویر شیره توت هلسا	brand_asset	["/images/opt/mulberry-syrup.jpg"]	0	0	\N	["شیره", "شیره توت"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شیره توت"}]	[{"label": "انرژی", "value": "۳۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید شیره توت هلسا	شیره توت، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.892234	2026-09-13 10:59:48.073022
120	شیره ویژه هلسا	helsa-signature-syrup	syrups	19	CAT-0086	هلسا ایرانیان	شیره ویژه هلسا، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی.	شیره ویژه هلسا از محصولات منتخب هلسا در دسته شیره است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	290000	\N	\N	0	TOMAN	14	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شیره ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-syrup.jpg	تصویر شیره ویژه هلسا هلسا	brand_asset	["/images/opt/date-syrup.jpg"]	0	0	\N	["شیره", "شیره ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شیره ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید شیره ویژه هلسا هلسا	شیره ویژه هلسا، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.896204	2026-09-13 10:59:48.073022
173	شکلات خرمایی کنجدی	sesame-date-chocolate	date-chocolate	32	CAT-0139	هلسا ایرانیان	شکلات خرمایی کنجدی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات خرمایی کنجدی از محصولات منتخب هلسا در دسته شکلات خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	410000	\N	\N	0	TOMAN	17	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات خرمایی کنجدی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-chocolate.jpg	تصویر شکلات خرمایی کنجدی هلسا	brand_asset	["/images/opt/date-chocolate.jpg"]	0	0	\N	["شکلات خرما", "شکلات خرمایی کنجدی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات خرمایی کنجدی"}]	[{"label": "انرژی", "value": "۴۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید شکلات خرمایی کنجدی هلسا	شکلات خرمایی کنجدی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.131538	2026-09-13 10:59:48.073022
174	شکلات خرمایی ویژه هلسا	helsa-signature-date-chocolate	date-chocolate	32	CAT-0140	هلسا ایرانیان	شکلات خرمایی ویژه هلسا، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات خرمایی ویژه هلسا از محصولات منتخب هلسا در دسته شکلات خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	480000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات خرمایی ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-chocolate.jpg	تصویر شکلات خرمایی ویژه هلسا هلسا	brand_asset	["/images/opt/date-chocolate.jpg"]	0	0	\N	["شکلات خرما", "شکلات خرمایی ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات خرمایی ویژه هلسا"}]	[{"label": "انرژی", "value": "۴۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید شکلات خرمایی ویژه هلسا هلسا	شکلات خرمایی ویژه هلسا، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.136239	2026-09-13 10:59:48.073022
140	بیسکویت پذیرایی هلسا	helsa-hospitality-biscuits	biscuits-cakes	24	CAT-0106	هلسا ایرانیان	بیسکویت پذیرایی هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	بیسکویت پذیرایی هلسا از محصولات منتخب هلسا در دسته بیسکویت و کیک ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	260000	\N	\N	0	TOMAN	25	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بیسکویت پذیرایی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/biscuits.jpg	تصویر بیسکویت پذیرایی هلسا هلسا	brand_asset	["/images/opt/biscuits.jpg"]	0	0	\N	["بیسکویت و کیک ویژه هلسا", "بیسکویت پذیرایی هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بیسکویت پذیرایی هلسا"}]	[{"label": "انرژی", "value": "۴۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید بیسکویت پذیرایی هلسا هلسا	بیسکویت پذیرایی هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.994435	2026-09-13 10:59:48.073022
143	بیسکویت خرمایی	date-biscuits	biscuits-cakes	24	CAT-0109	هلسا ایرانیان	بیسکویت خرمایی، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	بیسکویت خرمایی از محصولات منتخب هلسا در دسته بیسکویت و کیک ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	28	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بیسکویت خرمایی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/biscuits.jpg	تصویر بیسکویت خرمایی هلسا	brand_asset	["/images/opt/biscuits.jpg"]	0	0	\N	["بیسکویت و کیک ویژه هلسا", "بیسکویت خرمایی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بیسکویت خرمایی"}]	[{"label": "انرژی", "value": "۴۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید بیسکویت خرمایی هلسا	بیسکویت خرمایی، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.005762	2026-09-13 10:59:48.073022
141	کیک خرمایی هلسا	helsa-date-cake	biscuits-cakes	24	CAT-0107	هلسا ایرانیان	کیک خرمایی هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	کیک خرمایی هلسا از محصولات منتخب هلسا در دسته بیسکویت و کیک ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	320000	\N	\N	0	TOMAN	18	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کیک خرمایی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-cake.jpg	تصویر کیک خرمایی هلسا هلسا	brand_asset	["/images/opt/date-cake.jpg"]	0	0	\N	["بیسکویت و کیک ویژه هلسا", "کیک خرمایی هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کیک خرمایی هلسا"}]	[{"label": "انرژی", "value": "۴۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید کیک خرمایی هلسا هلسا	کیک خرمایی هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.998102	2026-09-13 10:59:48.073022
142	کیک خشک هلسا	helsa-dry-cake	biscuits-cakes	24	CAT-0108	هلسا ایرانیان	کیک خشک هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	کیک خشک هلسا از محصولات منتخب هلسا در دسته بیسکویت و کیک ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	280000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	کیک خشک هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-cake.jpg	تصویر کیک خشک هلسا هلسا	brand_asset	["/images/opt/date-cake.jpg"]	0	0	\N	["بیسکویت و کیک ویژه هلسا", "کیک خشک هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کیک خشک هلسا"}]	[{"label": "انرژی", "value": "۴۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید کیک خشک هلسا هلسا	کیک خشک هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.002015	2026-09-13 10:59:48.073022
144	شیرینی خشک ویژه هلسا	helsa-dry-sweets	biscuits-cakes	24	CAT-0110	هلسا ایرانیان	شیرینی خشک ویژه هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	شیرینی خشک ویژه هلسا از محصولات منتخب هلسا در دسته بیسکویت و کیک ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	360000	\N	\N	0	TOMAN	16	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شیرینی خشک ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/biscuits.jpg	تصویر شیرینی خشک ویژه هلسا هلسا	brand_asset	["/images/opt/biscuits.jpg"]	0	0	\N	["بیسکویت و کیک ویژه هلسا", "شیرینی خشک ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شیرینی خشک ویژه هلسا"}]	[{"label": "انرژی", "value": "۴۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}]	[]	t	f	t	خرید شیرینی خشک ویژه هلسا هلسا	شیرینی خشک ویژه هلسا، از مجموعه بیسکویت و کیک ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.009485	2026-09-13 10:59:48.073022
175	خرما بار	date-bar	date-bars	33	CAT-0141	هلسا ایرانیان	خرما بار، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما بار از محصولات منتخب هلسا در دسته بار خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	30	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	خرما بار	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-bar.jpg	تصویر خرما بار هلسا	brand_asset	["/images/opt/date-bar.jpg"]	0	0	\N	["بار خرما", "خرما بار"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "خرما بار"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۸ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید خرما بار هلسا	خرما بار، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.140026	2026-09-13 10:59:48.073022
176	بار خرما و مغزها	date-nut-bar	date-bars	33	CAT-0142	هلسا ایرانیان	بار خرما و مغزها، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار خرما و مغزها از محصولات منتخب هلسا در دسته بار خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار خرما و مغزها	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-bar.jpg	تصویر بار خرما و مغزها هلسا	brand_asset	["/images/opt/date-bar.jpg"]	0	0	\N	["بار خرما", "بار خرما و مغزها"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار خرما و مغزها"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۸ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید بار خرما و مغزها هلسا	بار خرما و مغزها، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.144106	2026-09-13 10:59:48.073022
177	بار خرما و کنجد	date-sesame-bar	date-bars	33	CAT-0143	هلسا ایرانیان	بار خرما و کنجد، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار خرما و کنجد از محصولات منتخب هلسا در دسته بار خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	\N	\N	0	TOMAN	26	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار خرما و کنجد	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-bar.jpg	تصویر بار خرما و کنجد هلسا	brand_asset	["/images/opt/date-bar.jpg"]	0	0	\N	["بار خرما", "بار خرما و کنجد"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار خرما و کنجد"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۸ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید بار خرما و کنجد هلسا	بار خرما و کنجد، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.148045	2026-09-13 10:59:48.073022
178	بار خرما و شکلات	date-chocolate-bar	date-bars	33	CAT-0144	هلسا ایرانیان	بار خرما و شکلات، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	بار خرما و شکلات از محصولات منتخب هلسا در دسته بار خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	بار خرما و شکلات	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-bar.jpg	تصویر بار خرما و شکلات هلسا	brand_asset	["/images/opt/date-bar.jpg"]	0	0	\N	["بار خرما", "بار خرما و شکلات"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "بار خرما و شکلات"}]	[{"label": "انرژی", "value": "۳۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۸ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید بار خرما و شکلات هلسا	بار خرما و شکلات، از مجموعه بار خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.15202	2026-09-13 10:59:48.073022
169	قند خرما ویژه هلسا	helsa-date-sugar	date-sugar	31	CAT-0135	هلسا ایرانیان	قند خرما ویژه هلسا، از مجموعه قند خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	قند خرما ویژه هلسا از محصولات منتخب هلسا در دسته قند خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	220000	\N	\N	0	TOMAN	20	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	قند خرما ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-sugar.jpg	تصویر قند خرما ویژه هلسا هلسا	brand_asset	["/images/opt/date-sugar.jpg"]	0	0	\N	["قند خرما", "قند خرما ویژه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "قند خرما ویژه هلسا"}]	[{"label": "انرژی", "value": "۳۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید قند خرما ویژه هلسا هلسا	قند خرما ویژه هلسا، از مجموعه قند خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.114225	2026-09-13 10:59:48.073022
105	پک هدیه هلسا	helsa-gift-pack	special-packs	17	CAT-0071	هلسا ایرانیان	پک هدیه هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک هدیه هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1250000	\N	\N	0	TOMAN	10	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک هدیه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک هدیه هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک هدیه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک هدیه هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک هدیه هلسا هلسا	پک هدیه هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.837108	2026-09-13 10:59:48.073022
106	پک پذیرایی هلسا	helsa-hospitality-pack	special-packs	17	CAT-0072	هلسا ایرانیان	پک پذیرایی هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک پذیرایی هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1450000	\N	\N	0	TOMAN	9	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک پذیرایی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک پذیرایی هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک پذیرایی هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک پذیرایی هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک پذیرایی هلسا هلسا	پک پذیرایی هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.841069	2026-09-13 10:59:48.073022
107	پک صبحانه هلسا	helsa-breakfast-pack	special-packs	17	CAT-0073	هلسا ایرانیان	پک صبحانه هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک صبحانه هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	980000	\N	\N	0	TOMAN	12	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک صبحانه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک صبحانه هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک صبحانه هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک صبحانه هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک صبحانه هلسا هلسا	پک صبحانه هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.845011	2026-09-13 10:59:48.073022
108	پک نوروز هلسا	helsa-nowruz-pack	special-packs	17	CAT-0074	هلسا ایرانیان	پک نوروز هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک نوروز هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1580000	\N	\N	0	TOMAN	7	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک نوروز هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک نوروز هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک نوروز هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک نوروز هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک نوروز هلسا هلسا	پک نوروز هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.848813	2026-09-13 10:59:48.073022
109	پک یلدای هلسا	helsa-yalda-pack	special-packs	17	CAT-0075	هلسا ایرانیان	پک یلدای هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک یلدای هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1520000	\N	\N	0	TOMAN	6	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک یلدای هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک یلدای هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک یلدای هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک یلدای هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک یلدای هلسا هلسا	پک یلدای هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.852972	2026-09-13 10:59:48.073022
110	پک سازمانی هلسا	helsa-corporate-pack	special-packs	17	CAT-0076	هلسا ایرانیان	پک سازمانی هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک سازمانی هلسا از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1850000	\N	\N	0	TOMAN	5	low_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک سازمانی هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک سازمانی هلسا هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک سازمانی هلسا"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک سازمانی هلسا"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک سازمانی هلسا هلسا	پک سازمانی هلسا، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.856981	2026-09-13 10:59:48.073022
111	پک ویژه مهمانی	helsa-party-pack	special-packs	17	CAT-0077	هلسا ایرانیان	پک ویژه مهمانی، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی.	پک ویژه مهمانی از محصولات منتخب هلسا در دسته پک‌های ویژه هلسا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	1680000	\N	\N	0	TOMAN	8	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	پک ویژه مهمانی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/gift-pack.jpg	تصویر پک ویژه مهمانی هلسا	brand_asset	["/images/opt/gift-pack.jpg"]	0	0	\N	["پک‌های ویژه هلسا", "پک ویژه مهمانی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پک ویژه مهمانی"}]	[{"label": "انرژی", "value": "۴۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۸ گرم"}, {"label": "کربوهیدرات", "value": "۶۰ گرم"}, {"label": "چربی", "value": "۲۰ گرم"}, {"label": "فیبر رژیمی", "value": "۷ گرم"}]	[]	t	f	t	خرید پک ویژه مهمانی هلسا	پک ویژه مهمانی، از مجموعه پک‌های ویژه هلسا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.860892	2026-09-13 10:59:48.073022
76	آبنبات زعفرانی	saffron-candy	candy	13	CAT-0042	هلسا ایرانیان	آبنبات زعفرانی، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی.	آبنبات زعفرانی از محصولات منتخب هلسا در دسته آبنبات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	145000	\N	\N	0	TOMAN	32	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	آبنبات زعفرانی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/saffron-candy.jpg	آبنبات زعفرانی طلایی با زعفران واقعی	brand_asset	["/images/opt/saffron-candy.jpg"]	0	0	\N	["آبنبات", "آبنبات زعفرانی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آبنبات زعفرانی"}]	[{"label": "انرژی", "value": "۴۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۹۸ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید آبنبات زعفرانی هلسا	آبنبات زعفرانی، از مجموعه آبنبات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.671965	2026-09-15 15:11:59.830868
26	میکس میوه خشک هلسا	dried-fruit-mix	dried-fruits	\N	HLA-0026	هلسا ایرانیان	ترکیب رنگارنگ انجیر، برگه، توت، کشمش و سیب خشک؛ کاسه سلامتی روزانه.	ترکیب رنگارنگ انجیر، برگه، توت، کشمش و سیب خشک؛ کاسه سلامتی روزانه هلسا.	360000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۶۰ گرم	بسته	جعبه مقوایی هلسا با پنجره نمایش و روبان کتان	انجیر خشک، برگه زردآلو، توت خشک، کشمش، سیب خشک	استهبان و ملایر، ایران	یخچال	/images/opt/dried-fruit-mix.jpg	تصویر میکس میوه خشک هلسا	seed_reference	["/images/opt/dried-fruit-mix.jpg"]	4.7	95	محبوب	["میوه خشک"]	[{"label": "وزن", "value": "۶۰ گرم"}, {"label": "مواد اولیه", "value": "میوه خشک"}, {"label": "محل تولید", "value": "ایران"}, {"label": "نوع بسته‌بندی", "value": "جعبه پذیرایی"}, {"label": "شرایط نگهداری", "value": "یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۳ گرم"}, {"label": "کربوهیدرات", "value": "۷۰ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید میکس میوه خشک هلسا هلسا	ترکیب رنگارنگ انجیر، برگه، توت، کشمش و سیب خشک؛ کاسه سلامتی روزانه. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.828
338	پاناکوتا وانیلی هلسا	vanilla-panna-cotta	cakes-desserts	64	CAT-0155	هلسا ایرانیان	پاناکوتا وانیلی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	پاناکوتا وانیلی هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	340000	\N	\N	0	TOMAN	18	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	پاناکوتا وانیلی هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/vanilla-panna-cotta.jpg	تصویر پاناکوتا وانیلی هلسا هلسا	brand_asset	["/images/opt/vanilla-panna-cotta.jpg"]	0	0	\N	["کیک و دسر", "پاناکوتا وانیلی هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "پاناکوتا وانیلی هلسا"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۳٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۲۲ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}]	[]	t	f	t	خرید پاناکوتا وانیلی هلسا هلسا	پاناکوتا وانیلی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.75293	2026-09-16 09:32:11.581
32	دمنوش گل‌گاوزبان و سنبل‌الطیب	herbal-tea-borage	natural	\N	HLA-0032	هلسا ایرانیان	دمنوش آرام‌بخش گل‌گاوزبان، سنبل‌الطیب و لیمو عمانی برای شب‌های آرام.	دمنوش آرام‌بخش گل‌گاوزبان، سنبل‌الطیب و لیمو عمانی؛ ritual شب‌های آرام هلسا.	185000	215000	\N	14	TOMAN	24	in_stock	5	1	\N	۱۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	گل‌گاوزبان، سنبل‌الطیب، لیمو عمانی	ایران	مكان خشک	/images/opt/herbal-tea-borage.jpg	تصویر دمنوش گل‌گاوزبان هلسا	seed_reference	["/images/opt/herbal-tea-borage.jpg"]	4.6	55	تخفیف	["دمنوش"]	[{"label": "وزن", "value": "۱۵۰ گرم"}, {"label": "مواد اولیه", "value": "دمنوش"}, {"label": "محل تولید", "value": "کاشان"}, {"label": "نوع بسته‌بندی", "value": "بسته کرافت پنجره‌دار"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۰٫۵ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید دمنوش گل‌گاوزبان و سنبل‌الطیب هلسا	دمنوش آرام‌بخش گل‌گاوزبان، سنبل‌الطیب و لیمو عمانی برای شب‌های آرام. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.837
41	آجیل شب یلدا	yalda-nuts	nuts-dried-fruits	6	CAT-0007	هلسا ایرانیان	آجیل شب یلدا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل شب یلدا از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	920000	\N	\N	0	TOMAN	9	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل شب یلدا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/nuts-yalda.jpg	آجیل مخصوص شب یلدا با انار	brand_asset	["/images/opt/nuts-yalda.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل شب یلدا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل شب یلدا"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل شب یلدا هلسا	آجیل شب یلدا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.395957	2026-09-15 15:11:59.830868
20	مغز گردوی چهارپره	walnut-kernels	nuts	\N	HLA-0020	هلسا ایرانیان	مغز گردوی سفید چهارپره تویسرکان؛ تازه، بدون تلخی و سرشار از امگا۳.	مغز گردوی سفید چهارپره تویسرکان؛ تازه، بدون تلخی و سرشار از امگا۳.	620000	690000	\N	10	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	مغز گردوی چهارپره	تویسرکان، همدان	یخچال	/images/opt/walnut-kernels.jpg	تصویر مغز گردوی چهارپره هلسا	seed_reference	["/images/opt/walnut-kernels.jpg"]	4.7	103	\N	["گردو"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "گردو"}, {"label": "محل تولید", "value": "تویسرکان"}, {"label": "نوع بسته‌بندی", "value": "بسته وکیوم"}, {"label": "شرایط نگهداری", "value": "یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۵ گرم"}, {"label": "کربوهیدرات", "value": "۱۴ گرم"}, {"label": "چربی", "value": "۶۵ گرم"}]	["مغزها"]	t	f	t	خرید مغز گردوی چهارپره هلسا	مغز گردوی سفید چهارپره تویسرکان؛ تازه، بدون تلخی و سرشار از امگا۳. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.816
42	خشکبار ویژه هلسا	helsa-dried-fruit-selection	nuts-dried-fruits	6	CAT-0008	هلسا ایرانیان	خشکبار ویژه هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	خشکبار ویژه هلسا از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	580000	\N	\N	0	TOMAN	22	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	خشکبار ویژه هلسا	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/dried-fruit-mix.jpg	خشکبار مخلوط ممتاز هلسا	brand_asset	["/images/opt/dried-fruit-mix.jpg"]	0	0	\N	["آجیل و خشکبار", "خشکبار ویژه هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "خشکبار ویژه هلسا"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید خشکبار ویژه هلسا هلسا	خشکبار ویژه هلسا، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.404606	2026-09-15 15:11:59.830868
34	سماق پرک کوهی	sumac-flakes	natural	\N	HLA-0034	هلسا ایرانیان	سماق پرک کوهی بدون هسته و نمک افزوده؛ رنگ سرخ طبیعی و طعم ملس.	سماق پرک کوهی بدون هسته و بدون نمک افزوده؛ رنگ سرخ طبیعی و طعم ملس.	145000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۳۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	سماق پرک کوهی	زاگرس، ایران	مكان خشک	/images/opt/sumac-flakes.jpg	تصویر سماق پرک کوهی هلسا	seed_reference	["/images/opt/sumac-flakes.jpg"]	4.4	33	\N	["ادویه"]	[{"label": "وزن", "value": "۳۰ گرم"}, {"label": "مواد اولیه", "value": "ادویه"}, {"label": "محل تولید", "value": "کردستان"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۳۰ کیلوکالری"}, {"label": "پروتئین", "value": "۵ گرم"}, {"label": "کربوهیدرات", "value": "۵۰ گرم"}, {"label": "چربی", "value": "۵ گرم"}]	[]	t	f	t	خرید سماق پرک کوهی هلسا	سماق پرک کوهی بدون هسته و نمک افزوده؛ رنگ سرخ طبیعی و طعم ملس. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.838
18	پسته اکبری درشت	akbari-pistachios	nuts	\N	HLA-0018	هلسا ایرانیان	پسته اکبری سوپر درشت رفسنجان، خندان با شور ملایم؛ لوکس‌ترین مغز ایران.	پسته اکبری سوپر درشت رفسنجان، خندان و شورِ ملایم؛ لوکس‌ترین مغز ایران.	1180000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۵۰۰ گرم	بسته	جعبه مقوایی هلسا با پنجره نمایش و روبان کتان	پسته اکبری (درصد مغز بالا)	رفسنجان، کرمان	مكان خنک	/images/opt/akbari-pistachios.jpg	تصویر پسته اکبری درشت هلسا	seed_reference	["/images/opt/akbari-pistachios.jpg"]	4.9	176	محبوب	["پسته"]	[{"label": "وزن", "value": "۵۰۰ گرم"}, {"label": "مواد اولیه", "value": "پسته"}, {"label": "محل تولید", "value": "رفسنجان"}, {"label": "نوع بسته‌بندی", "value": "بسته متالایز"}, {"label": "شرایط نگهداری", "value": "مكان خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۵۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۰ گرم"}, {"label": "کربوهیدرات", "value": "۲۸ گرم"}, {"label": "چربی", "value": "۴۵ گرم"}]	["مغزها"]	t	f	t	خرید پسته اکبری درشت هلسا	پسته اکبری سوپر درشت رفسنجان، خندان با شور ملایم؛ لوکس‌ترین مغز ایران. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.812
113	نقل زعفرانی	saffron-noghl	noghl	18	CAT-0079	هلسا ایرانیان	نقل زعفرانی، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی.	نقل زعفرانی از محصولات منتخب هلسا در دسته نقل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	210000	\N	\N	0	TOMAN	24	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	نقل زعفرانی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/saffron-noghl.jpg	نقل زعفرانی — بادام با پوشش شکر و زعفران	brand_asset	["/images/opt/saffron-noghl.jpg"]	0	0	\N	["نقل", "نقل زعفرانی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "نقل زعفرانی"}]	[{"label": "انرژی", "value": "۳۹۵ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۹۵ گرم"}, {"label": "چربی", "value": "۱ گرم"}]	[]	t	f	t	خرید نقل زعفرانی هلسا	نقل زعفرانی، از مجموعه نقل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.86892	2026-09-15 15:11:59.830868
14	آجیل چهارمغز	four-nut-mix	nuts	\N	HLA-0014	هلسا ایرانیان	چهارمغز خالص پسته، بادام، فندق و گردو؛ بدون هیچ افزودنی.	چهارمغز خالص: پسته، بادام، فندق و گردو بدون هیچ افزودنی؛ بمب امگا۳ برای صبحانه و دسر.	760000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۱ کیلوگرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	پسته، بادام درختی، فندق، مغز گردو	رفسنجان، کرمان	یخچال برای ماندگاری بیشتر	/images/opt/four-nut-mix.jpg	تصویر آجیل چهارمغز هلسا	seed_reference	["/images/opt/four-nut-mix.jpg"]	4.8	118	\N	["چهارمغز"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "چهارمغز"}, {"label": "محل تولید", "value": "ایران"}, {"label": "نوع بسته‌بندی", "value": "بسته وکیوم"}, {"label": "شرایط نگهداری", "value": "یخچال برای ماندگاری بیشتر"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۸ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}]	["مغزها"]	t	f	t	خرید آجیل چهارمغز هلسا	چهارمغز خالص پسته، بادام، فندق و گردو؛ بدون هیچ افزودنی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.803
17	آجیل ویژه یلدایی هلسا	special-yalda-nuts	nuts	\N	HLA-0017	هلسا ایرانیان	نسخه محدود یلدایی: پسته اکبری، فندق کامل و بادام هندی با جعبه چوبی هلسا.	نسخه محدود یلدایی: پسته اکبری، فندق کامل، بادام هندی طلایی و مغز پسته با جعبه چوبی هلسا.	1250000	1450000	\N	14	TOMAN	8	in_stock	5	1	\N	۱.۵ کیلوگرم	بسته	جعبه چوبی هلسا با قفل مغناطیسی	پسته اکبری، فندق کامل، بادام هندی طلایی، مغز پسته	رفسنجان، کرمان	مكان خنک	/images/opt/special-yalda-nuts.jpg	تصویر آجیل ویژه یلدایی هلسا	seed_reference	["/images/opt/special-yalda-nuts.jpg"]	5	89	محدود	["یلدا", "آجیل ویژه"]	[{"label": "وزن", "value": "۱.۵ کیلوگرم"}, {"label": "مواد اولیه", "value": "یلدا"}, {"label": "محل تولید", "value": "کرمان"}, {"label": "نوع بسته‌بندی", "value": "جعبه چوبی با مدالیون طلاکوب"}, {"label": "شرایط نگهداری", "value": "مكان خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۸ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}]	["مغزها"]	t	f	t	خرید آجیل ویژه یلدایی هلسا هلسا	نسخه محدود یلدایی: پسته اکبری، فندق کامل و بادام هندی با جعبه چوبی هلسا. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-10-01 00:00:00	2026-09-15 15:11:22.81
22	انجیر خشک استهبان	dried-figs	dried-fruits	\N	HLA-0022	هلسا ایرانیان	انجیر خشک درجه یک استهبان؛ دهان‌باز، سفید و یکدست با سایز ۱۰۱.	انجیر خشک درجه یک استهبان فارس؛ دهان‌باز، سفید و یکدست با سایز ۱۰۱. نگین سفره‌های افطار.	430000	495000	\N	13	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	جعبه مقوایی هلسا با پنجره نمایش و روبان کتان	انجیر خشک طبیعی	استهبان، فارس	یخچال	/images/opt/dried-figs.jpg	تصویر انجیر خشک استهبان هلسا	seed_reference	["/images/opt/dried-figs.jpg", "/images/opt/dried-fruit-mix.jpg"]	4.8	141	پرفروش	["انجیر خشک"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "انجیر خشک"}, {"label": "محل تولید", "value": "استهبان، فارس"}, {"label": "نوع بسته‌بندی", "value": "جعبه مقوایی لوکس"}, {"label": "شرایط نگهداری", "value": "یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۳٫۳ گرم"}, {"label": "کربوهیدرات", "value": "۶۴ گرم"}, {"label": "چربی", "value": "۰٫۹ گرم"}]	[]	t	f	t	خرید انجیر خشک استهبان هلسا	انجیر خشک درجه یک استهبان؛ دهان‌باز، سفید و یکدست با سایز ۱۰۱. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.82
25	آلو خشک دودی	dried-plums	dried-fruits	\N	HLA-0025	هلسا ایرانیان	آلو خشک دودی با طعم ملس و عطر ملایم دود؛ میان‌وعده‌ای متفاوت.	آلو خشک دودی با طعم ملس و عطر ملایم دود؛ میان‌وعده‌ای متفاوت برای سلیقه‌های خاص.	210000	240000	\N	13	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	آلو خشک دودی	ایران	دمای محیط	/images/opt/dried-plums.jpg	تصویر آلو خشک دودی هلسا	seed_reference	["/images/opt/dried-plums.jpg"]	4.4	37	جدید	["آلو خشک"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "آلو خشک"}, {"label": "محل تولید", "value": "چهارمحال"}, {"label": "نوع بسته‌بندی", "value": "بسته وکیوم"}, {"label": "شرایط نگهداری", "value": "دمای محیط"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۴۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۲ گرم"}, {"label": "کربوهیدرات", "value": "۶۴ گرم"}, {"label": "چربی", "value": "۰٫۴ گرم"}]	[]	t	f	t	خرید آلو خشک دودی هلسا	آلو خشک دودی با طعم ملس و عطر ملایم دود؛ میان‌وعده‌ای متفاوت. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.826
8	شکلات خرما با مغز گردو	date-chocolate-walnut	date-products	\N	HLA-0008	هلسا ایرانیان	لایه‌های خرما، گردوی تازه و شکلات شیری؛ همراه ایده‌آل چای عصرانه.	لایه‌های خرما، گردوی تازه و شکلات شیری؛ ترکیبی که با چای عصرانه ایرانی کامل می‌شود.	420000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۳۵۰ گرم	بسته	جعبه هدیه هلسا با کاغذ شیتی و کارت ارجاع	خرما مضافتی، مغز گردوی تازه، شکلات شیری پرکاکائو	بم، کرمان	دمای خنک	/images/opt/date-chocolate-walnut.jpg	تصویر شکلات خرما با مغز گردوی هلسا	seed_reference	["/images/opt/date-chocolate-walnut.jpg"]	4.8	64	جدید	["شکلات خرما", "گردو"]	[{"label": "وزن", "value": "۳۵۰ گرم"}, {"label": "مواد اولیه", "value": "شکلات خرما"}, {"label": "محل تولید", "value": "کارگاه هلسا"}, {"label": "نوع بسته‌بندی", "value": "جعبه هدیه"}, {"label": "شرایط نگهداری", "value": "دمای خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۴۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۷ گرم"}, {"label": "کربوهیدرات", "value": "۵۲ گرم"}, {"label": "چربی", "value": "۲۸ گرم"}]	["مغزها", "لبنیات"]	t	f	t	خرید شکلات خرما با مغز گردو هلسا	لایه‌های خرما، گردوی تازه و شکلات شیری؛ همراه ایده‌آل چای عصرانه. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-09-01 00:00:00	2026-09-15 15:11:22.794
11	پودر خرما طبیعی	date-powder	date-products	\N	HLA-0011	هلسا ایرانیان	پودر خرما برای اسموتی، اوورنایت و پخت؛ شیرینی طبیعی با فیبر بالا.	پودر خرما برای اسموتی، اوورنایت و پخت؛ شیرینی طبیعی با فیبر بالا بدون افزودنی.	165000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۴۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	پودر خرما ۱۰۰٪ طبیعی بدون افزودنی	بم، کرمان	مكان خشک	/images/opt/date-powder.jpg	تصویر پودر خرمای طبیعی هلسا	seed_reference	["/images/opt/date-powder.jpg"]	4.5	43	\N	["پودر خرما"]	[{"label": "وزن", "value": "۴۰ گرم"}, {"label": "مواد اولیه", "value": "پودر خرما"}, {"label": "محل تولید", "value": "خرما زاهدی"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۱۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲ گرم"}, {"label": "کربوهیدرات", "value": "۷۸ گرم"}, {"label": "چربی", "value": "۰٫۳ گرم"}]	[]	t	f	t	خرید پودر خرما طبیعی هلسا	پودر خرما برای اسموتی، اوورنایت و پخت؛ شیرینی طبیعی با فیبر بالا. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.796
16	آجیل اقتصادی روزانه	economic-nuts	nuts	\N	HLA-0016	هلسا ایرانیان	ترکیب متعادل و مقرون‌به‌صرفه نخودچی، کشمش، بادام و فندق برای مصرف روزانه.	ترکیبی متعادل و مقرون‌به‌صرفه از نخودچی، کشمش، بادام و فندق برای مصرف روزانه خانواده.	520000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۱ کیلوگرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	نخودچی بوداده، کشمش، بادام درختی، فندق	ایران	دمای محیط	/images/opt/economic-nuts.jpg	تصویر آجیل اقتصادی روزانه هلسا	seed_reference	["/images/opt/economic-nuts.jpg"]	4.4	66	تخفیف	["آجیل اقتصادی"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "آجیل اقتصادی"}, {"label": "محل تولید", "value": "ایران"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ"}, {"label": "شرایط نگهداری", "value": "دمای محیط"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۸ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}]	["مغزها"]	t	f	t	خرید آجیل اقتصادی روزانه هلسا	ترکیب متعادل و مقرون‌به‌صرفه نخودچی، کشمش، بادام و فندق برای مصرف روزانه. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.807
23	توت خشک طبیعت	dried-mulberries	dried-fruits	\N	HLA-0023	هلسا ایرانیان	توت خشک سفید مراغه؛ شیرینی طبیعی بدون سولفیت.	توت خشک سفید مراغه؛ شیرینی طبیعی بدون سولفیت، مناسب چای و میان‌وعده کودکان.	240000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۴۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	توت خشک سفید طبیعی	مراغه، آذربایجان شرقی	مكان خشک	/images/opt/dried-mulberries.jpg	تصویر توت خشک هلسا	seed_reference	["/images/opt/dried-mulberries.jpg"]	4.5	58	\N	["توت خشک"]	[{"label": "وزن", "value": "۴۰ گرم"}, {"label": "مواد اولیه", "value": "توت خشک"}, {"label": "محل تولید", "value": "مراغه"}, {"label": "نوع بسته‌بندی", "value": "بسته کرافت"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۷۲ گرم"}, {"label": "چربی", "value": "۱٫۵ گرم"}]	[]	t	f	t	خرید توت خشک طبیعت هلسا	توت خشک سفید مراغه؛ شیرینی طبیعی بدون سولفیت. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.822
15	آجیل پذیرایی مجلسی	party-nuts	nuts	\N	HLA-0015	هلسا ایرانیان	آجیل پذیرایی مجلسی با پسته اکبری خندان و بادام هندی درشت.	آجیل پذیرایی با پسته اکبری خندان، بادام هندی درشت و مغز گردوی سفید؛ انتخاب مجلس‌های رسمی و عیدانه.	980000	1150000	\N	15	TOMAN	24	in_stock	5	1	\N	۱ کیلوگرم	بسته	جعبه مقوایی هلسا با پنجره نمایش و روبان کتان	پسته اکبری، بادام هندی، مغز گردوی سفید، فندق	رفسنجان، کرمان	مكان خنک	/images/opt/party-nuts.jpg	تصویر آجیل پذیرایی مجلسی هلسا	seed_reference	["/images/opt/party-nuts.jpg"]	4.9	154	ویژه	["آجیل پذیرایی"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "آجیل پذیرایی"}, {"label": "محل تولید", "value": "کرمان"}, {"label": "نوع بسته‌بندی", "value": "جعبه لوکس پذیرایی"}, {"label": "شرایط نگهداری", "value": "مكان خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۸ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}]	["مغزها"]	t	f	t	خرید آجیل پذیرایی مجلسی هلسا	آجیل پذیرایی مجلسی با پسته اکبری خندان و بادام هندی درشت. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.805
36	آجیل چهارمغز	four-kernel-nuts	nuts-dried-fruits	6	CAT-0002	هلسا ایرانیان	آجیل چهارمغز، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی.	آجیل چهارمغز از محصولات منتخب هلسا در دسته آجیل و خشکبار است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	820000	\N	\N	0	TOMAN	20	in_stock	5	1	20	250 گرم	بسته	بسته‌بندی بهداشتی هلسا	آجیل چهارمغز	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/nuts-four-mix.jpg	آجیل چهارمغز ممتاز — پسته، بادام، بادام هندی و فندق	brand_asset	["/images/opt/nuts-four-mix.jpg"]	0	0	\N	["آجیل و خشکبار", "آجیل چهارمغز"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "آجیل چهارمغز"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۱۸ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}, {"label": "فیبر رژیمی", "value": "۸ گرم"}]	[]	t	f	t	خرید آجیل چهارمغز هلسا	آجیل چهارمغز، از مجموعه آجیل و خشکبار هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.307791	2026-09-15 15:11:59.830868
61	عسل کوهستان	mountain-honey	honey	9	CAT-0027	هلسا ایرانیان	عسل کوهستان، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی.	عسل کوهستان از محصولات منتخب هلسا در دسته عسل است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: کوهستان‌های ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	740000	\N	\N	0	TOMAN	11	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	عسل کوهستان	کوهستان‌های ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/honey-mountain.jpg	عسل کوهستان طبیعی با عسل‌کردو	brand_asset	["/images/opt/honey-mountain.jpg"]	0	0	\N	["عسل", "عسل کوهستان"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "کوهستان‌های ایران"}, {"label": "مواد اولیه", "value": "عسل کوهستان"}]	[{"label": "انرژی", "value": "۳۰۴ کیلوکالری"}, {"label": "پروتئین", "value": "۰.۳ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل کوهستان هلسا	عسل کوهستان، از مجموعه عسل هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:58.580273	2026-09-15 15:11:59.830868
31	چای سیاه لاهیجان	lahijan-black-tea	natural	\N	HLA-0031	هلسا ایرانیان	چای سیاه قلم بهاره لاهیجان با عطر هل طبیعی؛ دم‌کشیده و خوش‌رنگ.	چای سیاه قلم بهاره لاهیجان با عطر هل طبیعی؛ دم‌کشیده و خوش‌رنگ، بدون اسانس.	320000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۵۰۰ گرم	بسته	قوطی فلزی درب‌دار هلسا با پلمب تازگی	چای سیاه قلم بهاره	لاهیجان، گیلان	مكان خشک	/images/opt/lahijan-black-tea.jpg	تصویر چای سیاه لاهیجان هلسا	seed_reference	["/images/opt/lahijan-black-tea.jpg"]	4.8	149	محبوب	["چای"]	[{"label": "وزن", "value": "۵۰۰ گرم"}, {"label": "مواد اولیه", "value": "چای"}, {"label": "محل تولید", "value": "لاهیجان"}, {"label": "نوع بسته‌بندی", "value": "بسته متالایز"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۰٫۵ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید چای سیاه لاهیجان هلسا	چای سیاه قلم بهاره لاهیجان با عطر هل طبیعی؛ دم‌کشیده و خوش‌رنگ. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.834
170	شکلات خرمایی	date-chocolate	date-chocolate	32	CAT-0136	هلسا ایرانیان	شکلات خرمایی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	شکلات خرمایی از محصولات منتخب هلسا در دسته شکلات خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	395000	\N	\N	0	TOMAN	22	in_stock	5	1	20	یک بسته	بسته	بسته‌بندی بهداشتی هلسا	شکلات خرمایی	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-chocolate.jpg	تصویر شکلات خرمایی هلسا	brand_asset	["/images/opt/date-chocolate.jpg"]	0	0	\N	["شکلات خرما", "شکلات خرمایی"]	[{"label": "وزن", "value": "یک بسته"}, {"label": "نوع بسته‌بندی", "value": "بسته‌بندی بهداشتی هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "شکلات خرمایی"}]	[{"label": "انرژی", "value": "۴۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۱۶ گرم"}, {"label": "فیبر رژیمی", "value": "۵ گرم"}]	[]	t	f	t	خرید شکلات خرمایی هلسا	شکلات خرمایی، از مجموعه شکلات خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-11 22:07:59.119047	2026-09-15 15:19:12.192
3	خرما کبکاب	kabkab-dates	dates	1	HLA-0003	هلسا ایرانیان	خرما کبکاب، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما کبکاب از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: بوشهر. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	265000	\N	\N	0	TOMAN	35	in_stock	5	1	\N	۱ کیلوگرم	بسته	بسته‌بندی بهداشتی هلسا	خرما کبکاب	بوشهر	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/dates-kabkab.jpg	تصویر خرما کبکاب هلسا	seed_reference	["/images/opt/dates-kabkab.jpg"]	4.6	92	\N	["خرما کبکاب"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "خرما کبکاب"}, {"label": "محل تولید", "value": "بوشهر، برازجان"}, {"label": "نوع بسته‌بندی", "value": "کارتن بهداشتی وکیوم"}, {"label": "شرایط نگهداری", "value": "مكان خنک و خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما کبکاب هلسا	خرما کبکاب، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
5	خرما خاصویی	khasoei-dates	dates	1	HLA-0005	هلسا ایرانیان	خرما خاصویی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما خاصویی از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: فارس. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	240000	\N	\N	0	TOMAN	28	in_stock	5	1	\N	۱ کیلوگرم	بسته	بسته‌بندی بهداشتی هلسا	خرما خاصویی	فارس	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/dates-khasoei.jpg	تصویر خرما خاصویی هلسا	seed_reference	["/images/opt/dates-khasoei.jpg"]	4.4	51	\N	["خرما خاصویی"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "خرما خاصویی"}, {"label": "محل تولید", "value": "فارس، جهرم"}, {"label": "نوع بسته‌بندی", "value": "بسته وکیوم"}, {"label": "شرایط نگهداری", "value": "دمای خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما خاصویی هلسا	خرما خاصویی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
2	خرما مضافتی	mazafati-dates	dates	1	HLA-0002	هلسا ایرانیان	خرما مضافتی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما مضافتی از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: بم، کرمان. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	320000	380000	\N	16	TOMAN	42	in_stock	5	1	\N	۱ کیلوگرم	بسته	بسته‌بندی بهداشتی هلسا	خرما مضافتی	بم، کرمان	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/mazafati-premium.jpg	خرمای مضافتی ممتاز بم — تیره، لطیف و مرطوب	seed_reference	["/images/opt/mazafati-premium.jpg"]	4.8	186	محبوب	["خرما مضافتی"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "خرما مضافتی"}, {"label": "محل تولید", "value": "کرمان، بم"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ تازه‌ماندگار"}, {"label": "شرایط نگهداری", "value": "یخچال (۰ تا ۵ درجه)"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما مضافتی هلسا	خرما مضافتی، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-05-02 00:00:00	2026-09-15 15:11:59.830868
6	خرما مجول	medjool-dates	dates	1	HLA-0006	هلسا ایرانیان	خرما مجول، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما مجول از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	780000	890000	\N	12	TOMAN	14	in_stock	5	1	\N	۷۰۰ گرم	بسته	بسته‌بندی بهداشتی هلسا	خرما مجول	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/medjool-dates.jpg	تصویر خرما مجول هلسا	seed_reference	["/images/opt/medjool-dates.jpg", "/images/opt/medjool-dates-2.jpg", "/images/opt/medjool-dates-3.jpg"]	5	143	ویژه	["خرما مجول", "هدیه"]	[{"label": "وزن", "value": "۷۰۰ گرم"}, {"label": "مواد اولیه", "value": "خرما مجول"}, {"label": "محل تولید", "value": "وارداتی درجه یک / کشت ایران"}, {"label": "نوع بسته‌بندی", "value": "جعبه هدیه مخمل با مدالیون هلسا"}, {"label": "شرایط نگهداری", "value": "یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما مجول هلسا	خرما مجول، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-08-15 00:00:00	2026-09-15 15:11:59.830868
12	خرما شکلات‌پوش پسته‌ای	chocolate-coated-dates	date-products	\N	HLA-0012	هلسا ایرانیان	خرمای مضافتی بدون هسته با روکش شکلات بلژیکی و خرده پسته اکبری.	خرمای مضافتی بدون هسته با روکش شکلات بلژیکی و خرده پسته اکبری؛ هدیه‌ای که همیشه به یاد می‌ماند.	445000	520000	\N	14	TOMAN	24	in_stock	5	1	\N	۴۰۰ گرم	بسته	جعبه هدیه هلسا با کاغذ شیتی و کارت ارجاع	خرما مضافتی بدون هسته، شکلات بلژیکی، خرده پسته اکبری	بم، کرمان	دمای ۱۸ تا ۲۲	/images/opt/chocolate-coated-dates.jpg	تصویر خرمای شکلات‌پوش پسته‌ای هلسا	seed_reference	["/images/opt/chocolate-coated-dates.jpg"]	4.8	97	تخفیف	["شکلات خرما", "هدیه"]	[{"label": "وزن", "value": "۴۰۰ گرم"}, {"label": "مواد اولیه", "value": "شکلات خرما"}, {"label": "محل تولید", "value": "کارگاه هلسا"}, {"label": "نوع بسته‌بندی", "value": "جعبه هدیه طلایی"}, {"label": "شرایط نگهداری", "value": "دمای ۱۸ تا ۲۲"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۴۷۰ کیلوکالری"}, {"label": "پروتئین", "value": "۵ گرم"}, {"label": "کربوهیدرات", "value": "۵۸ گرم"}, {"label": "چربی", "value": "۲۴ گرم"}]	["مغزها", "لبنیات"]	t	f	t	خرید خرما شکلات‌پوش پسته‌ای هلسا	خرمای مضافتی بدون هسته با روکش شکلات بلژیکی و خرده پسته اکبری. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.799
10	شیره خرما	date-syrup	syrups	19	HLA-0010	هلسا ایرانیان	شیره خرما، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی.	شیره خرما از محصولات منتخب هلسا در دسته شیره است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	230000	265000	\N	13	TOMAN	26	in_stock	5	1	\N	۷۰ گرم	بسته	بسته‌بندی بهداشتی هلسا	شیره خرما	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-syrup.jpg	تصویر شیره خرما هلسا	seed_reference	["/images/opt/date-syrup.jpg"]	4.6	88	\N	["شیره خرما"]	[{"label": "وزن", "value": "۷۰ گرم"}, {"label": "مواد اولیه", "value": "شیره خرما"}, {"label": "محل تولید", "value": "بوشهر"}, {"label": "نوع بسته‌بندی", "value": "شیشه دهان‌گشاد درب فلزی"}, {"label": "شرایط نگهداری", "value": "پس از باز شدن در یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۴ گرم"}, {"label": "چربی", "value": "۰٫۲ گرم"}]	[]	t	f	t	خرید شیره خرما هلسا	شیره خرما، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
24	برگه زردآلو ملایم	dried-apricots	dried-fruits	\N	HLA-0024	هلسا ایرانیان	برگه زردآلو خشک‌شده آفتابی بدون مواد نگهدارنده؛ بافت گوشتی.	برگه زردآلو خشک‌شده آفتابی بدون مواد نگهدارنده؛ رنگ کهربایی طبیعی و بافت گوشتی.	285000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	برگه زردآلو	ایران	یخچال	/images/opt/dried-apricots.jpg	تصویر برگه زردآلو هلسا	seed_reference	["/images/opt/dried-apricots.jpg"]	4.6	69	\N	["برگه زردآلو"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "برگه زردآلو"}, {"label": "محل تولید", "value": "ملارد"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ"}, {"label": "شرایط نگهداری", "value": "یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۴۰ کیلوکالری"}, {"label": "پروتئین", "value": "۳٫۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۳ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید برگه زردآلو ملایم هلسا	برگه زردآلو خشک‌شده آفتابی بدون مواد نگهدارنده؛ بافت گوشتی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.824
21	کشمش سبز طلایی	golden-raisins	dried-fruits	\N	HLA-0021	هلسا ایرانیان	کشمش سبز بیدانه ملایر با رنگ طلایی طبیعی؛ خشک‌شده در سایه.	کشمش سبز بیدانه ملایر با رنگ طلایی طبیعی و شیرینی متعادل؛ خشک‌شده در سایه.	195000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	کشمش سبز بیدانه	ملایر، همدان	دمای خنک	/images/opt/golden-raisins.jpg	تصویر کشمش سبز طلایی هلسا	seed_reference	["/images/opt/golden-raisins.jpg"]	4.6	84	\N	["کشمش"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "کشمش"}, {"label": "محل تولید", "value": "ملایر"}, {"label": "نوع بسته‌بندی", "value": "بسته زیپ‌کیپ"}, {"label": "شرایط نگهداری", "value": "دمای خنک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۳ گرم"}, {"label": "کربوهیدرات", "value": "۷۹ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید کشمش سبز طلایی هلسا	کشمش سبز بیدانه ملایر با رنگ طلایی طبیعی؛ خشک‌شده در سایه. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.818
27	عسل طبیعی گون	natural-gon-honey	natural	\N	HLA-0027	هلسا ایرانیان	عسل طبیعی گون زاگرس با آنالیز آزمایشگاهی؛ عطر کوهستان و بافت کریستالی نرم.	عسل طبیعی گون زاگرس با آنالیز آزمایشگاهی؛ عطر کوهستان و بافت کریستالی نرم. برداشت امسال، بدون حرارت.	680000	760000	\N	11	TOMAN	24	in_stock	5	1	\N	۹۰۰ گرم	بسته	شیشه موم‌دار هلسا با درب چوبی و قاشق یکبار‌مصرف	عسل طبیعی گون ۱۰۰٪ خالص	زاگرس، چهارمحال و بختیاری	دمای محیط، دور از نور	/images/opt/natural-gon-honey.jpg	تصویر عسل طبیعی گون هلسا	seed_reference	["/images/opt/natural-gon-honey.jpg", "/images/opt/natural-gon-honey-2.jpg"]	4.9	187	پرفروش	["عسل"]	[{"label": "وزن", "value": "۹۰۰ گرم"}, {"label": "مواد اولیه", "value": "عسل"}, {"label": "محل تولید", "value": "زاگرس"}, {"label": "نوع بسته‌بندی", "value": "شیشه دهان‌گشاد"}, {"label": "شرایط نگهداری", "value": "دمای محیط، دور از نور"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۸۲ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عسل طبیعی گون هلسا	عسل طبیعی گون زاگرس با آنالیز آزمایشگاهی؛ عطر کوهستان و بافت کریستالی نرم. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.83
28	زعفران سرگل نگین	saffron-negin	natural	\N	HLA-0028	هلسا ایرانیان	زعفران سرگل نگین قائنات با قدرت رنگ‌دهی ۲۹۰ و هولوگرام اصالت.	زعفران سرگل نگین قائنات با قدرت رنگ‌دهی ۲۹۰؛ بسته‌بندی فلزی لوکس با هولوگرام اصالت هلسا.	1450000	1680000	\N	14	TOMAN	15	in_stock	5	1	\N	۴.۶ گرم (مثقالی)	بسته	قوطی فلزی درب‌دار هلسا با پلمب تازگی	زعفران سرگل نگین (تمام‌رشته)	قائنات، خراسان جنوبی	مكان تاریک و خشک	/images/opt/saffron-threads.jpg	زعفران سرگل نگین ایرانی — رشته‌های قرمز خالص	seed_reference	["/images/opt/saffron-threads.jpg"]	5	132	ویژه	["زعفران"]	[{"label": "وزن", "value": "۴.۶ گرم (مثقالی)"}, {"label": "مواد اولیه", "value": "زعفران"}, {"label": "محل تولید", "value": "قائنات"}, {"label": "نوع بسته‌بندی", "value": "قوطی فلزی طلاکوب"}, {"label": "شرایط نگهداری", "value": "مكان تاریک و خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۱۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۱ گرم"}, {"label": "کربوهیدرات", "value": "۶۵ گرم"}, {"label": "چربی", "value": "۶ گرم"}]	[]	t	f	t	خرید زعفران سرگل نگین هلسا	زعفران سرگل نگین قائنات با قدرت رنگ‌دهی ۲۹۰ و هولوگرام اصالت. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:59.830868
19	بادام درختی سنگی	tree-almonds	nuts	\N	HLA-0019	هلسا ایرانیان	بادام درختی سنگی سبزستان با مغز پر و طعم شیرین طبیعی؛ خام.	بادام درختی سنگی سبزستان با مغز پر و طعم شیرین طبیعی؛ خام و بدون بو دادگی.	465000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۵۰ گرم	بسته	پاچ بهداشتی با زیپ قفل‌شونده و درب ایستاده هلسا	بادام درختی سنگی خام	سبزستان، خراسان شمالی	مكان خشک	/images/opt/tree-almonds.jpg	تصویر بادام درختی سنگی هلسا	seed_reference	["/images/opt/tree-almonds.jpg"]	4.6	71	\N	["بادام"]	[{"label": "وزن", "value": "۵۰ گرم"}, {"label": "مواد اولیه", "value": "بادام"}, {"label": "محل تولید", "value": "سبزوار"}, {"label": "نوع بسته‌بندی", "value": "بسته کرافت"}, {"label": "شرایط نگهداری", "value": "مكان خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۵۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲۱ گرم"}, {"label": "کربوهیدرات", "value": "۲۲ گرم"}, {"label": "چربی", "value": "۵۰ گرم"}]	["مغزها"]	t	f	t	خرید بادام درختی سنگی هلسا	بادام درختی سنگی سبزستان با مغز پر و طعم شیرین طبیعی؛ خام. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-15 15:11:22.814
30	شیره انگور	grape-syrup	syrups	19	HLA-0030	هلسا ایرانیان	شیره انگور، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی.	شیره انگور از محصولات منتخب هلسا در دسته شیره است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	245000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۷۰ گرم	بسته	بسته‌بندی بهداشتی هلسا	شیره انگور	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/grape-syrup.jpg	تصویر شیره انگور هلسا	seed_reference	["/images/opt/grape-syrup.jpg"]	4.6	61	\N	["شیره"]	[{"label": "وزن", "value": "۷۰ گرم"}, {"label": "مواد اولیه", "value": "شیره"}, {"label": "محل تولید", "value": "ملایر"}, {"label": "نوع بسته‌بندی", "value": "شیشه"}, {"label": "شرایط نگهداری", "value": "دمای محیط"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۲ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}]	[]	t	f	t	خرید شیره انگور هلسا	شیره انگور، از مجموعه شیره هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
29	ارده کنجد	sesame-tahini	tahini	25	HLA-0029	هلسا ایرانیان	ارده کنجد، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی.	ارده کنجد از محصولات منتخب هلسا در دسته ارده است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	265000	\N	\N	0	TOMAN	24	in_stock	5	1	\N	۶۵۰ گرم	بسته	بسته‌بندی بهداشتی هلسا	ارده کنجد	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/tahini.jpg	تصویر ارده کنجد هلسا	seed_reference	["/images/opt/tahini.jpg"]	4.7	74	\N	["ارده"]	[{"label": "وزن", "value": "۶۵۰ گرم"}, {"label": "مواد اولیه", "value": "ارده"}, {"label": "محل تولید", "value": "اردکان"}, {"label": "نوع بسته‌بندی", "value": "شیشه درب فلزی"}, {"label": "شرایط نگهداری", "value": "پس از باز شدن یخچال"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۷ گرم"}, {"label": "کربوهیدرات", "value": "۲۲ گرم"}, {"label": "چربی", "value": "۵۴ گرم"}]	["کنجد"]	t	f	t	خرید ارده کنجد هلسا	ارده کنجد، از مجموعه ارده هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
33	عرق بیدمشک	bidmeshk-distillate	distillates	15	HLA-0033	هلسا ایرانیان	عرق بیدمشک، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی.	عرق بیدمشک از محصولات منتخب هلسا در دسته عرقیات است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	165000	\N	\N	0	TOMAN	26	in_stock	5	1	\N	۱ لیتر	بسته	بسته‌بندی بهداشتی هلسا	عرق بیدمشک	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/distillate.jpg	تصویر عرق بیدمشک هلسا	seed_reference	["/images/opt/distillate.jpg"]	4.5	42	\N	["عرقیات"]	[{"label": "وزن", "value": "۱ لیتر"}, {"label": "مواد اولیه", "value": "عرقیات"}, {"label": "محل تولید", "value": "قمصر کاشان"}, {"label": "نوع بسته‌بندی", "value": "شیشه ضخیم درب‌دار"}, {"label": "شرایط نگهداری", "value": "دمای محیط"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰ گرم"}, {"label": "کربوهیدرات", "value": "۰ گرم"}, {"label": "چربی", "value": "۰ گرم"}]	[]	t	f	t	خرید عرق بیدمشک هلسا	عرق بیدمشک، از مجموعه عرقیات هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-13 10:59:48.073022
342	مربای آلبالو هلسا	sour-cherry-jam	jams	65	CAT-0159	هلسا ایرانیان	مربای آلبالو هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای آلبالو هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	310000	\N	\N	0	TOMAN	17	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای آلبالو هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/sour-cherry-jam.jpg	تصویر مربای آلبالو هلسا هلسا	brand_asset	["/images/opt/sour-cherry-jam.jpg"]	0	0	\N	["مربا", "مربای آلبالو هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای آلبالو هلسا"}]	[{"label": "انرژی", "value": "۲۳۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۴ گرم"}, {"label": "کربوهیدرات", "value": "۵۶ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱٫۲ گرم"}]	[]	t	f	t	خرید مربای آلبالو هلسا هلسا	مربای آلبالو هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.778436	2026-09-16 09:32:11.513
339	مربای به هلسا	quince-jam	jams	65	CAT-0156	هلسا ایرانیان	مربای به هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای به هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	340000	\N	\N	0	TOMAN	18	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای به هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/quince-jam.jpg	تصویر مربای به هلسا هلسا	brand_asset	["/images/opt/quince-jam.jpg"]	0	0	\N	["مربا", "مربای به هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای به هلسا"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۱ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱٫۴ گرم"}]	[]	t	f	t	خرید مربای به هلسا هلسا	مربای به هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.759685	2026-09-16 09:32:11.567
343	مربای هندونه هلسا	watermelon-rind-jam	jams	65	CAT-0160	هلسا ایرانیان	مربای هندونه هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای هندونه هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	290000	\N	\N	0	TOMAN	15	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای هندونه هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/watermelon-rind-jam.jpg	تصویر مربای هندونه هلسا هلسا	brand_asset	["/images/opt/watermelon-rind-jam.jpg"]	0	0	\N	["مربا", "مربای هندونه هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای هندونه هلسا"}]	[{"label": "انرژی", "value": "۲۵۵ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۳ گرم"}, {"label": "کربوهیدرات", "value": "۶۳ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۰٫۹ گرم"}]	[]	t	f	t	خرید مربای هندونه هلسا هلسا	مربای هندونه هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.784559	2026-09-16 09:32:11.57
340	مربای هویج هلسا	carrot-jam	jams	65	CAT-0157	هلسا ایرانیان	مربای هویج هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای هویج هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	280000	\N	\N	0	TOMAN	20	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای هویج هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/carrot-jam.jpg	تصویر مربای هویج هلسا هلسا	brand_asset	["/images/opt/carrot-jam.jpg"]	0	0	\N	["مربا", "مربای هویج هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای هویج هلسا"}]	[{"label": "انرژی", "value": "۲۶۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۴ گرم"}, {"label": "کربوهیدرات", "value": "۶۴ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱ گرم"}]	[]	t	f	t	خرید مربای هویج هلسا هلسا	مربای هویج هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.765988	2026-09-16 09:32:11.572
344	مربای گل محمدی هلسا	rose-petal-jam	jams	65	CAT-0161	هلسا ایرانیان	مربای گل محمدی هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی.	مربای گل محمدی هلسا از محصولات منتخب هلسا در دسته مربا است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. پس از باز شدن در یخچال نگهداری شود	420000	\N	\N	0	TOMAN	10	in_stock	5	1	20	250 گرم	بسته	شیشه بهداشتی با درب مهر و موم هلسا	مربای گل محمدی هلسا	ایران	پس از باز شدن در یخچال نگهداری شود	/images/opt/rose-petal-jam.jpg	تصویر مربای گل محمدی هلسا هلسا	brand_asset	["/images/opt/rose-petal-jam.jpg"]	0	0	\N	["مربا", "مربای گل محمدی هلسا"]	[{"label": "وزن", "value": "250 گرم"}, {"label": "نوع بسته‌بندی", "value": "شیشه بهداشتی با درب مهر و موم هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "مربای گل محمدی هلسا"}]	[{"label": "انرژی", "value": "۲۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۰٫۳ گرم"}, {"label": "کربوهیدرات", "value": "۶۲ گرم"}, {"label": "چربی", "value": "۰٫۱ گرم"}, {"label": "فیبر رژیمی", "value": "۱٫۳ گرم"}]	[]	t	f	t	خرید مربای گل محمدی هلسا هلسا	مربای گل محمدی هلسا، از مجموعه مربا هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.790651	2026-09-16 09:32:11.574
336	رولت شکلاتی هلسا	chocolate-roulade	cakes-desserts	64	CAT-0153	هلسا ایرانیان	رولت شکلاتی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	رولت شکلاتی هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	460000	\N	\N	0	TOMAN	15	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	رولت شکلاتی هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/chocolate-roulade.jpg	تصویر رولت شکلاتی هلسا هلسا	brand_asset	["/images/opt/chocolate-roulade.jpg"]	0	0	\N	["کیک و دسر", "رولت شکلاتی هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "رولت شکلاتی هلسا"}]	[{"label": "انرژی", "value": "۳۵۰ کیلوکالری"}, {"label": "پروتئین", "value": "۵٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۴۵ گرم"}, {"label": "چربی", "value": "۱۷ گرم"}, {"label": "فیبر رژیمی", "value": "۲ گرم"}]	[]	t	f	t	خرید رولت شکلاتی هلسا هلسا	رولت شکلاتی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.740407	2026-09-16 09:32:11.577
335	موس شکلات بلژیکی هلسا	belgian-chocolate-mousse	cakes-desserts	64	CAT-0152	هلسا ایرانیان	موس شکلات بلژیکی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	موس شکلات بلژیکی هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	520000	\N	\N	0	TOMAN	16	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	موس شکلات بلژیکی هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/belgian-chocolate-mousse.jpg	تصویر موس شکلات بلژیکی هلسا هلسا	brand_asset	["/images/opt/belgian-chocolate-mousse.jpg"]	0	0	\N	["کیک و دسر", "موس شکلات بلژیکی هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "موس شکلات بلژیکی هلسا"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۴٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۳۰ گرم"}, {"label": "چربی", "value": "۱۸ گرم"}, {"label": "فیبر رژیمی", "value": "۱٫۵ گرم"}]	[]	t	f	t	خرید موس شکلات بلژیکی هلسا هلسا	موس شکلات بلژیکی هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.734591	2026-09-16 09:32:11.579
333	کیک تیرامیسو هلسا	tiramisu-cake	cakes-desserts	64	CAT-0150	هلسا ایرانیان	کیک تیرامیسو هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی.	کیک تیرامیسو هلسا از محصولات منتخب هلسا در دسته کیک و دسر است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	640000	\N	\N	0	TOMAN	14	in_stock	5	1	20	500 گرم	بسته	جعبه کادویی کیک هلسا	کیک تیرامیسو هلسا	ایران	در یخچال (۲ تا ۶ درجه) نگهداری شود و تا ۴۸ ساعت مصرف شود	/images/opt/tiramisu-cake.jpg	تصویر کیک تیرامیسو هلسا هلسا	brand_asset	["/images/opt/tiramisu-cake.jpg"]	0	0	\N	["کیک و دسر", "کیک تیرامیسو هلسا"]	[{"label": "وزن", "value": "500 گرم"}, {"label": "نوع بسته‌بندی", "value": "جعبه کادویی کیک هلسا"}, {"label": "محل تولید", "value": "ایران"}, {"label": "مواد اولیه", "value": "کیک تیرامیسو هلسا"}]	[{"label": "انرژی", "value": "۲۸۰ کیلوکالری"}, {"label": "پروتئین", "value": "۵ گرم"}, {"label": "کربوهیدرات", "value": "۳۰ گرم"}, {"label": "چربی", "value": "۱۴ گرم"}, {"label": "فیبر رژیمی", "value": "۰٫۸ گرم"}]	[]	t	t	t	خرید کیک تیرامیسو هلسا هلسا	کیک تیرامیسو هلسا، از مجموعه کیک و دسر هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2026-09-13 10:32:57.72089	2026-09-16 09:32:11.586
7	شکلات دست‌ساز خرما	handmade-date-chocolate	date-products	\N	HLA-0007	هلسا ایرانیان	شکلات دست‌ساز خرما پیارم با شکلات تلخ ۷۰٪ و پاشش پسته؛ بدون شکر افزوده.	خرمای پیارم بدون هسته، غرق در شکلات تلخ ۷۰٪ دست‌ساز با پاشش پسته و گلبرگ خشک. بدون شکر افزوده؛ شیرینی فقط از خرما.	395000	460000	\N	14	TOMAN	1	low_stock	5	1	\N	۳۵۰ گرم (۱۴ عدد)	بسته	جعبه هدیه هلسا با کاغذ شیتی و کارت ارجاع	خرما پیارم بدون هسته، شکلات تلخ ۷۰٪ (کاکائو، کره کاکائو)، خرده پسته، گلبرگ خشک	داراب، فارس	دمای ۱۸ تا ۲۲ درجه	/images/opt/handmade-date-chocolate.jpg	تصویر شکلات دست‌ساز خرمای هلسا	seed_reference	["/images/opt/handmade-date-chocolate.jpg", "/images/opt/chocolate-coated-dates.jpg", "/images/opt/handmade-date-chocolate-2.jpg"]	4.9	168	ویژه	["شکلات خرما", "دست‌ساز", "بدون شکر افزوده"]	[{"label": "وزن", "value": "۳۵۰ گرم (۱۴ عدد)"}, {"label": "مواد اولیه", "value": "شکلات خرما"}, {"label": "محل تولید", "value": "کارگاه هلسا، تهران"}, {"label": "نوع بسته‌بندی", "value": "جعبه مقوایی سخت با جداکننده داخلی"}, {"label": "شرایط نگهداری", "value": "دمای ۱۸ تا ۲۲ درجه"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۵۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۶ گرم"}, {"label": "کربوهیدرات", "value": "۴۸ گرم"}, {"label": "چربی", "value": "۳۲ گرم"}]	["مغزها", "لبنیات", "سویا"]	t	f	t	خرید شکلات دست‌ساز خرما هلسا	شکلات دست‌ساز خرما پیارم با شکلات تلخ ۷۰٪ و پاشش پسته؛ بدون شکر افزوده. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-07-20 00:00:00	2026-09-16 13:37:20.507
9	قند خرما	date-sugar	date-sugar	31	HLA-0009	هلسا ایرانیان	قند خرما، از مجموعه قند خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	قند خرما از محصولات منتخب هلسا در دسته قند خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: ایران. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	185000	\N	\N	0	TOMAN	6	in_stock	5	1	\N	۵۰۰ گرم	بسته	بسته‌بندی بهداشتی هلسا	قند خرما	ایران	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/date-sugar.jpg	تصویر قند خرما هلسا	seed_reference	["/images/opt/date-sugar.jpg"]	4.7	121	محبوب	["قند خرما", "بدون شکر"]	[{"label": "وزن", "value": "۵۰۰ گرم"}, {"label": "مواد اولیه", "value": "قند خرما"}, {"label": "محل تولید", "value": "خوزستان"}, {"label": "نوع بسته‌بندی", "value": "بسته کرافت پنجره‌دار"}, {"label": "شرایط نگهداری", "value": "دمای محیط، درب بسته"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۳۲۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۸۷ گرم"}, {"label": "چربی", "value": "۰٫۳ گرم"}]	[]	t	f	t	خرید قند خرما هلسا	قند خرما، از مجموعه قند خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-03-01 00:00:00	2026-09-16 13:39:05.054
13	آجیل ممتاز شب‌چره	premium-mixed-nuts	nuts	\N	HLA-0013	هلسا ایرانیان	ترکیب ممتاز پسته اکبری، بادام هندی، فندق، گردو و بادام درختی؛ بو داده ملایم.	ترکیب ممتاز پسته اکبری، بادام هندی، فندق، مغز گردو و بادام درختی؛ بو داده با حرارت ملایم و نمک دریا.	890000	1020000	\N	13	TOMAN	23	in_stock	5	1	\N	۱ کیلوگرم	بسته	جعبه مقوایی هلسا با پنجره نمایش و روبان کتان	پسته اکبری، بادام هندی، فندق، مغز گردو، بادام درختی	رفسنجان، کرمان و تویسرکان، همدان	مكان خنک و خشک	/images/opt/premium-mixed-nuts.jpg	تصویر آجیل ممتاز شب‌چره هلسا	seed_reference	["/images/opt/premium-mixed-nuts.jpg", "/images/opt/party-nuts.jpg", "/images/opt/four-nut-mix.jpg"]	4.9	232	پرفروش	["آجیل ممتاز", "شب‌چره"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "آجیل ممتاز"}, {"label": "محل تولید", "value": "کرمان و قزوین"}, {"label": "نوع بسته‌بندی", "value": "بسته متالایز تازه‌ماندگار"}, {"label": "شرایط نگهداری", "value": "مكان خنک و خشک"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۶۰۰ کیلوکالری"}, {"label": "پروتئین", "value": "۱۸ گرم"}, {"label": "کربوهیدرات", "value": "۲۰ گرم"}, {"label": "چربی", "value": "۵۲ گرم"}]	["مغزها"]	t	f	t	خرید آجیل ممتاز شب‌چره هلسا	ترکیب ممتاز پسته اکبری، بادام هندی، فندق، گردو و بادام درختی؛ بو داده ملایم. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-04-12 00:00:00	2026-09-16 14:08:21.511
1	خرما پیارم	piaram-dates	dates	1	HLA-0001	هلسا ایرانیان	خرما پیارم، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی.	خرما پیارم از محصولات منتخب هلسا در دسته خرما است. این محصول با تمرکز بر طعم، بافت و بسته‌بندی مناسب عرضه می‌شود. مبدأ ثبت‌شده: هرمزگان. در جای خشک و خنک، دور از نور مستقیم نگهداری شود	485000	560000	\N	13	TOMAN	28	in_stock	5	1	\N	۱ کیلوگرم	بسته	بسته‌بندی بهداشتی هلسا	خرما پیارم	هرمزگان	در جای خشک و خنک، دور از نور مستقیم نگهداری شود	/images/opt/piaram-premium.jpg	خرمای پیارم ممتاز حاجی‌آباد — کشیده، روشن و چین‌دار	seed_reference	["/images/opt/piaram-premium.jpg"]	4.9	214	پرفروش	["خرما پیارم", "خرمای لوکس"]	[{"label": "وزن", "value": "۱ کیلوگرم"}, {"label": "مواد اولیه", "value": "خرما پیارم"}, {"label": "محل تولید", "value": "هرمزگان، حاجی‌آباد"}, {"label": "نوع بسته‌بندی", "value": "جعبه مقوایی لوکس با ظرف داخلی"}, {"label": "شرایط نگهداری", "value": "دمای خنک (۴ تا ۱۰ درجه)"}, {"label": "تاریخ تولید", "value": "۱۴۰۴/۰۷/۰۱"}, {"label": "تاریخ انقضا", "value": "۱۴۰۵/۰۷/۰۱"}]	[{"label": "انرژی", "value": "۲۹۰ کیلوکالری"}, {"label": "پروتئین", "value": "۲٫۵ گرم"}, {"label": "کربوهیدرات", "value": "۷۵ گرم"}, {"label": "چربی", "value": "۰٫۵ گرم"}]	[]	t	f	t	خرید خرما پیارم هلسا	خرما پیارم، از مجموعه خرما هلسا؛ مناسب مصرف روزانه و پذیرایی. قیمت و موجودی به‌روز را در هلسا مارکت مشاهده کنید.	\N	2025-06-10 00:00:00	2026-09-16 14:10:09.999
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reviews (id, product_id, customer_id, author, rating, title, text, is_approved, created_at, verified_phone, verified_purchase) FROM stdin;
1	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 07:30:47.064677	09126194161	f
2	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 07:34:53.519671	09126500905	f
3	13	\N	مشتری هلسا	5	تست دستی	متن تست دستی برای بررسی	f	2026-09-16 09:05:49.054563	09129990004	f
4	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 09:06:27.994474	09122321995	f
5	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 09:24:05.705593	09121724608	f
6	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 09:41:50.456445	09122342602	f
7	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 10:01:24.518241	09123714593	f
8	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 10:22:51.984963	09129750400	f
9	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 10:39:10.300646	09123388313	f
10	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 10:41:13.717377	09126586730	f
11	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 11:06:17.593672	09126590393	f
12	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 11:09:01.568379	09129935594	f
13	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 13:02:18.365208	09121676235	f
14	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 13:36:07.502473	09128110418	f
15	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 13:36:39.319729	09125321408	f
16	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 14:05:42.280927	09124241803	f
17	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 14:06:35.424459	09128441311	f
18	13	\N	مشتری هلسا	5	عالی و تازه	خرید دومم است؛ کیفیت و بسته‌بندی عالی بود. تست خودکار.	f	2026-09-16 14:07:21.136898	09124107590	f
\.


--
-- Data for Name: shipping_methods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shipping_methods (id, code, label, description, estimated_time, price, is_active, sort_order, created_at, updated_at) FROM stdin;
1	standard	ارسال عادی	ارسال با روش استاندارد فروشگاه	۲ تا ۴ روز کاری	85000	t	1	2026-09-11 22:07:59.184729	2026-09-13 10:32:57.806
2	express	ارسال سریع	ویژه محدوده‌های پشتیبانی‌شده تهران	طبق هماهنگی سفارش	120000	t	2	2026-09-11 22:07:59.185853	2026-09-13 10:32:57.808
3	pickup	تحویل حضوری	تحویل با هماهنگی قبلی	هماهنگی تلفنی	0	t	3	2026-09-11 22:07:59.186681	2026-09-13 10:32:57.808
\.


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site_settings (key, value, updated_at) FROM stdin;
\.


--
-- Data for Name: tray_customizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tray_customizations (id, group_id, option_id, label, price) FROM stdin;
1	savory	cheese	پنیر	220000
2	savory	olive	زیتون	140000
3	savory	deli	کالباس / فرآورده‌های گوشتی	320000
4	savory	pickle	خیارشور	90000
5	savory	veggie	سبزیجات	110000
6	savory	dip	دیپ	130000
7	savory	cracker	کراکر	95000
8	sweet	dates	خرما	210000
9	sweet	datechoc	شکلات خرمایی	260000
10	sweet	driedfruit	میوه خشک	170000
11	sweet	sweets	شیرینی	190000
12	sweet	honey	عسل	160000
13	sweet	jam	مربا	120000
14	nuts	pistachio	پسته	340000
15	nuts	almond	بادام	190000
16	nuts	walnut	گردو	240000
17	nuts	hazelnut	فندق	260000
18	nuts	cashew	بادام هندی	310000
19	fruit	grape	انگور	120000
20	fruit	strawberry	توت‌فرنگی	150000
21	fruit	apple	سیب	90000
22	fruit	orange	پرتقال	100000
23	fruit	fig	انجیر	160000
24	fruit	seasonal	سایر میوه‌های فصل	140000
\.


--
-- Data for Name: tray_occasions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tray_occasions (id, label) FROM stdin;
1	دورهمی
2	مهمانی خانوادگی
3	تولد
4	عروسی
5	شب یلدا
6	نوروز
7	رمضان
8	جلسه کاری
9	پذیرایی VIP
10	هدیه
\.


--
-- Data for Name: tray_quotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tray_quotes (id, config, total, created_at) FROM stdin;
1	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 1, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	2990000	2026-09-11 22:48:26.620148
2	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	3380000	2026-09-11 22:48:27.725816
3	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-11 22:48:28.520924
4	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-11 22:48:33.502098
5	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-11 22:48:33.770809
6	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 1, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	2990000	2026-09-12 07:39:42.315965
7	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	3380000	2026-09-12 07:39:43.439708
8	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-12 07:39:44.220381
9	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-12 07:39:49.14443
10	{"base": "wood", "size": "corporate", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 2, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "سازمانی · چوب طبیعی"}	6530000	2026-09-12 07:39:49.402242
11	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "dates-mazafati", "qty": 1, "label": "خرمای مضافتی"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 1, "label": "پسته"}, {"id": "drink-coffee", "qty": 1, "label": "قهوه"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	2990000	2026-09-12 07:40:53.658802
12	{"base": "wood", "size": "medium", "decor": [], "items": [{"id": "pastry-tiramisu", "qty": 2, "label": "تیرامیسو هلسا"}, {"id": "jam-quince", "qty": 1, "label": "مربای به"}, {"id": "cheese-feta", "qty": 1, "label": "پنیر فتا"}, {"id": "nuts-pistachio", "qty": 1, "label": "پسته"}], "guests": 6, "builder": "advanced", "message": false, "giftWrap": "none", "sizeLabel": "متوسط · چوب طبیعی"}	3480000	2026-09-13 10:39:03.13912
\.


--
-- Data for Name: tray_sizes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tray_sizes (id, code, label, base_price, factor) FROM stdin;
1	small	کوچک	950000	1
2	medium	متوسط	1650000	1.35
3	large	بزرگ	2450000	1.8
4	vip	VIP	3900000	2.6
\.


--
-- Data for Name: wholesale_businesses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wholesale_businesses (id, code, business_name, business_type, contact_name, mobile, email, city, address, economic_code, monthly_volume, interests, notes, discount_percent, status, customer_id, admin_note, reviewed_at, created_at, updated_at) FROM stdin;
1	WSB-XIQM4861	کافه دمو 5156	cafe	رضا کافه‌دار	09124445156	demo5156.cafe@helsa-test.ir	تهران						12	approved	4		2026-09-11 22:19:16.494	2026-09-11 22:19:16.473278	2026-09-11 22:19:16.494
2	WSB-XIRIE791	کافه دمو 5198	cafe	رضا کافه‌دار	09124445198	demo5198.cafe@helsa-test.ir	تهران						12	approved	5		2026-09-11 22:19:58.318	2026-09-11 22:19:58.303618	2026-09-11 22:19:58.318
3	WSB-XIRSQ525	کافه دمو 5211	cafe	رضا کافه‌دار	09124445211	demo5211.cafe@helsa-test.ir	تهران						12	approved	6		2026-09-11 22:20:11.713	2026-09-11 22:20:11.694196	2026-09-11 22:20:11.713
4	WSB-XIRT5R38	کافه دمو 5212	cafe	رضا کافه‌دار	09124445212	demo5212.cafe@helsa-test.ir	تهران						12	approved	7		2026-09-11 22:20:12.272	2026-09-11 22:20:12.25641	2026-09-11 22:20:12.272
5	WSB-XITRFX36	کافه دمو 5303	cafe	رضا کافه‌دار	09124445303	demo5303.cafe@helsa-test.ir	تهران						12	approved	8		2026-09-11 22:21:43.358	2026-09-11 22:21:43.34229	2026-09-11 22:21:43.358
6	WSB-Y2T09H47	کافه دمو 8860	cafe	رضا کافه‌دار	09124448860	demo8860.cafe@helsa-test.ir	تهران						12	approved	23		2026-09-12 07:41:00.453	2026-09-12 07:41:00.438277	2026-09-12 07:41:00.453
7	WSB-3ZW79K47	کافه دمو 56767	cafe	رضا کافه‌دار	09124446767	demo6767.cafe@helsa-test.ir	تهران	تهران، خیابان ولیعصر	411123456789	۲۰ تا ۵۰ میلیون	خرما، دیپ، آجیل	برای تست ممیزی	0	pending	55		\N	2026-09-16 11:06:07.689547	2026-09-16 11:06:07.688
8	WSB-3ZY3GJ54	کافه دمو 56855	cafe	رضا کافه‌دار	09124446855	demo6855.cafe@helsa-test.ir	تهران	تهران، خیابان ولیعصر	411123456789	۲۰ تا ۵۰ میلیون	خرما، دیپ، آجیل	برای تست ممیزی	0	pending	56		\N	2026-09-16 11:07:36.068385	2026-09-16 11:07:36.067
9	WSB-3ZYMVJ57	کافه دمو 56881	cafe	رضا کافه‌دار	09124446881	demo6881.cafe@helsa-test.ir	تهران	تهران، خیابان ولیعصر	411123456789	۲۰ تا ۵۰ میلیون	خرما، دیپ، آجیل	برای تست ممیزی	0	pending	58		\N	2026-09-16 11:08:01.231725	2026-09-16 11:08:01.231
10	WSB-3ZZD4440	کافه دمو 56915	cafe	رضا کافه‌دار	09124446915	demo6915.cafe@helsa-test.ir	تهران	تهران، خیابان ولیعصر	411123456789	۲۰ تا ۵۰ میلیون	خرما، دیپ، آجیل	برای تست ممیزی	0	pending	60		\N	2026-09-16 11:08:35.237658	2026-09-16 11:08:35.236
11	WSB-46HOO556	کافه دمو 67847	cafe	رضا کافه‌دار	09124447847	demo7847.cafe@helsa-test.ir	تهران	تهران، خیابان ولیعصر	411123456789	۲۰ تا ۵۰ میلیون	خرما، دیپ، آجیل	برای تست ممیزی	0	pending	77		\N	2026-09-16 14:10:47.717805	2026-09-16 14:10:47.717
\.


--
-- Data for Name: wholesale_inquiries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wholesale_inquiries (id, code, business_type, company_name, contact_name, mobile, email, city, estimated_monthly_volume, product_interests, notes, status, created_at, updated_at) FROM stdin;
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: -
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 1, false);


--
-- Name: accounting_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.accounting_transactions_id_seq', 26, true);


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.addresses_id_seq', 21, true);


--
-- Name: admin_audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_audit_logs_id_seq', 50, true);


--
-- Name: admin_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_notifications_id_seq', 2, true);


--
-- Name: allergens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.allergens_id_seq', 6, true);


--
-- Name: auth_challenges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_challenges_id_seq', 72, true);


--
-- Name: banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.banners_id_seq', 1, false);


--
-- Name: beverage_pairings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.beverage_pairings_id_seq', 8, true);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 65, true);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contact_messages_id_seq', 25, true);


--
-- Name: corporate_gift_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.corporate_gift_requests_id_seq', 6, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customers_id_seq', 77, true);


--
-- Name: gift_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gift_packages_id_seq', 12, true);


--
-- Name: gift_quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gift_quotes_id_seq', 6, true);


--
-- Name: instagram_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.instagram_posts_id_seq', 37, true);


--
-- Name: inventory_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_movements_id_seq', 237, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoices_id_seq', 2, true);


--
-- Name: mazeh_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mazeh_categories_id_seq', 7, true);


--
-- Name: mazeh_tray_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mazeh_tray_items_id_seq', 119, true);


--
-- Name: mazeh_trays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mazeh_trays_id_seq', 12, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_items_id_seq', 58, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_id_seq', 38, true);


--
-- Name: party_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.party_packages_id_seq', 5, true);


--
-- Name: payment_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payment_logs_id_seq', 3, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 39, true);


--
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_images_id_seq', 173, true);


--
-- Name: product_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_variants_id_seq', 348, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 345, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reviews_id_seq', 18, true);


--
-- Name: shipping_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shipping_methods_id_seq', 6, true);


--
-- Name: tray_customizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tray_customizations_id_seq', 24, true);


--
-- Name: tray_occasions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tray_occasions_id_seq', 10, true);


--
-- Name: tray_quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tray_quotes_id_seq', 12, true);


--
-- Name: tray_sizes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tray_sizes_id_seq', 4, true);


--
-- Name: wholesale_businesses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wholesale_businesses_id_seq', 11, true);


--
-- Name: wholesale_inquiries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wholesale_inquiries_id_seq', 1, false);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: accounting_transactions accounting_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounting_transactions
    ADD CONSTRAINT accounting_transactions_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_audit_logs admin_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_audit_logs
    ADD CONSTRAINT admin_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: admin_notifications admin_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_notifications
    ADD CONSTRAINT admin_notifications_pkey PRIMARY KEY (id);


--
-- Name: allergens allergens_label_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergens
    ADD CONSTRAINT allergens_label_unique UNIQUE (label);


--
-- Name: allergens allergens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergens
    ADD CONSTRAINT allergens_pkey PRIMARY KEY (id);


--
-- Name: auth_challenges auth_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_challenges
    ADD CONSTRAINT auth_challenges_pkey PRIMARY KEY (id);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: beverage_pairings beverage_pairings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.beverage_pairings
    ADD CONSTRAINT beverage_pairings_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_slug_unique UNIQUE (slug);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_unique UNIQUE (slug);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: corporate_gift_requests corporate_gift_requests_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_gift_requests
    ADD CONSTRAINT corporate_gift_requests_code_unique UNIQUE (code);


--
-- Name: corporate_gift_requests corporate_gift_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_gift_requests
    ADD CONSTRAINT corporate_gift_requests_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: gift_packages gift_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_packages
    ADD CONSTRAINT gift_packages_pkey PRIMARY KEY (id);


--
-- Name: gift_packages gift_packages_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_packages
    ADD CONSTRAINT gift_packages_slug_unique UNIQUE (slug);


--
-- Name: gift_quotes gift_quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_quotes
    ADD CONSTRAINT gift_quotes_pkey PRIMARY KEY (id);


--
-- Name: instagram_posts instagram_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instagram_posts
    ADD CONSTRAINT instagram_posts_pkey PRIMARY KEY (id);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_number_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_number_unique UNIQUE (number);


--
-- Name: invoices invoices_order_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_unique UNIQUE (order_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: mazeh_categories mazeh_categories_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_categories
    ADD CONSTRAINT mazeh_categories_code_unique UNIQUE (code);


--
-- Name: mazeh_categories mazeh_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_categories
    ADD CONSTRAINT mazeh_categories_pkey PRIMARY KEY (id);


--
-- Name: mazeh_tray_items mazeh_tray_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_tray_items
    ADD CONSTRAINT mazeh_tray_items_pkey PRIMARY KEY (id);


--
-- Name: mazeh_trays mazeh_trays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_trays
    ADD CONSTRAINT mazeh_trays_pkey PRIMARY KEY (id);


--
-- Name: mazeh_trays mazeh_trays_sku_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_trays
    ADD CONSTRAINT mazeh_trays_sku_unique UNIQUE (sku);


--
-- Name: mazeh_trays mazeh_trays_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_trays
    ADD CONSTRAINT mazeh_trays_slug_unique UNIQUE (slug);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_code_unique UNIQUE (code);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: party_packages party_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.party_packages
    ADD CONSTRAINT party_packages_pkey PRIMARY KEY (id);


--
-- Name: payment_logs payment_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_logs
    ADD CONSTRAINT payment_logs_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_sku_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_unique UNIQUE (sku);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_unique UNIQUE (sku);


--
-- Name: products products_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_unique UNIQUE (slug);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: shipping_methods shipping_methods_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_methods
    ADD CONSTRAINT shipping_methods_code_unique UNIQUE (code);


--
-- Name: shipping_methods shipping_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipping_methods
    ADD CONSTRAINT shipping_methods_pkey PRIMARY KEY (id);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (key);


--
-- Name: tray_customizations tray_customizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_customizations
    ADD CONSTRAINT tray_customizations_pkey PRIMARY KEY (id);


--
-- Name: tray_occasions tray_occasions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_occasions
    ADD CONSTRAINT tray_occasions_pkey PRIMARY KEY (id);


--
-- Name: tray_quotes tray_quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_quotes
    ADD CONSTRAINT tray_quotes_pkey PRIMARY KEY (id);


--
-- Name: tray_sizes tray_sizes_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_sizes
    ADD CONSTRAINT tray_sizes_code_unique UNIQUE (code);


--
-- Name: tray_sizes tray_sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tray_sizes
    ADD CONSTRAINT tray_sizes_pkey PRIMARY KEY (id);


--
-- Name: wholesale_businesses wholesale_businesses_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_businesses
    ADD CONSTRAINT wholesale_businesses_code_unique UNIQUE (code);


--
-- Name: wholesale_businesses wholesale_businesses_mobile_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_businesses
    ADD CONSTRAINT wholesale_businesses_mobile_unique UNIQUE (mobile);


--
-- Name: wholesale_businesses wholesale_businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_businesses
    ADD CONSTRAINT wholesale_businesses_pkey PRIMARY KEY (id);


--
-- Name: wholesale_inquiries wholesale_inquiries_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_inquiries
    ADD CONSTRAINT wholesale_inquiries_code_unique UNIQUE (code);


--
-- Name: wholesale_inquiries wholesale_inquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_inquiries
    ADD CONSTRAINT wholesale_inquiries_pkey PRIMARY KEY (id);


--
-- Name: accounting_reference_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX accounting_reference_unique ON public.accounting_transactions USING btree (type, reference_type, reference_id);


--
-- Name: accounting_type_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accounting_type_created_idx ON public.accounting_transactions USING btree (type, created_at);


--
-- Name: addresses_customer_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX addresses_customer_idx ON public.addresses USING btree (customer_id, is_default);


--
-- Name: admin_audit_entity_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX admin_audit_entity_idx ON public.admin_audit_logs USING btree (entity_type, entity_id, created_at);


--
-- Name: admin_notifications_read_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX admin_notifications_read_idx ON public.admin_notifications USING btree (is_read, created_at);


--
-- Name: auth_challenges_identifier_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_challenges_identifier_idx ON public.auth_challenges USING btree (identifier, purpose);


--
-- Name: categories_active_sort_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_active_sort_idx ON public.categories USING btree (is_active, sort_order);


--
-- Name: corporate_gift_requests_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX corporate_gift_requests_status_idx ON public.corporate_gift_requests USING btree (status, created_at);


--
-- Name: customers_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX customers_email_unique ON public.customers USING btree (email);


--
-- Name: customers_phone_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX customers_phone_unique ON public.customers USING btree (phone);


--
-- Name: gift_packages_kind_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gift_packages_kind_active_idx ON public.gift_packages USING btree (kind, is_active);


--
-- Name: instagram_posts_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX instagram_posts_active_idx ON public.instagram_posts USING btree (is_active, sort_order);


--
-- Name: inventory_product_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_product_created_idx ON public.inventory_movements USING btree (product_id, created_at);


--
-- Name: invoices_customer_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invoices_customer_idx ON public.invoices USING btree (customer_id);


--
-- Name: mazeh_trays_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mazeh_trays_active_idx ON public.mazeh_trays USING btree (active, featured);


--
-- Name: order_items_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_items_order_idx ON public.order_items USING btree (order_id);


--
-- Name: orders_customer_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orders_customer_idx ON public.orders USING btree (customer_id);


--
-- Name: orders_idempotency_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX orders_idempotency_idx ON public.orders USING btree (idempotency_key);


--
-- Name: orders_status_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orders_status_created_idx ON public.orders USING btree (status, created_at);


--
-- Name: payment_logs_event_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_logs_event_idx ON public.payment_logs USING btree (event);


--
-- Name: payment_logs_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_logs_order_idx ON public.payment_logs USING btree (order_id);


--
-- Name: payments_authority_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_authority_idx ON public.payments USING btree (authority);


--
-- Name: payments_order_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payments_order_idx ON public.payments USING btree (order_id, status);


--
-- Name: product_images_product_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_images_product_idx ON public.product_images USING btree (product_id, sort_order);


--
-- Name: product_variants_product_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_variants_product_idx ON public.product_variants USING btree (product_id, is_active);


--
-- Name: products_category_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_category_active_idx ON public.products USING btree (category, is_active, is_visible);


--
-- Name: products_featured_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_featured_idx ON public.products USING btree (is_featured);


--
-- Name: products_stock_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_stock_idx ON public.products USING btree (stock_status, stock);


--
-- Name: reviews_customer_product_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX reviews_customer_product_unique ON public.reviews USING btree (customer_id, product_id);


--
-- Name: wholesale_businesses_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wholesale_businesses_status_idx ON public.wholesale_businesses USING btree (status, created_at);


--
-- Name: wholesale_inquiries_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wholesale_inquiries_status_idx ON public.wholesale_inquiries USING btree (status, created_at);


--
-- Name: addresses addresses_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: gift_quotes gift_quotes_package_id_gift_packages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_quotes
    ADD CONSTRAINT gift_quotes_package_id_gift_packages_id_fk FOREIGN KEY (package_id) REFERENCES public.gift_packages(id) ON DELETE CASCADE;


--
-- Name: inventory_movements inventory_movements_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: inventory_movements inventory_movements_tray_id_mazeh_trays_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_tray_id_mazeh_trays_id_fk FOREIGN KEY (tray_id) REFERENCES public.mazeh_trays(id) ON DELETE SET NULL;


--
-- Name: inventory_movements inventory_movements_variant_id_product_variants_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_variant_id_product_variants_id_fk FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- Name: invoices invoices_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: invoices invoices_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: mazeh_tray_items mazeh_tray_items_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_tray_items
    ADD CONSTRAINT mazeh_tray_items_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: mazeh_tray_items mazeh_tray_items_tray_id_mazeh_trays_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mazeh_tray_items
    ADD CONSTRAINT mazeh_tray_items_tray_id_mazeh_trays_id_fk FOREIGN KEY (tray_id) REFERENCES public.mazeh_trays(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_tray_id_mazeh_trays_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_tray_id_mazeh_trays_id_fk FOREIGN KEY (tray_id) REFERENCES public.mazeh_trays(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_variant_id_product_variants_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_variant_id_product_variants_id_fk FOREIGN KEY (variant_id) REFERENCES public.product_variants(id) ON DELETE SET NULL;


--
-- Name: orders orders_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: payment_logs payment_logs_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_logs
    ADD CONSTRAINT payment_logs_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: payment_logs payment_logs_payment_id_payments_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_logs
    ADD CONSTRAINT payment_logs_payment_id_payments_id_fk FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE SET NULL;


--
-- Name: payments payments_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: product_images product_images_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_variants product_variants_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: reviews reviews_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: reviews reviews_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: wholesale_businesses wholesale_businesses_customer_id_customers_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wholesale_businesses
    ADD CONSTRAINT wholesale_businesses_customer_id_customers_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict pdtEc0kic1iIFVLZXobU1PaL3zFcGz1iLyPmqDWEqFen7wpLLDqOxyzDfJYUtan

