from bs4 import BeautifulSoup
import requests
import json
import unicodedata

response = requests.get('https://www.stok-narciarski.pl/warunki-narciarskie')
slopes = []
content = response.text
soup = BeautifulSoup(content, "html.parser")
for a in soup.findAll('div', class_='row slope-row slope-row-data'):
    try:
        name = a.find('h4', class_='slope-row-name').a.text
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
        tmp = unicodedata.normalize('NFD', name).replace('ł', 'l').encode('ascii', 'ignore').decode("utf-8")
        res = requests.get('https://www.stok-narciarski.pl/' + tmp.lower().replace(' ', '-').replace('---', '-'))
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

