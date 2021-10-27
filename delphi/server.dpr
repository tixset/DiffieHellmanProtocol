program server;

{$APPTYPE CONSOLE}

uses
  sysUtils, scktComp, dialogs, windows, classes;

type
  tMyClass = class(tObject)
    procedure serverSocketClientRead(sender: tObject; socket: tCustomWinSocket);
  end;

const
  port = 5555;

var
  myClass: tMyClass;
  serverSocket: tServerSocket;
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

procedure tMyClass.serverSocketClientRead(sender: tObject; socket: tCustomWinSocket);
var
  recievedData: string;
  dataArr: tStringList;
begin
  recievedData := socket.ReceiveText;
  writeLn(recievedData);
  dataArr := tStringList.Create;
  split(':', recievedData, dataArr);
  if (recievedData = 'GET_SHARED_KEY') then
  begin
    writeLn('Клиент запрашивает общий ключ');
    sharedKey := getRandInt(1111, 9999);
    writeLn('Общий ключ сгенерирован: ' + intToStr(sharedKey));
    writeLn('Отправляю общий ключ: ' + intToStr(sharedKey));
    socket.SendText('SHARED_KEY:' + intToStr(sharedKey));
  end;
  if ((dataArr.Count > 1) and (dataArr[0] = 'PUBLIC_KEY')) then
  begin
    clientPublicKey := strToInt(dataArr[1]);
    writeLn('Публичный ключ клиента получен: ' + intToStr(clientPublicKey));
    privateKey := getRandInt(1000, 9999);
    writeLn('Приватный ключ сгенерирован: ' + intToStr(privateKey));
    keyCipher := clientPublicKey + privateKey;
    writeLn('> Ключ шифрования посчитан: ' + intToStr(keyCipher));
    serverPublicKey := sharedKey + privateKey;
    writeLn('Публичный ключ сервера посчитан: ' + intToStr(serverPublicKey));
    writeLn('Отправляю публичный ключ: ' + intToStr(serverPublicKey));
    socket.SendText('PUBLIC_KEY: ' + intToStr(serverPublicKey));
    writeLn('Задача завершена!');
  end;
end;

begin
  setConsoleCP(1251);
  setConsoleOutputCP(1251);
  serverSocket := tServerSocket.Create(nil);
  serverSocket.ServerType := stNonBlocking;
  serverSocket.OnClientRead := myClass.serverSocketClientRead;
  serverSocket.Port := port;
  Try
    serverSocket.Open;
  except
    showMessage('Не могу открыть сокет!');
  end;
  writeLn('Сервер запущен');
  while integer(getMessage(msg, 0, 0, 0)) <> 0 do
  begin
    translateMessage(msg);
    dispatchMessage(msg);
  end;
end.

