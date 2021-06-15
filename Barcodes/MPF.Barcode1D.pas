unit MPF.Barcode1D;
interface uses MPF.Barcode, Classes, MPF.Arrays;

//==============================================================================
type
  TMpfBarcode1D = class(TMpfBarcode)
  private
    FRow: Integer;
    function GetModules: IReadOnlyBoolArray;
    procedure SetRow(const Value: Integer);
  protected
    property Row: Integer read FRow write SetRow;
  public
    constructor Create(AOwner: TComponent); override;
    property Modules: IReadOnlyBoolArray read GetModules;
  end;

//==============================================================================
implementation

//==============================================================================
{ TMpfBarcode1D }

constructor TMpfBarcode1D.Create(AOwner: TComponent);
begin
  inherited;
  FRow := 0;
end;


function TMpfBarcode1D.GetModules: IReadOnlyBoolArray;
var
  i: Integer;
  AModule: Boolean;
  AModules: TArray<Boolean>;
begin
//  Encode;
  AModules := [];
  for i:=0 to SymbolWidth-1 do begin
    AModule := GetModule(i, FRow);
    AModules := AModules + [AModule];
  end;
  Result := TArrays.NewBoolArray(AModules);
end;


procedure TMpfBarcode1D.SetRow(const Value: Integer);
begin
  if FRow = Value then Exit;
  if FRow < 0 then begin FRow := 0; Exit end;
  if FRow >= SymbolHeight then begin FRow := SymbolHeight - 1; Exit; end;
  FRow := Value;
end;


end.
