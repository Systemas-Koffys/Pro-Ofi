USE dboficina;
DELETE FROM usuarios;
INSERT INTO usuarios (username, password, role, nombre, cargo, email) VALUES 
('admin', 'admin', 'ADMIN', 'Ing. Simón Farfán', 'Ingeniero', 'cfarfan@alcaldiatarija.gob.bo'),
('root', 'password', 'ROOT', 'Kevin Flores Vallejos', 'Técnico', 'sistemas.koffys@gmail.com');
