from bs4 import BeautifulSoup
import requests
import json
import threading
from flask import Flask
from flask_caching import Cache
from pymongo import MongoClient

client = MongoClient('mongodb://localhost/')
db = client['na-stok-app']
config = {
    "DEBUG": True,          # some Flask specific configs
    "CACHE_TYPE": "simple", # Flask-Caching related configs
    "CACHE_DEFAULT_TIMEOUT": 300
}
app = Flask(__name__)
# tell Flask to use the above defined config
app.config.from_mapping(config)
cache = Cache(app)


def get_slope_condition():
    print('scrapping starts')
    response = requests.get('https://www.stok-narciarski.pl/warunki-narciarskie')
    slopes = []
    content = response.text
    soup = BeautifulSoup(content, "html.parser")
    for a in soup.findAll('div', class_='row slope-row slope-row-data'):
        try:
            tmp = a.find('h4', class_='slope-row-name').a
            name = tmp.text
            tmp = tmp['href']
            city = a.find('span', class_='slop-row-city').text
            condition_min = a.find('span', class_='snow-lvl min')
            if condition_min is not None:
                condition_min = condition_min.text.split(' ')[1]
            condition_max = a.find('span', class_='snow-lvl max')
            if condition_max is not None:
                condition_max = condition_max.text
            condition_equals = a.find('span', class_="snow-lvl equal")
            if condition_equals is not None:
                condition_equals = condition_equals.text
            update = a.find('time', class_='slope-update-time')['title']
            stat = a.find('div', class_='col-12 col-sm-4 col-lg-1 slope-status').span.text.replace(' ', '')
            snow_fall = a.find('span', class_='sfl-number').text
            weathers = []
            for w in a.find('ul', class_='slope-next-days').find_all('li'):
                day = w.find('span', class_='wc-day').text
                day_name = w.find('span', class_='wc-day-of-week').text
                day = day.replace(day_name, "")
                clouds = w.img['title']
                temperature = w.div.text.replace("oC", "")
                weather = {
                    "day": day,
                    "day_name": day_name,
                    "clouds": clouds,
                    "temperature": temperature
                }
                weathers.append(weather)
            res = requests.get('https://www.stok-narciarski.pl' + tmp)
            soup2 = BeautifulSoup(res.text, "html.parser")
            address = soup2.find('span', itemprop="streetAddress").text
            slope = {
                "name": name,
                "city": city,
                "address": address,
                "condition_min": condition_min,
                "condition_max": condition_max,
                "condition_equal": condition_equals,
                "update_time": update,
                "status": stat,
                "snow_fall": snow_fall,
                "weather": weathers
            }
            slopes.append(slope)
        except Exception as e:
            print(e)
            pass

    with open('slopes.json', 'w') as outfile:
        json.dump(slopes, outfile, indent=4)

    print('done')


@app.route('/')
@cache.memoize(timeout=10*60)
def update():
    threading.Thread(target=get_slope_condition, args=(), daemon=True).start()
    return ('', 204)




