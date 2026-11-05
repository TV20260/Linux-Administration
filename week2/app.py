import os
from flask import Flask, render_template
import pymysql

app = Flask(__name__)

DB_CONFIG = {
    "host": "127.0.0.1",
    "user": "usercount",
    "password": os.environ.get("DB_PASSWORD"),
    "database": "week2_db",
    "cursorclass": pymysql.cursors.DictCursor
}

def get_and_increment_counter():
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            cursor.execute("UPDATE site_counter SET hits = hits + 1 WHERE id = 1;")
            cursor.execute("SELECT hits FROM site_counter WHERE id = 1;")
            result = cursor.fetchone()
            connection.commit()
            return result['hits'] if result else 0
    finally:
        connection.close()

@app.route('/week2/')
def index():
    total_hits = get_and_increment_counter()
    return render_template('index.html', hits=total_hits)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000)
