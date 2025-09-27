--
-- PostgreSQL database dump
--

\restrict VeHyr2YWAVb76zkAbbNWIMs7WJBhyKsU0lQOlBCg9rXx7unEQ76YtSIo4z8Xdze

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_clinic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_assistant_id_fkey;
ALTER TABLE IF EXISTS ONLY public.schedules DROP CONSTRAINT IF EXISTS schedules_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.schedules DROP CONSTRAINT IF EXISTS schedules_clinic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.publications DROP CONSTRAINT IF EXISTS publications_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notes DROP CONSTRAINT IF EXISTS notes_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notes DROP CONSTRAINT IF EXISTS notes_patient_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notes DROP CONSTRAINT IF EXISTS notes_approved_by_fkey;
ALTER TABLE IF EXISTS ONLY public.medical_records DROP CONSTRAINT IF EXISTS medical_records_patient_id_fkey;
ALTER TABLE IF EXISTS ONLY public.medical_records DROP CONSTRAINT IF EXISTS medical_records_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.medical_records DROP CONSTRAINT IF EXISTS medical_records_appointment_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invitation_logs DROP CONSTRAINT IF EXISTS invitation_logs_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.company_invites DROP CONSTRAINT IF EXISTS company_invites_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.company_invites DROP CONSTRAINT IF EXISTS company_invites_clinic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.clinic DROP CONSTRAINT IF EXISTS clinic_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.availability DROP CONSTRAINT IF EXISTS availability_clinic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS assistants_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS assistants_doctor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS assistants_created_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS assistants_clinic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.appointments DROP CONSTRAINT IF EXISTS appointments_patient_id_fkey;
ALTER TABLE IF EXISTS ONLY public.appointments DROP CONSTRAINT IF EXISTS appointments_availability_id_fkey;
DROP INDEX IF EXISTS public.ix_tasks_created_by;
DROP INDEX IF EXISTS public.ix_publications_slug;
DROP INDEX IF EXISTS public.ix_invitation_logs_invite_code;
DROP INDEX IF EXISTS public.ix_company_invites_is_used;
DROP INDEX IF EXISTS public.ix_company_invites_invite_code;
DROP INDEX IF EXISTS public.ix_assistants_user_id;
DROP INDEX IF EXISTS public.ix_assistants_telegram_id;
DROP INDEX IF EXISTS public.ix_assistants_doctor_id;
DROP INDEX IF EXISTS public.ix_assistants_clinic_id;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_url_slug_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_pkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_name_key;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS uq_assistant_clinic_name;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_pkey;
ALTER TABLE IF EXISTS ONLY public.subscribers DROP CONSTRAINT IF EXISTS subscribers_pkey;
ALTER TABLE IF EXISTS ONLY public.subscribers DROP CONSTRAINT IF EXISTS subscribers_email_key;
ALTER TABLE IF EXISTS ONLY public.schedules DROP CONSTRAINT IF EXISTS schedules_pkey;
ALTER TABLE IF EXISTS ONLY public.publications DROP CONSTRAINT IF EXISTS publications_pkey;
ALTER TABLE IF EXISTS ONLY public.notes DROP CONSTRAINT IF EXISTS notes_pkey;
ALTER TABLE IF EXISTS ONLY public.medical_records DROP CONSTRAINT IF EXISTS medical_records_pkey;
ALTER TABLE IF EXISTS ONLY public.invitation_logs DROP CONSTRAINT IF EXISTS invitation_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.company_invites DROP CONSTRAINT IF EXISTS company_invites_pkey;
ALTER TABLE IF EXISTS ONLY public.clinic DROP CONSTRAINT IF EXISTS clinic_pkey;
ALTER TABLE IF EXISTS ONLY public.availability DROP CONSTRAINT IF EXISTS availability_pkey;
ALTER TABLE IF EXISTS ONLY public.assistants DROP CONSTRAINT IF EXISTS assistants_pkey;
ALTER TABLE IF EXISTS ONLY public.appointments DROP CONSTRAINT IF EXISTS appointments_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_roles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tasks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.subscribers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.schedules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.publications ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.notes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.medical_records ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.invitation_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.company_invites ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.clinic ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.availability ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.assistants ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.appointments ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_roles_id_seq;
DROP TABLE IF EXISTS public.user_roles;
DROP SEQUENCE IF EXISTS public.tasks_id_seq;
DROP TABLE IF EXISTS public.tasks;
DROP SEQUENCE IF EXISTS public.subscribers_id_seq;
DROP TABLE IF EXISTS public.subscribers;
DROP SEQUENCE IF EXISTS public.schedules_id_seq;
DROP TABLE IF EXISTS public.schedules;
DROP SEQUENCE IF EXISTS public.publications_id_seq;
DROP TABLE IF EXISTS public.publications;
DROP SEQUENCE IF EXISTS public.notes_id_seq;
DROP TABLE IF EXISTS public.notes;
DROP SEQUENCE IF EXISTS public.medical_records_id_seq;
DROP TABLE IF EXISTS public.medical_records;
DROP SEQUENCE IF EXISTS public.invitation_logs_id_seq;
DROP TABLE IF EXISTS public.invitation_logs;
DROP SEQUENCE IF EXISTS public.company_invites_id_seq;
DROP TABLE IF EXISTS public.company_invites;
DROP SEQUENCE IF EXISTS public.clinic_id_seq;
DROP TABLE IF EXISTS public.clinic;
DROP SEQUENCE IF EXISTS public.availability_id_seq;
DROP TABLE IF EXISTS public.availability;
DROP SEQUENCE IF EXISTS public.assistants_id_seq;
DROP TABLE IF EXISTS public.assistants;
DROP SEQUENCE IF EXISTS public.appointments_id_seq;
DROP TABLE IF EXISTS public.appointments;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
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
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
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
-- Name: assistants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.assistants_id_seq OWNED BY public.assistants.id;


--
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
-- Name: availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.availability_id_seq OWNED BY public.availability.id;


--
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
-- Name: clinic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.clinic_id_seq OWNED BY public.clinic.id;


--
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
-- Name: company_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.company_invites_id_seq OWNED BY public.company_invites.id;


--
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
-- Name: invitation_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.invitation_logs_id_seq OWNED BY public.invitation_logs.id;


--
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
-- Name: medical_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.medical_records_id_seq OWNED BY public.medical_records.id;


--
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
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
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
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.publications_id_seq OWNED BY public.publications.id;


--
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
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: bioforge_user
--

CREATE TABLE public.subscribers (
    id integer NOT NULL,
    email character varying(150) NOT NULL,
    subscribed_at timestamp without time zone
);


ALTER TABLE public.subscribers OWNER TO bioforge_user;

--
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
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.subscribers_id_seq OWNED BY public.subscribers.id;


--
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
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
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
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
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
    role_id integer
);


ALTER TABLE public.users OWNER TO bioforge_user;

--
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
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bioforge_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: assistants id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants ALTER COLUMN id SET DEFAULT nextval('public.assistants_id_seq'::regclass);


--
-- Name: availability id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability ALTER COLUMN id SET DEFAULT nextval('public.availability_id_seq'::regclass);


--
-- Name: clinic id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic ALTER COLUMN id SET DEFAULT nextval('public.clinic_id_seq'::regclass);


--
-- Name: company_invites id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites ALTER COLUMN id SET DEFAULT nextval('public.company_invites_id_seq'::regclass);


--
-- Name: invitation_logs id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs ALTER COLUMN id SET DEFAULT nextval('public.invitation_logs_id_seq'::regclass);


