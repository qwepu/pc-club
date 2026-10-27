--
-- PostgreSQL database cluster dump
--

-- Started on 2026-10-27 15:06:13

\restrict jP3MaVdwkwRr3JK20Z1bBYSpvCSqeKLap33uO9iQPynoaeijz983Xb01ztpAwn2

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE user1;
ALTER ROLE user1 WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:z+lOEjZtFT9tm44rodm10w==$1h/pShIXypBEf9MZyKVbFHLvcHRPaWWq5vP+M8F9U/Q=:QyP8Ez6kr5F3Oy9DAkLgv5n+yc8uPbAjkL2gUbuwFt8=';

--
-- User Configurations
--








\unrestrict jP3MaVdwkwRr3JK20Z1bBYSpvCSqeKLap33uO9iQPynoaeijz983Xb01ztpAwn2

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict rSVg0dh964q3uqwKyxoOlSCCdXNWL4pcIbV0uTySJTShiP0IHYBVgtXj7NgBSne

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-27 15:06:13

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

-- Completed on 2026-10-27 15:06:13

--
-- PostgreSQL database dump complete
--

\unrestrict rSVg0dh964q3uqwKyxoOlSCCdXNWL4pcIbV0uTySJTShiP0IHYBVgtXj7NgBSne

--
-- Database "MyDataBase" dump
--

--
-- PostgreSQL database dump
--

\restrict PMhh11FKeUrz7YherSrhAM7gWTUlg1ZkJClGU55WegDkdiRawyGjHhikcpe8r4i

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-27 15:06:13

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
-- TOC entry 3562 (class 1262 OID 16384)
-- Name: MyDataBase; Type: DATABASE; Schema: -; Owner: user1
--

CREATE DATABASE "MyDataBase" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "MyDataBase" OWNER TO user1;

\unrestrict PMhh11FKeUrz7YherSrhAM7gWTUlg1ZkJClGU55WegDkdiRawyGjHhikcpe8r4i
\connect "MyDataBase"
\restrict PMhh11FKeUrz7YherSrhAM7gWTUlg1ZkJClGU55WegDkdiRawyGjHhikcpe8r4i

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 234 (class 1259 OID 16697)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    action character varying(20) NOT NULL,
    entity_name character varying(100),
    user_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    details text,
    CONSTRAINT audit_logs_action_check CHECK (((action)::text = ANY ((ARRAY['CREATE'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying, 'LOGIN'::character varying, 'LOGOUT'::character varying, 'REGISTER'::character varying])::text[])))
);


ALTER TABLE public.audit_logs OWNER TO user1;

--
-- TOC entry 233 (class 1259 OID 16696)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO user1;

--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 233
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- TOC entry 224 (class 1259 OID 16596)
-- Name: computers; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.computers (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    description text
);


ALTER TABLE public.computers OWNER TO user1;

--
-- TOC entry 223 (class 1259 OID 16595)
-- Name: computers_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.computers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.computers_id_seq OWNER TO user1;

--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 223
-- Name: computers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.computers_id_seq OWNED BY public.computers.id;


--
-- TOC entry 228 (class 1259 OID 16628)
-- Name: game_sessions; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.game_sessions (
    id integer NOT NULL,
    start_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    end_time timestamp without time zone,
    cost numeric(10,2) DEFAULT 0 NOT NULL,
    user_id integer NOT NULL,
    computer_id integer NOT NULL,
    tariff_id integer NOT NULL,
    CONSTRAINT game_sessions_check CHECK (((end_time IS NULL) OR (end_time >= start_time))),
    CONSTRAINT game_sessions_cost_check CHECK ((cost >= (0)::numeric))
);


ALTER TABLE public.game_sessions OWNER TO user1;

--
-- TOC entry 227 (class 1259 OID 16627)
-- Name: game_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.game_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.game_sessions_id_seq OWNER TO user1;

--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 227
-- Name: game_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.game_sessions_id_seq OWNED BY public.game_sessions.id;


--
-- TOC entry 236 (class 1259 OID 16716)
-- Name: order_items; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price_at_order numeric(10,2) NOT NULL,
    CONSTRAINT order_items_price_at_order_check CHECK ((price_at_order >= (0)::numeric)),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_items OWNER TO user1;

--
-- TOC entry 235 (class 1259 OID 16715)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO user1;

--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 230 (class 1259 OID 16660)
-- Name: orders; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status character varying(20) DEFAULT 'New'::character varying NOT NULL,
    comment text,
    user_id integer NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['New'::character varying, 'Processing'::character varying, 'Completed'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO user1;

--
-- TOC entry 229 (class 1259 OID 16659)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO user1;

--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 229
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 232 (class 1259 OID 16681)
-- Name: products; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    price numeric(10,2) NOT NULL,
    quantity_in_stock integer DEFAULT 0 NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT products_quantity_in_stock_check CHECK ((quantity_in_stock >= 0))
);


ALTER TABLE public.products OWNER TO user1;

--
-- TOC entry 231 (class 1259 OID 16680)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO user1;

--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 231
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 220 (class 1259 OID 16564)
-- Name: roles; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    description character varying(200)
);


ALTER TABLE public.roles OWNER TO user1;

--
-- TOC entry 219 (class 1259 OID 16563)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO user1;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 226 (class 1259 OID 16611)
-- Name: tariffs; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.tariffs (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description text,
    CONSTRAINT tariffs_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE public.tariffs OWNER TO user1;

--
-- TOC entry 225 (class 1259 OID 16610)
-- Name: tariffs_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.tariffs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tariffs_id_seq OWNER TO user1;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 225
-- Name: tariffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.tariffs_id_seq OWNED BY public.tariffs.id;


--
-- TOC entry 222 (class 1259 OID 16575)
-- Name: users; Type: TABLE; Schema: public; Owner: user1
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100),
    role_id integer NOT NULL
);


ALTER TABLE public.users OWNER TO user1;

--
-- TOC entry 221 (class 1259 OID 16574)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: user1
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO user1;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user1
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3344 (class 2604 OID 16700)
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 16599)
-- Name: computers id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.computers ALTER COLUMN id SET DEFAULT nextval('public.computers_id_seq'::regclass);


--
-- TOC entry 3335 (class 2604 OID 16631)
-- Name: game_sessions id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.game_sessions ALTER COLUMN id SET DEFAULT nextval('public.game_sessions_id_seq'::regclass);


