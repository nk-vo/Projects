from urllib.request import urlopen
import re
url = "http://olympus.realpython.org/profiles/poseidon"
page = urlopen(url)
html = page.read().decode("utf-8")

title_index = html.find("<title>")
print("title_index\n", title_index)

start_index = title_index + len("<title>")
print("start_index\n", start_index)

end_index = html.find("</title>")
print("end_index\n", end_index)

title = html[start_index:end_index]
print(title)