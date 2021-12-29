unit MPF.Connections;
interface uses IdUdpClient, SysUtils
{$IFDEF MSWINDOWS} ,CiaComPort, Vcl.ExtCtrls {$ENDIF}, MPF.MAC, Classes,
  IdTCPClient;

//==============================================================================
type
  IConnection = interface['{1B0B63CB-7407-4B8B-961D-42B9589FCDC3}']
    procedure Send(const AData: TBytes);
    function Receive(const ACount: Integer): TBytes;
    procedure Purge;
    function Clone: IConnection;
    function GetReadTimeout: Integer;
    procedure SetReadTimeout(const ATimeout: Integer);

    property ReadTimeout: Integer read GetReadTimeout write SetReadTimeout;

  end;

//------------------------------------------------------------------------------
  INetworkConnection = interface(IConnection)['{0D603E35-6FD2-490A-B276-38C3228B0147}']
    function GetAddress: string;
    procedure SetAddress(const AAddress: string);
    function GetPort: Word;
    procedure SetPort(const APort: Word);

    property Address: string read GetAddress write SetAddress;
    property Port: Word read GetPort write SetPort;

  end;

//------------------------------------------------------------------------------
  IUDPConnection = interface(INetworkConnection)['{824BA484-456F-407B-A8F9-70A4F2DE25F6}']
  end;

//------------------------------------------------------------------------------
  ITCPConnection = interface(INetworkConnection)['{F2A27B45-BF65-4664-9273-5FD1F8EC7F6A}']
    procedure Connect;
    procedure Disconnect;
    function GetConnectTimeout: Integer;
    procedure SetConnectTimeout(const ATimeout: Integer);

    property ConnectTimeout: Integer read GetConnectTimeout write SetConnectTimeout;

  end;

//------------------------------------------------------------------------------
  ICOMConnection = interface(IConnection)['{E16ED835-E7C5-419C-8563-F3228D374336}']
    procedure Open;
    procedure Close;
    function IsOpened: Boolean;
    function GetPort: Byte;
    procedure SetPort(const APort: Byte);
    function GetBaudrate: Integer;
    procedure SetBaudrate(const ABaudrate: Integer);

    property Opened: Boolean read IsOpened;
    property Port: Byte read GetPort write SetPort;
    property Baudrate: Integer read GetBaudrate write SetBaudrate;

  end;

//------------------------------------------------------------------------------
  IMagicPacket = interface['{F3F96522-782A-48FE-93DF-EFCA91A8824E}']
    function GetData: TBytes;
    property Data: TBytes read GetData;
  end;

//==============================================================================
  TUDPConnection = class(TInterfacedObject, IConnection, INetworkConnection,
    IUDPConnection)
  strict private
    Connection: TIdUdpClient;
    RxBuffer: TBytes;

    function GetAddress: string;
    function GetPort: Word;
    function GetReadTimeout: Integer;
    procedure SetAddress(const AAddress: string);
    procedure SetPort(const APort: Word);
    procedure SetReadTimeout(const ATimeout: Integer);
    procedure Send(const AData: TBytes);
    function Receive(const ACount: Integer): TBytes;
    procedure Purge;
    function Clone: IConnection;

  public
    constructor Create; overload;
    constructor Create(AOwner: TComponent); overload;
    constructor Create(AOwner: TComponent; const AAddr: string; const APort: Word;
      const AReadTimeout: Integer = 2000); overload;
    constructor Create(const AAddr: string; const APort: Word;
      const AReadTimeout: Integer = 2000); overload;

    destructor Destroy; override;

  end;

//------------------------------------------------------------------------------
  TTCPConnection = class(TInterfacedObject, IConnection, INetworkConnection,
    ITCPConnection)
  strict private
    Connection: TIdTCPClient;
    Address: string;
    Port: Word;
    ReadTimeout: Integer;
    ConnectTimeout: Integer;

    procedure Connect;
    procedure Disconnect;
    function GetAddress: string;
    procedure SetAddress(const AAddr: string);
    function GetPort: Word;
    procedure SetPort(const APort: Word);
    function GetReadTimeout: Integer;
    procedure SetReadTimeout(const ATimeout: Integer);
    function GetConnectTimeout: Integer;
    procedure SetConnectTimeout(const ATimeout: Integer);
    procedure Send(const AData: TBytes);
    function Receive(const ACount: Integer): TBytes;
    procedure Purge;
    function Clone: IConnection;

  public
    constructor Create; overload;
    constructor Create(const AAddr: string; const APort: Word; const AReadTimeout: Integer = 2000); overload;
    destructor Destroy; override;

  end;

