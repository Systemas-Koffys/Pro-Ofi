import mysql from 'mysql2/promise';

async function fix() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'dboficina'
  });

  const contratos = [
    'Permanente (Item)',
    'Eventual (Consultor)',
    'Pasante/Practica',
    'Contrato Externo'
  ];

  const [rows] = await connection.execute('SELECT id FROM tecnicos');
  for (const row of rows) {
     const contratoAleatorio = contratos[Math.floor(Math.random() * contratos.length)];
     await connection.execute('UPDATE tecnicos SET tipo_contrato = ? WHERE id = ?', [contratoAleatorio, row.id]);
  }
  await connection.end();
}
fix().catch(console.error);
