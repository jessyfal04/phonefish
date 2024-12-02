import sqlite3
import json
from server import local

dburl = "../api/phonefish.db" if local else "/var/www/jessyfallavier.dev/phonefish/api/phonefish.db"
def execDB(cmd:str, args:tuple=()):
    with sqlite3.connect(dburl) as conn:
        cursor = conn.cursor()
        cursor.execute(cmd, args)
        conn.commit()

        return cursor.fetchall()

async def send(message, websocket):
    json_data = json.dumps(message)
    print(f"S : {websocket.remote_address} | {json_data}")
    await websocket.send(json_data)

def checkCodeValidity(pseudo, identifier, code):
    return execDB("SELECT COUNT(identifier) FROM users WHERE pseudo = ? AND identifier = ? AND code = ?", (pseudo,identifier, code))[0][0] == 1

def checkTokenValidity(pseudo, identifier, token):
    return execDB("SELECT COUNT(identifier) FROM users WHERE pseudo = ? AND identifier = ? AND token = ?", (pseudo,identifier, token))[0][0] == 1

pseudoIdToWS = {}

async def processOpen(message, websocket):
    pseudo, identifier, code = message["ARGS"]["pseudo"], message["ARGS"]["identifier"], message["ARGS"]["code"]

    res = "OK"
    if checkCodeValidity(pseudo, identifier, code):
        try:
            await send({"ACTION":"OPEN"}, pseudoIdToWS[pseudo+"#"+identifier])
        except:
            res = "ERR"
    else:
        res = "ERR"

    await send({"ACTION":"OPEN_R", "ERROR":res}, websocket)

async def processVibrate(message, websocket):
    pseudo, identifier, code = message["ARGS"]["pseudo"], message["ARGS"]["identifier"], message["ARGS"]["code"]

    res = "OK"
    if checkCodeValidity(pseudo, identifier, code):
        try:
            await send({"ACTION":"VIBRATE"}, pseudoIdToWS[pseudo+"#"+identifier])
        except:
            res = "ERR"
    else:
        res = "ERR"

    await send({"ACTION":"OPEN_R", "ERROR":res}, websocket)

async def processAccept(message, websocket):
    pseudo, identifier, token = message["ARGS"]["pseudo"], message["ARGS"]["identifier"], message["ARGS"]["token"]

    res = "OK"
    if checkTokenValidity(pseudo, identifier, token):
        pseudoIdToWS[pseudo+"#"+identifier] = websocket
    else:
        res = "ERR"

    await send({"ACTION":"OPEN_R", "ERROR":res}, websocket)