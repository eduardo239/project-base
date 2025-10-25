from flask import Flask, jsonify, request

app = Flask(__name__)

# Example data (in-memory, for simplicity)
data = {"message": "Hello from Flask API!"}

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
    app.run(debug=True)