--
-- TOC entry 3346 (class 2604 OID 16719)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 3338 (class 2604 OID 16663)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3341 (class 2604 OID 16684)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3329 (class 2604 OID 16567)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3333 (class 2604 OID 16614)
-- Name: tariffs id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.tariffs ALTER COLUMN id SET DEFAULT nextval('public.tariffs_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 16578)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3554 (class 0 OID 16697)
-- Dependencies: 234
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.audit_logs (id, action, entity_name, user_id, created_at, details) FROM stdin;
1	CREATE	computers	1	2026-10-27 09:31:01.945552	Тестовая запись №1
2	UPDATE	tariffs	2	2026-10-27 09:01:01.945552	Тестовая запись №2
3	DELETE	products	3	2026-10-27 08:31:01.945552	Тестовая запись №3
4	LOGOUT	orders	4	2026-10-27 08:01:01.945552	Тестовая запись №4
5	REGISTER	game_sessions	5	2026-10-27 07:31:01.945552	Тестовая запись №5
6	LOGIN	users	6	2026-10-27 07:01:01.945552	Тестовая запись №6
7	CREATE	computers	7	2026-10-27 06:31:01.945552	Тестовая запись №7
8	UPDATE	tariffs	8	2026-10-27 06:01:01.945552	Тестовая запись №8
9	DELETE	products	9	2026-10-27 05:31:01.945552	Тестовая запись №9
10	LOGOUT	orders	10	2026-10-27 05:01:01.945552	Тестовая запись №10
11	REGISTER	game_sessions	11	2026-10-27 04:31:01.945552	Тестовая запись №11
12	LOGIN	users	12	2026-10-27 04:01:01.945552	Тестовая запись №12
13	CREATE	computers	13	2026-10-27 03:31:01.945552	Тестовая запись №13
14	UPDATE	tariffs	14	2026-10-27 03:01:01.945552	Тестовая запись №14
15	DELETE	products	15	2026-10-27 02:31:01.945552	Тестовая запись №15
16	LOGOUT	orders	16	2026-10-27 02:01:01.945552	Тестовая запись №16
17	REGISTER	game_sessions	17	2026-10-27 01:31:01.945552	Тестовая запись №17
18	LOGIN	users	18	2026-10-27 01:01:01.945552	Тестовая запись №18
19	CREATE	computers	19	2026-10-27 00:31:01.945552	Тестовая запись №19
20	UPDATE	tariffs	20	2026-10-27 00:01:01.945552	Тестовая запись №20
21	DELETE	products	21	2026-10-26 23:31:01.945552	Тестовая запись №21
22	LOGOUT	orders	22	2026-10-26 23:01:01.945552	Тестовая запись №22
23	REGISTER	game_sessions	23	2026-10-26 22:31:01.945552	Тестовая запись №23
24	LOGIN	users	24	2026-10-26 22:01:01.945552	Тестовая запись №24
25	CREATE	computers	25	2026-10-26 21:31:01.945552	Тестовая запись №25
26	UPDATE	tariffs	26	2026-10-26 21:01:01.945552	Тестовая запись №26
27	DELETE	products	27	2026-10-26 20:31:01.945552	Тестовая запись №27
28	LOGOUT	orders	28	2026-10-26 20:01:01.945552	Тестовая запись №28
29	REGISTER	game_sessions	29	2026-10-26 19:31:01.945552	Тестовая запись №29
30	LOGIN	users	30	2026-10-26 19:01:01.945552	Тестовая запись №30
31	CREATE	computers	31	2026-10-26 18:31:01.945552	Тестовая запись №31
32	UPDATE	tariffs	32	2026-10-26 18:01:01.945552	Тестовая запись №32
33	DELETE	products	33	2026-10-26 17:31:01.945552	Тестовая запись №33
34	LOGOUT	orders	34	2026-10-26 17:01:01.945552	Тестовая запись №34
35	REGISTER	game_sessions	35	2026-10-26 16:31:01.945552	Тестовая запись №35
36	LOGIN	users	36	2026-10-26 16:01:01.945552	Тестовая запись №36
37	CREATE	computers	37	2026-10-26 15:31:01.945552	Тестовая запись №37
38	UPDATE	tariffs	38	2026-10-26 15:01:01.945552	Тестовая запись №38
39	DELETE	products	39	2026-10-26 14:31:01.945552	Тестовая запись №39
40	LOGOUT	orders	40	2026-10-26 14:01:01.945552	Тестовая запись №40
41	REGISTER	game_sessions	41	2026-10-26 13:31:01.945552	Тестовая запись №41
42	LOGIN	users	42	2026-10-26 13:01:01.945552	Тестовая запись №42
43	CREATE	computers	43	2026-10-26 12:31:01.945552	Тестовая запись №43
44	UPDATE	tariffs	44	2026-10-26 12:01:01.945552	Тестовая запись №44
45	DELETE	products	45	2026-10-26 11:31:01.945552	Тестовая запись №45
46	LOGOUT	orders	46	2026-10-26 11:01:01.945552	Тестовая запись №46
47	REGISTER	game_sessions	47	2026-10-26 10:31:01.945552	Тестовая запись №47
48	LOGIN	users	48	2026-10-26 10:01:01.945552	Тестовая запись №48
49	CREATE	computers	49	2026-10-26 09:31:01.945552	Тестовая запись №49
50	UPDATE	tariffs	50	2026-10-26 09:01:01.945552	Тестовая запись №50
51	DELETE	products	51	2026-10-26 08:31:01.945552	Тестовая запись №51
52	LOGOUT	orders	52	2026-10-26 08:01:01.945552	Тестовая запись №52
53	REGISTER	game_sessions	53	2026-10-26 07:31:01.945552	Тестовая запись №53
54	LOGIN	users	54	2026-10-26 07:01:01.945552	Тестовая запись №54
55	CREATE	computers	55	2026-10-26 06:31:01.945552	Тестовая запись №55
56	UPDATE	tariffs	56	2026-10-26 06:01:01.945552	Тестовая запись №56
57	DELETE	products	57	2026-10-26 05:31:01.945552	Тестовая запись №57
58	LOGOUT	orders	58	2026-10-26 05:01:01.945552	Тестовая запись №58
59	REGISTER	game_sessions	59	2026-10-26 04:31:01.945552	Тестовая запись №59
60	LOGIN	users	60	2026-10-26 04:01:01.945552	Тестовая запись №60
61	CREATE	computers	61	2026-10-26 03:31:01.945552	Тестовая запись №61
62	UPDATE	tariffs	62	2026-10-26 03:01:01.945552	Тестовая запись №62
63	DELETE	products	63	2026-10-26 02:31:01.945552	Тестовая запись №63
64	LOGOUT	orders	64	2026-10-26 02:01:01.945552	Тестовая запись №64
65	REGISTER	game_sessions	65	2026-10-26 01:31:01.945552	Тестовая запись №65
66	LOGIN	users	66	2026-10-26 01:01:01.945552	Тестовая запись №66
67	CREATE	computers	67	2026-10-26 00:31:01.945552	Тестовая запись №67
68	UPDATE	tariffs	68	2026-10-26 00:01:01.945552	Тестовая запись №68
69	DELETE	products	69	2026-10-25 23:31:01.945552	Тестовая запись №69
70	LOGOUT	orders	70	2026-10-25 23:01:01.945552	Тестовая запись №70
71	REGISTER	game_sessions	71	2026-10-25 22:31:01.945552	Тестовая запись №71
72	LOGIN	users	72	2026-10-25 22:01:01.945552	Тестовая запись №72
73	CREATE	computers	73	2026-10-25 21:31:01.945552	Тестовая запись №73
74	UPDATE	tariffs	74	2026-10-25 21:01:01.945552	Тестовая запись №74
75	DELETE	products	75	2026-10-25 20:31:01.945552	Тестовая запись №75
76	LOGOUT	orders	76	2026-10-25 20:01:01.945552	Тестовая запись №76
77	REGISTER	game_sessions	77	2026-10-25 19:31:01.945552	Тестовая запись №77
78	LOGIN	users	78	2026-10-25 19:01:01.945552	Тестовая запись №78
79	CREATE	computers	79	2026-10-25 18:31:01.945552	Тестовая запись №79
80	UPDATE	tariffs	80	2026-10-25 18:01:01.945552	Тестовая запись №80
81	DELETE	products	81	2026-10-25 17:31:01.945552	Тестовая запись №81
82	LOGOUT	orders	82	2026-10-25 17:01:01.945552	Тестовая запись №82
83	REGISTER	game_sessions	83	2026-10-25 16:31:01.945552	Тестовая запись №83
84	LOGIN	users	84	2026-10-25 16:01:01.945552	Тестовая запись №84
85	CREATE	computers	85	2026-10-25 15:31:01.945552	Тестовая запись №85
86	UPDATE	tariffs	86	2026-10-25 15:01:01.945552	Тестовая запись №86
87	DELETE	products	87	2026-10-25 14:31:01.945552	Тестовая запись №87
88	LOGOUT	orders	88	2026-10-25 14:01:01.945552	Тестовая запись №88
89	REGISTER	game_sessions	89	2026-10-25 13:31:01.945552	Тестовая запись №89
90	LOGIN	users	90	2026-10-25 13:01:01.945552	Тестовая запись №90
91	CREATE	computers	91	2026-10-25 12:31:01.945552	Тестовая запись №91
92	UPDATE	tariffs	92	2026-10-25 12:01:01.945552	Тестовая запись №92
93	DELETE	products	93	2026-10-25 11:31:01.945552	Тестовая запись №93
94	LOGOUT	orders	94	2026-10-25 11:01:01.945552	Тестовая запись №94
95	REGISTER	game_sessions	95	2026-10-25 10:31:01.945552	Тестовая запись №95
96	LOGIN	users	96	2026-10-25 10:01:01.945552	Тестовая запись №96
97	CREATE	computers	97	2026-10-25 09:31:01.945552	Тестовая запись №97
98	UPDATE	tariffs	98	2026-10-25 09:01:01.945552	Тестовая запись №98
99	DELETE	products	99	2026-10-25 08:31:01.945552	Тестовая запись №99
100	LOGOUT	orders	100	2026-10-25 08:01:01.945552	Тестовая запись №100
\.


--
-- TOC entry 3544 (class 0 OID 16596)
-- Dependencies: 224
-- Data for Name: computers; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.computers (id, name, status, description) FROM stdin;
1	PC-001	t	Игровой компьютер №1
2	PC-002	t	Игровой компьютер №2
3	PC-003	t	Игровой компьютер №3
4	PC-004	t	Игровой компьютер №4
5	PC-005	t	Игровой компьютер №5
6	PC-006	t	Игровой компьютер №6
7	PC-007	t	Игровой компьютер №7
8	PC-008	t	Игровой компьютер №8
9	PC-009	t	Игровой компьютер №9
10	PC-010	f	Игровой компьютер №10
11	PC-011	t	Игровой компьютер №11
12	PC-012	t	Игровой компьютер №12
13	PC-013	t	Игровой компьютер №13
14	PC-014	t	Игровой компьютер №14
15	PC-015	t	Игровой компьютер №15
16	PC-016	t	Игровой компьютер №16
17	PC-017	t	Игровой компьютер №17
18	PC-018	t	Игровой компьютер №18
19	PC-019	t	Игровой компьютер №19
20	PC-020	f	Игровой компьютер №20
21	PC-021	t	Игровой компьютер №21
22	PC-022	t	Игровой компьютер №22
23	PC-023	t	Игровой компьютер №23
24	PC-024	t	Игровой компьютер №24
25	PC-025	t	Игровой компьютер №25
26	PC-026	t	Игровой компьютер №26
27	PC-027	t	Игровой компьютер №27
28	PC-028	t	Игровой компьютер №28
29	PC-029	t	Игровой компьютер №29
30	PC-030	f	Игровой компьютер №30
31	PC-031	t	Игровой компьютер №31
32	PC-032	t	Игровой компьютер №32
33	PC-033	t	Игровой компьютер №33
34	PC-034	t	Игровой компьютер №34
35	PC-035	t	Игровой компьютер №35
36	PC-036	t	Игровой компьютер №36
37	PC-037	t	Игровой компьютер №37
38	PC-038	t	Игровой компьютер №38
39	PC-039	t	Игровой компьютер №39
40	PC-040	f	Игровой компьютер №40
41	PC-041	t	Игровой компьютер №41
42	PC-042	t	Игровой компьютер №42
43	PC-043	t	Игровой компьютер №43
44	PC-044	t	Игровой компьютер №44
45	PC-045	t	Игровой компьютер №45
46	PC-046	t	Игровой компьютер №46
47	PC-047	t	Игровой компьютер №47
48	PC-048	t	Игровой компьютер №48
49	PC-049	t	Игровой компьютер №49
50	PC-050	f	Игровой компьютер №50
51	PC-051	t	Игровой компьютер №51
52	PC-052	t	Игровой компьютер №52
53	PC-053	t	Игровой компьютер №53
54	PC-054	t	Игровой компьютер №54
55	PC-055	t	Игровой компьютер №55
56	PC-056	t	Игровой компьютер №56
57	PC-057	t	Игровой компьютер №57
58	PC-058	t	Игровой компьютер №58
59	PC-059	t	Игровой компьютер №59
60	PC-060	f	Игровой компьютер №60
61	PC-061	t	Игровой компьютер №61
62	PC-062	t	Игровой компьютер №62
63	PC-063	t	Игровой компьютер №63
64	PC-064	t	Игровой компьютер №64
65	PC-065	t	Игровой компьютер №65
66	PC-066	t	Игровой компьютер №66
67	PC-067	t	Игровой компьютер №67
68	PC-068	t	Игровой компьютер №68
69	PC-069	t	Игровой компьютер №69
70	PC-070	f	Игровой компьютер №70
71	PC-071	t	Игровой компьютер №71
72	PC-072	t	Игровой компьютер №72
73	PC-073	t	Игровой компьютер №73
74	PC-074	t	Игровой компьютер №74
75	PC-075	t	Игровой компьютер №75
76	PC-076	t	Игровой компьютер №76
77	PC-077	t	Игровой компьютер №77
78	PC-078	t	Игровой компьютер №78
79	PC-079	t	Игровой компьютер №79
80	PC-080	f	Игровой компьютер №80
81	PC-081	t	Игровой компьютер №81
82	PC-082	t	Игровой компьютер №82
83	PC-083	t	Игровой компьютер №83
84	PC-084	t	Игровой компьютер №84
85	PC-085	t	Игровой компьютер №85
86	PC-086	t	Игровой компьютер №86
87	PC-087	t	Игровой компьютер №87
88	PC-088	t	Игровой компьютер №88
89	PC-089	t	Игровой компьютер №89
90	PC-090	f	Игровой компьютер №90
91	PC-091	t	Игровой компьютер №91
92	PC-092	t	Игровой компьютер №92
93	PC-093	t	Игровой компьютер №93
94	PC-094	t	Игровой компьютер №94
95	PC-095	t	Игровой компьютер №95
96	PC-096	t	Игровой компьютер №96
97	PC-097	t	Игровой компьютер №97
98	PC-098	t	Игровой компьютер №98
99	PC-099	t	Игровой компьютер №99
100	PC-100	f	Игровой компьютер №100
\.


--
-- TOC entry 3548 (class 0 OID 16628)
-- Dependencies: 228
-- Data for Name: game_sessions; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.game_sessions (id, start_time, end_time, cost, user_id, computer_id, tariff_id) FROM stdin;
1	2026-07-19 10:01:01.945552	2026-07-19 12:01:01.945552	40.00	100	1	1
2	2026-08-21 10:01:01.945552	2026-08-21 12:01:01.945552	80.00	67	70	2
3	2026-09-23 10:01:01.945552	2026-09-23 12:01:01.945552	120.00	34	39	3
4	2026-10-26 10:01:01.945552	2026-10-26 12:01:01.945552	160.00	1	8	4
5	2026-08-20 10:01:01.945552	2026-08-20 12:01:01.945552	200.00	68	77	5
6	2026-09-22 10:01:01.945552	2026-09-22 12:01:01.945552	240.00	35	46	6
7	2026-10-25 10:01:01.945552	2026-10-25 12:01:01.945552	280.00	2	15	7
8	2026-08-19 10:01:01.945552	2026-08-19 12:01:01.945552	320.00	69	84	8
9	2026-09-21 10:01:01.945552	2026-09-21 12:01:01.945552	360.00	36	53	9
10	2026-10-24 10:01:01.945552	2026-10-24 12:01:01.945552	400.00	3	22	10
11	2026-08-18 10:01:01.945552	2026-08-18 12:01:01.945552	50.00	70	91	11
12	2026-09-20 10:01:01.945552	2026-09-20 12:01:01.945552	100.00	37	60	12
13	2026-10-23 10:01:01.945552	2026-10-23 12:01:01.945552	150.00	4	29	13
14	2026-08-17 10:01:01.945552	2026-08-17 12:01:01.945552	200.00	71	98	14
15	2026-09-19 10:01:01.945552	2026-09-19 12:01:01.945552	250.00	38	67	15
16	2026-10-22 10:01:01.945552	2026-10-22 12:01:01.945552	300.00	5	36	16
17	2026-08-16 10:01:01.945552	2026-08-16 12:01:01.945552	350.00	72	5	17
18	2026-09-18 10:01:01.945552	2026-09-18 12:01:01.945552	400.00	39	74	18
19	2026-10-21 10:01:01.945552	2026-10-21 12:01:01.945552	450.00	6	43	19
20	2026-08-15 10:01:01.945552	2026-08-15 12:01:01.945552	500.00	73	12	20
21	2026-09-17 10:01:01.945552	2026-09-17 12:01:01.945552	60.00	40	81	21
22	2026-10-20 10:01:01.945552	2026-10-20 12:01:01.945552	120.00	7	50	22
23	2026-08-14 10:01:01.945552	2026-08-14 12:01:01.945552	180.00	74	19	23
24	2026-09-16 10:01:01.945552	2026-09-16 12:01:01.945552	240.00	41	88	24
25	2026-10-19 10:01:01.945552	2026-10-19 12:01:01.945552	300.00	8	57	25
26	2026-08-13 10:01:01.945552	2026-08-13 12:01:01.945552	360.00	75	26	26
27	2026-09-15 10:01:01.945552	2026-09-15 12:01:01.945552	420.00	42	95	27
28	2026-10-18 10:01:01.945552	2026-10-18 12:01:01.945552	480.00	9	64	28
29	2026-08-12 10:01:01.945552	2026-08-12 12:01:01.945552	540.00	76	33	29
30	2026-09-14 10:01:01.945552	2026-09-14 12:01:01.945552	600.00	43	2	30
31	2026-10-17 10:01:01.945552	2026-10-17 12:01:01.945552	70.00	10	71	31
32	2026-08-11 10:01:01.945552	2026-08-11 12:01:01.945552	140.00	77	40	32
33	2026-09-13 10:01:01.945552	2026-09-13 12:01:01.945552	210.00	44	9	33
34	2026-10-16 10:01:01.945552	2026-10-16 12:01:01.945552	280.00	11	78	34
35	2026-08-10 10:01:01.945552	2026-08-10 12:01:01.945552	350.00	78	47	35
36	2026-09-12 10:01:01.945552	2026-09-12 12:01:01.945552	420.00	45	16	36
37	2026-10-15 10:01:01.945552	2026-10-15 12:01:01.945552	490.00	12	85	37
38	2026-08-09 10:01:01.945552	2026-08-09 12:01:01.945552	560.00	79	54	38
39	2026-09-11 10:01:01.945552	2026-09-11 12:01:01.945552	630.00	46	23	39
40	2026-10-14 10:01:01.945552	2026-10-14 12:01:01.945552	700.00	13	92	40
41	2026-08-08 10:01:01.945552	2026-08-08 12:01:01.945552	80.00	80	61	41
42	2026-09-10 10:01:01.945552	2026-09-10 12:01:01.945552	160.00	47	30	42
43	2026-10-13 10:01:01.945552	2026-10-13 12:01:01.945552	240.00	14	99	43
44	2026-08-07 10:01:01.945552	2026-08-07 12:01:01.945552	320.00	81	68	44
45	2026-09-09 10:01:01.945552	2026-09-09 12:01:01.945552	400.00	48	37	45
46	2026-10-12 10:01:01.945552	2026-10-12 12:01:01.945552	480.00	15	6	46
47	2026-08-06 10:01:01.945552	2026-08-06 12:01:01.945552	560.00	82	75	47
48	2026-09-08 10:01:01.945552	2026-09-08 12:01:01.945552	640.00	49	44	48
49	2026-10-11 10:01:01.945552	2026-10-11 12:01:01.945552	720.00	16	13	49
50	2026-08-05 10:01:01.945552	2026-08-05 12:01:01.945552	800.00	83	82	50
51	2026-09-07 10:01:01.945552	2026-09-07 12:01:01.945552	90.00	50	51	51
52	2026-10-10 10:01:01.945552	2026-10-10 12:01:01.945552	180.00	17	20	52
53	2026-08-04 10:01:01.945552	2026-08-04 12:01:01.945552	270.00	84	89	53
54	2026-09-06 10:01:01.945552	2026-09-06 12:01:01.945552	360.00	51	58	54
55	2026-10-09 10:01:01.945552	2026-10-09 12:01:01.945552	450.00	18	27	55
56	2026-08-03 10:01:01.945552	2026-08-03 12:01:01.945552	540.00	85	96	56
57	2026-09-05 10:01:01.945552	2026-09-05 12:01:01.945552	630.00	52	65	57
58	2026-10-08 10:01:01.945552	2026-10-08 12:01:01.945552	720.00	19	34	58
59	2026-08-02 10:01:01.945552	2026-08-02 12:01:01.945552	810.00	86	3	59
60	2026-09-04 10:01:01.945552	2026-09-04 12:01:01.945552	900.00	53	72	60
61	2026-10-07 10:01:01.945552	2026-10-07 12:01:01.945552	100.00	20	41	61
62	2026-08-01 10:01:01.945552	2026-08-01 12:01:01.945552	200.00	87	10	62
63	2026-09-03 10:01:01.945552	2026-09-03 12:01:01.945552	300.00	54	79	63
64	2026-10-06 10:01:01.945552	2026-10-06 12:01:01.945552	400.00	21	48	64
65	2026-07-31 10:01:01.945552	2026-07-31 12:01:01.945552	500.00	88	17	65
66	2026-09-02 10:01:01.945552	2026-09-02 12:01:01.945552	600.00	55	86	66
67	2026-10-05 10:01:01.945552	2026-10-05 12:01:01.945552	700.00	22	55	67
68	2026-07-30 10:01:01.945552	2026-07-30 12:01:01.945552	800.00	89	24	68
69	2026-09-01 10:01:01.945552	2026-09-01 12:01:01.945552	900.00	56	93	69
70	2026-10-04 10:01:01.945552	2026-10-04 12:01:01.945552	1000.00	23	62	70
71	2026-07-29 10:01:01.945552	2026-07-29 12:01:01.945552	110.00	90	31	71
72	2026-08-31 10:01:01.945552	2026-08-31 12:01:01.945552	220.00	57	100	72
73	2026-10-03 10:01:01.945552	2026-10-03 12:01:01.945552	330.00	24	69	73
74	2026-07-28 10:01:01.945552	2026-07-28 12:01:01.945552	440.00	91	38	74
75	2026-08-30 10:01:01.945552	2026-08-30 12:01:01.945552	550.00	58	7	75
76	2026-10-02 10:01:01.945552	2026-10-02 12:01:01.945552	660.00	25	76	76
77	2026-07-27 10:01:01.945552	2026-07-27 12:01:01.945552	770.00	92	45	77
78	2026-08-29 10:01:01.945552	2026-08-29 12:01:01.945552	880.00	59	14	78
79	2026-10-01 10:01:01.945552	2026-10-01 12:01:01.945552	990.00	26	83	79
80	2026-07-26 10:01:01.945552	2026-07-26 12:01:01.945552	1100.00	93	52	80
81	2026-08-28 10:01:01.945552	2026-08-28 12:01:01.945552	120.00	60	21	81
82	2026-09-30 10:01:01.945552	2026-09-30 12:01:01.945552	240.00	27	90	82
83	2026-07-25 10:01:01.945552	2026-07-25 12:01:01.945552	360.00	94	59	83
84	2026-08-27 10:01:01.945552	2026-08-27 12:01:01.945552	480.00	61	28	84
85	2026-09-29 10:01:01.945552	2026-09-29 12:01:01.945552	600.00	28	97	85
86	2026-07-24 10:01:01.945552	2026-07-24 12:01:01.945552	720.00	95	66	86
87	2026-08-26 10:01:01.945552	2026-08-26 12:01:01.945552	840.00	62	35	87
88	2026-09-28 10:01:01.945552	2026-09-28 12:01:01.945552	960.00	29	4	88
89	2026-07-23 10:01:01.945552	2026-07-23 12:01:01.945552	1080.00	96	73	89
90	2026-08-25 10:01:01.945552	2026-08-25 12:01:01.945552	1200.00	63	42	90
91	2026-09-27 10:01:01.945552	2026-09-27 12:01:01.945552	130.00	30	11	91
92	2026-07-22 10:01:01.945552	2026-07-22 12:01:01.945552	260.00	97	80	92
93	2026-08-24 10:01:01.945552	2026-08-24 12:01:01.945552	390.00	64	49	93
94	2026-09-26 10:01:01.945552	2026-09-26 12:01:01.945552	520.00	31	18	94
95	2026-07-21 10:01:01.945552	2026-07-21 12:01:01.945552	650.00	98	87	95
96	2026-08-23 10:01:01.945552	2026-08-23 12:01:01.945552	780.00	65	56	96
97	2026-09-25 10:01:01.945552	2026-09-25 12:01:01.945552	910.00	32	25	97
98	2026-07-20 10:01:01.945552	2026-07-20 12:01:01.945552	1040.00	99	94	98
99	2026-08-22 10:01:01.945552	2026-08-22 12:01:01.945552	1170.00	66	63	99
100	2026-09-24 10:01:01.945552	2026-09-24 12:01:01.945552	1300.00	33	32	100
\.


--
-- TOC entry 3556 (class 0 OID 16716)
-- Dependencies: 236
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.order_items (id, order_id, product_id, quantity, price_at_order) FROM stdin;
1	1	1	3	30.00
2	1	2	1	35.00
3	2	2	2	35.00
4	2	3	3	40.00
5	3	3	1	40.00
6	3	4	2	45.00
7	4	4	3	45.00
8	4	5	1	50.00
9	5	5	2	50.00
10	5	6	3	55.00
11	6	6	1	55.00
12	6	7	2	60.00
13	7	7	3	60.00
14	7	8	1	65.00
15	8	8	2	65.00
16	8	9	3	70.00
17	9	9	1	70.00
18	9	10	2	75.00
19	10	10	3	75.00
20	10	11	1	45.00
21	11	11	2	45.00
22	11	12	3	50.00
23	12	12	1	50.00
24	12	13	2	55.00
25	13	13	3	55.00
26	13	14	1	60.00
27	14	14	2	60.00
28	14	15	3	65.00
29	15	15	1	65.00
30	15	16	2	70.00
31	16	16	3	70.00
32	16	17	1	75.00
33	17	17	2	75.00
34	17	18	3	80.00
35	18	18	1	80.00
36	18	19	2	85.00
37	19	19	3	85.00
38	19	20	1	90.00
39	20	20	2	90.00
40	20	21	3	60.00
41	21	21	1	60.00
42	21	22	2	65.00
43	22	22	3	65.00
44	22	23	1	70.00
45	23	23	2	70.00
46	23	24	3	75.00
47	24	24	1	75.00
48	24	25	2	80.00
49	25	25	3	80.00
50	25	26	1	85.00
51	26	26	2	85.00
52	26	27	3	90.00
53	27	27	1	90.00
54	27	28	2	95.00
55	28	28	3	95.00
56	28	29	1	100.00
57	29	29	2	100.00
58	29	30	3	105.00
59	30	30	1	105.00
60	30	31	2	75.00
61	31	31	3	75.00
62	31	32	1	80.00
63	32	32	2	80.00
64	32	33	3	85.00
65	33	33	1	85.00
66	33	34	2	90.00
67	34	34	3	90.00
68	34	35	1	95.00
69	35	35	2	95.00
70	35	36	3	100.00
71	36	36	1	100.00
72	36	37	2	105.00
73	37	37	3	105.00
74	37	38	1	110.00
75	38	38	2	110.00
76	38	39	3	115.00
77	39	39	1	115.00
78	39	40	2	120.00
79	40	40	3	120.00
80	40	41	1	90.00
81	41	41	2	90.00
82	41	42	3	95.00
83	42	42	1	95.00
84	42	43	2	100.00
85	43	43	3	100.00
86	43	44	1	105.00
87	44	44	2	105.00
88	44	45	3	110.00
89	45	45	1	110.00
90	45	46	2	115.00
91	46	46	3	115.00
92	46	47	1	120.00
93	47	47	2	120.00
94	47	48	3	125.00
95	48	48	1	125.00
96	48	49	2	130.00
97	49	49	3	130.00
98	49	50	1	135.00
99	50	50	2	135.00
100	50	51	3	105.00
101	51	51	1	105.00
102	51	52	2	110.00
103	52	52	3	110.00
104	52	53	1	115.00
105	53	53	2	115.00
106	53	54	3	120.00
107	54	54	1	120.00
108	54	55	2	125.00
109	55	55	3	125.00
110	55	56	1	130.00
111	56	56	2	130.00
112	56	57	3	135.00
113	57	57	1	135.00
114	57	58	2	140.00
115	58	58	3	140.00
116	58	59	1	145.00
117	59	59	2	145.00
118	59	60	3	150.00
119	60	60	1	150.00
120	60	61	2	120.00
121	61	61	3	120.00
122	61	62	1	125.00
123	62	62	2	125.00
124	62	63	3	130.00
125	63	63	1	130.00
126	63	64	2	135.00
127	64	64	3	135.00
128	64	65	1	140.00
129	65	65	2	140.00
130	65	66	3	145.00
131	66	66	1	145.00
132	66	67	2	150.00
133	67	67	3	150.00
134	67	68	1	155.00
135	68	68	2	155.00
136	68	69	3	160.00
137	69	69	1	160.00
138	69	70	2	165.00
139	70	70	3	165.00
140	70	71	1	135.00
141	71	71	2	135.00
142	71	72	3	140.00
143	72	72	1	140.00
144	72	73	2	145.00
145	73	73	3	145.00
146	73	74	1	150.00
147	74	74	2	150.00
148	74	75	3	155.00
149	75	75	1	155.00
150	75	76	2	160.00
151	76	76	3	160.00
152	76	77	1	165.00
153	77	77	2	165.00
154	77	78	3	170.00
155	78	78	1	170.00
156	78	79	2	175.00
157	79	79	3	175.00
158	79	80	1	180.00
159	80	80	2	180.00
160	80	81	3	150.00
161	81	81	1	150.00
162	81	82	2	155.00
163	82	82	3	155.00
164	82	83	1	160.00
165	83	83	2	160.00
166	83	84	3	165.00
167	84	84	1	165.00
168	84	85	2	170.00
169	85	85	3	170.00
170	85	86	1	175.00
171	86	86	2	175.00
172	86	87	3	180.00
173	87	87	1	180.00
174	87	88	2	185.00
175	88	88	3	185.00
176	88	89	1	190.00
177	89	89	2	190.00
178	89	90	3	195.00
179	90	90	1	195.00
180	90	91	2	165.00
181	91	91	3	165.00
182	91	92	1	170.00
183	92	92	2	170.00
184	92	93	3	175.00
185	93	93	1	175.00
186	93	94	2	180.00
187	94	94	3	180.00
188	94	95	1	185.00
189	95	95	2	185.00
190	95	96	3	190.00
191	96	96	1	190.00
192	96	97	2	195.00
193	97	97	3	195.00
194	97	98	1	200.00
195	98	98	2	200.00
196	98	99	3	205.00
197	99	99	1	205.00
198	99	100	2	210.00
199	100	1	3	30.00
200	100	100	3	210.00
\.


--
-- TOC entry 3550 (class 0 OID 16660)
-- Dependencies: 230
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.orders (id, created_at, status, comment, user_id) FROM stdin;
1	2026-10-27 07:01:01.945552	Processing	Тестовый заказ №1	1
2	2026-10-27 04:01:01.945552	Completed	Тестовый заказ №2	2
3	2026-10-27 01:01:01.945552	Cancelled	Тестовый заказ №3	3
4	2026-10-26 22:01:01.945552	New	Тестовый заказ №4	4
5	2026-10-26 19:01:01.945552	Processing	Тестовый заказ №5	5
6	2026-10-26 16:01:01.945552	Completed	Тестовый заказ №6	6
7	2026-10-26 13:01:01.945552	Cancelled	Тестовый заказ №7	7
8	2026-10-26 10:01:01.945552	New	Тестовый заказ №8	8
9	2026-10-26 07:01:01.945552	Processing	Тестовый заказ №9	9
10	2026-10-26 04:01:01.945552	Completed	Тестовый заказ №10	10
11	2026-10-26 01:01:01.945552	Cancelled	Тестовый заказ №11	11
12	2026-10-25 22:01:01.945552	New	Тестовый заказ №12	12
13	2026-10-25 19:01:01.945552	Processing	Тестовый заказ №13	13
14	2026-10-25 16:01:01.945552	Completed	Тестовый заказ №14	14
15	2026-10-25 13:01:01.945552	Cancelled	Тестовый заказ №15	15
16	2026-10-25 10:01:01.945552	New	Тестовый заказ №16	16
17	2026-10-25 07:01:01.945552	Processing	Тестовый заказ №17	17
18	2026-10-25 04:01:01.945552	Completed	Тестовый заказ №18	18
19	2026-10-25 01:01:01.945552	Cancelled	Тестовый заказ №19	19
20	2026-10-24 22:01:01.945552	New	Тестовый заказ №20	20
21	2026-10-24 19:01:01.945552	Processing	Тестовый заказ №21	21
22	2026-10-24 16:01:01.945552	Completed	Тестовый заказ №22	22
23	2026-10-24 13:01:01.945552	Cancelled	Тестовый заказ №23	23
24	2026-10-24 10:01:01.945552	New	Тестовый заказ №24	24
25	2026-10-24 07:01:01.945552	Processing	Тестовый заказ №25	25
26	2026-10-24 04:01:01.945552	Completed	Тестовый заказ №26	26
27	2026-10-24 01:01:01.945552	Cancelled	Тестовый заказ №27	27
28	2026-10-23 22:01:01.945552	New	Тестовый заказ №28	28
29	2026-10-23 19:01:01.945552	Processing	Тестовый заказ №29	29
30	2026-10-23 16:01:01.945552	Completed	Тестовый заказ №30	30
31	2026-10-23 13:01:01.945552	Cancelled	Тестовый заказ №31	31
32	2026-10-23 10:01:01.945552	New	Тестовый заказ №32	32
33	2026-10-23 07:01:01.945552	Processing	Тестовый заказ №33	33
34	2026-10-23 04:01:01.945552	Completed	Тестовый заказ №34	34
35	2026-10-23 01:01:01.945552	Cancelled	Тестовый заказ №35	35
36	2026-10-22 22:01:01.945552	New	Тестовый заказ №36	36
37	2026-10-22 19:01:01.945552	Processing	Тестовый заказ №37	37
38	2026-10-22 16:01:01.945552	Completed	Тестовый заказ №38	38
39	2026-10-22 13:01:01.945552	Cancelled	Тестовый заказ №39	39
40	2026-10-22 10:01:01.945552	New	Тестовый заказ №40	40
41	2026-10-22 07:01:01.945552	Processing	Тестовый заказ №41	41
42	2026-10-22 04:01:01.945552	Completed	Тестовый заказ №42	42
43	2026-10-22 01:01:01.945552	Cancelled	Тестовый заказ №43	43
44	2026-10-21 22:01:01.945552	New	Тестовый заказ №44	44
45	2026-10-21 19:01:01.945552	Processing	Тестовый заказ №45	45
46	2026-10-21 16:01:01.945552	Completed	Тестовый заказ №46	46
47	2026-10-21 13:01:01.945552	Cancelled	Тестовый заказ №47	47
48	2026-10-21 10:01:01.945552	New	Тестовый заказ №48	48
49	2026-10-21 07:01:01.945552	Processing	Тестовый заказ №49	49
50	2026-10-21 04:01:01.945552	Completed	Тестовый заказ №50	50
51	2026-10-21 01:01:01.945552	Cancelled	Тестовый заказ №51	51
52	2026-10-20 22:01:01.945552	New	Тестовый заказ №52	52
53	2026-10-20 19:01:01.945552	Processing	Тестовый заказ №53	53
54	2026-10-20 16:01:01.945552	Completed	Тестовый заказ №54	54
55	2026-10-20 13:01:01.945552	Cancelled	Тестовый заказ №55	55
56	2026-10-20 10:01:01.945552	New	Тестовый заказ №56	56
57	2026-10-20 07:01:01.945552	Processing	Тестовый заказ №57	57
58	2026-10-20 04:01:01.945552	Completed	Тестовый заказ №58	58
59	2026-10-20 01:01:01.945552	Cancelled	Тестовый заказ №59	59
60	2026-10-19 22:01:01.945552	New	Тестовый заказ №60	60
61	2026-10-19 19:01:01.945552	Processing	Тестовый заказ №61	61
62	2026-10-19 16:01:01.945552	Completed	Тестовый заказ №62	62
63	2026-10-19 13:01:01.945552	Cancelled	Тестовый заказ №63	63
64	2026-10-19 10:01:01.945552	New	Тестовый заказ №64	64
65	2026-10-19 07:01:01.945552	Processing	Тестовый заказ №65	65
66	2026-10-19 04:01:01.945552	Completed	Тестовый заказ №66	66
67	2026-10-19 01:01:01.945552	Cancelled	Тестовый заказ №67	67
68	2026-10-18 22:01:01.945552	New	Тестовый заказ №68	68
69	2026-10-18 19:01:01.945552	Processing	Тестовый заказ №69	69
70	2026-10-18 16:01:01.945552	Completed	Тестовый заказ №70	70
71	2026-10-18 13:01:01.945552	Cancelled	Тестовый заказ №71	71
72	2026-10-18 10:01:01.945552	New	Тестовый заказ №72	72
73	2026-10-18 07:01:01.945552	Processing	Тестовый заказ №73	73
74	2026-10-18 04:01:01.945552	Completed	Тестовый заказ №74	74
75	2026-10-18 01:01:01.945552	Cancelled	Тестовый заказ №75	75
76	2026-10-17 22:01:01.945552	New	Тестовый заказ №76	76
77	2026-10-17 19:01:01.945552	Processing	Тестовый заказ №77	77
78	2026-10-17 16:01:01.945552	Completed	Тестовый заказ №78	78
79	2026-10-17 13:01:01.945552	Cancelled	Тестовый заказ №79	79
80	2026-10-17 10:01:01.945552	New	Тестовый заказ №80	80
81	2026-10-17 07:01:01.945552	Processing	Тестовый заказ №81	81
82	2026-10-17 04:01:01.945552	Completed	Тестовый заказ №82	82
83	2026-10-17 01:01:01.945552	Cancelled	Тестовый заказ №83	83
84	2026-10-16 22:01:01.945552	New	Тестовый заказ №84	84
85	2026-10-16 19:01:01.945552	Processing	Тестовый заказ №85	85
86	2026-10-16 16:01:01.945552	Completed	Тестовый заказ №86	86
87	2026-10-16 13:01:01.945552	Cancelled	Тестовый заказ №87	87
88	2026-10-16 10:01:01.945552	New	Тестовый заказ №88	88
89	2026-10-16 07:01:01.945552	Processing	Тестовый заказ №89	89
90	2026-10-16 04:01:01.945552	Completed	Тестовый заказ №90	90
91	2026-10-16 01:01:01.945552	Cancelled	Тестовый заказ №91	91
92	2026-10-15 22:01:01.945552	New	Тестовый заказ №92	92
93	2026-10-15 19:01:01.945552	Processing	Тестовый заказ №93	93
94	2026-10-15 16:01:01.945552	Completed	Тестовый заказ №94	94
95	2026-10-15 13:01:01.945552	Cancelled	Тестовый заказ №95	95
96	2026-10-15 10:01:01.945552	New	Тестовый заказ №96	96
97	2026-10-15 07:01:01.945552	Processing	Тестовый заказ №97	97
98	2026-10-15 04:01:01.945552	Completed	Тестовый заказ №98	98
99	2026-10-15 01:01:01.945552	Cancelled	Тестовый заказ №99	99
100	2026-10-14 22:01:01.945552	New	Тестовый заказ №100	100
\.


--
-- TOC entry 3552 (class 0 OID 16681)
-- Dependencies: 232
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.products (id, name, category, price, quantity_in_stock, is_available) FROM stdin;
1	Вода классик	Напитки	30.00	0	f
2	Вода мини	Напитки	35.00	11	t
3	Вода макси	Напитки	40.00	22	t
4	Вода люкс	Напитки	45.00	33	t
5	Вода фирменный	Напитки	50.00	44	t
6	Вода острый	Напитки	55.00	55	t
7	Вода сладкий	Напитки	60.00	6	t
8	Вода лёгкий	Напитки	65.00	17	t
9	Вода двойной	Напитки	70.00	28	t
10	Вода домашний	Напитки	75.00	39	t
11	Кола классик	Напитки	45.00	37	t
12	Кола мини	Напитки	50.00	48	t
13	Кола макси	Напитки	55.00	59	t
14	Кола люкс	Напитки	60.00	10	t
15	Кола фирменный	Напитки	65.00	21	t
16	Кола острый	Напитки	70.00	32	t
17	Кола сладкий	Напитки	75.00	43	t
18	Кола лёгкий	Напитки	80.00	54	t
19	Кола двойной	Напитки	85.00	5	t
20	Кола домашний	Напитки	90.00	16	t
21	Энергетик классик	Напитки	60.00	14	t
22	Энергетик мини	Напитки	65.00	25	t
23	Энергетик макси	Напитки	70.00	36	t
24	Энергетик люкс	Напитки	75.00	47	t
25	Энергетик фирменный	Напитки	80.00	58	t
26	Энергетик острый	Напитки	85.00	9	t
27	Энергетик сладкий	Напитки	90.00	20	t
28	Энергетик лёгкий	Напитки	95.00	31	t
29	Энергетик двойной	Напитки	100.00	42	t
30	Энергетик домашний	Напитки	105.00	53	t
31	Чипсы классик	Снеки	75.00	51	t
32	Чипсы мини	Снеки	80.00	2	t
33	Чипсы макси	Снеки	85.00	13	t
34	Чипсы люкс	Снеки	90.00	24	t
35	Чипсы фирменный	Снеки	95.00	35	t
36	Чипсы острый	Снеки	100.00	46	t
37	Чипсы сладкий	Снеки	105.00	57	t
38	Чипсы лёгкий	Снеки	110.00	8	t
39	Чипсы двойной	Снеки	115.00	19	t
40	Чипсы домашний	Снеки	120.00	30	t
41	Шоколад классик	Сладости	90.00	28	t
42	Шоколад мини	Сладости	95.00	39	t
43	Шоколад макси	Сладости	100.00	50	t
44	Шоколад люкс	Сладости	105.00	1	t
45	Шоколад фирменный	Сладости	110.00	12	t
46	Шоколад острый	Сладости	115.00	23	t
47	Шоколад сладкий	Сладости	120.00	34	t
48	Шоколад лёгкий	Сладости	125.00	45	t
49	Шоколад двойной	Сладости	130.00	56	t
50	Шоколад домашний	Сладости	135.00	7	t
51	Кофе классик	Напитки	105.00	5	t
52	Кофе мини	Напитки	110.00	16	t
53	Кофе макси	Напитки	115.00	27	t
54	Кофе люкс	Напитки	120.00	38	t
55	Кофе фирменный	Напитки	125.00	49	t
56	Кофе острый	Напитки	130.00	0	f
57	Кофе сладкий	Напитки	135.00	11	t
58	Кофе лёгкий	Напитки	140.00	22	t
59	Кофе двойной	Напитки	145.00	33	t
60	Кофе домашний	Напитки	150.00	44	t
61	Печенье классик	Сладости	120.00	42	t
62	Печенье мини	Сладости	125.00	53	t
63	Печенье макси	Сладости	130.00	4	t
64	Печенье люкс	Сладости	135.00	15	t
65	Печенье фирменный	Сладости	140.00	26	t
66	Печенье острый	Сладости	145.00	37	t
67	Печенье сладкий	Сладости	150.00	48	t
68	Печенье лёгкий	Сладости	155.00	59	t
69	Печенье двойной	Сладости	160.00	10	t
70	Печенье домашний	Сладости	165.00	21	t
71	Сок классик	Напитки	135.00	19	t
72	Сок мини	Напитки	140.00	30	t
73	Сок макси	Напитки	145.00	41	t
74	Сок люкс	Напитки	150.00	52	t
75	Сок фирменный	Напитки	155.00	3	t
76	Сок острый	Напитки	160.00	14	t
77	Сок сладкий	Напитки	165.00	25	t
78	Сок лёгкий	Напитки	170.00	36	t
79	Сок двойной	Напитки	175.00	47	t
80	Сок домашний	Напитки	180.00	58	t
81	Сэндвич классик	Еда	150.00	56	t
82	Сэндвич мини	Еда	155.00	7	t
83	Сэндвич макси	Еда	160.00	18	t
84	Сэндвич люкс	Еда	165.00	29	t
85	Сэндвич фирменный	Еда	170.00	40	t
86	Сэндвич острый	Еда	175.00	51	t
87	Сэндвич сладкий	Еда	180.00	2	t
88	Сэндвич лёгкий	Еда	185.00	13	t
89	Сэндвич двойной	Еда	190.00	24	t
90	Сэндвич домашний	Еда	195.00	35	t
91	Чай классик	Напитки	165.00	33	t
92	Чай мини	Напитки	170.00	44	t
93	Чай макси	Напитки	175.00	55	t
94	Чай люкс	Напитки	180.00	6	t
95	Чай фирменный	Напитки	185.00	17	t
96	Чай острый	Напитки	190.00	28	t
97	Чай сладкий	Напитки	195.00	39	t
98	Чай лёгкий	Напитки	200.00	50	t
99	Чай двойной	Напитки	205.00	1	t
100	Чай домашний	Напитки	210.00	12	t
\.


--
-- TOC entry 3540 (class 0 OID 16564)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.roles (id, name, description) FROM stdin;
1	Administrator	Full system access
2	Manager	Manage products, orders and game sessions
3	User	Basic system access
\.


--
-- TOC entry 3546 (class 0 OID 16611)
-- Dependencies: 226
-- Data for Name: tariffs; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.tariffs (id, name, price, is_active, description) FROM stdin;
1	Стандарт 1 ч	40.00	t	Тариф на 1 ч
2	Стандарт 2 ч	80.00	t	Тариф на 2 ч
3	Стандарт 3 ч	120.00	t	Тариф на 3 ч
4	Стандарт 4 ч	160.00	t	Тариф на 4 ч
5	Стандарт 5 ч	200.00	t	Тариф на 5 ч
6	Стандарт 6 ч	240.00	t	Тариф на 6 ч
7	Стандарт 7 ч	280.00	t	Тариф на 7 ч
8	Стандарт 8 ч	320.00	t	Тариф на 8 ч
9	Стандарт 9 ч	360.00	t	Тариф на 9 ч
10	Стандарт 10 ч	400.00	f	Тариф на 10 ч
11	VIP 1 ч	50.00	t	Тариф на 1 ч
12	VIP 2 ч	100.00	t	Тариф на 2 ч
13	VIP 3 ч	150.00	t	Тариф на 3 ч
14	VIP 4 ч	200.00	t	Тариф на 4 ч
15	VIP 5 ч	250.00	t	Тариф на 5 ч
16	VIP 6 ч	300.00	t	Тариф на 6 ч
17	VIP 7 ч	350.00	t	Тариф на 7 ч
18	VIP 8 ч	400.00	t	Тариф на 8 ч
19	VIP 9 ч	450.00	f	Тариф на 9 ч
20	VIP 10 ч	500.00	t	Тариф на 10 ч
21	Ночной 1 ч	60.00	t	Тариф на 1 ч
22	Ночной 2 ч	120.00	t	Тариф на 2 ч
23	Ночной 3 ч	180.00	t	Тариф на 3 ч
24	Ночной 4 ч	240.00	t	Тариф на 4 ч
25	Ночной 5 ч	300.00	t	Тариф на 5 ч
26	Ночной 6 ч	360.00	t	Тариф на 6 ч
27	Ночной 7 ч	420.00	t	Тариф на 7 ч
28	Ночной 8 ч	480.00	f	Тариф на 8 ч
29	Ночной 9 ч	540.00	t	Тариф на 9 ч
30	Ночной 10 ч	600.00	t	Тариф на 10 ч
31	Студенческий 1 ч	70.00	t	Тариф на 1 ч
32	Студенческий 2 ч	140.00	t	Тариф на 2 ч
33	Студенческий 3 ч	210.00	t	Тариф на 3 ч
34	Студенческий 4 ч	280.00	t	Тариф на 4 ч
35	Студенческий 5 ч	350.00	t	Тариф на 5 ч
36	Студенческий 6 ч	420.00	t	Тариф на 6 ч
37	Студенческий 7 ч	490.00	f	Тариф на 7 ч
38	Студенческий 8 ч	560.00	t	Тариф на 8 ч
39	Студенческий 9 ч	630.00	t	Тариф на 9 ч
40	Студенческий 10 ч	700.00	t	Тариф на 10 ч
41	Утренний 1 ч	80.00	t	Тариф на 1 ч
42	Утренний 2 ч	160.00	t	Тариф на 2 ч
43	Утренний 3 ч	240.00	t	Тариф на 3 ч
44	Утренний 4 ч	320.00	t	Тариф на 4 ч
45	Утренний 5 ч	400.00	t	Тариф на 5 ч
46	Утренний 6 ч	480.00	f	Тариф на 6 ч
47	Утренний 7 ч	560.00	t	Тариф на 7 ч
48	Утренний 8 ч	640.00	t	Тариф на 8 ч
49	Утренний 9 ч	720.00	t	Тариф на 9 ч
50	Утренний 10 ч	800.00	t	Тариф на 10 ч
51	Дневной 1 ч	90.00	t	Тариф на 1 ч
52	Дневной 2 ч	180.00	t	Тариф на 2 ч
53	Дневной 3 ч	270.00	t	Тариф на 3 ч
54	Дневной 4 ч	360.00	t	Тариф на 4 ч
55	Дневной 5 ч	450.00	f	Тариф на 5 ч
56	Дневной 6 ч	540.00	t	Тариф на 6 ч
57	Дневной 7 ч	630.00	t	Тариф на 7 ч
58	Дневной 8 ч	720.00	t	Тариф на 8 ч
59	Дневной 9 ч	810.00	t	Тариф на 9 ч
60	Дневной 10 ч	900.00	t	Тариф на 10 ч
61	Вечерний 1 ч	100.00	t	Тариф на 1 ч
62	Вечерний 2 ч	200.00	t	Тариф на 2 ч
63	Вечерний 3 ч	300.00	t	Тариф на 3 ч
64	Вечерний 4 ч	400.00	f	Тариф на 4 ч
65	Вечерний 5 ч	500.00	t	Тариф на 5 ч
66	Вечерний 6 ч	600.00	t	Тариф на 6 ч
67	Вечерний 7 ч	700.00	t	Тариф на 7 ч
68	Вечерний 8 ч	800.00	t	Тариф на 8 ч
69	Вечерний 9 ч	900.00	t	Тариф на 9 ч
70	Вечерний 10 ч	1000.00	t	Тариф на 10 ч
71	Выходной 1 ч	110.00	t	Тариф на 1 ч
72	Выходной 2 ч	220.00	t	Тариф на 2 ч
73	Выходной 3 ч	330.00	f	Тариф на 3 ч
74	Выходной 4 ч	440.00	t	Тариф на 4 ч
75	Выходной 5 ч	550.00	t	Тариф на 5 ч
76	Выходной 6 ч	660.00	t	Тариф на 6 ч
77	Выходной 7 ч	770.00	t	Тариф на 7 ч
78	Выходной 8 ч	880.00	t	Тариф на 8 ч
79	Выходной 9 ч	990.00	t	Тариф на 9 ч
80	Выходной 10 ч	1100.00	t	Тариф на 10 ч
81	Турнирный 1 ч	120.00	t	Тариф на 1 ч
82	Турнирный 2 ч	240.00	f	Тариф на 2 ч
83	Турнирный 3 ч	360.00	t	Тариф на 3 ч
84	Турнирный 4 ч	480.00	t	Тариф на 4 ч
85	Турнирный 5 ч	600.00	t	Тариф на 5 ч
86	Турнирный 6 ч	720.00	t	Тариф на 6 ч
87	Турнирный 7 ч	840.00	t	Тариф на 7 ч
88	Турнирный 8 ч	960.00	t	Тариф на 8 ч
89	Турнирный 9 ч	1080.00	t	Тариф на 9 ч
90	Турнирный 10 ч	1200.00	t	Тариф на 10 ч
91	Командный 1 ч	130.00	f	Тариф на 1 ч
92	Командный 2 ч	260.00	t	Тариф на 2 ч
93	Командный 3 ч	390.00	t	Тариф на 3 ч
94	Командный 4 ч	520.00	t	Тариф на 4 ч
95	Командный 5 ч	650.00	t	Тариф на 5 ч
96	Командный 6 ч	780.00	t	Тариф на 6 ч
97	Командный 7 ч	910.00	t	Тариф на 7 ч
98	Командный 8 ч	1040.00	t	Тариф на 8 ч
99	Командный 9 ч	1170.00	t	Тариф на 9 ч
100	Командный 10 ч	1300.00	t	Тариф на 10 ч
\.


--
-- TOC entry 3542 (class 0 OID 16575)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: user1
--

COPY public.users (id, login, password_hash, full_name, email, role_id) FROM stdin;
1	user1	test_hash_1	Иванов Алексей	user1@cyberclub.test	1
2	user2	test_hash_2	Иванов Дмитрий	user2@cyberclub.test	1
3	user3	test_hash_3	Иванов Максим	user3@cyberclub.test	1
4	user4	test_hash_4	Иванов Иван	user4@cyberclub.test	2
5	user5	test_hash_5	Иванов Артём	user5@cyberclub.test	2
6	user6	test_hash_6	Иванов Никита	user6@cyberclub.test	2
7	user7	test_hash_7	Иванов Егор	user7@cyberclub.test	2
8	user8	test_hash_8	Иванов Кирилл	user8@cyberclub.test	2
9	user9	test_hash_9	Иванов Андрей	user9@cyberclub.test	2
10	user10	test_hash_10	Иванов Сергей	user10@cyberclub.test	2
11	user11	test_hash_11	Петров Алексей	user11@cyberclub.test	2
12	user12	test_hash_12	Петров Дмитрий	user12@cyberclub.test	2
13	user13	test_hash_13	Петров Максим	user13@cyberclub.test	2
14	user14	test_hash_14	Петров Иван	user14@cyberclub.test	3
15	user15	test_hash_15	Петров Артём	user15@cyberclub.test	3
16	user16	test_hash_16	Петров Никита	user16@cyberclub.test	3
17	user17	test_hash_17	Петров Егор	user17@cyberclub.test	3
18	user18	test_hash_18	Петров Кирилл	user18@cyberclub.test	3
19	user19	test_hash_19	Петров Андрей	user19@cyberclub.test	3
20	user20	test_hash_20	Петров Сергей	user20@cyberclub.test	3
21	user21	test_hash_21	Сидоров Алексей	user21@cyberclub.test	3
22	user22	test_hash_22	Сидоров Дмитрий	user22@cyberclub.test	3
23	user23	test_hash_23	Сидоров Максим	user23@cyberclub.test	3
24	user24	test_hash_24	Сидоров Иван	user24@cyberclub.test	3
25	user25	test_hash_25	Сидоров Артём	user25@cyberclub.test	3
26	user26	test_hash_26	Сидоров Никита	user26@cyberclub.test	3
27	user27	test_hash_27	Сидоров Егор	user27@cyberclub.test	3
28	user28	test_hash_28	Сидоров Кирилл	user28@cyberclub.test	3
29	user29	test_hash_29	Сидоров Андрей	user29@cyberclub.test	3
30	user30	test_hash_30	Сидоров Сергей	user30@cyberclub.test	3
31	user31	test_hash_31	Смирнов Алексей	user31@cyberclub.test	3
32	user32	test_hash_32	Смирнов Дмитрий	user32@cyberclub.test	3
33	user33	test_hash_33	Смирнов Максим	user33@cyberclub.test	3
34	user34	test_hash_34	Смирнов Иван	user34@cyberclub.test	3
35	user35	test_hash_35	Смирнов Артём	user35@cyberclub.test	3
36	user36	test_hash_36	Смирнов Никита	user36@cyberclub.test	3
37	user37	test_hash_37	Смирнов Егор	user37@cyberclub.test	3
38	user38	test_hash_38	Смирнов Кирилл	user38@cyberclub.test	3
39	user39	test_hash_39	Смирнов Андрей	user39@cyberclub.test	3
40	user40	test_hash_40	Смирнов Сергей	user40@cyberclub.test	3
41	user41	test_hash_41	Кузнецов Алексей	user41@cyberclub.test	3
42	user42	test_hash_42	Кузнецов Дмитрий	user42@cyberclub.test	3
43	user43	test_hash_43	Кузнецов Максим	user43@cyberclub.test	3
44	user44	test_hash_44	Кузнецов Иван	user44@cyberclub.test	3
45	user45	test_hash_45	Кузнецов Артём	user45@cyberclub.test	3
46	user46	test_hash_46	Кузнецов Никита	user46@cyberclub.test	3
47	user47	test_hash_47	Кузнецов Егор	user47@cyberclub.test	3
48	user48	test_hash_48	Кузнецов Кирилл	user48@cyberclub.test	3
49	user49	test_hash_49	Кузнецов Андрей	user49@cyberclub.test	3
50	user50	test_hash_50	Кузнецов Сергей	user50@cyberclub.test	3
51	user51	test_hash_51	Попов Алексей	user51@cyberclub.test	3
52	user52	test_hash_52	Попов Дмитрий	user52@cyberclub.test	3
53	user53	test_hash_53	Попов Максим	user53@cyberclub.test	3
54	user54	test_hash_54	Попов Иван	user54@cyberclub.test	3
55	user55	test_hash_55	Попов Артём	user55@cyberclub.test	3
56	user56	test_hash_56	Попов Никита	user56@cyberclub.test	3
57	user57	test_hash_57	Попов Егор	user57@cyberclub.test	3
58	user58	test_hash_58	Попов Кирилл	user58@cyberclub.test	3
59	user59	test_hash_59	Попов Андрей	user59@cyberclub.test	3
60	user60	test_hash_60	Попов Сергей	user60@cyberclub.test	3
61	user61	test_hash_61	Волков Алексей	user61@cyberclub.test	3
62	user62	test_hash_62	Волков Дмитрий	user62@cyberclub.test	3
63	user63	test_hash_63	Волков Максим	user63@cyberclub.test	3
64	user64	test_hash_64	Волков Иван	user64@cyberclub.test	3
65	user65	test_hash_65	Волков Артём	user65@cyberclub.test	3
66	user66	test_hash_66	Волков Никита	user66@cyberclub.test	3
67	user67	test_hash_67	Волков Егор	user67@cyberclub.test	3
68	user68	test_hash_68	Волков Кирилл	user68@cyberclub.test	3
69	user69	test_hash_69	Волков Андрей	user69@cyberclub.test	3
70	user70	test_hash_70	Волков Сергей	user70@cyberclub.test	3
71	user71	test_hash_71	Соколов Алексей	user71@cyberclub.test	3
72	user72	test_hash_72	Соколов Дмитрий	user72@cyberclub.test	3
73	user73	test_hash_73	Соколов Максим	user73@cyberclub.test	3
74	user74	test_hash_74	Соколов Иван	user74@cyberclub.test	3
75	user75	test_hash_75	Соколов Артём	user75@cyberclub.test	3
76	user76	test_hash_76	Соколов Никита	user76@cyberclub.test	3
77	user77	test_hash_77	Соколов Егор	user77@cyberclub.test	3
78	user78	test_hash_78	Соколов Кирилл	user78@cyberclub.test	3
79	user79	test_hash_79	Соколов Андрей	user79@cyberclub.test	3
80	user80	test_hash_80	Соколов Сергей	user80@cyberclub.test	3
81	user81	test_hash_81	Лебедев Алексей	user81@cyberclub.test	3
82	user82	test_hash_82	Лебедев Дмитрий	user82@cyberclub.test	3
83	user83	test_hash_83	Лебедев Максим	user83@cyberclub.test	3
84	user84	test_hash_84	Лебедев Иван	user84@cyberclub.test	3
85	user85	test_hash_85	Лебедев Артём	user85@cyberclub.test	3
86	user86	test_hash_86	Лебедев Никита	user86@cyberclub.test	3
87	user87	test_hash_87	Лебедев Егор	user87@cyberclub.test	3
88	user88	test_hash_88	Лебедев Кирилл	user88@cyberclub.test	3
89	user89	test_hash_89	Лебедев Андрей	user89@cyberclub.test	3
90	user90	test_hash_90	Лебедев Сергей	user90@cyberclub.test	3
91	user91	test_hash_91	Козлов Алексей	user91@cyberclub.test	3
92	user92	test_hash_92	Козлов Дмитрий	user92@cyberclub.test	3
93	user93	test_hash_93	Козлов Максим	user93@cyberclub.test	3
94	user94	test_hash_94	Козлов Иван	user94@cyberclub.test	3
95	user95	test_hash_95	Козлов Артём	user95@cyberclub.test	3
96	user96	test_hash_96	Козлов Никита	user96@cyberclub.test	3
97	user97	test_hash_97	Козлов Егор	user97@cyberclub.test	3
98	user98	test_hash_98	Козлов Кирилл	user98@cyberclub.test	3
99	user99	test_hash_99	Козлов Андрей	user99@cyberclub.test	3
100	user100	test_hash_100	Козлов Сергей	user100@cyberclub.test	3
\.


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 233
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 100, true);


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 223
-- Name: computers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.computers_id_seq', 100, true);


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 227
-- Name: game_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.game_sessions_id_seq', 100, true);


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.order_items_id_seq', 200, true);


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 229
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.orders_id_seq', 100, true);


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 231
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.products_id_seq', 100, true);


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 225
-- Name: tariffs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.tariffs_id_seq', 100, true);


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user1
--

