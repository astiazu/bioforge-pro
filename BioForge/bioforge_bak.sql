--
-- PostgreSQL database dump
--

\restrict RYac1PySInZcP15xc2WbHsgnhbZY7g5ytz4BSaxYBVu28NH2bgJ73y3kRNQOOdA

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-10-28 10:58:43

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 251 (class 1259 OID 16807)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO bioforge_user;

--
-- TOC entry 238 (class 1259 OID 16590)
-- Name: appointments; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    availability_id integer,
    patient_id integer,
    status character varying(20),
    created_at timestamp without time zone
);


ALTER TABLE public.appointments OWNER TO bioforge_user;

--
-- TOC entry 237 (class 1259 OID 16589)
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 237
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- TOC entry 234 (class 1259 OID 16537)
-- Name: assistants; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.assistants (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(120),
    whatsapp character varying(20),
    is_active boolean,
    created_at timestamp without time zone,
    clinic_id integer,
    doctor_id integer NOT NULL,
    telegram_id character varying(50),
    type character varying(20) NOT NULL,
    user_id integer,
    created_by_user_id integer,
    CONSTRAINT valid_assistant_type CHECK (((type)::text = ANY ((ARRAY['common'::character varying, 'general'::character varying])::text[])))
);


ALTER TABLE public.assistants OWNER TO bioforge_user;

--
-- TOC entry 233 (class 1259 OID 16536)
-- Name: assistants_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.assistants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assistants_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 233
-- Name: assistants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.assistants_id_seq OWNED BY public.assistants.id;


--
-- TOC entry 230 (class 1259 OID 16508)
-- Name: availability; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.availability (
    id integer NOT NULL,
    clinic_id integer,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    is_booked boolean
);


ALTER TABLE public.availability OWNER TO bioforge_user;

--
-- TOC entry 229 (class 1259 OID 16507)
-- Name: availability_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.availability_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 229
-- Name: availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.availability_id_seq OWNED BY public.availability.id;


--
-- TOC entry 226 (class 1259 OID 16481)
-- Name: clinic; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.clinic (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(200) NOT NULL,
    phone character varying(20),
    specialty character varying(50),
    doctor_id integer,
    is_active boolean
);


ALTER TABLE public.clinic OWNER TO bioforge_user;

--
-- TOC entry 225 (class 1259 OID 16480)
-- Name: clinic_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.clinic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clinic_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 225
-- Name: clinic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.clinic_id_seq OWNED BY public.clinic.id;


--
-- TOC entry 236 (class 1259 OID 16571)
-- Name: company_invites; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.company_invites (
    id integer NOT NULL,
    doctor_id integer NOT NULL,
    invite_code character varying(20) NOT NULL,
    email character varying(150) NOT NULL,
    name character varying(100) NOT NULL,
    clinic_id integer,
    whatsapp character varying(20),
    assistant_type character varying(20) NOT NULL,
    is_used boolean,
    created_at timestamp without time zone,
    expires_at timestamp without time zone NOT NULL,
    used_at timestamp without time zone
);


ALTER TABLE public.company_invites OWNER TO bioforge_user;

--
-- TOC entry 235 (class 1259 OID 16570)
-- Name: company_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.company_invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_invites_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 235
-- Name: company_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.company_invites_id_seq OWNED BY public.company_invites.id;


--
-- TOC entry 248 (class 1259 OID 16719)
-- Name: event; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.event (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    description text,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone NOT NULL,
    location character varying(150),
    clinic_id integer,
    is_public boolean NOT NULL,
    max_attendees integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    doctor_id integer NOT NULL,
    created_by integer NOT NULL,
    updated_by integer,
    image_url character varying(300),
    publication_id integer
);


ALTER TABLE public.event OWNER TO bioforge_user;

--
-- TOC entry 247 (class 1259 OID 16718)
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 247
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- TOC entry 228 (class 1259 OID 16493)
-- Name: invitation_logs; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.invitation_logs (
    id integer NOT NULL,
    invite_code character varying(20) NOT NULL,
    email character varying(150) NOT NULL,
    method character varying(20),
    success boolean,
    error_message text,
    sent_at timestamp without time zone,
    doctor_id integer NOT NULL,
    assistant_name character varying(100)
);


ALTER TABLE public.invitation_logs OWNER TO bioforge_user;

--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: invitation_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.invitation_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invitation_logs_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 227
-- Name: invitation_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.invitation_logs_id_seq OWNED BY public.invitation_logs.id;


--
-- TOC entry 242 (class 1259 OID 16637)
-- Name: medical_records; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.medical_records (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    appointment_id integer,
    title character varying(100) NOT NULL,
    notes text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.medical_records OWNER TO bioforge_user;

--
-- TOC entry 241 (class 1259 OID 16636)
-- Name: medical_records_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.medical_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medical_records_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 241
-- Name: medical_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.medical_records_id_seq OWNED BY public.medical_records.id;


--
-- TOC entry 222 (class 1259 OID 16442)
-- Name: notes; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    status character varying(20) NOT NULL,
    user_id integer NOT NULL,
    patient_id integer,
    created_at timestamp without time zone,
    approved_by integer,
    approved_at timestamp without time zone,
    updated_at timestamp without time zone NOT NULL,
    featured_image character varying(200),
    view_count integer
);


ALTER TABLE public.notes OWNER TO bioforge_user;

--
-- TOC entry 221 (class 1259 OID 16441)
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notes_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 221
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- TOC entry 246 (class 1259 OID 16695)
-- Name: product; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.product (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_service boolean,
    stock integer,
    is_visible boolean,
    hide_if_out_of_stock boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    doctor_id integer NOT NULL,
    created_by integer NOT NULL,
    updated_by integer,
    base_price numeric(10,2) DEFAULT 0.00 NOT NULL,
    tax_rate numeric(5,2) DEFAULT 0.00,
    has_tax_included boolean DEFAULT false,
    is_on_promotion boolean DEFAULT false,
    promotion_discount numeric(5,2) DEFAULT 0.00,
    promotion_end_date timestamp without time zone,
    image_urls json DEFAULT '[]'::json,
    category_id integer
);


ALTER TABLE public.product OWNER TO bioforge_user;

--
-- TOC entry 250 (class 1259 OID 16748)
-- Name: product_category; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.product_category (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    parent_id integer,
    is_active boolean,
    doctor_id integer NOT NULL
);


ALTER TABLE public.product_category OWNER TO bioforge_user;

--
-- TOC entry 249 (class 1259 OID 16747)
-- Name: product_category_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_category_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 249
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


--
-- TOC entry 245 (class 1259 OID 16694)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 245
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- TOC entry 224 (class 1259 OID 16466)
-- Name: publications; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.publications (
    id integer NOT NULL,
    slug character varying(200),
    type character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    excerpt character varying(500),
    is_published boolean NOT NULL,
    user_id integer NOT NULL,
    tags character varying(200),
    read_time integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone,
    image_url character varying(300),
    view_count integer
);


ALTER TABLE public.publications OWNER TO bioforge_user;

--
-- TOC entry 223 (class 1259 OID 16465)
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publications_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 223
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.publications_id_seq OWNED BY public.publications.id;


--
-- TOC entry 232 (class 1259 OID 16520)
-- Name: schedules; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.schedules (
    id integer NOT NULL,
    doctor_id integer NOT NULL,
    clinic_id integer NOT NULL,
    day_of_week integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    is_active boolean
);


ALTER TABLE public.schedules OWNER TO bioforge_user;

--
-- TOC entry 231 (class 1259 OID 16519)
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedules_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 231
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- TOC entry 218 (class 1259 OID 16413)
-- Name: subscribers; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.subscribers (
    id integer NOT NULL,
    email character varying(150) NOT NULL,
    subscribed_at timestamp without time zone
);


ALTER TABLE public.subscribers OWNER TO bioforge_user;

--
-- TOC entry 217 (class 1259 OID 16412)
-- Name: subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.subscribers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscribers_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 217
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.subscribers_id_seq OWNED BY public.subscribers.id;


--
-- TOC entry 240 (class 1259 OID 16607)
-- Name: tasks; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    due_date date,
    status character varying(20) NOT NULL,
    doctor_id integer NOT NULL,
    assistant_id integer NOT NULL,
    created_by integer,
    clinic_id integer,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.tasks OWNER TO bioforge_user;

--
-- TOC entry 239 (class 1259 OID 16606)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 239
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- TOC entry 216 (class 1259 OID 16402)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.user_roles OWNER TO bioforge_user;

--
-- TOC entry 215 (class 1259 OID 16401)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 215
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- TOC entry 220 (class 1259 OID 16422)
-- Name: users; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash character varying(200) NOT NULL,
    is_admin boolean NOT NULL,
    is_professional boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    url_slug character varying(100),
    professional_category character varying(50),
    specialty character varying(100),
    bio text,
    years_experience integer,
    profile_photo character varying(200),
    license_number character varying(100),
    services text,
    skills text,
    role_name character varying(50),
    role_id integer,
    store_enabled boolean DEFAULT true NOT NULL,
    email_verified boolean
);


ALTER TABLE public.users OWNER TO bioforge_user;

