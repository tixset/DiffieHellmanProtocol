use strict;
use warnings;
use IO::Socket;

my $host = '127.0.0.1';
my $port = 5555;

my $sharedKey;
my $privateKey;
my $clientPublicKey;
my $serverPublicKey;
my $keyCipher;
my @dataArr;
my $recievedData;

sub getRandInt{
    my ($min, $max) = (shift, shift);
    return $min + int(rand( $max - $min + 1 ));
}

my $socket = new IO::Socket::INET (LocalHost => $host, LocalPort => $port, Proto => 'tcp', Listen => 5, Reuse => 1);
die "Не могу открыть сокет!\n" unless $socket;

print "Сервер запущен\n";

while(1) {
    my $clientSocket = $socket->accept();
    while (1){
        $clientSocket->recv($recievedData, 1024);
        @dataArr = split(':', $recievedData);
        if ($recievedData eq "GET_SHARED_KEY") {
            print "Клиент запрашивает общий ключ\n";
            $sharedKey = getRandInt(1000, 9999);
            print "Общий ключ сгенерирован: $sharedKey\n";
            print "Отправляю общий ключ: $sharedKey\n";
            $clientSocket->send("SHARED_KEY:$sharedKey");
        }
        if ((defined $dataArr[0]) && ($dataArr[0] eq "PUBLIC_KEY")) {
            $clientPublicKey = $dataArr[1];
            print "Публичный ключ клиента получен: $clientPublicKey\n";
            $privateKey = getRandInt(1000, 9999);
            print "Приватный ключ сгенерирован: $privateKey\n";
            $keyCipher = $clientPublicKey + $privateKey;
            print "> Ключ шифрования посчитан: $keyCipher\n";
            $serverPublicKey = $sharedKey + $privateKey;
            print "Публичный ключ сервера посчитан: $serverPublicKey\n";
            print "Отправляю публичный ключ: $serverPublicKey\n";
            $clientSocket->send("PUBLIC_KEY:$serverPublicKey");
            print "Задача завершена!\n";
            last;
        }
    }
}
