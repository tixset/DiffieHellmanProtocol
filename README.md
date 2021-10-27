# Пример работы протокола Диффи — Хеллмана на нескольких ЯП
*Протокол Диффи-Хеллмана — это криптографический протокол, позволяющий двум и более сторонам получить общий секретный ключ, используя незащищенный от прослушивания канал связи. Полученный ключ используется для шифрования дальнейшего обмена с помощью алгоритмов симметричного шифрования.*

Работу данного алгоритма продемонстрирую на примере сокетов.

Последовательность действий алгоритма довольно проста, поэтому не буду тут приводить пример на алгоритмическом языке, а просто опишу эту последовательность в виде списка.

1. Клиент запрашивает общий ключ у сервера
2. Сервер:
* Генерирует общий ключ
* Отправляет общий ключ клиенту
3. Клиент: 
* Принимает общий ключ
* Генерирует приватный ключ
* Выполняет между двумя ключами (между общим и приватным) математическую операцию (вычисляет публичный ключ)
* Отправляет публичный ключ серверу
4. Сервер:
* Получает публичный ключ клиента
* Выполняет между двумя ключами (между публичным и приватным) математическую операцию (**вычисляет ключ шифрования**)
* Генерирует приватный
* Выполняет между двумя ключами (между общим и приватным) математическую операцию (вычисляет публичный ключ)
* Отправляет публичный ключ клиенту
5. Клиент:
* Получает публичный ключ сервера
* Выполняет между двумя ключами (между публичным и приватным) математическую операцию (**вычисляет ключ шифрования**)

Из этой последовательности действий понятно, что и клиент и сервер по сути по очереди выполняют одно и то же действие.

*Для наглядности демонстрации алгоритма в качестве математической операции вместо деления по модулю я использовал банальную операцию сложения.*

Пример алгоритма привожу на трех языках:
* perl
* python
* delphi

Вывод в консоль серверной части программы выглядит так:

![server](https://github.com/tixset/DiffieHellmanProtocol/blob/main/screenshots/server_ru.png)

Вывод в консоль клиентской части программы выглядит так:

![client](https://github.com/tixset/DiffieHellmanProtocol/blob/main/screenshots/client_ru.png)


---

# An example of the Diffie - Hellman protocol working on several programming languages
*The Diffie-Hellman Protocol is a cryptographic protocol that allows two or more parties to obtain a shared secret key using an unsecured communication channel. The received key is used to encrypt further exchange using symmetric encryption algorithms.*

I will demonstrate the work of this algorithm using the example of sockets.

The sequence of actions of the algorithm is quite simple, so I will not give an example in algorithmic language here, but simply describe this sequence in the form of a list.

1. The client requests a shared key from the server
2. Server:
* Generates a shared key
* Sends the shared key to the client
3. Client:
* Accepts a shared key
* Generates a private key
* Performs a mathematical operation between two keys (between public and private) (calculates the public key)
* Sends the public key to the server
4. Server:
* Receives the client's public key
* Performs a mathematical operation between two keys (between public and private) (**calculates the encryption key**)
* Generates a private
* Performs a mathematical operation between two keys (between public and private) (calculates the public key)
* Sends the public key to the client
5. Customer:
* Gets the server's public key
* Performs a mathematical operation between two keys (between public and private) (**calculates the encryption key**)

From this sequence of actions, it is clear that both the client and the server, in fact, take turns performing the same action.

*For the sake of illustrating the algorithm as a mathematical operation, instead of dividing modulo, I used the banal addition operation.*

I give an example of the algorithm in three languages:
* perl
* python
* delphi

The output to the console of the server part of the program looks like this:

![server](https://github.com/tixset/DiffieHellmanProtocol/blob/main/screenshots/server_en.png)

The output to the console of the client part of the program looks like this:

![client](https://github.com/tixset/DiffieHellmanProtocol/blob/main/screenshots/client_en.png)
