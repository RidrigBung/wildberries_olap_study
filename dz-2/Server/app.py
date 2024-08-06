from flask import Flask, make_response, render_template
app = Flask(__name__)

@app.route('/')
def hello_geek():
    resp = make_response(render_template('index.html'))
    return resp


if __name__ == "__main__":
    app.run(debug=True)