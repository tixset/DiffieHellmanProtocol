use strict;
use warnings;
use IO::Socket;

my $host = '127.0.0.1';
my $port = 5555;

my $sharedKey;
my $privateKey;
my $publicKey;
my $KeyCipher;
my @data_arr;
my $recieved_data;

sub getRandInt{
    my ($min, $max) = (shift, shift);
    return $min + int(rand( $max - $min + 1 ));
}

my $socket = new IO::Socket::INET (LocalHost => $host, LocalPort => $port, Proto => 'tcp', Listen => 5, Reuse => 1);
die "Не могу открыть сокет!\n" unless $socket;

print "Сервер запущен\n";

while(1) {
    my $client_socket = $socket->accept();
    while (1){
        $client_socket->recv($recieved_data, 1024);
        @data_arr = split(':', $recieved_data);
        if ($recieved_data eq "GET_SHARED_KEY") {
            print "Клиент запрашивает общий ключ\n";
            $sharedKey = getRandInt(1000, 9999);
            print "Общий ключ сгенерирован: $sharedKey\n";
            print "Отправляю общий ключ: $sharedKey\n";
            $client_socket->send("SHARED_KEY:$sharedKey");
        }
        if ((defined $data_arr[0]) && ($data_arr[0] eq "PUBLIC_KEY")) {
            $publicKey = $data_arr[1];
            print "Публичный ключ клиента получен: $publicKey\n";
            $privateKey = getRandInt(1000, 9999);
            print "Приватный ключ сгенерирован: $privateKey\n";
            $KeyCipher = $publicKey + $privateKey;
            print "> Ключ шифрования посчитан: $KeyCipher\n";
            $publicKey = $sharedKey + $privateKey;
            print "Публичный ключ сервера посчитан: $publicKey\n";
            print "Отправляю публичный ключ: $publicKey\n";
            $client_socket->send("PUBLIC_KEY:$publicKey");
            print "Задача завершена!\n";
            last;
        }
    }
}
