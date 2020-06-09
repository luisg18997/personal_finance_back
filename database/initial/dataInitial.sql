--data initial of roles

INSERT INTO per_finance_data.roles(name) values('administrador'), ('cliente');

INSERT INTO per_finance_data.categories(name) values('servicios'), ('personal'), ('otros');

INSERT INTO per_finance_data.currencies(name, code, symbol) values ('Bolivares', 'VEF', 'Bs'),  ('Dolar Estadounidense', 'USD', '$'), ('Pesos Colombianos', 'COP', '$');

INSERT INTO per_finance_data.users(email,password,role_id) values('admin@email.com', '$2a$10$6fY345o2brAsNTUTZG3J.uLVrWOdUdKdSyD1XDpWgqz8b/wm85j7y', 1); --pass Hola.123