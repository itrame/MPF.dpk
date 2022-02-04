unit MPF.Streams;
interface uses SysUtils;
//==============================================================================
type
  IStream = interface['{32D84309-8750-4E9F-844F-8E15782C2C2E}']
    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadCardinal: Cardinal;
    function GetPosition: Int64;
    function ReadAnsiString8: string;
    procedure WriteUInt32(const AValue: UInt32);
    procedure WriteByte(const AValue: Byte);
    procedure WriteWord(const AValue: Word);

    property Position: Int64 read GetPosition;

  end;

//==============================================================================
  TStreams = class
    class function NewStream(const AFileName: string; const AMode: Word): IStream; overload;
    class function NewStream(const ABytes: TBytes): IStream; overload;
  end;

//==============================================================================
implementation uses Classes;

//==============================================================================
type
  TmpfStream = class(TInterfacedObject, IStream)
  strict protected
    Stream: TStream;

    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadCardinal: Cardinal;
    function GetPosition: Int64;
    function ReadAnsiString8: string;
    procedure WriteUInt32(const AValue: UInt32);
    procedure WriteByte(const AValue: Byte);
    procedure WriteWord(const AValue: Word);

  public
    constructor Create(const AFileName: string; const AMode: Word); overload;
    constructor Create(const AFileName: string; const AMode: Word; ARights: Cardinal); overload;
    constructor Create(const ABytes: TBytes); overload;
    destructor Destroy; override;

  end;

//==============================================================================
{ TMpfStream }

constructor TMpfStream.Create(const AFileName: string; const AMode: Word);
begin
  inherited Create;
  Stream := TFileStream.Create(AFileName, AMode);
end;

//------------------------------------------------------------------------------
constructor TmpfStream.Create(const AFileName: string; const AMode: Word;
  ARights: Cardinal);
begin
  inherited Create;
  Stream := TFileStream.Create(AFileName, AMode, ARights);
end;

//------------------------------------------------------------------------------
constructor TmpfStream.Create(const ABytes: TBytes);
begin
  inherited Create;
  Stream := TBytesStream.Create(ABytes);
end;

//------------------------------------------------------------------------------
destructor TMpfStream.Destroy;
begin
  if Stream <> nil then Stream.Free;
  inherited;
end;

//------------------------------------------------------------------------------
function TmpfStream.GetPosition: Int64;
begin
  Result := Stream.Position;
end;

//------------------------------------------------------------------------------
function TMpfStream.ReadByte: Byte;
var
  AValue: Byte;
begin
  Stream.Read(AValue, 1);
  Result := AValue;
end;

//------------------------------------------------------------------------------
function TMpfStream.ReadCardinal: Cardinal;
var
  AValue: Cardinal;
begin
  Stream.Read(AValue, 4);
  Result := AValue;
end;

//------------------------------------------------------------------------------
function TmpfStream.ReadAnsiString8: string;
var
  ALen: Byte;
  i: Integer;
begin
  Result := '';
  ALen := ReadByte;
  for i:=1 to ALen do Result := Result + Char(ReadByte);
end;

//------------------------------------------------------------------------------
function TMpfStream.ReadWord: Word;
var
  AValue: Word;
begin
  Stream.Read(AValue, 2);
  Result := AValue;
end;

//------------------------------------------------------------------------------
procedure TmpfStream.WriteByte(const AValue: Byte);
begin
  Stream.Write(AValue, 1);
end;

//------------------------------------------------------------------------------
procedure TmpfStream.WriteUInt32(const AValue: UInt32);
begin
  Stream.Write(AValue, 4);
end;

//------------------------------------------------------------------------------
procedure TmpfStream.WriteWord(const AValue: Word);
begin
  Stream.Write(AValue, 2);
end;

//==============================================================================
{ TStreams }

class function TStreams.NewStream(const ABytes: TBytes): IStream;
begin
  Result := TMpfStream.Create(ABytes);
end;

//------------------------------------------------------------------------------
class function TStreams.NewStream(const AFileName: string;
  const AMode: Word): IStream;
begin
  Result := TMpfStream.Create(AFileName, AMode);
end;



end.
