const initSqlJs = require('sql.js');
const fs = require('fs');
const path = require('path');

const DB_PATH = path.join(__dirname, 'agix.db');

let db = null;

function saveDb() {
  const data = db.export();
  fs.writeFileSync(DB_PATH, Buffer.from(data));
}

async function initDatabase() {
  const SQL = await initSqlJs();

  if (fs.existsSync(DB_PATH)) {
    const fileBuffer = fs.readFileSync(DB_PATH);
    db = new SQL.Database(fileBuffer);
    console.log('✅ Banco de dados carregado do disco.');
  } else {
    db = new SQL.Database();
    console.log('📦 Criando banco de dados e inserindo dados iniciais...');
    const sql = fs.readFileSync(path.join(__dirname, 'database.sql'), 'utf-8');
    db.run(sql);
    saveDb();
    console.log('✅ Banco de dados criado com sucesso!');
  }

  return db;
}

function getDb() { return db; }

function queryAll(sql, params = []) {
  const stmt = db.prepare(sql);
  stmt.bind(params);
  const rows = [];
  while (stmt.step()) rows.push(stmt.getAsObject());
  stmt.free();
  return rows;
}

function queryOne(sql, params = []) {
  return queryAll(sql, params)[0] || null;
}

function run(sql, params = []) {
  db.run(sql, params);
  saveDb();
}

function getAllUsers() {
  return queryAll('SELECT * FROM users ORDER BY created_at DESC');
}
function getUserById(id) {
  return queryOne('SELECT * FROM users WHERE id = ?', [id]);
}
function getUserByEmail(email) {
  return queryOne('SELECT * FROM users WHERE email = ?', [email]);
}
function createUser({ name, email, agency_name, plan = 'free' }) {
  run('INSERT INTO users (name, email, agency_name, plan) VALUES (?, ?, ?, ?)', [name, email, agency_name || null, plan]);
  return queryOne('SELECT * FROM users WHERE email = ?', [email]);
}
function getContentsByUser(userId, limit = 50) {
  return queryAll('SELECT * FROM contents WHERE user_id = ? ORDER BY created_at DESC LIMIT ?', [userId, limit]);
}
function getFavoritesByUser(userId) {
  return queryAll('SELECT * FROM contents WHERE user_id = ? AND is_favorite = 1 ORDER BY created_at DESC', [userId]);
}
function saveContent({ id, user_id, type, title, content, form_data }) {
  run('INSERT OR REPLACE INTO contents (id, user_id, type, title, content, form_data) VALUES (?, ?, ?, ?, ?, ?)',
    [id, user_id, type, title, content, JSON.stringify(form_data)]);
  return getContentById(id);
}
function getContentById(id) {
  return queryOne('SELECT * FROM contents WHERE id = ?', [id]);
}
function toggleFavorite(id) {
  run('UPDATE contents SET is_favorite = CASE WHEN is_favorite = 1 THEN 0 ELSE 1 END WHERE id = ?', [id]);
  return getContentById(id);
}
function deleteContent(id) {
  run('DELETE FROM contents WHERE id = ?', [id]);
}
function getClientsByUser(userId) {
  return queryAll('SELECT * FROM clients WHERE user_id = ? ORDER BY name ASC', [userId]);
}
function createClient({ user_id, name, niche, target_audience, notes }) {
  run('INSERT INTO clients (user_id, name, niche, target_audience, notes) VALUES (?, ?, ?, ?, ?)',
    [user_id, name, niche || null, target_audience || null, notes || null]);
  return queryAll('SELECT * FROM clients WHERE user_id = ? ORDER BY id DESC LIMIT 1', [user_id])[0];
}
function getTemplatesByUser(userId) {
  return queryAll('SELECT * FROM templates WHERE user_id = ? ORDER BY created_at DESC', [userId]);
}
function saveTemplate({ user_id, name, type, form_data }) {
  run('INSERT INTO templates (user_id, name, type, form_data) VALUES (?, ?, ?, ?)',
    [user_id, name, type, JSON.stringify(form_data)]);
  return queryAll('SELECT * FROM templates WHERE user_id = ? ORDER BY id DESC LIMIT 1', [user_id])[0];
}
function logUsage({ user_id, content_type, tokens_used }) {
  run('INSERT INTO ai_usage (user_id, content_type, tokens_used) VALUES (?, ?, ?)', [user_id, content_type, tokens_used || 0]);
}
function getUsageByUser(userId) {
  return queryAll('SELECT content_type, COUNT(*) as total, SUM(tokens_used) as tokens FROM ai_usage WHERE user_id = ? GROUP BY content_type', [userId]);
}
function getGeneralStats() {
  return {
    totalUsers:     queryOne('SELECT COUNT(*) as count FROM users').count,
    totalContents:  queryOne('SELECT COUNT(*) as count FROM contents').count,
    totalClients:   queryOne('SELECT COUNT(*) as count FROM clients').count,
    totalFavorites: queryOne('SELECT COUNT(*) as count FROM contents WHERE is_favorite = 1').count,
    contentByType:  queryAll('SELECT type, COUNT(*) as count FROM contents GROUP BY type ORDER BY count DESC'),
  };
}

module.exports = {
  initDatabase, getDb,
  getAllUsers, getUserById, getUserByEmail, createUser,
  getContentsByUser, getFavoritesByUser, saveContent, getContentById, toggleFavorite, deleteContent,
  getClientsByUser, createClient,
  getTemplatesByUser, saveTemplate,
  logUsage, getUsageByUser, getGeneralStats,
};
