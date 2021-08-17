unit MPF.IcpConET7060;
interface

//==============================================================================
type
  IIcpConET7060 = interface['{7D284A18-656B-4172-8E59-F9CA0CF689B5}']
    function GetAddress: string;
    procedure SetAddress(const AAddr: string);
    function GetPort: Word;
    procedure SetPort(const AValue: Word);
    function GetUnitID: Byte;
    procedure SetUnitID(const AValue: Byte);
    function GetConnectTimeout: Integer;
    procedure SetConnectTimeout(const AValue: Integer);
    function GetReadTimeout: Integer;
    procedure SetReadTimeout(const AValue: Integer);
    procedure Connect;
    procedure Disconnect;

    function GetInput(const AInput: Byte): Boolean;
    function GetInputsArray: TArray<Boolean>;
    procedure SetOutput(const AOutput: Byte; const AValue: Boolean);
    procedure SetOutputs(const AData: TArray<Boolean>);


    property Address: string read GetAddress write SetAddress;
    property Port: Word read GetPort write SetPort;
    property UnitID: Byte read GetUnitID write SetUnitID;
    property ConnectTimeout: Integer read GetConnectTimeout write SetConnectTimeout;
    property ReadTimeout: Integer read GetReadTimeout write SetReadTimeout;

  end;

//==============================================================================
implementation uses IdModbusClient, SysUtils, MPF.Helpers, Spring.Container;

//==============================================================================
type
  TIcpConET7060 = class(TInterfacedObject, IIcpConET7060)
  strict private
    Connection: TIdModbusClient;

    function GetAddress: string;
    procedure SetAddress(const AAddr: string);
    function GetPort: Word;
    procedure SetPort(const AValue: Word);
    function GetUnitID: Byte;
    procedure SetUnitID(const AValue: Byte);
    function GetConnectTimeout: Integer;
    procedure SetConnectTimeout(const AValue: Integer);
    function GetReadTimeout: Integer;
    procedure SetReadTimeout(const AValue: Integer);
    procedure Connect;
    procedure Disconnect;

    function GetInput(const AInput: Byte): Boolean;
    function GetInputsArray: TArray<Boolean>;
    procedure SetOutput(const AOutput: Byte; const AValue: Boolean);
    procedure SetOutputs(const AData: TArray<Boolean>);

  public
    constructor Create;
    destructor Destroy; override;

  end;

//==============================================================================
{ TIcpConET7060 }

procedure TIcpConET7060.Connect;
begin
  Connection.Connect;
end;

//------------------------------------------------------------------------------
constructor TIcpConET7060.Create;
begin
  inherited;
  Connection := TIdModBusClient.Create(nil);
  Connection.UnitID := 1;
  Connection.ConnectTimeout := 2000;
  Connection.ReadTimeout := 2000;
end;

//------------------------------------------------------------------------------
destructor TIcpConET7060.Destroy;
begin
  FreeAndNil(Connection);
  inherited;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.Disconnect;
begin
  Connection.Disconnect;
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetAddress: string;
begin
  Result := Connection.Host;
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetConnectTimeout: Integer;
begin
  Result := Connection.ConnectTimeout;
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetInput(const AInput: Byte): Boolean;
var
  AData: TArray<Boolean>;
begin
  SetLength(AData, 1);
  if AInput < 6 then Connection.ReadInputBits(AInput+1, 1, AData);
  Result := AData[0];
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetInputsArray: TArray<Boolean>;
begin
  SetLength(Result, 6);
  Connection.ReadInputBits(1, 6, Result);
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetPort: Word;
begin
  Result := Connection.Port;
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetReadTimeout: Integer;
begin
  Result := Connection.ReadTimeout;
end;

//------------------------------------------------------------------------------
function TIcpConET7060.GetUnitID: Byte;
begin
  Result := Connection.UnitID;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetAddress(const AAddr: string);
begin
  Connection.Host := AAddr;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetConnectTimeout(const AValue: Integer);
begin
  Connection.ConnectTimeout := AValue;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetOutput(const AOutput: Byte; const AValue: Boolean);
begin
  if AOutput < 6 then Connection.WriteCoil(AOutput+1, AValue);
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetOutputs(const AData: TArray<Boolean>);
var
  ALocalData: TArray<Boolean>;
begin
  ALocalData := AData.Clone;
  SetLength(ALocalData, 6);
  Connection.WriteCoils(1, 6, ALocalData);
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetPort(const AValue: Word);
begin
  Connection.Port := AValue;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetReadTimeout(const AValue: Integer);
begin
  Connection.ReadTimeout := AValue;
end;

//------------------------------------------------------------------------------
procedure TIcpConET7060.SetUnitID(const AValue: Byte);
begin
  Connection.UnitID := AValue;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TIcpConET7060>.Implements<IIcpConET7060>;

end.
