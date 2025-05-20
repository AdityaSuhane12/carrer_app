import requests

url = 'http://127.0.0.1:5000/get-career'
data = {
    "answers": ["Creative", "Management"]
}

response = requests.post(url, json=data)
print(response.json())
