unit MPF.Barcode;
interface uses MPF.Matrices, zint, Classes;

//==============================================================================
type
  TMpfBarcode = class(TComponent)
  private
    FSymbol: TZintSymbol;
    FContent: string;
    function GetSymbology: TZintSymbology;
    procedure SetSymbology(const Value: TZintSymbology);
    procedure SetContent(const Value: string);
    function GetSymbolHeight: Integer;
    function GetSymbolWidth: Integer;
    function GetSignature: string;
  protected
    function GetModule(const AX, AY: Integer): Boolean;
    function ValidateContent(const AContent: string): Boolean; virtual;
    procedure Encode;
    property Symbology: TZintSymbology read GetSymbology write SetSymbology;
    property SymbolHeight: Integer read GetSymbolHeight;
    property SymbolWidth: Integer read GetSymbolWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Content: string read FContent write SetContent;
    property Signature: string read GetSignature;
  end;

//==============================================================================
implementation uses zint_common, MPF.Helpers;

//==============================================================================
{ TMpfBarcode}

constructor TMpfBarcode.Create(AOwner: TComponent);
begin
  inherited;
  FSymbol := TZintSymbol.Create(Self);
end;


destructor TMpfBarcode.Destroy;
begin
  FSymbol.Free;
  inherited;
end;


procedure TMpfBarcode.Encode;
begin
  FSymbol.Clear;
  FSymbol.Encode(string(UTF8Encode(FContent)), true);
end;


function TMpfBarcode.GetSignature: string;
begin
  Result := FSymbol.text.ToAnsiStr($00);
end;


function TMpfBarcode.GetSymbolHeight: Integer;
begin
  Result := FSymbol.height;
end;


function TMpfBarcode.GetSymbology: TZintSymbology;
begin
  Result := FSymbol.SymbolType;
end;


function TMpfBarcode.GetSymbolWidth: Integer;
begin
  Result := FSymbol.width;
end;


function TMpfBarcode.GetModule(const AX, AY: Integer): Boolean;
begin
  Result := module_is_set(FSymbol, AY, AX) <> 0;
end;


procedure TMpfBarcode.SetContent(const Value: string);
begin
  if ValidateContent(Value) then begin
    FContent := Value;
    Encode;
  end;
end;


procedure TMpfBarcode.SetSymbology(const Value: TZintSymbology);
begin
  FSymbol.SymbolType := Value;
end;


function TMpfBarcode.ValidateContent(const AContent: string): Boolean;
begin
  Result := true;
end;

end.
