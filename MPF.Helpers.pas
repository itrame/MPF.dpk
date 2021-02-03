unit MPF.Helpers;
interface uses MPF.Types;

//==============================================================================
type
  TByteHelper = record helper for Byte
    function GetBit(Index: Byte): Boolean;
    function ToStr: string;
    procedure SetBit(Index: Byte; const AValue: Boolean);
    property Bit[Index: Byte]: Boolean read GetBit write SetBit;
  end;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
{ TByteHelper }

function TByteHelper.GetBit(Index: Byte): Boolean;
begin
  if Index > 7 then
    raise Exception.Create('GetBit for TByte - bit index: ' + IntToStr(Index) + ' > 7!');

  Result := ((Self shr Index) and $01) = $01;

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

end.
