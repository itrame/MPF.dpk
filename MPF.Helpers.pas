unit MPF.Helpers;
interface uses SysUtils, MPF.Types;

//==============================================================================
type
  TByteHelper = record helper for Byte
    function GetBit(Index: Byte): Boolean;
    procedure SetBit(Index: Byte; const AValue: Boolean);
    function ToStr: string;
    function Lo: Byte;
    function Hi: Byte;
    function BCDToInt: Integer;
    property Bit[Index: Byte]: Boolean read GetBit write SetBit;
  end;

//------------------------------------------------------------------------------
  TBytesHelper = record helper for TBytes
    function GetWord(const APos: Integer): Word;
    function GetInt16(const APos: Integer): Int16;
    function GetUInt32(const APos: Integer): UInt32;
    function GetUInt64(const APos: Integer): UInt64;
    function GetBCD(const APos: Integer): Byte;
  end;

//------------------------------------------------------------------------------
  TStringHelper = record helper for string
    function DeleteLeading(const AChar: Char): string;
    function DeleteEnding(const AChar: Char): string;
  end;

//------------------------------------------------------------------------------
  TUInt32Helper = record helper for UInt32
    function ToBytes: TBytes;
  end;

//------------------------------------------------------------------------------
function ToTimeStr(const AHour, AMin: Byte): string;

//==============================================================================
implementation

//==============================================================================
{ TByteHelper }

function TByteHelper.BCDToInt: Integer;
begin
  Result := (10 * Hi) + Lo;
end;

//------------------------------------------------------------------------------
function TByteHelper.GetBit(Index: Byte): Boolean;
begin
  if Index > 7 then
    raise Exception.Create('GetBit for TByte - bit index: ' + IntToStr(Index) + ' > 7!');

  Result := ((Self shr Index) and $01) = $01;

end;

//------------------------------------------------------------------------------
function TByteHelper.Hi: Byte;
begin
  Result := Self shr 4;
end;

//------------------------------------------------------------------------------
function TByteHelper.Lo: Byte;
begin
  Result := Self and $0F;
end;

//------------------------------------------------------------------------------
procedure TByteHelper.SetBit(Index: Byte; const AValue: Boolean);
var
  AMask: Byte;

begin
  if Index > 7 then
    raise Exception.Create('GetBit for TByte - bit index: ' + Index.ToStr + ' > 7!');

  AMask := $01 shl Index;
  if AValue then
    Self := Self or AMask
  else
    Self := Self and (not AMask);

end;

//------------------------------------------------------------------------------
function TByteHelper.ToStr: string;
begin
  Result := IntToStr(Self);
end;

//==============================================================================
{ TBytesHelper }

function TBytesHelper.GetBCD(const APos: Integer): Byte;
begin
  Result := (Self[APos] shr 4)*10 + (Self[APos] and $0F);
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetInt16(const APos: Integer): Int16;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetUInt32(const APos: Integer): UInt32;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
  Result := (Result shl 8) or Self[APos+2];
  Result := (Result shl 8) or Self[APos+3];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetUInt64(const APos: Integer): UInt64;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
  Result := (Result shl 8) or Self[APos+2];
  Result := (Result shl 8) or Self[APos+3];
  Result := (Result shl 8) or Self[APos+4];
  Result := (Result shl 8) or Self[APos+5];
  Result := (Result shl 8) or Self[APos+6];
  Result := (Result shl 8) or Self[APos+7];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetWord(const APos: Integer): Word;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
end;

//==============================================================================
{ TStringHelper }

function TStringHelper.DeleteEnding(const AChar: Char): string;
begin
  Result := Self;
  while Length(Result) > 0 do
    if Self[Length(Result)] = AChar then Delete(Result, Length(Result), 1) else Break;
end;

//------------------------------------------------------------------------------
function TStringHelper.DeleteLeading(const AChar: Char): string;
begin
  Result := Self;
  while Length(Result) > 0 do
    if Result[1] = AChar then Delete(Result, 1, 1) else Break;
end;

//==============================================================================
{ TUInt32Helper }

function TUInt32Helper.ToBytes: TBytes;
begin
  Result := [(Self and $FF000000) shr 24];
  Result := Result + [(Self and $00FF0000) shr 16];
  Result := Result + [(Self and $0000FF00) shr 8];
  Result := Result + [Self and $000000FF];

end;

//==============================================================================
function ToTimeStr(const AHour, AMin: Byte): string;
var
  AHrStr,AMinStr: string;
begin
  AHrStr := AHour.ToStr;
  AMinStr := AMin.ToStr;
  if Length(AMinStr) < 2 then AMinStr := '0' + AMinStr;
  Result := AHrStr + ':' + AMinStr;
end;



end.
