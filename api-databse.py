import requests
import mysql.connector
from mysql.connector import Error


try:
    conn = mysql.connector.connect(
        host="localhost",       
        user="root", 
        password="Akhil@1234",  
        database="Flightassignment", 
        port=3306 
    )
    cursor = conn.cursor()
    print("Connected to MySQL successfully!")

except Error as e:
    print("MySQL Connection Error:", e)
    exit()

API_KEY = "cf2f4bcaf40ace70ac67224e6a06ef8d" 
API_URL = "http://api.aviationstack.com/v1/flights"  
#url

params = {
    "access_key": API_KEY,
    "dep_iata": "CDG",  
    "arr_iata": "LHR",  
    "limit": 100
}

response = requests.get(API_URL, params=params)


if response.status_code == 200:
    flight_data = response.json()["data"]

    if not flight_data:
        print("No flight data returned from API. Check your filters!")
        exit()

    for flight in flight_data:
        try:
            flight_number = flight["flight"]["iata"]
            departure_iata = flight["departure"]["iata"]
            arrival_iata = flight["arrival"]["iata"]
            departure_time = flight["departure"]["scheduled"]
            arrival_time = flight["arrival"]["scheduled"]
            airline_name = flight["airline"]["name"]
            status = flight["flight_status"]

            if not all([flight_number, departure_iata, arrival_iata, departure_time, arrival_time, airline_name, status]):
                print(f"Skipping incomplete flight data: {flight}")
                continue

            print(f"Inserting flight: {flight_number} from {departure_iata} to {arrival_iata}")

            insert_query = """
            INSERT INTO Flights (flight_number, departure_airport_id, arrival_airport_id, airline_id, departure_time, arrival_time, status)
            VALUES (%s, 
                    (SELECT airport_id FROM Airports WHERE iata_code = %s),
                    (SELECT airport_id FROM Airports WHERE iata_code = %s),
                    (SELECT airline_id FROM Airlines WHERE airline_name = %s),
                    %s, %s, %s)
            ON DUPLICATE KEY UPDATE 
            status = VALUES(status), arrival_time = VALUES(arrival_time);
            """

            cursor.execute(insert_query, (
                flight_number, departure_iata, arrival_iata, airline_name, departure_time, arrival_time, status
            ))

        except Error as e:
            print("SQL Insertion Error:", e)
            continue

    conn.commit()
    print("All flights inserted successfully!")

else:
    print("API Request Failed:", response.status_code, response.text)

# Close connection
cursor.close()
conn.close()
print("MySQL Connection Closed.")
