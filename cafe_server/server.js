const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const cron = require('node-cron');

const app = express();
app.use(cors());
app.use(express.json());

//подключение к бд
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
        console.log('✅ Подключение успешно!', res.rows[0]);
    }
    //pool.end();
});

// POST api/bookings
app.post('/api/bookings', async (req, res) => {
    const { name, phone, email, date, time, guests, tableId } = req.body;

    const expires_at = new Date();
    expires_at.setHours(expires_at.getHours() + 3);

    try {
        const result = await pool.query(
            `INSERT INTO bookings (name, phone, email, date, time, guests, "tableId", "expires_at")
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id`,
            [name, phone, email, date, time, guests, tableId, expires_at]
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
            'SELECT * FROM bookings WHERE "expires_at" > NOW() ORDER BY "created_at" DESC'
        );
        res.json(result.rows);
    } catch (err) {
        console.error('❌ Ошибка в /api/bookings:', err.message);
        res.status(500).json({ error: 'Ошибка загрузки', details: err.message });
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
        const result = await pool.query('SELECT id, name, description, gender, "image_url" FROM cats');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошибка загрузки котов' });
    }
});

// GET api/menu/today
app.get('/api/daily_menus', async (req, res) => {
    const today = new Date();
    const dateStr = today.toISOString().split('T')[0];

    try {
        let result = await pool.query(
            'SELECT * FROM daily_menus WHERE date_str = $1',
            [dateStr]
        );

        if (result.rows.length == 0) {
            const allDishes = await pool.query(
                'SELECT id, name, price, "images_url" FROM dishes WHERE "is_available" = true'
            );

            if (allDishes.rows.length < 3) {
                return res.status(400).json({ error: 'Недостаточно блюд для формирования меню' });
            }

            const shuffled = [...allDishes.rows].sort(() => 0.5 - Math.random());
            const selected = shuffled.slice(0, 3);
            const dishIds = selected.map(d => d.id);

            // Сохраняем в daily_menus
            // Сохраняем в daily_menus — теперь с menu_date и generated_at
            await pool.query(
                `INSERT INTO daily_menus (menu_date, date_str, "dishes_of_day", "generated_at")
   VALUES ($1, $2, $3::jsonb, NOW())`,
                [dateStr, dateStr, JSON.stringify(dishIds)]
            );

            return res.json(selected);
        } else {
            const dishIds = result.rows[0].dishes_of_day; // предполагается, что это массив
            const placeholders = dishIds.map((_, i) => `$${i + 1}`).join(',');
            const query = `
        SELECT id, name, price, "images_url"
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
        const result = await pool.query('DELETE FROM bookings WHERE "expires_at" < NOW()');
        console.log(`🧹 Удалено ${result.rowCount} просроченных броней`);
    } catch (err) {
        console.error('Ошибка очистки:', err);
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🟢 Сервер запущен на http://localhost:${PORT}`);
});