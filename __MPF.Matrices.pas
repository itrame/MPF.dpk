unit __MPF.Matrices;
interface uses MPF.Arrays;

//==============================================================================
type
  IMpConstMatrix = interface(IMpConstArray)['{F1A8C655-10BA-47A0-93C5-4E21C29E26A8}']
    function GetWidth: Integer;
    function GetHeight: Integer;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;

//------------------------------------------------------------------------------
  IMpReadOnlyMatrix<T> = interface(IMpConstMatrix)['{2170AC1B-B07C-4905-8ACE-D6FFF8BF8610}']
    function GetItem(X,Y: Integer): T;
    property Items[X,Y: Integer]: T read GetItem; default;
  end;

//------------------------------------------------------------------------------
  IMpResizableMatrix = interface(IMpConstMatrix)['{CB0DD1B2-9550-484A-BD3C-0AB25A214E1E}']
    procedure SetWidth(const AWidth: Integer);
    procedure SetHeight(const AHeight: Integer);
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

//------------------------------------------------------------------------------
  IMpMatrix<T> = interface(IMpReadOnlyMatrix<T>)['{BE6348A7-BB04-4A0E-99F3-F3FB1F9F471F}']
    procedure SetItem(X,Y: Integer; AValue: T);
    procedure SetWidth(const AWidth: Integer);
    procedure SetHeight(const AHeight: Integer);
    procedure SetSize(const AWidth, AHeight: Integer);
    property Items[X,Y: Integer]: T read GetItem write SetItem; default;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

//------------------------------------------------------------------------------
  TMpMatrix = class(TInterfacedObject, IMpConstMatrix)
  strict protected
    function ToStr: string; virtual; abstract;
    function GetSize: Integer;
    function GetWidth: Integer; virtual; abstract;
    function GetHeight: Integer; virtual; abstract;
  end;

//------------------------------------------------------------------------------
  TMpMatrix<T> = class(TMpMatrix, IMpReadOnlyMatrix<T>, IMpMatrix<T>)
  strict private
    Items: TArray<TArray<T>>;
    function GetItem(X,Y: Integer): T;
    procedure SetItem(X,Y: Integer; AValue: T);
    procedure SetWidth(const AWidth: Integer);
    procedure SetHeight(const AHeight: Integer);
    procedure SetSize(const AWidth, AHeight: Integer);
    function GetMaxLength(AData: TArray<TArray<T>>): Integer;
  strict protected
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
  public
    constructor Create(const AWidth, AHeight: Integer); overload;
    constructor Create(AData: TArray<TArray<T>>); overload;
  end;

//==============================================================================
  TMatrices = class
    class function CreateMatrixOf<T>(const AWidth, AHeight: Integer): TMpMatrix<T>; overload;
    class function CreateMatrixOf<T>(AData: TArray<TArray<T>>): TMpMatrix<T>; overload;
    class function CreateMatrixOf<T>: TMpMatrix<T>; overload;
  end;

//==============================================================================
implementation

//==============================================================================
{ TMpMatrix }

function TMpMatrix.GetSize: Integer;
begin
  Result := GetWidth * GetHeight;
end;

//==============================================================================
{ TMpMatrix<T> }

constructor TMpMatrix<T>.Create(const AWidth, AHeight: Integer);
begin
  inherited Create;
  SetSize(AWidth, AHeight);
end;

//------------------------------------------------------------------------------
constructor TMpMatrix<T>.Create(AData: TArray<TArray<T>>);
var
  Y: Integer;
  X: Integer;
begin
  Create(GetMaxLength(AData), Length(AData));
  for Y:=0 to Length(AData)-1 do
    for X:=0 to Length(AData[Y])-1 do
      Items[Y,X] := AData[Y,X];
end;

//------------------------------------------------------------------------------
function TMpMatrix<T>.GetHeight: Integer;
begin
  Result := Length(Items);
end;

//------------------------------------------------------------------------------
function TMpMatrix<T>.GetItem(X, Y: Integer): T;
begin
  Result := Items[Y,X];
end;

//------------------------------------------------------------------------------
function TMpMatrix<T>.GetMaxLength(AData: TArray<TArray<T>>): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i:=0 to Length(AData)-1 do
    if Length(AData[i]) > Result then Result := Length(AData[i]);
end;

//------------------------------------------------------------------------------
function TMpMatrix<T>.GetWidth: Integer;
begin
  if GetHeight > 0 then Result := Length(Items[0]) else Result := 0;
end;

//------------------------------------------------------------------------------
procedure TMpMatrix<T>.SetHeight(const AHeight: Integer);
var
  AWidth,i: Integer;
begin
  AWidth := GetWidth;
  SetLength(Items, AHeight);
  SetWidth(AWidth);
end;

//------------------------------------------------------------------------------
procedure TMpMatrix<T>.SetItem(X, Y: Integer; AValue: T);
begin
  Items[Y,X] := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpMatrix<T>.SetSize(const AWidth, AHeight: Integer);
begin
  SetHeight(AHeight);
  SetWidth(AWidth);
end;

//------------------------------------------------------------------------------
procedure TMpMatrix<T>.SetWidth(const AWidth: Integer);
var
  i: Integer;
begin
  for i:=0 to Length(Items)-1 do SetLength(Items[i], AWidth);
end;

//==============================================================================
{ TMatrices }

class function TMatrices.CreateMatrixOf<T>(AData: TArray<TArray<T>>): TMpMatrix<T>;
begin
  Result := TMpMatrix<T>.Create(AData);
end;

//------------------------------------------------------------------------------
class function TMatrices.CreateMatrixOf<T>(const AWidth, AHeight: Integer): TMpMatrix<T>;
begin
  Result := TMpMatrix<T>.Create(AWidth, AHeight);
end;

//------------------------------------------------------------------------------
class function TMatrices.CreateMatrixOf<T>: TMpMatrix<T>;
begin
  Result := TMpMatrix<T>.Create;
end;

end.