--
-- TOC entry 219 (class 1259 OID 16421)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 244 (class 1259 OID 16667)
-- Name: visits; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.visits (
    id integer NOT NULL,
    ip_address character varying(45),
    user_agent text,
    path character varying(255) NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.visits OWNER TO bioforge_user;

--
-- TOC entry 243 (class 1259 OID 16666)
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: bioforge_user
--

CREATE SEQUENCE public.visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visits_id_seq OWNER TO bioforge_user;

--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 243
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.visits_id_seq OWNED BY public.visits.id;


--
-- TOC entry 4737 (class 2604 OID 16593)
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- TOC entry 4735 (class 2604 OID 16540)
-- Name: assistants id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants ALTER COLUMN id SET DEFAULT nextval('public.assistants_id_seq'::regclass);


--
-- TOC entry 4733 (class 2604 OID 16511)
-- Name: availability id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability ALTER COLUMN id SET DEFAULT nextval('public.availability_id_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 16484)
-- Name: clinic id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic ALTER COLUMN id SET DEFAULT nextval('public.clinic_id_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 16574)
-- Name: company_invites id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites ALTER COLUMN id SET DEFAULT nextval('public.company_invites_id_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 16722)
-- Name: event id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- TOC entry 4732 (class 2604 OID 16496)
-- Name: invitation_logs id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs ALTER COLUMN id SET DEFAULT nextval('public.invitation_logs_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 16640)
-- Name: medical_records id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records ALTER COLUMN id SET DEFAULT nextval('public.medical_records_id_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 16445)
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 16698)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 16751)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 4730 (class 2604 OID 16469)
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications ALTER COLUMN id SET DEFAULT nextval('public.publications_id_seq'::regclass);


--
-- TOC entry 4734 (class 2604 OID 16523)
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- TOC entry 4726 (class 2604 OID 16416)
-- Name: subscribers id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers ALTER COLUMN id SET DEFAULT nextval('public.subscribers_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 16610)
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 16405)
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 16425)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 16670)
-- Name: visits id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.visits ALTER COLUMN id SET DEFAULT nextval('public.visits_id_seq'::regclass);


--
-- TOC entry 5025 (class 0 OID 16807)
-- Dependencies: 251
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.alembic_version (version_num) FROM stdin;
b502a6c406f7
\.


--
-- TOC entry 5012 (class 0 OID 16590)
-- Dependencies: 238
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.appointments (id, availability_id, patient_id, status, created_at) FROM stdin;
\.


--
-- TOC entry 5008 (class 0 OID 16537)
-- Dependencies: 234
-- Data for Name: assistants; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.assistants (id, name, email, whatsapp, is_active, created_at, clinic_id, doctor_id, telegram_id, type, user_id, created_by_user_id) FROM stdin;
7	Stefy	stefyocen99@gmail.com	+5492344441364	t	2025-09-26 23:02:29.583424	\N	6	\N	general	13	\N
17	Gustavo Pendex	gusty5873@gmail.com	+5491169660766	t	2025-09-26 23:02:29.595635	3	6	\N	common	\N	\N
21	Jose Herrero	\N	+5491150248868	t	2025-09-26 23:02:29.672787	3	6	\N	common	\N	\N
22	Alberto Plomero	\N	+5491165526968	t	2025-09-26 23:02:29.682551	3	6	\N	common	\N	\N
20	Alfredo Pintor	\N	+5491168804039	t	2025-09-26 23:02:29.687436	3	6	\N	common	\N	\N
26	Claudio CD3 - Arquitectura	claudio@datos.com	+5491176376566	t	2025-09-30 12:39:02.852439	\N	6	\N	general	17	\N
27	Maxi	maxigdalessandro@gmail.com	+5491130014357	t	2025-09-30 17:02:09.071245	1	2	\N	common	\N	\N
28	Agustin - Administración -	agustin@cd3.com	\N	t	2025-10-01 15:08:36.096059	\N	6	\N	general	19	\N
29	Chjavo	chavo@gmail.com	+5491169983838	t	2025-10-01 17:53:46.953745	3	6	\N	general	20	\N
11	William Albañil	\N	+5491130396026	t	2025-09-26 23:02:29.496511	3	6	\N	common	\N	\N
13	Juan electricista	\N	+5491134990533	t	2025-09-26 23:02:29.501397	3	6	\N	common	\N	\N
5	juan cirio	\N	+5491161329953	t	2025-09-26 23:02:29.572684	3	6	\N	common	\N	\N
16	Emiliano	emiliano@gmail.com	+5491162919904	t	2025-09-26 23:02:29.588797	\N	2	\N	common	\N	\N
18	Junior	jarajunior5@gmail.com	+5491125460229	t	2025-09-26 23:02:29.609307	3	6	\N	common	\N	\N
19	Stefy	stefyocen99@gmail.com	\N	t	2025-09-26 23:02:29.633719	5	2	\N	common	\N	\N
2	Rodolfo	rodolfo@gmail.com	+541176376566	t	2025-09-26 23:02:28.869541	1	2	6210586580	common	\N	\N
3	Mabel	macalu1966@gmail.com	+5491160524863	t	2025-09-26 23:02:28.884186	\N	2	6210586580	common	\N	\N
4	Luca	elvasquito16@gmail.com	+5493544570009	t	2025-09-26 23:02:28.890045	\N	4	\N	common	\N	\N
14	Benitez	\N	5491165964909	t	2025-09-26 23:02:28.987709	3	6	\N	common	\N	\N
15	Candela	\N	+5491160152137	t	2025-09-26 23:02:29.003339	\N	6	\N	common	\N	\N
8	Agustin	\N	+5491127567346	t	2025-09-26 23:02:29.009194	3	6	\N	common	\N	\N
10	Vicente Pintor	\N	+5491134989650	t	2025-09-26 23:02:29.11076	3	6	\N	common	\N	\N
12	Alejandro electricista	\N	+5491170611762	t	2025-09-26 23:02:29.390065	3	6	\N	common	\N	\N
23	PRIMITIVO BOLITA	\N	+5491140641851	t	2025-09-26 23:02:29.696225	3	6	\N	common	\N	\N
24	Martin yerno Benitez	\N	+5491123549775	t	2025-09-26 23:02:29.849549	3	6	\N	common	\N	\N
25	David	\N	+5491172233722	t	2025-09-26 23:02:29.858338	3	6	\N	common	\N	\N
6	PERRO	astiazu@gmail.com	+5493544404054	t	2025-09-26 23:02:28.974037	\N	6	\N	general	2	\N
30	Jose Luis (Tío)	noexistemail@correo.com	+543544404054	t	2025-10-07 13:02:16.30457	\N	4	\N	general	39	\N
\.


--
-- TOC entry 5004 (class 0 OID 16508)
-- Dependencies: 230
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.availability (id, clinic_id, date, "time", is_booked) FROM stdin;
\.


--
-- TOC entry 5000 (class 0 OID 16481)
-- Dependencies: 226
-- Data for Name: clinic; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.clinic (id, name, address, phone, specialty, doctor_id, is_active) FROM stdin;
2	Corralon El Vasquito - 9 de Julio -	9 de julio - Mina Clavero	+5493544470679	Construcción y Venta de Materiales	4	t
3	Gina 1	Quesada 4380	\N	\N	6	t
1	Datos Consultora	Villa Urquiza	+5493544404054	Tecnología - Automatización - Big Data	2	t
4	GINA 1	QUESADA 4380	+5492344441364	ARQUITECTURA	13	t
5	Palomar	Virasoro 586	+5491160524863	Tecnología	2	t
6	Ocampo - Quilmes -	Ocampo 398 - Quilmes	+5491154571803	Arquitectura, Tecnología, Desarrollos, Deptos.	6	t
7	Thomas	Alvarez Thomas 1672	+5491154571803	Arquitectura, Tecnología, Desarrollos, Deptos.	6	t
8	Nono	Ruta Provincial 15 km 83,5, Córdoba, Argentina	+5493544541118	Sistemas de Seguridad	38	t
9	Ban Zai - Show - MC	Poeta lugones 1443, Mina Clavero, Córdoba	+5493512026579	Entretenimiento - Música - Dj - Noche - Eventos -	3	t
10	BanZai Show Mina Clavero	Poeta Lugones 2235, Mina Clavero, Córdoba, Argentina	+5493512026579	Música - Eventos - Fiestas - Entretenimiento	40	t
\.


--
-- TOC entry 5010 (class 0 OID 16571)
-- Dependencies: 236
-- Data for Name: company_invites; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.company_invites (id, doctor_id, invite_code, email, name, clinic_id, whatsapp, assistant_type, is_used, created_at, expires_at, used_at) FROM stdin;
\.


--
-- TOC entry 5022 (class 0 OID 16719)
-- Dependencies: 248
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.event (id, title, description, start_datetime, end_datetime, location, clinic_id, is_public, max_attendees, created_at, updated_at, doctor_id, created_by, updated_by, image_url, publication_id) FROM stdin;
2	Fiesta - Carlos flores y su Conjunto -	la Banda de Carlos Flores en BanZai Show MC	2025-10-15 23:00:00	2025-10-16 05:00:00	Poeta lugones 2235, Mina Clavero, Córdoba	9	t	198	2025-10-09 22:43:33.169101	2025-10-10 15:17:22.993792	3	3	\N	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1760049812/waodfcqlbdkvcsbl6qh0.jpg	\N
3	Tributo a Soda Stereo	Dos conciertos homenajean a Soda Stereo en Mina Clavero: una versión orquestal gratuita y una experiencia íntima Fechas, entradas y todo lo que tenés que saber....	2025-10-20 22:00:00	2025-10-21 05:00:00	Poeta lugones 2235, Mina Clavero, Córdoba	9	t	400	2025-10-10 15:21:59.589239	2025-10-10 15:21:59.589239	3	3	\N	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1760109718/k81hdgfod1safmpeb4jb.png	\N
4	primer evento	detalles	2025-10-18 23:00:00	2025-10-19 05:00:00	Poeta lugones 2235, Mina Clavero, Córdoba	10	t	200	2025-10-12 18:09:41.54626	2025-10-12 18:09:41.54626	40	40	\N	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1760292580/furydkc7i3bnvr2qhnlj.jpg	\N
\.


--
-- TOC entry 5002 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: invitation_logs; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.invitation_logs (id, invite_code, email, method, success, error_message, sent_at, doctor_id, assistant_name) FROM stdin;
\.


--
-- TOC entry 5016 (class 0 OID 16637)
-- Dependencies: 242
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.medical_records (id, patient_id, doctor_id, appointment_id, title, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4996 (class 0 OID 16442)
-- Dependencies: 222
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.notes (id, title, content, status, user_id, patient_id, created_at, approved_by, approved_at, updated_at, featured_image, view_count) FROM stdin;
1	Estamos de vuelta !!	🌸🎶 Vuelve BanZaiShow – MC 🎶🌸\nDespués del parate de marzo, este sábado 20 de septiembre reabrimos el escenario con todo: llega la banda de Carlos Flores para ponerle música, energía y fiesta al arranque de la primavera. 🌺🔥\n\nEs el regreso que estabas esperando: un show que mezcla la potencia de la banda en vivo, el espíritu de BanZai y la promesa de una temporada de verano que arranca a pura música y diversión.\n\n📍 Lugar: Poeta Lugones 1443 - a metros de la calle San Martín - Mina Clavero -\n🕘 Hora: 23\n🎟️ Entrada: llamanos al +54 351 202 6579 \n\n👉 Vení con tus amigos, preparate para cantar, bailar y ser parte de este renacer. BanZaiShow – MC vuelve y lo hace a lo grande.	published	3	\N	2025-09-15 16:09:11.829155	1	2025-09-15 16:10:10.673182	2025-09-18 14:10:06.384342	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757952551/notes/o7uwlprajx126yanemz7.jpg	33
3	El precio de construcción por metro cuadrado llegó a $ 1.865.348,15 en agosto de 2025.	🔴 Según la Asociación de Pymes de la Construcción de la Provincia de Buenos Aires (Apymeco), el precio de construcción por metro cuadrado llegó en agosto de 2025 a $ 1.865.348,15, lo que representa una variación mensual del 0,66% respecto a julio. Si agosto protagonizó aumentos, fueron menores a los protagonizados en meses anteriores.\n\nSegún la entidad, el crecimiento interanual fue del 25,99 por ciento, mientras en lo que va del año el aumento fue del 16,62 por ciento. La variación mensual de  materiales para la construcción fue del 0,76%, mientras que la mano de obra lo hizo en un 0,67 por ciento.	private	4	\N	2025-09-16 14:44:54.835442	\N	\N	2025-09-16 14:44:54.835457	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758033894/notes/elcgqsvc8tww0m1sjwa3.png	0
4	👏👏 Ingresaron carretillas y hormigoneras!	Visita nuestro local en 9 de julio 961!!👏👏\n\n- Detalles del producto\n\n- Precio\n\n- Forma de pago	private	4	\N	2025-09-16 19:36:41.095883	\N	\N	2025-09-16 19:36:41.095891	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758051400/notes/nbv0wekyn2aiuvkrigdf.jpg	0
5	📌 ¿Cómo preparar tu obra para recibir el hormigón?	Antes de la llegada del mixer, hay detalles clave que aseguran una descarga rápida, segura y sin contratiempos:\n\n🔸 Acceso libre para el camión y/o bomba\n🔸 Personal listo para distribuir y nivelar\n🔸 Encofrado limpio y húmedo\n🔸 Herramientas listas\n\n✅ Una obra preparada ahorra tiempo, evita pérdidas y garantiza mejores resultados.\n\n📲 ¿Tenés dudas sobre tu próxima obra? Escribinos y te asesoramos.	private	4	\N	2025-09-16 20:12:47.252536	\N	\N	2025-09-16 20:12:47.252544	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758053566/notes/wz7fp3ouibrkcifw30oo.jpg	0
2	Microsoft Power BI - CURSO GRATUITO	Microsoft Power BI - CURSO GRATUITO\n\nCertificado Profesional en Visualización de Datos de Microsoft\n\nFormulario de inscripción: https://forms.gle/7z1jPqa7JA89ojJB9\n\nDesarrollá habilidades en análisis y visualización de datos.\nAdquirí competencias laborales para una carrera en visualización de datos, una de las áreas más demandadas.\nNo se requiere experiencia previa ni título universitario para comenzar.\n\n🌟 Primer encuentro gratuito online\n\n📅 Sábado 20 de septiembre\n🕖 10 a 13 hs (Argentina, GMT-3)\n💻 Modalidad online (Zoom) – el enlace te lo mandamos por mail el día de la clase\n🎓 Organiza: Centro de Graduados de Ingeniería – UBA\n\n¡ATENCIÓN SUPER REGALO!\n\nTodos los que completen el formulario, se conecten al zoom y den el presente recibirán en forma totalmente gratis el acceso al curso:\n\nMicrosoft - Power BI\nFundamentos de Visualización de Datos\nEste curso forma parte del Certificado Profesional en Visualización de Datos con Power BI de Microsoft\nImpartido en español (doblaje con IA)\n\nPodrás obtener un certificado oficial de Microsoft a tu nombre \n\nCertificado Profesional – Serie de 5 cursos\n\nFormulario de inscripción: https://forms.gle/7z1jPqa7JA89ojJB9	published	2	\N	2025-09-15 16:44:09.767201	1	2025-09-15 16:45:10.177284	2025-09-17 19:13:49.508365	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757954649/notes/wol6rptl1i2bgy0zge6a.jpg	29
6	Para aumentar la oferta de dólares, no habrá retenciones a los granos hasta el 31 de octubre	- El gobierno nacional dispuso que no le cobrará retenciones a los granos hasta el 31 de octubre o hasta que se concreten declaraciones juradas de exportación por USD 7 mil millones, lo que ocurra primero. La medida busca generar una mayor oferta de dólares luego de varios días de suba que llevaron la cotización oficial a $1.515 y le provocaron pérdidas de más de USD 1.100 millones en las reservas del Banco Central.\n- “La vieja política busca generar incertidumbre para boicotear el programa de gobierno. Al hacerlo castigan a los argentinos: no lo vamos a permitir. Por eso, y con el objetivo de generar mayor oferta de dólares durante este período, hasta el 31 de octubre habrá retenciones cero para todos los granos. Fin”, anticipó el funcionario.\n- Voceros del Ministerio de Economía detallaron que la medida alcanza a la soja, el maíz, el trigo, la cebada, el sorgo y el girasol.\n- El anuncio oficial tomó por sorpresa al presidente de la Sociedad Rural Argentina (SRA), Nicolás Pino, quien se enteró del cambio regulatorio mientras daba una entrevista a Radio Mitre.	published	2	\N	2025-09-22 16:47:03.403187	2	2025-09-22 16:47:40.12416	2025-09-24 13:44:04.252544	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758559622/notes/hbmfqnsmtogiutumo8fo.png	1
7	no debería crear notas o si ?	contenido de una nota de un usuario de pruebas o uno que haya ingresado como usuario de visita	pending	16	\N	2025-09-27 20:34:40.262693	\N	\N	2025-09-27 20:34:58.174986	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759005279/notes/eop2yjn67aostlcdrsv7.jpg	0
8	🧾 El costo oculto del equilibrio fiscal	🧾 El costo oculto del equilibrio fiscal (versión explicada para todos)\r\n\r\nEl Gobierno presentó el Presupuesto 2026 diciendo que busca “ordenar las cuentas” y lograr equilibrio fiscal —es decir, que el Estado no gaste más de lo que recauda.\r\nPero el economista y abogado tributario Marcos Sequeira señala que, detrás de ese discurso, hay decisiones que no son tan coherentes y que podrían terminar beneficiando a algunos sectores a costa de todos los demás.\r\n\r\n⚖️ 1. Equilibrio fiscal… ¿a cualquier precio?\r\n\r\nEl presupuesto promete disciplina y control del gasto, pero al mismo tiempo mantiene y amplía privilegios fiscales: exenciones, beneficios y regímenes especiales para ciertos sectores o empresas.\r\nEso significa que unos pagan menos impuestos, y entonces el resto (personas comunes, pymes, autónomos) terminan pagando más para compensar.\r\n→ En resumen: se busca el equilibrio, pero con un sistema cada vez más desigual.\r\n\r\n📚 2. Exenciones y “subsidios disfrazados”\r\n\r\nEl texto menciona un ejemplo concreto:\r\n\r\nLibros digitales: bien, se los exonera de IVA (justo y razonable).\r\n\r\nMedios periodísticos: se les permite recuperar el IVA como si exportaran, aunque no exportan.\r\nEso equivale a un subsidio fiscal encubierto para los medios, algo que rompe el principio básico de equidad:\r\n\r\n“Si dos sectores están en condiciones similares, deberían pagar los mismos impuestos”.\r\n\r\nY abre una puerta peligrosa: otros rubros podrían exigir el mismo trato, debilitando aún más la recaudación del Estado.\r\n\r\n⛽ 3. Impuesto a los combustibles: un parche caro\r\n\r\nEl gobierno deja de cobrar ciertos impuestos a los combustibles para evitar subas o faltantes de energía.\r\nPero eso no resuelve el problema de fondo (la falta de inversión y planificación energética).\r\nEn la práctica, el Estado subsidia indirectamente a los que consumen energía importada y paga el costo con fondos públicos.\r\nPeor aún: las empresas pueden acostumbrarse a que el Estado siempre las salve, lo que desalienta inversiones privadas a largo plazo.\r\n\r\n💰 4. Cupos fiscales: el Estado eligiendo ganadores\r\n\r\nEl presupuesto asigna enormes cupos fiscales (beneficios impositivos con límite de gasto) a ciertos sectores:\r\n\r\n$310.000 millones a la Economía del Conocimiento,\r\n\r\npero solo $2.000 millones a Biotecnología.\r\n\r\nEsa diferencia muestra una política de “picking winners”: el Estado elige quién gana y quién no.\r\nEsto genera competencia desleal y corrupción potencial, porque muchas empresas terminan invirtiendo tiempo y dinero para conseguir beneficios políticos, no para innovar o producir.\r\n\r\n🔌 5. Subsidios al gas: otra distorsión\r\n\r\nEl subsidio al gas patagónico se financia cobrando más caro el gas al resto del país.\r\nEso es un subsidio cruzado obligatorio: todos pagamos para que una zona tenga tarifas más bajas.\r\nEl problema es que se hace sin transparencia: el dinero no pasa por el presupuesto nacional, sino que se maneja “por afuera”, sin control del Congreso.\r\nEsto rompe el principio de unidad presupuestaria y distorsiona los precios.\r\n\r\n🏭 6. Transferencias “libres de impuestos”: el guiño a las privatizaciones\r\n\r\nEl presupuesto también declara que la transferencia de activos energéticos (centrales termoeléctricas) sea “libre de impuestos”.\r\nEso significa que el Estado condona impuestos a empresas energéticas públicas o privadas bajo el argumento de “reorganización”.\r\nEn la práctica, es un beneficio fiscal anticipado que podría preparar el terreno para una futura privatización o ingreso de capital privado, sin que esas operaciones paguen Ganancias.\r\n\r\n🧩 7. Conclusión: equilibrio sí, pero sin trampas\r\n\r\nEl análisis de Sequeira concluye que el presupuesto:\r\n\r\nBusca mostrar equilibrio en los números,\r\n\r\npero sostiene un sistema tributario injusto y complejo,\r\n\r\ncon excepciones, cupos, subsidios y favores sectoriales.\r\n\r\nEl riesgo: lograr un equilibrio “de corto plazo” pero a costa de la integridad y la equidad del sistema tributario.\r\nEn vez de simplificar y hacer justo el sistema, se lo vuelve más opaco, desigual y dependiente de la política.\r\n\r\n🧠 En palabras simples:\r\n\r\n“El Presupuesto 2026 no es tanto un plan de orden fiscal como una telaraña de beneficios cruzados. Se equilibra el Estado, pero se desequilibra la justicia tributaria.”	private	2	\N	2025-10-20 14:34:24.90333	\N	\N	2025-10-20 14:34:24.90333	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1760970862/notes/hzqatjdeexu7e3whv1hx.png	0
\.


--
-- TOC entry 5020 (class 0 OID 16695)
-- Dependencies: 246
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.product (id, name, description, is_service, stock, is_visible, hide_if_out_of_stock, created_at, updated_at, doctor_id, created_by, updated_by, base_price, tax_rate, has_tax_included, is_on_promotion, promotion_discount, promotion_end_date, image_urls, category_id) FROM stdin;
6	Hormigonera	Hormigonera	f	6	t	f	2025-10-06 17:20:07.833839	2025-10-06 18:21:02.697077	4	4	4	350000.00	0.00	t	t	10.00	2025-10-25 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759774843/bioforge/productos/4/producto_6_1.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759774861/bioforge/productos/4/producto_6_2.png"]	5
2	Kit Alarma Central x 2	Kit x 2 Cámaras - alarma central -\r\n- detalle 1\r\n- detalle 2\r\n- detalle 3	f	2	t	f	2025-10-03 16:25:14.567509	2025-10-03 16:52:51.430171	38	38	38	113000.00	0.00	t	t	9.99	2025-10-05 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759508833/bioforge/productos/38/producto_2_1.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759510334/bioforge/productos/38/producto_2_2.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759510357/bioforge/productos/38/producto_2_3.png"]	1
1	Kit Alarma Central x 4	Alarma para casa de familia con central telefónica	f	10	t	f	2025-10-02 23:30:11.770899	2025-10-03 16:54:03.065805	38	38	38	150000.00	0.00	t	t	10.00	2025-10-04 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759504701/bioforge/productos/38/producto_1_1.png"]	1
3	Cámaras de Seguridas kit x 3	Kit de tres Cámaras de Seguridad\r\n\r\nDetalle 1\r\nDetalle 2\r\nDetalle 3	f	4	t	f	2025-10-03 16:57:55.83431	2025-10-03 16:58:55.10515	38	38	38	150000.00	0.00	t	t	15.00	2025-10-10 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759510700/bioforge/productos/38/producto_3_1.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759510717/bioforge/productos/38/producto_3_2.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759510734/bioforge/productos/38/producto_3_3.png"]	1
4	Servicio de Seguridad	Servicio de seguridad Privada las 24 hs\r\n\r\n- Detalle 1\r\n- Detalle 2\r\n- Detalle 3	t	0	t	f	2025-10-03 20:53:18.383461	2025-10-03 20:53:50.588118	38	38	38	100000.00	0.00	t	f	0.00	\N	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759524829/bioforge/productos/38/producto_4_1.png"]	1
7	Heladera	Heladera con Frezzer	f	2	t	f	2025-10-06 18:23:46.16554	2025-10-06 18:25:36.070996	4	4	4	1200000.00	21.00	f	f	0.00	\N	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759775135/bioforge/productos/4/producto_7_1.png"]	2
5	telefono	telefono	f	1	t	f	2025-10-06 16:41:28.387609	2025-10-06 18:59:11.224475	4	4	4	1.00	0.00	t	t	10.00	2025-10-10 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759774901/bioforge/productos/4/producto_5_1.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759774926/bioforge/productos/4/producto_5_2.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759774945/bioforge/productos/4/producto_5_3.png"]	3
8	Smart TV 42'	Oferta DIA DE LA MADRE\r\nTelevisor smart TV 42 '\r\ndetalle 1\r\ndetalle 2\r\ndetalle 3	f	3	t	t	2025-10-07 14:44:52.265959	2025-10-07 14:45:24.279046	4	4	4	100000.00	0.00	t	t	15.00	2025-10-20 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759848323/bioforge/productos/4/producto_8_1.jpg"]	3
9	i Motion Highline	iMotion Full - PAI014\r\n\r\nPantalla/Llave electrónica 220V, maneja hasta cuatro salidas/teclas de 150w cada una. Instalación en caja de luz igual que cualquier tecla + neutro.\r\n\r\nPermite programación de colores, formato de presentación.\r\n\r\nPermite dialogar entre distintas teclas, programar funciones de encendido o apagado, bajo determinadas circunstancias.\r\n\r\nTodas las salidas dimerizables con memoria de límites.\r\n\r\nSlide mode: Puede ser configurado para encender la pantalla cuando está apagada, o incluso se puede configurar el encendido de la luz ambiente al pasar la mano por enfrente de la tecla.\r\n\r\nInteracción de las teclas de distintos ambientes, permitiendo un control centralizado de toda la iluminación, persianas, cortinas eléctricas o blackout.\r\n\r\nSimulación de presencia avanzada (permite simular movimiento interno).\r\n\r\nNotificaciones a dispositivos móviles ante eventos programados (Timbre, encendido de luces, disparo de un sensor externo, etc).\r\n\r\nControl de las luces de la casa desde el celular o desde internet.\r\n\r\nAcepta comando de voz a través de Google Assistant, escalable a otros sistemas.	f	5	t	t	2025-10-24 13:25:16.996837	2025-10-24 15:44:21.549451	2	2	2	169990.00	0.00	t	t	10.00	2025-10-31 00:00:00	["https://res.cloudinary.com/dxpxsv7ui/image/upload/v1761312351/bioforge/productos/2/producto_9_1.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1761320390/bioforge/productos/2/producto_9_2.png", "https://res.cloudinary.com/dxpxsv7ui/image/upload/v1761320660/bioforge/productos/2/producto_9_3.png"]	6
\.


--
-- TOC entry 5024 (class 0 OID 16748)
-- Dependencies: 250
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.product_category (id, name, description, parent_id, is_active, doctor_id) FROM stdin;
1	Sistemas de Seguridad		\N	t	38
2	Electrodomesticos	electrodomesticos	\N	t	4
3	Tecnología	Tecno - Telefonos - compu	\N	t	4
4	Accesorios	Accesorios	\N	t	4
5	Herramientas	Herramientas	\N	t	4
6	Soluciones IoT	“Control de tu hogar/negocio desde cualquier lugar. Domótica IOT argentina hecha para gente real.”	\N	t	2
\.


--
-- TOC entry 4998 (class 0 OID 16466)
-- Dependencies: 224
-- Data for Name: publications; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.publications (id, slug, type, title, content, excerpt, is_published, user_id, tags, read_time, created_at, updated_at, published_at, image_url, view_count) FROM stdin;
2	\N	Deportes	Argentina dio vuelta un partidazo y le ganó 3-2 a Finlandia por el debut del Mundial de vóley	Argentina debutó en el Mundial de vóley con una remontada histórica: tras ir 0-2 contra Finlandia, ganó 3-2 con parciales 19-25, 18-25, 25-22, 25-22 y 15-11 en 2h30, primer tie-break del torneo. Sin jugar bien, pero con carácter, logró por primera vez dar vuelta un 0-2 en un Mundial.\n\nMarcelo Méndez sorprendió con Matías Sánchez como armador y De Cecco al banco, completando con Kukartsev, Loser, Gallego, Palonsky, Vicentín y Danani. El inicio fue errático, con bloqueo finlandés implacable (5-0 en el primer set). Los europeos dominaron saque y defensa, y se llevaron los dos primeros parciales casi sin oposición.\n\nEn el tercero, Méndez devolvió a De Cecco y el equipo mostró otra cara: más defensa, presión desde el saque y puntos claves de Palonsky y Kukartsev. Argentina ganó confianza, sostuvo la presión y forzó el tie-break.\n\nEn el quinto, los errores de Marttila y el ingreso decisivo de Martínez (bloqueo y ace vital) inclinaron la balanza. Finlandia se desmoronó en el cierre y Argentina selló el 15-11. Fue un triunfo trabajado, irregular en el juego pero enorme en carácter, que sirve para creer de cara al choque contra Corea.\n\nFormación inicial: Sánchez, Kukartsev, Loser, Gallego, Vicentín, Palonsky y Danani. Ingresaron De Cecco, Gómez, Martínez, Armoa, Zerba y Giraudo.	Pese a que arrancó 0-2 en sets y desdibujada, la Selección lo pudo ganar con el ingreso clave de Martínez y mejoras varias. Ahora se viene Corea para pensar en los octavos de final.	t	1	argentina, mundial, remontada, mendez	\N	2025-09-15 13:58:30.509061	2025-09-15 22:34:58.640416	2025-09-15 13:58:30.508436	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757944710/publications/jwccsrisdzof2ncnir81.jpg	1
4	\N	Cultura	🚶‍♂️✨ Camino del Peregrino: fe, tradición y comunidad en movimiento ✨🚶‍♀️	El domingo, desde las primeras horas, cientos de fieles emprendieron la caminata por el Camino del Peregrino, partiendo desde Giulio Cesare y llegando al Santuario del Cura Brochero. Cada paso estuvo cargado de oraciones, intenciones y agradecimientos, en una experiencia única que combina espiritualidad, tradición, naturaleza y cultura.\n\nLa gran novedad de este año fue el Primer Encuentro de Peregrinos, realizado el sábado, con la Misa del Peregrino, espectáculos artísticos y momentos de preparación espiritual que reforzaron el sentido comunitario de la experiencia.\n\nPero la peregrinación no solo dejó huella en lo religioso: también impactó en la economía local, impulsando hotelería, gastronomía y comercios. A la vez, la articulación entre instituciones, municipios, fuerzas de seguridad, vecinos y voluntarios garantizó un evento seguro, organizado y hospitalario.\n\nEl presidente de la Agencia Córdoba Turismo, Darío Capitani, lo resumió con claridad:\n“El Santo Brochero no solo representa un ejemplo de fe y compromiso social, sino también un motor para el turismo religioso, que moviliza a miles de personas y posiciona a Córdoba como un destino espiritual único en el país”.\n\nLa actividad fue organizada por la Diócesis de Cruz del Eje, el Santuario del Cura Brochero y la Municipalidad de Villa Cura Brochero, con el acompañamiento del Gobierno de Córdoba a través de la Agencia Córdoba Turismo.	El evento, que ya se ha consolidado como uno de los encuentros de fe más importantes del país, reafirma a Villa Cura Brochero como un destino central del turismo religioso en Córdoba.	t	2	misa, peregrinos, religion, caminata, cura brochero, santo brochero	\N	2025-09-15 16:39:23.094835	2025-09-15 17:04:13.369125	2025-09-15 16:39:23.094096	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757954363/publications/b7hixjbcdnjdhnusuvob.jpg	1
3	\N	Cultura	BanZaiShow - MC - Esta de vuelta !!	🌸🎶 Vuelve BanZaiShow – MC 🎶🌸\nDespués del parate de marzo, este Sábado 20 de septiembre reabrimos el escenario con todo: llega la banda de Carlos Flores para ponerle música, energía y fiesta al arranque de la primavera. 🌺🔥\n\nEs el regreso que estabas esperando: un show que mezcla la potencia de la banda en vivo, el espíritu de BanZai y la promesa de una temporada de verano que arranca a pura música y diversión.\n\n📍 Lugar: Poeta Lugones 1443 - a metros de la calle San Martín - Mina Clavero -\n🕘 Hora: 23\n🎟️ Entrada: llamanos al +54 351 202 6579 \n\n👉 Vení con tus amigos, preparate para cantar, bailar y ser parte de este renacer. BanZaiShow – MC vuelve y lo hace a lo grande.	- Volvimos !!! y queremos festejarlos con todo ... !	t	1	Entretenimiento, diversión, noche, mina clavero, baile, carlos flores	\N	2025-09-15 16:23:12.889797	2025-09-21 16:08:21.014882	2025-09-15 16:23:12.888177	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757953393/publications/pzwru665yxneqmatr1xt.jpg	39
1	\N	Análisis	A cuánto cerró el dólar blue este viernes 12 de septiembre	El dólar blue hoy viernes 12 de septiembre de 2025, cerró de la siguiente manera para esta jornada cambiaria.\n\nA cuánto cotiza el dólar Blue\nEl dólar paralelo cotiza con un valor en el mercado de $1405,00 para la compra y $1425,00 para la venta.\n\nA cuánto cotiza el dólar Oficial\nSegún la pizarra del Banco de la Nación Argentina (BNA), este viernes 12 de septiembre cerró en $1390,00 para la compra y $1440,00 para la venta.\n\nA cuánto cotiza el dólar MEP\nEl dólar MEP, también conocido como dólar bolsa, cerró en $1415,00 para la compra, $1465,00 para la venta.\n\nA cuánto cotiza el dólar contado con liquidación\nEl dólar contado con liquidación (CCL) cerró en las pizarras a $1460,70 para la compra y $1462,00 para la venta.\n\nA cuánto cotiza el dólar cripto\nA través de las operaciones con criptomonedas, el dólar cripto cotiza en $1464,12\n\n​para la compra, y en $1468,27 para la venta.\n\nA cuánto cotiza el dólar tarjeta\nEl tipo de cambio, al cual se debe convertir el monto en dólares que nos llega en el resumen de nuestra tarjeta, opera hoy en $1904,50.\n\nLos consumos en moneda extranjera pueden ser por utilización de productos digitales, plataformas de streaming o compras en el exterior.\n\nRiesgo País\nEl riesgo país es un indicador elaborado por el JP Morgan que mide la diferencia que pagan los bonos del Tesoro de Estados Unidos contra las del resto de los países.\n\nEste jueves 11 de septiembre dicho índice ubicó al riesgo país en 1070 puntos básicos.	Conocé como cerró en el mercado la divisa norteamericana el viernes, 12 de septiembre del 2025	t	1	\N	\N	2025-09-15 13:51:02.402106	2025-09-15 21:32:17.354441	2025-09-15 13:51:02.399277	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757944263/publications/xqhq07yrseavad3dxg57.png	2
6	\N	Educativo	🌾 Conferencia sobre Condiciones Climáticas – Campaña 2025-2026 🌦	🌾 Conferencia sobre Condiciones Climáticas – Campaña 2025-2026 🌦\n📅 19 de septiembre – 18:00 hs\n📍 Consorcio Caminero N°151, Alto Grande\n\n🎙 Disertante: Rafael Di Marco\n🎟 Entradas: $20.000 general | $15.000 socios\n(Cupos limitados)\n\nAdquirí tu entrada completando el formulario \n https://docs.google.com/forms/d/e/1FAIpQLSfUbhNYh57IN4HQZKiBOUhYFTHaBNdfAdmhr1Q1Bsbtl6kAMg/viewform?usp=header \n\n👉 Reservá tu lugar al 3544-410592	Expertos y productores analizarán cómo las variaciones climáticas afectarán la campaña 2025-2026: lluvias, sequías, plagas y su impacto en rindes, costos y logística. Se discutirán modelos predictivos, estrategias de adaptación, manejo de suelo, seguros agrícolas y políticas públicas para mitigar riesgos y mejorar la resiliencia del sector agropecuario. Prácticas sostenibles.	t	1	#Clima, #Agro2025, #CampañaAgrícola,  #SustentabilidadRural,  #ProductoresEnAcción	\N	2025-09-17 11:47:32.627416	2025-09-17 11:47:49.535005	2025-09-17 11:47:32.626069	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758109653/publications/kv2gsszf7uyeulfkxidl.jpg	1
5	\N	Deportes	Argentina 3 - Korea 1 ! Con un pie en segunda ronda.	En su segunda presentación del Grupo C del Mundial, la Selección masculina dirigida por Marcelo Méndez superó a Corea del Sur por 3-1 y quedó muy cerca de la segunda ronda.\n\nEl arranque fue parejo, con un rival que mostró mejorías pero nunca logró incomodar en serio. La diferencia estuvo en los momentos clave: el ingreso de Nico Zerba (2,04 m) dio aire con un pasaje de 3-0, y los bloqueos de Pablo Kukartsev y los puntos de Luciano Vicentín inclinaron la balanza.\n\nEl tercer set fue todo celeste y blanco: variantes, solidez y un Kukartsev imparable con 21 puntos y 3 bloqueos. Con esa contundencia, Argentina cerró un 25-18 que sentenció la historia y dejó al equipo con la confianza a tope para lo que viene.	El seleccionado nacional masculino, dirigido por Marcelo Méndez, le ganó por 3-1 a Corea del Sur, que disputan su segunda presentación por el Grupo D del Mundial que se celebra en Filipinas. Pablo Kukartsev fue el máximo anotador con 21 puntos.	t	1	seleccion argentina, voley, mundial, segunda ronda, korea	\N	2025-09-16 11:56:02.478456	2025-09-16 15:04:24.177555	2025-09-16 11:56:02.444156	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758023763/publications/jjkt9iyvnkopl5uyhwi8.jpg	2
7	\N	Tecnología	Marina Hasson: “La incorporación de la IA en las pymes es un camino, no es prender y apagar la luz”	La inteligencia artificial (IA) dejó de ser promesa y ya persigue a empresas de todos los tamaños. Según Marina Hasson, directora de pymes en Microsoft para Latam, su adopción es un camino, no una receta lista: se ajusta a cada realidad y a lo que muestre mejor retorno.\n\nEl estudio 2025 de Microsoft/Edelman muestra que, en Argentina, la importancia de la IA para las pymes se cuadruplicó en un año, pasando del 7% al 30%, sobre todo en medianas. Los principales desafíos: reducir costos, ganar clientes y aumentar ventas.\n\nHasson identifica cuatro ejes estratégicos: experiencia de empleados (retener talento), interacción con clientes (mejor servicio), automatización de procesos y espacio para la innovación. Todo con seguridad como base crítica: proteger datos, dispositivos e identidades.\n\nHoy existe un fenómeno de “traer tu propia IA”, lo que obliga a uniformidad y gobernanza interna. La clave, dice Hasson, es la cultura organizacional y un liderazgo fuerte que impulse la adopción, con apoyo de Tecnología y Recursos Humanos.\n\nEl estudio revela que el 54% de las pymes ya tiene estrategia de IA, y 82% ve con optimismo su uso, aunque el 49% admite que necesita cambios culturales. Además, el 58% ya usa alguna IA, y 83% planea invertir en 2025.\n\nMotivos: en microempresas, la prioridad es costos y continuidad; en medianas, competencia, eficiencia e innovación. Las aplicaciones más comunes son: atención al cliente virtual, búsquedas de información y marketing con IA generativa.\n\nEn síntesis: la adopción avanza a distintas velocidades, pero las oportunidades para pymes están en mejorar la experiencia laboral, el servicio al cliente, la eficiencia de procesos y el valor agregado en productos o servicios.	La número uno del segmento de pymes de Microsoft para la región, destaca que en un año se cuadriplicó la importancia de proyectos con la nueva tecnología en la Argentina	t	2	IA, Tecnología, PYMES, Empresas, oportunidades	\N	2025-09-18 11:53:24.968108	2025-09-18 11:53:26.373209	2025-09-18 11:53:24.964108	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758196405/publications/ntv2dgjrmbrumh65pilz.png	0
9	\N	Tecnología	Qué sectores lideran la implementación de la inteligencia artificial en Argentina	La inteligencia artificial convirtió en un factor clave para la transformación digital de las empresas en Argentina. De acuerdo a un estudio de International Data Corporation (IDC), la inversión en tecnologías de IA en América Latina alcanzará los $3,400 millones en 2025, y en el país. Estas industrias están aprovechando la IA para personalizar servicios y mejorar la experiencia del cliente, marcando el camino hacia un uso más sofisticado de los datos. \n\nLos usuarios demandan servicios más personalizados, y el análisis de datos históricos y preferencias permite a las empresas ofrecer soluciones a medida. Esto es posible gracias a la implementación de tecnologías de IA que explotan la información de manera eficiente.\n\nAunque la adopción de IA crece de manera sostenida, algunos sectores enfrentan desafíos significativos. Entre ellos, se destaca el sector salud que es uno de los que enfrentan más retos debido a preocupaciones sobre la seguridad y privacidad de los datos. El manejo de datos sensibles genera dudas, especialmente en tecnologías emergentes. Sin embargo, estas preocupaciones representan oportunidades para desarrollar soluciones más seguras y eficientes. El sector agrícola también está comenzando a explorar el uso de IA en decisiones ambientales y monitoreo climatológico, mostrando un gran potencial de crecimiento.\n\nLas soluciones más buscadas incluyen chatbots avanzados, análisis predictivo y herramientas para ciberseguridad. Las nuevas versiones de chatbots, ahora más inteligentes, están siendo ampliamente adoptadas, especialmente en áreas operativas y de atención al cliente. Además, las empresas están aprovechando la IA para predicción y mantenimiento en plantas de operaciones, así como para fortalecer sus estrategias de ciberseguridad.\n\nAunque la implementación de IA no está exenta de retos. Para que la IA funcione correctamente, es crucial tener una estrategia de datos estructurada. Esto implica contar con fuentes de datos confiables y consistentes, integrar datos estructurados y no estructurados, y construir un Data Lake que permita explotar la información de manera efectiva. Además, proteger estos datos y minimizar vulnerabilidades sigue siendo un desafío clave para las organizaciones.\n\nLa inteligencia artificial se convirtió en un tema estratégico en las discusiones a nivel directivo. La resistencia a esta tecnología ha disminuido considerablemente. Las empresas saben que la IA no reemplazará a las personas, sino que empodera a quienes sepan utilizarla. Esto está redefiniendo la competitividad empresarial. Según sus estimaciones, para 2030, un alto porcentaje de compañías en la región contará con al menos un proyecto significativo basado en IA.\n...\n\nLee la nota completa aca : https://www.ambito.com/opiniones/que-sectores-lideran-la-implementacion-la-inteligencia-artificial-argentina-n6186668	Según una investigación de International Data Corporation (IDC) la inversión en tecnologías de IA en América Latina alcanzará los $3,400 millones en 2025, y en el país.	t	2	IA, Tecnología, PYMES, Empresas, oportunidades, datos	\N	2025-09-18 13:21:54.611646	2025-09-18 13:21:55.800841	2025-09-18 13:21:54.611052	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758201715/publications/zp4zrvl6ao62bp9g6dxv.png	0
8	\N	Tecnología	Conuar fabricará componentes para un prototipo de micro reactor nuclear que se construirá en EE.UU.	La empresa Combustibles Nucleares Argentina (Conuar) podría fabricar componentes para un micro reactor atómico diseñado por una firma europea. La compañía, que es controlada por el grupo Perez Companc y tiene a la Comisión Nacional de Energía Atómica (CNEA) como accionista minoritario, firmó en Viena un acuerdo con la firma Terra Innovatum que involucra al reactor micromodular SOLO, según pudo saber EconoJournal. El acuerdo también abre la puerta a establecer en la Argentina un hub de ensamblaje y cadena de valor para Latinoamérica relacionado con este reactor.\n\nEl convenio suscrito establece que Conuar diseñará y fabricará componentes críticos para el SOLO Micro-Modular Reactor (MMR) de Terra Innovatum, una compañía europea enfocada en el desarrollo de soluciones nucleares innovadoras.\n\nEl CEO de CONUAR, Rodolfo Kramer, celebró la firma del convenio. “Este acuerdo representa una oportunidad única para demostrar cómo la capacidad industrial argentina puede integrarse a proyectos internacionales de vanguardia. En Conuar nos sentimos orgullosos de aportar nuestra experiencia y know-how para hacer realidad un diseño que promete energía limpia y accesible para futuras generaciones”, dijo.\n\nLee la nota completa acá : https://econojournal.com.ar/2025/09/conuar-fabricara-componentes-para-un-prototipo-de-micro-reactor-nuclear-que-se-construira-en-ee-uu/	La empresa Conuar, controlada por el grupo Perez Companc, rubricó esta semana un acuerdo con la firma europea Terra Innovatum para fabricar componentes críticos del reactor micro modular SOLO. Terra Innovatum comenzó a tramitar el licenciamiento para la construcción de una primera unidad prototipo en los Estados Unidos.	t	2	Tecnología, energía nuclear, energía, Argentina	\N	2025-09-18 12:17:15.030874	2025-09-30 12:11:25.137987	2025-09-18 12:17:15.030195	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758197835/publications/x7178mz11xkzbz58uae3.jpg	6
10	\N	Deportes	𝗣𝗥𝗜𝗠𝗘𝗥𝗢 𝗔𝗥𝗚𝗘𝗡𝗧𝗜𝗡𝗔 𝗖𝗟𝗔𝗦𝗜𝗙𝗜𝗖𝗔𝗗𝗔 !! ... Segundo 𝗙𝗥𝗔𝗡𝗖𝗜𝗔.	Argentina dio un tremendo golpe en el Mundial de vóleibol: eliminó a Francia y se clasificó a los octavos de final.\nSe impuso por 3-2 para dejar afuera del torneo al bicampeón olímpico.\n\nLa selección argentina de vóleibol dio un gran golpe contra Francia, porque consiguió el pasaporte para los octavos de final del Mundial, en el cierre del Grupo C, y eliminó al bicampeón olímpico. El conjunto de Marcelo Méndez se impuso por 3-2 (28-26, 25-23, 21-25, 20-25 y 15-12), en el tie break con una tarea impresionante en el ataque de Luciano Vicentín (22 puntos) y de Luciano Palonsky (17). Ahora el conjunto nacional espera rival que será el segundo del Grupo F (que podría ser Italia o Ucrania).\n\nLa victoria de la Argentina resonó en todo el estadio en el Coliseo Smart Araneta de Quenzon City, Filipinas, pero uno de los momentos más particulares se dio cuando el entrenador de Francia, Andrea Giani, que interrumpió el festejo del conjunto de Marcelo Méndez, al parecer, para advertir algún comportamiento que le pareció desmedido. Los jugadores argentinos lo escucharon con respeto, aunque no dejó de ser una acción, al menos curiosa, porque sus jugadores, durante el partido, también entraron en el juego de las provocaciones.\n\nLee la nota completa acá : https://www.lanacion.com.ar/deportes/voley/argentina-vs-francia-por-un-lugar-en-los-octavos-de-final-del-mundial-de-voleibol-en-vivo-nid18092025/	VAMOS ARGENTINA CARAJO	t	2	#VAMOSARGENTINA #VamosLosPibes #mundial #WorldChampionship #voley #volei #voleibol	\N	2025-09-18 13:32:36.155961	2025-09-18 22:40:14.309235	2025-09-18 13:32:36.15531	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758202356/publications/v4vftyh7pawosa8er56m.png	14
11	\N	Deportes	Argentina y otra cita con la historia del vóleibol: frente a Italia en busca de los cuartos de final	Por qué es importante el partido del Mundial de Vóleibol\nArgentina e Italia buscarán seguir avanzando en el cuadro del Mundial, buscando alcanzar el podio en la máxima competencia Mundial de Selecciones. El torneo es durísimo, de hecho varios candidatos a pelear por las medallas quedaron fuera de competencia, como Brasil, que desde 2002 siempre había estado entre los cuatro mejores de este torneo.\n\nAsí llegan los equipos\nCómo dijimos, Argentina debió vencer en su último duelo de Fase de Grupos a Francia, el actual bicampeón olímpico. Tras ir ganando 2 a 0, los galos remontaron y el partido se definió en un tremendo quinto set. ARgentina con ese resltado ganó el grupo con tres victorias en tres presentaciones.\n\nItalia también llegó necesitada de un triunfo a su último duelo de zona ante Ucrania, pero para obtener el segundo lugar de la misma, detrás de Bélgica, que había sido su verdugo en el debut. La Selección italiana se adueñó del partido desde la primera pelota y lo ganó con parciales de 25-21, 25-22 y 25-18, con 11 puntos de Romano, otros 11 de Bottolo y 12 de Michieletto, máximo goleador italiano.\n\nLee la nota completa aca : https://www.espn.com.ar/otros-deportes/nota/_/id/15692421/argentina-vs-italia-por-los-octavos-de-final-del-mundial-de-voleibol-equipo-fecha-hora-y-tv-en-vivo	La Selección Argentina masculina consiguió una histórica e inolvidable victoria 3-2 sobre la bicampeona olímpica Francia y enfrentará el domingo 21 de septiembre a Italia por los octavos de final del Campeonato Mundial de Vóleibol Filipinas 2025.\n\nEl partido comienza a las 04:30 (ARG/URU/CHI) y 02:30 (COL/PER/ECU).	t	1	argentina, mundial, italia, mendez, voley	\N	2025-09-20 00:41:01.604045	2025-09-20 12:19:19.111657	2025-09-20 00:41:01.600091	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758328862/publications/wnlzolyxvlacdpg19oew.jpg	2
13	\N	Deportes	👏👏 - GRACIAS MUCHACHOS - 👏👏	No siempre gana el que levanta la copa. A veces el verdadero triunfo es dejar el corazón en cada jugada, emocionar a un país entero y recordarnos que el vóley argentino está entre los grandes del mundo. Gracias, muchachos, por hacernos latir fuerte, por pintarnos de celeste y blanco en cada punto, por mostrarnos que la disciplina, el compromiso y la pasión también son victorias. Para nosotros ya son campeones. Orgullo total. 🙌🇦🇷❤️	Argentina cayó, pero dejó el alma en la cancha. 🏐🇦🇷	t	1	argentina, corazon, garra, mundial2025	\N	2025-09-22 14:34:09.609732	2025-09-22 14:34:11.269414	2025-09-22 14:34:09.608069	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758551650/publications/j3ierianmmisgcak8w3q.png	0
14	\N	Deportes	El piloto récord del que habla todo el país! 🏁🔥🇦🇷	Matías Lorenzato, originario de Mina Clavero, Traslasierra, Córdoba, Argentina, es sin duda uno de los pilotos más destacados y en ascenso en el motociclismo argentino y regional. Con una historia marcada por esfuerzo, pasión y resultados impresionantes, Lorenzato se ha consolidado como una figura clave en el Campeonato Argentino de Motociclismo (CAM).\n\nActualmente, el piloto de Mina Clavero tiene en su haber 74 victorias, logrando 9 títulos en diferentes categorías y acercándose rápidamente a convertirse en el máximo ganador en la historia del CAM, a solo 11 triunfos de alcanzar ese récord. Su desempeño en 2025 ha sido excepcional, mostrando una conducción madura y una competitividad que lo mantienen en la cima de manera constante.\n\nDestaca en categorías altamente competitivas, siendo líder absoluto en la 450cc Internacional y también en la 125cc Graduados, las categorías más duras y exigentes del certamen. Recientemente, su fantástico rendimiento en carreras en Centeno y Villa Trinidad, donde también fue el piloto más ganador en esas pistas, confirma su potencial y su gran capacidad para adaptarse y dominar en diferentes circuitos.\n\nEn la temporada 2025, Lorenzato ha obtenido 9 podios, con 4 victorias en la categoría 450cc y la primera posición en 125cc, demostrando una vez más su consistencia y talento. En la última fecha, enfrentó mano a mano a los grandes, luchando con Marcos Barrios y Matías Frey, conquistando las victorias sin errores y asegurando la punta en las carreras más complicadas.\n\nSu historia y logros no solo reflejan su talento como piloto, sino también su dedicación y perseverancia, que inspiran a toda la comunidad de Traslasierra y Argentina. Matías Lorenzato continúa escribiendo su propia leyenda, con la mira puesta en más triunfos y récords, consolidándose como uno de los referentes del motociclismo nacional.\n\nEste es solo el comienzo de una historia que sigue creciendo y emocionando a todos los amantes del deporte sobre dos ruedas.	Matías Lorenzato, de Mina Clavero, Córdoba, destacado piloto argentino en el CAM, con 74 victorias y 9 títulos en categorías duras como 450cc y 125cc. Líder en 2025, busca récords y consolidarse como uno de los mejores, demostrando talento, madurez y perseverancia en cada carrera.	t	1	motoCAM, record, mina clavero, traslasierra, matiaslorenzato	\N	2025-09-22 15:12:41.830905	2025-09-22 15:12:43.394274	2025-09-22 15:12:41.826947	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758553962/publications/sddk7qmrolgtvxxmtsem.png	0
12	\N	Análisis	Payway Trends: Orquestación estratégica en el ecosistema de pagos argentino	Payway Trends se consolida como el epicentro donde converge la vanguardia del ecosistema de pagos argentino. Más allá de un evento corporativo, se erige como termómetro de las transformaciones que redefine la interacción entre dinero, tecnología y consumo. Con un lineup que integra desde economistas como Santiago Bulat hasta disruptores como Mario Pergolini, el encuentro profundiza en tensiones clave: seguridad versus experiencia seamless, inclusión financiera versus sophistication tecnológica, innovación global versus adaptación local.\n\nTras el discurso colaborativo —donde actores como Visa, Mastercard y retailers líderes comparten casos— subyace una apuesta estratégica de Payway por posicionarse no como un mero procesador, sino como el orquestador central de un ecosistema fragmentado. El evento refleja así los desafíos de una industria en transición: cómo escalar soluciones sin sacrificar usabilidad, cómo integrar legacy systems con APIs de última milla, y cómo construir confianza en un contexto de alta volatilidad económica.\n\nPero más allá de las tendencias, Payway Trends expone una verdad incómoda: la innovación real often choca con inercias estructurales del mercado. El evento, entonces, funciona tanto como vitrina de avances como espejo de las limitaciones que aún persisten en la democratización financiera argentina. Un diálogo necesario, aunque aún dominado por la retórica corporativa, en un país donde el futuro de los pagos aún se escribe entre promesas y restricciones.\n\nLee la nota completa aca: https://www.lanacion.com.ar/economia/negocios/como-pagaremos-en-el-futuro-tendencias-e-innovacion-en-un-encuentro-que-reunio-a-los-referentes-del-nid17092025/	Payway Trends reunió a actores clave del ecosistema financiero para debatir el futuro de los pagos. El evento, organizado por Payway, se presentó como un espacio de orquestación entre bancos, fintechs y comercios, destacando tendencias como tokenización, seguridad y experiencia de usuario.	t	1	tecnologia, futuro, pagos, fintech, networking	\N	2025-09-20 12:12:47.273322	2025-09-20 12:16:26.793553	2025-09-20 12:12:47.272491	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758370368/publications/rlngqxxszrcpujxqx5od.png	4
16	\N	Análisis	Liquidez o crecimiento: el dilema clave para las pymes en año electoral	La economía se encuentra en un punto de inflexión. El resultado electoral en la provincia de Buenos Aires, con una derrota contundente para el oficialismo, modificó la hoja de ruta política y reactivó la sensibilidad de los mercados. Los próximos meses, hasta las legislativas nacionales de octubre, estarán marcados por expectativas fluctuantes, estrategias defensivas y la necesidad de administrar cuidadosamente cada decisión empresarial.\n\nPara las pyme, luego de un año de cierta estabilidad macroeconómica que permitió proyectar con mayor previsibilidad, la fragilidad política y financiera reinstala un escenario conocido y desgastante: adaptarse a reglas que vuelven a cambiar sobre la marcha. Para las empresas argentinas no es una novedad, pero sí implica reactivar reflejos que habían quedado relegados.\n\n… por Damián Di Pace.\nLee la nota completa acá: https://www.infobae.com/opinion/2025/09/28/liquidez-o-crecimiento-el-dilema-clave-para-las-pymes-en-ano-electoral/	La incertidumbre política y la volatilidad financiera obligan a las pequeñas y medianas empresas a encontrar un delicado equilibrio entre aprovechar los rendimientos inmediatos del capital y apostar por inversiones productivas	t	2	Análisis, Damián Di Pace, inversión. Liquidez, crecimiento	\N	2025-09-29 22:26:59.357885	2025-09-29 22:59:37.031577	2025-09-29 22:26:59.35707	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759184819/publications/gld4smksxe9djstzmpc1.jpg	1
15	\N	Análisis	Liquidez o crecimiento: el dilema clave para las pymes en año electoral	La economía se encuentra en un punto de inflexión. El resultado electoral en la provincia de Buenos Aires, con una derrota contundente para el oficialismo, modificó la hoja de ruta política y reactivó la sensibilidad de los mercados. Los próximos meses, hasta las legislativas nacionales de octubre, estarán marcados por expectativas fluctuantes, estrategias defensivas y la necesidad de administrar cuidadosamente cada decisión empresarial.\n\nPara las pyme, luego de un año de cierta estabilidad macroeconómica que permitió proyectar con mayor previsibilidad, la fragilidad política y financiera reinstala un escenario conocido y desgastante: adaptarse a reglas que vuelven a cambiar sobre la marcha. Para las empresas argentinas no es una novedad, pero sí implica reactivar reflejos que habían quedado relegados.\n\n… por Damián Di Pace.\nLee la nota completa acá: https://www.infobae.com/opinion/2025/09/28/liquidez-o-crecimiento-el-dilema-clave-para-las-pymes-en-ano-electoral/	La incertidumbre política y la volatilidad financiera obligan a las pequeñas y medianas empresas a encontrar un delicado equilibrio entre aprovechar los rendimientos inmediatos del capital y apostar por inversiones productivas	t	2	Análisis, Damián Di Pace, inversión. Liquidez, crecimiento	\N	2025-09-29 22:26:58.04124	2025-09-30 02:00:01.741986	2025-09-29 22:26:58.038573	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759184818/publications/nmnhihchvyxdhdscicrh.jpg	1
\.


--
-- TOC entry 5006 (class 0 OID 16520)
-- Dependencies: 232
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.schedules (id, doctor_id, clinic_id, day_of_week, start_time, end_time, is_active) FROM stdin;
\.


--
-- TOC entry 4992 (class 0 OID 16413)
-- Dependencies: 218
-- Data for Name: subscribers; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.subscribers (id, email, subscribed_at) FROM stdin;
1	holisticotre@gmail.com	2025-09-18 13:06:58.18181
2	patricia.schifini@gmail.com	2025-09-18 13:17:39.171417
3	macalu66@hotmail.com	2025-09-18 13:38:59.03338
4	elvasqito@hotmail.com	2025-09-18 20:00:19.489848
5	lucaastiazu0@gmail.com	2025-09-18 20:06:50.750662
\.


--
-- TOC entry 5014 (class 0 OID 16607)
-- Dependencies: 240
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.tasks (id, title, description, due_date, status, doctor_id, assistant_id, created_by, clinic_id, created_at) FROM stdin;
58	Mix - ubicaciones - asistentes - tareas - Senior	Actualizacion de tablas	2025-09-30	pending	6	6	6	\N	2025-09-29 11:40:39.774616
60	pulir	pulir balcones del 1ro al 4to piso deptos a	2025-10-01	pending	6	18	19	\N	2025-10-01 17:51:20.50527
59	prueba de tareas de agustin	asignando tareas	2025-10-05	in_progress	6	6	19	\N	2025-10-01 15:13:14.868927
44	4 a	arreglar el zocalo inferiopr del ventanal de living	2025-09-22	pending	6	18	\N	\N	2025-09-22 14:13:04.889157
26	1 a enduido	terminacion pared lateral	2025-09-09	pending	6	5	\N	\N	2025-09-18 18:53:51.026537
45	4 c pastinar	pastrinar piso living y habitacion	2025-09-24	pending	6	5	\N	\N	2025-09-24 13:47:06.204792
4	ubicaciones	ver como llevar piso departamento por ubicación	\N	pending	6	6	\N	\N	2025-09-01 08:00:00
5	relacion entre tareas	ver poder relacionar tareas puras con tareas que surgen de tareas mal hechas	\N	pending	6	6	\N	\N	2025-09-01 08:00:00
6	Tarea 1	descripcion tarea 1	2025-09-22	pending	2	3	\N	\N	2025-09-01 08:00:00
7	Dashboard gestion de tareas	importante : grafico de evolucion de tareas por asistente	2025-09-26	in_progress	6	6	\N	\N	2025-09-17 11:16:07.420352
46	4 c Pintar 	encima de extractador	2025-09-24	pending	6	5	\N	\N	2025-09-24 13:48:06.855202
10	4 c Benitez	Benitez mira porque se descascara la pintura del 4 c, decime como solucionamos ese tema porfa	2025-09-17	pending	6	14	\N	\N	2025-09-17 14:20:11.584355
3	pastinar 1 a	ARREGLAR BORDES DE PLACAR DE LA HABITACION. !	2025-09-17	pending	6	5	\N	\N	2025-09-01 08:00:00
17	TAREA DE PRUEBA PARA VER SI LLEGAN LOS MENSAJES	BLABLABLA	2025-09-17	pending	6	15	\N	\N	2025-09-17 17:13:21.97051
8	2 b pintar zocalos que faltan en todo el departamento	Verifica y pinta todos los zócalos que faltan pintar en el departamento 2 b	2025-09-17	pending	6	10	\N	\N	2025-09-17 13:41:33.459326
1	Asignando nueva tarea	Probando mensajes de telegram	2025-09-20	completed	2	3	\N	\N	2025-09-01 08:00:00
18	Enviar correo	Enviame por favor tu correo electrónico. Gracias	2025-09-18	in_progress	2	16	\N	\N	2025-09-17 17:38:27.388166
2	probando mensajes de telegram	probando vinculaciones	2025-09-20	in_progress	2	2	\N	\N	2025-09-01 08:00:00
19	6 B EMPROLIJAR VCIGA HABITACION	PASAR MNOLADORA Y EMPROLIJAR REBARBAS	2025-09-19	pending	6	10	\N	\N	2025-09-18 14:36:09.684803
20	2 B PASTINAR PISO	PASTINAR PISO CONTRA ZOCALOS	2025-09-18	pending	6	5	\N	\N	2025-09-18 14:59:38.971769
21	2 b pintar zocalos habitaciones y living	revisar yb pintar zocalos de toido el depto	2025-09-18	pending	6	17	\N	\N	2025-09-18 15:15:04.76939
24	2 c pastinar living	\N	2025-09-11	pending	6	13	\N	\N	2025-09-18 18:51:06.351874
25	1 a terrminacion pared lavarropa	\N	2025-09-08	pending	6	5	\N	\N	2025-09-18 18:52:02.633755
27	3 a lavadero	emprolijar	2025-09-10	pending	6	5	\N	\N	2025-09-18 18:55:05.87661
28	3 a piso	pastinar pìso	2025-09-10	pending	6	5	\N	\N	2025-09-18 18:56:02.660837
29	2 a lavarropa	emprolija	2025-09-11	pending	6	5	\N	\N	2025-09-18 18:56:58.948271
32	3 c lavarropa	pintar	2025-09-18	pending	6	5	\N	\N	2025-09-18 18:59:36.487388
33	2 b baños	limpiar baños	2025-09-12	pending	6	5	\N	\N	2025-09-18 19:00:29.439061
35	3 a bañadera	emprolijar	2025-09-04	pending	6	5	\N	\N	2025-09-18 19:01:57.642668
31	2 b lavarropa	lavarropa pintar	2025-09-18	pending	6	5	\N	\N	2025-09-18 18:58:57.332989
11	4 a pintura	MEÑANA VIENEN LOS DUEÑOS DEL 4 A\n\nHOY HAY QUE TERMINAR DE HACER ESTOS ARREGLOS\nPINTUTRA , HAY RETOQUES SERCA DE LA LLAVE DEL PASILLO.\nENDUIDO EN LOS PERFILES DE LOS PLACARES\nPINTAR ZOCALOS EN TODO EL DEPARTAMENTO DONDE CORRESPONDA	2025-09-17	pending	6	10	\N	\N	2025-09-17 15:17:55.657757
12	6 B pintura	PINTAR PARED CON HUMEDAD DEL DORMITORIO	2025-09-18	pending	6	10	\N	\N	2025-09-17 15:27:49.449934
14	6 B enduido	HAY UN AGUJERO POR TAPAR ENTRE LA PERED Y EL PISO ANTRES DEL PASILLO QUE DA A DOREMITORIO	2025-09-18	pending	6	10	\N	\N	2025-09-17 15:33:15.067121
15	6 B viga	EMPROLIOJAR VIGA DE COCINA	2025-09-18	pending	6	10	\N	\N	2025-09-17 15:34:29.660787
16	4 A colocar puerta	VOLVER A COLOCAR5 PUIERTYA DONDE ESTA CALDERA	2025-09-18	pending	6	5	\N	\N	2025-09-17 15:35:20.791313
34	4 a limpieza	limpiar porcelanatos baños	2025-09-09	pending	6	5	\N	\N	2025-09-18 19:01:10.567745
23	2 c lavarropa	terminacion pared de lavarroipa	2025-09-12	completed	6	5	\N	\N	2025-09-18 18:50:15.943278
30	3 b pastina	pastina en cocina	2025-09-04	completed	6	5	\N	\N	2025-09-18 18:58:10.003987
9	Verificar estado de colocación de mesadas que falktan en deptos	Ste mira en que departamentos falta colocar todavía las mesadas o vanitoris porfa	2025-09-17	completed	6	7	\N	\N	2025-09-17 13:43:56.032547
22	2 bb arreglar con enduido ventanales	arreglar bordes de ventana con enduido	2025-09-18	completed	6	10	\N	\N	2025-09-18 15:19:52.81755
41	1 B ENDUIDO	ENDUIDO A VENTANA	2025-09-19	completed	6	5	\N	\N	2025-09-19 17:43:19.384974
37	prueba	jyuhdsgafjhfgdjhgfdjhsgtjuhdsgfef	2025-09-18	cancelled	6	6	\N	\N	2025-09-18 20:07:23.422197
40	1 C ENDUIDO	ERNDUIDO A VENTANA DEL CUARTO	2025-09-19	completed	6	5	\N	\N	2025-09-19 17:41:37.063707
38	1 a PASTINA	pastinar PISO	2025-09-19	completed	6	5	\N	\N	2025-09-19 15:29:38.197211
42	LIMPIEZA 5TO PISO	LIMPIAR OFICINA	2025-09-19	pending	6	5	\N	\N	2025-09-19 17:51:44.733504
43	 4 a techo	limpiar manchas en techo de habitación principal del lado de la cabecera 	2025-09-22	pending	6	5	\N	\N	2025-09-22 14:11:58.704048
47	4 c lijar	emprolijar viga de habitacion	2025-09-24	pending	6	24	\N	\N	2025-09-24 13:51:49.183991
48	4 c clavoi	sacar clavo del techo y emprolijar	2025-09-24	pending	6	24	\N	\N	2025-09-24 13:52:26.012381
49	4 c	emprolijar viga con pared living	2025-09-24	completed	6	5	\N	\N	2025-09-24 13:54:43.912711
50	4 c emproliojar	emprolijar pared dfe habitacion	2025-09-24	pending	6	5	\N	\N	2025-09-24 13:55:39.418806
51	4 c  zocalo	arreglar zocalo debajo de venmtanal del living	2025-09-24	completed	6	25	\N	\N	2025-09-24 13:58:36.500042
52	4 c premarcops	revisar terminación de premarcos	2025-09-24	pending	6	5	\N	\N	2025-09-24 13:59:42.241057
54	3 c	lijar viga de habitación	2025-09-24	pending	6	20	\N	\N	2025-09-24 14:02:34.027685
55	3 c  enduido	poner enduido ensima de ventanal de habitacion princvipal	2025-09-24	pending	6	10	\N	\N	2025-09-24 14:03:53.552784
53	3 c  pintar	pintar debajo de ventanal del living	2025-09-24	pending	6	10	\N	\N	2025-09-24 14:01:39.473851
56	1 a pintura	emproliojar pintura habitacion y living	2025-09-24	pending	6	20	\N	\N	2025-09-24 14:36:31.490999
57	3 a  enduido	emportliojar ventana Habitacion enduido	2025-09-24	pending	6	20	\N	\N	2025-09-24 14:37:24.992896
61	Preparar informe de ventas para ...	Para el informe descartar las ventas en cta. cte.	2025-10-15	in_progress	4	30	4	\N	2025-10-07 14:38:38.885224
\.


--
-- TOC entry 4990 (class 0 OID 16402)
-- Dependencies: 216
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.user_roles (id, name, description, is_active, created_at) FROM stdin;
1	Profesional	Profesional de la salud	t	2025-09-15 12:49:15.089596
2	Tienda	Tienda de productos	t	2025-09-15 12:49:15.149453
3	Visitante	Usuario visitante	t	2025-09-15 12:49:15.20735
4	Paciente	Paciente	t	2025-09-15 12:49:15.261005
5	Usuario	Usuario general del sistema	t	2025-09-29 22:57:09.602066
6	PyME	Pequeña y mediana empresa hasta 10 empleados	t	2025-09-29 22:57:54.084654
\.


--
-- TOC entry 4994 (class 0 OID 16422)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.users (id, username, email, password_hash, is_admin, is_professional, created_at, updated_at, url_slug, professional_category, specialty, bio, years_experience, profile_photo, license_number, services, skills, role_name, role_id, store_enabled, email_verified) FROM stdin;
5	JoseLuis	astiazu@hotmail.com	scrypt:32768:8:1$lP4evFrgZ2rCSEH2$6c8d16c7d0058ef81d6b0318c30ff70138b65ef54b7ebc1fb63a94fa2ef3dd97eb32c94b54b49d653bf438c4557baffaaa39fd12afff67919eddaca5c06c387b	f	f	2025-09-15 23:09:03.92779	2025-09-15 23:09:03.927796	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
10	patricia.schifini	patricia.schifini@gmail.com	scrypt:32768:8:1$nfnexY6RRdbJsU1I$290abae3a52614fb119a5d7c5976fc918d06af2f8acce68077276eee7cbc6ae18eb3807437d1191cf800bd3c9d693974420525850cbfc39546720c1fae0a4fe8	f	f	2025-09-18 13:17:39.993785	2025-09-18 13:23:03.182494	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3	t	t
7	Mabel	macalu1966@gmail.com	scrypt:32768:8:1$AhXnS31WIaSkLwzr$94f1dce240cf32cd781fd471f834265592bbeb1540cd0503dbe8eae13db45a7bf556f5ae3e85df387b584bd57b132654330ad9d2b2c0df2a28b5c9b76873e0ae	f	f	2025-09-16 20:15:42.909522	2025-09-16 20:15:42.909529	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3	t	t
12	macalu66	macalu66@hotmail.com	scrypt:32768:8:1$9xquiPX71EBGL5ZZ$7896ee4c27fe8fc5bab07b85f43a061e1e04314b77b5917b4ed33e4a8762178cedd51bae8263c1db86ae1c7dc6ee111052106557f4591023d6afe880993479ff	f	f	2025-09-18 13:38:59.795792	2025-09-18 13:38:59.795799	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
38	Daniel Neira	vigilanciatraslasierra.ar@gmail.com	scrypt:32768:8:1$Y5aCCALnPzynfyQb$7a8968e6682c41007bfa652fd99200ecb9304a6a9c859860f780201f3a481adb885cf021c8a758fea10eda20bd662e6138f12edc9ae1f590d137f51066a3f6b4	f	t	2025-10-02 18:33:18.845267	2025-10-02 18:35:07.800821	vigilanciatraslasierra	\N	Sistema de Vigilancia	Sistemas de Seguridd y Vigilancia	30	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759430108/profiles/profile_38.jpg	1234	Cámaras de Seguridad - Alarmas - Cercos Eléctricos	\N	user	1	t	t
8	emiliano	emipaz1975@hotmail.com	scrypt:32768:8:1$Gy8BpuDHUKD7R9Ss$a4d4add1d7788e4d62121039ce6073badbc7a8d155a79df43e6609a12fb73f72f8d0a50f7317061cd603d8ece750dd26a3753c2c524809ecad4ecb45b0674e62	f	f	2025-09-17 19:37:59.412573	2025-09-17 19:37:59.41258	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
14	elvasqito	elvasqito@hotmail.com	scrypt:32768:8:1$knbX3b3pbRjGgdir$afb0269b4b460b6f0dfd666535cecd94f062a9d530f6ff8e81e8e53313bb4e957ab597e1d14d51af6aeaee549992bb24dc4152be3e343d3f1625839c8e4c2660	f	f	2025-09-18 20:00:20.20733	2025-09-18 20:00:20.207342	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
15	lucaastiazu0	lucaastiazu0@gmail.com	scrypt:32768:8:1$IW4EEw9OWwlzWGxx$60db46247ef0cf3a747e929523d46cd9e2f6456a585147c604c165aa81ad65b5bc68895af634d495dc92a9b5fe836b23be2a2269637ea420c38fe86d8da68802	f	f	2025-09-18 20:06:51.606432	2025-09-18 20:06:51.606438	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
1	admin	admin@local	scrypt:32768:8:1$R9CNmjywCnwEtxq4$08a882ad07c5c738f38ad70cf98ec0aaec887a9f19f7ff1a098c0307c8b15fe3a5a0d3e0b0765a7667271faa9ddab891334a3f0b9f22d9b01bea0d1773cb6b49	t	f	2025-09-15 12:49:15.506259	2025-09-26 23:55:51.712576	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	1	t	t
9	Marcela	holisticotre@gmail.com	scrypt:32768:8:1$cv6EWv5DYHyNEqkc$bc29fb459f2cd0f795d44942b8dde3edbe3edb2f98267980587a573b644bd1e6cc7400c84965771f2907bb8a47cd8cdf751fd56bcc7c80f61a92618dcc60f8a6	f	f	2025-09-18 13:06:58.894439	2025-09-27 14:59:46.447027	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3	t	t
16	Usuario Prueba	usuarioprueba@bioforge.test	scrypt:32768:8:1$yOO3iZKZ8PV539lU$e4b58889ac9e7fb2ac17a044a095d063aeff61969550e4c673f4d75df5aca234bfcbebda8ecf2cdd78b603892019d8af0e7c280418b4339aa00d4e5bbcd29f74	f	f	2025-09-27 18:11:02.644654	2025-09-27 18:11:02.644654	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N	t	t
13	Stefy	stefyocen99@gmail.com	scrypt:32768:8:1$V75r4g6TCjh0kwJb$34222f9a0d80886f42032516d397ef1c5b0990401d3ed8d401c88fe818cb55b16cd360b28d4ca8ab9ebe1c501086717f064c9126d1dbc8b5d6b10fad23b32812	f	f	2025-09-18 13:50:13.50132	2025-09-27 20:43:11.007484	stefy	\N	None	None	\N	\N	None	None	\N	user	\N	t	t
2	astiazu.joseluis	astiazu@gmail.com	scrypt:32768:8:1$ZpRhhqjxxeLx3ymN$64c7dd95c16287bdbf669433162abc2f4dac43d26172d694180aea120eade20f034e4e2e5bd2882ebbdbe63cb29e36a50ec3c33908de6ac7350e4c4b4be6d887	t	t	2025-09-15 13:59:29.501659	2025-09-27 21:49:51.73583	astiazu-joseluis	\N	Analista de Sistemas	Soy analista de sistemas, orientado hacia los resultados y con excelentes dotes comunicativas. También cuento con conocimiento en análisis de datos. A partir del año 2020 volví a la programación gracias a la Cooperativa del Centro de Graduados de la Facultad de Ingeniería - FIUBA -, inicialmente con Python y luego Data Analytics con Google. Desaprender y aprender ha sido un desafío constante en materia de tecnología. Agradecido de poder hacerlo.	30	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757945404/profiles/profile_2.jpg	3571	Analisis de Datos, Big Data, Automatización, Consultorías, Formación.	\N	user	1	t	t
6	CD3 -Arq. - Salvador	salvadorcirio@gmail.com	scrypt:32768:8:1$hQFms7Eadh8ZGI1l$fb2da23880239487dd790ca064a00b3b309f2d31b649e1a5222c9ac877a50af68a462c2cbe242fc1ce8a8089fc3ca9c13c90e254a45de44dff3a043d073b725b	f	t	2025-09-16 18:30:47.767281	2025-09-30 10:49:12.235687	salvador	\N	Proyect Líder Licenciado en Sistemas	None	10000	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758890047/profiles/profile_6.png	None	None	\N	user	\N	t	t
17	claudio	claudio@datos.com	scrypt:32768:8:1$Afym1fD9gsZ1CeFZ$829454d82acf288bc59f43e398babeabbd1552c43cfd00eed604ed5bfc7e0f726c58647d70257a4f1bd91ac7dbbd4486a14a5588e608b13be67fc7d3a221b864	f	f	2025-09-30 12:33:09.261628	2025-09-30 12:35:50.819397	\N	\N	\N	\N	\N	\N	\N	\N	\N	senior_assistant	5	t	t
18	PozoProp	pozoprop@gmail.com	scrypt:32768:8:1$tu0YAlm8XNwQouXI$3d3c83171501e912c306e4814381595a1fd2d456062ee8e985c7ab05389e84e8f57c1570ca6cf79afee8e8de5088caef85e9b110c3797e9dab8170b067431364	f	t	2025-09-30 16:27:18.685369	2025-09-30 16:32:53.387712	pozoprop	\N	Arquitectura - Diseño - Construcción	Desarrollo, venta, construcción de edificios de departamentos.\n\n- Concepto de Casas en Altura - \nDiseñamos juntos tu  próximo departamento eligiendo los detalles.	20	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1759249970/profiles/profile_18.png	3251	Venta de departamentos construidos con tus ideas	\N	user	6	t	t
20	chavo	chavo@gmail.com	scrypt:32768:8:1$EkQXwKxUZFlGXpka$3a7bb26f91f09f47ceafab7785369ed046c1c0f108e793f6cc3cec72d3b997dea75ea32c219adce68d040b895d1c966f19acb0f7ff561a2cfa586ce51f91e9ac	f	f	2025-10-01 17:53:46.950833	2025-10-01 17:53:46.95084	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3	t	t
19	Agustín - Administración -	agustin@cd3.com	scrypt:32768:8:1$RlZcjRHYeQFMSJPk$165c1483b49ebebcb6f0a1fa8288f1f1872fc3b8551ec85759e270efd8e769ebc2fbb75daa71042b8e0dec807cb61e93376d64e24e013f244a4e5353d6489c46	f	f	2025-10-01 15:08:36.092781	2025-10-01 22:55:07.267287	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	5	t	t
4	El Vasquito	elvasquito16@gmail.com	scrypt:32768:8:1$nrSKnxpESVLPcpJk$b5db2f70f4f2b421dc3318fddd790cce734b90c0801f3fb4afaeaad80d204e6989b5d9ff778b38742531299f8565aa5b423cee39dce4d7d7ab34f4f33ccc2cb5	f	t	2025-09-15 22:53:36.025149	2025-10-06 14:21:00.585582	el-vasquito	\N	Corralón  y Materiales para la construcción	Una pequeña descripcion de la biografia/historia	30	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757977265/profiles/profile_4.png	1889	Materiales para la construcción\nHormigón Armado\nTransporte y logística	\N	user	1	t	t
3	Quique Spada	spadaenrique@gmail.com	scrypt:32768:8:1$hlSmrLyfceG66M6d$f1a61ebd1fdd2027a74f0560dc5bbbc4d4e8040410912bda192b81d84ce8ef6d99955752e78ac07344564aaf05c81fa68490bbc04d405ab68e0d1a97c94b3284	f	f	2025-09-15 15:57:34.892438	2025-10-10 23:56:53.483138	quique-spada	\N	Empresario - Dj	Socio fundador en el año 1979 de la Productora AUDIVISIÓN - hasta 1981 -\nPerfil · Creador digital\nPropietario y Creativo de SonrisasProducciones en sonrisas producciones\nGerente Propietario en sonrisas producciones	40	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757952072/profiles/profile_3.jpg	007	Entretenimientos - Diversión	\N	user	5	t	t
40	BanZai Show MC	banzai.minaclavero@gmail.com	scrypt:32768:8:1$1nPBsRWHEhqnQ9ay$a62b6ec78b4619a17d877e6a3a1bea9fc24f754584727f457d56205d67b6729176db44691245a483c74d48f7d95992532e25d2a39adf0243a2ed1ab2aa4636c7	f	t	2025-10-10 23:57:20.73104	2025-10-11 00:05:27.219901	banzai-show-mc	\N	Salón de Eventos y Entretenimientos	Cuando nace Banzai en Mina Clavero	29	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1760141126/profiles/profile_40.jpg	2235	Salón de Fiestas - Eventos y Entretenimientos\r\nMúsica - Noche - Dj's\r\nBar Nocturno\r\nPizzas - Lomitos - Hamburguesas	\N	user	1	t	t
39	noexistemail	noexistemail@correo.com	scrypt:32768:8:1$w97AF5BcH2HA6SM7$beeaedab044242dbed91986a810d03b84b8f1ffda8df332e484a4242c4677d085c288967d740fd6aaebfeff0134af4a65375ddc5441d1d63d3efe1d421482f97	f	f	2025-10-07 13:02:16.284058	2025-10-07 13:02:16.284058	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3	t	t
42	Martin S.	manifiestosolo.ok@gmail.com	scrypt:32768:8:1$JRYpmkyvnj4CjidP$55a5d7d340d807a79bcda1a468ea8d6076ce0e6846b884bb0b8ef5fd6f8b513b7fb223e624ab19ff9d600b94ef9f9c5bf5dcc1fb909a9ffe559a5a698569402a	f	t	2025-10-21 19:12:37.913945	2025-10-21 23:24:13.82921	martin-s	\N	Politólogo - Economista	Soy politólogo y economista graduado en la Universidad de Buenos Aires, con sólida formación en políticas públicas, análisis macroeconómico y gestión institucional. Durante mi trayectoria profesional integré equipos de gobierno, participando en proyectos estratégicos orientados a la modernización del Estado, la transparencia y la eficiencia en la administración pública. Me especializo en el diseño y evaluación de políticas públicas, comunicación estratégica y gestión del cambio en contextos de alta complejidad. Combino una mirada técnica con sensibilidad política y capacidad de articulación entre sectores público y privado. Apasionado por el análisis de coyuntura y la planificación a largo plazo, creo en el valor de los datos, la evidencia y la gestión profesional como pilares del desarrollo sostenible y la institucionalidad democrática.	10	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1761089052/profiles/profile_42.png	11523	- Análisis político y económico: Diagnóstico de escenarios, tendencias y riesgos para la toma de decisiones estratégicas.\r\n- Consultoría en comunicación y gestión pública: Diseño de estrategias de posicionamiento, narrativa institucional y gestión de crisis.\r\n- Asesoramiento en políticas públicas: Formulación, evaluación y seguimiento de programas orientados a resultados y transparencia.\r\n- Planeamiento estratégico: Asistencia en planificación, gestión de proyectos y evaluación de impacto.\r\n- Capacitación y conferencias: Formación en liderazgo, economía política y comunicación institucional.	\N	user	1	t	t
\.


--
-- TOC entry 5018 (class 0 OID 16667)
-- Dependencies: 244
-- Data for Name: visits; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.visits (id, ip_address, user_agent, path, created_at) FROM stdin;
883	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-01 22:50:10.734724
769	127.0.0.1	Go-http-client/1.1	/	2025-10-01 18:17:24.190295
770	127.0.0.1	Go-http-client/2.0	/	2025-10-01 18:17:32.700604
771	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 18:18:25.63701
772	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:18:26.241748
773	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:18:26.253134
774	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:18:38.53314
775	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:18:38.589342
776	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 18:18:55.320726
777	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:18:55.870851
778	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:18:55.884065
779	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:19:07.246872
780	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:19:07.940202
781	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:19:08.001264
782	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 18:19:26.447644
783	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:19:27.209254
784	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:19:28.097845
785	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:19:28.165427
786	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:20:06.965653
787	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:20:07.434423
788	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:20:07.460552
789	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 18:21:44.193559
790	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:21:44.912982
791	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:21:44.955259
792	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 20:37:47.893171
793	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 20:37:49.019177
794	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 20:37:49.028195
795	127.0.0.1	Go-http-client/1.1	/	2025-10-01 20:40:43.782799
796	127.0.0.1	Go-http-client/2.0	/	2025-10-01 20:40:46.269537
797	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 20:41:02.319357
798	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 20:41:03.165907
799	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 20:41:03.176396
800	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 20:41:34.863509
801	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 20:41:35.530857
802	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 20:41:35.551231
803	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 20:42:20.257959
804	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 20:42:20.72222
805	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 20:42:20.811222
806	127.0.0.1	Go-http-client/1.1	/	2025-10-01 21:58:16.26498
807	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:06:59.552946
808	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:07:01.235319
809	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:07:01.268495
810	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:08:13.813441
811	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:08:14.466396
812	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:08:14.86465
813	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-01 22:09:14.790282
269	127.0.0.1	Go-http-client/1.1	/	2025-10-01 12:29:33.061651
270	127.0.0.1	Go-http-client/2.0	/	2025-10-01 12:29:36.810437
271	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/profesional/astiazu-joseluis	2025-10-01 12:32:10.929736
272	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:32:11.471267
273	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:32:11.828808
274	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/profesional/astiazu-joseluis	2025-10-01 12:32:13.638834
275	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:32:14.054712
276	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:32:14.530701
277	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/profesionales	2025-10-01 12:32:21.947306
278	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:32:22.46992
279	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:32:22.474005
280	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/profesional/astiazu-joseluis	2025-10-01 12:32:56.219205
281	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:32:56.645827
282	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:32:56.678392
283	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:32:56.698789
284	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:32:56.772748
285	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/profesionales	2025-10-01 12:33:09.591836
286	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:33:09.94986
287	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:33:09.991375
288	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/	2025-10-01 12:33:45.462295
289	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:33:45.781308
290	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:33:45.814986
291	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:33:51.157479
292	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:33:51.162289
293	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin/dashboard	2025-10-01 12:34:10.621107
294	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:34:10.995044
295	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:34:11.028161
296	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 12:34:21.611596
297	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:34:22.793373
298	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:34:22.826565
299	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 12:35:06.116329
300	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:35:06.460722
301	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:35:06.661733
302	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 12:36:02.302666
303	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:36:02.713042
304	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:36:02.74581
305	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/portfolio	2025-10-01 12:36:10.530912
306	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:36:10.907692
307	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:36:10.963148
308	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/portfolio	2025-10-01 12:40:51.185755
309	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:40:51.556547
310	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:40:51.915033
311	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/	2025-10-01 12:41:52.656265
312	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:41:53.045808
313	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:41:53.392915
314	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:41:53.426487
315	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:41:53.440781
316	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/profesional/2/contactar	2025-10-01 12:48:54.032501
317	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:48:54.375425
318	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:48:54.380732
319	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/favicon-32x32.png	2025-10-01 12:48:55.794871
320	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/favicon-16x16.png	2025-10-01 12:48:56.007213
321	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:49:05.697905
322	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:49:05.703026
323	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:49:42.879879
324	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:49:42.884367
325	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:50:12.471954
326	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:50:12.863627
327	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:50:12.948593
328	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-agenda	2025-10-01 12:51:06.84183
329	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:51:07.765449
330	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:51:07.770392
331	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 12:52:27.888942
332	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 12:52:28.996659
333	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:52:29.731896
334	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:52:30.453967
335	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:52:30.467437
336	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 12:52:36.248594
337	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 12:52:36.982026
338	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:52:37.730926
339	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:52:38.482786
340	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:52:38.491012
341	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 12:53:18.140009
342	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 12:53:19.266493
343	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:53:20.504004
344	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:53:21.686856
345	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:53:21.691131
346	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/asistentes	2025-10-01 12:53:36.544035
347	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/default-assistant.png	2025-10-01 12:53:38.332286
348	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:53:38.338875
349	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:53:38.783458
350	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/profesional/salvador	2025-10-01 12:58:49.350643
351	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:58:50.309796
352	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:58:51.263592
353	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:58:51.271196
354	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 12:59:01.656661
355	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/	2025-10-01 12:59:01.787578
356	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:59:02.232562
357	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:59:02.296204
358	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 12:59:02.621751
359	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/og-image-datosconsultora.jpg	2025-10-01 12:59:03.490154
360	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/favicon-32x32.png	2025-10-01 12:59:03.494229
361	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:59:03.579519
362	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/favicon-16x16.png	2025-10-01 12:59:03.939915
363	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/apple-touch-icon.png	2025-10-01 12:59:03.951653
364	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:59:04.548359
365	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:59:04.559774
366	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:59:06.49542
367	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:59:06.526043
368	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 12:59:09.458112
369	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 12:59:10.423446
370	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 12:59:11.392562
371	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 12:59:12.356392
372	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 12:59:12.802943
373	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/seleccionar-perfil	2025-10-01 12:59:42.224873
374	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:59:42.6187
375	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:59:42.623339
376	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/iniciar-como	2025-10-01 12:59:45.841674
377	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/ver-tareas	2025-10-01 12:59:46.193461
378	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:59:46.601413
379	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:59:46.607438
380	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 12:59:58.524418
381	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 12:59:59.133179
382	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 12:59:59.15366
383	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 13:00:23.898983
384	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 13:00:24.4411
385	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 13:00:24.445937
884	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 22:50:10.984734
885	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:50:12.837812
886	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:50:12.979417
887	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:50:19.919574
888	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:50:21.413274
889	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:50:23.458254
890	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mis-equipos	2025-10-01 22:51:16.805104
891	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:51:23.994288
892	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:51:25.215025
893	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/perfil-equipo	2025-10-01 22:52:31.754177
894	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:52:33.774745
895	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:52:36.657161
896	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:52:47.992957
897	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:52:50.000826
898	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:52:51.299697
899	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 22:53:59.323761
900	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:00.186579
901	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:00.293028
902	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:04.008964
903	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:04.214049
904	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-01 22:54:16.067438
905	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:17.481543
906	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:18.055777
907	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-01 22:54:19.985528
908	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:20.652546
910	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-01 22:54:30.687025
911	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:31.259314
913	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/19/edit	2025-10-01 22:54:41.899287
914	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:42.05847
916	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/19/edit	2025-10-01 22:55:07.233076
917	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-01 22:55:07.649197
918	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:55:08.816137
920	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-01 22:55:29.466186
921	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:55:30.962815
923	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:55:37.566045
924	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:55:38.381495
926	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:55:50.822316
927	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:55:52.127525
929	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:56:15.196115
930	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:56:16.433459
933	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:59:14.044934
1126	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 14:38:09.699201
1127	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:38:10.300776
386	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil/editar	2025-10-01 13:08:08.296036
387	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 13:08:09.306391
388	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 13:08:09.310757
389	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/consultorio/nuevo	2025-10-01 13:08:15.627213
390	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 13:08:17.104167
391	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 13:08:17.117504
392	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/ver-tareas	2025-10-01 13:08:32.142706
393	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/seleccionar-perfil	2025-10-01 13:08:33.114212
394	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/mi-perfil	2025-10-01 13:08:34.074099
395	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 13:08:35.030931
396	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 13:08:35.03649
397	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/asistentes	2025-10-01 13:08:46.593737
398	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/css/datosconsultora.css	2025-10-01 13:08:48.076971
399	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/logo-datos.gif	2025-10-01 13:08:48.081116
400	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0	/static/img/default-assistant.png	2025-10-01 13:08:48.084651
401	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-01 13:11:39.797801
402	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:11:40.31042
403	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:11:40.65971
404	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-01 13:12:06.980262
405	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:12:07.373115
406	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:12:07.377081
407	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 13:12:17.455253
408	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:12:17.960693
409	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:12:17.96736
410	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 13:12:28.137171
411	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:12:28.799746
412	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:12:28.853903
413	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:12:36.009633
414	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:12:36.051511
415	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 13:13:29.251724
416	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:13:29.897493
417	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:13:29.943469
418	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/2/contactar	2025-10-01 13:15:57.52501
419	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:15:58.422535
420	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:15:59.503837
421	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-01 13:16:06.362555
422	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-01 13:16:07.312085
423	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:16:12.34591
424	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:16:12.350102
425	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 13:16:56.097561
426	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:16:57.058162
427	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:16:57.062968
428	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 13:17:35.055953
429	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:17:36.119529
430	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:17:36.128967
431	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 13:19:17.218515
432	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:19:18.023072
433	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:19:18.180345
434	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:19:28.370246
435	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:19:28.377858
436	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 13:20:27.929213
437	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:20:28.432061
438	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:20:28.836489
439	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-01 13:20:36.365667
440	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 13:20:36.673522
441	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:20:37.008661
442	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:20:37.038307
443	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 13:20:46.081765
444	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:20:46.518558
445	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:20:46.542051
446	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/8/editar	2025-10-01 13:20:58.698904
447	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 13:20:59.136903
448	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:20:59.504305
449	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-01 13:20:59.508715
450	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:20:59.903661
451	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 13:22:06.516459
452	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:22:07.061648
453	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:22:07.067243
454	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 13:23:06.604733
455	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:23:06.994052
456	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:23:06.999495
457	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:23:20.163272
458	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:23:20.577141
459	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 13:23:51.964749
460	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:23:52.382105
461	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:23:52.390511
462	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 13:24:06.771328
463	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 13:24:07.075936
464	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 13:24:07.498323
465	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:24:07.873107
466	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:24:07.913518
467	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 13:24:16.568492
468	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:24:17.046921
1888	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-04 15:39:46.917415
469	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:24:17.067746
470	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/8/editar	2025-10-01 13:24:39.768026
471	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:24:40.191715
472	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:24:40.224517
473	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 13:24:56.147473
474	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:24:56.510256
475	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:24:56.514736
476	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 13:25:00.823309
477	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:25:01.387433
478	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-01 13:25:01.44698
479	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:25:01.452286
480	127.0.0.1	Go-http-client/1.1	/	2025-10-01 13:32:26.895261
481	127.0.0.1	Go-http-client/2.0	/	2025-10-01 13:32:35.98309
482	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 13:43:27.380438
483	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 13:43:28.172172
484	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-01 13:43:28.192633
485	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 13:43:28.548673
486	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.049089
487	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.6488
488	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.673341
489	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.759784
490	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.85959
491	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:17.959804
492	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.057881
493	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.154782
494	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.250344
495	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.26919
496	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.366176
497	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.464399
498	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.55977
499	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:05:18.653289
500	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 14:11:35.556307
501	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 14:11:35.987264
502	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 14:11:36.00892
503	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:43.998825
504	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.389057
505	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.397806
506	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.405657
507	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.487983
508	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.499294
509	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.507556
510	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.592853
511	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.602837
512	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.611099
513	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.692927
514	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.703657
515	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:44.711886
516	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:45.452005
517	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:06:45.718683
518	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:06:46.052477
519	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:06:46.073163
520	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 15:07:14.824564
521	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:07:15.573972
522	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:07:15.580997
523	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 15:07:49.683432
524	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:07:50.303501
525	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:07:50.308432
526	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-01 15:07:50.312933
527	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:07:55.574189
528	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:07:56.737639
529	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:07:56.744274
530	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 15:08:35.276692
531	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 15:08:36.36892
532	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-01 15:08:36.855948
533	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:08:37.273472
534	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:08:37.278408
535	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 15:08:47.811037
536	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:08:48.146242
537	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:08:48.18579
538	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:08:54.231072
539	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:08:54.267989
540	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:09:12.92502
541	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:09:12.967799
542	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:10:11.884684
543	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:10:11.893209
544	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-01 15:10:34.116904
545	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:10:35.023964
546	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:10:35.076047
547	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-01 15:10:45.526804
548	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:10:46.900112
549	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:10:46.935969
550	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-01 15:10:51.198463
551	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:10:51.711063
552	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:10:51.763181
553	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/19/edit	2025-10-01 15:11:02.899552
554	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:11:03.577655
909	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:21.682844
912	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:54:32.111876
915	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:54:42.902248
919	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:55:09.381093
922	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:55:31.41986
925	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:55:40.04952
928	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:55:55.767291
931	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:56:18.942813
932	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 22:59:13.558588
934	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:59:14.104504
1128	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:38:11.699263
1129	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 14:38:29.527943
1130	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:38:30.379525
1131	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:38:33.09397
1132	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 14:39:02.965992
1133	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:39:05.357663
1134	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:39:05.768812
1135	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 14:42:45.092511
1136	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:42:51.132249
1137	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:42:53.403803
1138	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 14:45:36.133467
1139	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:45:37.978251
1140	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:45:40.704412
1141	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-02 14:45:48.69001
1142	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:45:50.253536
1143	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:45:52.480655
1144	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-02 14:45:53.54026
1351	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-02 22:21:03.842311
1352	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:21:04.422407
1353	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:21:04.77593
1354	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 22:21:12.656067
1355	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:21:13.119944
1356	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:21:13.438316
1357	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 22:21:20.320857
1358	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 22:24:00.130091
1359	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:00.263881
1360	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:00.588114
1361	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-02 22:24:10.169469
1362	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:11.223216
1363	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:11.466387
1364	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 22:24:17.998328
1365	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:18.434381
555	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:11:03.584857
556	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/19/edit	2025-10-01 15:11:16.065095
557	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-01 15:11:17.059035
558	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:11:17.41086
559	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:11:17.425099
560	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 15:11:26.474214
561	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:11:27.107884
562	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:11:27.113642
563	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:11:39.999466
564	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:11:40.092758
565	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 15:11:57.225745
566	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 15:11:57.499116
567	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 15:11:57.949086
568	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:11:58.395987
569	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:11:58.430255
570	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 15:12:15.878532
571	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:12:16.523772
572	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:12:16.562631
573	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-01 15:12:27.963599
574	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:12:28.38599
575	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:12:28.405525
576	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-01 15:13:14.858089
577	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 15:13:15.221849
578	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:13:15.698584
579	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:13:15.751317
580	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 15:13:31.69458
581	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 15:13:32.361522
582	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 15:13:32.792683
583	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:24.915916
584	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:25.516729
585	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:25.620584
586	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:25.718331
587	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:25.818704
588	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:25.915404
589	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.008049
590	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.103019
591	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.121753
592	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.21388
593	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.309461
594	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.403709
595	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.423265
596	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.51532
597	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:26.606628
598	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:31:26.995864
599	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:31:27.005269
600	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:31:28.410154
601	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:31:28.825323
602	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:31:28.831438
603	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/	2025-10-01 15:31:38.435779
604	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:31:38.852888
605	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:31:38.858257
606	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/og-image-datosconsultora.jpg	2025-10-01 15:31:39.468196
607	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/apple-touch-icon.png	2025-10-01 15:31:39.473225
608	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/favicon-32x32.png	2025-10-01 15:31:39.487594
609	127.0.0.1	NetworkingExtension/8621.3.11.10.3 Network/4277.140.33 iOS/18.6.2	/static/img/favicon-16x16.png	2025-10-01 15:31:39.508321
610	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:31:45.431256
611	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:31:45.437627
612	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/seleccionar-perfil	2025-10-01 15:32:21.495417
613	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:32:21.929842
614	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:32:21.987518
615	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/iniciar-como	2025-10-01 15:32:30.366725
616	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/ver-tareas	2025-10-01 15:32:30.702217
617	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:32:31.085197
618	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:32:31.09604
619	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/	2025-10-01 15:32:36.803672
620	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:32:37.394233
621	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:32:37.406658
622	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:32:37.414465
623	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:32:37.42589
624	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/portfolio	2025-10-01 15:33:19.68224
625	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:33:20.0818
626	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:33:20.091082
627	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/servicios/inteligencia-comercial	2025-10-01 15:33:39.033998
628	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:33:39.374176
629	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:33:39.415883
630	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:33:39.431303
631	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:33:39.441752
632	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 15:34:15.18844
633	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:34:15.957229
634	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:34:16.02654
635	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 15:39:24.894856
636	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 15:39:26.212188
637	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 15:39:26.219598
638	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:50.077618
639	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:50.694932
640	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:50.879231
641	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:51.004195
642	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:51.783876
643	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:51.907861
644	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:52.010072
645	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/admin	2025-10-01 16:21:52.495281
646	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 16:21:53.046753
647	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 16:21:53.538406
648	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 16:22:07.857677
649	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 16:22:08.572088
650	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 16:22:08.594139
651	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 16:22:59.573567
652	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 16:23:00.160223
653	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 16:23:00.164522
654	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/favicon-32x32.png	2025-10-01 16:23:05.411775
655	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/favicon-16x16.png	2025-10-01 16:23:05.743072
656	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/apple-touch-icon.png	2025-10-01 16:23:05.789271
657	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/perfil-equipo	2025-10-01 16:23:43.196807
658	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 16:23:43.620078
659	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 16:23:43.657519
660	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/dashboard	2025-10-01 16:24:01.342928
661	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/css/datosconsultora.css	2025-10-01 16:24:01.795029
662	127.0.0.1	Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 Safari/604.1	/static/img/logo-datos.gif	2025-10-01 16:24:01.837668
663	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/favicon-32x32.png	2025-10-01 16:26:49.863737
664	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/apple-touch-icon.png	2025-10-01 16:26:50.23475
665	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile Safari/537.36	/static/img/favicon-16x16.png	2025-10-01 16:26:52.698753
666	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/2/contactar	2025-10-01 17:43:46.554851
667	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:43:47.087224
668	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:43:47.102798
669	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-01 17:43:48.032797
670	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-01 17:43:48.414622
671	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/2/contactar	2025-10-01 17:43:51.814903
672	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:43:52.286702
673	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:43:52.294712
674	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:44:12.962275
675	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:44:13.046819
676	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:44:18.675577
677	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:44:18.775583
678	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:44:43.806533
679	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:44:43.873617
680	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:45:03.004142
681	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:45:03.017084
682	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	/static/img/favicon-32x32.png	2025-10-01 17:45:06.680192
683	127.0.0.1	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36	/static/img/favicon-16x16.png	2025-10-01 17:45:07.158832
684	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 17:45:11.581503
685	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 17:45:12.76976
686	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 17:45:14.091212
687	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:45:15.374877
688	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:45:15.381856
689	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 17:45:19.059293
690	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:45:20.314175
691	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:45:20.337769
692	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:49:03.578654
693	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:49:05.09231
694	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:49:05.144032
695	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-01 17:49:43.908401
696	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:49:45.051993
697	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:49:45.11197
698	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-01 17:51:20.494478
699	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 17:51:21.577284
700	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:51:22.588505
701	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:51:22.63764
702	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:51:29.024221
703	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:51:30.131821
704	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:51:30.179073
705	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 17:52:17.742569
706	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:52:18.832892
707	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:52:19.23053
708	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-01 17:53:46.238722
709	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-01 17:53:47.942186
710	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 17:53:48.990911
711	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:53:49.99164
712	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:53:50.006692
713	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:53:55.368017
714	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	/	2025-10-01 17:53:56.489323
935	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 23:14:09.852152
715	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:53:56.63838
716	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:53:56.691571
717	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:53:57.040522
718	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:53:57.056123
719	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 17:54:03.575741
720	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 17:54:04.602698
721	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:54:05.606526
722	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:54:05.661323
723	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:54:54.325525
724	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:54:55.487988
725	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:54:55.493087
726	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 17:55:06.077709
727	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 17:55:07.069192
728	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:55:08.082064
729	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:55:08.144799
730	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:59:02.780239
731	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:59:03.275512
732	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:59:03.305652
733	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 17:59:28.198719
734	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 17:59:28.977832
735	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 17:59:29.016996
736	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:00:50.523842
737	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:00:51.742666
738	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:00:51.748452
739	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/perfil-equipo	2025-10-01 18:01:00.389241
740	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:01:00.831673
741	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:01:00.871261
742	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mis-equipos	2025-10-01 18:01:21.794503
743	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:01:23.183682
744	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:01:23.248218
745	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:01:40.994927
746	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:01:41.395813
936	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:14:13.367401
937	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:14:13.944566
938	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:14:21.856432
939	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:14:21.929674
940	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 23:14:51.768982
941	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 23:14:52.392049
942	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 23:14:53.267073
943	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:14:55.237349
944	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:14:55.372121
945	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:15:04.07942
1919	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-05 20:29:36.567064
946	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 23:24:03.62301
947	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:24:15.489588
948	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:24:17.586815
949	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:24:18.649354
950	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 23:27:43.26114
951	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:27:43.889576
952	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:27:48.944417
953	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 23:28:23.744324
954	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:28:24.013859
955	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:28:24.039252
956	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:28:26.824008
957	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:28:26.850369
958	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 23:28:41.211656
959	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:28:42.50369
960	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:28:42.997844
961	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:28:55.450865
962	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:28:56.484102
963	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:28:57.248773
964	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:29:20.269992
965	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:29:20.840324
966	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:29:21.577651
1145	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 16:47:16.395886
1146	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:47:20.062987
1147	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:47:20.658709
1148	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:47:30.585765
1149	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:47:31.294772
1150	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:47:32.81679
1151	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:48:51.364075
1152	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:48:53.212274
1153	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:48:54.865648
1366	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:18.459821
1367	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/eventos/vigilanciatraslasierra	2025-10-02 22:24:20.941783
1368	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:21.424221
1369	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:21.508206
1370	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 22:24:24.481445
1371	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:24.61231
1372	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:24.84767
1373	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 22:24:39.78271
1374	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:40.088384
1375	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:40.135258
1376	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 22:24:49.989576
1377	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:50.531586
967	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:51:56.351335
968	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:51:57.862124
969	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:51:58.65121
970	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:52:15.958378
971	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:52:16.737699
972	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:52:17.872015
973	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 23:53:21.624933
974	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:53:22.522419
975	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:53:22.975558
976	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 23:53:30.38252
977	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:53:30.847381
978	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:53:30.866914
979	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:53:42.133858
980	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 23:53:52.873931
981	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:53:53.57512
982	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:53:56.579612
983	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-01 23:54:22.04718
984	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:54:26.342233
985	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:54:26.812955
986	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 23:54:44.804225
987	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 23:54:46.269115
988	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 23:54:47.488392
1154	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:52:49.402025
1155	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:52:54.534018
1156	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:52:55.59899
1157	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:53:17.766165
1158	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 16:53:21.30143
1159	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:53:30.814899
1160	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:53:31.21042
1161	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:53:33.354039
1162	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 16:54:00.309936
1163	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 16:54:02.627872
1164	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 16:54:04.043935
1378	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:50.612642
1379	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-02 22:24:54.317347
1380	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:55.341792
1381	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:55.731453
1382	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 22:24:57.866289
1383	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:24:58.235441
1384	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:24:58.420018
1385	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/eventos/el-vasquito	2025-10-02 22:25:01.486029
1386	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:25:01.823929
989	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 11:32:40.777709
990	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:32:41.964265
991	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:32:42.09415
992	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-02 11:32:48.018618
993	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-02 11:32:48.832119
994	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 11:33:00.898346
995	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 11:33:01.191322
996	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:33:01.852473
997	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:33:01.938412
998	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 11:33:08.434667
999	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:33:09.37708
1000	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:33:09.393679
1165	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 17:08:31.272576
1166	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:08:35.991465
1167	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 17:08:43.949721
1168	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:08:44.090352
1169	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:08:45.135792
1170	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 17:09:27.350549
1171	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:09:27.801165
1172	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:09:29.485296
1173	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:09:29.873004
1174	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:09:45.760212
1175	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:09:50.975704
1176	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:09:51.4181
1177	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-02 17:10:10.928953
1178	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:22:23.942195
1179	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:22:26.986721
1180	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:22:28.213322
1181	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-02 17:22:34.775534
1182	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:22:34.982565
1183	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:22:38.138913
1184	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:22:47.887748
1185	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:22:48.8077
1186	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:22:49.041104
1187	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 17:23:57.300018
1188	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:23:58.807882
1189	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:24:01.088707
1190	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/salvador	2025-10-02 17:24:06.369145
1191	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:24:06.405273
1192	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:24:08.14996
1193	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:24:08.273012
1194	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:24:24.726144
1195	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:24:26.851702
1001	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:33:14.809343
1002	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:33:16.367004
1003	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-02 11:33:33.927024
1004	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-02 11:33:35.87141
1005	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-02 11:33:36.151695
1006	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:33:37.577025
1007	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:33:37.874885
1008	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 11:34:09.35031
1009	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:34:09.632543
1010	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:34:10.739509
1011	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-02 11:34:31.499326
1012	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:34:33.189308
1013	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:34:33.26646
1196	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:24:26.930802
1197	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 17:24:32.570626
1198	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:24:33.539407
1199	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:24:34.40418
1200	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/salvador	2025-10-02 17:24:40.354557
1201	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:24:41.1495
1202	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:24:43.681806
1387	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:25:02.227267
1388	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 22:25:04.391891
1389	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:25:04.696584
1390	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:25:04.709275
1465	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 13:16:19.353779
1466	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:16:20.987131
1467	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:16:21.66293
1468	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 13:16:28.997134
1469	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:16:30.17246
1470	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:16:32.616866
1471	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 13:16:37.639484
1472	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:16:39.353888
1473	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:16:40.397863
1474	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 13:16:42.579569
1475	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:16:44.114284
1476	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:16:44.635781
1477	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 13:17:25.755168
1478	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 13:17:25.85527
1479	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:17:28.501344
1480	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:17:28.564821
1481	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 13:17:35.623625
1482	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:17:35.737886
1014	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 11:55:03.051395
1015	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:55:06.459698
1016	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:55:07.255616
1017	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:58:00.528072
1018	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:58:01.045662
1019	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-02 11:58:26.827155
1020	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:58:29.516685
1021	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:58:29.545003
1022	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 11:58:36.386992
1023	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:58:37.981765
1024	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:58:39.066269
1025	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-02 11:58:54.972474
1026	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 11:58:56.119973
1027	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 11:58:59.470653
1203	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:36:29.50245
1204	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:37:09.378702
1205	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:37:33.780348
1206	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:39:33.146881
1207	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:39:33.264074
1208	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:39:34.151795
1209	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/servicios/inteligencia-comercial	2025-10-02 17:40:00.326934
1210	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:40:01.452457
1211	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:40:02.154738
1391	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 23:17:53.290203
1392	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:17:54.03388
1393	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:17:54.343239
1394	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-02 23:17:56.410902
1395	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:17:56.697044
1396	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:17:56.764431
1397	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 23:17:59.569688
1398	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:17:59.846064
1399	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:17:59.957395
1400	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:18:02.080505
1401	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:18:02.09516
1402	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 23:18:17.016025
1403	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:18:18.143009
1404	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:18:18.771445
1405	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-02 23:18:36.133304
1483	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:17:39.930878
1484	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 13:18:15.762031
1485	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 13:18:15.833808
1486	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:18:17.151231
1487	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:18:17.404658
1028	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 12:16:46.340857
1029	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:16:49.255492
1030	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:16:49.617807
1031	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:16:58.748926
1032	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:17:00.292916
1212	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:45:01.106834
1213	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:45:01.186913
1214	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:45:18.211858
1215	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:45:19.45841
1216	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:45:19.692799
1217	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 17:45:24.941562
1218	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:45:25.467943
1219	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:45:27.62182
1220	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 17:45:59.376226
1221	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 17:45:59.682387
1222	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:46:02.266942
1223	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:46:02.679059
1224	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:46:13.908412
1225	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:46:14.468977
1226	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:46:15.784452
1227	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-02 17:46:31.267842
1228	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:46:32.127734
1229	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:46:34.975479
1230	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:46:39.758337
1231	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:46:40.945876
1232	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:46:43.275539
1233	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mis-equipos	2025-10-02 17:46:47.571573
1234	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 17:46:47.662396
1235	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:46:48.854813
1236	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:46:49.201508
1237	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:46:59.386883
1238	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:47:00.235537
1239	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:47:00.523631
1240	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/salvador	2025-10-02 17:47:09.545401
1241	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:47:09.613762
1242	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:47:12.531333
1243	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:47:12.600669
1244	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 17:48:40.71767
1245	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 17:48:41.919859
1246	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 17:48:42.998992
1406	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 23:22:03.612307
1407	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-02 23:22:18.718239
1408	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-02 23:23:53.489222
1033	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 12:18:06.895404
1247	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:08:05.705068
1248	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:08:07.891173
1249	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:08:09.70861
1250	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/7/editar	2025-10-02 18:12:56.808343
1251	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:13:01.636128
1252	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:13:02.516673
1253	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/7/editar	2025-10-02 18:13:22.520567
1254	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-agenda	2025-10-02 18:13:22.808664
1255	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:13:24.49133
1256	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:13:25.065569
1257	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:13:38.504459
1258	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:13:39.445895
1259	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:13:42.536329
1260	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 18:13:55.066503
1261	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:13:56.931308
1262	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:13:57.07389
1263	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 18:14:01.713686
1264	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:14:02.146314
1265	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:14:03.356313
1266	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/salvador	2025-10-02 18:14:09.156787
1267	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:14:10.528412
1409	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:23:53.723113
1410	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:23:54.061994
1411	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-02 23:23:58.169537
1412	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-02 23:28:27.776972
1413	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:28:28.20472
1414	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:28:28.442026
1415	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-02 23:30:11.756253
1416	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-02 23:30:12.484787
1417	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:30:12.939397
1418	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:30:13.360307
1419	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-02 23:30:21.891334
1420	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:30:22.280017
1421	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:30:22.855229
1422	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-02 23:30:37.405485
1423	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-02 23:30:37.750221
1424	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:30:38.351314
1425	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:30:38.760506
1488	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 13:18:24.917577
1489	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:18:26.075814
1490	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:18:26.593891
1945	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-06 14:14:03.868826
1034	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 12:19:12.588205
1035	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:19:12.945637
1036	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:19:13.629248
1037	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 12:20:34.092499
1038	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:20:36.44852
1039	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:20:37.437809
1040	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-02 12:21:02.206097
1041	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 12:25:51.314554
1042	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:25:51.79406
1043	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:25:57.34549
1044	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 12:27:42.663003
1045	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:27:44.174277
1046	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:27:46.055192
1047	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 12:28:21.039608
1048	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:28:22.671981
1049	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:28:24.610512
1268	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:14:12.823405
1426	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 23:30:53.285859
1427	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:30:55.872365
1428	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:30:55.882127
1429	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 23:31:01.930656
1430	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:31:02.499028
1431	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:31:05.369239
1432	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 23:31:09.659408
1433	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:31:09.980709
1434	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:31:10.490488
1435	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-02 23:31:14.05945
1436	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:31:14.480361
1437	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:31:17.269994
1438	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-02 23:37:33.604994
1439	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 23:37:34.069447
1440	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 23:37:34.320035
1491	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 13:18:33.813835
1492	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:18:34.731832
1493	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:18:36.785118
1494	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 13:18:42.249638
1495	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:18:43.689131
1496	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:18:45.844961
1497	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 13:18:48.310852
1498	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 13:19:37.426092
1499	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:19:37.548163
1500	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:19:38.556012
1050	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 12:35:19.328185
1051	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:35:20.330171
1052	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:35:21.307251
1053	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-02 12:35:32.932584
1054	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-02 12:57:37.739382
1055	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-02 12:58:37.902753
1056	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-02 12:59:08.42757
1057	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 12:59:09.518422
1058	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 12:59:09.757688
1269	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/salvador	2025-10-02 18:30:42.95713
1270	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:30:43.491324
1271	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:30:44.290176
1272	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:30:49.26738
1273	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:30:51.364988
1274	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:31:00.07387
1275	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:31:01.935254
1276	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:31:12.493202
1277	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:31:13.053764
1278	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:31:18.390845
1279	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:31:20.634077
1280	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:31:24.859307
1281	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:31:24.873957
1282	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:31:45.252029
1283	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:31:45.566492
1284	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-02 18:32:01.754493
1285	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:03.055316
1286	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:03.305813
1287	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-02 18:32:10.938376
1288	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:11.573155
1289	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:14.47706
1290	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-02 18:32:16.808676
1291	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:17.568951
1292	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:19.699877
1293	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 18:32:31.412644
1294	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:33.264263
1295	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:33.281841
1296	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:39.552058
1297	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:41.881316
1298	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/auth/register	2025-10-02 18:32:44.545865
1299	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:32:44.754851
1300	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:32:46.819861
1301	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/auth/register	2025-10-02 18:33:18.423382
1059	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 13:06:55.458245
1060	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:06:55.800055
1061	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:06:58.262042
1062	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 13:07:04.498552
1063	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:07:07.274994
1064	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:07:07.463481
1065	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 13:07:17.445217
1066	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:07:17.705967
1067	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:07:20.891607
1068	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-02 13:07:45.463123
1069	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:07:45.630113
1070	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:07:48.90121
1071	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/publications	2025-10-02 13:08:40.023304
1072	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:08:42.730905
1073	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:08:44.111802
1074	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:24:57.953961
1075	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:24:59.299705
1076	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-02 13:25:22.083591
1077	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:25:23.355606
1078	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:25:24.477711
1079	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-02 13:26:42.781335
1302	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:33:20.338482
1303	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:33:20.763301
1304	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-02 18:33:36.26427
1305	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:33:37.444485
1306	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:33:38.297049
1307	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:33:45.017959
1308	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:33:46.062919
1309	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:33:46.169364
1310	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-02 18:33:51.816515
1311	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:33:52.535282
1312	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:33:54.28827
1313	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-02 18:35:06.128895
1314	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:35:09.441498
1315	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:35:10.671517
1316	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:35:11.540686
1317	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 18:35:45.105211
1441	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 00:05:57.166238
1501	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 13:19:52.16286
1502	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:19:52.832806
1503	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:19:53.383606
1504	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 13:19:58.688447
1080	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-02 13:33:15.302506
1081	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 13:33:15.37575
1082	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:33:16.645805
1083	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-02 13:33:18.865602
1084	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:33:19.395893
1085	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-02 13:33:26.262316
1086	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-02 13:33:26.545525
1087	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:33:27.927397
1088	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:33:29.138376
1089	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 13:34:27.923372
1090	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:34:29.09723
1091	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:34:32.233557
1318	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:45:00.972359
1319	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 18:45:19.076931
1320	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:45:19.26297
1321	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:45:20.632157
1322	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-02 18:46:29.63482
1323	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 18:46:29.762262
1324	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:46:31.211715
1325	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:46:31.352648
1326	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 18:47:10.566778
1327	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:47:10.841199
1328	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:47:10.846083
1329	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 18:47:14.126945
1330	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:47:14.750014
1331	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:47:14.859391
1332	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 18:47:26.028691
1333	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 18:47:26.636132
1334	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 18:47:27.309983
1442	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 10:39:42.550556
1505	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:19:58.787083
1506	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:20:00.605497
1507	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:20:16.792023
1508	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:20:19.303329
1509	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 13:20:34.009341
1510	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:20:35.930784
1511	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:20:36.057739
1512	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categorias	2025-10-03 13:20:39.716543
1513	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:20:41.209753
1514	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:20:43.308937
1515	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categoria/nueva	2025-10-03 13:20:45.284094
1516	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 13:20:46.825154
1092	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 13:38:28.963941
1093	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:38:30.838023
1094	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:38:30.896615
1095	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:38:37.767436
1096	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:38:38.09166
1097	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 13:38:51.843063
1098	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 13:41:23.408736
1099	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:41:23.585495
1100	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:41:25.686639
1101	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 13:41:37.527332
1102	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:41:41.660755
1103	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:41:41.753536
1104	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:41:47.233684
1105	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:41:47.90851
1106	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-02 13:42:07.004797
1107	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:42:09.45409
1108	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:42:10.24464
1109	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-02 13:42:17.47875
1335	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 20:04:12.848595
1336	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 20:04:13.298802
1337	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 20:04:14.599136
1443	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 11:52:19.013995
1444	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-03 11:52:24.491202
1445	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-03 11:52:26.287643
1446	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:52:34.34745
1447	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:52:34.944149
1448	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 11:52:51.458309
1449	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:52:53.150738
1450	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:52:53.311874
1451	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 11:53:04.868367
1452	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 11:56:38.894731
1453	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:56:39.018759
1454	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:56:40.134028
1455	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 11:56:46.666448
1456	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:56:47.974103
1457	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:56:49.115738
1458	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 11:57:29.8816
1459	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:57:30.257584
1460	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:57:32.242021
1461	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 11:57:56.309634
1462	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 11:57:59.635903
1463	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 11:58:00.521182
2045	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-06 15:56:30.77113
1110	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-02 13:46:49.545162
1111	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:46:49.957279
1112	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:46:51.793766
1113	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-02 13:46:52.870947
1114	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 13:47:09.288442
1115	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 13:47:12.172805
1116	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 13:47:13.677736
1338	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-02 21:03:13.055512
1339	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 21:03:14.341685
1340	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 21:03:14.511609
1341	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 21:03:20.465405
1342	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 21:03:20.991792
1343	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 21:03:21.637319
1344	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-02 21:03:29.391463
1464	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 12:01:50.233615
1517	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 13:20:48.880883
1518	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categoria/nueva	2025-10-03 13:21:02.676409
1519	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categorias	2025-10-03 13:21:02.998494
1520	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categorias	2025-10-03 15:11:40.743808
1521	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/categorias	2025-10-03 15:17:01.158477
1522	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:17:03.101407
747	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:01:41.425989
748	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 18:01:58.925427
749	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 18:01:59.252625
750	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:01:59.688687
751	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:01:59.714225
752	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 18:02:29.231622
753	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:02:29.740214
754	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:02:29.744827
755	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:02:36.353452
756	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:02:36.763193
757	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-01 18:02:56.908749
758	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:02:57.437412
759	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:02:57.442808
760	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 18:03:03.896877
761	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:03:05.064469
762	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:03:05.081982
763	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 18:03:11.72671
764	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:03:12.1074
765	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:03:12.145391
766	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 18:04:36.443155
767	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 18:04:36.950637
768	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 18:04:36.96348
814	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:09:15.325108
815	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:09:15.332272
816	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-01 22:09:28.700753
817	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:09:29.031626
818	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:09:29.48798
819	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:09:29.615045
820	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:09:54.139498
821	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:09:54.477156
822	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:09:54.549692
823	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:02.819777
824	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:03.26432
825	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:03.271079
826	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:13.734459
827	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:14.400941
828	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:14.788767
829	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:33.1042
830	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:33.587251
831	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:33.602193
832	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:40.337449
833	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:40.839606
834	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:40.8512
835	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:48.518276
836	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:49.161207
837	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:49.197799
838	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:10:56.235884
839	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:10:56.853119
840	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:10:56.861146
841	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/60/editar	2025-10-01 22:11:10.403414
842	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:11:10.792684
843	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:11:10.798644
844	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/ver-tareas	2025-10-01 22:12:28.794241
845	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:12:29.338702
846	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:12:29.343628
847	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:12:45.371606
848	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:12:45.957048
849	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:12:45.970768
850	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:13:08.684206
851	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:13:09.476532
852	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:13:09.50366
853	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-01 22:14:09.720386
854	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:14:10.303457
855	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:14:10.381653
1799	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 20:28:07.081794
856	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:14:21.203075
857	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:14:21.2088
858	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-01 22:14:37.46823
859	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:14:38.016813
860	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:14:38.030466
861	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:16:01.335005
862	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:18:19.482272
863	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:18:43.639972
864	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:18:51.231704
865	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:18:59.861747
866	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:06.621258
867	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:14.607533
868	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:20.083468
869	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:27.311409
870	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:33.278713
871	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:41.066361
872	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:48.58228
873	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:19:54.832513
874	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:20:02.016771
875	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:20:08.49943
876	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/export-data	2025-10-01 22:20:14.757329
877	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-01 22:49:33.881063
878	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:49:45.119682
879	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:49:45.514231
880	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-01 22:50:02.346285
881	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-01 22:50:04.706706
882	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-01 22:50:04.796553
1117	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 14:33:03.083696
1118	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:33:07.746934
1119	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:33:08.219599
1120	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 14:34:02.874138
1121	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:34:04.579269
1122	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:34:06.56566
1123	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-02 14:36:19.093224
1124	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 14:36:21.701702
1125	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 14:36:22.02593
1345	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 22:20:50.409758
1346	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:20:50.810162
1347	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:20:50.899033
1348	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-02 22:20:56.086694
1349	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-02 22:20:57.035942
1350	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-02 22:20:57.266419
1851	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 21:31:42.39118
1523	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:17:03.738144
1524	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 15:17:44.092855
1525	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:17:46.048479
1526	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:17:47.191091
1527	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 15:17:51.847968
1528	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:17:52.498375
1529	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:17:54.554593
1530	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 15:17:56.918922
1531	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:17:57.964853
1532	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:18:00.268142
1533	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/subir-imagen	2025-10-03 15:18:21.189174
1534	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 15:18:22.719495
1535	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:18:24.513495
1536	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:18:24.62385
1537	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 15:18:55.561295
1538	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 15:18:55.641378
1539	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:18:57.01007
1540	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:18:57.430006
1541	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 15:19:15.965714
1542	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:16.222556
1543	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:16.251855
1544	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 15:19:19.686529
1545	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:20.449246
1546	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:20.887736
1547	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 15:19:27.797121
1548	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:28.951455
1549	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:29.166304
1550	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 15:19:34.75485
1551	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:35.43651
1552	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:35.470693
1553	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 15:19:45.610156
1554	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:46.026187
1555	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:46.318676
1556	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 15:19:49.684011
1557	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:19:49.769947
1558	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:19:50.064881
1559	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 15:20:24.623048
1560	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:20:26.140671
1561	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:20:26.978587
1562	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 15:22:22.421042
1563	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:22:22.592433
1564	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:22:25.815187
1565	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:22:27.071082
1566	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:22:28.552091
1567	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:22:28.916354
1568	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:25:36.927965
1569	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:25:37.079824
1570	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:25:38.253695
1571	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:40:23.377984
1572	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:40:26.44058
1573	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:40:26.685706
1574	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:40:39.309638
1575	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:40:39.938565
1576	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:40:41.699359
1577	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:43:19.620357
1578	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 15:43:33.844931
1579	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 15:43:34.833242
1580	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 15:43:35.417245
1581	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 16:24:47.174078
1582	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 16:25:14.546021
1583	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:25:14.607547
1584	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:25:16.362975
1585	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:25:17.388398
1586	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:25:29.838478
1587	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:25:30.684712
1588	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:25:33.106172
1589	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:27:12.558499
1590	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:27:14.795386
1591	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:27:16.006361
1592	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:27:16.027846
1593	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:27:41.867519
1594	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:27:42.299714
1595	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:27:43.489643
1596	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:27:44.339279
1597	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:27:48.536676
1598	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:27:49.940039
1599	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:27:50.053325
1600	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:27:53.717991
1601	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:27:54.200428
1602	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:27:56.973951
1603	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:28:03.174339
1604	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:28:03.245794
1605	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:04.967854
1606	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:05.164638
1607	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:28:08.893755
1608	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:10.68971
1609	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:12.63753
1610	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:28:17.666985
1611	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:28:17.819328
1612	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:18.665064
1613	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:20.308669
1614	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:28:21.882449
1615	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:21.994757
1616	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:25.920661
1617	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:28:27.229785
1618	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:27.648738
1619	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:28.554045
1620	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:28:32.473604
1621	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:32.898423
1622	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:35.63581
1623	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/subir-imagen	2025-10-03 16:28:50.669975
1624	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:28:51.104557
1625	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:28:53.000616
1626	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:28:53.053352
1627	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:28:58.822574
1628	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:28:59.102858
1629	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:29:00.153183
1630	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:29:00.585817
1631	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:29:08.590947
1632	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:29:09.167138
1633	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:29:09.660317
1634	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:32:55.941436
1635	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:32:56.189493
1636	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:32:58.305286
1637	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:33:13.303812
1638	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:33:13.998163
1639	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:33:15.463061
1640	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:33:15.685723
1641	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:33:26.789594
1642	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:33:27.366762
1643	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:33:27.952714
1644	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:33:28.622661
1645	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:33:34.970031
1646	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:33:35.041323
1647	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:33:36.223487
1648	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:33:36.763545
1649	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 16:33:43.802346
1650	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:33:44.003518
1651	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:33:48.326905
1652	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:33:50.262027
1653	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:33:50.695633
1654	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:33:50.716142
1655	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 16:45:22.677397
1656	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 16:45:23.56219
1657	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:45:26.766881
1658	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:45:27.725409
1659	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:45:38.089026
1660	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:45:39.634971
1661	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:45:40.758053
1662	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:45:48.566901
1663	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:45:49.489783
1664	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:45:50.082573
1665	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:46:02.547332
1666	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:46:03.594728
1667	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:46:04.469956
1668	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:46:04.549344
1669	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:47:10.547081
1670	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:47:11.270736
1671	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:47:11.978768
1672	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:51:23.103086
1673	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:51:23.814539
1674	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:51:30.215624
1675	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:51:30.574036
1676	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:51:53.956632
1677	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:51:55.900539
1678	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:51:57.466998
1679	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:51:59.323013
1680	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:52:14.068606
1681	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:52:15.352345
1682	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:52:16.827
1683	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:52:16.96958
1684	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/subir-imagen	2025-10-03 16:52:37.490758
1685	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:52:40.214478
1686	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:52:42.533891
1687	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:52:42.884485
1688	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-03 16:52:51.411619
1689	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:52:54.229094
1690	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:52:58.456283
1691	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:52:59.227786
1694	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:53:11.464518
1697	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:53:51.064437
1701	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:54:05.393026
1703	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:54:09.833604
1704	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:54:11.858573
1706	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 16:54:19.031658
1707	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:54:19.588315
1709	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 16:57:55.815604
1710	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:57:56.082219
1711	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:57:58.124618
1713	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 16:58:05.901388
1714	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:58:06.195337
1716	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/subir-imagen	2025-10-03 16:58:20.173339
1717	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 16:58:21.242218
1718	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:58:22.639731
1720	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/subir-imagen	2025-10-03 16:58:36.009798
1721	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 16:58:37.908295
1722	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:58:39.397117
1724	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/subir-imagen	2025-10-03 16:58:52.299394
1725	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 16:58:55.764842
1726	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:58:57.178947
1728	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 16:59:05.222184
1731	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:59:07.563081
1734	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:59:16.498431
1737	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:59:35.149918
1740	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:59:41.422171
2285	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/subir-imagen	2025-10-06 18:25:35.544613
2286	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:25:36.110062
2287	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:25:37.947026
2288	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:25:38.112067
2289	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:25:46.26904
2290	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:25:46.585457
2291	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:25:49.142656
2292	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:25:49.16414
2293	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-06 18:26:04.438502
2294	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:26:04.698275
2295	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:26:04.908243
2296	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 18:26:08.11341
2297	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:26:08.800928
2298	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:26:09.068514
2299	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-06 18:26:15.652688
1692	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:53:09.629494
1693	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:53:10.754534
1695	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:53:48.927159
1696	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:53:49.166426
1698	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/subir-imagen	2025-10-03 16:54:02.761107
1699	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:54:03.635157
1700	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:54:04.535577
1702	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/1/editar	2025-10-03 16:54:09.527929
1705	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:54:12.460154
1708	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:54:22.051775
1712	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:57:58.267348
1715	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:58:08.753531
1719	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:58:22.664145
1723	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:58:39.567044
1727	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 16:58:57.929953
1729	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 16:59:05.313982
1730	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:59:07.468346
1732	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:59:14.556961
1733	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:59:15.029634
1735	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 16:59:34.160631
1736	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:59:34.646976
1738	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 16:59:39.461588
1739	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 16:59:40.261907
1741	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 17:12:23.938422
1742	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:12:26.463408
1743	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:12:28.242766
1744	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 17:33:36.785623
1745	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:33:37.616215
1746	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:33:40.153894
1747	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 17:34:57.094864
1748	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 17:35:10.679775
1749	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:35:11.137798
1750	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:35:11.176862
1751	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 17:35:37.946774
1752	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:35:39.181675
1753	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:35:40.775479
1754	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 17:53:12.151046
1755	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:53:12.898142
1756	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:53:14.336176
1757	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 17:54:20.914029
1758	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:54:21.36619
1759	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:54:21.44432
1760	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 17:55:03.372929
1761	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 17:55:04.057528
1762	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 17:55:05.772914
1763	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 17:55:10.524047
1764	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 18:04:45.469508
1765	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 18:05:21.591276
1766	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 18:07:37.122003
1767	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:07:37.610301
1768	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:07:38.186491
1769	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 18:07:50.17467
1770	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:07:51.196186
1771	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:07:51.921797
1772	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 18:37:30.383346
1773	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:37:32.782348
1774	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:37:34.195477
1775	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 18:37:52.596447
1776	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:37:53.486126
1777	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:37:53.524213
1778	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 18:45:50.867989
1779	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:45:51.046217
1780	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:45:52.652695
1781	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 18:47:15.957632
1782	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 18:47:16.145139
1783	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 18:47:17.268711
1784	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 19:04:03.166168
1785	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 19:04:06.076904
1786	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 19:04:06.636492
1787	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 19:55:49.82864
1788	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 19:55:51.882217
1789	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 19:55:53.974293
1790	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 19:55:58.06036
1791	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 19:55:58.395327
1792	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 19:56:00.684465
1793	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 20:06:07.763243
1794	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:06:08.916595
1795	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:06:11.783393
1796	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 20:06:32.245476
1797	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:06:32.358759
1798	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:06:35.332974
2300	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:26:16.205439
2301	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:26:16.667367
2302	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 18:26:20.997078
1800	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:28:08.192671
1801	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:28:08.346974
1802	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-03 20:28:14.79396
1803	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:28:15.619177
1804	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:28:16.085989
1805	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 20:28:23.673149
1806	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:28:24.296215
1807	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:28:25.540887
1808	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 20:28:31.197808
1809	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:28:31.453676
1810	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:28:33.997703
1811	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/3/editar	2025-10-03 20:40:53.581297
1812	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:40:54.51981
1813	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:40:56.87682
1814	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 20:41:55.166803
1815	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:41:55.94418
1816	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:41:57.497448
1817	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 20:42:02.535697
1818	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:42:03.391196
1819	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:42:03.999614
1820	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/producto/nuevo	2025-10-03 20:53:18.33121
1821	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 20:53:18.452308
1822	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:53:21.587177
1823	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:53:22.07743
1824	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/4/editar	2025-10-03 20:53:36.51149
1825	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:53:37.578907
1826	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:53:38.138498
1827	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/4/subir-imagen	2025-10-03 20:53:49.349798
1828	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/4/editar	2025-10-03 20:53:50.92016
1829	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:53:51.852804
1830	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:53:53.06769
1831	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/4/editar	2025-10-03 20:53:57.429649
1832	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/38/productos	2025-10-03 20:53:57.482384
1833	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:53:58.848639
1834	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:53:59.276876
1835	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 20:54:23.176574
1836	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 20:54:23.679518
1837	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 20:54:23.757648
1838	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 21:28:54.529714
1839	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:28:57.321309
1840	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:28:57.714876
1841	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:29:22.046724
1842	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:29:24.524837
1843	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-03 21:29:34.684347
1844	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 21:29:34.754664
1845	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:29:35.621394
1846	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:29:37.242052
1847	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-03 21:29:53.139544
1848	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 21:29:53.363182
1849	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:29:53.994552
1850	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:29:55.858874
2303	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:26:21.196303
2304	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:26:21.638699
2365	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:32:12.531854
2366	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:32:14.302899
2368	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:35:00.876925
2369	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:35:01.126931
2371	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito/agregar/6	2025-10-06 19:35:04.534258
2372	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-06 19:35:04.628988
2385	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:06:24.927596
2386	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 12:06:34.380479
2387	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:06:35.22816
2388	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:06:36.33756
2389	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:07:03.389537
2390	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:07:04.072172
2391	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 12:07:21.240582
2392	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:07:23.115214
2393	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:07:23.268051
2394	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 12:07:37.169269
2395	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:07:37.760057
2396	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:07:39.585299
2397	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-07 12:09:08.835889
2398	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:09:09.838134
2399	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:09:13.992056
2400	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 12:09:27.32297
2401	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:09:30.343067
2402	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:09:32.687857
2403	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 12:09:39.712051
2404	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:09:41.464451
2405	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:09:43.858723
2406	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-07 12:10:12.254806
2407	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:10:13.264603
2408	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:10:14.573715
2409	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-07 12:10:14.970212
2439	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 13:17:14.087272
1852	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:31:43.775016
1853	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:31:43.920525
1854	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:31:48.44802
1855	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:31:50.071609
1856	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-03 21:32:04.361142
1857	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:32:05.94322
1858	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:32:05.994986
1859	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-03 21:32:50.159041
1860	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:32:50.727418
1861	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:32:55.398959
1862	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/59/editar	2025-10-03 21:33:09.047356
1863	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:33:09.439952
1864	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:33:11.231026
1865	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-03 21:33:17.11794
1866	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 21:33:17.848433
1867	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 21:33:18.747871
1868	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 22:19:16.357788
1869	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:19:16.943747
1870	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:19:19.457984
1871	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-03 22:19:26.386929
1872	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:19:27.683843
1873	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:19:28.117454
1874	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-03 22:19:33.018492
1875	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:19:34.106419
1876	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:19:34.32517
1877	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-03 22:19:44.962244
1878	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:19:45.076499
1879	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:19:49.086397
1880	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-03 22:43:10.221984
1881	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:43:12.892009
1882	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:43:13.07268
1883	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:43:20.737486
1884	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:43:21.414264
1885	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-03 22:43:32.577726
1886	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-03 22:43:33.53382
1887	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-03 22:43:33.806289
2305	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:57:29.182979
2306	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:57:32.352503
2307	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:57:32.94041
2308	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 18:57:38.215459
2309	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:57:39.118808
2310	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:57:39.37956
1889	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 15:39:47.606889
1890	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 15:39:48.350074
1891	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-04 15:39:54.69548
1892	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-04 15:39:55.458687
1893	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-04 15:39:56.875723
1894	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 15:39:57.573011
1895	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 15:39:57.589614
1896	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 15:40:02.093162
1897	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 15:40:04.601541
1898	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-04 15:40:16.249357
1899	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 15:40:18.255768
1900	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 15:40:18.716719
1901	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-04 15:40:22.758346
1902	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 15:40:24.061119
1903	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 15:40:24.466399
1904	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-04 18:22:14.971288
1905	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 18:22:17.56507
1906	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 18:22:18.382537
1907	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-04 18:22:22.583368
1908	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 18:22:22.995488
1909	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 18:22:24.80903
1910	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-04 18:22:29.266218
1911	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 18:22:29.797975
1912	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 18:22:33.399664
1913	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-04 18:22:34.672173
1914	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 18:22:36.761104
1915	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 18:22:39.068807
1916	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-04 19:05:41.126927
1917	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-04 19:05:45.426958
1918	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-04 19:05:45.91672
2311	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-06 18:57:47.418849
2312	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:57:48.580993
2313	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:57:48.794866
2314	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 18:57:51.551294
2315	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:57:53.162669
2316	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:57:53.40877
2317	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-06 18:58:18.951006
2318	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:58:20.046741
2319	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:58:20.48523
2320	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 18:58:28.22617
2321	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:58:28.359966
2322	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:58:29.186163
1920	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:29:38.093246
1921	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:29:39.018013
1922	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-05 20:29:46.197425
1923	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:29:47.720417
1924	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:29:47.83566
1925	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:29:51.354309
1926	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:29:53.923238
1927	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-05 20:30:04.867407
1928	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:30:07.438286
1929	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:30:07.516411
1930	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-05 20:30:16.96542
1931	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:30:18.752577
1932	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:30:21.40061
1933	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-05 20:30:30.646487
1934	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:30:32.736879
1935	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:30:35.357075
1936	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-05 20:30:40.464161
1937	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:30:41.566729
1938	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:30:43.6415
1939	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-05 20:31:44.593983
1940	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:31:45.821554
1941	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:31:48.494002
1942	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/roles	2025-10-05 20:31:54.605507
1943	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-05 20:31:54.834517
1944	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-05 20:31:55.975181
2323	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:58:56.05168
2324	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:58:56.300711
2325	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:00.112827
2326	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:59:11.194203
2327	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:59:11.283072
2328	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:59:13.491632
2329	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:13.517999
2330	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-06 18:59:25.699987
2331	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:26.985178
2332	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:59:27.503753
2333	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 18:59:30.549245
2334	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:31.022896
2335	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:59:31.032663
2336	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-06 18:59:51.1348
2337	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:59:51.911189
2338	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:52.299869
2339	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:59:57.774151
1946	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:14:06.610599
1947	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:14:07.619413
1948	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-06 14:14:13.909619
1949	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 14:14:13.973099
1950	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-06 14:14:15.538568
1951	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:14:15.780766
1952	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:14:16.318866
1953	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-06 14:14:21.410307
1954	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-06 14:14:34.604023
1955	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:14:35.854544
1956	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:14:38.041703
1957	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-06 14:14:40.440038
1958	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:14:41.121774
1959	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:14:43.018799
1960	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 14:14:51.306618
1961	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:14:51.45115
1962	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:14:55.041579
1963	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-06 14:15:03.117482
1964	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:15:04.939306
1965	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:15:04.956885
1966	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:15:10.319333
1967	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:15:11.92582
1968	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:15:39.610153
1969	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:15:40.994467
1970	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-06 14:15:54.090034
1971	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:15:54.224803
1972	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:15:54.627158
1973	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:15:58.321101
1974	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:15:58.592596
1975	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-06 14:16:09.83899
1976	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:16:11.090976
1977	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:16:12.042174
1978	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-06 14:16:16.711732
1979	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:16:17.284992
1980	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:16:17.306477
1981	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-06 14:16:22.911601
1982	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:16:23.767584
1983	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:16:24.161151
1984	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:16:32.958261
1985	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:16:34.013955
1986	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:16:34.467092
1987	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:16:46.389773
1988	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-06 14:16:47.466951
1989	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:16:48.504577
1990	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:16:48.613954
1991	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:17:08.697014
1992	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:17:10.313755
1993	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:17:33.198159
1994	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:17:33.971614
1995	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:17:56.898014
1996	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:17:57.030824
1997	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:17:57.450761
1998	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:18:11.792454
1999	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-06 14:18:12.422352
2000	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:18:13.314959
2001	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:18:13.60305
2002	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:18:23.700004
2003	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:18:24.503245
2004	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:18:28.506284
2005	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:18:30.264142
2006	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:18:42.993002
2007	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:18:43.427584
2008	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 14:19:11.31896
2009	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:19:13.291668
2010	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:19:13.894222
2011	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-06 14:19:21.895412
2012	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:19:22.406169
2013	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:19:25.522956
2014	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 14:19:32.8962
2015	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:19:33.530978
2016	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:19:35.928017
2017	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:19:38.6234
2018	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:19:39.915429
2019	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/14/edit	2025-10-06 14:19:58.939869
2020	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:20:00.130334
2021	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:20:01.058094
2022	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-06 14:20:13.515949
2023	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:20:13.714195
2024	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:20:13.744467
2025	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:20:44.759467
2026	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:20:45.290736
2027	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:20:45.783914
2028	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/4/edit	2025-10-06 14:20:59.821887
2029	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-06 14:21:00.929344
2030	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:21:01.366858
2034	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:21:34.883871
2037	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:21:46.527747
2040	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:21:51.6231
2044	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 14:22:12.710587
2340	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:59:58.020251
2341	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-06 19:00:21.353439
2342	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:00:22.397418
2343	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:00:23.234356
2344	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/iniciar-como	2025-10-06 19:00:30.186214
2345	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 19:00:30.901076
2346	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:00:31.707253
2347	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:00:31.831282
2348	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-06 19:00:34.703433
2349	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:00:34.846992
2350	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:00:35.155595
2351	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-06 19:00:41.015624
2352	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:00:41.935576
2353	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:00:42.478071
2354	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:00:47.710152
2355	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:00:47.912309
2356	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:00:48.58323
2357	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-06 19:00:52.874854
2367	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:32:14.734549
2370	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:35:02.412124
2410	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 12:10:28.896354
2411	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:10:30.469638
2412	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:10:33.422841
2413	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 12:11:13.79841
2440	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 13:17:14.630746
2441	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 13:17:19.170424
2442	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-07 13:17:21.605551
2443	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 13:17:22.925408
2444	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 13:17:25.791696
2445	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-07 13:17:26.295621
2446	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-07 13:17:32.714253
2447	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 13:17:36.069327
2448	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 13:17:37.425807
2449	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-07 13:18:01.397662
2450	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 13:18:01.603235
2451	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 13:18:02.861081
2452	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-07 13:18:54.622765
2031	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:21:01.387361
2032	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 14:21:31.909675
2033	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:21:34.786218
2035	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 14:21:44.871448
2036	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:21:45.807023
2038	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 14:21:49.643553
2039	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:21:50.572286
2041	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 14:22:10.402904
2042	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 14:22:10.45662
2043	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 14:22:12.662735
2358	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:10:30.894922
2361	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:10:31.804128
2364	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 19:10:44.035925
2373	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:40:19.97823
2374	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito/agregar/6	2025-10-06 19:40:28.78415
2375	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-06 19:40:29.051244
3980	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:05:21.711467
2414	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 12:58:50.927995
2415	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:58:51.5159
2416	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:58:51.678013
2417	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 12:58:58.335909
2418	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:59:00.441916
2419	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:59:00.560575
2420	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:59:05.667642
2421	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:59:06.1784
2422	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 12:59:20.863361
2423	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:59:22.787242
2424	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:59:23.002089
2425	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-07 12:59:28.514614
2426	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:59:29.74104
2427	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:59:31.887093
2428	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-07 12:59:32.445214
2429	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 12:59:37.549349
2430	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:59:38.007375
2431	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:59:39.64267
2432	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 13:00:09.648843
2433	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 13:01:08.13966
2434	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistente/nuevo	2025-10-07 13:02:15.571638
2435	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/asistentes	2025-10-07 13:02:16.952047
2436	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 13:02:18.714787
2437	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/default-assistant.png	2025-10-07 13:02:19.230423
2438	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 13:02:19.705048
2453	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-07 14:37:56.320605
2046	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 15:56:33.548549
2047	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 15:56:34.116924
2048	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 15:56:41.144952
2049	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 15:56:42.663549
2050	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 15:56:43.675296
2051	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 15:56:48.520159
2052	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 15:56:49.605149
2053	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 15:56:51.446021
2054	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 15:56:54.541809
2055	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 15:56:55.683446
2056	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 15:56:58.79095
2057	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 15:57:21.559659
2058	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 15:57:21.681728
2059	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 15:57:24.715021
2060	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 16:24:05.607825
2061	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:24:07.678191
2062	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:24:11.348705
2063	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 16:40:09.698826
2064	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:40:13.661833
2065	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:40:14.139878
2066	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 16:40:18.524279
2067	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:40:19.928618
2068	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:40:22.128385
2069	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 16:41:28.356359
2070	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 16:41:28.502847
2071	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:41:31.822277
2072	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:41:32.366237
2073	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 16:41:49.587925
2074	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:41:52.113383
2075	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:41:52.819463
2076	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 16:58:28.084042
2077	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 16:58:28.18707
2078	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:58:29.757426
2079	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:58:30.233025
2080	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 16:58:49.086088
2081	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:58:50.33124
2082	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:58:51.69602
2083	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 16:58:56.158059
2084	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:58:56.734737
2085	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:58:57.89297
2086	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 16:59:02.426789
2087	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:59:03.553771
2088	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:59:04.944925
2089	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 16:59:31.954461
2090	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 16:59:32.352911
2091	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 16:59:34.188897
2092	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 16:59:34.306088
2093	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 17:00:28.290493
2094	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:00:31.327688
2095	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:00:32.138255
2096	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 17:00:48.256865
2097	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 17:00:48.54789
2098	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:00:50.75645
2099	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:00:51.029891
2100	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 17:00:54.747768
2101	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:00:56.594987
2102	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:00:58.822588
2103	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categoria/nueva	2025-10-06 17:01:11.90303
2104	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/categorias	2025-10-06 17:01:12.311247
2105	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:01:14.307879
2106	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:01:14.50027
2107	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 17:08:11.19742
2108	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:08:14.410884
2109	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:08:16.64337
2110	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:08:23.576184
2111	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:08:24.342805
2112	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:08:25.646553
2113	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 17:08:32.97293
2114	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:08:34.035457
2115	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:08:37.198637
2116	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 17:08:49.941668
2117	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 17:08:52.184403
2118	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:08:54.420797
2119	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:08:54.746
2120	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 17:09:10.525252
2121	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 17:09:12.089745
2122	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:09:14.090294
2123	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:09:14.45456
2124	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 17:18:41.56967
2125	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 17:18:43.253307
2126	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:18:46.582996
2127	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:18:49.131895
2128	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 17:18:51.977191
2129	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:18:52.429349
2130	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:18:54.801978
2131	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:18:54.912334
2132	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 17:19:04.116202
2133	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:19:10.384501
2134	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:19:12.725827
2135	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 17:20:07.78794
2136	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:20:07.882668
2137	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:20:09.924228
2138	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:20:10.084388
2139	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:20:17.80629
2140	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:20:17.910785
2141	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:20:19.073904
2142	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/subir-imagen	2025-10-06 17:20:35.833658
2143	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:20:36.593443
2144	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:20:38.609129
2145	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:20:38.68237
2146	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/subir-imagen	2025-10-06 17:20:53.293629
2147	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:20:53.984076
2148	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:20:55.820552
2149	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:20:55.842038
2150	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:21:17.686898
2151	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:21:18.147848
2152	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:21:19.905222
2153	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:21:20.311486
2154	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:22:32.347719
2155	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:22:34.923476
2156	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:22:35.754555
2157	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:31:02.30032
2158	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:31:02.787638
2159	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:31:06.404441
2160	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:34:34.278572
2161	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:34:34.386968
2162	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:34:38.051628
2163	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 17:38:06.729993
2164	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 17:38:06.999043
2165	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:38:07.161157
2166	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:38:07.970749
2167	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:38:15.658472
2168	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:38:16.704396
2169	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:38:21.706012
2170	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:38:24.906785
2171	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:38:27.28625
2172	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:38:29.906442
2173	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 17:52:26.101513
2174	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:52:26.450156
2175	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:52:27.694819
2176	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 17:52:46.184126
2177	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:52:46.348187
2178	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:52:48.642204
2179	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 17:52:57.903211
2180	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 17:52:58.554598
2181	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 17:52:59.885202
2182	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-06 18:16:56.233167
2183	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:16:59.300641
2184	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:17:00.100952
2185	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:17:11.711631
2186	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:17:12.629623
2187	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:17:15.455873
2188	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:19.841246
2189	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:17:21.46874
2190	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:17:22.577166
2191	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/imagen/1/eliminar	2025-10-06 18:17:29.080764
2192	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:29.606171
2193	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:30.09349
2194	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:17:32.145795
2195	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:17:32.509082
2196	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/imagen/0/eliminar	2025-10-06 18:17:44.149054
2197	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:44.562154
2198	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:45.230139
2199	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:17:46.581739
2200	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:17:46.754596
2201	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:17:59.056208
2202	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:17:59.146053
2203	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:18:01.438109
2204	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:18:01.655889
2205	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:08.385078
2206	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:18:08.55696
2207	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:18:09.959827
2208	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/imagen/2/eliminar	2025-10-06 18:18:17.429277
2209	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:18.065037
2210	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:18.791621
2211	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:18:21.727738
2212	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:18:21.96212
2213	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/imagen/1/eliminar	2025-10-06 18:18:28.180555
2214	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:28.835845
2215	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:29.217693
2216	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:18:31.25144
2217	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:18:31.78368
2218	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/imagen/0/eliminar	2025-10-06 18:18:39.399614
2219	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:39.694546
2220	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:18:40.115452
2221	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:18:41.485121
2222	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:18:42.020295
2223	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:19:10.235435
2224	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:19:10.941023
2225	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:19:14.18681
2226	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:19:14.63686
2227	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:20:13.87735
2228	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:20:15.59761
2229	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:20:16.030242
2230	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/subir-imagen	2025-10-06 18:20:43.082268
2231	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:20:44.941209
2232	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:20:46.622891
2233	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:20:46.729345
2234	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/subir-imagen	2025-10-06 18:21:01.883578
2235	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:21:02.779108
2236	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:21:04.753773
2237	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:21:05.181031
2238	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/6/editar	2025-10-06 18:21:11.098194
2239	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:21:11.651916
2240	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:21:14.723778
2241	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:21:15.070469
2242	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:21:20.631658
2243	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:21:22.12975
2244	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:21:23.848549
2245	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 18:21:41.564377
2246	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:21:42.896442
2247	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:21:44.655279
2248	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:21:45.815962
2249	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 18:22:06.983546
2250	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:22:08.523631
2251	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:22:10.521734
2252	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:22:10.730723
2253	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/subir-imagen	2025-10-06 18:22:25.475766
2254	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:22:26.792208
2255	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:22:29.038366
2256	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:22:29.15849
2257	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/5/editar	2025-10-06 18:22:34.641549
2258	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:22:34.709912
2259	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:22:36.205072
2260	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:22:37.196309
2261	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 18:22:44.468977
2262	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:22:45.148679
2263	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:22:49.089223
2264	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-06 18:23:46.131359
2265	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:23:46.252457
2266	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:23:49.254981
2267	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:23:49.498152
2268	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:23:57.632659
2269	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:23:59.223528
2270	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:24:01.737269
2271	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:24:33.334843
2272	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:24:33.634657
2273	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:24:35.357361
2274	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:24:36.476045
2275	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:24:45.859612
2276	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:24:45.973868
2277	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:24:49.783559
2278	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:25:01.612986
2279	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-06 18:25:02.662824
2280	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:25:06.217121
2281	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:25:06.965188
2282	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/7/editar	2025-10-06 18:25:18.724313
2283	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 18:25:19.831766
2284	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-06 18:25:21.176533
2359	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:10:30.900782
2360	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:10:31.694749
2362	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-06 19:10:41.821018
2363	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-06 19:10:42.711668
2376	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 12:05:24.030021
2377	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:05:25.95705
2378	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 12:05:27.436847
2379	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-07 12:05:33.373033
2380	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-07 12:05:33.65527
2381	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 12:06:20.939702
2382	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 12:06:21.269301
2383	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 12:06:22.821097
2384	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 12:06:24.344576
2560	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 16:23:41.047405
2454	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/nueva	2025-10-07 14:38:38.851736
2455	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-07 14:38:39.221172
2456	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:38:40.702655
2457	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:38:40.954614
2458	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tarea/61/cambiar-estado	2025-10-07 14:38:53.891366
2459	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-07 14:38:54.225478
2460	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:38:55.628346
2461	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:38:55.825618
2462	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 14:39:07.806404
2463	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:39:08.461695
2464	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:39:10.741546
2465	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 14:39:27.218061
2466	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:39:28.134102
2467	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:39:30.063349
2468	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-07 14:43:10.239321
2469	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:43:11.037597
2470	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:43:16.10756
2471	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/producto/nuevo	2025-10-07 14:44:52.241541
2472	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 14:44:52.978868
2473	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:44:55.223556
2474	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:44:55.493095
2475	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/8/editar	2025-10-07 14:45:01.869736
2476	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:45:02.340452
2477	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:45:05.26192
2478	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/8/subir-imagen	2025-10-07 14:45:22.243833
2479	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/8/editar	2025-10-07 14:45:24.488033
2480	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:45:25.948521
2481	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:45:26.000283
2482	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/8/editar	2025-10-07 14:45:32.6865
2483	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 14:45:32.98192
2484	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:45:34.393092
2485	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:45:34.423367
2486	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 14:45:50.08298
2487	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:45:50.396463
2488	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:45:50.611313
2489	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-07 14:45:57.124673
2490	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:45:57.663758
2491	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:45:57.709654
2492	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 14:46:03.683939
2493	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:46:04.136103
2494	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:46:04.559937
2495	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:46:07.774382
2604	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 17:52:18.500523
2496	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:49:37.912067
2497	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:51:12.11106
2498	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:51:12.750174
2499	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:51:12.763844
2500	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/6	2025-10-07 14:51:35.588841
2501	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:51:36.208837
2502	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:51:37.044272
2503	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-07 14:52:11.524068
2504	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:52:12.456436
2505	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:52:12.741673
2506	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-07 14:52:16.654538
2507	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:52:17.436065
2508	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:52:17.86137
2509	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-07 14:52:21.194473
2510	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:52:21.834139
2511	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:52:22.069494
2512	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 14:52:48.934996
2513	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:52:49.296335
2514	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:52:49.595371
2515	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:52:52.883833
2516	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:52:52.940481
2517	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:17.529548
2518	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:17.544194
2519	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:22.561918
2520	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:22.93888
2521	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 14:53:32.408872
2522	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:32.70331
2523	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:32.938186
2524	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 14:53:35.8118
2525	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:36.168743
2526	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:36.472463
2527	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-07 14:53:40.035552
2528	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:40.45451
2529	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:40.715257
2530	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 14:53:48.494775
2531	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:48.882475
2532	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:49.341477
2533	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:53:54.356092
2534	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:53:54.814592
2535	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:53:54.903158
2536	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/6	2025-10-07 14:53:58.958047
2537	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:53:59.598241
2538	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:54:00.329886
2540	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/7	2025-10-07 14:54:26.125226
2541	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:54:26.503166
2542	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:54:26.877201
2544	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 14:54:34.157192
2545	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:54:35.114738
3981	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:05:21.742232
3983	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:05:22.324279
3984	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-12 18:08:20.760677
3985	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:08:25.461988
3987	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:08:26.266699
3989	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/40/eventos	2025-10-12 18:08:32.913378
3990	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:08:33.125299
3992	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:08:34.821637
3994	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/40/evento/nuevo	2025-10-12 18:08:37.484802
3995	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:08:40.092786
3997	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:08:41.831122
3999	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/40/evento/nuevo	2025-10-12 18:09:39.709293
4000	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-12 18:09:41.940804
4001	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:09:43.825133
4003	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:09:44.556602
4005	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-12 18:10:01.781724
4007	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:10:02.127434
4009	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:10:02.304194
4012	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:10:07.578767
4014	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:10:08.737981
4017	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:10:14.618529
4019	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:10:15.738679
4122	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 20:57:03.495042
4125	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 20:57:11.196946
4230	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/upload_csv	2025-10-16 17:29:30.363896
4231	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:29:30.978172
4232	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:29:33.313702
4234	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:29:33.559802
4236	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:30:53.758739
4237	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:30:54.63035
4238	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:30:59.66421
4240	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:31:00.185712
4242	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:31:24.836917
4243	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:31:35.906621
4244	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:31:36.501362
4246	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:31:38.053173
4248	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/select_columns	2025-10-16 17:31:44.811209
2539	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:54:01.018561
2543	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:54:27.401627
2546	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:54:35.396969
2547	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:54:42.615434
2548	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:54:43.036835
2549	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:54:43.347072
2550	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/6	2025-10-07 14:57:34.61541
2551	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 14:57:35.206735
2552	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 14:57:35.670614
2553	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 14:57:35.673543
2554	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/productos	2025-10-07 15:57:46.755945
2555	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/8/editar	2025-10-07 15:58:09.53134
2556	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 15:58:26.700165
2557	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/producto/2/editar	2025-10-07 15:58:33.490108
2558	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 15:58:33.590981
2559	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 15:58:52.644304
3982	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:05:21.756881
3986	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:08:25.670002
3988	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:08:26.969845
3991	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:08:33.780593
3993	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:08:35.223015
3996	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:08:40.389674
3998	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:08:42.725192
4002	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:09:44.129832
4004	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:09:45.243146
4006	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:10:01.886219
4008	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:10:02.138177
4010	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-12 18:10:06.462521
4011	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:10:07.041643
4013	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:10:07.775065
4015	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/banzai-show-mc	2025-10-12 18:10:14.16441
4016	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:10:14.456412
4018	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:10:15.12049
4127	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 21:02:03.385978
4134	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 21:02:19.379652
4233	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:29:33.481677
4235	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:29:33.616448
4239	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:31:00.065592
4241	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:31:03.038832
4245	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:31:36.529683
4247	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:31:38.64987
4252	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:31:57.844892
4482	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 14:25:11.078811
2561	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:23:41.343801
2562	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:23:42.493603
2563	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 16:23:59.221749
2564	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:24:00.897576
2565	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:24:00.897576
2566	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:24:09.477904
2567	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:24:09.824591
2568	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-07 16:24:24.39239
2569	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:24:25.695164
2570	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:24:25.819189
2571	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 16:26:26.192747
2572	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:26:27.150784
2573	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:26:27.654701
2574	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 16:26:33.47567
2575	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:26:34.082134
2576	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:26:34.396598
2577	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/notas-publicadas	2025-10-07 16:28:01.719904
2578	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:02.546094
2579	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:06.193175
2580	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/publications	2025-10-07 16:28:08.592171
2581	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:09.331449
2582	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:10.221124
2583	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 16:28:13.652994
2584	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:14.838505
2585	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:16.611442
2586	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/publications	2025-10-07 16:28:20.482156
2587	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:21.314217
2588	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:21.703871
2589	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 16:28:24.511085
2590	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:26.925218
2591	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:27.54535
2592	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/portfolio	2025-10-07 16:28:30.609404
2593	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:31.239305
2594	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:32.995215
2595	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 16:28:57.373848
2596	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:28:58.161958
2597	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:28:58.674178
2598	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/portfolio	2025-10-07 16:38:41.593006
2599	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 16:38:41.987554
2600	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 16:38:47.023832
2601	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 16:38:55.76237
2602	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 16:39:37.589766
2603	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 16:39:46.024582
2605	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 17:58:05.853013
2606	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 17:58:21.609337
2607	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 18:00:01.40378
2608	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:00:02.018057
2609	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:00:02.38623
2610	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:00:03.638223
2611	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:00:28.46415
2612	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:00:29.157041
2613	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:00:30.353364
2614	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:00:31.234737
2615	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:00:31.665415
2616	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:00:32.33145
2617	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:00:34.585423
2618	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:00:34.619603
2619	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:00:35.122549
2620	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:00:58.380172
2621	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:00:59.173061
2622	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:00:59.812728
2623	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:01:00.079249
2624	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:01:08.690919
2625	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:07:50.161238
2626	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:07:55.341564
2627	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:07:56.039824
2628	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:07:56.108678
2629	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:07:57.513994
2630	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:07:58.968138
2631	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:16:23.932682
2632	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:16:24.383867
2633	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:16:52.08439
2634	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:32:15.441591
2635	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-07 18:32:19.10625
2636	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:32:19.437317
2637	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:32:19.861156
2638	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:32:20.497895
2639	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:32:23.716736
2640	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:32:24.420861
2641	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:32:24.665987
2642	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:32:25.263169
2643	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:39:34.528287
2644	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:39:35.282923
2645	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:39:35.712892
2646	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:39:35.884772
2647	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/vaciar_carrito	2025-10-07 18:41:07.241478
2648	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:41:07.549596
2649	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:08.097338
2650	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:08.533113
2651	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:08.888504
2652	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 18:41:13.63083
2653	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:13.997054
2654	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:14.419429
2655	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:15.198747
2656	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-07 18:41:19.36391
2657	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:19.776522
2658	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:19.80533
2659	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:20.466972
2660	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 18:41:26.547232
2661	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:27.092647
2662	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:27.338758
2663	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:27.775296
2664	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:41:29.765586
2665	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:30.412578
2666	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:30.427229
2667	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:31.315924
2668	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/6	2025-10-07 18:41:36.891288
2669	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:41:37.236024
2670	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:37.656936
2671	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:37.670605
2672	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:38.429907
2673	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/7	2025-10-07 18:41:42.254241
2674	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:41:42.804061
2675	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:43.538456
2676	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:43.614632
2677	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:43.987689
2678	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/5	2025-10-07 18:41:48.869769
2679	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:41:49.162305
2680	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:49.780341
2681	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:50.20718
2682	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:50.466398
2683	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:41:53.757509
2684	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:41:54.084668
2685	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:41:54.206742
2686	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:41:54.959695
2687	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/vaciar_carrito	2025-10-07 18:46:09.112274
2688	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 18:46:11.161164
2689	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:46:13.615826
2690	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:46:14.093376
2691	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:46:15.504065
2692	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 18:46:19.518835
2693	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:46:19.842577
2694	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:46:20.01153
2695	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:46:20.445378
2696	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-07 18:46:26.278802
2697	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:46:26.7754
2698	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:46:26.896496
2699	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:46:27.268578
2700	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 18:59:17.088327
2701	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:59:17.303178
2702	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:59:17.533653
2703	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:59:17.547327
2704	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:59:43.323482
2705	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:59:44.011975
2706	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:59:44.327416
2707	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:59:44.825967
2708	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/8	2025-10-07 18:59:57.215983
2709	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 18:59:57.465016
2710	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 18:59:58.024601
2711	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 18:59:58.203317
2712	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 18:59:58.927948
2713	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 19:00:09.125027
2714	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 19:17:25.867218
2715	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:09:35.061247
2716	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:09:50.192434
2717	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:09:50.553872
2718	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:09:50.582261
2719	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:09:51.11248
2720	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:09:56.024239
2721	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:19:55.504782
2722	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:19:56.873966
2723	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:19:56.959908
2724	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:19:58.366686
2725	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:20:02.146576
2726	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:23:24.876608
2727	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:23:25.792648
2728	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:23:25.899096
2729	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:23:25.923512
2730	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:23:31.443693
2731	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:26:01.725099
2783	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 23:23:27.298869
2732	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:26:02.107296
2733	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:26:02.598085
2734	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:26:03.07168
2735	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:26:05.402802
2736	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:26:06.040518
2737	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:26:06.312007
2738	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:26:07.062032
2739	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/vaciar_carrito/el-vasquito	2025-10-07 20:26:48.54323
2740	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:26:48.842072
2741	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:26:50.084296
2742	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:26:50.444656
2743	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:26:51.065768
2744	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/6	2025-10-07 20:27:00.626599
2745	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:27:00.929342
2746	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:01.561195
2747	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:01.94695
2748	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:27:02.460637
2749	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/agregar_al_carrito/8	2025-10-07 20:27:16.290147
2750	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:27:16.799057
2751	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:17.753084
2752	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:18.215986
2753	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:27:18.446502
2754	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:27:22.961243
2755	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:27:23.337232
2756	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:23.363664
2757	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:24.023776
2758	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:27:51.500661
2759	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:51.961611
2760	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:52.261425
2761	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:27:52.946988
2762	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/carrito	2025-10-07 20:27:55.152625
2763	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:55.603322
2764	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:55.610158
2765	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:27:56.597177
2766	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/vaciar_carrito/el-vasquito	2025-10-07 20:27:58.67519
2767	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:27:58.932031
2768	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:27:59.400798
2769	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:27:59.566816
2770	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:28:00.19379
2771	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-07 20:28:15.280212
2772	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:28:16.027754
2773	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:28:16.165725
2774	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:28:16.619645
2777	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:28:24.19059
4020	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 18:10:25.484082
4021	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:10:26.32004
4023	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:10:27.970973
4025	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/api/dias-disponibles/40/10	2025-10-12 18:10:28.596962
4026	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/4	2025-10-12 18:10:42.086131
4027	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:10:42.521694
4029	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:10:42.903542
4031	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 18:11:59.730522
4032	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:12:01.213475
4034	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:12:02.333626
4036	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/api/dias-disponibles/40/10	2025-10-12 18:12:03.169588
4128	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 21:02:03.528558
4131	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 21:02:16.418619
4249	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 17:31:56.653887
4250	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:31:56.706752
4251	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:31:57.844892
4253	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:31:57.8793
4255	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-16 17:32:04.740577
4256	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:32:05.131217
4258	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:32:05.564827
4260	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 17:32:11.892182
4261	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:32:11.944919
4262	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:32:12.503532
4264	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:32:12.527456
4376	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:06:31.704506
4377	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:06:31.960375
4378	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:06:32.716258
4379	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:06:32.824658
4380	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 13:07:01.469063
4381	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:07:03.451054
4382	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:07:03.624883
4383	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:07:04.134669
4384	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:07:04.408115
4385	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:07:09.518617
4386	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:07:10.265924
4387	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:07:10.884382
4388	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:07:11.952283
4389	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:07:25.077674
4390	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:07:25.616259
4391	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:07:26.451248
4392	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:07:27.042086
2775	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:28:22.953741
2776	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:28:23.658351
2778	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:28:24.389815
2779	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/tienda/el-vasquito	2025-10-07 20:29:18.114555
2780	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 20:29:18.784495
2781	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 20:29:19.022785
2782	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 20:29:19.130211
4022	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:10:26.712147
4024	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:10:28.086211
4028	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:10:42.62095
4030	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:10:43.601316
4033	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:12:01.42344
4035	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:12:02.694963
4129	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 21:02:03.652587
4132	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 21:02:18.074924
4254	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:31:58.060985
4257	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:32:05.336302
4259	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:32:05.606815
4263	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:32:12.511549
4265	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:32:12.751098
4393	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-20 13:07:44.41516
4394	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:07:46.528993
4395	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:07:46.627629
4396	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:07:47.261437
4397	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:07:47.861061
4398	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/iniciar-como	2025-10-20 13:08:00.603631
4399	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-20 13:08:00.657342
4400	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:08:02.375164
4401	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:08:02.608567
4402	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:08:03.172066
4403	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:08:03.750209
4404	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 13:08:09.518447
4405	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:08:10.351474
4406	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:08:11.002864
4407	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:08:11.653763
4408	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:08:12.065882
4409	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 13:08:15.751538
4410	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:08:16.839953
4411	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:08:17.17492
4412	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:08:17.948384
4413	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:08:19.101737
4414	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 13:17:00.310253
4522	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 13:04:55.349368
2784	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 23:23:28.232491
2785	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 23:23:28.879972
2786	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 23:23:29.155373
4037	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/4	2025-10-12 20:51:11.389428
4038	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 20:51:11.673615
4039	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 20:51:11.830845
4040	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 20:51:11.869912
4041	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 20:51:11.979285
4042	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 20:51:15.599022
4043	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 20:51:16.076579
4044	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 20:51:16.0883
4045	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 20:51:16.414479
4046	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 20:51:17.349078
4047	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/api/dias-disponibles/40/10	2025-10-12 20:51:18.799806
4048	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/4	2025-10-12 20:51:25.48018
4049	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 20:51:25.783899
4050	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 20:51:26.082736
4051	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 20:51:26.133519
4053	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 20:51:30.973018
4054	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 20:51:31.531629
4056	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 20:51:32.640055
4058	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/api/dias-disponibles/40/10	2025-10-12 20:51:33.665483
4130	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 21:02:04.045176
4133	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 21:02:18.876707
4266	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 18:04:26.350165
4267	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 18:04:26.537669
4268	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 18:04:29.718798
4269	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 18:04:30.084663
4270	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 18:04:30.330764
4271	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 18:04:30.423132
4272	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 18:04:38.016084
4273	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 18:04:41.661713
4274	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 18:04:42.241323
4275	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 18:04:42.960095
4276	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 18:04:43.680823
4277	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-16 18:04:52.501437
4278	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 18:04:53.839369
4279	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 18:04:54.090354
4280	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 18:04:54.570841
4281	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 18:04:55.69295
4319	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/publications	2025-10-18 17:36:56.341592
4320	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 17:36:56.706833
4321	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 17:36:57.71175
2787	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-07 23:52:42.366131
2788	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 23:52:42.941339
2789	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 23:52:43.705525
2790	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 23:52:43.910609
2791	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/portfolio	2025-10-07 23:53:33.804638
2792	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-07 23:53:34.224571
2793	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-07 23:53:34.424772
2794	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-07 23:53:34.765605
2795	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/portfolio	2025-10-08 00:00:30.424729
2796	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 00:00:30.880796
2797	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 00:00:31.855923
2798	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 00:00:31.936981
2799	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 17:02:41.585751
2800	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 17:02:42.352864
2801	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 17:02:43.364612
2802	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 17:02:43.47985
2803	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-08 17:02:50.239324
2804	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-08 17:02:51.110445
2805	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/publications	2025-10-08 17:03:38.250012
2806	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 17:03:40.027409
2807	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 17:03:40.834076
2808	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 17:03:42.62905
2809	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-08 17:04:06.682003
2810	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 17:04:11.100593
2811	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 17:04:11.196297
2812	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 17:04:12.177772
2813	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-08 17:04:22.093104
2814	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 17:04:22.395846
2815	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 17:04:23.342164
2816	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 17:04:23.500369
2817	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:16:09.006425
2818	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:16:10.702277
2819	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:16:10.971816
2820	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:16:11.872234
2821	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-08 23:16:54.857899
2822	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:16:55.895044
2823	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:16:57.394113
2824	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:16:57.763264
2825	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-08 23:17:04.151153
2826	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:17:04.681437
2827	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:17:05.875814
2828	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:17:06.610205
2829	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/eventos/el-vasquito	2025-10-08 23:18:05.84051
2830	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:18:06.771196
2831	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:18:09.413372
2832	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:18:10.231751
2833	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-08 23:21:28.534133
2834	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:21:31.242709
2835	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:21:33.28769
2836	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:21:34.819595
2837	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:21:42.508187
2838	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:21:43.444735
2839	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:21:44.106869
2840	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-08 23:21:57.206875
2841	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:21:58.698622
2842	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:21:59.312895
2843	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:21:59.976974
2844	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:22:14.346556
2845	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:22:16.493588
2846	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:22:16.596135
2847	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:22:17.051226
2848	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:22:28.018842
2849	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:22:28.43585
2850	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:22:29.030596
2851	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/dashboard	2025-10-08 23:22:36.498594
2852	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:22:38.180285
2853	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:22:38.281853
2854	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:22:39.097307
2855	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin	2025-10-08 23:22:45.183429
2856	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:22:47.105849
2857	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:22:48.503352
2858	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:22:48.994576
2859	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-08 23:23:12.784855
2860	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:23:13.404014
2861	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:23:14.346914
2862	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:23:15.266864
2863	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-08 23:23:33.063793
2864	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:23:33.951516
2865	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:23:34.607785
2866	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:23:35.388085
2867	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-08 23:23:47.32643
2868	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-08 23:23:47.693633
2869	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:23:52.35979
2870	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:23:52.427173
2871	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:23:52.676208
2872	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:24:02.166729
2873	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:24:02.479239
2874	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:24:02.696043
2875	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:24:02.907965
2876	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:24:08.872498
2877	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:24:08.893984
2878	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:24:10.022439
2879	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:24:45.973729
2880	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:24:46.244244
2881	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:24:47.64956
2882	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-08 23:24:58.554679
2883	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:24:59.523459
2884	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:25:00.015662
2885	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:25:00.948795
2886	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-08 23:25:10.884646
2887	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/admin/users	2025-10-08 23:25:11.631738
2888	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:25:13.112253
2889	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:25:13.747039
2890	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:25:14.165995
2891	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-08 23:25:36.998727
2892	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:25:37.534875
2893	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:25:37.541711
2894	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:25:37.551479
2895	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-08 23:26:00.252852
2896	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-08 23:26:00.570247
2897	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:01.344197
2898	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:01.98875
2899	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:02.116681
2900	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:26:08.601746
2901	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:09.125195
2902	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:09.528533
2903	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:11.991008
2904	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:15.186418
2905	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:15.604401
2906	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:16.101482
2907	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-08 23:26:27.711218
2908	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:28.49347
2909	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:29.475922
2910	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:30.09215
2911	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-08 23:26:33.319298
2912	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-08 23:26:33.366174
2913	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:33.999008
2915	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:34.499025
2918	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:41.737528
2920	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesionales	2025-10-08 23:26:45.672213
2921	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:46.327024
2923	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:47.577061
2928	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:54.12365
2931	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:27:20.329528
2933	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:27:21.939447
2934	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:30:29.494545
2935	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:30:29.973074
2939	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:30:43.017913
2941	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/dashboard	2025-10-08 23:30:48.673845
2942	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:30:49.651905
2944	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:30:51.221292
2945	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:31:15.758184
2947	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:31:16.134173
2949	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:31:21.29693
2951	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:31:22.410734
4052	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 20:51:26.530989
4055	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 20:51:31.723036
4057	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 20:51:33.249453
4135	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:12:40.985297
4136	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:12:43.360372
4137	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:12:44.772035
4138	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:12:45.386314
4139	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:15:11.36792
4140	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:15:11.393313
4141	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:15:11.807875
4142	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:15:13.333314
4143	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:17:02.356264
4144	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:17:04.560925
4145	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:17:07.15378
4146	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:17:07.326639
4282	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/roles	2025-10-17 18:00:03.986029
4283	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-17 18:00:04.044621
4284	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:00:05.540761
4285	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:00:05.896242
4286	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:00:05.97974
4287	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:00:06.389911
4288	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-17 18:00:11.195729
4289	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-17 18:00:12.652314
2914	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:34.001939
2916	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:26:40.265313
2917	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:26:40.856639
2919	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:42.466062
2922	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:46.838753
2924	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-08 23:26:53.149985
2925	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-08 23:26:53.411715
2926	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-08 23:26:53.766212
2927	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:26:54.117788
2929	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:26:54.158804
2930	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/	2025-10-08 23:27:19.799822
2932	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:27:21.229072
2936	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:30:30.683053
2937	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-trabajo	2025-10-08 23:30:41.755179
2938	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:30:42.616534
2940	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:30:43.498392
2943	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:30:50.675375
2946	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:31:16.134173
2948	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:31:17.687445
2950	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:31:21.699776
2952	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-08 23:31:37.842364
2953	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-08 23:31:38.531837
2954	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-08 23:31:39.224244
2955	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-08 23:31:39.881491
2956	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/eventos	2025-10-08 23:32:42.542126
2957	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 00:11:00.307659
2958	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/eventos	2025-10-09 00:11:05.276559
2959	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 00:11:05.954314
2960	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 00:11:06.734611
2961	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 00:11:07.194584
2962	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 00:11:11.162971
2963	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 18:55:10.263796
2964	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:55:13.902572
2965	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:55:15.162862
2966	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:55:17.492033
2967	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-09 18:55:34.948104
2968	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-09 18:55:35.686411
2969	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-09 18:55:41.657776
2970	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:55:42.1783
2971	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:55:43.085063
2972	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:55:46.052925
2973	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-09 18:55:48.987578
2974	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 18:55:56.546396
2975	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:56:01.152484
2976	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:56:03.310752
2977	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:56:04.868905
2978	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 18:56:17.150514
2979	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:56:23.634586
2980	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:56:24.586767
2981	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:56:25.817267
2982	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 18:56:37.015842
2983	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 18:56:43.805594
2984	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 18:56:51.095849
2985	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:56:57.760596
2986	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:56:58.510617
2987	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:56:59.470607
2988	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 18:57:19.675305
2989	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:57:26.187703
2990	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:57:26.302944
2991	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:57:27.221425
2992	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:57:40.015258
2993	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:57:41.709649
2994	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:57:42.054386
2995	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 18:58:01.588165
2996	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:58:08.635256
2997	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:58:08.855477
2998	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:58:09.601592
2999	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 18:58:16.771726
3000	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 18:58:19.129219
3001	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:58:23.988079
3002	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:58:24.568344
3003	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:58:25.029936
3004	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 18:59:35.604166
3005	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:59:38.324951
3006	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:59:38.685312
3007	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:59:40.891431
3008	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 18:59:46.567383
3009	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 18:59:48.187067
3010	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 18:59:49.928329
3011	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 19:00:27.064211
3012	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:00:30.837766
3013	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:00:30.977416
3014	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:00:33.004337
3015	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 19:01:11.83266
3016	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:01:12.091458
3017	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:01:13.521189
3019	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:01:17.635571
4059	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-15 15:56:54.46988
4060	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-15 15:56:54.715987
4061	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-15 15:56:54.765788
4062	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 15:56:56.945545
4063	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 15:56:57.089104
4064	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 15:56:57.170161
4065	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 15:56:57.264887
4066	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-15 15:57:02.998964
4067	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-15 15:57:05.439959
4068	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-15 15:57:05.785673
4069	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 15:57:07.848237
4070	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 15:57:08.255477
4071	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 15:57:08.837529
4072	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 15:57:09.421045
4147	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:25:30.191914
4148	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:25:30.308128
4149	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:25:31.524965
4150	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:25:32.309173
4290	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-17 18:06:32.578113
4291	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-17 18:08:47.559072
4292	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:08:49.548882
4293	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:08:49.98249
4294	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:08:50.185623
4295	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:08:50.6163
4322	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 17:36:58.1395
4323	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 17:36:59.771871
4324	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-18 17:37:05.226139
4325	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-18 17:37:05.247506
4326	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-18 17:37:07.971339
4327	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 17:37:09.279483
4328	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 17:37:09.57832
4329	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 17:37:10.637917
4330	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/default-avatar.png	2025-10-18 17:37:11.691662
4331	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 17:37:12.379184
4332	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-18 17:37:16.028222
4415	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:17:02.948085
4416	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:17:03.173106
4417	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:17:03.816794
4418	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:17:05.384224
4419	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-20 13:17:25.394602
4420	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 13:17:25.433664
3018	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:01:14.836659
3020	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:04:07.93474
3021	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:10:39.423493
3022	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:11:09.116473
3023	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:13:06.3182
3024	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:13:06.528169
3025	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:13:07.253773
3026	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:13:08.090716
3027	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:23:38.483663
3028	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:25:25.034287
3029	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:25:59.409361
3030	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:25:59.944535
3031	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:26:00.051958
3032	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:26:01.106679
3033	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:27:12.995113
3034	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:27:15.308663
3035	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:27:16.771112
3036	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:27:17.071901
3037	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/evento/nuevo	2025-10-09 19:30:11.621718
3038	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 19:30:13.520703
3039	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:14.500225
3040	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:15.396737
3041	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:15.619889
3042	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 19:30:24.288815
3043	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:24.4019
3044	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:24.516649
3045	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:24.561572
3046	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-09 19:30:29.661338
3047	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:29.946992
3048	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:29.950282
3049	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:30.091529
3050	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/el-vasquito	2025-10-09 19:30:35.518938
3051	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:35.774812
3052	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:35.789459
3053	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:36.003332
3054	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:45.068066
3055	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:45.072951
3056	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:45.08076
3057	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-09 19:30:49.150226
3058	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:49.574065
3059	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:49.579925
3060	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:49.611177
4543	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 17:25:55.982915
3061	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-09 19:30:56.218246
3063	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:30:56.504457
3068	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:05.391449
3070	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:13.352632
3073	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 19:31:25.877442
3077	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:26.803736
3079	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:31.325849
3082	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:33.408922
3086	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:50.147722
4073	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:14:29.428941
4074	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-15 18:15:10.569381
4075	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:15:11.415109
4076	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:15:11.472731
4077	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:15:11.748127
4078	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:15:11.987398
4079	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/iniciar-como	2025-10-15 18:15:30.957229
4080	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-15 18:15:31.386928
4081	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:15:35.317224
4082	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:15:35.776226
4083	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:15:35.808453
4084	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:15:36.076041
4085	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-15 18:15:43.458107
4086	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:15:45.175442
4087	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:15:45.190094
4088	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:15:45.824877
4089	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:15:46.461616
4090	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:15:53.476974
4091	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:16:00.367814
4092	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:16:07.035499
4093	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:17:17.821413
4094	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/terminos-y-condiciones	2025-10-15 18:17:24.243004
4095	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:17:24.747903
4096	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:17:24.810405
4097	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:17:26.154195
4098	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:17:26.230371
4099	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:18:27.592164
4100	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/politica-de-privacidad	2025-10-15 18:18:31.757826
4101	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:18:32.990288
4102	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:18:33.274477
4103	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:18:33.872149
4104	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:18:34.478616
4105	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:19:23.675477
3062	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:30:56.504457
3065	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 19:31:05.253749
3067	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:05.380708
3072	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:13.368262
3074	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 19:31:25.945309
3076	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:26.6426
3078	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 19:31:31.243818
3081	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:31.338544
3084	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:31:33.43236
3088	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:50.269798
4106	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:19:29.139034
4151	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:25:54.917815
4152	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:25:56.738191
4153	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:25:56.930578
4154	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:25:57.59857
4155	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:27:16.444906
4156	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:27:16.581628
4157	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:27:17.284779
4158	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:27:17.792607
4159	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:27:47.092399
4160	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:27:47.300409
4161	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:27:48.012352
4162	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:27:49.655962
4163	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-15 23:28:03.465984
4164	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 23:28:05.41234
4165	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 23:28:05.434798
4166	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 23:28:05.838135
4167	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 23:28:07.580381
4296	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-17 18:40:50.931736
4297	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:40:51.552933
4298	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:40:51.664753
4299	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:40:52.497299
4300	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:40:52.896237
4333	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-18 17:47:30.105634
4334	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 17:47:32.007195
4335	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 17:47:34.194751
4336	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 17:47:34.709946
4337	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 17:47:38.055236
4338	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/default-avatar.png	2025-10-18 17:47:38.311593
4339	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-18 17:47:47.690793
4340	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-18 17:47:48.125377
4341	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-18 17:47:48.427146
4342	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 17:47:50.936013
3064	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:30:56.835517
3066	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:05.374849
3069	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 19:31:13.22112
3071	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:13.361425
3075	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:26.126957
3080	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:31:31.331715
3083	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:33.413805
3085	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 19:31:50.02565
3087	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:31:50.220967
3089	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/dashboard	2025-10-09 19:36:06.304161
3090	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:36:08.052749
3091	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:36:08.169943
3092	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:36:09.033249
3093	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 19:36:18.615092
3094	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:36:20.007713
3095	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:36:20.539958
3096	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:36:21.162045
3097	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:36:24.445843
3098	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:36:24.781789
3099	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:36:24.906796
3100	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-09 19:36:36.730786
3101	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 19:36:37.286576
3102	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 19:36:37.460407
3103	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 19:36:38.03953
3104	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-09 20:39:14.10268
3105	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 20:39:16.356165
3106	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 20:39:16.664767
3107	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 20:39:18.322043
3108	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 20:39:49.090525
3109	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 20:45:23.302554
3110	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 20:45:31.348199
3111	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 20:45:32.045489
3112	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 20:45:33.834603
3113	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 20:45:34.833168
3114	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 20:45:41.432487
3115	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 20:45:43.440357
3116	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 20:45:44.166281
3117	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 20:45:47.004429
3118	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 20:46:26.98511
3119	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 20:46:28.634086
3120	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 20:46:29.4847
3121	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 20:46:30.191754
3122	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 20:50:34.610232
3123	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 20:50:35.717687
3124	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 20:50:36.737739
3125	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 20:50:37.203569
3126	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 20:59:57.668877
3127	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:03:30.632925
3128	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:07:57.303553
3129	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:07:59.814536
3130	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:08:00.39854
3131	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:08:01.039673
3132	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:08:53.673126
3133	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 21:14:33.121563
3134	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:14:33.501458
3135	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:14:34.563991
3136	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:14:35.952709
3137	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:14:40.202836
3138	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:14:41.804936
3139	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:14:42.712189
3140	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:14:43.797186
3141	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:16:48.094478
3142	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 21:16:49.709761
3143	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:16:52.846087
3144	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:16:52.933007
3145	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:16:54.392033
3146	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:17:14.780849
3147	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:17:16.446916
3148	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:17:17.019201
3149	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:17:17.253581
3150	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 21:17:34.269243
3151	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:17:34.426475
3152	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:17:35.268298
3153	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:17:36.097427
3154	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 21:17:40.448631
3155	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:17:41.191821
3156	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:17:41.850041
3157	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:17:42.400355
3158	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 21:39:42.92848
3159	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 21:39:44.43048
3160	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:39:47.112205
3161	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:39:47.430575
3162	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:39:50.422365
3163	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:41:00.300983
4546	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 19:11:08.127809
3164	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 21:41:03.387018
3165	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:41:04.738137
3166	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:41:05.256701
3167	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:41:05.982805
3168	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:41:37.69179
3169	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 21:41:39.040465
3170	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 21:41:40.593248
3171	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:41:40.900387
3172	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:41:41.771508
3173	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:41:42.124058
3174	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 21:41:55.911849
3175	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 21:41:58.966246
3176	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:41:59.129227
3177	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:41:59.733977
3178	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:42:00.97425
3179	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 21:42:27.150352
3180	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 21:42:27.30465
3181	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 21:42:28.860854
3182	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 21:42:29.615759
3183	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 21:42:30.586491
3184	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 22:13:52.667796
3185	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:13:54.501836
3186	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:13:56.121029
3187	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:13:57.212367
3188	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:13:58.180172
3189	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/1	2025-10-09 22:14:02.08996
3190	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:14:03.589837
3191	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:14:03.913253
3192	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:14:05.040733
3193	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:14:06.344971
3194	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 22:14:13.54099
3195	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:14:13.768539
3196	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:14:14.75001
3197	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:14:15.511757
3198	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:14:15.823288
3199	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 22:14:24.118463
3200	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:14:24.742506
3201	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:14:24.910481
3202	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:14:25.591165
3203	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:14:27.710853
3204	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eliminar-evento/1	2025-10-09 22:14:29.89159
3205	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/4/eventos	2025-10-09 22:14:30.53321
3206	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:14:32.315002
3207	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:14:32.420475
3208	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:14:32.913653
3209	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:14:34.160762
3210	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 22:15:59.512975
3211	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:16:02.759161
3212	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:16:02.893935
3213	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:16:03.556556
3214	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:16:04.289974
3215	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:16:29.285363
3216	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:16:29.663307
3217	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:16:29.78831
3218	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:16:31.350859
3219	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:16:52.373956
3220	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:16:52.927689
3221	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:16:53.427217
3222	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:16:54.863779
3223	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 22:17:24.734328
3224	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:17:27.062522
3225	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:17:27.55472
3226	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:17:28.701243
3227	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:17:29.287687
3228	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 22:17:51.771773
3229	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:17:53.765486
3230	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:17:54.474492
3231	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:17:54.763565
3232	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:17:55.979422
3233	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:00.728587
3234	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:00.977624
3235	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:18:01.750101
3236	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:18:01.862898
3237	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-09 22:18:11.144439
3238	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:13.000938
3239	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:13.028282
3240	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:18:13.486306
3241	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:18:15.051783
3242	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-09 22:18:20.774125
3243	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:21.709209
3244	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:23.085228
3245	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:18:24.305974
3246	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:18:26.512584
3247	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 22:18:29.172333
3248	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:29.617658
3249	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:30.586439
3250	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:18:31.226103
3251	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:18:32.469794
3252	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 22:18:39.803518
3253	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:39.911918
3254	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:40.699054
3255	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:18:41.075043
3256	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:18:41.711775
3257	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 22:18:55.639943
3258	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 22:18:56.722005
3259	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:18:58.692281
3260	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:18:59.767509
3261	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:19:00.430617
3262	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:19:00.740193
3263	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 22:20:24.913194
3264	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:20:29.690199
3265	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:20:30.164825
3266	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:20:30.19705
3267	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:20:30.646281
3268	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:20:33.974023
3269	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:20:35.135189
3270	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:20:35.718218
3271	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:20:36.497534
3272	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 22:20:54.145056
3273	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:20:56.229104
3274	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:20:56.769158
3275	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:20:57.417617
3276	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:20:58.255536
3277	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-09 22:21:19.307452
3278	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:21:21.576562
3279	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:21:22.204513
3280	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:21:22.942818
3281	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:21:23.82566
3282	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-09 22:21:31.060259
3283	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:21:32.079821
3284	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:21:32.114004
3285	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:21:32.885506
3286	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:21:32.961683
3287	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 22:21:36.368527
3288	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:21:36.674201
3289	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:21:36.737679
3290	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:21:37.469148
3291	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:21:38.057058
3292	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 22:21:43.780866
3293	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:21:43.872668
3294	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:21:44.150997
3295	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:21:44.571903
3296	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:21:45.730637
3297	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-09 22:21:53.413977
3298	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-09 22:21:53.724537
3299	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:21:54.463817
3300	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:21:54.920865
3301	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:21:55.358864
3302	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:21:55.926263
3303	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:22:05.380166
3304	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:22:05.751765
3305	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:22:05.79766
3306	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:22:06.410965
3307	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-09 22:22:20.061779
3308	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:22:20.945103
3309	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:22:21.213669
3310	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:22:21.689267
3311	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:22:22.0887
3312	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 22:22:26.916485
3313	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:22:27.888196
3314	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:22:28.028827
3315	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:22:28.543489
3316	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:22:29.932202
3317	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-09 22:34:41.721449
3318	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:34:43.422674
3319	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:34:43.818682
3320	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:34:45.270877
3321	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:34:46.285561
3322	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 22:34:54.585629
3323	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:34:55.146191
3324	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:34:55.196976
3325	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:34:55.550503
3326	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:34:55.972392
3327	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-09 22:35:02.429142
3328	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:35:03.358858
3329	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:35:04.607433
3330	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:35:05.181667
3331	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:35:06.140198
3332	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-09 22:36:30.061827
3333	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 22:36:30.131164
3334	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:36:31.942746
4576	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 13:19:26.010834
3335	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:36:32.094115
3336	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:36:32.540424
3337	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:36:33.034578
3338	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:36:40.231587
3339	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:36:40.332176
3340	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:36:40.900557
3341	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:36:41.36834
3342	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:36:41.910351
3343	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/evento/nuevo	2025-10-09 22:36:44.86113
3344	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/evento/nuevo	2025-10-09 22:41:18.972921
3345	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:41:19.391885
3346	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:41:22.09412
3347	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:41:23.047275
3348	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:41:23.117587
3349	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:41:23.304116
3350	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/evento/nuevo	2025-10-09 22:43:31.473249
3351	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 22:43:33.63977
3352	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:43:36.161497
3353	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:43:36.251231
3354	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:43:37.274757
3355	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:43:37.639463
3356	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:43:44.965867
3357	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:43:45.414611
3358	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:43:45.920487
3359	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:43:46.084555
3360	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:43:47.104118
3361	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:44:01.183672
3362	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:44:02.567017
3363	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:44:03.087542
3364	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:44:03.84147
3365	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:44:04.855172
3366	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:45:09.313777
3367	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:45:10.872911
3368	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:45:13.139095
3369	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:45:14.362765
3370	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:45:15.019037
3371	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:45:15.657729
3372	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:45:19.80972
3373	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:45:21.120307
3374	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:45:21.524618
3375	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:45:22.427481
3376	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:45:23.552514
3377	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:47:27.020817
3378	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:47:29.381244
3379	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:47:31.127395
3381	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:47:31.647917
3383	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:47:37.576333
3384	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:47:39.363494
3386	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:47:40.825946
4107	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:22:07.493179
4301	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-17 18:51:30.833594
4302	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-17 18:52:31.155399
4303	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:52:31.470839
4304	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:52:32.349775
4305	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:52:32.461103
4306	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:52:33.563683
4307	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-17 18:52:42.413094
4308	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-17 18:52:42.771503
4309	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/publications	2025-10-17 18:52:47.689147
4310	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:52:47.938179
4311	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:52:49.029035
4312	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:52:50.702429
4313	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:52:52.432954
4314	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/publications	2025-10-17 18:53:57.539097
4315	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-17 18:53:58.043018
4316	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-17 18:53:58.606514
4317	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-17 18:53:58.789136
4318	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-17 18:54:00.811664
4343	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 17:47:51.225085
4344	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 17:47:51.945809
4345	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 17:47:52.716832
4346	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-18 17:48:54.341332
4347	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 17:48:56.333584
4348	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 17:48:56.717386
4349	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 17:48:56.816022
4350	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 17:48:57.05724
4421	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-20 13:17:38.812488
4422	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:17:40.29398
4423	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:17:40.867731
4424	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:17:41.435129
4425	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:17:43.675432
4426	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/default-avatar.png	2025-10-20 13:17:43.706683
4427	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/astiazu-joseluis	2025-10-20 13:17:53.726514
4428	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-20 13:17:53.804647
4429	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:17:55.604506
4430	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:17:55.990258
3380	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:47:31.277789
3382	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:47:33.11281
3385	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:47:40.071041
3387	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:47:41.195095
3388	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:56:33.696916
3389	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 22:56:35.175479
3390	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:56:37.615986
3391	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:56:37.928495
3392	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:56:38.48906
3393	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:56:40.001808
3394	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 22:56:44.519036
3395	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 22:56:46.461478
3396	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 22:56:46.774965
3397	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 22:56:47.051344
3398	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 22:56:47.722261
3399	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 23:01:50.633688
3400	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 23:01:50.787989
3401	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:01:51.358806
3402	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:01:52.587849
3403	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:01:52.646446
3404	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:01:52.662071
3405	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 23:02:00.273637
3406	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:02:00.471399
3407	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:02:00.947001
3408	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:02:01.365957
3409	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:02:02.461694
3410	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 23:02:05.913465
3411	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:02:08.461396
3412	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:02:09.106926
3413	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:02:09.903824
3414	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:02:10.423372
3415	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-09 23:03:17.12031
3416	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-09 23:03:18.353258
3417	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:03:19.187266
3418	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:03:19.340593
3419	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:03:19.86893
3420	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:03:21.316242
3421	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/publications	2025-10-09 23:03:25.702615
3422	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:03:26.598148
3423	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:03:26.745613
3424	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:03:27.403836
3425	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:03:29.203206
3426	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notas-publicadas	2025-10-09 23:03:48.597867
3427	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:03:49.170153
3429	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:03:50.494414
3431	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-09 23:04:01.561657
3432	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:04:02.335607
3434	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:04:03.038759
3436	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-09 23:04:10.684019
3437	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:04:11.949195
3439	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:04:13.279315
3441	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-09 23:04:18.898145
4108	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:32:22.569934
4109	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:32:26.313707
4110	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:32:43.755185
4111	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:36:40.155354
4112	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:36:40.746195
4113	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:36:40.961049
4114	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:36:41.016711
4115	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 18:36:58.437683
4116	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 18:36:59.059772
4117	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 18:37:00.03832
4118	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-15 18:37:00.895768
4168	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 16:52:47.466163
4169	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 16:52:47.617534
4170	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-16 16:52:53.292025
4171	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-16 16:52:53.435582
4351	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-18 18:39:54.517297
4352	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 18:39:54.767306
4353	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 18:39:57.461236
4354	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 18:39:58.225908
4355	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 18:39:59.356809
4356	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-18 18:40:11.76736
4357	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-18 18:40:11.803497
4431	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:17:56.661176
4432	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:17:56.766651
4433	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 13:18:02.515851
4434	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:18:02.669172
4435	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:18:03.766864
4436	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:18:06.068206
4437	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:18:06.604354
4438	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 13:25:25.739033
4439	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:25:28.36998
4440	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:25:28.575061
4441	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:25:29.18934
4442	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:25:30.690852
3428	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:03:49.844979
3430	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:03:50.97685
3433	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:04:02.443035
3435	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:04:05.455826
3438	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:04:12.133773
3440	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:04:13.958048
3442	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-09 23:12:19.748875
3443	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-09 23:12:19.953959
3444	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-09 23:12:21.131731
3445	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-09 23:12:21.488187
3446	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-09 23:12:21.64835
3447	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-09 23:12:21.743078
3448	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-10 13:12:00.277239
3449	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:12:01.191326
3450	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:12:02.097603
3451	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:12:02.306597
3452	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:12:02.451129
3453	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-10 13:12:07.148049
3454	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-10 13:12:07.41661
3455	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 13:12:16.889545
3456	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-10 13:12:16.995994
3457	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 13:12:17.71965
3458	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:12:18.77046
3459	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:12:19.158169
3460	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:12:19.309537
3461	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:12:19.674295
3462	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-10 13:12:57.74818
3463	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:12:57.93471
3464	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:12:58.08413
3465	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:12:58.181787
3466	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:12:58.189602
3467	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-10 13:13:06.965248
3468	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:13:07.698672
3469	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:13:07.931101
3470	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:13:08.334428
3471	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:13:08.674288
3472	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 13:13:16.751108
3473	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:13:17.019256
3474	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:13:17.157936
3475	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:13:17.210668
3476	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:13:18.047613
3477	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-10 13:13:29.821398
3478	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:13:30.005974
3479	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:13:30.878067
3480	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:13:31.252589
3481	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:13:31.93914
3482	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-10 13:37:01.111837
3483	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 13:37:04.478151
3484	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:37:04.520633
3485	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:37:06.315608
3486	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:37:07.151572
3487	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:37:07.88597
3488	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:37:08.283442
3489	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:37:08.835217
3490	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:37:09.572546
3491	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:37:10.001267
3492	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 13:37:20.515257
3493	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 13:37:20.829719
3494	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 13:37:20.889293
3495	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 13:37:21.025037
3496	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 13:37:21.333641
3497	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 14:25:22.496295
3498	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:25:23.46312
3499	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:25:23.582266
3500	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:25:23.63012
3501	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:25:23.872311
3502	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 14:26:30.806459
3503	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:26:31.419759
3504	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:26:31.786957
3505	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:26:32.228373
3506	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:26:32.343614
3507	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 14:28:15.53375
3508	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:28:18.064098
3509	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:28:18.381492
3510	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:28:19.089034
3511	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:28:19.335129
3512	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-10 14:44:15.084125
3513	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:44:15.706214
3514	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:44:16.02556
3515	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:44:16.101733
3516	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:44:16.427916
3517	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 14:44:20.380185
3518	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:44:20.591131
3519	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:44:20.710763
3520	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:44:21.496427
3521	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:44:21.888044
3522	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 14:52:55.432583
3523	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 14:52:56.42187
3524	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 14:52:56.593754
3525	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 14:52:56.805672
3526	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 14:52:57.059586
3527	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-10 15:00:44.62036
3528	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:00:45.404565
3529	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:00:45.951454
3530	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:00:46.31475
3531	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:00:46.803533
3532	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:00:51.816873
3533	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:15:15.189841
3534	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:15:15.669349
3535	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:15:15.828537
3536	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:15:15.849045
3537	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:15:16.310975
3538	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/publications	2025-10-10 15:15:52.984479
3539	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:15:53.732548
3540	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:15:53.95619
3541	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:15:54.627109
3542	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:15:55.980667
3543	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notas-publicadas	2025-10-10 15:16:14.759084
3544	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:16:15.310859
3545	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:16:15.522781
3546	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:16:16.276218
3547	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:16:16.902218
3548	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-10 15:16:18.162511
3549	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:16:18.753344
3550	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:16:18.876396
3551	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:16:19.689897
3552	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:16:20.364724
3553	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:16:24.050876
3554	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:16:24.322371
3555	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:16:24.597769
3556	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:16:25.022585
3557	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:16:25.050908
3558	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-10 15:16:37.029795
3559	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:16:38.814032
3560	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:16:39.316005
3561	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:16:41.028945
3562	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:16:41.602204
4358	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-18 18:42:50.908241
3563	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-10 15:16:49.39249
3564	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:16:51.654765
3565	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:16:51.911609
3566	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:16:53.254423
3567	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:16:53.534216
3568	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-10 15:17:22.25879
3569	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-10 15:17:23.616134
3570	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:17:24.43948
3571	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:17:24.610383
3572	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:17:24.969279
3573	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:17:25.736397
3574	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:17:40.09329
3575	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:17:40.544474
3576	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:17:40.675338
3577	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:17:41.03375
3578	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:17:41.159728
3579	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/editar-evento/2	2025-10-10 15:17:52.088294
3580	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:17:54.643062
3581	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:17:55.099129
3582	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:17:55.524919
3583	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:17:56.84381
3584	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 15:18:07.622471
3585	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:18:09.042435
3586	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:18:09.456512
3587	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:18:10.219226
3588	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:18:10.750008
3589	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/eventos	2025-10-10 15:18:28.150943
3590	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:18:28.270088
3591	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:18:28.580643
3592	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:18:28.836512
3593	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:18:29.410749
3594	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/evento/nuevo	2025-10-10 15:18:31.935242
3595	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:18:33.519766
3596	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:18:33.720943
3597	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:18:34.230686
3598	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:18:35.362108
3599	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/3/evento/nuevo	2025-10-10 15:21:57.84309
3600	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 15:21:59.804092
3601	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:22:02.117149
3602	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:22:03.220702
3603	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:22:03.845724
3604	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:22:04.088894
3605	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 15:22:13.268384
3606	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:22:13.911959
3607	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:22:14.848512
3608	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:22:15.37294
3609	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:22:15.928132
3610	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:22:27.711713
3611	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:22:28.269836
3612	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:22:28.420229
3613	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:22:29.257171
3614	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:22:29.426121
3615	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/3	2025-10-10 15:22:42.288836
3616	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/3	2025-10-10 15:24:20.424764
3617	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:24:20.957007
3618	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:24:21.03611
3619	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:24:21.406237
3620	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:24:21.889653
3621	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/3	2025-10-10 15:29:37.447084
3622	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:29:38.057449
3623	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:29:38.364103
3624	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:29:38.861191
3625	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:29:39.80653
3626	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:29:51.792266
3627	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:29:52.159466
3628	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:29:52.298142
3629	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:29:52.61651
3630	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:29:53.60873
3631	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:30:13.439931
3632	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:30:13.551256
3633	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:30:13.736813
3634	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:30:14.049323
3635	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:30:14.28859
3636	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eventos/quique-spada	2025-10-10 15:30:29.968777
3637	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eventos/quique-spada	2025-10-10 15:32:04.878054
3638	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:05.41518
3639	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:05.54995
3640	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:05.578272
3641	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:05.916173
3642	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:32:14.827099
3643	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:15.2861
3644	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:16.005361
3645	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:16.490729
3646	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:17.250518
3647	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eventos/quique-spada	2025-10-10 15:32:19.030843
3648	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:19.585549
3649	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:19.81603
3650	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:20.326787
3651	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:21.031401
3652	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/3	2025-10-10 15:32:22.535354
3653	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:22.714072
3654	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:22.732624
3655	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:23.730704
3656	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:23.98462
3657	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eventos/quique-spada	2025-10-10 15:32:25.872862
3658	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:26.515458
3659	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:26.754724
3660	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:27.94324
3661	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:28.184459
3662	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/eventos/quique-spada	2025-10-10 15:32:31.995614
3663	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:32.303242
3664	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:32.315937
3665	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:32.652864
3666	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:32.90092
3667	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 15:32:36.244286
3668	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 15:32:36.847822
3669	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 15:32:37.081227
3670	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 15:32:37.766797
3671	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 15:32:38.107623
3672	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/3	2025-10-10 19:38:47.035383
3673	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 19:38:47.74927
3674	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 19:38:47.755126
3675	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 19:38:47.879152
3676	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 19:38:47.928957
3677	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 19:38:52.510647
3678	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 19:38:53.083912
3679	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 19:38:53.42572
3680	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 19:38:54.140587
3681	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 19:38:55.161122
3682	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/evento/2	2025-10-10 19:38:57.29889
3683	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 19:38:57.421938
3684	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 19:38:57.620191
3685	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 19:38:57.918051
3686	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 19:38:58.153413
3687	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/quique-spada	2025-10-10 19:39:04.472461
3688	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 19:39:04.69903
3689	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 19:39:04.707818
3690	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 19:39:05.003728
4603	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 14:17:10.67987
3691	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 19:39:06.252791
3692	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-10 23:54:08.384398
3693	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:54:11.791238
3694	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:54:11.971909
3695	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:54:12.433837
3696	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:54:13.050066
3697	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:54:50.329994
3698	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:54:50.458902
3699	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:54:50.871511
3700	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:54:51.168398
3701	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/auth/register	2025-10-10 23:54:54.487831
3702	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:54:55.768147
3703	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:54:56.04794
3704	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:54:56.361422
3705	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:54:56.558696
3706	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/auth/register	2025-10-10 23:55:40.04243
3707	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:55:40.960424
3708	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:55:41.364735
3709	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:55:41.883303
3710	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:55:42.583525
3711	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:09.932496
3712	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:09.958864
3713	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:10.245002
3714	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:11.652759
3715	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-10 23:56:17.184669
3716	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:17.743279
3717	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:17.888791
3718	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:18.176888
3719	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:18.657368
3720	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-10 23:56:21.413314
3721	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:21.908448
3722	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:22.037845
3723	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:22.522233
3724	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:22.949004
3725	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-10 23:56:25.3397
3726	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:25.694206
3727	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:25.956908
3728	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:25.962767
3729	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:26.092651
3730	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-10 23:56:33.096771
3731	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:33.472761
3732	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:33.474715
3733	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:33.73742
3734	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:33.97473
3738	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:56:55.117954
3740	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:56:56.453438
3743	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:57:22.075807
3745	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:57:23.494795
4119	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 20:57:02.380751
4126	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 20:57:11.997756
4172	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 17:03:02.065161
4173	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:03:02.671141
4174	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:03:06.03941
4175	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:03:06.485715
4176	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:03:06.919325
4177	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:03:07.141987
4178	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-16 17:03:17.362529
4179	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:03:19.08573
4180	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:03:19.344525
4181	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:03:20.067206
4182	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:03:21.223493
4183	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 17:03:32.587627
4184	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:03:32.959707
4185	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:03:34.884576
4186	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:03:34.975397
4187	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:03:35.296695
4188	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:03:35.601393
4189	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/dashboard	2025-10-16 17:03:43.208574
4190	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:03:44.68177
4191	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:03:44.944472
4192	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:03:45.523589
4193	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:03:46.131034
4194	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-16 17:04:24.393007
4195	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:04:24.723584
4196	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:04:29.629993
4197	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:04:29.707243
4198	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:04:29.982052
4199	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:04:30.635396
4200	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/upload_csv	2025-10-16 17:04:33.203349
4201	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:04:36.22884
4202	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:04:36.588712
4203	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:04:37.308461
4204	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:04:38.120012
4359	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-18 18:42:51.233449
4360	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-18 18:42:53.27795
4361	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-18 18:42:53.44397
3735	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/3/edit	2025-10-10 23:56:53.461652
3736	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-10 23:56:54.281994
3737	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:56:54.708758
3739	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:56:55.624317
3741	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/auth/register	2025-10-10 23:57:20.257388
3742	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:57:22.001586
3744	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:57:22.424452
3746	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:57:28.734216
3747	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:57:29.157077
3748	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:57:29.458847
3749	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:57:29.526232
3750	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-10 23:57:46.462784
3751	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:57:47.074619
3752	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:57:47.535574
3753	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:57:47.976016
3754	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:57:48.283641
3755	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-10 23:57:52.247142
3756	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:57:53.139261
3757	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:57:53.161721
3758	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:57:53.539663
3759	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:57:53.94495
3760	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-10 23:57:59.805968
3761	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-10 23:58:00.180979
3762	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-10 23:58:00.840176
3763	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-10 23:58:01.00327
3764	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-10 23:58:01.421252
3765	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/consultorio/nuevo	2025-10-11 00:02:51.543575
3766	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-11 00:02:52.483057
3767	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 00:02:55.750251
3768	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 00:02:56.277609
3769	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 00:02:56.411406
3770	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 00:02:56.643834
3771	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/40/eventos	2025-10-11 00:03:01.460393
3772	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 00:03:02.139125
3773	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 00:03:02.812974
3774	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 00:03:02.941883
3775	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 00:03:03.172361
3776	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-11 00:03:10.553453
3777	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 00:03:12.373822
3778	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 00:03:12.389448
3779	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 00:03:12.954896
3780	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 00:03:13.718589
3781	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-11 00:05:25.496215
3782	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-11 00:05:27.249202
3783	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 00:05:28.874252
3785	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 00:05:29.627205
4120	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-15 20:57:02.519425
4123	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 20:57:09.568481
4205	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-16 17:11:26.357945
4206	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:11:26.634319
4207	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:11:26.894096
4208	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:11:26.947807
4209	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:11:27.107968
4210	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:11:58.47326
4211	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:11:58.607053
4212	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:11:59.018204
4213	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:11:59.683261
4214	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-16 17:12:16.282933
4215	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-16 17:12:16.856198
4216	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:12:17.934355
4217	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:12:17.974885
4218	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:12:19.162424
4219	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:12:19.539392
4220	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-16 17:14:00.835235
4221	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:14:02.24349
4222	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:14:02.63608
4223	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:14:03.665895
4224	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:14:04.412995
4225	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-16 17:14:23.637755
4226	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-16 17:14:24.42587
4227	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-16 17:14:24.43368
4228	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-16 17:14:24.444427
4362	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-18 18:42:54.28677
4443	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 13:25:34.599177
4444	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:25:35.148511
4445	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:25:36.407336
4446	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:25:37.409318
4447	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:25:38.37517
4449	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:16:10.115424
4450	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:16:10.632528
4451	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:16:10.988984
4452	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:16:11.412824
4453	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 14:16:34.762658
4454	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:16:35.022431
4455	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:16:35.46287
4456	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:16:36.219728
3784	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 00:05:29.114494
3786	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 00:05:30.114039
3787	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-11 12:43:25.494511
3788	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 12:43:26.356839
3789	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 12:43:27.491636
3790	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 12:43:27.704533
3791	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 12:43:28.016066
3792	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-11 12:43:35.080233
3793	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-11 12:43:35.814628
3794	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-11 12:46:28.645805
3795	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-11 12:46:28.928524
3796	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-11 12:46:29.393384
3797	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 12:46:30.863155
3798	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 12:46:31.186408
3799	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 12:46:31.834863
3800	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 12:46:32.17081
3801	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-11 19:34:24.66997
3802	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 19:34:25.359446
3803	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 19:34:26.394641
3804	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 19:34:26.407337
3805	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 19:34:26.655391
3806	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-11 19:35:20.816958
3807	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 19:35:22.996233
3808	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 19:35:24.49336
3809	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 19:35:25.261942
3810	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 19:35:25.643796
3811	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-11 19:35:34.697174
3812	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 19:35:35.298425
3813	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 19:35:35.335538
3814	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 19:35:35.860947
3815	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 19:35:36.192989
3816	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-11 19:35:42.562843
3817	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-11 19:35:43.032583
3818	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-11 19:35:44.639576
3819	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-11 19:35:45.331983
3820	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-11 19:35:47.348654
3821	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 14:47:05.841522
3822	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:47:09.435866
3823	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:47:09.961276
3824	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:47:11.082891
3825	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:47:12.017488
3826	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-12 14:47:29.104426
3827	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:47:29.880815
3828	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:47:30.130823
3829	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:47:30.853503
3830	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:47:34.394138
3831	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/vigilanciatraslasierra	2025-10-12 14:47:53.620785
3832	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:47:54.329795
3833	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:47:55.520746
3834	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:47:55.738523
3835	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:47:56.530539
3836	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 14:47:58.321613
3837	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:47:59.259628
3838	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:47:59.64636
3839	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:48:02.767055
3840	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:48:02.862763
3841	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/agregar_al_carrito/2	2025-10-12 14:49:21.611215
3842	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 14:49:21.804584
3843	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:49:23.534128
3844	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:49:23.926717
3845	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:49:24.862778
3846	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:49:25.2124
3847	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 14:49:31.040213
3848	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:49:32.321496
3849	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:49:32.715068
3850	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:49:33.566655
3851	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:49:34.180926
3852	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/vaciar_carrito/vigilanciatraslasierra	2025-10-12 14:50:03.585133
3853	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 14:50:03.960145
3854	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 14:50:04.54805
3855	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 14:50:05.918208
3856	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 14:50:07.659473
3857	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 14:50:09.148286
3858	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 15:07:29.678097
3859	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 15:07:33.759763
3860	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 15:07:34.532735
3861	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 15:07:35.12748
3862	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 15:07:35.691462
3863	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/2	2025-10-12 15:07:42.124757
3864	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/2	2025-10-12 15:08:52.146341
3865	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 15:08:52.376816
3866	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 15:19:51.42064
3867	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/2	2025-10-12 15:19:58.776813
3868	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/2	2025-10-12 15:44:48.493963
3869	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 15:44:49.058435
3870	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 15:44:49.537938
3871	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 15:44:49.775738
3872	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 15:44:51.445218
3873	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/3	2025-10-12 15:49:04.138163
3874	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 15:49:05.131357
3875	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 15:49:05.32472
3876	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 15:49:05.855009
3877	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 15:49:06.50249
3878	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 15:59:24.13429
3879	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 15:59:25.886254
3880	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 15:59:26.321091
3881	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 15:59:26.552544
3882	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 15:59:26.770811
3883	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/1	2025-10-12 15:59:32.265605
3884	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/3	2025-10-12 16:05:07.195919
3885	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:05:07.820935
3886	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:05:07.990862
3887	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:05:08.284817
3888	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:05:09.469422
3889	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/agregar_al_carrito/3	2025-10-12 16:07:35.962027
3890	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/3	2025-10-12 16:07:36.304811
3891	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:07:38.322451
3892	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:07:38.483584
3893	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:07:38.981648
3894	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:07:40.883561
3895	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 16:07:46.357846
3896	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:07:46.841255
3897	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:07:47.790501
3898	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:07:48.802251
3899	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:07:49.702666
3900	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 16:07:53.671535
3901	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:07:54.170574
3902	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:07:55.973848
3903	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:07:56.688713
3904	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:07:57.158454
3905	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/vaciar_carrito/vigilanciatraslasierra	2025-10-12 16:08:01.393443
3906	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 16:08:01.787008
3907	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:08:02.541912
3908	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:08:03.625932
3909	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:08:04.561503
3910	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:08:04.678697
3911	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/agregar_al_carrito/1	2025-10-12 16:25:30.094181
3912	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 16:25:31.265113
3913	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:25:34.772542
3914	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:25:35.088955
3915	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:25:35.416115
3916	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:25:37.617839
3917	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 16:25:41.484161
3918	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:25:41.819135
3919	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:25:42.829414
3920	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:25:44.193714
3921	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:25:44.598997
3922	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 16:31:24.009398
3923	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:31:25.517685
3924	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:31:28.100769
3925	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:31:29.046108
3926	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:31:29.859611
3927	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 16:43:10.233726
3928	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:43:13.331961
3929	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:43:13.956974
3930	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:43:14.633752
3931	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:43:14.95798
3932	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/carrito	2025-10-12 16:44:12.50167
3933	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:44:14.460226
3934	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:44:15.302045
3935	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:44:16.122384
3936	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:44:16.882169
3937	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/vaciar_carrito/vigilanciatraslasierra	2025-10-12 16:44:28.474309
3938	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/vigilanciatraslasierra	2025-10-12 16:44:28.880569
3939	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:44:30.613532
3940	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:44:31.102805
3941	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:44:32.021777
3942	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:44:35.073623
3943	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-12 16:45:07.805544
3944	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:45:10.115183
3945	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:45:10.189404
3946	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:45:10.865204
3947	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:45:10.973605
3948	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-12 16:45:16.297006
3949	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:45:17.413248
3950	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:45:18.233095
3951	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:45:18.663772
3952	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:45:20.024163
3953	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/banzai-show-mc	2025-10-12 16:45:24.606333
3954	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 16:45:24.876845
3955	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 16:45:25.284086
3956	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 16:45:25.386628
3957	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 16:45:26.460873
3958	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/banzai-show-mc	2025-10-12 17:35:25.855823
3959	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 17:35:28.407166
3960	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 17:35:29.997096
3961	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 17:35:30.03088
3962	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 17:35:30.833019
3963	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/banzai-show-mc	2025-10-12 18:00:10.612446
3964	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:00:11.70874
3965	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:00:15.989628
3966	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:00:16.170786
3967	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:00:17.333419
3968	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 18:00:22.246158
3969	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/calendario/40/10	2025-10-12 18:01:45.567434
3970	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:01:47.20616
3971	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:01:47.527458
3972	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:01:48.375138
3973	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:01:50.416697
3974	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/api/dias-disponibles/40/10	2025-10-12 18:01:52.069095
3975	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-12 18:02:19.569898
3976	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-12 18:02:21.501106
3977	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-12 18:02:22.50309
3978	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-12 18:02:23.447452
3979	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-12 18:02:24.507545
4121	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-15 20:57:03.044835
4124	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-15 20:57:10.569977
4229	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-16 17:14:25.761363
4363	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 13:05:45.95755
4364	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:05:46.338418
4365	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:05:47.091372
4366	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:05:48.665639
4367	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:05:50.279939
4368	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-20 13:05:55.616522
4369	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 13:05:56.907578
4370	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 13:05:57.027702
4371	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 13:05:57.517946
4372	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 13:05:58.41202
4373	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-32x32.png	2025-10-20 13:06:01.488283
4374	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/favicon-16x16.png	2025-10-20 13:06:02.040299
4375	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-20 13:06:30.001817
4448	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 14:16:08.34681
4457	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:16:36.711442
4458	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 14:16:41.153965
4459	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:16:42.127626
4460	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:16:42.343455
4461	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:16:43.313209
4462	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:16:43.494852
4463	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 14:16:53.835015
4464	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:16:54.50984
4465	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:16:55.410257
4466	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:16:57.57048
4467	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:16:59.068084
4468	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 14:17:54.830035
4469	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:17:55.002895
4470	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:17:56.397464
4471	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:17:57.294465
4472	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:17:57.636272
4473	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 14:18:31.884877
4474	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:18:33.313631
4475	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:18:33.691572
4476	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:18:34.789262
4477	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:18:36.176024
4478	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-20 14:24:24.055383
4479	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:24:25.820575
4480	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:24:25.851827
4481	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:24:26.25223
4483	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:25:11.443085
4484	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:25:12.205803
4485	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:25:13.798139
4486	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:25:14.155567
4487	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:25:19.909169
4488	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:25:19.918932
4489	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:25:19.994132
4490	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:25:20.897475
4491	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-20 14:25:42.852263
4492	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:25:44.700463
4493	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:25:44.770779
4494	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:25:45.394819
4495	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:25:45.437792
4496	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/iniciar-como	2025-10-20 14:27:33.141336
4497	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-20 14:27:33.624035
4498	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:27:35.753722
4499	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:27:35.844546
4500	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:27:36.276199
4501	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:27:37.612671
4502	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 14:27:46.21499
4503	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:27:46.392731
4504	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:27:47.009939
4505	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:27:47.590518
4506	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:27:48.35031
4507	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 14:32:52.907733
4508	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:32:55.580179
4509	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:32:55.759872
4510	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:32:57.15543
4511	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:32:57.839534
4512	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/note/new	2025-10-20 14:34:20.781131
4513	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 14:34:25.329614
4514	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/map.js	2025-10-20 14:34:27.74668
4515	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/css/datosconsultora.css	2025-10-20 14:34:28.053333
4516	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/img/logo-datos.gif	2025-10-20 14:34:28.32287
4517	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/static/js/datosconsultora.js	2025-10-20 14:34:29.907884
4518	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 19:11:30.418993
4519	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notes	2025-10-20 19:11:56.185911
4520	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/notas-publicadas	2025-10-20 19:12:03.296483
4521	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-20 19:12:13.250893
4523	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-21 13:05:07.468404
4524	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-21 13:05:22.710104
4525	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/41/delete	2025-10-21 13:05:34.730995
4526	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-21 13:05:35.006397
4527	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 13:05:50.444879
4528	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-21 13:06:36.702952
4529	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 13:06:36.754465
4530	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-21 13:15:35.318213
4531	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 13:15:35.337748
4532	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-21 13:18:30.167103
4533	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 15:06:54.743021
4534	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-21 17:04:03.926379
4535	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-21 17:04:12.400795
4536	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-21 17:04:22.625269
4537	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-21 17:05:20.671228
4538	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 17:05:31.449917
4539	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:07:25.153075
4540	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:09:48.914404
4541	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:18:11.446912
4542	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:18:25.735002
4544	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:27:06.948731
4545	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 17:27:18.334863
4547	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/verify-email	2025-10-21 19:12:36.203441
4548	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-21 19:12:39.690372
4549	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 19:12:41.966323
4550	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-21 22:35:21.144187
4551	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 22:35:21.476226
4552	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 22:35:36.908848
4553	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-21 22:35:47.450202
4554	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 22:35:47.531257
4555	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 22:36:30.735771
4556	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/asistentes	2025-10-21 22:36:43.30209
4557	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 22:36:43.627783
4558	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 22:37:13.565765
4559	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/42/categorias	2025-10-21 22:37:27.291793
4560	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 22:37:27.329879
4561	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 22:59:47.06842
4562	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-21 23:00:10.02527
4563	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/dashboard	2025-10-21 23:00:16.493269
4564	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin	2025-10-21 23:00:23.090663
4565	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-21 23:00:43.668522
4566	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/42/edit	2025-10-21 23:00:59.544917
4567	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users/42/edit	2025-10-21 23:01:15.820027
4568	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/admin/users	2025-10-21 23:01:15.87569
4569	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-21 23:01:36.099533
4570	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 23:02:06.750006
4571	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-21 23:02:18.335373
4572	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil/editar	2025-10-21 23:24:11.247641
4573	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-21 23:24:14.320434
4574	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-21 23:24:47.543264
4575	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/martin-s	2025-10-21 23:25:07.569345
4577	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-24 13:19:53.169448
4578	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 13:19:53.617212
4579	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 13:20:02.71273
4580	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-24 13:20:49.320229
4581	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/iniciar-como	2025-10-24 13:21:00.018825
4582	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-24 13:21:00.776664
4583	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/categorias	2025-10-24 13:21:31.112628
4584	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/categoria/nueva	2025-10-24 13:22:24.4352
4585	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/categoria/nueva	2025-10-24 13:22:58.247359
4586	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/categorias	2025-10-24 13:22:58.725887
4587	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-24 13:23:10.435753
4588	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/productos	2025-10-24 13:23:18.418926
4589	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/producto/nuevo	2025-10-24 13:23:25.615945
4590	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/producto/nuevo	2025-10-24 13:25:16.962939
4591	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/productos	2025-10-24 13:25:17.067433
4592	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 13:25:25.665381
4593	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/subir-imagen	2025-10-24 13:25:51.14817
4594	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 13:25:54.578466
4595	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 13:26:05.759995
4596	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/productos	2025-10-24 13:26:07.534958
4597	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 13:26:31.949358
4598	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-24 13:26:59.690041
4599	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/astiazu-joseluis	2025-10-24 13:27:19.188268
4600	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/astiazu-joseluis	2025-10-24 13:27:24.340787
4601	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 13:27:39.255357
4602	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 13:47:00.351461
4604	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesionales	2025-10-24 14:17:19.938482
4605	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/cookies	2025-10-24 14:17:46.617109
4606	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 14:17:46.912036
4607	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/profesional/astiazu-joseluis	2025-10-24 14:17:51.576717
4608	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/astiazu-joseluis	2025-10-24 14:17:56.58667
4609	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 14:18:00.771872
4610	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/tienda/astiazu-joseluis	2025-10-24 14:52:12.064087
4611	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 14:52:23.221702
4612	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 15:34:23.845484
4613	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 15:38:14.166697
4614	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/	2025-10-24 15:39:00.743974
4615	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/seleccionar-perfil	2025-10-24 15:39:14.664373
4616	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/iniciar-como	2025-10-24 15:39:18.579055
4617	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/mi-perfil	2025-10-24 15:39:18.609332
4618	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/productos	2025-10-24 15:39:24.869799
4619	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 15:39:28.692195
4620	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/subir-imagen	2025-10-24 15:39:49.831592
4621	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 15:39:51.426376
4622	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/subir-imagen	2025-10-24 15:44:20.940052
4623	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 15:44:22.008942
4624	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/producto/9/editar	2025-10-24 15:44:27.106812
4625	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/2/productos	2025-10-24 15:44:27.471045
4626	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 15:44:40.148728
4627	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 15:50:34.891498
4628	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36	/detalle-producto/9	2025-10-24 15:56:55.244043
\.


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 237
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.appointments_id_seq', 1, false);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 233
-- Name: assistants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.assistants_id_seq', 31, false);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 229
-- Name: availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.availability_id_seq', 1, false);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 225
-- Name: clinic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.clinic_id_seq', 10, true);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 235
-- Name: company_invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.company_invites_id_seq', 1, false);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 247
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.event_id_seq', 4, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 227
-- Name: invitation_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.invitation_logs_id_seq', 1, false);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 241
-- Name: medical_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.medical_records_id_seq', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 221
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.notes_id_seq', 8, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 249
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.product_category_id_seq', 6, true);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 245
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.product_id_seq', 9, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 223
-- Name: publications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.publications_id_seq', 17, false);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 231
-- Name: schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.schedules_id_seq', 1, false);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 217
-- Name: subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.subscribers_id_seq', 6, false);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 239
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.tasks_id_seq', 61, true);


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 215
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 7, false);


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.users_id_seq', 42, true);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 243
-- Name: visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.visits_id_seq', 4628, true);


--
-- TOC entry 4809 (class 2606 OID 16811)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 4794 (class 2606 OID 16595)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- TOC entry 4782 (class 2606 OID 16543)
-- Name: assistants assistants_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_pkey PRIMARY KEY (id);


--
-- TOC entry 4778 (class 2606 OID 16513)
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 16486)
-- Name: clinic clinic_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic
    ADD CONSTRAINT clinic_pkey PRIMARY KEY (id);


--
-- TOC entry 4790 (class 2606 OID 16576)
-- Name: company_invites company_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_pkey PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 16726)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 16500)
-- Name: invitation_logs invitation_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs
    ADD CONSTRAINT invitation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 16644)
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- TOC entry 4768 (class 2606 OID 16449)
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 16755)
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 16702)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 16473)
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- TOC entry 4780 (class 2606 OID 16525)
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 4756 (class 2606 OID 16420)
-- Name: subscribers subscribers_email_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_email_key UNIQUE (email);


