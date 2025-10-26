import os
from flask import Flask, jsonify, request # type: ignore

app = Flask(__name__)

# Example data (in-memory, for simplicity)
data = {"message": "Hello from Flask API!"}

lista = [{
    "id": 1,
    "name": "Item One"
},
{
    "id": 2,
    "name": "Item Two"
}]










@app.route('/', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "message": "API is running"}), 200

def create_new():
    new_item = {
        "id": len(lista) + 1,
        "name": f"Item {len(lista) + 1}"
    }
    lista.append(new_item)
    return jsonify(new_item), 201

@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify(data)

@app.route('/api/data', methods=['POST'])
def update_data():
    new_message = request.json.get('message')
    if new_message:
        data['message'] = new_message
        return jsonify({"status": "success", "message": "Data updated"}), 200
    return jsonify({"status": "error", "message": "No message provided"}), 400

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
