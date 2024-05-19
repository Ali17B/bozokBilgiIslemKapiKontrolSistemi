from flask import Flask
from flask_socketio import SocketIO
import serial
import threading

app = Flask(__name__)
socketio = SocketIO(app)

# Seri porttan okunan son UID'yi saklayacak global değişken
last_uid = ""

# Seri porttan veri okuma fonksiyonu
def read_from_port(ser):
    global last_uid
    while True:
        reading = ser.readline().decode('utf-8').strip()
        if reading.startswith("UID:"):
            last_uid = reading.split(":")[1].strip()
            # Yeni UID geldiğinde, bunu WebSocket üzerinden yayınla
            socketio.emit('new_uid', {'uid': last_uid})

# Seri portu açma
ser = serial.Serial('COM3', 9600, timeout=1)
thread = threading.Thread(target=read_from_port, args=(ser,))
thread.start()

if __name__ == '__main__':
    socketio.run(app, host='localhost', port=1234, debug=True)

