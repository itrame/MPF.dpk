unit MPF.Barcode1D;
interface uses MPF.Barcode, Classes, MPF.Arrays;

//==============================================================================
type
  IMpfBarcode1D = interface(IMpfBarcode)['{1B30611A-DF49-4C0F-93A4-71B3E80A4203}']
    function GetModules: TArray<Boolean>;
    property Modules: TArray<Boolean> read GetModules;
  end;

//------------------------------------------------------------------------------
  TMpfBarcode1D = class(TMpfBarcode)
  protected
    function GetModules: TArray<Boolean>;
  end;

//==============================================================================
implementation

//==============================================================================
{ TMpfBarcode1D }

function TMpfBarcode1D.GetModules: TArray<Boolean>;
var
  i: Integer;
begin
  Result := [];
  for i:=0 to Symbol.Width-1 do
    Result := Result + [Symbol[i,0]];
end;

end.