--
-- Name: medical_records id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records ALTER COLUMN id SET DEFAULT nextval('public.medical_records_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications ALTER COLUMN id SET DEFAULT nextval('public.publications_id_seq'::regclass);


--
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- Name: subscribers id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers ALTER COLUMN id SET DEFAULT nextval('public.subscribers_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.appointments (id, availability_id, patient_id, status, created_at) FROM stdin;
\.


--
-- Data for Name: assistants; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.assistants (id, name, email, whatsapp, is_active, created_at, clinic_id, doctor_id, telegram_id, type, user_id, created_by_user_id) FROM stdin;
2	Rodolfo	rodolfo@gmail.com	+541176376566	t	2025-09-26 23:02:28.869541	1	2	6210586580	common	\N	\N
3	Mabel	macalu1966@gmail.com	+5491160524863	t	2025-09-26 23:02:28.884186	\N	2	6210586580	common	\N	\N
4	Luca	elvasquito16@gmail.com	+5493544570009	t	2025-09-26 23:02:28.890045	\N	4	\N	common	\N	\N
6	PERRO	astiazu@gmail.com	+5493544404054	t	2025-09-26 23:02:28.974037	\N	6	\N	common	\N	\N
14	Benitez		5491165964909	t	2025-09-26 23:02:28.987709	3	6	\N	common	\N	\N
9	Claudio		+5491154571803	t	2025-09-26 23:02:28.997475	\N	6	\N	common	\N	\N
15	Candela		+5491160152137	t	2025-09-26 23:02:29.003339	\N	6	\N	common	\N	\N
8	Agustin		+5491127567346	t	2025-09-26 23:02:29.009194	3	6	\N	common	\N	\N
10	Vicente Pintor		+5491134989650	t	2025-09-26 23:02:29.11076	3	6	\N	common	\N	\N
12	Alejandro electricista		+5491170611762	t	2025-09-26 23:02:29.390065	3	6	\N	common	\N	\N
11	William Albañil		+5491130396026	t	2025-09-26 23:02:29.496511	3	6	\N	common	\N	\N
13	Juan electricista		+5491134990533	t	2025-09-26 23:02:29.501397	3	6	\N	common	\N	\N
5	juan cirio		+5491161329953	t	2025-09-26 23:02:29.572684	3	6	\N	common	\N	\N
7	Stefy		+5492344441364	t	2025-09-26 23:02:29.583424	3	6	\N	common	\N	\N
16	Emiliano	emiliano@gmail.com	+5491162919904	t	2025-09-26 23:02:29.588797	\N	2	\N	common	\N	\N
17	Gustavo Pendex	gusty5873@GMAIL.COM	+5491169660766	t	2025-09-26 23:02:29.595635	3	6	\N	common	\N	\N
18	Junior	jarajunior5@gmail.com	+5491125460229	t	2025-09-26 23:02:29.609307	3	6	\N	common	\N	\N
19	Stefy	stefyocen99@gmail.com		t	2025-09-26 23:02:29.633719	5	2	\N	common	\N	\N
21	Jose Herrero		+5491150248868	t	2025-09-26 23:02:29.672787	\N	6	\N	common	\N	\N
22	Alberto Plomero		+5491165526968	t	2025-09-26 23:02:29.682551	\N	6	\N	common	\N	\N
20	Alfredo Pintor		+5491168804039	t	2025-09-26 23:02:29.687436	\N	6	\N	common	\N	\N
23	PRIMITIVO BOLITA		+5491140641851	t	2025-09-26 23:02:29.696225	3	6	\N	common	\N	\N
24	Martin yerno Benitez		+5491123549775	t	2025-09-26 23:02:29.849549	3	6	\N	common	\N	\N
25	David		+5491172233722	t	2025-09-26 23:02:29.858338	3	6	\N	common	\N	\N
\.


--
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.availability (id, clinic_id, date, "time", is_booked) FROM stdin;
\.


--
-- Data for Name: clinic; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.clinic (id, name, address, phone, specialty, doctor_id, is_active) FROM stdin;
2	Corralon El Vasquito - 9 de Julio -	9 de julio - Mina Clavero	+5493544470679	Construcción y Venta de Materiales	4	t
3	Gina 1	Quesada 4380			6	t
1	Datos Consultora	Villa Urquiza	+5493544404054	Tecnología - Automatización - Big Data	2	t
4	GINA 1	QUESADA 4380	+5492344441364	ARQUITECTURA	13	t
5	Palomar	Virasoro 586	+5491160524863	Tecnología	2	t
\.


--
-- Data for Name: company_invites; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.company_invites (id, doctor_id, invite_code, email, name, clinic_id, whatsapp, assistant_type, is_used, created_at, expires_at, used_at) FROM stdin;
\.


--
-- Data for Name: invitation_logs; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.invitation_logs (id, invite_code, email, method, success, error_message, sent_at, doctor_id, assistant_name) FROM stdin;
\.


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.medical_records (id, patient_id, doctor_id, appointment_id, title, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.notes (id, title, content, status, user_id, patient_id, created_at, approved_by, approved_at, updated_at, featured_image, view_count) FROM stdin;
1	Estamos de vuelta !!	🌸🎶 Vuelve BanZaiShow – MC 🎶🌸\r\nDespués del parate de marzo, este sábado 20 de septiembre reabrimos el escenario con todo: llega la banda de Carlos Flores para ponerle música, energía y fiesta al arranque de la primavera. 🌺🔥\r\n\r\nEs el regreso que estabas esperando: un show que mezcla la potencia de la banda en vivo, el espíritu de BanZai y la promesa de una temporada de verano que arranca a pura música y diversión.\r\n\r\n📍 Lugar: Poeta Lugones 1443 - a metros de la calle San Martín - Mina Clavero -\r\n🕘 Hora: 23\r\n🎟️ Entrada: llamanos al +54 351 202 6579 \r\n\r\n👉 Vení con tus amigos, preparate para cantar, bailar y ser parte de este renacer. BanZaiShow – MC vuelve y lo hace a lo grande.	published	3	\N	2025-09-15 16:09:11.829155	1	2025-09-15 16:10:10.673182	2025-09-18 14:10:06.384342	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757952551/notes/o7uwlprajx126yanemz7.jpg	33
3	El precio de construcción por metro cuadrado llegó a $ 1.865.348,15 en agosto de 2025.	🔴 Según la Asociación de Pymes de la Construcción de la Provincia de Buenos Aires (Apymeco), el precio de construcción por metro cuadrado llegó en agosto de 2025 a $ 1.865.348,15, lo que representa una variación mensual del 0,66% respecto a julio. Si agosto protagonizó aumentos, fueron menores a los protagonizados en meses anteriores.\r\n\r\nSegún la entidad, el crecimiento interanual fue del 25,99 por ciento, mientras en lo que va del año el aumento fue del 16,62 por ciento. La variación mensual de  materiales para la construcción fue del 0,76%, mientras que la mano de obra lo hizo en un 0,67 por ciento.	private	4	\N	2025-09-16 14:44:54.835442	\N	\N	2025-09-16 14:44:54.835457	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758033894/notes/elcgqsvc8tww0m1sjwa3.png	0
4	👏👏 Ingresaron carretillas y hormigoneras!	Visita nuestro local en 9 de julio 961!!👏👏\r\n\r\n- Detalles del producto\r\n\r\n- Precio\r\n\r\n- Forma de pago	private	4	\N	2025-09-16 19:36:41.095883	\N	\N	2025-09-16 19:36:41.095891	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758051400/notes/nbv0wekyn2aiuvkrigdf.jpg	0
5	📌 ¿Cómo preparar tu obra para recibir el hormigón?	Antes de la llegada del mixer, hay detalles clave que aseguran una descarga rápida, segura y sin contratiempos:\r\n\r\n🔸 Acceso libre para el camión y/o bomba\r\n🔸 Personal listo para distribuir y nivelar\r\n🔸 Encofrado limpio y húmedo\r\n🔸 Herramientas listas\r\n\r\n✅ Una obra preparada ahorra tiempo, evita pérdidas y garantiza mejores resultados.\r\n\r\n📲 ¿Tenés dudas sobre tu próxima obra? Escribinos y te asesoramos.	private	4	\N	2025-09-16 20:12:47.252536	\N	\N	2025-09-16 20:12:47.252544	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758053566/notes/wz7fp3ouibrkcifw30oo.jpg	0
2	Microsoft Power BI - CURSO GRATUITO	Microsoft Power BI - CURSO GRATUITO\r\n\r\nCertificado Profesional en Visualización de Datos de Microsoft\r\n\r\nFormulario de inscripción: https://forms.gle/7z1jPqa7JA89ojJB9\r\n\r\nDesarrollá habilidades en análisis y visualización de datos.\r\nAdquirí competencias laborales para una carrera en visualización de datos, una de las áreas más demandadas.\r\nNo se requiere experiencia previa ni título universitario para comenzar.\r\n\r\n🌟 Primer encuentro gratuito online\r\n\r\n📅 Sábado 20 de septiembre\r\n🕖 10 a 13 hs (Argentina, GMT-3)\r\n💻 Modalidad online (Zoom) – el enlace te lo mandamos por mail el día de la clase\r\n🎓 Organiza: Centro de Graduados de Ingeniería – UBA\r\n\r\n¡ATENCIÓN SUPER REGALO!\r\n\r\nTodos los que completen el formulario, se conecten al zoom y den el presente recibirán en forma totalmente gratis el acceso al curso:\r\n\r\nMicrosoft - Power BI\r\nFundamentos de Visualización de Datos\r\nEste curso forma parte del Certificado Profesional en Visualización de Datos con Power BI de Microsoft\r\nImpartido en español (doblaje con IA)\r\n\r\nPodrás obtener un certificado oficial de Microsoft a tu nombre \r\n\r\nCertificado Profesional – Serie de 5 cursos\r\n\r\nFormulario de inscripción: https://forms.gle/7z1jPqa7JA89ojJB9	published	2	\N	2025-09-15 16:44:09.767201	1	2025-09-15 16:45:10.177284	2025-09-17 19:13:49.508365	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757954649/notes/wol6rptl1i2bgy0zge6a.jpg	29
6	Para aumentar la oferta de dólares, no habrá retenciones a los granos hasta el 31 de octubre	- El gobierno nacional dispuso que no le cobrará retenciones a los granos hasta el 31 de octubre o hasta que se concreten declaraciones juradas de exportación por USD 7 mil millones, lo que ocurra primero. La medida busca generar una mayor oferta de dólares luego de varios días de suba que llevaron la cotización oficial a $1.515 y le provocaron pérdidas de más de USD 1.100 millones en las reservas del Banco Central.\r\n- “La vieja política busca generar incertidumbre para boicotear el programa de gobierno. Al hacerlo castigan a los argentinos: no lo vamos a permitir. Por eso, y con el objetivo de generar mayor oferta de dólares durante este período, hasta el 31 de octubre habrá retenciones cero para todos los granos. Fin”, anticipó el funcionario.\r\n- Voceros del Ministerio de Economía detallaron que la medida alcanza a la soja, el maíz, el trigo, la cebada, el sorgo y el girasol.\r\n- El anuncio oficial tomó por sorpresa al presidente de la Sociedad Rural Argentina (SRA), Nicolás Pino, quien se enteró del cambio regulatorio mientras daba una entrevista a Radio Mitre.	published	2	\N	2025-09-22 16:47:03.403187	2	2025-09-22 16:47:40.12416	2025-09-24 13:44:04.252544	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758559622/notes/hbmfqnsmtogiutumo8fo.png	1
\.


--
-- Data for Name: publications; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.publications (id, slug, type, title, content, excerpt, is_published, user_id, tags, read_time, created_at, updated_at, published_at, image_url, view_count) FROM stdin;
2	\N	Deportes	Argentina dio vuelta un partidazo y le ganó 3-2 a Finlandia por el debut del Mundial de vóley	Argentina debutó en el Mundial de vóley con una remontada histórica: tras ir 0-2 contra Finlandia, ganó 3-2 con parciales 19-25, 18-25, 25-22, 25-22 y 15-11 en 2h30, primer tie-break del torneo. Sin jugar bien, pero con carácter, logró por primera vez dar vuelta un 0-2 en un Mundial.\r\n\r\nMarcelo Méndez sorprendió con Matías Sánchez como armador y De Cecco al banco, completando con Kukartsev, Loser, Gallego, Palonsky, Vicentín y Danani. El inicio fue errático, con bloqueo finlandés implacable (5-0 en el primer set). Los europeos dominaron saque y defensa, y se llevaron los dos primeros parciales casi sin oposición.\r\n\r\nEn el tercero, Méndez devolvió a De Cecco y el equipo mostró otra cara: más defensa, presión desde el saque y puntos claves de Palonsky y Kukartsev. Argentina ganó confianza, sostuvo la presión y forzó el tie-break.\r\n\r\nEn el quinto, los errores de Marttila y el ingreso decisivo de Martínez (bloqueo y ace vital) inclinaron la balanza. Finlandia se desmoronó en el cierre y Argentina selló el 15-11. Fue un triunfo trabajado, irregular en el juego pero enorme en carácter, que sirve para creer de cara al choque contra Corea.\r\n\r\nFormación inicial: Sánchez, Kukartsev, Loser, Gallego, Vicentín, Palonsky y Danani. Ingresaron De Cecco, Gómez, Martínez, Armoa, Zerba y Giraudo.	Pese a que arrancó 0-2 en sets y desdibujada, la Selección lo pudo ganar con el ingreso clave de Martínez y mejoras varias. Ahora se viene Corea para pensar en los octavos de final.	t	1	argentina, mundial, remontada, mendez	\N	2025-09-15 13:58:30.509061	2025-09-15 22:34:58.640416	2025-09-15 13:58:30.508436	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757944710/publications/jwccsrisdzof2ncnir81.jpg	1
4	\N	Cultura	🚶‍♂️✨ Camino del Peregrino: fe, tradición y comunidad en movimiento ✨🚶‍♀️	El domingo, desde las primeras horas, cientos de fieles emprendieron la caminata por el Camino del Peregrino, partiendo desde Giulio Cesare y llegando al Santuario del Cura Brochero. Cada paso estuvo cargado de oraciones, intenciones y agradecimientos, en una experiencia única que combina espiritualidad, tradición, naturaleza y cultura.\r\n\r\nLa gran novedad de este año fue el Primer Encuentro de Peregrinos, realizado el sábado, con la Misa del Peregrino, espectáculos artísticos y momentos de preparación espiritual que reforzaron el sentido comunitario de la experiencia.\r\n\r\nPero la peregrinación no solo dejó huella en lo religioso: también impactó en la economía local, impulsando hotelería, gastronomía y comercios. A la vez, la articulación entre instituciones, municipios, fuerzas de seguridad, vecinos y voluntarios garantizó un evento seguro, organizado y hospitalario.\r\n\r\nEl presidente de la Agencia Córdoba Turismo, Darío Capitani, lo resumió con claridad:\r\n“El Santo Brochero no solo representa un ejemplo de fe y compromiso social, sino también un motor para el turismo religioso, que moviliza a miles de personas y posiciona a Córdoba como un destino espiritual único en el país”.\r\n\r\nLa actividad fue organizada por la Diócesis de Cruz del Eje, el Santuario del Cura Brochero y la Municipalidad de Villa Cura Brochero, con el acompañamiento del Gobierno de Córdoba a través de la Agencia Córdoba Turismo.	El evento, que ya se ha consolidado como uno de los encuentros de fe más importantes del país, reafirma a Villa Cura Brochero como un destino central del turismo religioso en Córdoba.	t	2	misa, peregrinos, religion, caminata, cura brochero, santo brochero	\N	2025-09-15 16:39:23.094835	2025-09-15 17:04:13.369125	2025-09-15 16:39:23.094096	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757954363/publications/b7hixjbcdnjdhnusuvob.jpg	1
3	\N	Cultura	BanZaiShow - MC - Esta de vuelta !!	🌸🎶 Vuelve BanZaiShow – MC 🎶🌸\r\nDespués del parate de marzo, este Sábado 20 de septiembre reabrimos el escenario con todo: llega la banda de Carlos Flores para ponerle música, energía y fiesta al arranque de la primavera. 🌺🔥\r\n\r\nEs el regreso que estabas esperando: un show que mezcla la potencia de la banda en vivo, el espíritu de BanZai y la promesa de una temporada de verano que arranca a pura música y diversión.\r\n\r\n📍 Lugar: Poeta Lugones 1443 - a metros de la calle San Martín - Mina Clavero -\r\n🕘 Hora: 23\r\n🎟️ Entrada: llamanos al +54 351 202 6579 \r\n\r\n👉 Vení con tus amigos, preparate para cantar, bailar y ser parte de este renacer. BanZaiShow – MC vuelve y lo hace a lo grande.	- Volvimos !!! y queremos festejarlos con todo ... !	t	1	Entretenimiento, diversión, noche, mina clavero, baile, carlos flores	\N	2025-09-15 16:23:12.889797	2025-09-21 16:08:21.014882	2025-09-15 16:23:12.888177	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757953393/publications/pzwru665yxneqmatr1xt.jpg	39
1	\N	Análisis	A cuánto cerró el dólar blue este viernes 12 de septiembre	El dólar blue hoy viernes 12 de septiembre de 2025, cerró de la siguiente manera para esta jornada cambiaria.\r\n\r\nA cuánto cotiza el dólar Blue\r\nEl dólar paralelo cotiza con un valor en el mercado de $1405,00 para la compra y $1425,00 para la venta.\r\n\r\nA cuánto cotiza el dólar Oficial\r\nSegún la pizarra del Banco de la Nación Argentina (BNA), este viernes 12 de septiembre cerró en $1390,00 para la compra y $1440,00 para la venta.\r\n\r\nA cuánto cotiza el dólar MEP\r\nEl dólar MEP, también conocido como dólar bolsa, cerró en $1415,00 para la compra, $1465,00 para la venta.\r\n\r\nA cuánto cotiza el dólar contado con liquidación\r\nEl dólar contado con liquidación (CCL) cerró en las pizarras a $1460,70 para la compra y $1462,00 para la venta.\r\n\r\nA cuánto cotiza el dólar cripto\r\nA través de las operaciones con criptomonedas, el dólar cripto cotiza en $1464,12\r\n\r\n​para la compra, y en $1468,27 para la venta.\r\n\r\nA cuánto cotiza el dólar tarjeta\r\nEl tipo de cambio, al cual se debe convertir el monto en dólares que nos llega en el resumen de nuestra tarjeta, opera hoy en $1904,50.\r\n\r\nLos consumos en moneda extranjera pueden ser por utilización de productos digitales, plataformas de streaming o compras en el exterior.\r\n\r\nRiesgo País\r\nEl riesgo país es un indicador elaborado por el JP Morgan que mide la diferencia que pagan los bonos del Tesoro de Estados Unidos contra las del resto de los países.\r\n\r\nEste jueves 11 de septiembre dicho índice ubicó al riesgo país en 1070 puntos básicos.	Conocé como cerró en el mercado la divisa norteamericana el viernes, 12 de septiembre del 2025	t	1		\N	2025-09-15 13:51:02.402106	2025-09-15 21:32:17.354441	2025-09-15 13:51:02.399277	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757944263/publications/xqhq07yrseavad3dxg57.png	2
6	\N	Educativo	🌾 Conferencia sobre Condiciones Climáticas – Campaña 2025-2026 🌦	🌾 Conferencia sobre Condiciones Climáticas – Campaña 2025-2026 🌦\r\n📅 19 de septiembre – 18:00 hs\r\n📍 Consorcio Caminero N°151, Alto Grande\r\n\r\n🎙 Disertante: Rafael Di Marco\r\n🎟 Entradas: $20.000 general | $15.000 socios\r\n(Cupos limitados)\r\n\r\nAdquirí tu entrada completando el formulario \r\n https://docs.google.com/forms/d/e/1FAIpQLSfUbhNYh57IN4HQZKiBOUhYFTHaBNdfAdmhr1Q1Bsbtl6kAMg/viewform?usp=header \r\n\r\n👉 Reservá tu lugar al 3544-410592	Expertos y productores analizarán cómo las variaciones climáticas afectarán la campaña 2025-2026: lluvias, sequías, plagas y su impacto en rindes, costos y logística. Se discutirán modelos predictivos, estrategias de adaptación, manejo de suelo, seguros agrícolas y políticas públicas para mitigar riesgos y mejorar la resiliencia del sector agropecuario. Prácticas sostenibles.	t	1	#Clima, #Agro2025, #CampañaAgrícola,  #SustentabilidadRural,  #ProductoresEnAcción	\N	2025-09-17 11:47:32.627416	2025-09-17 11:47:49.535005	2025-09-17 11:47:32.626069	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758109653/publications/kv2gsszf7uyeulfkxidl.jpg	1
5	\N	Deportes	Argentina 3 - Korea 1 ! Con un pie en segunda ronda.	En su segunda presentación del Grupo C del Mundial, la Selección masculina dirigida por Marcelo Méndez superó a Corea del Sur por 3-1 y quedó muy cerca de la segunda ronda.\r\n\r\nEl arranque fue parejo, con un rival que mostró mejorías pero nunca logró incomodar en serio. La diferencia estuvo en los momentos clave: el ingreso de Nico Zerba (2,04 m) dio aire con un pasaje de 3-0, y los bloqueos de Pablo Kukartsev y los puntos de Luciano Vicentín inclinaron la balanza.\r\n\r\nEl tercer set fue todo celeste y blanco: variantes, solidez y un Kukartsev imparable con 21 puntos y 3 bloqueos. Con esa contundencia, Argentina cerró un 25-18 que sentenció la historia y dejó al equipo con la confianza a tope para lo que viene.	El seleccionado nacional masculino, dirigido por Marcelo Méndez, le ganó por 3-1 a Corea del Sur, que disputan su segunda presentación por el Grupo D del Mundial que se celebra en Filipinas. Pablo Kukartsev fue el máximo anotador con 21 puntos.	t	1	seleccion argentina, voley, mundial, segunda ronda, korea	\N	2025-09-16 11:56:02.478456	2025-09-16 15:04:24.177555	2025-09-16 11:56:02.444156	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758023763/publications/jjkt9iyvnkopl5uyhwi8.jpg	2
7	\N	Tecnología	Marina Hasson: “La incorporación de la IA en las pymes es un camino, no es prender y apagar la luz”	La inteligencia artificial (IA) dejó de ser promesa y ya persigue a empresas de todos los tamaños. Según Marina Hasson, directora de pymes en Microsoft para Latam, su adopción es un camino, no una receta lista: se ajusta a cada realidad y a lo que muestre mejor retorno.\r\n\r\nEl estudio 2025 de Microsoft/Edelman muestra que, en Argentina, la importancia de la IA para las pymes se cuadruplicó en un año, pasando del 7% al 30%, sobre todo en medianas. Los principales desafíos: reducir costos, ganar clientes y aumentar ventas.\r\n\r\nHasson identifica cuatro ejes estratégicos: experiencia de empleados (retener talento), interacción con clientes (mejor servicio), automatización de procesos y espacio para la innovación. Todo con seguridad como base crítica: proteger datos, dispositivos e identidades.\r\n\r\nHoy existe un fenómeno de “traer tu propia IA”, lo que obliga a uniformidad y gobernanza interna. La clave, dice Hasson, es la cultura organizacional y un liderazgo fuerte que impulse la adopción, con apoyo de Tecnología y Recursos Humanos.\r\n\r\nEl estudio revela que el 54% de las pymes ya tiene estrategia de IA, y 82% ve con optimismo su uso, aunque el 49% admite que necesita cambios culturales. Además, el 58% ya usa alguna IA, y 83% planea invertir en 2025.\r\n\r\nMotivos: en microempresas, la prioridad es costos y continuidad; en medianas, competencia, eficiencia e innovación. Las aplicaciones más comunes son: atención al cliente virtual, búsquedas de información y marketing con IA generativa.\r\n\r\nEn síntesis: la adopción avanza a distintas velocidades, pero las oportunidades para pymes están en mejorar la experiencia laboral, el servicio al cliente, la eficiencia de procesos y el valor agregado en productos o servicios.	La número uno del segmento de pymes de Microsoft para la región, destaca que en un año se cuadriplicó la importancia de proyectos con la nueva tecnología en la Argentina	t	2	IA, Tecnología, PYMES, Empresas, oportunidades	\N	2025-09-18 11:53:24.968108	2025-09-18 11:53:26.373209	2025-09-18 11:53:24.964108	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758196405/publications/ntv2dgjrmbrumh65pilz.png	0
9	\N	Tecnología	Qué sectores lideran la implementación de la inteligencia artificial en Argentina	La inteligencia artificial convirtió en un factor clave para la transformación digital de las empresas en Argentina. De acuerdo a un estudio de International Data Corporation (IDC), la inversión en tecnologías de IA en América Latina alcanzará los $3,400 millones en 2025, y en el país. Estas industrias están aprovechando la IA para personalizar servicios y mejorar la experiencia del cliente, marcando el camino hacia un uso más sofisticado de los datos. \r\n\r\nLos usuarios demandan servicios más personalizados, y el análisis de datos históricos y preferencias permite a las empresas ofrecer soluciones a medida. Esto es posible gracias a la implementación de tecnologías de IA que explotan la información de manera eficiente.\r\n\r\nAunque la adopción de IA crece de manera sostenida, algunos sectores enfrentan desafíos significativos. Entre ellos, se destaca el sector salud que es uno de los que enfrentan más retos debido a preocupaciones sobre la seguridad y privacidad de los datos. El manejo de datos sensibles genera dudas, especialmente en tecnologías emergentes. Sin embargo, estas preocupaciones representan oportunidades para desarrollar soluciones más seguras y eficientes. El sector agrícola también está comenzando a explorar el uso de IA en decisiones ambientales y monitoreo climatológico, mostrando un gran potencial de crecimiento.\r\n\r\nLas soluciones más buscadas incluyen chatbots avanzados, análisis predictivo y herramientas para ciberseguridad. Las nuevas versiones de chatbots, ahora más inteligentes, están siendo ampliamente adoptadas, especialmente en áreas operativas y de atención al cliente. Además, las empresas están aprovechando la IA para predicción y mantenimiento en plantas de operaciones, así como para fortalecer sus estrategias de ciberseguridad.\r\n\r\nAunque la implementación de IA no está exenta de retos. Para que la IA funcione correctamente, es crucial tener una estrategia de datos estructurada. Esto implica contar con fuentes de datos confiables y consistentes, integrar datos estructurados y no estructurados, y construir un Data Lake que permita explotar la información de manera efectiva. Además, proteger estos datos y minimizar vulnerabilidades sigue siendo un desafío clave para las organizaciones.\r\n\r\nLa inteligencia artificial se convirtió en un tema estratégico en las discusiones a nivel directivo. La resistencia a esta tecnología ha disminuido considerablemente. Las empresas saben que la IA no reemplazará a las personas, sino que empodera a quienes sepan utilizarla. Esto está redefiniendo la competitividad empresarial. Según sus estimaciones, para 2030, un alto porcentaje de compañías en la región contará con al menos un proyecto significativo basado en IA.\r\n...\r\n\r\nLee la nota completa aca : https://www.ambito.com/opiniones/que-sectores-lideran-la-implementacion-la-inteligencia-artificial-argentina-n6186668	Según una investigación de International Data Corporation (IDC) la inversión en tecnologías de IA en América Latina alcanzará los $3,400 millones en 2025, y en el país.	t	2	IA, Tecnología, PYMES, Empresas, oportunidades, datos	\N	2025-09-18 13:21:54.611646	2025-09-18 13:21:55.800841	2025-09-18 13:21:54.611052	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758201715/publications/zp4zrvl6ao62bp9g6dxv.png	0
8	\N	Tecnología	Conuar fabricará componentes para un prototipo de micro reactor nuclear que se construirá en EE.UU.	La empresa Combustibles Nucleares Argentina (Conuar) podría fabricar componentes para un micro reactor atómico diseñado por una firma europea. La compañía, que es controlada por el grupo Perez Companc y tiene a la Comisión Nacional de Energía Atómica (CNEA) como accionista minoritario, firmó en Viena un acuerdo con la firma Terra Innovatum que involucra al reactor micromodular SOLO, según pudo saber EconoJournal. El acuerdo también abre la puerta a establecer en la Argentina un hub de ensamblaje y cadena de valor para Latinoamérica relacionado con este reactor.\r\n\r\nEl convenio suscrito establece que Conuar diseñará y fabricará componentes críticos para el SOLO Micro-Modular Reactor (MMR) de Terra Innovatum, una compañía europea enfocada en el desarrollo de soluciones nucleares innovadoras.\r\n\r\nEl CEO de CONUAR, Rodolfo Kramer, celebró la firma del convenio. “Este acuerdo representa una oportunidad única para demostrar cómo la capacidad industrial argentina puede integrarse a proyectos internacionales de vanguardia. En Conuar nos sentimos orgullosos de aportar nuestra experiencia y know-how para hacer realidad un diseño que promete energía limpia y accesible para futuras generaciones”, dijo.\r\n\r\nLee la nota completa acá : https://econojournal.com.ar/2025/09/conuar-fabricara-componentes-para-un-prototipo-de-micro-reactor-nuclear-que-se-construira-en-ee-uu/	La empresa Conuar, controlada por el grupo Perez Companc, rubricó esta semana un acuerdo con la firma europea Terra Innovatum para fabricar componentes críticos del reactor micro modular SOLO. Terra Innovatum comenzó a tramitar el licenciamiento para la construcción de una primera unidad prototipo en los Estados Unidos.	t	2	Tecnología, energía nuclear, energía, Argentina	\N	2025-09-18 12:17:15.030874	2025-09-18 17:04:16.575261	2025-09-18 12:17:15.030195	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758197835/publications/x7178mz11xkzbz58uae3.jpg	3
10	\N	Deportes	𝗣𝗥𝗜𝗠𝗘𝗥𝗢 𝗔𝗥𝗚𝗘𝗡𝗧𝗜𝗡𝗔 𝗖𝗟𝗔𝗦𝗜𝗙𝗜𝗖𝗔𝗗𝗔 !! ... Segundo 𝗙𝗥𝗔𝗡𝗖𝗜𝗔.	Argentina dio un tremendo golpe en el Mundial de vóleibol: eliminó a Francia y se clasificó a los octavos de final.\r\nSe impuso por 3-2 para dejar afuera del torneo al bicampeón olímpico.\r\n\r\nLa selección argentina de vóleibol dio un gran golpe contra Francia, porque consiguió el pasaporte para los octavos de final del Mundial, en el cierre del Grupo C, y eliminó al bicampeón olímpico. El conjunto de Marcelo Méndez se impuso por 3-2 (28-26, 25-23, 21-25, 20-25 y 15-12), en el tie break con una tarea impresionante en el ataque de Luciano Vicentín (22 puntos) y de Luciano Palonsky (17). Ahora el conjunto nacional espera rival que será el segundo del Grupo F (que podría ser Italia o Ucrania).\r\n\r\nLa victoria de la Argentina resonó en todo el estadio en el Coliseo Smart Araneta de Quenzon City, Filipinas, pero uno de los momentos más particulares se dio cuando el entrenador de Francia, Andrea Giani, que interrumpió el festejo del conjunto de Marcelo Méndez, al parecer, para advertir algún comportamiento que le pareció desmedido. Los jugadores argentinos lo escucharon con respeto, aunque no dejó de ser una acción, al menos curiosa, porque sus jugadores, durante el partido, también entraron en el juego de las provocaciones.\r\n\r\nLee la nota completa acá : https://www.lanacion.com.ar/deportes/voley/argentina-vs-francia-por-un-lugar-en-los-octavos-de-final-del-mundial-de-voleibol-en-vivo-nid18092025/	VAMOS ARGENTINA CARAJO	t	2	#VAMOSARGENTINA #VamosLosPibes #mundial #WorldChampionship #voley #volei #voleibol	\N	2025-09-18 13:32:36.155961	2025-09-18 22:40:14.309235	2025-09-18 13:32:36.15531	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758202356/publications/v4vftyh7pawosa8er56m.png	14
11	\N	Deportes	Argentina y otra cita con la historia del vóleibol: frente a Italia en busca de los cuartos de final	Por qué es importante el partido del Mundial de Vóleibol\r\nArgentina e Italia buscarán seguir avanzando en el cuadro del Mundial, buscando alcanzar el podio en la máxima competencia Mundial de Selecciones. El torneo es durísimo, de hecho varios candidatos a pelear por las medallas quedaron fuera de competencia, como Brasil, que desde 2002 siempre había estado entre los cuatro mejores de este torneo.\r\n\r\nAsí llegan los equipos\r\nCómo dijimos, Argentina debió vencer en su último duelo de Fase de Grupos a Francia, el actual bicampeón olímpico. Tras ir ganando 2 a 0, los galos remontaron y el partido se definió en un tremendo quinto set. ARgentina con ese resltado ganó el grupo con tres victorias en tres presentaciones.\r\n\r\nItalia también llegó necesitada de un triunfo a su último duelo de zona ante Ucrania, pero para obtener el segundo lugar de la misma, detrás de Bélgica, que había sido su verdugo en el debut. La Selección italiana se adueñó del partido desde la primera pelota y lo ganó con parciales de 25-21, 25-22 y 25-18, con 11 puntos de Romano, otros 11 de Bottolo y 12 de Michieletto, máximo goleador italiano.\r\n\r\nLee la nota completa aca : https://www.espn.com.ar/otros-deportes/nota/_/id/15692421/argentina-vs-italia-por-los-octavos-de-final-del-mundial-de-voleibol-equipo-fecha-hora-y-tv-en-vivo	La Selección Argentina masculina consiguió una histórica e inolvidable victoria 3-2 sobre la bicampeona olímpica Francia y enfrentará el domingo 21 de septiembre a Italia por los octavos de final del Campeonato Mundial de Vóleibol Filipinas 2025.\r\n\r\nEl partido comienza a las 04:30 (ARG/URU/CHI) y 02:30 (COL/PER/ECU).	t	1	argentina, mundial, italia, mendez, voley	\N	2025-09-20 00:41:01.604045	2025-09-20 12:19:19.111657	2025-09-20 00:41:01.600091	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758328862/publications/wnlzolyxvlacdpg19oew.jpg	2
13	\N	Deportes	👏👏 - GRACIAS MUCHACHOS - 👏👏	No siempre gana el que levanta la copa. A veces el verdadero triunfo es dejar el corazón en cada jugada, emocionar a un país entero y recordarnos que el vóley argentino está entre los grandes del mundo. Gracias, muchachos, por hacernos latir fuerte, por pintarnos de celeste y blanco en cada punto, por mostrarnos que la disciplina, el compromiso y la pasión también son victorias. Para nosotros ya son campeones. Orgullo total. 🙌🇦🇷❤️	Argentina cayó, pero dejó el alma en la cancha. 🏐🇦🇷	t	1	argentina, corazon, garra, mundial2025	\N	2025-09-22 14:34:09.609732	2025-09-22 14:34:11.269414	2025-09-22 14:34:09.608069	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758551650/publications/j3ierianmmisgcak8w3q.png	0
14	\N	Deportes	El piloto récord del que habla todo el país! 🏁🔥🇦🇷	Matías Lorenzato, originario de Mina Clavero, Traslasierra, Córdoba, Argentina, es sin duda uno de los pilotos más destacados y en ascenso en el motociclismo argentino y regional. Con una historia marcada por esfuerzo, pasión y resultados impresionantes, Lorenzato se ha consolidado como una figura clave en el Campeonato Argentino de Motociclismo (CAM).\r\n\r\nActualmente, el piloto de Mina Clavero tiene en su haber 74 victorias, logrando 9 títulos en diferentes categorías y acercándose rápidamente a convertirse en el máximo ganador en la historia del CAM, a solo 11 triunfos de alcanzar ese récord. Su desempeño en 2025 ha sido excepcional, mostrando una conducción madura y una competitividad que lo mantienen en la cima de manera constante.\r\n\r\nDestaca en categorías altamente competitivas, siendo líder absoluto en la 450cc Internacional y también en la 125cc Graduados, las categorías más duras y exigentes del certamen. Recientemente, su fantástico rendimiento en carreras en Centeno y Villa Trinidad, donde también fue el piloto más ganador en esas pistas, confirma su potencial y su gran capacidad para adaptarse y dominar en diferentes circuitos.\r\n\r\nEn la temporada 2025, Lorenzato ha obtenido 9 podios, con 4 victorias en la categoría 450cc y la primera posición en 125cc, demostrando una vez más su consistencia y talento. En la última fecha, enfrentó mano a mano a los grandes, luchando con Marcos Barrios y Matías Frey, conquistando las victorias sin errores y asegurando la punta en las carreras más complicadas.\r\n\r\nSu historia y logros no solo reflejan su talento como piloto, sino también su dedicación y perseverancia, que inspiran a toda la comunidad de Traslasierra y Argentina. Matías Lorenzato continúa escribiendo su propia leyenda, con la mira puesta en más triunfos y récords, consolidándose como uno de los referentes del motociclismo nacional.\r\n\r\nEste es solo el comienzo de una historia que sigue creciendo y emocionando a todos los amantes del deporte sobre dos ruedas.	Matías Lorenzato, de Mina Clavero, Córdoba, destacado piloto argentino en el CAM, con 74 victorias y 9 títulos en categorías duras como 450cc y 125cc. Líder en 2025, busca récords y consolidarse como uno de los mejores, demostrando talento, madurez y perseverancia en cada carrera.	t	1	motoCAM, record, mina clavero, traslasierra, matiaslorenzato	\N	2025-09-22 15:12:41.830905	2025-09-22 15:12:43.394274	2025-09-22 15:12:41.826947	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758553962/publications/sddk7qmrolgtvxxmtsem.png	0
12	\N	Análisis	Payway Trends: Orquestación estratégica en el ecosistema de pagos argentino	Payway Trends se consolida como el epicentro donde converge la vanguardia del ecosistema de pagos argentino. Más allá de un evento corporativo, se erige como termómetro de las transformaciones que redefine la interacción entre dinero, tecnología y consumo. Con un lineup que integra desde economistas como Santiago Bulat hasta disruptores como Mario Pergolini, el encuentro profundiza en tensiones clave: seguridad versus experiencia seamless, inclusión financiera versus sophistication tecnológica, innovación global versus adaptación local.\r\n\r\nTras el discurso colaborativo —donde actores como Visa, Mastercard y retailers líderes comparten casos— subyace una apuesta estratégica de Payway por posicionarse no como un mero procesador, sino como el orquestador central de un ecosistema fragmentado. El evento refleja así los desafíos de una industria en transición: cómo escalar soluciones sin sacrificar usabilidad, cómo integrar legacy systems con APIs de última milla, y cómo construir confianza en un contexto de alta volatilidad económica.\r\n\r\nPero más allá de las tendencias, Payway Trends expone una verdad incómoda: la innovación real often choca con inercias estructurales del mercado. El evento, entonces, funciona tanto como vitrina de avances como espejo de las limitaciones que aún persisten en la democratización financiera argentina. Un diálogo necesario, aunque aún dominado por la retórica corporativa, en un país donde el futuro de los pagos aún se escribe entre promesas y restricciones.\r\n\r\nLee la nota completa aca: https://www.lanacion.com.ar/economia/negocios/como-pagaremos-en-el-futuro-tendencias-e-innovacion-en-un-encuentro-que-reunio-a-los-referentes-del-nid17092025/	Payway Trends reunió a actores clave del ecosistema financiero para debatir el futuro de los pagos. El evento, organizado por Payway, se presentó como un espacio de orquestación entre bancos, fintechs y comercios, destacando tendencias como tokenización, seguridad y experiencia de usuario.	t	1	tecnologia, futuro, pagos, fintech, networking	\N	2025-09-20 12:12:47.273322	2025-09-20 12:16:26.793553	2025-09-20 12:12:47.272491	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758370368/publications/rlngqxxszrcpujxqx5od.png	4
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.schedules (id, doctor_id, clinic_id, day_of_week, start_time, end_time, is_active) FROM stdin;
\.


--
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
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.tasks (id, title, description, due_date, status, doctor_id, assistant_id, created_by, clinic_id, created_at) FROM stdin;
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
24	2 c pastinar living		2025-09-11	pending	6	13	\N	\N	2025-09-18 18:51:06.351874
25	1 a terrminacion pared lavarropa		2025-09-08	pending	6	5	\N	\N	2025-09-18 18:52:02.633755
27	3 a lavadero	emprolijar	2025-09-10	pending	6	5	\N	\N	2025-09-18 18:55:05.87661
28	3 a piso	pastinar pìso	2025-09-10	pending	6	5	\N	\N	2025-09-18 18:56:02.660837
29	2 a lavarropa	emprolija	2025-09-11	pending	6	5	\N	\N	2025-09-18 18:56:58.948271
32	3 c lavarropa	pintar	2025-09-18	pending	6	5	\N	\N	2025-09-18 18:59:36.487388
33	2 b baños	limpiar baños	2025-09-12	pending	6	5	\N	\N	2025-09-18 19:00:29.439061
35	3 a bañadera	emprolijar	2025-09-04	pending	6	5	\N	\N	2025-09-18 19:01:57.642668
31	2 b lavarropa	lavarropa pintar	2025-09-18	pending	6	5	\N	\N	2025-09-18 18:58:57.332989
11	4 a pintura	MEÑANA VIENEN LOS DUEÑOS DEL 4 A\r\n\r\nHOY HAY QUE TERMINAR DE HACER ESTOS ARREGLOS\r\nPINTUTRA , HAY RETOQUES SERCA DE LA LLAVE DEL PASILLO.\r\nENDUIDO EN LOS PERFILES DE LOS PLACARES\r\nPINTAR ZOCALOS EN TODO EL DEPARTAMENTO DONDE CORRESPONDA	2025-09-17	pending	6	10	\N	\N	2025-09-17 15:17:55.657757
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
39	LLaamar a Cecilia por posible interesado de deptos al pozo	gestion comerciual	2025-09-19	completed	6	9	\N	\N	2025-09-19 15:31:53.776755
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
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.user_roles (id, name, description, is_active, created_at) FROM stdin;
1	Profesional	Profesional de la salud	t	2025-09-15 12:49:15.089596
2	Tienda	Tienda de productos	t	2025-09-15 12:49:15.149453
3	Visitante	Usuario visitante	t	2025-09-15 12:49:15.20735
4	Paciente	Paciente	t	2025-09-15 12:49:15.261005
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bioforge_user
--

COPY public.users (id, username, email, password_hash, is_admin, is_professional, created_at, updated_at, url_slug, professional_category, specialty, bio, years_experience, profile_photo, license_number, services, skills, role_name, role_id) FROM stdin;
4	El Vasquito	elvasquito16@gmail.com	scrypt:32768:8:1$fAuN0TQivk9YugLQ$1d584cf5ccfd8bde4fe86a34324b6e45b6bcc9ed38ecc0ce58d6c6fa5a829ded1e58da31317dae17a24603e356cafd9d53dd627c69e65183b8f6defdef9350e3	f	t	2025-09-15 22:53:36.025149	2025-09-15 23:01:06.356271	el-vasquito	\N	Corralón  y Materiales para la construcción	Una pequeña descripcion de la biografia/historia	30	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757977265/profiles/profile_4.png	1889	Materiales para la construcción\r\nHormigón Armado\r\nTransporte y logística	\N	user	\N
5	JoseLuis	astiazu@hotmail.com	scrypt:32768:8:1$lP4evFrgZ2rCSEH2$6c8d16c7d0058ef81d6b0318c30ff70138b65ef54b7ebc1fb63a94fa2ef3dd97eb32c94b54b49d653bf438c4557baffaaa39fd12afff67919eddaca5c06c387b	f	f	2025-09-15 23:09:03.92779	2025-09-15 23:09:03.927796	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
3	Quique Spada	spadaenrique@gmail.com	scrypt:32768:8:1$O3aEVb0gSCNXegRo$b0cbd75d52522d710962f3b2aabace4afa39ac13da8c7becc115a643173e60d561d6e08d39eb1e74444e9452c66f08936f864bac1929de242d38d26f019e1bd8	f	t	2025-09-15 15:57:34.892438	2025-09-15 21:57:39.416671	quique-spada	\N	Empresario - Dj	Socio fundador en el año 1979 de la Productora AUDIVISIÓN - hasta 1981 -\r\nPerfil · Creador digital\r\nPropietario y Creativo de SonrisasProducciones en sonrisas producciones\r\nGerente Propietario en sonrisas producciones	40	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757952072/profiles/profile_3.jpg	007	Entretenimientos - Diversión	\N	user	1
10	patricia.schifini	patricia.schifini@gmail.com	scrypt:32768:8:1$nfnexY6RRdbJsU1I$290abae3a52614fb119a5d7c5976fc918d06af2f8acce68077276eee7cbc6ae18eb3807437d1191cf800bd3c9d693974420525850cbfc39546720c1fae0a4fe8	f	f	2025-09-18 13:17:39.993785	2025-09-18 13:23:03.182494	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3
7	Mabel	macalu1966@gmail.com	scrypt:32768:8:1$AhXnS31WIaSkLwzr$94f1dce240cf32cd781fd471f834265592bbeb1540cd0503dbe8eae13db45a7bf556f5ae3e85df387b584bd57b132654330ad9d2b2c0df2a28b5c9b76873e0ae	f	f	2025-09-16 20:15:42.909522	2025-09-16 20:15:42.909529	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3
12	macalu66	macalu66@hotmail.com	scrypt:32768:8:1$9xquiPX71EBGL5ZZ$7896ee4c27fe8fc5bab07b85f43a061e1e04314b77b5917b4ed33e4a8762178cedd51bae8263c1db86ae1c7dc6ee111052106557f4591023d6afe880993479ff	f	f	2025-09-18 13:38:59.795792	2025-09-18 13:38:59.795799	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
8	emiliano	emipaz1975@hotmail.com	scrypt:32768:8:1$Gy8BpuDHUKD7R9Ss$a4d4add1d7788e4d62121039ce6073badbc7a8d155a79df43e6609a12fb73f72f8d0a50f7317061cd603d8ece750dd26a3753c2c524809ecad4ecb45b0674e62	f	f	2025-09-17 19:37:59.412573	2025-09-17 19:37:59.41258	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
2	astiazu.joseluis	astiazu@gmail.com	scrypt:32768:8:1$vIyDsdbeUB55kvOl$ec1ad02d35b0ed378acd81104d7b697ebc6606a06ddd57c1a30ff0104de86f58a1062008eb3e04ac2dcb53f6afd1e24a0b3fd7a7ebf04abfa75407e81f69f4c1	t	t	2025-09-15 13:59:29.501659	2025-09-18 10:20:48.380188	astiazu-joseluis	\N	Analista de Sistemas	Soy analista de sistemas, orientado hacia los resultados y con excelentes dotes comunicativas. También cuento con conocimiento en análisis de datos. A partir del año 2020 volví a la programación gracias a la Cooperativa del Centro de Graduados de la Facultad de Ingeniería - FIUBA -, inicialmente con Python y luego Data Analytics con Google. Desaprender y aprender ha sido un desafío constante en materia de tecnología. Agradecido de poder hacerlo.	30	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1757945404/profiles/profile_2.jpg	3571	Analisis de Datos, Big Data, Automatización, Consultorías, Formación.	\N	user	1
14	elvasqito	elvasqito@hotmail.com	scrypt:32768:8:1$knbX3b3pbRjGgdir$afb0269b4b460b6f0dfd666535cecd94f062a9d530f6ff8e81e8e53313bb4e957ab597e1d14d51af6aeaee549992bb24dc4152be3e343d3f1625839c8e4c2660	f	f	2025-09-18 20:00:20.20733	2025-09-18 20:00:20.207342	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
15	lucaastiazu0	lucaastiazu0@gmail.com	scrypt:32768:8:1$IW4EEw9OWwlzWGxx$60db46247ef0cf3a747e929523d46cd9e2f6456a585147c604c165aa81ad65b5bc68895af634d495dc92a9b5fe836b23be2a2269637ea420c38fe86d8da68802	f	f	2025-09-18 20:06:51.606432	2025-09-18 20:06:51.606438	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
6	CD3 -Arq. - Salvador	salvadorcirio@gmail.com	scrypt:32768:8:1$Be9cpv3TcL7UKT4U$733dd90611103ce16ffd218f7bd2a77a13dea6a264c6b38bb17dfd184db6637063f7e12cf20f90284e45e99ad56292493d9b0290683a380065fd454bd6ca809c	f	t	2025-09-16 18:30:47.767281	2025-09-19 15:31:56.509464	salvador	\N	Proyect Líder Licenciado en Sistemas	None	10000	https://res.cloudinary.com/dxpxsv7ui/image/upload/v1758198899/profiles/profile_6.jpg	None	None	\N	user	\N
1	admin	admin@local	scrypt:32768:8:1$R9CNmjywCnwEtxq4$08a882ad07c5c738f38ad70cf98ec0aaec887a9f19f7ff1a098c0307c8b15fe3a5a0d3e0b0765a7667271faa9ddab891334a3f0b9f22d9b01bea0d1773cb6b49	t	f	2025-09-15 12:49:15.506259	2025-09-26 23:55:51.712576	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	1
13	Stefy	stefyocen99@gmail.com	scrypt:32768:8:1$AtUBEHv74RI4Xedq$5d870fa4dc19514da66aac717d13a882efc9747ede3cee3fd8da57d3a89c1e5b4923db49c34b2b9db4f14190754f874ce2d4bd261802924651934b1604e573ae	f	f	2025-09-18 13:50:13.50132	2025-09-26 23:57:01.345353	stefy	\N	None	None	\N	\N	None	None	\N	user	\N
9	Marcela	holisticotre@gmail.com	scrypt:32768:8:1$cv6EWv5DYHyNEqkc$bc29fb459f2cd0f795d44942b8dde3edbe3edb2f98267980587a573b644bd1e6cc7400c84965771f2907bb8a47cd8cdf751fd56bcc7c80f61a92618dcc60f8a6	f	f	2025-09-18 13:06:58.894439	2025-09-27 14:59:46.447027	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	3
16	Usuario Prueba	usuarioprueba@bioforge.test	scrypt:32768:8:1$yOO3iZKZ8PV539lU$e4b58889ac9e7fb2ac17a044a095d063aeff61969550e4c673f4d75df5aca234bfcbebda8ecf2cdd78b603892019d8af0e7c280418b4339aa00d4e5bbcd29f74	f	f	2025-09-27 18:11:02.644654	2025-09-27 18:11:02.644654	\N	\N	\N	\N	\N	\N	\N	\N	\N	user	\N
\.


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.appointments_id_seq', 1, false);


--
-- Name: assistants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.assistants_id_seq', 25, true);


--
-- Name: availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.availability_id_seq', 1, false);


--
-- Name: clinic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.clinic_id_seq', 5, true);


--
-- Name: company_invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.company_invites_id_seq', 1, false);


--
-- Name: invitation_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.invitation_logs_id_seq', 1, false);


--
-- Name: medical_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.medical_records_id_seq', 1, false);


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.notes_id_seq', 6, true);


--
-- Name: publications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.publications_id_seq', 14, true);


--
-- Name: schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.schedules_id_seq', 1, false);


--
-- Name: subscribers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.subscribers_id_seq', 5, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.tasks_id_seq', 57, true);


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bioforge_user
--

SELECT pg_catalog.setval('public.users_id_seq', 16, true);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: assistants assistants_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_pkey PRIMARY KEY (id);


--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (id);


--
-- Name: clinic clinic_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic
    ADD CONSTRAINT clinic_pkey PRIMARY KEY (id);


--
-- Name: company_invites company_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_pkey PRIMARY KEY (id);


--
-- Name: invitation_logs invitation_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs
    ADD CONSTRAINT invitation_logs_pkey PRIMARY KEY (id);


--
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: subscribers subscribers_email_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_email_key UNIQUE (email);


--
-- Name: subscribers subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: assistants uq_assistant_clinic_name; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT uq_assistant_clinic_name UNIQUE (clinic_id, name);


--
-- Name: user_roles user_roles_name_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_name_key UNIQUE (name);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_url_slug_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_url_slug_key UNIQUE (url_slug);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: ix_assistants_clinic_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_clinic_id ON public.assistants USING btree (clinic_id);


--
-- Name: ix_assistants_doctor_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_doctor_id ON public.assistants USING btree (doctor_id);


--
-- Name: ix_assistants_telegram_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_telegram_id ON public.assistants USING btree (telegram_id);


--
-- Name: ix_assistants_user_id; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_assistants_user_id ON public.assistants USING btree (user_id);


--
-- Name: ix_company_invites_invite_code; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE UNIQUE INDEX ix_company_invites_invite_code ON public.company_invites USING btree (invite_code);


--
-- Name: ix_company_invites_is_used; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_company_invites_is_used ON public.company_invites USING btree (is_used);


--
-- Name: ix_invitation_logs_invite_code; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_invitation_logs_invite_code ON public.invitation_logs USING btree (invite_code);


--
-- Name: ix_publications_slug; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE UNIQUE INDEX ix_publications_slug ON public.publications USING btree (slug);


--
-- Name: ix_tasks_created_by; Type: INDEX; Schema: public; Owner: bioforge_user
--

CREATE INDEX ix_tasks_created_by ON public.tasks USING btree (created_by);


--
-- Name: appointments appointments_availability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_availability_id_fkey FOREIGN KEY (availability_id) REFERENCES public.availability(id);


--
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- Name: assistants assistants_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- Name: assistants assistants_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: assistants assistants_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: assistants assistants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.assistants
    ADD CONSTRAINT assistants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: availability availability_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- Name: clinic clinic_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.clinic
    ADD CONSTRAINT clinic_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: company_invites company_invites_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- Name: company_invites company_invites_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.company_invites
    ADD CONSTRAINT company_invites_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: invitation_logs invitation_logs_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.invitation_logs
    ADD CONSTRAINT invitation_logs_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: medical_records medical_records_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: medical_records medical_records_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: medical_records medical_records_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- Name: notes notes_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: notes notes_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.users(id);


--
-- Name: notes notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: publications publications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: schedules schedules_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- Name: schedules schedules_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: tasks tasks_assistant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assistant_id_fkey FOREIGN KEY (assistant_id) REFERENCES public.assistants(id);


--
-- Name: tasks tasks_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinic(id);


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: tasks tasks_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.users(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bioforge_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO bioforge_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO bioforge_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO bioforge_user;


--
-- PostgreSQL database dump complete
--

\unrestrict VeHyr2YWAVb76zkAbbNWIMs7WJBhyKsU0lQOlBCg9rXx7unEQ76YtSIo4z8Xdze

