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

sock = socket.socket()
sock.bind((host, port))
sock.listen(1)

print "Сервер запущен"

while True:
    client_socket, addr = sock.accept()
    while True:
        recieved_data = client_socket.recv(1024)
        if not recieved_data:
            break
        data_arr = recieved_data.split(':')
        if recieved_data == "GET_SHARED_KEY":
            print "Клиент запрашивает общий ключ"
            sharedKey = randint(1111, 9999)
            print "Общий ключ сгенерирован: " + str(sharedKey)
            print "Отправляю общий ключ: " + str(sharedKey)
            client_socket.send("SHARED_KEY:" + str(sharedKey))
        if (data_arr[0]) and (data_arr[0] == "PUBLIC_KEY"):
            publicKey = int(data_arr[1])
            print "Публичный ключ клиента получен: " + str(publicKey)
            privateKey = randint(1111, 9999);
            print "Приватный ключ сгенерирован: " + str(privateKey)
            KeyCipher = publicKey + privateKey
            print "> Ключ шифрования посчитан: " + str(KeyCipher)
            publicKey = sharedKey + privateKey
            print "Публичный ключ сервера посчитан: " + str(publicKey)
            print "Отправляю публичный ключ: " + str(publicKey)
            client_socket.send("PUBLIC_KEY:" + str(publicKey))
            print "Задача завершена!"
            break
conn.close()
