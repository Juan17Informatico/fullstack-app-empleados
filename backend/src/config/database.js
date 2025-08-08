const { Pool } = require("pg");
require("dotenv").config();

const pool = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'db',
    database: process.env.DB_NAME || 'empleados_db',
    password: process.env.DB_PASSWORD || 'password',
    port: process.env.DB_PORT || 5432,
    max: 10,
    idleTimeoutMillis: 30000,
});

const testConnection = async () => {
    try {
        const client = await pool.connect();
        console.log("✅ Conexión a la base de datos establecida");
        client.release();
    } catch (err) {
        console.error("❌ Error conectando a la base de datos:", err);
        process.exit(1);
    }
};

module.exports = { pool, testConnection };
