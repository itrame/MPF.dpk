unit MPF.Connections;
interface uses IdUdpClient, SysUtils
{$IFDEF MSWINDOWS} ,CiaComPort, Vcl.ExtCtrls {$ENDIF}, MPF.MAC;

//==============================================================================
type
  IConnectionObject = interface['{2A53264C-60A2-4678-B4FF-909339A5BF31}']
  end;

//------------------------------------------------------------------------------
  IConnectionInfo = interface(IConnectionObject)['{2981AC84-4613-4E71-B297-F9915AAC0432}']
    function GetReadTimeout: Integer;
    property ReadTimeout: Integer read GetReadTimeout;
  end;

//------------------------------------------------------------------------------
  IConfigurableConnection = interface(IConnectionInfo)['{23A62567-07B4-4778-A322-85F1C82BD818}']
    procedure SetReadTimeout(const ATimeout: Integer);
    property ReadTimeout: Integer read GetReadTimeout write SetReadTimeout;
  end;

//------------------------------------------------------------------------------
  IIPConnectionInfo = interface(IConnectionInfo)['{FAC85938-2524-4FDC-B318-EFF7A101EE88}']
    function GetAddress: string;
    function GetPort: Word;

    property Address: string read GetAddress;
    property Port: Word read GetPort;

  end;

//------------------------------------------------------------------------------
  IConfigurableIPConnection = interface(IConfigurableConnection)['{0D603E35-6FD2-490A-B276-38C3228B0147}']
    function GetAddress: string;
    procedure SetAddress(const AAddress: string);
    function GetPort: Word;
    procedure SetPort(const APort: Word);

    property Address: string read GetAddress write SetAddress;
    property Port: Word read GetPort write SetPort;

  end;

//------------------------------------------------------------------------------
  ICOMConnectionInfo = interface(IConnectionInfo)['{DDED98A6-D950-4260-947E-B12CC6119971}']
    function GetPort: Byte;
    function GetBaudrate: Integer;

    property Port: Byte read GetPort;
    property Baudrate: Integer read GetBaudrate;

  end;

//------------------------------------------------------------------------------
  IConfigurableCOMConnection = interface(IConfigurableConnection)['{BE1F71CF-FFA2-4427-9F96-F6B0E6E9DE8A}']
    function GetPort: Byte;
    procedure SetPort(const APort: Byte);
    function GetBaudrate: Integer;
    procedure SetBaudrate(const ABaudrate: Integer);

    property Port: Byte read GetPort write SetPort;
    property Baudrate: Integer read GetBaudrate write SetBaudrate;

  end;

//------------------------------------------------------------------------------
  IConnection = interface(IConnectionObject)['{1B0B63CB-7407-4B8B-961D-42B9589FCDC3}']
    procedure Send(const AData: TBytes);
    function Receive(const ACount: Integer): TBytes;
    procedure Purge;
  end;

//------------------------------------------------------------------------------
  ICOMConnection = interface(IConnection)['{E16ED835-E7C5-419C-8563-F3228D374336}']
    procedure Open;
    procedure Close;
    function IsOpened: Boolean;
    property Opened: Boolean read IsOpened;
  end;

//------------------------------------------------------------------------------
  IMagicPacket = interface['{F3F96522-782A-48FE-93DF-EFCA91A8824E}']
    function GetData: TBytes;
    property Data: TBytes read GetData;
  end;

//==============================================================================
  TUDPConnection = class(TInterfacedObject, IConnection, IConfigurableIPConnection,
    IConnectionObject, IIPConnectionInfo)
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

  public
    constructor Create; overload;
    constructor Create(const AAddr: string; const APort: Word;
      const AReadTimeout: Integer = 2000); overload;

    destructor Destroy; override;

  end;

//------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}
  TCOMConnection = class(TInterfacedObject, ICOMConnection, IConfigurableCOMConnection,
    ICOMConnectionInfo, IConnectionObject)

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

  public
    constructor Create; overload;
    constructor Create(const APort: Byte; const ABaudrate: Integer;
      const AReadTimeout: Integer = 2000); overload;
    destructor Destroy; override;

  end;

{$ENDIF}

//==============================================================================
  TConnections = class
    class function NewUDP: TUDPConnection; overload;
    class function NewUDP(const AAddr: string; const APort: Word;
      const AReadTimeout: Integer = 2000): TUDPConnection; overload;

{$IFDEF MSWINDOWS}
    class function NewCOM(const APort: Byte; const ABaudrate: Integer;
      const AReadTimeout: Integer = 2000): TCOMConnection; overload;
{$ENDIF}

  end;

//==============================================================================
function NewMagicPacket(AMAC: IMACAddress): IMagicPacket;


//==============================================================================
implementation uses IdGlobal {$IFDEF MSWINDOWS}, Vcl.Forms {$ENDIF};

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

constructor TUDPConnection.Create;
begin
  inherited;
  Connection := TIdUdpClient.Create;
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
destructor TUDPConnection.Destroy;
begin
  Connection.Free;
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
{ TMPFConnections }

class function TConnections.NewUDP: TUDPConnection;
begin
  Result := TUDPConnection.Create;
end;

//------------------------------------------------------------------------------
{$IFDEF MSWINDOWS}

class function TConnections.NewCOM(const APort: Byte; const ABaudrate,
  AReadTimeout: Integer): TCOMConnection;
begin
  Result := TCOMConnection.Create(APort, ABaudrate, AReadTimeout);
end;

{$ENDIF}

//------------------------------------------------------------------------------
class function TConnections.NewUDP(const AAddr: string; const APort: Word;
  const AReadTimeout: Integer): TUDPConnection;
begin
  Result := TUDPConnection.Create(AAddr, APort, AReadTimeout);
end;

//==============================================================================
{ TCOMConnection }
{$IFDEF MSWINDOWS}
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
function NewMagicPacket(AMAC: IMACAddress): IMagicPacket;
begin
  Result := TMagicPacket.Create(AMAC);
end;

end.
