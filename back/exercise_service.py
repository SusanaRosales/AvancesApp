import requests

BASE_URL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist"

def get_all_body_parts():
    response = requests.get(f"{BASE_URL}/exercises.json", timeout=10)
    data = response.json()
    body_parts = list(set(ex["category"] for ex in data))
    return sorted(body_parts)

def get_exercises_by_body_part(body_part: str):
    response = requests.get(f"{BASE_URL}/exercises.json", timeout=10)
    data = response.json()
    return [ex for ex in data if ex.get("category", "").lower() == body_part.lower()]

def search_exercises_by_name(name: str):
    response = requests.get(f"{BASE_URL}/exercises.json", timeout=10)
    data = response.json()
    return [ex for ex in data if name.lower() in ex.get("name", "").lower()]

def get_exercises_by_equipment(equipment: str):
    response = requests.get(f"{BASE_URL}/exercises.json", timeout=10)
    data = response.json()
    return [ex for ex in data if equipment.lower() in [e.lower() for e in ex.get("equipment", [])]]