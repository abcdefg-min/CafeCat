const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const cron = require('node-cron');

const app = express();
app.use(cors());
app.use(express.json());

// Подключение к БД
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'cafeCat',
    password: '231153242780',
    port: 5433,
});

// Проверка подключения
pool.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('Ошибка подключения к БД:', err.stack);
    } else {
        console.log('Подключение к БД успешно!', res.rows[0]);
    }
});

//БРОНИ----------------------------------------------------------------
app.post('/api/bookings', async (req, res) => {
    console.log('⚠️ Пришёл запрос на бронирование:', req.body);
    
    const { name, phone, email, date, time, guests, tableId } = req.body;

    // Проверка обязательных полей
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
            missingFields 
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
        console.error('Ошибка обновления брони:', err);
        res.status(500).json({ error: 'Ошибка обновления брони' });
    }
});

//СТОЛЫ----------------------------------------------------------------
app.get('/api/tables', async (req, res) => {
    try {
        const result = await pool.query('SELECT id, x_percent, y_percent FROM tables');
        res.json(result.rows);
    } catch (err) {
        console.error('Ошибка загрузки столов:', err);
        res.status(500).json({ error: 'Ошибка загрузки столов' });
    }
});

app.get('/api/occupied-tables', async (req, res) => {
    try {
        const { date, time } = req.query;
        
        if (!date || !time) {
            return res.status(400).json({ error: 'Необходимы параметры date и time' });
        }
        
        // Проверка формата даты
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(date)) {
            return res.status(400).json({ error: 'Неверный формат даты. Используйте YYYY-MM-DD' });
        }
        
        // Проверка формата времени
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
               AND status NOT IN ('cancelled', 'expired')`,
            [date, time]
        );
        
        res.json(result.rows.map(r => r.tableId));
    } catch (error) {
        console.error('Ошибка при получении занятых столов:', error);
        res.status(500).json({ error: 'Внутренняя ошибка сервера' });
    }
});

//КОТЫ----------------------------------------------------------------
app.get('/api/cats', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT id, name, description, gender, "image_url", "hover_url" FROM cats'
        );
        res.json(result.rows);
    } catch (err) {
        console.error('Ошибка загрузки котов:', err);
        res.status(500).json({ error: 'Ошибка загрузки котов' });
    }
});

app.post('/api/cats', async (req, res) => {
    const { name, gender, description, image_url, hover_url } = req.body;
    
    if (!name || !gender) {
        return res.status(400).json({ 
            error: 'Обязательные поля: name, gender' 
        });
    }
    
    try {
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

app.put('/api/cats/:id', async (req, res) => {
    const { id } = req.params;
    const { name, gender, description, image_url, hover_url } = req.body;
    
    if (!name || !gender) {
        return res.status(400).json({ 
            error: 'Обязательные поля: name, gender'
        });
    }
    
    try {
        // Проверка существования кота
        const checkResult = await pool.query(
            'SELECT id FROM cats WHERE id = $1',
            [id]
        );
        
        if (checkResult.rows.length === 0) {
            return res.status(404).json({ 
                error: `Кот с ID "${id}" не найден`
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
        
        res.json({
            success: true,
            cat: result.rows[0]
        });
        
    } catch (err) {
        console.error('Ошибка обновления кота:', err);
        res.status(500).json({ 
            error: 'Ошибка обновления кота', 
            details: err.message
        });
    }
});

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

//------------------БЛЮДА----------------------------------------------------------------
app.get('/api/dishes', async (req, res) => {
    try {
        console.log('Запрос на получение всех блюд');
        
        const result = await pool.query(`
            SELECT 
                id, 
                name, 
                category, 
                price, 
                is_available, 
                images_url, 
                created_at 
            FROM dishes 
            ORDER BY created_at DESC
        `);
        
        console.log(`Найдено ${result.rows.length} блюд`);
        res.json(result.rows);
        
    } catch (err) {
        console.error('Ошибка при получении блюд:', err);
        res.status(500).json({ 
            error: 'Ошибка сервера при получении блюд',
            details: err.message 
        });
    }
});

app.get('/api/dishes/:id', async (req, res) => {
    try {
        const { id } = req.params;
        console.log(`Запрос блюда с ID: ${id}`);
        
        const result = await pool.query(
            'SELECT * FROM dishes WHERE id = $1',
            [id]
        );
        
        if (result.rows.length === 0) {
            console.log(`Блюдо с ID ${id} не найдено`);
            return res.status(404).json({ error: 'Блюдо не найдено' });
        }
        
        console.log(`Блюдо найдено: ${result.rows[0].name}`);
        res.json(result.rows[0]);
        
    } catch (err) {
        console.error('Ошибка при получении блюда:', err);
        res.status(500).json({ 
            error: 'Ошибка сервера', 
            details: err.message 
        });
    }
});

app.post('/api/dishes', async (req, res) => {
    try {
        console.log('Запрос на создание блюда:', req.body);
        
        const { 
            name, 
            category, 
            price, 
            is_available = true, 
            images_url, 
        } = req.body;

        // Валидация
        if (!name || !category || price === undefined) {
            console.error('Отсутствуют обязательные поля');
            return res.status(400).json({ 
                error: 'Поля name, category и price обязательны' 
            });
        }

        const priceNum = parseFloat(price);
        if (isNaN(priceNum) || priceNum <= 0) {
            console.error('Некорректная цена:', price);
            return res.status(400).json({ 
                error: 'Цена должна быть положительным числом' 
            });
        }

        // Генерация ID
        const id = `dish_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

        const result = await pool.query(
            `INSERT INTO dishes (
                id, 
                name, 
                category, 
                price, 
                is_available, 
                images_url, 
                created_at
            ) VALUES ($1, $2, $3, $4, $5, $6, NOW())
            RETURNING *`,
            [id, name, category, priceNum, is_available, images_url || null]
        );

        console.log(`Блюдо создано: ${result.rows[0].name}`);
        res.status(201).json(result.rows[0]);
        
    } catch (err) {
        console.error('Ошибка при создании блюда:', err);
        res.status(500).json({ 
            error: 'Ошибка сервера', 
            details: err.message,
            stack: err.stack 
        });
    }
});

