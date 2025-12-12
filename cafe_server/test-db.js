const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'cafeCat',
  password: '231153242780',
  port: 5433,
});

pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('❌ Ошибка подключения:', err.stack);
  } else {
    console.log('✅ Подключение к БД успешно!', res.rows[0]);
  }
  pool.end();
});