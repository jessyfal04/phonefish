from flask import Flask, jsonify, request, abort
import apiProcess
import secrets

app = Flask(__name__)

@app.route('/users/register', methods=['POST'])
def usersRegister():
    args = request.args

    pseudo = args.get("pseudo").lower()
    identifier = apiProcess.getIdentifierFromPseudo(pseudo)
    token = secrets.token_hex(32//2)
    
    apiProcess.execDB("INSERT INTO users (pseudo, identifier, token) VALUES (?, ?, ?)", (pseudo, identifier, token))

    response = {
        "pseudo" : pseudo,
        "identifier" : identifier,
        "token": token
    }

    return jsonify(response)

@app.route('/users/all', methods=['GET'])
def usersAll():
    result = apiProcess.execDB("SELECT pseudo, identifier FROM users")
    
    keys = ["pseudo", "identifier"]
    response = [{keys[index]:value for index, value in enumerate(r)} for r in result]
    
    return jsonify(response)


if __name__ == '__main__':
    app.run(debug=True)
