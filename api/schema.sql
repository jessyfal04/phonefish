CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pseudo TEXT NOT NULL,
    identifier TEXT NOT NULL,
    code TEXT NOT NULL,
    token TEXT NOT NULL,
    score INTEGER DEFAULT NULL,
    date DATETIME NOT NULL,
    UNIQUE(pseudo, identifier)
);