app.put('/api/dishes/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            name, 
            category, 
            price, 
            is_available, 
            images_url, 
        } = req.body;

        console.log(`PUT запрос для блюда ID: ${id}`);
        console.log('Данные:', req.body);

        // Проверяем существование блюда
        const checkResult = await pool.query(
            'SELECT id FROM dishes WHERE id = $1',
            [id]
        );

        if (checkResult.rows.length === 0) {
            console.error(`Блюдо с ID ${id} не найдено`);
            return res.status(404).json({ error: 'Блюдо не найдено' });
        }

        // Валидация цены
        if (price !== undefined) {
            const priceNum = parseFloat(price);
            if (isNaN(priceNum) || priceNum <= 0) {
                console.error('Некорректная цена:', price);
                return res.status(400).json({ 
                    error: 'Цена должна быть положительным числом' 
                });
            }
        }

        const result = await pool.query(
            `UPDATE dishes SET 
                name = COALESCE($1, name),
                category = COALESCE($2, category),
                price = COALESCE($3, price),
                is_available = COALESCE($4, is_available),
                images_url = COALESCE($5, images_url),
                updated_at = NOW()
            WHERE id = $6
            RETURNING *`,
            [
                name || null, 
                category || null, 
                price !== undefined ? parseFloat(price) : null, 
                is_available !== undefined ? is_available : null,
                images_url || null, 
                id
            ]
        );

        console.log(`Блюдо обновлено: ${result.rows[0].name}`);
        
        res.json({
            success: true,
            dish: result.rows[0]
        });
        
    } catch (err) {
        console.error('Ошибка при обновлении блюда:', err);
        res.status(500).json({ 
            error: 'Ошибка обновления блюда', 
            details: err.message,
            stack: err.stack
        });
    }
});

