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
    console.log('⚠️ Пришёл запрос:', req.body);
    console.log('📦 Тело запроса:', JSON.stringify(req.body, null, 2));
    console.log('📊 Поля:', {
        date: req.body.date,
        time: req.body.time,
        name: req.body.name,
        phone: req.body.phone,
        email: req.body.email,
        guests: req.body.guests,
        tableId: req.body.tableId
    });

    const { name, phone, email, date, time, guests, tableId } = req.body;

    // Проверяем все обязательные поля
    const missingFields = [];
    if (!date) missingFields.push('date');
    if (!time) missingFields.push('time');
    if (!name) missingFields.push('name');
    if (!phone) missingFields.push('phone');
    if (!tableId) missingFields.push('tableId');
    
    if (missingFields.length > 0) {
        console.error('Отсутствуют поля:', missingFields);
        return res.status(400).json({ 
            error: 'Не хватает данных',
            missingFields: missingFields 
        });
    }

    try {
        const timeWithSeconds = time.length === 5 ? `${time}:00` : time;

        const bookingDateTime = new Date(`${date}T${timeWithSeconds}+03:00`);

        if (isNaN(bookingDateTime.getTime())) {
            return res.status(400).json({ error: 'Некорректная дата или время' });
        }

        const expires_at = new Date(bookingDateTime);
        expires_at.setHours(expires_at.getHours() + 2);

        if (bookingDateTime < new Date()) {
            return res.status(400).json({ error: 'Нельзя бронировать на прошлое' });
        }

        const result = await pool.query(
            `INSERT INTO bookings (name, phone, email, date, time, guests, "tableId", "expires_at")
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id`,
            [name, phone, email, date, time, guests, tableId, expires_at]
        );

        res.status(201).json({ id: result.rows[0].id });

    } catch (err) {
        console.error('Ошибка бронирования:', err);
        res.status(500).json({ error: 'Ошибка бронирования', details: err.message });
    }
});

app.get('/api/bookings', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM bookings WHERE "expires_at" > NOW() ORDER BY "created_at" DESC'
        );
        res.json(result.rows);
    } catch (err) {
        console.error('Ошибка в /api/bookings:', err.message);
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
    try {
        const { date, time } = req.query;
        
        if (!date || !time) {
            return res.status(400).json({ error: 'Необходимы параметры date и time' });
        }
        
        // Проверка даты
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(date)) {
            return res.status(400).json({ error: 'Неверный формат даты. Используйте YYYY-MM-DD' });
        }
        
        // Проверка времени (HH:MM или HH:MM:SS)
        const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/;
        if (!timeRegex.test(time)) {
            return res.status(400).json({ error: 'Неверный формат времени' });
        }
        
        const result = await pool.query(
            `SELECT "tableId"::TEXT 
             FROM bookings 
             WHERE date = $1::DATE 
               AND time = $2::TIME 
               AND "expires_at" > NOW()
               AND status NOT IN ('cancelled', 'expired')`, // Добавьте проверку статуса
            [date, time]
        );
        
        res.json(result.rows.map(r => r.tableId));
    } catch (error) {
        console.error('Ошибка при получении занятых столов:', error);
        res.status(500).json({ error: 'Внутренняя ошибка сервера' });
    }
});

// GET /api/cats
app.get('/api/cats', async (req, res) => {
    try {
        const result = await pool.query('SELECT id, name, description, gender, "image_url", "hover_url" FROM cats');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошибка загрузки котов' });
    }
});

// POST создать нового кота
app.post('/api/cats', async (req, res) => {
    const { name, gender, description, image_url, hover_url } = req.body;
    
    // Валидация
    if (!name || !gender) {
        return res.status(400).json({ 
            error: 'Обязательные поля: name, gender' 
        });
    }
    
    try {
        // Генерируем ID (можно использовать UUID или оставить как есть)
        const id = `cat_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        
        const result = await pool.query(
            `INSERT INTO cats (id, name, gender, description, "image_url", "hover_url") 
             VALUES ($1, $2, $3, $4, $5, $6) 
             RETURNING *`,
            [id, name, gender, description || null, image_url || null, hover_url || null]
        );
        
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error('Ошибка создания кота:', err);
        res.status(500).json({ 
            error: 'Ошибка создания кота', 
            details: err.message 
        });
    }
});

// PUT обновить кота
app.put('/api/cats/:id', async (req, res) => {
    const { id } = req.params;
    const { name, gender, description, image_url, hover_url } = req.body;
    
    console.log(`🔄 PUT запрос для кота ID: ${id}`);
    console.log('📦 Данные:', { name, gender });
    
    if (!name || !gender) {
        return res.status(400).json({ 
            error: 'Обязательные поля: name, gender',
            received: { name, gender }
        });
    }
    
    try {
        // Сначала проверим существование кота
        const checkResult = await pool.query(
            'SELECT id FROM cats WHERE id = $1',
            [id]
        );
        
        console.log(`🔍 Найдено котов с ID ${id}: ${checkResult.rows.length}`);
        
        if (checkResult.rows.length === 0) {
            return res.status(404).json({ 
                error: `Кот с ID "${id}" не найден`,
                availableIds: (await pool.query('SELECT id FROM cats')).rows.map(r => r.id)
            });
        }
        
        const result = await pool.query(
            `UPDATE cats 
             SET name = $1, 
                 gender = $2, 
                 description = $3, 
                 "image_url" = $4, 
                 "hover_url" = $5,
                 updated_at = NOW()
             WHERE id = $6 
             RETURNING *`,
            [name, gender, description || null, image_url || null, hover_url || null, id]
        );
        
        console.log(`Кот обновлен: ${result.rows[0].name}`);
        
        res.json({
            success: true,
            cat: result.rows[0]
        });
        
    } catch (err) {
        console.error('Ошибка обновления кота:', err);
        res.status(500).json({ 
            error: 'Ошибка обновления кота', 
            details: err.message,
            stack: err.stack
        });
    }
});

// DELETE удалить кота
app.delete('/api/cats/:id', async (req, res) => {
    const { id } = req.params;
    
    try {
        const result = await pool.query(
            'DELETE FROM cats WHERE id = $1 RETURNING id',
            [id]
        );
        
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Кот не найден' });
        }
        
        res.json({ 
            success: true, 
            message: 'Кот удален',
            id: result.rows[0].id 
        });
    } catch (err) {
        console.error('Ошибка удаления кота:', err);
        res.status(500).json({ 
            error: 'Ошибка удаления кота', 
            details: err.message 
        });
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

app.post('/api/admin/login', async (req, res) => {
    const { email } = req.body;

    try {
        const result = await pool.query(
            'SELECT * FROM admin WHERE email = $1 AND is_active = true',
            [email]
        );

        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Пользователь не найден' });
        }

        const user = result.rows[0];

        if (user.role !== 'admin') {
            return res.status(403).json({ error: 'Доступ запрещён' });
        }

        // Можно вернуть токен, но для простоты — просто данные
        res.json({
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошибка входа' });
    }
})

//редактирвоание броней
app.put('/api/bookings/:id', async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;

    if (!['pending', 'confirmed', 'cancelled', 'expired'].includes(status)) {
        return res.status(400).json({ error: 'Некорректный статус' });
    }

    try {
        const result = await pool.query(
            `UPDATE bookings 
             SET status = $1
             WHERE id = $2 RETURNING *`,
            [status, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Бронь не найдена' });
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Ошибка обновления брони' });
    }
});

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
    console.log(`!!! Сервер запущен на http://localhost:${PORT}`);
});

const requireAdmin = async (req, res, next) => {
    next();
}