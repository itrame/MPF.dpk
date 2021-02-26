unit MPF.MAC;
interface uses SysUtils;

//==============================================================================
type
  IMACAddress = interface['{B34C6408-3E3A-4611-A17C-EE2FF5C4A47F}']
    function AsString(const ASeparator: string = ''): string;
    function GetByte(Index: Integer): Byte;
    function GetData: TBytes;
    property Bytes[Index: Integer]: Byte read GetByte;
    property Data: TBytes read GetData;
  end;

//------------------------------------------------------------------------------
  IEditableMACAddress = interface['{E9B31D48-DF14-43C1-8417-F0B1EBB98651}']
    function GetData: TBytes;
    procedure SetData(const AData: TBytes);
    function AsMACAddress: IMACAddress;
    property Data: TBytes read GetData write SetData;
  end;

//==============================================================================
implementation uses Spring.Container;

//==============================================================================
type
  TMACAddress = class(TInterfacedObject, IMACAddress, IEditableMACAddress)
  strict private
    Bytes: TBytes;
    function AsString(const ASeparator: string = ''): string;
    function GetByte(Index: Integer): Byte;
    function GetData: TBytes;
    procedure SetData(const AData: TBytes);
    function AsMACAddress: IMACAddress;
    function ValidateData(const AData: TBytes): Boolean;
  public
    constructor Create(const AData: TBytes); overload;
    constructor Create; overload;
  end;

//==============================================================================
{ TMACAddress }

function TMACAddress.AsMACAddress: IMACAddress;
begin
  Result := Self;
end;

//------------------------------------------------------------------------------
function TMACAddress.AsString(const ASeparator: string = ''): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to 5 do begin
    Result := IntToHex(Bytes[i], 2);
    if i<5 then Result := Result + ASeparator;
  end;
end;

//------------------------------------------------------------------------------
constructor TMACAddress.Create(const AData: TBytes);
begin
  inherited Create;
  SetData(AData);
end;

//------------------------------------------------------------------------------
constructor TMACAddress.Create;
begin
  inherited;
  SetData([0, 0, 0, 0, 0, 0]);
end;

//------------------------------------------------------------------------------
function TMACAddress.GetByte(Index: Integer): Byte;
begin
  Result := Bytes[Index];
end;

//------------------------------------------------------------------------------
function TMACAddress.GetData: TBytes;
begin
  Result := Bytes;
end;

//------------------------------------------------------------------------------
procedure TMACAddress.SetData(const AData: TBytes);
var
  i: Integer;
begin
  if not ValidateData(AData) then raise Exception.Create('Data is not valid MAC Address.');
  Bytes := [];
  for i:=0 to Length(AData)-1 do Bytes := Bytes + [AData[i]];
end;

//------------------------------------------------------------------------------
function TMACAddress.ValidateData(const AData: TBytes): Boolean;
begin
  Result := false;
  if Length(AData) <> 6 then Exit;
  Result := true;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TMACAddress>.
    Implements<IMACAddress>.
    Implements<IEditableMACAddress>;

end.