app.delete('/api/dishes/:id', async (req, res) => {
    try {
        const { id } = req.params;
        console.log(`Запрос на удаление блюда ID: ${id}`);

        const result = await pool.query(
            'DELETE FROM dishes WHERE id = $1 RETURNING id, name',
            [id]
        );

        if (result.rows.length === 0) {
            console.error(`Блюдо с ID ${id} не найдено`);
            return res.status(404).json({ error: 'Блюдо не найдено' });
        }

        console.log(`Блюдо удалено: ${result.rows[0].name}`);
        
        res.json({ 
            success: true, 
            message: 'Блюдо удалено',
            id: result.rows[0].id,
            name: result.rows[0].name
        });
        
    } catch (err) {
        console.error('Ошибка при удалении блюда:', err);
        res.status(500).json({ 
            error: 'Ошибка удаления блюда', 
            details: err.message 
        });
    }
});

app.get('/api/dishes/category/:category', async (req, res) => {
    try {
        const { category } = req.params;
        console.log(`Запрос блюд категории: ${category}`);
        
        const result = await pool.query(
            'SELECT * FROM dishes WHERE category = $1 AND is_available = true ORDER BY name',
            [category]
        );
        
        console.log(`Найдено ${result.rows.length} блюд в категории ${category}`);
        res.json(result.rows);
        
    } catch (err) {
        console.error('Ошибка при получении блюд по категории:', err);
        res.status(500).json({ error: 'Ошибка сервера' });
    }
});

app.get('/api/dishes/search/:query', async (req, res) => {
    try {
        const { query } = req.params;
        console.log(`Поиск блюд: ${query}`);
        
        const result = await pool.query(
            `SELECT * FROM dishes 
             WHERE (name ILIKE $1 
             OR category ILIKE $1)
             AND is_available = true
             ORDER BY name`,
            [`%${query}%`]
        );
        
        console.log(`Найдено ${result.rows.length} блюд по запросу "${query}"`);
        res.json(result.rows);
        
    } catch (err) {
        console.error('Ошибка при поиске блюд:', err);
        res.status(500).json({ error: 'Ошибка сервера' });
    }
});

//БЛЮДА ДНЯ----------------------------------------------------------------
app.get('/api/daily_menus', async (req, res) => {
    try {
        const today = new Date();
        const dateStr = today.toISOString().split('T')[0];

        console.log(`Запрос меню на дату: ${dateStr}`);

        // Ищем существующее меню
        const result = await pool.query(
            'SELECT * FROM daily_menus WHERE date_str = $1',
            [dateStr]
        );

        if (result.rows.length === 0) {
            console.log(`Меню на ${dateStr} не найдено, создаем новое...`);
            
            // Получаем все доступные блюда
            const allDishes = await pool.query(
                'SELECT id, name, price, images_url FROM dishes WHERE is_available = true'
            );

            if (allDishes.rows.length < 3) {
                console.error('Недостаточно доступных блюд');
                return res.status(400).json({ 
                    error: 'Недостаточно блюд для формирования меню',
                    available: allDishes.rows.length
                });
            }

            // Случайный выбор 3 блюд
            const shuffled = [...allDishes.rows].sort(() => 0.5 - Math.random());
            const selected = shuffled.slice(0, 3);
            const dishIds = selected.map(d => d.id);

            console.log(`Выбраны блюда: ${selected.map(d => d.name).join(', ')}`);

            // Сохраняем в daily_menus
            await pool.query(
                `INSERT INTO daily_menus (menu_date, date_str, dishes_of_day, generated_at)
                 VALUES ($1, $2, $3::jsonb, NOW())`,
                [dateStr, dateStr, JSON.stringify(dishIds)]
            );

            return res.json(selected);
        } else {
            // Получаем блюда из существующего меню
            const menu = result.rows[0];
            console.log(`Найдено существующее меню: ${JSON.stringify(menu.dishes_of_day)}`);
            
            if (!menu.dishes_of_day || !Array.isArray(menu.dishes_of_day)) {
                console.error('dishes_of_day не является массивом');
                return res.status(500).json({ error: 'Некорректный формат меню' });
            }

            const dishIds = menu.dishes_of_day;
            
            // Если массив пустой
            if (dishIds.length === 0) {
                return res.json([]);
            }

            // Получаем данные о блюдах
            const placeholders = dishIds.map((_, i) => `$${i + 1}`).join(',');
            const dishesQuery = `
                SELECT id, name, price, images_url
                FROM dishes
                WHERE id IN (${placeholders})
            `;
            
            const dishesResult = await pool.query(dishesQuery, dishIds);
            console.log(`Найдено ${dishesResult.rows.length} блюд в меню`);
            
            res.json(dishesResult.rows);
        }
    } catch (err) {
        console.error('Ошибка загрузки меню:', err);
        res.status(500).json({ 
            error: 'Ошибка загрузки меню', 
            details: err.message,
            stack: err.stack 
        });
    }
});

