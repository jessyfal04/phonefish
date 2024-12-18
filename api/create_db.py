import sqlite3

with sqlite3.connect('phonefish.db') as conn:
    with open('schema.sql', 'r') as schema_file:
        conn.executescript(schema_file.read())