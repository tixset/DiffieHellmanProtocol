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
my $recvData;

sub getRandInt{
    my ($min, $max) = (shift, shift);
    return $min + int(rand( $max - $min + 1 ));
}

my $socket = new IO::Socket::INET (PeerAddr => $host, PeerPort => $port, Proto => 'tcp');
die "Не могу подключиться к серверу!\n" unless $socket;

print "Клиент запущен\n";
print "Запрашиваю общий ключ\n";
$socket->send("GET_SHARED_KEY");

while (1) {
    $socket->recv($recvData, 1024);
    @dataArr = split(':', $recvData);
    if ($dataArr[0] eq "SHARED_KEY") {
        $sharedKey = $dataArr[1];
        print "Общий ключ получен: $sharedKey\n";
        $privateKey = getRandInt(1000, 9999);
        print "Приватный ключ сгенерирован: $privateKey\n";
        $clientPublicKey = $sharedKey + $privateKey;
        print "Публичный ключ клиента посчитан: $clientPublicKey\n";
	print "Отправляю публичный ключ: $clientPublicKey\n";
        $socket->send("PUBLIC_KEY:$clientPublicKey");
    }
    if ((defined $dataArr[0]) && ($dataArr[0] eq "PUBLIC_KEY")) {
        $serverPublicKey = $dataArr[1];
	print "Публичный ключ сервера получен: $serverPublicKey\n";
        $keyCipher = $serverPublicKey + $privateKey;
        print "> Ключ шифрования посчитан: $keyCipher\n";
        print "Задача завершена!\n";
	close($socket);
        exit;
    }
}
