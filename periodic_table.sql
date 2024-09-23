--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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

DROP DATABASE IF EXISTS periodic_table;
--
-- Name: periodic_table; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE periodic_table WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE periodic_table OWNER TO postgres;

\connect periodic_table

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
-- Name: elements; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.elements (
    atomic_number integer NOT NULL,
    symbol character varying(2),
    name character varying(40)
);


ALTER TABLE public.elements OWNER TO freecodecamp;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.properties (
                                   atomic_number integer NOT NULL,
                                   type character varying(30),
                                   weight numeric(9,6) NOT NULL,
                                   melting_point numeric,
                                   boiling_point numeric
);


ALTER TABLE public.properties OWNER TO freecodecamp;

--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.elements VALUES (1, 'H', 'Hydrogen');
INSERT INTO public.elements VALUES (2, 'he', 'Helium');
INSERT INTO public.elements VALUES (3, 'li', 'Lithium');
INSERT INTO public.elements VALUES (4, 'Be', 'Beryllium');
INSERT INTO public.elements VALUES (5, 'B', 'Boron');
INSERT INTO public.elements VALUES (6, 'C', 'Carbon');
INSERT INTO public.elements VALUES (7, 'N', 'Nitrogen');
INSERT INTO public.elements VALUES (8, 'O', 'Oxygen');
INSERT INTO public.elements VALUES (1000, 'mT', 'moTanium');


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.properties VALUES (1, 'nonmetal', 1.008000, -259.1, -252.9);
INSERT INTO public.properties VALUES (2, 'nonmetal', 4.002600, -272.2, -269);
INSERT INTO public.properties VALUES (3, 'metal', 6.940000, 180.54, 1342);
INSERT INTO public.properties VALUES (4, 'metal', 9.012200, 1287, 2470);
INSERT INTO public.properties VALUES (5, 'metalloid', 10.810000, 2075, 4000);
INSERT INTO public.properties VALUES (6, 'nonmetal', 12.011000, 3550, 4027);
INSERT INTO public.properties VALUES (7, 'nonmetal', 14.007000, -210.1, -195.8);
INSERT INTO public.properties VALUES (8, 'nonmetal', 15.999000, -218, -183);
INSERT INTO public.properties VALUES (1000, 'metalloid', 1.000000, 10, 100);


--
-- Name: elements elements_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_atomic_number_key UNIQUE (atomic_number);


--
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (atomic_number);


--
-- Name: properties properties_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_atomic_number_key UNIQUE (atomic_number);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (atomic_number);


--
-- PostgreSQL database dump complete
--

ALTER TABLE public.properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE public.properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE public.properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE public.properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE public.properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE public.elements ADD CONSTRAINT unique_symbol UNIQUE(symbol);
ALTER TABLE public.elements ADD CONSTRAINT unique_name UNIQUE(name);
ALTER TABLE public.elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE public.elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE public.properties ADD CONSTRAINT fk_atomic_number FOREIGN KEY (atomic_number) REFERENCES public.elements(atomic_number);

CREATE TABLE public.types (
    type_id SERIAL PRIMARY KEY,
    type VARCHAR(30) NOT NULL
);

INSERT INTO public.types (type) VALUES ('metal'), ('metalloid'), ('nonmetal');

ALTER TABLE public.properties ADD COLUMN type_id INT NOT NULL DEFAULT 0;

UPDATE public.properties
SET type_id = (
    SELECT type_id FROM public.types WHERE types.type = properties.type
);
ALTER TABLE public.properties ADD CONSTRAINT fk_type_id FOREIGN KEY (type_id) REFERENCES types(type_id);
ALTER TABLE public.properties DROP COLUMN type;

UPDATE public.elements SET symbol = INITCAP(symbol);
ALTER TABLE public.properties ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE public.properties SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::TEXT)::DECIMAL;

INSERT INTO public.elements (atomic_number, name, symbol) VALUES (9, 'Fluorine', 'F'), (10, 'Neon', 'Ne');
INSERT INTO public.properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (9, 18.998, -220, -188.1, (SELECT type_id FROM public.types WHERE type = 'nonmetal')),
       (10, 20.18, -248.6, -246.1, (SELECT type_id FROM public.types WHERE type = 'nonmetal'));

DELETE FROM public.properties WHERE atomic_number = 1000;
DELETE FROM public.elements WHERE atomic_number = 1000;

