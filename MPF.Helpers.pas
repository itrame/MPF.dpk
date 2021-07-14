unit MPF.Helpers;
interface uses SysUtils, MPF.Types, Vcl.StdCtrls, Vcl.ComCtrls;

//==============================================================================
type
  TBoolArray = TArray<Boolean>;

  TByteHelper = record helper for Byte
    function GetBit(Index: Byte): Boolean;
    procedure SetBit(Index: Byte; const AValue: Boolean);
    function ToString: string;
    function Lo: Byte;
    function Hi: Byte;
    function BCDToInt: Integer;
    function ToBin(const AL, AH: string; const ASep: string = ''): string;
    property Bit[Index: Byte]: Boolean read GetBit write SetBit;
  end;

//------------------------------------------------------------------------------
  TBytesHelper = record helper for TBytes
    function GetWord(const APos: Integer): Word;
    function GetInt16(const APos: Integer): Int16;
    function GetUInt32(const APos: Integer): UInt32;
    function GetUInt64(const APos: Integer): UInt64;
    function GetBCD(const APos: Integer): Byte;
    function ToHex(const APrefix, ASuffix, ASeparator: string): string; overload;
    function ToHex: string; overload;
    function ToAnsiStr(const ATerminator: Byte = $00): string;
    function GetSize: UInt32;
    procedure SetSize(const ASize: UInt32);

    property Size: UInt32 read GetSize write SetSize;
  end;

//------------------------------------------------------------------------------
  TBoolArrayHelper = record helper for TBoolArray
    function ToStr(const ATrueStr, AFalseStr: string; const ASep: string = ''): string;
  end;

//------------------------------------------------------------------------------
  TStringHelper = record helper for string
    function DeleteLeading(const AChar: Char): string;
    function DeleteEnding(const AChar: Char): string;
    function ToBool(const ATrueStr, AFalseStr: string; const ADefault: Boolean = False): Boolean;
    function ToInteger: Integer;
    function IsOnlyDigits: Boolean;
    function ToBytes: TBytes;
    function HexToInt: Integer;
  end;

//------------------------------------------------------------------------------
  TUInt32Helper = record helper for UInt32
    function ToBytes: TBytes;
    function ToString: string;
  end;

//------------------------------------------------------------------------------
  TBoolHelper = record helper for Boolean
    function ToString(const ATrueStr, AFalseStr: string): string;
    function ToStr(const ATrueStr, AFalseStr: string): string;
  end;

//------------------------------------------------------------------------------
  TListBoxHelper = class helper for TListBox
    function FirstSelectedIndex: Integer;
    function LastSelectedIndex: Integer;
    function IsFirstSelected: Boolean;
    function IsLastSelected: Boolean;
  end;

//------------------------------------------------------------------------------
  TDateTimeHelper = record helper for TDateTime
    function ToStr: string;
  end;

//------------------------------------------------------------------------------
  TListColumnsHelper = class helper for TListColumns
    function GetColumn(const ACaption: string): TListColumn;
  end;

//------------------------------------------------------------------------------
  TListItemHelper = class helper for TListItem
    procedure SetValue(const AColName, AValue: string);
  end;

//------------------------------------------------------------------------------
function ToTimeStr(const AHour, AMin: Byte): string;

//==============================================================================
implementation uses Character, Classes;

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
    raise Exception.Create('GetBit for TByte - bit index: ' + Index.ToString + ' > 7!');

  AMask := $01 shl Index;
  if AValue then
    Self := Self or AMask
  else
    Self := Self and (not AMask);

end;

//------------------------------------------------------------------------------
function TByteHelper.ToBin(const AL, AH, ASep: string): string;
var
  i: Integer;
begin
  Result := '';
  for i:=7 downto 0 do begin
    if Bit[i] then Result := Result + AH else Result := Result + AL;
    if i > 0 then Result := Result + ASep;
  end;
end;

//------------------------------------------------------------------------------
function TByteHelper.ToString: string;
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
function TBytesHelper.GetSize: UInt32;
begin
  Result := Length(Self);
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

//------------------------------------------------------------------------------
procedure TBytesHelper.SetSize(const ASize: UInt32);
begin
  SetLength(Self, ASize);
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToAnsiStr(const ATerminator: Byte = $00): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    if Self[i] = ATerminator then Break;
    Result := Result + Char(Self[i]);
  end;
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToHex: string;
begin
  Result := ToHex('', '', ' ');
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToHex(const APrefix, ASuffix, ASeparator: string): string;
var
  i: Integer;
  AItemStr: string;

begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    AItemStr := APrefix + IntToHex(Self[i], 2) + ASuffix;
    Result := Result + AItemStr;
    if i < Length(Self)-1 then Result := Result + ASeparator;
  end;

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

function TStringHelper.HexToInt: Integer;
begin
  Result := StrToInt('$' + Self);
end;

//------------------------------------------------------------------------------
function TStringHelper.IsOnlyDigits: Boolean;
var
  i: Integer;
begin
  Result := true;
  for i:=1 to Length(Self) do
    if not Self[i].IsDigit then begin
      Result := false;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function TStringHelper.ToBool(const ATrueStr, AFalseStr: string;
  const ADefault: Boolean): Boolean;
begin
  if UpperCase(Self) = UpperCase(ATrueStr) then begin
    Result := true;
    Exit;
  end;

  if UpperCase(Self) = UpperCase(AFalseStr) then begin
    Result := false;
    Exit;
  end;

  Result := ADefault;

end;

//------------------------------------------------------------------------------
function TStringHelper.ToBytes: TBytes;
var
  i: Integer;
begin
  Result := [];
  for i:=1 to Length(Self) do Result := Result + [Byte(Self[i])];
end;

//------------------------------------------------------------------------------
function TStringHelper.ToInteger: Integer;
begin
  Result := StrToInt(Self);
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
  AHrStr := AHour.ToString;
  AMinStr := AMin.ToString;
  if Length(AMinStr) < 2 then AMinStr := '0' + AMinStr;
  Result := AHrStr + ':' + AMinStr;
end;

//------------------------------------------------------------------------------
function TUInt32Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

//==============================================================================
{ TBoolHelper }

function TBoolHelper.ToStr(const ATrueStr, AFalseStr: string): string;
begin
  Result := ToString(ATrueStr, AFalseStr);
end;

//------------------------------------------------------------------------------
function TBoolHelper.ToString(const ATrueStr, AFalseStr: string): string;
begin
  if Self then Result := ATrueStr else Result := AFalseStr;
end;

//==============================================================================
{ TListBoxHelper }

function TListBoxHelper.FirstSelectedIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Self.Count-1 do
    if Self.Selected[i] then begin
      Result := i;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function TListBoxHelper.IsFirstSelected: Boolean;
begin
  Result := FirstSelectedIndex = 0;
end;

//------------------------------------------------------------------------------
function TListBoxHelper.IsLastSelected: Boolean;
begin
  Result := LastSelectedIndex = (Self.Count-1);
end;

//------------------------------------------------------------------------------
function TListBoxHelper.LastSelectedIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=Self.Count-1 downto 0 do
    if Self.Selected[i] then begin
      Result := i;
      Break;
    end;
end;

//==============================================================================
{ TBoolArrayHelper }

function TBoolArrayHelper.ToStr(const ATrueStr, AFalseStr: string;
  const ASep: string = ''): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    Result := Result + Self[i].ToString(ATrueStr, AFalseStr);
    if i < (Length(Self)-1) then Result := Result + ASep;
  end;
end;

//==============================================================================
{ TDateTimeHelper }

function TDateTimeHelper.ToStr: string;
begin
  Result := DateTimeToStr(Self);
end;

//==============================================================================
{ TListColumnsHelper }

function TListColumnsHelper.GetColumn(const ACaption: string): TListColumn;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to Self.Count-1 do
    if Self[i].Caption = ACaption then begin
      Result := Self[i];
      Break;
    end;
end;

//==============================================================================
{ TListItemHelper }

procedure TListItemHelper.SetValue(const AColName, AValue: string);
var
  i, AColId: Integer;
  AListView: TListView;

begin
  if not Assigned(Self.Owner) then Exit;
  if not (Self.Owner.Owner is TListView) then Exit;
  AListView := Self.Owner.Owner as TListView;

  AColId := -1;
  for i:=0 to AListView.Columns.Count-1 do
    if AListView.Columns[i].Caption = AColName then begin
      AColId := i;
      Break;
    end;

  if AColId < 0 then Exit;

  for i:=SubItems.Count to AColId do
    SubItems.Add('');

  SubItems[AColId-1] := AValue;

end;

end.
