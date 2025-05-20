from flask import Flask, request, jsonify
from career_engine import analyze_answers
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests from your Flutter frontend

@app.route('/')
def home():
    return "Career Guidance API is running!"

@app.route('/get-career', methods=['POST'])
def get_career():
    try:
        data = request.get_json(force=True)
        
        if not data or 'answers' not in data:
            return jsonify({"error": "Missing 'answers' field"}), 400

        answers = data['answers']

        if not isinstance(answers, list):
            return jsonify({"error": "'answers' must be a list"}), 400

        careers = analyze_answers(answers)
        return jsonify({"careers": careers})

    except Exception as e:
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