//получить все меню
app.get('/api/daily_menus/all', async (req, res) => {
    try {
        console.log('Запрос всех меню');
        const result = await pool.query(
            'SELECT * FROM daily_menus ORDER BY menu_date DESC'
        );
        console.log(`Найдено ${result.rows.length} меню`);
        res.json(result.rows);
    } catch (err) {
        console.error('Ошибка загрузки меню ', err);
        res.status(500).json({
            error: 'Ошибка загрузки меню',
            details: err.message
        });
    }
});

//получить меню на конкретную дату
app.get('/api/daily_menus/:date', async (req, res) => {
    try {
        const {date} = req.params;
        const dateRegex  = /^\d{4}-\d{2}-\d{2}$/;
        if(!dateRegex.test(date)) {
            return res.status(400).json({
                error: 'Неверный формат даты'
            });
        }
        const result = await pool.query(
            'SELECT * FROM daily_menus WHERE date_str = $1',
            [date]
        );
        
        if (result.rows.length === 0) {
            console.log(`Меню на ${date} не найдено`);
            return res.json({ date, dishes: [] });
        }
        
        const menu = result.rows[0];
        const dishIds = menu.dishes_of_day || [];

        // Получаем данные о блюдах
        if (dishIds.length > 0) {
            const placeholders = dishIds.map((_, i) => `$${i + 1}`).join(',');
            const dishesQuery = `
                SELECT id, name, price, images_url, category
                FROM dishes
                WHERE id IN (${placeholders})
            `;
            
            const dishesResult = await pool.query(dishesQuery, dishIds);
            menu.dishes = dishesResult.rows;
        } else {
            menu.dishes = [];
        }
        console.log(`Найдено меню с ${dishIds.length} блюдами`);
        res.json(menu);
    } catch (err) {
        console.error('Ошибка загрузки меню:', err);
        res.status(500).json({ 
            error: 'Ошибка загрузки меню', 
            details: err.message 
        });
    }
});