//------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}
  TCOMConnection = class(TInterfacedObject, ICOMConnection, IConnection)
  strict private
    Connection: TCiaComPort;
    BytesToReceive: Integer;
    RxData: TBytes;
    RxTimer: TTimer;
    Timeout: Boolean;

    procedure ConnectionDataAvailable(ASender: TObject);
    procedure RxTimeout(ASender: TObject);
    function GetPort: Byte;
    function GetBaudrate: Integer;
    function GetReadTimeout: Integer;
    procedure SetPort(const APort: Byte);
    procedure SetBaudrate(const ABaudrate: Integer);
    procedure SetReadTimeout(const ATimeout: Integer);
    procedure Send(const AData: TBytes);
    function Receive(const ACount: Integer): TBytes;
    procedure Purge;
    procedure Open;
    procedure Close;
    function IsOpened: Boolean;
    function ReadFromBuffer(const ACount: Integer): TBytes;
    procedure Wait(ATimer: TTimer);
    function Clone: IConnection;

  public
    constructor Create; overload;
    constructor Create(const APort: Byte; const ABaudrate: Integer;
      const AReadTimeout: Integer = 2000); overload;
    destructor Destroy; override;

  end;

{$ENDIF}

//==============================================================================
//  TConnections = class
//    class function NewUDP: IUDPConnection; overload;
//    class function NewUDP(AOwner: TComponent): IUDPConnection; overload;
//    class function NewUDP(const AAddr: string; const APort: Word;
//      const AReadTimeout: Integer = 2000): IUDPConnection; overload;
//    class function NewUDP(AOwner: TComponent; const AAddr: string; const APort: Word;
//      const AReadTimeout: Integer = 2000): IUDPConnection; overload;
//
//    class function NewTCP: ITCPConnection; overload;
//    class function NewTCP(const AAddr: string; const APort: Word;
//      const AReadTimeout: Integer = 2000): ITCPConnection; overload;
//
//{$IFDEF MSWINDOWS}
//    class function NewCOM: ICOMConnection; overload;
//    class function NewCOM(const APort: Byte; const ABaudrate: Integer;
//      const AReadTimeout: Integer = 2000): ICOMConnection; overload;
//{$ENDIF}
//
//  end;

//==============================================================================
function NewMagicPacket(AMAC: IMACAddress): IMagicPacket;

function NewUDP: IUDPConnection; overload;
function NewUDP(const AAddr: string; const APort: Word;
      const AReadTimeout: Integer = 2000): IUDPConnection; overload;

function NewTCP: ITCPConnection; overload;
function NewTCP(const AAddr: string; const APort: Word; const ATimeout: Integer = 2000):
  ITCPConnection; overload;

{$IFDEF MSWINDOWS}
function NewCOM: ICOMConnection; overload;
function NewCOM(const APort: Byte; const ABaudrate: Integer;
      const AReadTimeout: Integer = 2000): ICOMConnection; overload;
{$ENDIF}

//==============================================================================
implementation uses IdGlobal {$IFDEF MSWINDOWS}, Vcl.Forms {$ENDIF}, Spring.Container;

//==============================================================================
type
  TMagicPacket = class(TInterfacedObject, IMagicPacket)
  strict private
    Data: TBytes;
    function CreateData(AMAC: IMACAddress): TBytes;
    function GetData: TBytes;
  public
    constructor Create(AMAC: IMACAddress);
  end;

//==============================================================================
{ TUDPConnection }

constructor TUDPConnection.Create(AOwner: TComponent);
begin
  inherited Create;
  Connection := TIdUdpClient.Create(AOwner);
  Connection.ReceiveTimeout := 2000;
end;

//------------------------------------------------------------------------------
function TUDPConnection.Clone: IConnection;
begin
  Result := TUDPConnection.Create(Connection.Owner, GetAddress, GetPort, GetReadTimeout);
end;

//------------------------------------------------------------------------------
constructor TUDPConnection.Create(AOwner: TComponent; const AAddr: string; const APort: Word;
  const AReadTimeout: Integer = 2000);
begin
  Create(AOwner);
  Connection.Host := AAddr;
  Connection.Port := APort;
  Connection.ReceiveTimeout := AReadTimeout;
end;

//------------------------------------------------------------------------------
constructor TUDPConnection.Create(const AAddr: string; const APort: Word;
  const AReadTimeout: Integer);
begin
  Create;
  Connection.Host := AAddr;
  Connection.Port := APort;
  Connection.ReceiveTimeout := AReadTimeout;
