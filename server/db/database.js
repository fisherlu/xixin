const fs = require('fs');
const path = require('path');

const DATA_DIR = path.join(__dirname, '..', 'data');

// Ensure data directory exists
if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

class JsonDB {
  constructor(filename) {
    this.filepath = path.join(DATA_DIR, filename);
    this._load();
  }

  _load() {
    try {
      const raw = fs.readFileSync(this.filepath, 'utf-8');
      this.data = JSON.parse(raw);
    } catch {
      this.data = this._defaultData();
      this._save();
    }
  }

  _save() {
    fs.writeFileSync(this.filepath, JSON.stringify(this.data, null, 2));
  }

  _defaultData() { return []; }

  getAll() { return [...this.data]; }

  find(predicate) {
    return this.data.find(predicate) || null;
  }

  findAll(predicate) {
    return this.data.filter(predicate);
  }

  insert(item) {
    this.data.push(item);
    this._save();
    return item;
  }

  update(predicate, updates) {
    const idx = this.data.findIndex(predicate);
    if (idx >= 0) {
      this.data[idx] = { ...this.data[idx], ...updates };
      this._save();
      return this.data[idx];
    }
    return null;
  }

  upsert(predicate, item) {
    const idx = this.data.findIndex(predicate);
    if (idx >= 0) {
      this.data[idx] = { ...this.data[idx], ...item };
    } else {
      this.data.push(item);
    }
    this._save();
    return this.data[idx >= 0 ? idx : this.data.length - 1];
  }

  count(predicate) {
    if (!predicate) return this.data.length;
    return this.data.filter(predicate).length;
  }

  delete(predicate) {
    const before = this.data.length;
    this.data = this.data.filter((item) => !predicate(item));
    this._save();
    return before - this.data.length;
  }
}

// ── Database Collections ──
const users = new JsonDB('users.json');
const subscriptions = new JsonDB('subscriptions.json');
const receipts = new JsonDB('receipts.json');
const sessions = new JsonDB('sessions.json');
const stats = new JsonDB('stats.json');

module.exports = { users, subscriptions, receipts, sessions, stats };