--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

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
-- Name: Test Data; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Test Data" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE "Test Data" OWNER TO postgres;

\connect -reuse-previous=on "dbname='Test Data'"

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
-- Name: APP; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."APP" (
    appid integer NOT NULL,
    name character varying NOT NULL,
    version character varying NOT NULL
);


ALTER TABLE public."APP" OWNER TO postgres;

--
-- Name: APP_VULNERABILITIES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."APP_VULNERABILITIES" (
    appid integer NOT NULL,
    vulnid integer NOT NULL
);


ALTER TABLE public."APP_VULNERABILITIES" OWNER TO postgres;

--
-- Name: APP_appid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."APP_appid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."APP_appid_seq" OWNER TO postgres;

--
-- Name: APP_appid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."APP_appid_seq" OWNED BY public."APP".appid;


--
-- Name: BUSINESS_UNIT; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BUSINESS_UNIT" (
    unitid integer NOT NULL,
    name character varying NOT NULL,
    administrator integer NOT NULL,
    belongs_to integer
);


ALTER TABLE public."BUSINESS_UNIT" OWNER TO postgres;

--
-- Name: BUSINESS_UNIT_unitid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BUSINESS_UNIT_unitid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BUSINESS_UNIT_unitid_seq" OWNER TO postgres;

--
-- Name: BUSINESS_UNIT_unitid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BUSINESS_UNIT_unitid_seq" OWNED BY public."BUSINESS_UNIT".unitid;


--
-- Name: COMPUTER; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."COMPUTER" (
    name character varying NOT NULL,
    operatingsystem character varying NOT NULL,
    computerid integer NOT NULL,
    os_version character varying NOT NULL,
    unitid integer NOT NULL
);


ALTER TABLE public."COMPUTER" OWNER TO postgres;

--
-- Name: COMPUTER_VULNERABILITIES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."COMPUTER_VULNERABILITIES" (
    vulnid integer NOT NULL,
    computerid integer NOT NULL
);


ALTER TABLE public."COMPUTER_VULNERABILITIES" OWNER TO postgres;

--
-- Name: COMPUTER_computerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."COMPUTER_computerid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."COMPUTER_computerid_seq" OWNER TO postgres;

--
-- Name: COMPUTER_computerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."COMPUTER_computerid_seq" OWNED BY public."COMPUTER".computerid;


--
-- Name: RUNS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RUNS" (
    computerid integer NOT NULL,
    appid integer NOT NULL
);


ALTER TABLE public."RUNS" OWNER TO postgres;

--
-- Name: USER; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."USER" (
    username character varying NOT NULL,
    saltyhash character(1) NOT NULL,
    role character varying NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public."USER" OWNER TO postgres;

--
-- Name: USER_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."USER_userid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."USER_userid_seq" OWNER TO postgres;

--
-- Name: USER_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."USER_userid_seq" OWNED BY public."USER".userid;


--
-- Name: VULNERABILITY; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VULNERABILITY" (
    severity double precision NOT NULL,
    vulnid integer NOT NULL
);


ALTER TABLE public."VULNERABILITY" OWNER TO postgres;

--
-- Name: VULNERABILITY_vulnid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."VULNERABILITY_vulnid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."VULNERABILITY_vulnid_seq" OWNER TO postgres;

--
-- Name: VULNERABILITY_vulnid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."VULNERABILITY_vulnid_seq" OWNED BY public."VULNERABILITY".vulnid;


--
-- Name: APP appid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."APP" ALTER COLUMN appid SET DEFAULT nextval('public."APP_appid_seq"'::regclass);


--
-- Name: BUSINESS_UNIT unitid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BUSINESS_UNIT" ALTER COLUMN unitid SET DEFAULT nextval('public."BUSINESS_UNIT_unitid_seq"'::regclass);


--
-- Name: COMPUTER computerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER" ALTER COLUMN computerid SET DEFAULT nextval('public."COMPUTER_computerid_seq"'::regclass);


