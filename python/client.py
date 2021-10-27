#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import socket
from random import randint

host = '127.0.0.1'
port = 5555

sharedKey = 0
privateKey = 0
clientPublicKey = 0
serverPublicKey = 0
keyCipher = 0

socket = socket.socket()
try:
    socket.connect((host, port))
except Exception:
    print "Не могу подключиться к серверу!"
    sys.exit(1)

print "Клиент запущен"
print "Запрашиваю общий ключ"
socket.send("GET_SHARED_KEY")

while True:
    recievedData = socket.recv(1024)
    dataArr = recievedData.split(':')
    if dataArr[0] == "SHARED_KEY":
        sharedKey = int(dataArr[1])
        print "Общий ключ получен: " + str(sharedKey)
        privateKey = randint(1000, 9999)
        print "Приватный ключ сгенерирован: " + str(privateKey)
        clientPublicKey = sharedKey + privateKey
        print "Публичный ключ клиента посчитан: " + str(clientPublicKey)
        print "Отправляю публичный ключ: " + str(clientPublicKey)
        socket.send("PUBLIC_KEY:" + str(clientPublicKey))
    if (dataArr[0]) and (dataArr[0] == "PUBLIC_KEY"):
        serverPublicKey = int(dataArr[1])
        print "Публичный ключ сервера получен: " + str(serverPublicKey)
        keyCipher = serverPublicKey + privateKey
        print "> Ключ шифрования посчитан: " + str(keyCipher)
        print "Задача завершена!"
	socket.close()
	sys.exit()