end;

//------------------------------------------------------------------------------
constructor TUDPConnection.Create;
begin
  inherited;
  Connection := TIdUdpClient.Create;
  Connection.ReceiveTimeout := 2000;
end;

//------------------------------------------------------------------------------
destructor TUDPConnection.Destroy;
begin
  try Connection.Free; except end;
  inherited;
end;

//------------------------------------------------------------------------------
function TUDPConnection.GetAddress: string;
begin
  Result := Connection.Host;
end;

//------------------------------------------------------------------------------
function TUDPConnection.GetPort: Word;
begin
  Result := Connection.Port;
end;

//------------------------------------------------------------------------------
function TUDPConnection.GetReadTimeout: Integer;
begin
  Result := Connection.ReceiveTimeout;
end;

//------------------------------------------------------------------------------
procedure TUDPConnection.Purge;
var
  ALocalData: TBytes;
begin
  SetLength(ALocalData, Connection.BufferSize);
  Connection.ReceiveBuffer(TIdBytes(ALocalData), 0);
  RxBuffer := [];
end;

//------------------------------------------------------------------------------
function TUDPConnection.Receive(const ACount: Integer): TBytes;
var
  ALocalData: TBytes;
  ABytesReceived, i: Integer;

begin

  if Length(RxBuffer) < ACount then
  begin

    SetLength(ALocalData, Connection.BufferSize);
    ABytesReceived := Connection.ReceiveBuffer( TIdBytes(ALocalData) );
    SetLength(ALocalData, ABytesReceived);
    RxBuffer := RxBuffer + ALocalData;

  end;

  for i:=0 to ACount-1 do Result := Result + [RxBuffer[i]];
  Delete(RxBuffer, 0, ACount);


end;

//------------------------------------------------------------------------------
procedure TUDPConnection.Send(const AData: TBytes);
begin
  Connection.SendBuffer( TIdBytes(AData) );
end;

//------------------------------------------------------------------------------
procedure TUDPConnection.SetAddress(const AAddress: string);
begin
  Connection.Host := AAddress;
end;

//------------------------------------------------------------------------------
procedure TUDPConnection.SetPort(const APort: Word);
begin
  Connection.Port := APort;
end;

//------------------------------------------------------------------------------
procedure TUDPConnection.SetReadTimeout(const ATimeout: Integer);
begin
  Connection.ReceiveTimeout := ATimeout;
end;

//==============================================================================
{ TConnections }

//class function TConnections.NewUDP: IUDPConnection;
//begin
//  Result := TUDPConnection.Create;
//end;
//
////------------------------------------------------------------------------------
//class function TConnections.NewUDP(AOwner: TComponent): IUDPConnection;
//begin
//  Result := TUDPConnection.Create(AOwner);
//end;
//
////------------------------------------------------------------------------------
//class function TConnections.NewUDP(const AAddr: string; const APort: Word;
//  const AReadTimeout: Integer = 2000): IUDPConnection;
//begin
//  Result := TUDPConnection.Create(AAddr, APort, AReadTimeout);
//end;
//
////------------------------------------------------------------------------------
//class function TConnections.NewUDP(AOwner: TComponent; const AAddr: string;
//  const APort: Word; const AReadTimeout: Integer): IUDPConnection;
//begin
//  Result := TUDPConnection.Create(AOwner, AAddr, APort, AReadTimeout);
//end;
//
////------------------------------------------------------------------------------
//class function TConnections.NewTCP(const AAddr: string; const APort: Word;
//  const AReadTimeout: Integer): ITCPConnection;
//begin
//  Result := TTCPConnection.Create(AAddr, APort, AReadTimeout);
//end;
//
////------------------------------------------------------------------------------
//class function TConnections.NewTCP: ITCPConnection;
//begin
//  Result := TTCPConnection.Create;
//end;
//
////------------------------------------------------------------------------------
//{$IFDEF MSWINDOWS}
//
//class function TConnections.NewCOM: ICOMConnection;
//begin
//  Result := TCOMConnection.Create;
//end;
//
//
//class function TConnections.NewCOM(const APort: Byte; const ABaudrate,
//  AReadTimeout: Integer): ICOMConnection;
//begin
//  Result := TCOMConnection.Create(APort, ABaudrate, AReadTimeout);
//end;
//
//
//
//{$ENDIF}

//==============================================================================
{ TCOMConnection }
{$IFDEF MSWINDOWS}