--
-- Name: USER userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER" ALTER COLUMN userid SET DEFAULT nextval('public."USER_userid_seq"'::regclass);


--
-- Name: VULNERABILITY vulnid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VULNERABILITY" ALTER COLUMN vulnid SET DEFAULT nextval('public."VULNERABILITY_vulnid_seq"'::regclass);


--
-- Name: APP_VULNERABILITIES APP_VULNERABILITIES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."APP_VULNERABILITIES"
    ADD CONSTRAINT "APP_VULNERABILITIES_pkey" PRIMARY KEY (appid, vulnid);


--
-- Name: APP APP_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."APP"
    ADD CONSTRAINT "APP_pkey" PRIMARY KEY (appid);


--
-- Name: BUSINESS_UNIT BUSINESS_UNIT_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BUSINESS_UNIT"
    ADD CONSTRAINT "BUSINESS_UNIT_pkey" PRIMARY KEY (unitid);


--
-- Name: COMPUTER_VULNERABILITIES COMPUTER_VULNERABILITIES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER_VULNERABILITIES"
    ADD CONSTRAINT "COMPUTER_VULNERABILITIES_pkey" PRIMARY KEY (vulnid, computerid);


--
-- Name: COMPUTER COMPUTER_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER"
    ADD CONSTRAINT "COMPUTER_name_key" UNIQUE (name);


--
-- Name: COMPUTER COMPUTER_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER"
    ADD CONSTRAINT "COMPUTER_pkey" PRIMARY KEY (computerid);


--
-- Name: RUNS RUNS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RUNS"
    ADD CONSTRAINT "RUNS_pkey" PRIMARY KEY (computerid, appid);


--
-- Name: USER USER_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY (userid);


--
-- Name: USER USER_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_username_key" UNIQUE (username);


--
-- Name: VULNERABILITY VULNERABILITY_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VULNERABILITY"
    ADD CONSTRAINT "VULNERABILITY_pkey" PRIMARY KEY (vulnid);


--
-- Name: BUSINESS_UNIT administrator_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BUSINESS_UNIT"
    ADD CONSTRAINT administrator_fk FOREIGN KEY (administrator) REFERENCES public."USER"(userid) ON DELETE CASCADE;


--
-- Name: APP_VULNERABILITIES appid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."APP_VULNERABILITIES"
    ADD CONSTRAINT appid_fk FOREIGN KEY (appid) REFERENCES public."APP"(appid) ON DELETE CASCADE;


--
-- Name: RUNS appid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RUNS"
    ADD CONSTRAINT appid_fk FOREIGN KEY (appid) REFERENCES public."APP"(appid) ON DELETE CASCADE;


--
-- Name: BUSINESS_UNIT belongs_to_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BUSINESS_UNIT"
    ADD CONSTRAINT belongs_to_fk FOREIGN KEY (belongs_to) REFERENCES public."BUSINESS_UNIT"(unitid) ON DELETE CASCADE;


--
-- Name: RUNS computerid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RUNS"
    ADD CONSTRAINT computerid_fk FOREIGN KEY (computerid) REFERENCES public."COMPUTER"(computerid) ON DELETE CASCADE;


--
-- Name: COMPUTER_VULNERABILITIES computerid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER_VULNERABILITIES"
    ADD CONSTRAINT computerid_fk FOREIGN KEY (computerid) REFERENCES public."COMPUTER"(computerid) ON DELETE CASCADE;


--
-- Name: COMPUTER unitid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER"
    ADD CONSTRAINT unitid_fk FOREIGN KEY (unitid) REFERENCES public."BUSINESS_UNIT"(unitid) ON DELETE CASCADE;


--
-- Name: COMPUTER_VULNERABILITIES vulnid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COMPUTER_VULNERABILITIES"
    ADD CONSTRAINT vulnid_fk FOREIGN KEY (vulnid) REFERENCES public."VULNERABILITY"(vulnid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

