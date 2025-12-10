const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const cron = require('node-cron');

const app = express();
app.use(cors());
app.use(express.json());

//подключение к бд
const pool = new Pool({
    user: '',
    host: 'localhost',
    database: 'cafe_bd',
    password: '123',
    port: 5432,
});

// POST api/bookings
app.post('api/bookings', async (req, res) => {
    const { name, phone, email, date, time, guests, tableId } = req.body;

    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 3);

    try {
        const result = await pool.query(
            `INSERT INTO bookings (name, phone, email, date, time, guests, "tableId", "expiresAt")
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id`,
            [name, phone, email, date, time, guests, tableId, expiresAt]
        );
        res.status(201).json({ id: result.rows[0].id });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошбика бронирования' });
    }
});

app.get('/api/bookings', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM bookings WHERE "expiresAt" > NOW() ORDER BY "createdAt" DESC'
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: 'Ошибка загрузки' });
    }
});

// GET /api/tables
app.get('/api/tables', async (req, res) => {
    const result = await pool.query('SELECT id, x_percent, y_percent FROM tables');
  res.json(result.rows);
});

// GET /api/occupied-tables?date=2025-12-10&time=18:00
app.get('/api/occupied-tables', async (req, res) => {
  const { date, time } = req.query;
  const result = await pool.query(
    `SELECT "tableId"::TEXT FROM bookings 
     WHERE date = $1 AND time = $2 AND "expiresAt" > NOW()`,
    [date, time]
  );
  res.json(result.rows.map(r => r.tableId));
});

// GET /api/cats
app.get('/api/cats', async (req, res) => {
    try {
        const result = await pool.query('SELECT id, name, description, gender, "imageUrl" FROM cats');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошибка загрузки котов' });
    }
});

// GET api/menu/today
application.get('api/menu/today', async (req, res) => {
    const today = new Date();
    const dateStr = today.toISOString().split('T')[0];

    try {
        let result = await pool.query(
            'SELECT * FROM daily_menus WHERE date = $1',
            [dateStr]
        );

        if (result.rows.length == 0) {
            const allDishes = await pool.query(
                'SELECT id, name, price, "imagesUrl" FROM dishes WHERE "isAvailable" = true'
            );

            if (allDishes.rows.length < 3) {
                return res.status(400).json({ error: 'Недостаточно блюд для формирования меню' });
            }

            const shuffled = [...allDishes.rows].sort(() => 0.5 - Math.random());
            const selected = shuffled.slice(0, 3);
            const dishIds = selected.map(d => d.id);

            // Сохраняем в daily_menus
            await pool.query(
                `INSERT INTO daily_menus (date, "dishesOfDay")
                VALUES ($1, $2)`,
                [dateStr, dishIds]
            );

            return res.json(selected);
        } else {
            const dishIds = result.rows[0].dishesOfDay; // предполагается, что это массив
            const placeholders = dishIds.map((_, i) => `$${i + 1}`).join(',');
            const query = `
        SELECT id, name, price, "imagesUrl"
        FROM dishes
        WHERE id IN (${placeholders})
      `;
            const dishesResult = await pool.query(query, dishIds);
            res.json(dishesResult.rows);
        }
    } catch (err) {
        console.error('Ошибка загрузки меню:', err);
        res.status(500).json({ error: 'Ошибка загрузки меню' });
    }
})

// Автоочистка каждые 10 минут
cron.schedule('*/10 * * * *', async () => {
    try {
        const result = await pool.query('DELETE FROM bookings WHERE "expiresAt" < NOW()');
        console.log(`🧹 Удалено ${result.rowCount} просроченных броней`);
    } catch (err) {
        console.error('Ошибка очистки:', err);
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🟢 Сервер запущен на http://localhost:${PORT}`);
});