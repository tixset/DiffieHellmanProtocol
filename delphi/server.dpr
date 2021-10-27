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
  dataArr := tStringList.Create;
  split(':', recievedData, dataArr);
  if (recievedData = 'GET_SHARED_KEY') then
  begin
    writeLn('Êëèåíò çàïðàøèâàåò îáùèé êëþ÷');
    sharedKey := getRandInt(1111, 9999);
    writeLn('Îáùèé êëþ÷ ñãåíåðèðîâàí: ' + intToStr(sharedKey));
    writeLn('Îòïðàâëÿþ îáùèé êëþ÷: ' + intToStr(sharedKey));
    socket.SendText('SHARED_KEY:' + intToStr(sharedKey));
  end;
  if ((dataArr.Count > 1) and (dataArr[0] = 'PUBLIC_KEY')) then
  begin
    clientPublicKey := strToInt(dataArr[1]);
    writeLn('Ïóáëè÷íûé êëþ÷ êëèåíòà ïîëó÷åí: ' + intToStr(clientPublicKey));
    privateKey := getRandInt(1000, 9999);
    writeLn('Ïðèâàòíûé êëþ÷ ñãåíåðèðîâàí: ' + intToStr(privateKey));
    keyCipher := clientPublicKey + privateKey;
    writeLn('> Êëþ÷ øèôðîâàíèÿ ïîñ÷èòàí: ' + intToStr(keyCipher));
    serverPublicKey := sharedKey + privateKey;
    writeLn('Ïóáëè÷íûé êëþ÷ ñåðâåðà ïîñ÷èòàí: ' + intToStr(serverPublicKey));
    writeLn('Îòïðàâëÿþ ïóáëè÷íûé êëþ÷: ' + intToStr(serverPublicKey));
    socket.SendText('PUBLIC_KEY: ' + intToStr(serverPublicKey));
    writeLn('Çàäà÷à çàâåðøåíà!');
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
    showMessage('Íå ìîãó îòêðûòü ñîêåò!');
  end;
  writeLn('Ñåðâåð çàïóùåí');
  while integer(getMessage(msg, 0, 0, 0)) <> 0 do
  begin
    translateMessage(msg);
    dispatchMessage(msg);
  end;
end.

