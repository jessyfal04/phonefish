from flask import Flask, jsonify, request, abort
import apiProcess
import secrets
import random
import string
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/users/register', methods=['POST'])
def usersRegister():
    args = request.args

    pseudo = args.get("pseudo").lower()
    identifier = apiProcess.getIdentifierFromPseudo(pseudo)
    token = secrets.token_hex(32//2)
    code = ''.join(random.choice(string.ascii_uppercase) for _ in range(4))
    
    apiProcess.execDB("INSERT INTO users (pseudo, identifier, code, token, date) VALUES (?, ?, ?, ?, datetime('now'))", (pseudo, identifier, code, token))

    response = {
        "pseudo" : pseudo,
        "identifier" : identifier,
        "token": token,
        "code": code
    }

    return jsonify(response)

@app.route('/users/playing', methods=['GET'])
def usersPlaying():
    result = apiProcess.execDB("SELECT pseudo, identifier, date FROM users")
    
    keys = ["pseudo", "identifier", "date"]
    response = [{keys[index]:value for index, value in enumerate(r)} for r in result]
    
    return jsonify(response)

@app.route('/scores/register', methods=['POST'])
def scoresRegister():
    args = request.args
    score = args.get("score")
    pseudo = args.get("pseudo")
    identifier = args.get("identifier")
    token = args.get("token")

    if None in [score, pseudo, identifier, token]:
        return jsonify(error = "Mauvais arguments"), 400

    score = int(score)

    apiProcess.execDB("UPDATE users SET score = ? WHERE pseudo = ? AND identifier = ? AND token = ?"
                      , (score, pseudo, identifier, token))
    
    result = apiProcess.execDB("SELECT score FROM users WHERE pseudo = ? AND identifier = ? AND token = ?"
                               , (pseudo, identifier, token))
    
    if len(result) == 1 and len(result[0]) == 1 and result[0][0] == score:
        return jsonify(success=True)
    else:
        return jsonify(error = "Score non mis à jour"), 500

@app.route('/scores/all', methods=['GET'])
def scoresAll():
    result = apiProcess.execDB("SELECT pseudo, identifier, score, date FROM users WHERE score IS NOT NULL ORDER BY score DESC, date ASC")
    
    keys = ["pseudo", "identifier", "score", "date"]
    response = [{keys[index]:value for index, value in enumerate(r)} for r in result]
    
    return jsonify(response)

@app.route('/scores/recent', methods=['GET'])
def scoresRecent():
    result = apiProcess.execDB("SELECT pseudo, identifier, score, date FROM users WHERE score IS NOT NULL AND date >= datetime('now','-1 day') ORDER BY score DESC, date ASC")
    
    keys = ["pseudo", "identifier", "score", "date"]
    response = [{keys[index]:value for index, value in enumerate(r)} for r in result]
    
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)
