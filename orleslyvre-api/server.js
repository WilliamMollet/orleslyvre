const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;
const db = require('./db');

// Charger les variables d'environnement
require('dotenv').config();

// Configuration des options CORS
const corsOptions = {
    origin: 'http://example.com',
    optionsSuccessStatus: 200
};

// Utilise CORS avec des options spécifiques
app.use(cors(corsOptions));
// Middleware pour analyser les requêtes JSON
app.use(express.json());

// Routes pour Category
app.get('/api/categories', async (req, res) => {
    try {
        const rows = await db.query('SELECT * FROM Category');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/categories', async (req, res) => {
    const newCategory = req.body;
    try {
        const result = await db.query('INSERT INTO Category (label_cat) VALUES (?)', newCategory.label_cat);
        res.status(201).json({ id: result[0], ...newCategory });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Routes pour Item
app.get('/api/items', async (req, res) => {
    try {
        const rows = await db.query('SELECT * FROM Item');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/items', async (req, res) => {
    const newItem = req.body;
    try {
        const result = await db.query('INSERT INTO Item (name_item, desc_item, id_cat) VALUES (?,?,?)', [newItem.name_item, newItem.desc_item, newItem.id_cat]);
        res.status(201).json({ id: result[0], ...newItem });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Routes pour Rating
app.get('/api/:item/ratings', async (req, res) => {
    item = req.params.item;
    try {
        const rows = await db.query('SELECT * FROM Rating WHERE id_item = ?', item);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/ratings', async (req, res) => {
    const newRating = req.body;
    try {
        const result = await db.query('INSERT INTO Rating (val_rating, name_rating, id_item ) VALUES (?,?,?)', [newRating.val_rating, newRating.name_rating, newRating.id_item]);
        // Mettre à jour la moyenne des évaluations de l'item
        await updateAvgRating(newRating.id_item);
        res.status(201).json({ id: result[0], ...newRating });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Fonction pour mettre à jour la moyenne des évaluations
async function updateAvgRating(itemId) {
    try {
        const ratings = await db.query('SELECT AVG(val_rating) as avg_rating FROM Rating WHERE id_item = ?', [itemId]);
        console.log(ratings[0].avg_rating);
        const avgRating = Math.round(ratings[0].avg_rating * 10) / 10;
        console.log(avgRating);
        const newAvgRating = await db.query('UPDATE Item SET avg_rating_item = ? WHERE id_item = ?', [avgRating, itemId]);
        console.log(newAvgRating);
    } catch (err) {
        console.error(err);
    }
}

// Route pour rechercher des items
app.get('/api/items/search', async (req, res) => {
    const { category, limit, search, rating, orderBy, direction } = req.query;

    let query = 'SELECT * FROM Item';
    let queryParams = [];

    let conditions = [];

    if (category) {
        conditions.push('id_cat = ?');
        queryParams.push(category);
    }

    if (search) {
        conditions.push('name_item LIKE ?');
        queryParams.push(`%${search}%`);
    }

    if (rating) {
        conditions.push('avg_rating_item >= ?');
        queryParams.push(parseFloat(rating));
    }

    if (conditions.length > 0) {
        query += ' WHERE ' + conditions.join(' AND ');
    }

    let orderClause = ' ORDER BY ';
    if (orderBy) {
        orderClause += `${orderBy} `;
    } else {
        orderClause += 'name_item ';
    }

    if (direction && (direction.toUpperCase() === 'ASC' || direction.toUpperCase() === 'DESC')) {
        orderClause += direction.toUpperCase();
    } else {
        orderClause += 'DESC';
    }

    query += orderClause;

    if (limit) {
        query += ' LIMIT ?';
        queryParams.push(parseInt(limit, 10));
    }

    try {
        const rows = await db.query(query, queryParams);
        for (let i = 0; i < rows.length; i++) {
            const category = await itemCategory(rows[i].id_cat);
            rows[i].cat_item = category[0].label_cat;
        }
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

async function itemCategory(id) {
    try {
        const rows = await db.query('SELECT label_cat FROM Category WHERE id_cat = ?', id);
        return rows;
    } catch (err) {
        console.error(err);
    }
}

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
