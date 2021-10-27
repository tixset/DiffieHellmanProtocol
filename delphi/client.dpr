program client;

{$APPTYPE CONSOLE}

uses
  sysUtils, scktComp, dialogs, windows, classes;

type
  tMyClass = class(tObject)
    procedure clientSocket1Connect(sender: tObject; socket: tCustomWinSocket);
    procedure clientSocket1Error(sender: tObject; socket: tCustomWinSocket; errorEvent: tErrorEvent; var errorCode: integer);
    procedure clientSocketRead(Sender: tObject; socket: tCustomWinSocket);
  end;

const
  host = '127.0.0.1';
  port = 5555;

var
  myClass: tMyClass;
  clientSocket: tClientSocket;
  sharedKey, privateKey,clientPublicKey, serverPublicKey, keyCipher: integer;
  msg: tMsg;

procedure split(delimiter: char; str: string; listOfStrings: tStringList);
begin
  listOfStrings.Clear;
  ExtractStrings([delimiter], [], PChar(str), listOfStrings);
end;

function getRandInt(min: integer; max: integer): integer;
begin
  randomize;
  result := min + random(max - min + 1);
end;

procedure tMyClass.clientSocketRead(Sender: tObject; socket: tCustomWinSocket);
var
  recievedData: string;
  dataArr: tStringList;
begin
  recievedData := socket.ReceiveText;
  dataArr := tStringList.Create;
  split(':', recievedData, dataArr);
  if ((dataArr.Count > 1) and (dataArr[0] = 'SHARED_KEY')) then
  begin
    sharedKey := strToInt(dataArr[1]);
    writeLn('Общий ключ получен: ' + intToStr(sharedKey));
    privateKey := getRandInt(1000, 9999);
    writeLn('Приватный ключ сгенерирован: ' + intToStr(privateKey));
    clientPublicKey := sharedKey + privateKey;
    writeLn('Публичный ключ клиента посчитан: ' + intToStr(clientPublicKey));
	  writeLn('Отправляю публичный ключ: ' + intToStr(clientPublicKey));
    socket.SendText('PUBLIC_KEY:' + intToStr(clientPublicKey));
  end;
  if ((dataArr.Count > 1) and (dataArr[0] = 'PUBLIC_KEY')) then
  begin
    serverPublicKey := strToInt(dataArr[1]);
	  writeLn('Публичный ключ сервера получен: ' + intToStr(serverPublicKey));
    keyCipher := serverPublicKey + privateKey;
    writeLn('> Ключ шифрования посчитан: ' + intToStr(keyCipher));
    writeLn('Задача завершена!');;
	  clientSocket.Close;
    ExitProcess(0);
  end;
end;

procedure tMyClass.clientSocket1Connect(sender: tObject; socket: tCustomWinSocket);
begin
  writeLn('Клиент запущен');
  writeLn('Запрашиваю общий ключ');
  clientSocket.Socket.SendText('GET_SHARED_KEY');
end;

procedure tMyClass.clientSocket1Error(sender: tObject; socket: tCustomWinSocket; errorEvent: tErrorEvent; var errorCode: integer);
begin
  writeLn('Не могу подключиться к серверу!');
  ExitProcess(1);
end;

begin
  setConsoleCP(1251);
  setConsoleOutputCP(1251);
  clientSocket := tClientSocket.Create(nil);
  clientSocket.ClientType := ctNonBlocking;
  clientSocket.OnConnect := myClass.clientSocket1Connect;
  clientSocket.OnError := myClass.clientSocket1Error;
  clientSocket.OnRead := myClass.clientSocketRead;
  clientSocket.Host := host;
  clientSocket.Port := port;
  clientSocket.Open;
  while integer(getMessage(msg, 0, 0, 0)) <> 0 do
  begin
    translateMessage(msg);
    dispatchMessage(msg);
  end;
end.
