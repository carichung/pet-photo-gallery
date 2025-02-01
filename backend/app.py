from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import mysql.connector

app = Flask(__name__)
CORS(app)  # Enable CORS for frontend-backend communication

# Database configuration (replace with your actual database credentials)
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'password',
    'database': 'pet_photo_gallery'
}

# Ensure the uploads directory exists
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# Route to handle photo uploads
@app.route('/upload', methods=['POST'])
def upload_photo():
    if 'photo' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['photo']
    caption = request.form.get('caption', '')

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Save the file to the uploads folder
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    # Save photo metadata to the database
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        cursor.execute(
            'INSERT INTO photos (url, caption) VALUES (%s, %s)',
            (file_path, caption)
        )
        connection.commit()
        cursor.close()
        connection.close()
    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'message': 'Photo uploaded successfully!'}), 200

# Route to fetch all photos
@app.route('/photos', methods=['GET'])
def get_photos():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        cursor.execute('SELECT url, caption FROM photos')
        photos = cursor.fetchall()
        cursor.close()
        connection.close()
        return jsonify(photos), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

