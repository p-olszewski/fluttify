from bs4 import BeautifulSoup
import requests
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime

COLLECTION_NAME = u'products'
FIREABASE_ADMIN_PRIVATE_KEY_FILE = ''


def firestore_auth():
	try:
		cred = credentials.Certificate(FIREABASE_ADMIN_PRIVATE_KEY_FILE)
		app = firebase_admin.initialize_app(cred)
		db = firestore.client()
		return db
	except FileNotFoundError:
		print("Firebase Admin SDK private key file not found.")
		exit()


def get_products(db):
	url = "https://selgros24.pl/artykuly-spozywcze-pc1160.html?maxDisplay=120&orderBy=nameA"
	try:
		soup = get_html(url)
	except requests.exceptions.ConnectionError as e:
		print(e)
		exit()

	max_index = int(
		soup.find("div", class_="itemsPaggingHeader").find("li", page="page", class_=False).find("span").text)
	for i in range(1, max_index):
		url = f"https://selgros24.pl/artykuly-spozywcze-pc1160.html?maxDisplay=120&orderBy=nameA&pageNo={i}"
		try:
			soup = get_html(url)
		except requests.exceptions.ConnectionError as e:
			print(e)
			break

		temp = soup.find("div", class_="gridView")

		for x in temp.find_all("article"):
			name = x.find("img")["title"]
			name = name.replace('/', ' ')
			price = float(x.find("div", class_="actual-price").text)
			date = datetime.datetime.now()
			data = {"name": name, "price": price, "updated": date}
			db.collection(COLLECTION_NAME).document(name).set(data)


def get_html(url):
	request = requests.get(url)
	if request.status_code == 404:
		print("URL returned 404")
		exit()
	soup = BeautifulSoup(request.content, "html.parser")
	return soup


def main():
	db = firestore_auth()
	get_products(db)


if __name__ == "__main__":
	main()