function TCOMConnection.Clone: IConnection;
begin
  Result := TCOMConnection.Create(GetPort, GetBaudrate, GetReadTimeout);
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.Close;
begin
  Purge;
  Connection.Open := false;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.ConnectionDataAvailable(ASender: TObject);
var
  AData: TBytes;

begin
  SetLength(AData, Connection.RxCount);
  Connection.Receive(AData, Connection.RxCount);
  RxData := RxData + AData;

  if Length(RxData) >= BytesToReceive then RxTimer.Enabled := false;

end;

//------------------------------------------------------------------------------
constructor TCOMConnection.Create(const APort: Byte; const ABaudrate,
  AReadTimeout: Integer);
begin
  Create;
  Connection.Port := APort;
  Connection.Baudrate := ABaudrate;
  RxTimer.Interval := AReadTimeout;
end;

//------------------------------------------------------------------------------
destructor TCOMConnection.Destroy;
begin
  RxTimer.Free;
  Connection.Free;
  inherited;
end;

//------------------------------------------------------------------------------
constructor TCOMConnection.Create;
begin
  inherited;
  Connection := TCiaComPort.Create(nil);
  Connection.OnDataAvailable := ConnectionDataAvailable;
  RxTimer := TTimer.Create(nil);
  RxTimer.Enabled := false;
  RxTimer.OnTimer := RxTimeout;
  RxTimer.Interval := 2000;
end;

//------------------------------------------------------------------------------
function TCOMConnection.GetBaudrate: Integer;
begin
  Result := Connection.Baudrate;
end;

//------------------------------------------------------------------------------
function TCOMConnection.GetPort: Byte;
begin
  Result := Connection.Port;
end;

//------------------------------------------------------------------------------
function TCOMConnection.GetReadTimeout: Integer;
begin
  Result := Connection.RxTimeout;
end;

//------------------------------------------------------------------------------
function TCOMConnection.IsOpened: Boolean;
begin
  Result := Connection.Open;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.Open;
begin
  Connection.Open := true;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.Purge;
begin
  Connection.PurgeRx;
  Connection.PurgeTx;
  RxData := [];
end;

//------------------------------------------------------------------------------
function TCOMConnection.ReadFromBuffer(const ACount: Integer): TBytes;
var
  i: Integer;
begin
  Result := [];
  for i:=0 to ACount-1 do Result := Result + [RxData[i]];
  Delete(RxData, 0, ACount);
end;

//------------------------------------------------------------------------------
function TCOMConnection.Receive(const ACount: Integer): TBytes;
begin
  if not IsOpened then
    raise Exception.Create('Port not opened.');

  if Length(RxData) >= ACount then
    Result := ReadFromBuffer(ACount)
  else begin
    BytesToReceive := ACount;
    Timeout := false;
    RxTimer.Enabled := true;
    Wait(RxTimer);
    if not Timeout then
      Result := ReadFromBuffer(ACount)
    else
      raise Exception.Create('Timeout error.');
  end;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.RxTimeout(ASender: TObject);
begin
  RxTimer.Enabled := false;
  Timeout := true;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.Send(const AData: TBytes);
begin
  Connection.Send(AData, Length(AData));
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.SetBaudrate(const ABaudrate: Integer);
begin
  Connection.Baudrate := ABaudrate;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.SetPort(const APort: Byte);
begin
  Connection.Port := APort;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.SetReadTimeout(const ATimeout: Integer);
begin
  RxTimer.Interval := ATimeout;
end;

//------------------------------------------------------------------------------
procedure TCOMConnection.Wait(ATimer: TTimer);
begin
  while ATimer.Enabled do Application.ProcessMessages;
end;

{$ENDIF}
//==============================================================================
{ TMagicPacket }

constructor TMagicPacket.Create(AMAC: IMACAddress);
begin
  inherited Create;
  Data := CreateData(AMAC);
end;

//------------------------------------------------------------------------------
function TMagicPacket.CreateData(AMAC: IMACAddress): TBytes;
var
  i: Integer;

begin
  Result := [];

  for i:=0 to 5 do Result := Result + [$FF];
  for i:=0 to 15 do Result := Result + AMAC.Data;

end;

//------------------------------------------------------------------------------
function TMagicPacket.GetData: TBytes;
begin
  Result := Data;
end;

//==============================================================================
{ TTCPConnection }

function TTCPConnection.Clone: IConnection;
var
  ANewConnection: ITCPConnection;
begin
  ANewConnection := TTCPConnection.Create(GetAddress, GetPort, GetReadTimeout);
  ANewConnection.ConnectTimeout := GetConnectTimeout;
  Result := ANewConnection;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.Connect;
