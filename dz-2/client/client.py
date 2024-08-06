import urllib.request

page = urllib.request.urlopen("http://localhost:5000")

encodedContent = page.read()
decodedContent = encodedContent.decode("utf8")

print(decodedContent)

page.close()