--
-- TOC entry 4758 (class 2606 OID 16418)
-- Name: subscribers subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 16614)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4788 (class 2606 OID 16545)
-- Name: assistants uq_assistant_clinic_name; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT uq_assistant_clinic_name UNIQUE (clinic_id, name);


--
-- TOC entry 4752 (class 2606 OID 16411)
-- Name: user_roles user_roles_name_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_name_key UNIQUE (name);


--
-- TOC entry 4754 (class 2606 OID 16409)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4760 (class 2606 OID 16433)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4762 (class 2606 OID 16429)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4764 (class 2606 OID 16435)
-- Name: users users_url_slug_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_url_slug_key UNIQUE (url_slug);


--
-- TOC entry 4766 (class 2606 OID 16431)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4801 (class 2606 OID 16674)
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- TOC entry 4783 (class 1259 OID 16567)
-- Name: ix_assistants_clinic_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_clinic_id ON public.assistants USING btree (clinic_id);


--
-- TOC entry 4784 (class 1259 OID 16566)
-- Name: ix_assistants_doctor_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_doctor_id ON public.assistants USING btree (doctor_id);


--
-- TOC entry 4785 (class 1259 OID 16568)
-- Name: ix_assistants_telegram_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_telegram_id ON public.assistants USING btree (telegram_id);


