unit MPF.Streams;
interface
//==============================================================================
type
  IStream = interface['{32D84309-8750-4E9F-844F-8E15782C2C2E}']
    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadCardinal: Cardinal;
    function GetPosition: Int64;
    function ReadAnsiString8: string;

    property Position: Int64 read GetPosition;

  end;

//------------------------------------------------------------------------------
  IFileStream = interface(IStream)['{53EBEAA1-8F9E-4D63-90E4-A1006F9685C4}']
  end;

//==============================================================================
  TStreams = class
    class function NewFileStream(const AFileName: string; const AMode: Word): IFileStream;
  end;

//==============================================================================
implementation uses Classes;

//==============================================================================
type
  TmpfStream = class(TInterfacedObject)
  strict protected
    Stream: TStream;

    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadCardinal: Cardinal;
    function GetPosition: Int64;
    function ReadAnsiString8: string;

  public
   destructor Destroy; override;

  end;

//------------------------------------------------------------------------------
  TmpfFileStream = class(TmpfStream, IStream, IFileStream)
  public
    constructor Create(const AFileName: string; const AMode: Word); overload;
    constructor Create(const AFileName: string; const AMode: Word; ARights: Cardinal); overload;

  end;

//==============================================================================
{ TMpfStream }

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

//==============================================================================
{ TMpfFileStream }

constructor TMpfFileStream.Create(const AFileName: string; const AMode: Word);
begin
  inherited Create;
  Stream := TFileStream.Create(AFileName, AMode);
end;

//------------------------------------------------------------------------------
constructor TMpfFileStream.Create(const AFileName: string; const AMode: Word;
  ARights: Cardinal);
begin
  inherited Create;
  Stream := TFileStream.Create(AFileName, AMode, ARights);
end;

//==============================================================================
{ TStreams }

class function TStreams.NewFileStream(const AFileName: string;
  const AMode: Word): IFileStream;
begin
  Result := TMpfFileStream.Create(AFileName, AMode);
end;



end.
