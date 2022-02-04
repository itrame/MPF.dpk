unit MPF.Barcode;
interface uses MPF.Matrices, zint, Classes;

//==============================================================================
type
  IMpfBarcode = interface['{1180685F-7304-4B9E-B410-88EF6642C7EE}']
    function GetContent: string;
    procedure SetContent(const AContent: string);
    function GetSignature: string;
    procedure Encode;

    property Content: string read GetContent write SetContent;
    property Signature: string read GetSignature;
  end;

//------------------------------------------------------------------------------

  TMpfBarcode = class(TInterfacedObject, IMpfBarcode)
  protected
    Symbology: TZintSymbology;
    Content: string;
    Signature: string;
    Symbol: IBoolMatrix;

    function GetSymbology: TZintSymbology;
    procedure SetSymbology(const AValue: TZintSymbology);
    function ValidateContent(const AContent: string): Boolean; virtual;
    procedure Encode;
    function GetContent: string;
    procedure SetContent(const AValue: string);
    function GetSignature: string;
    procedure UpdateSymbolFrom(AZintSymbol: TZintSymbol);

  public
    constructor Create;

  end;

//==============================================================================
implementation uses zint_common, MPF.Helpers, SysUtils, Spring.Services;

//==============================================================================
{ TMpfBarcode}

constructor TMpfBarcode.Create;
begin
  inherited;
  Symbol := ServiceLocator.GetService<IBoolMatrix>;
end;

//------------------------------------------------------------------------------
procedure TMpfBarcode.Encode;
var
  AZintSymbol: TZintSymbol;
begin
  AZintSymbol := TZintSymbol.Create(nil);
  try
    AZintSymbol.SymbolType := Symbology;
    AZintSymbol.Encode(string(UTF8Encode(Content)), true);
    Signature := AZintSymbol.text.ToAnsiStr($00);
    UpdateSymbolFrom(AZintSymbol);
  finally
    FreeAndNil(AZintSymbol);
  end;

end;

//------------------------------------------------------------------------------
function TMpfBarcode.GetSignature: string;
begin
  Result := Signature;
end;

//------------------------------------------------------------------------------
function TMpfBarcode.GetSymbology: TZintSymbology;
begin
  Result := Symbology;
end;

//------------------------------------------------------------------------------
function TMpfBarcode.GetContent: string;
begin
  Result := Content;
end;

//------------------------------------------------------------------------------
procedure TMpfBarcode.SetContent(const AValue: string);
begin
  if ValidateContent(AValue) then Content := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfBarcode.SetSymbology(const AValue: TZintSymbology);
begin
  Symbology := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfBarcode.UpdateSymbolFrom(AZintSymbol: TZintSymbol);
var
  aX, aY: Integer;
begin
  Symbol.Width := AZintSymbol.width;
  Symbol.Height := AZintSymbol.height;
  for aY:=0 to Symbol.Height-1 do
    for aX:=0 to Symbol.Width-1 do
      Symbol[aX,aY] := module_is_set(AZintSymbol, aY, aX) <> 0;
end;

//------------------------------------------------------------------------------
function TMpfBarcode.ValidateContent(const AContent: string): Boolean;
begin
  Result := true;
end;

end.
