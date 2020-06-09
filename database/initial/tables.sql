CREATE SCHEMA per_finance_data;

--create sequences

CREATE SEQUENCE per_finance_data.user_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE per_finance_data.client_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE per_finance_data.role_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE per_finance_data.currency_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE per_finance_data.category_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE per_finance_data.finance_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


-- create tables
CREATE TABLE per_finance_data.roles(
    id INTEGER DEFAULT nextval('per_finance_data.role_id_seq'::regclass) NOT NULL,
    name VARCHAR(50) NOT NULL

);

CREATE TABLE per_finance_data.users(
    id INTEGER DEFAULT nextval('per_finance_data.user_id_seq'::regclass) NOT NULL,
    email VARCHAR(200) NOT NULL,
    password TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    isDeleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE per_finance_data.clients(
    id INTEGER DEFAULT nextval('per_finance_data.client_id_seq'::regclass) NOT NULL,
    name VARCHAR(200),
    last_name VARCHAR(200),
    birth_date DATE,
    avatar TEXT,
    is_new BOOLEAN DEFAULT TRUE,
    user_id INTEGER NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    isDeleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE per_finance_data.currencies(
    id INTEGER DEFAULT nextval('per_finance_data.currency_id_seq'::regclass) NOT NULL,
    name VARCHAR(50) NOT NULL,
    code VARCHAR(5) NOT NULL,
    symbol  VARCHAR(5) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    isDeleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE per_finance_data.categories(
    id INTEGER DEFAULT nextval('per_finance_data.category_id_seq'::regclass) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    is_personal BOOLEAN,
    user_id INTEGER,
    isActive BOOLEAN DEFAULT TRUE,
    isDeleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE per_finance_data.finance(
    id INTEGER DEFAULT nextval('per_finance_data.finance_id_seq'::regclass) NOT NULL,
    title VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    mount double precision NOT NULL,
    finance_date DATE NOT NULL,
    finance_hour TIME NOT NULL,
    category_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,
    is_income BOOLEAN DEFAULT true NOT NULL,
    user_id INTEGER NOT NULL
);


-- add constraints--
--add PK


ALTER TABLE ONLY per_finance_data.users
	ADD CONSTRAINT user_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY per_finance_data.roles
	ADD CONSTRAINT role_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY per_finance_data.clients
	ADD CONSTRAINT client_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY per_finance_data.currencies
	ADD CONSTRAINT currency_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY per_finance_data.categories
	ADD CONSTRAINT category_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY per_finance_data.finance
	ADD CONSTRAINT finance_id_pk PRIMARY KEY (id);


-- ADD fk in the tables

ALTER TABLE ONLY per_finance_data.users
  ADD CONSTRAINT user_role_id_fk FOREIGN KEY (role_id)
  REFERENCES per_finance_data.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY per_finance_data.clients
  ADD CONSTRAINT client_user_id_fk FOREIGN KEY (user_id)
  REFERENCES per_finance_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY per_finance_data.categories
  ADD CONSTRAINT category_user_id_fk FOREIGN KEY (user_id)
  REFERENCES per_finance_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY per_finance_data.finance
  ADD CONSTRAINT finance_user_id_fk FOREIGN KEY (user_id)
  REFERENCES per_finance_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY per_finance_data.finance
  ADD CONSTRAINT finance_currency_id_fk FOREIGN KEY (currency_id)
  REFERENCES per_finance_data.currencies(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY per_finance_data.finance
  ADD CONSTRAINT finance_category_id_fk FOREIGN KEY (category_id)
  REFERENCES per_finance_data.categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

