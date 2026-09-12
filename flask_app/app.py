from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "<h1>Hello from the Flask Backend!</h1><p>DevOps Trainee Project is running.</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)