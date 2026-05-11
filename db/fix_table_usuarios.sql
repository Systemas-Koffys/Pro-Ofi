USE dboficina;

-- 1. Re-crear la tabla con la estructura completa y correcta
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    email VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'Activo'
);

-- 2. Insertar los dos usuarios oficiales
INSERT INTO usuarios (username, password, role, nombre, cargo, email, estado) VALUES 
('admin', 'admin', 'ADMIN', 'Ing. Cimar Farfan', 'Ingeniero', 'cfarfan@alcaldiatarija.gob.bo', 'Activo'),
('root', 'password', 'ROOT', 'Tec. Kevin Flores', 'Técnico', 'sistemas.koffys@gmail.com', 'Activo');