begin
  if Assigned(Connection) then
    Disconnect;

  if not Assigned(Connection) then begin
    Connection := TIdTcpClient.Create;
    Connection.Host := Address;
    Connection.Port := Port;
    Connection.ReadTimeout := ReadTimeout;
    Connection.ConnectTimeout := ConnectTimeout;
  end;

  Connection.Connect;

end;

//------------------------------------------------------------------------------
constructor TTCPConnection.Create(const AAddr: string; const APort: Word;
  const AReadTimeout: Integer = 2000);
begin
  Create;
  SetAddress(AAddr);
  SetPort(APort);
  SetReadTimeout(AReadTimeout);
end;

//------------------------------------------------------------------------------
constructor TTCPConnection.Create;
begin
  inherited;
//  Connection := TIdTCPClient.Create;
  ConnectTimeout := 2000;
  ReadTimeout := 2000;
end;

//------------------------------------------------------------------------------
destructor TTCPConnection.Destroy;
begin
  if Assigned(Connection) then Connection.Free;
  inherited;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.Disconnect;
begin
  if Assigned(Connection) then begin
    Connection.Disconnect;
    FreeAndNil(Connection);
  end;
end;

//------------------------------------------------------------------------------
function TTCPConnection.GetAddress: string;
begin
  Result := Address;
end;

//------------------------------------------------------------------------------
function TTCPConnection.GetConnectTimeout: Integer;
begin
  Result := ConnectTimeout;
end;

//------------------------------------------------------------------------------
function TTCPConnection.GetPort: Word;
begin
  Result := Port;
end;

//------------------------------------------------------------------------------
function TTCPConnection.GetReadTimeout: Integer;
begin
  Result := ReadTimeout;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.Purge;
begin
  Connection.IOHandler.InputBuffer.Clear;
end;

//------------------------------------------------------------------------------
function TTCPConnection.Receive(const ACount: Integer): TBytes;
begin
  if Assigned(Connection) then
    Connection.IOHandler.ReadBytes(TIdBytes(Result), ACount)
  else
    raise Exception.Create('Not connected.');
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.Send(const AData: TBytes);
begin
  if Assigned(Connection) then
    Connection.IOHandler.Write(TIdBytes(AData))
  else
    raise Exception.Create('Not connected.');
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.SetAddress(const AAddr: string);
begin
  Address := AAddr;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.SetConnectTimeout(const ATimeout: Integer);
begin
  ConnectTimeout := ATimeout;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.SetPort(const APort: Word);
begin
  Port := APort;
end;

//------------------------------------------------------------------------------
procedure TTCPConnection.SetReadTimeout(const ATimeout: Integer);
begin
  ReadTimeout := ATimeout;
end;

//==============================================================================
function NewMagicPacket(AMAC: IMACAddress): IMagicPacket;
begin
  Result := TMagicPacket.Create(AMAC);
end;

//------------------------------------------------------------------------------
function NewUDP: IUDPConnection;
begin
  Result := TUDPConnection.Create;
end;

//------------------------------------------------------------------------------
function NewUDP(const AAddr: string; const APort: Word; const AReadTimeout: Integer = 2000):
  IUDPConnection; overload;
begin
  Result := TUDPConnection.Create(AAddr, APort, AReadTimeout);
end;

//------------------------------------------------------------------------------
function NewTCP: ITCPConnection;
begin
  Result := TTCPConnection.Create;
end;

//------------------------------------------------------------------------------
function NewTCP(const AAddr: string; const APort: Word; const ATimeout: Integer = 2000):
  ITCPConnection;
begin
  Result := TTcpConnection.Create(AAddr, APort, ATimeout);
  Result.ConnectTimeout := ATimeout;
end;

//------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}

function NewCOM: ICOMConnection;
begin
  Result := TCOMConnection.Create;
end;

//------------------------------------------------------------------------------
function NewCOM(const APort: Byte; const ABaudrate: Integer;
      const AReadTimeout: Integer = 2000): ICOMConnection;
begin
  Result := TCOMConnection.Create(APort, ABaudrate, AReadTimeout);
end;

{$ENDIF}
//==============================================================================
initialization
  GlobalContainer.RegisterType<TUdpConnection>.
    Implements<IUdpConnection>.
    Implements<INetworkConnection>('MPF UDP Connection');

  GlobalContainer.RegisterType<TTCPConnection>.
    Implements<ITCPConnection>.
    Implements<INetworkConnection>('MPF TCP Connection');


end.
