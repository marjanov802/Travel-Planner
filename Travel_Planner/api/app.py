from flask import Flask, request, jsonify
import openai

app = Flask(__name__)

# Set your OpenAI API key
openai.api_key = "YOUR_OPENAI_API_KEY"

@app.route('/generate', methods=['POST'])
def generate_response():
    try:
        data = request.json
        prompt = data.get('prompt', '')

        # Call OpenAI API
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=prompt,
            max_tokens=100
        )

        # Send back the result
        return jsonify({"response": response.choices[0].text.strip()})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(port=5000)
