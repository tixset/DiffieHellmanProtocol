#!/usr/bin/env python
# -*- coding: utf-8 -*-

import socket
from random import randint

host = '127.0.0.1'
port = 5555

sharedKey = 0
privateKey = 0
publicKey = 0
KeyCipher = 0

socket = socket.socket()
socket.connect((host, port))

print "Клиент запущен"
print "Запрашиваю общий ключ"
socket.send("GET_SHARED_KEY")
while True:
    recieved_data = socket.recv(1024)
    data_arr = recieved_data.split(':')
    if data_arr[0] == "SHARED_KEY":
        sharedKey = int(data_arr[1])
        print "Общий ключ получен: " + str(sharedKey)
        privateKey = randint(1111, 9999)
        print "Приватный ключ сгенерирован: " + str(privateKey)
        publicKey = sharedKey + privateKey
        print "Публичный ключ клиента посчитан: " + str(publicKey)
        print "Отправляю публичный ключ: " + str(publicKey)
        socket.send("PUBLIC_KEY:" + str(publicKey))
    if (data_arr[0]) and (data_arr[0] == "PUBLIC_KEY"):
        publicKey = int(data_arr[1])
        print "Публичный ключ сервера получен: " + str(publicKey)
        KeyCipher = publicKey + privateKey
        print "> Ключ шифрования посчитан: " + str(KeyCipher)
        print "Задача завершена!"
	socket.close()
	break
