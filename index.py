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
    memory_porcent = str(request_data["p_memory"]) + "%"
    disk_porcent   = str(request_data["p_disk"]) + "%"
    disk_free      = str(request_data["disk_free"]) + "GB"
    disk_used      = str(request_data["disk_used"]) + "GB"
    data = {
        "username": 'Tu viejo reportando directo en directo',
        "avatar_url": "https://i.imgur.com/4M34hi2.png", 
        "embeds" : [{
            "fields": [
                {
                    "name": "Memoria %", 
                    "value": memory_porcent,
                    "inline": True
                },
                {
                    "name": "Disco %", 
                    "value": disk_porcent,
                    "inline": True, 

                },
                {
                    "name": "Espacio en disco", 
                    "value": disk_free,
                },
                {
                    "name": "Almacenamiento en disco", 
                    "value": disk_used,
                },                        
            ]
        }]
    }

    x = requests.post(url, headers = headers, json = data)
    print(x)
    return jsonify(msg="Data received!")

app.run(host='0.0.0.0', port=5000, debug=True)
