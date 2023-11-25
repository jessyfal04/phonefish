from flask import abort
from random import randint
import sqlite3

def execDB(cmd:str, args:tuple=()):
    with sqlite3.connect('phonefish.db') as conn:
        cursor = conn.cursor()
        cursor.execute(cmd, args)
        conn.commit()

        return cursor.fetchall()

def getIdentifierFromPseudo(pseudo:str) -> str:
    if pseudo == "" or len(pseudo) > 16 or not pseudo.isalnum():
        abort(400, description="Le pseudo n'est pas valide.")

    identifier = None
    maxTry = 1000
    while True:
        maxTry -= 1

        identifier = "".join([str(randint(0,9)) for _ in range(4)])
        if execDB("SELECT COUNT(identifier) FROM users WHERE pseudo = ? AND identifier = ?", (pseudo,identifier))[0][0] == 0:
            break
        if maxTry == 0:
            abort(500, "Nom d'utilisateur surchargé.")

    return identifier
