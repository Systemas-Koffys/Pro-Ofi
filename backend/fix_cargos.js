import mysql from 'mysql2/promise';

async function fix() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'dboficina'
  });

  const cargos = [
    'Encargado de area',
    'Tecnico de sistemas',
    'Tecnico de verificacion',
    'Tecnico de equipo',
    'Chofer',
    'Podador',
    'Cargador'
  ];

  console.log("Restaurando cargos (sin acentos para estabilidad)...");

  const [rows] = await connection.execute('SELECT id FROM tecnicos');
  
  for (const row of rows) {
     const cargoAleatorio = cargos[Math.floor(Math.random() * cargos.length)];
     await connection.execute('UPDATE tecnicos SET cargo = ? WHERE id = ?', [cargoAleatorio, row.id]);
  }

  console.log(`Corregidos ${rows.length} funcionarios.`);
  await connection.end();
}

fix().catch(console.error);
