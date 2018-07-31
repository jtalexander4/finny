--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.8
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgraphile_watch; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA postgraphile_watch;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: notify_watchers_ddl(); Type: FUNCTION; Schema: postgraphile_watch; Owner: -
--

CREATE FUNCTION postgraphile_watch.notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;


--
-- Name: notify_watchers_drop(); Type: FUNCTION; Schema: postgraphile_watch; Owner: -
--

CREATE FUNCTION postgraphile_watch.notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account (
    id integer NOT NULL,
    name character varying NOT NULL,
    parent_account_id integer,
    balance numeric(10,2) NOT NULL,
    account_type_id integer NOT NULL
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: account_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_type (
    id integer NOT NULL,
    name character varying NOT NULL,
    credit_positive boolean NOT NULL
);


--
-- Name: account_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_type_id_seq OWNED BY public.account_type.id;


--
-- Name: fiscal_period; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fiscal_period (
    id integer NOT NULL,
    name character varying NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL
);


--
-- Name: fiscal_period_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fiscal_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fiscal_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fiscal_period_id_seq OWNED BY public.fiscal_period.id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction (
    id integer NOT NULL,
    name character varying,
    reference character varying,
    date_posted date DEFAULT now() NOT NULL
);


--
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- Name: transaction_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_line (
    id integer NOT NULL,
    transaction_id integer NOT NULL,
    account_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    fiscal_period_id integer NOT NULL,
    date_posted date DEFAULT now() NOT NULL
);


--
-- Name: transaction_line_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transaction_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transaction_line_id_seq OWNED BY public.transaction_line.id;


--
-- Name: vw_transaction_line; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_transaction_line AS
 SELECT txn.name AS transaction_name,
    acct.name AS account,
    line.amount,
    per.name AS fiscal_period,
    line.date_posted
   FROM (((public.transaction_line line
     LEFT JOIN public.transaction txn ON ((line.transaction_id = txn.id)))
     LEFT JOIN public.account acct ON ((line.account_id = acct.id)))
     LEFT JOIN public.fiscal_period per ON ((line.fiscal_period_id = per.id)));


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: account_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_type ALTER COLUMN id SET DEFAULT nextval('public.account_type_id_seq'::regclass);


--
-- Name: fiscal_period id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fiscal_period ALTER COLUMN id SET DEFAULT nextval('public.fiscal_period_id_seq'::regclass);


--
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- Name: transaction_line id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_line ALTER COLUMN id SET DEFAULT nextval('public.transaction_line_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account (id, name, parent_account_id, balance, account_type_id) FROM stdin;
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.account_id_seq', 1, false);


--
-- Data for Name: account_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.account_type (id, name, credit_positive) FROM stdin;
1	Assets	f
2	Liabilities	t
3	Income	t
4	Expenses	f
5	Equity	t
\.


--
-- Name: account_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.account_type_id_seq', 5, true);


--
-- Data for Name: fiscal_period; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fiscal_period (id, name, from_date, to_date) FROM stdin;
\.


--
-- Name: fiscal_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fiscal_period_id_seq', 1, false);


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction (id, name, reference, date_posted) FROM stdin;
\.


--
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaction_id_seq', 1, false);


--
-- Data for Name: transaction_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction_line (id, transaction_id, account_id, amount, fiscal_period_id, date_posted) FROM stdin;
\.


--
-- Name: transaction_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaction_line_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: fiscal_period fiscal_period_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fiscal_period
    ADD CONSTRAINT fiscal_period_pkey PRIMARY KEY (id);


--
-- Name: account_type id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- Name: transaction_line transaction_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_line
    ADD CONSTRAINT transaction_line_pkey PRIMARY KEY (id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: fki_account_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_account_fk ON public.transaction_line USING btree (account_id);


--
-- Name: fki_account_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_account_type ON public.account USING btree (account_type_id);


--
-- Name: fki_account_type_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_account_type_fk ON public.account USING btree (parent_account_id);


--
-- Name: fki_fiscal_period_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fiscal_period_fk ON public.transaction_line USING btree (fiscal_period_id);


--
-- Name: fki_transaction_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_transaction_fk ON public.transaction_line USING btree (transaction_id);


--
-- Name: transaction_line account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_line
    ADD CONSTRAINT account_fk FOREIGN KEY (account_id) REFERENCES public.account(id);


--
-- Name: account account_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_type_fk FOREIGN KEY (account_type_id) REFERENCES public.account_type(id);


--
-- Name: transaction_line fiscal_period_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_line
    ADD CONSTRAINT fiscal_period_fk FOREIGN KEY (fiscal_period_id) REFERENCES public.fiscal_period(id);


--
-- Name: transaction_line transaction_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_line
    ADD CONSTRAINT transaction_fk FOREIGN KEY (transaction_id) REFERENCES public.transaction(id);


--
-- Name: postgraphile_watch_ddl; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER postgraphile_watch_ddl ON ddl_command_end
         WHEN TAG IN ('ALTER DOMAIN', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE DOMAIN', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP DOMAIN', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP SCHEMA', 'DROP TABLE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE PROCEDURE postgraphile_watch.notify_watchers_ddl();


--
-- Name: postgraphile_watch_drop; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER postgraphile_watch_drop ON sql_drop
   EXECUTE PROCEDURE postgraphile_watch.notify_watchers_drop();


--
-- PostgreSQL database dump complete
--