SELECT pg_catalog.setval('public.users_id_seq', 100, true);


--
-- TOC entry 3379 (class 2606 OID 16709)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3365 (class 2606 OID 16609)
-- Name: computers computers_name_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT computers_name_key UNIQUE (name);


--
-- TOC entry 3367 (class 2606 OID 16607)
-- Name: computers computers_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT computers_pkey PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 16643)
-- Name: game_sessions game_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3381 (class 2606 OID 16730)
-- Name: order_items order_items_order_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_product_id_key UNIQUE (order_id, product_id);


--
-- TOC entry 3383 (class 2606 OID 16728)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3375 (class 2606 OID 16674)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 16695)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3357 (class 2606 OID 16573)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 3359 (class 2606 OID 16571)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3369 (class 2606 OID 16626)
-- Name: tariffs tariffs_name_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.tariffs
    ADD CONSTRAINT tariffs_name_key UNIQUE (name);


--
-- TOC entry 3371 (class 2606 OID 16624)
-- Name: tariffs tariffs_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.tariffs
    ADD CONSTRAINT tariffs_pkey PRIMARY KEY (id);


--
-- TOC entry 3361 (class 2606 OID 16589)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 3363 (class 2606 OID 16587)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3389 (class 2606 OID 16710)
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3385 (class 2606 OID 16649)
-- Name: game_sessions game_sessions_computer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_computer_id_fkey FOREIGN KEY (computer_id) REFERENCES public.computers(id);


--
-- TOC entry 3386 (class 2606 OID 16654)
-- Name: game_sessions game_sessions_tariff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES public.tariffs(id);


--
-- TOC entry 3387 (class 2606 OID 16644)
-- Name: game_sessions game_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3390 (class 2606 OID 16731)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 3391 (class 2606 OID 16736)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3388 (class 2606 OID 16675)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3384 (class 2606 OID 16590)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-10-27 15:06:13

--
-- PostgreSQL database dump complete
--

\unrestrict PMhh11FKeUrz7YherSrhAM7gWTUlg1ZkJClGU55WegDkdiRawyGjHhikcpe8r4i

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict p81DgmrdvcSUueIi4cbQJlsTiYz55iGBHkOCDMPUWo1s0DKgO2AhWV9owjNURLg

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.4

-- Started on 2026-10-27 15:06:13

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

-- Completed on 2026-10-27 15:06:13

--
-- PostgreSQL database dump complete
--

\unrestrict p81DgmrdvcSUueIi4cbQJlsTiYz55iGBHkOCDMPUWo1s0DKgO2AhWV9owjNURLg

-- Completed on 2026-10-27 15:06:13

--
-- PostgreSQL database cluster dump complete
--

