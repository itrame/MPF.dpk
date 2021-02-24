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

//==============================================================================
function NewMACAddr(const AData: TBytes): IMACAddress;

//==============================================================================
implementation

//==============================================================================
type
  TMACAddress = class(TInterfacedObject, IMACAddress)
  strict private
    Bytes: TBytes;
    function AsString(const ASeparator: string = ''): string;
    function GetByte(Index: Integer): Byte;
    function GetData: TBytes;
  public
    constructor Create(const AData: TBytes);
  end;

//==============================================================================
{ TMACAddress }

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
  Bytes := AData;
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

//==============================================================================
function NewMACAddr(const AData: TBytes): IMACAddress;
begin
  if Length(AData) <> 6 then
    raise Exception.Create('Wrong data size. MAC Address should have 6 bytes.');

  Result := TMACAddress.Create(AData);

end;

end.
