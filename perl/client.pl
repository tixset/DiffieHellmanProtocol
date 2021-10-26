use strict;
use warnings;
use IO::Socket;

my $host = '127.0.0.1';
my $port = '5555';

my $sharedKey;
my $privateKey;
my $publicKey;
my $KeyCipher;
my @data_arr;
my $recv_data;

sub getRandInt{
  my ($min, $max) = (shift, shift);
  return $min + int(rand( $max - $min + 1 ));
}

my $socket = new IO::Socket::INET (PeerAddr => $host, PeerPort => $port, Proto => 'tcp');
die "Не могу открыть сокет!\n" unless $socket;

print "Клиент запущен\n";
print "Запрашиваю общий ключ\n";
$socket->send("GET_SHARED_KEY");

while (1) {
    $socket->recv($recv_data, 1024);
    @data_arr = split(':', $recv_data);
    if ($data_arr[0] eq "SHARED_KEY") {
        $sharedKey = $data_arr[1];
        print "Общий ключ получен: $sharedKey\n";
        $privateKey = getRandInt(1111, 9999);
        print "Приватный ключ сгенерирован: $privateKey\n";
        $publicKey = $sharedKey + $privateKey;
        print "Публичный ключ клиента посчитан: $publicKey\n";
	print "Отправляю публичный ключ: $publicKey\n";
        $socket->send("PUBLIC_KEY:$publicKey");
    }
    if ((defined $data_arr[0]) && ($data_arr[0] eq "PUBLIC_KEY")) {
        $publicKey = $data_arr[1];
	print "Публичный ключ сервера получен: $publicKey\n";
        $KeyCipher = $publicKey + $privateKey;
        print "> Ключ шифрования посчитан: $KeyCipher\n";
        print "Задача завершена!\n";
	close($socket);
        exit;
    }
}