//создать или обновить меню на дату
app.post('/api/daily_menus', async (req, res) => {
    try {
        const { date, dishIds } = req.body;
        console.log(`Создание/обновление меню на ${date}:`, dishIds);
        
        // Проверка формата даты
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(date)) {
            return res.status(400).json({ error: 'Неверный формат даты. Используйте YYYY-MM-DD' });
        }
        
        // Проверка dishIds
        if (!Array.isArray(dishIds)) {
            return res.status(400).json({ error: 'dishIds должен быть массивом' });
        }
        
        if (dishIds.length > 5) {
            return res.status(400).json({ error: 'Максимум 5 блюд в меню дня' });
        }
        
        // Проверяем существование блюд
        if (dishIds.length > 0) {
            const placeholders = dishIds.map((_, i) => `$${i + 1}`).join(',');
            const checkQuery = `SELECT id FROM dishes WHERE id IN (${placeholders})`;
            const checkResult = await pool.query(checkQuery, dishIds);
            
            if (checkResult.rows.length !== dishIds.length) {
                return res.status(400).json({ 
                    error: 'Некоторые блюда не найдены',
                    foundIds: checkResult.rows.map(r => r.id)
                });
            }
        }
        
        // Проверяем существующее меню
        const existingResult = await pool.query(
            'SELECT * FROM daily_menus WHERE date_str = $1',
            [date]
        );
        
        let result;
        if (existingResult.rows.length === 0) {
            // Создаем новое меню
            result = await pool.query(
                `INSERT INTO daily_menus (menu_date, date_str, dishes_of_day, generated_at)
                 VALUES ($1, $2, $3::jsonb, NOW())
                 RETURNING *`,
                [date, date, JSON.stringify(dishIds)]
            );
            console.log(`Создано новое меню на ${date}`);
        } else {
            // Обновляем существующее меню
            result = await pool.query(
                `UPDATE daily_menus 
                 SET dishes_of_day = $1::jsonb, 
                     generated_at = NOW()
                 WHERE date_str = $2
                 RETURNING *`,
                [JSON.stringify(dishIds), date]
            );
            console.log(`Обновлено меню на ${date}`);
        }
        
        res.json({
            success: true,
            menu: result.rows[0],
            message: existingResult.rows.length === 0 ? 'Меню создано' : 'Меню обновлено'
        });
    } catch (err) {
        console.error('Ошибка сохранения меню ', err);
        res.status(500).json({
            error: 'Ошибка сохранения меню',
            details: err.message,
            stack: err.stack
        });
    }
});

//удалить меню на дату
app.delete('/api/daily_menus/:date', async (req, res) => {
    try {
        const {date} = req.params;
        console.log(`Удаление меню на дату ${date}`);
        const result = await pool.query(
            'DELETE FROM daily_menus WHERE date_str = $1 RETURNING date_str',
            [date]
        );

        if (result.eow.length === 0) {
            console.log(`Меню на ${date} не найдено`);
            return res.status(400).json({error: 'Меню не найдено'});
        }

        console.log(`Меню на ${date} удалено`);
        res.json({
            success: true,
            message: 'Меню удалено',
            date: result.row[0].date_str
        });

    } catch (err) {
        console.error('Ошибка удаления меню ', err);
        res.status(500).json({
            error: 'Ошибка удаления меню',
            details: err.message
        });
    }
});


//АДМИН АУТЕНТИФИКАЦИЯ--------------------------------------------------------
app.post('/api/admin/login', async (req, res) => {
    try {
        const { email } = req.body;
        console.log(`Попытка входа админа: ${email}`);

        const result = await pool.query(
            'SELECT * FROM admin WHERE email = $1 AND is_active = true',
            [email]
        );

        if (result.rows.length === 0) {
            console.error('Пользователь не найден или неактивен');
            return res.status(401).json({ error: 'Пользователь не найден' });
        }

        const user = result.rows[0];

        if (user.role !== 'admin') {
            console.error('Недостаточно прав');
            return res.status(403).json({ error: 'Доступ запрещён' });
        }

        console.log(`Успешный вход: ${user.name}`);
        
        res.json({
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
        });

    } catch (err) {
        console.error('Ошибка входа:', err);
        res.status(500).json({ error: 'Ошибка входа', details: err.message });
    }
});

// Автоочистка просроченных броней каждые 10 минут
cron.schedule('*/10 * * * *', async () => {
    try {
        const result = await pool.query(
            'DELETE FROM bookings WHERE "expires_at" < NOW()'
        );
        console.log(`Удалено ${result.rowCount} просроченных броней`);
    } catch (err) {
        console.error('Ошибка очистки:', err);
    }
});

//ЗАПУСК СЕРВАКА
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Сервер запущен на http://localhost:${PORT}`);
});