--
-- TOC entry 4786 (class 1259 OID 16569)
-- Name: ix_assistants_user_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_user_id ON public.assistants USING btree (user_id);


--
-- TOC entry 4791 (class 1259 OID 16587)
-- Name: ix_company_invites_invite_code; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE UNIQUE INDEX ix_company_invites_invite_code ON public.company_invites USING btree (invite_code);


--
-- TOC entry 4792 (class 1259 OID 16588)
-- Name: ix_company_invites_is_used; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_company_invites_is_used ON public.company_invites USING btree (is_used);


--
-- TOC entry 4776 (class 1259 OID 16506)
-- Name: ix_invitation_logs_invite_code; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_invitation_logs_invite_code ON public.invitation_logs USING btree (invite_code);


--
-- TOC entry 4769 (class 1259 OID 16479)
-- Name: ix_publications_slug; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE UNIQUE INDEX ix_publications_slug ON public.publications USING btree (slug);


--
-- TOC entry 4795 (class 1259 OID 16635)
-- Name: ix_tasks_created_by; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_tasks_created_by ON public.tasks USING btree (created_by);


--
-- TOC entry 4826 (class 2606 OID 16596)
-- Name: appointments appointments_availability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_availability_id_fkey FOREIGN KEY (availability_id) REFERENCES public.availability(id);


