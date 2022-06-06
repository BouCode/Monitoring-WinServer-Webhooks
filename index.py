from flask import Flask, jsonify, request
from dotenv import load_dotenv

import requests 
import os 

load_dotenv()
app = Flask (__name__)
url = os.getenv ('URL_WEBHOOK')

headers = { "Content-Type": "application/json"}


@app.route ("/monitor-win", methods= ['POST'])
def monitor_win ():
    request_data   = request.get_json()
    memory_porcent = request_data["p_memory"]
    disk_porcent   = request_data["p_disk"]
    disk_free      = request_data["disk_free"]
    disk_used      = str(request_data["disk_used"])
    cpu_porcent    = request_data["p_cpu"]
    data = {
        "username": 'Tu viejo reportando directo en directo',
        "avatar_url": "https://i.imgur.com/4M34hi2.png", 
        "content": "¡ALERTA! Consumo excesivo de memoria",
        "embeds" : [{
            "fields": [
                {
                    "name": "Memoria %", 
                    "value": str(memory_porcent) + '%',
                    "inline": True
                },
                {
                    "name": "Disco %", 
                    "value": str(disk_porcent) + '%',
                    "inline": True, 

                },
                {
                    "name": "Espacio en disco", 
                    "value": str(disk_free) + 'GB',
                },
                {
                    "name": "Almacenamiento en disco", 
                    "value": str(disk_used) + 'GB',
                },
                {
                    "name": "CPU %", 
                    "value": str(cpu_porcent) + '%',
                }
            ]
        }]
    }

    if memory_porcent > 89 or disk_porcent > 75 or cpu_porcent > 60:
        requests.post(url, headers = headers, json = data)

    return jsonify(msg="Data received!")

app.run(host='0.0.0.0', port=5000, debug=True)
