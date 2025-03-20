import requests

API_KEY = "cf2f4bcaf40ace70ac67224e6a06ef8d"  
API_URL = "http://api.aviationstack.com/v1/flights"


params = {
    "access_key": API_KEY,
    "dep_iata": "CDG",  
    "arr_iata": "LHR",  
    "limit": 100 
}

response = requests.get(API_URL, params=params)

if response.status_code == 200:
    flight_data = response.json()
    print(flight_data)  
else:
    print("Failed to fetch data:", response.status_code, response.text) 
    
