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

sock = socket.socket()
try:
    sock.bind((host, port))
except Exception:
    print "Не могу открыть сокет!"
    sys.exit(1)
sock.listen(1)

print "Сервер запущен"

while True:
    clientSocket, addr = sock.accept()
    while True:
        recievedData = clientSocket.recv(1024)
        if not recievedData:
            break
        dataArr = recievedData.split(':')
        if recievedData == "GET_SHARED_KEY":
            print "Клиент запрашивает общий ключ"
            sharedKey = randint(1000, 9999)
            print "Общий ключ сгенерирован: " + str(sharedKey)
            print "Отправляю общий ключ: " + str(sharedKey)
            clientSocket.send("SHARED_KEY:" + str(sharedKey))
        if (dataArr[0]) and (dataArr[0] == "PUBLIC_KEY"):
            clientPublicKey = int(dataArr[1])
            print "Публичный ключ клиента получен: " + str(clientPublicKey)
            privateKey = randint(1000, 9999);
            print "Приватный ключ сгенерирован: " + str(privateKey)
            keyCipher = clientPublicKey + privateKey
            print "> Ключ шифрования посчитан: " + str(keyCipher)
            serverPublicKey = sharedKey + privateKey
            print "Публичный ключ сервера посчитан: " + str(serverPublicKey)
            print "Отправляю публичный ключ: " + str(serverPublicKey)
            clientSocket.send("PUBLIC_KEY:" + str(serverPublicKey))
            print "Задача завершена!"
            break