--
-- TOC entry 4827 (class 2606 OID 16601)
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- TOC entry 4820 (class 2606 OID 16546)
-- Name: assistants assistants_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4821 (class 2606 OID 16561)
-- Name: assistants assistants_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- TOC entry 4822 (class 2606 OID 16551)
-- Name: assistants assistants_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4823 (class 2606 OID 16556)
-- Name: assistants assistants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4817 (class 2606 OID 16514)
-- Name: availability availability_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4815 (class 2606 OID 16487)
-- Name: clinic clinic_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic
    ADD CONSTRAINT clinic_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4824 (class 2606 OID 16582)
-- Name: company_invites company_invites_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4825 (class 2606 OID 16577)
-- Name: company_invites company_invites_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4839 (class 2606 OID 16727)
-- Name: event event_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4840 (class 2606 OID 16737)
-- Name: event event_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 4841 (class 2606 OID 16732)
-- Name: event event_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4842 (class 2606 OID 16802)
-- Name: event event_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- TOC entry 4843 (class 2606 OID 16742)
-- Name: event event_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 4816 (class 2606 OID 16501)
-- Name: invitation_logs invitation_logs_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs
    ADD CONSTRAINT invitation_logs_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4832 (class 2606 OID 16655)
-- Name: medical_records medical_records_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- TOC entry 4833 (class 2606 OID 16650)
-- Name: medical_records medical_records_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4834 (class 2606 OID 16645)
-- Name: medical_records medical_records_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- TOC entry 4811 (class 2606 OID 16460)
-- Name: notes notes_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 4812 (class 2606 OID 16455)
-- Name: notes notes_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- TOC entry 4813 (class 2606 OID 16450)
-- Name: notes notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4844 (class 2606 OID 16787)
-- Name: product_category product_category_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4835 (class 2606 OID 16781)
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_category(id);


