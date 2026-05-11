import mysql from 'mysql2/promise';

async function fix() {
  const connection = await mysql.createConnection({
    host: 'db',
    user: 'root',
    password: 'password',
    database: 'dboficina',
    port: 3306
  });

  try {
    // 1. Crear o recrear la tabla con la estructura necesaria para el frontend
    await connection.query(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(100) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        role VARCHAR(20) NOT NULL,
        nombre VARCHAR(100) NOT NULL,
        cargo VARCHAR(100),
        email VARCHAR(100),
        estado VARCHAR(20) DEFAULT 'Activo'
      )
    `);

    // 2. Limpiar para evitar duplicados en esta prueba
    await connection.query('DELETE FROM usuarios');
    
    // 3. Insertar los dos usuarios oficiales
    const usuarios = [
      ['admin', 'admin', 'ADMIN', 'Ing. Cimar Farfan', 'Ingeniero', 'cfarfan@alcaldiatarija.gob.bo', 'Activo'],
      ['root', 'password', 'ROOT', 'Tec. Kevin Flores', 'Técnico', 'sistemas.koffys@gmail.com', 'Activo']
    ];

    for (const u of usuarios) {
      await connection.query(
        'INSERT INTO usuarios (username, password, role, nombre, cargo, email, estado) VALUES (?, ?, ?, ?, ?, ?, ?)',
        u
      );
    }

    console.log('✅ Base de datos sincronizada: Tabla usuarios creada y poblada.');
  } catch (err) {
    console.error('❌ Error al sincronizar:', err);
  } finally {
    await connection.end();
  }
}

fix();