--
-- TOC entry 4845 (class 2606 OID 16758)
-- Name: product_category product_category_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.product_category(id);


--
-- TOC entry 4836 (class 2606 OID 16708)
-- Name: product product_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 4837 (class 2606 OID 16703)
-- Name: product product_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4838 (class 2606 OID 16713)
-- Name: product product_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- TOC entry 4814 (class 2606 OID 16474)
-- Name: publications publications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4818 (class 2606 OID 16531)
-- Name: schedules schedules_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4819 (class 2606 OID 16526)
-- Name: schedules schedules_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4828 (class 2606 OID 16620)
-- Name: tasks tasks_assistant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assistant_id_fkey FOREIGN KEY (assistant_id) REFERENCES public.assistants(id);


--
-- TOC entry 4829 (class 2606 OID 16630)
-- Name: tasks tasks_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- TOC entry 4830 (class 2606 OID 16625)
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 4831 (class 2606 OID 16615)
-- Name: tasks tasks_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- TOC entry 4810 (class 2606 OID 16436)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(id);


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO bioforge_user;


--
-- TOC entry 2128 (class 826 OID 16400)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO bioforge_user;


--
-- TOC entry 2127 (class 826 OID 16399)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO bioforge_user;


-- Completed on 2025-10-28 10:58:44

--
-- PostgreSQL database dump complete
--

\unrestrict RYac1PySInZcP15xc2WbHsgnhbZY7g5ytz4BSaxYBVu28NH2bgJ73y3kRNQOOdA

