unit MPF.Matrices;
interface uses MPF.Converters, System.Generics.Defaults, MPF.Types, System.Types;

//==============================================================================
type
  IMatrix<T> = interface;

  IReadOnlyMatrix<T> = interface['{4AB3CBEE-7E2E-499E-BFF0-D85D41B768A3}']
    function GetItem(X,Y: Integer): T;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function AsStr(AConverter: IMatrixToStr<T>): string;
    function CountOf(const AItem: T; AComparer: IEqualityComparer<T>): Integer; overload;
    function CountOf(const AItem: T): Integer; overload;
    function Equal(const X, Y: Integer; AItem: T; AComparer: IEqualityComparer<T>): Boolean; overload;
    function Equal(const X, Y: Integer; AItem: T): Boolean; overload;
    procedure GetData(var AData: TArray<TArray<T>>);
    function PositionOf(AItem: T; AComparer: IEqualityComparer<T>): TPoint; overload;
    function PositionOf(AItem: T): TPoint; overload;
    function Clone: IMatrix<T>;
    function GetSize: UInt64;

    property Items[X,Y: Integer]: T read GetItem; default;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Size: UInt64 read GetSize;

  end;

//------------------------------------------------------------------------------
  IReadOnlyBoolMatrix = interface(IReadOnlyMatrix<Boolean>)['{8723CF65-3957-4F59-82A0-27B675A2ADEA}']
  end;

//------------------------------------------------------------------------------
  IMatrix<T> = interface(IReadOnlyMatrix<T>)['{9603548C-2DE0-4654-A010-D0588207447B}']
    procedure SetItem(X,Y: Integer; AValue: T);
    procedure SetWidth(const AWidth: Integer);
    procedure SetHeight(const AHeight: Integer);
    procedure SetSize(const AWidth, AHeight: Integer);
    procedure SetData(AData: TArray<TArray<T>>);
    procedure Fill(const AValue: T);
    procedure MultiplyX(const AFactor: Integer);
    procedure RotateRight;
    procedure RotateLeft;
    procedure RotateUpsideDown;
    procedure FillColumn(const AColumn: Integer; const AValue: T);

    property Items[X,Y: Integer]: T read GetItem write SetItem; default;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Data: TArray<TArray<T>> write SetData;

  end;

//------------------------------------------------------------------------------
  IBoolMatrix = interface(IMatrix<Boolean>)['{76AAF44B-A204-45FA-96A1-DD977CD83EAC}']
    procedure Mask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>; const AOperation: TBoolOperationType);
    procedure AndMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure AndMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure OrMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure OrMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure XorMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure XorMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure Invert;
    function Clone: IBoolMatrix;
  end;

//------------------------------------------------------------------------------
  TMatrixOf<T> = class(TInterfacedObject, IMatrix<T>, IReadOnlyMatrix<T>)
  strict private
    Items: TArray<TArray<T>>;

    function GetItem(X,Y: Integer): T;
    procedure SetItem(X,Y: Integer; AValue: T);
    procedure SetWidth(const AWidth: Integer);
    procedure SetHeight(const AHeight: Integer);
    procedure SetSize(const AWidth, AHeight: Integer);
    function GetMaxLength(AData: TArray<TArray<T>>): Integer;
    function GetWidth: Integer;
    procedure GetData(var AData: TArray<TArray<T>>);
    procedure SetData(AData: TArray<TArray<T>>);
    function AsStr(AConverter: IMatrixToStr<T>): string;
    function CountOf(const AItem: T; AComparer: IEqualityComparer<T>): Integer; overload;
    function CountOf(const AItem: T): Integer; overload;
    function Equal(const X, Y: Integer; AItem: T; AComparer: IEqualityComparer<T>): Boolean; overload;
    function Equal(const X, Y: Integer; AItem: T): Boolean; overload;
    procedure Fill(const AValue: T);
    function RowExists(const ARow: Integer): Boolean;
    function PositionOf(AItem: T; AComparer: IEqualityComparer<T>): TPoint; overload;
    function PositionOf(AItem: T): TPoint; overload;
    function Clone: IMatrix<T>;
    function GetSize: UInt64;
    procedure MultiplyX(const AFactor: Integer);
    procedure RotateLeft;
    procedure RotateRight;
    procedure RotateUpsideDown;
    procedure FillColumn(const AColumn: Integer; const AValue: T);

  strict protected
    procedure PasteRow(const X, Y: Integer; const ARow: TArray<T>);
    function GetHeight: Integer;
    function GetRow(const ARow: Integer): TArray<T>;
    procedure CopyTo(ADest: IInterface); virtual;

  public
    constructor Create; overload;
    constructor Create(const AWidth, AHeight: Integer); overload;
    constructor Create(AData: TArray<TArray<T>>); overload;

  end;

//------------------------------------------------------------------------------
  TBoolMatrix = class(TMatrixOf<Boolean>, IBoolMatrix, IReadOnlyBoolMatrix)
  strict private
    procedure Mask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>; const AOperation: TBoolOperationType); overload;
    procedure Mask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>; const AOperation: TBoolOperationType); overload;
    procedure AndMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure AndMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure OrMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure OrMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure XorMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>); overload;
    procedure XorMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>); overload;
    procedure Invert;
    function Clone: IBoolMatrix;
  end;

//==============================================================================
  TMatrices = class
    class function NewMatrix<T>: TMatrixOf<T>; overload;
    class function NewMatrix<T>(const AWidth, AHeight: Integer): TMatrixOf<T>; overload;
    class function NewMatrix<T>(AData: TArray<TArray<T>>): TMatrixOf<T>; overload;

    class function NewBoolMatrix: TBoolMatrix; overload;
    class function NewBoolMatrix(const AWidth, AHeight: Integer): TBoolMatrix; overload;
    class function NewBoolMatrix(AData: TArray<TArray<Boolean>>): TBoolMatrix; overload;

    class function NewMatrixToStr<T>: TMatrixToStr<T>; overload;
    class function NewMatrixToStr<T>(AItemConverter: IValueToStr<T>): TMatrixToStr<T>; overload;

  end;

//==============================================================================
implementation uses SysUtils, Spring.Container, MPF.Arrays;

//==============================================================================
{ TMatrixOf<T> }

constructor TMatrixOf<T>.Create(const AWidth, AHeight: Integer);
begin
  Create;
  SetSize(AWidth, AHeight);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.CountOf(const AItem: T; AComparer: IEqualityComparer<T>): Integer;
var
  Y,X: Integer;

begin
  Result := 0;
  for Y:=0 to GetHeight-1 do
    for X:=0 to GetWidth-1 do begin
      if Equal(X, Y, AItem, AComparer) then
        Result := Result + 1;
    end;

end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.Clone: IMatrix<T>;
begin
  Result := TMatrixOf<T>.Create;
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.CopyTo(ADest: IInterface);
var
  ADestObject: TObject;
  ADestMatrix: TMatrixOf<T>;

begin
  ADestObject := ADest as TObject;
  if ADestObject is TMatrixOf<T> then begin
    ADestMatrix := ADestObject as TMatrixOf<T>;
    ADestMatrix.SetData(Items);
  end;

end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.CountOf(const AItem: T): Integer;
var
  AComparer: IEqualityComparer<T>;
begin
  AComparer := TEqualityComparer<T>.Default;
  Result := CountOf(AItem, AComparer);
end;

//------------------------------------------------------------------------------
constructor TMatrixOf<T>.Create;
begin
  inherited;
  SetLength(Items, 1);
  SetLength(Items[0], 1);
end;

//------------------------------------------------------------------------------
constructor TMatrixOf<T>.Create(AData: TArray<TArray<T>>);
begin
  Create;
  SetData(AData);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.Equal(const X, Y: Integer; AItem: T): Boolean;
var
  AComparer: IEqualityComparer<T>;
begin
  AComparer := TEqualityComparer<T>.Default;
  Result := Equal(X, Y, AItem, AComparer);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.Equal(const X, Y: Integer; AItem: T;
  AComparer: IEqualityComparer<T>): Boolean;
begin
  Result := AComparer.Equals(Items[Y,X], AItem);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.Fill(const AValue: T);
var
  Y,X: Integer;
begin
  for Y:=0 to GetHeight-1 do
    for X:=0 to GetWidth-1 do SetItem(X, Y, AValue);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.FillColumn(const AColumn: Integer; const AValue: T);
var
  aY,aX: Integer;
begin
  for aY:=0 to GetHeight-1 do begin
    for aX:=0 to GetWidth-1 do begin
      if aX = aColumn then Items[aY,aX] := aValue;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.GetData(var AData: TArray<TArray<T>>);
var
  Y, X, i: Integer;

begin
  SetLength(AData, GetHeight);
  for i:=0 to GetHeight-1 do SetLength(AData[i], GetWidth);

  for Y:=0 to GetHeight-1 do
    for X:=0 to GetWidth-1 do
      AData[Y,X] := Items[Y,X];

end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetHeight: Integer;
begin
  Result := Length(Items);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetItem(X, Y: Integer): T;
begin
  Result := Items[Y,X];
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetMaxLength(AData: TArray<TArray<T>>): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i:=0 to Length(AData)-1 do
    if Length(AData[i]) > Result then Result := Length(AData[i]);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetRow(const ARow: Integer): TArray<T>;
begin
  if RowExists(ARow) then Result := Items[ARow];
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetSize: UInt64;
begin
  Result := GetHeight * GetWidth;
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.GetWidth: Integer;
begin
  if GetHeight > 0 then Result := Length(Items[0]) else Result := 0;
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.MultiplyX(const AFactor: Integer);
var
  i, AX: Integer;
  AResult: IMatrix<T>;
  AY: Integer;

begin
  if AFactor < 1 then
    raise Exception.Create('Multiply Factor can not be < 1');

  if AFactor = 1 then Exit;

  AResult := Clone;
  AResult.Width := AResult.Width * AFactor;

  for AX:=0 to GetWidth-1 do begin
    for i:=0 to AFactor-1 do begin
      for AY:=0 to GetHeight-1 do
        AResult[(AX*AFactor)+i,AY] := GetItem(AX, AY);
    end;
  end;

  AResult.GetData(Items);

end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.PasteRow(const X, Y: Integer; const ARow: TArray<T>);
var
  aX: Integer;

begin
  if (Y < 0) or (Y >= GetHeight) then Exit;

  for aX:=0 to Length(ARow)-1 do begin
    if (aX+X) < 0 then Continue;
    if (aX+X) >= GetWidth then Break;

    Items[Y,aX+X] := ARow[aX];

  end;

end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.PositionOf(AItem: T): TPoint;
var
  AComparer: IEqualityComparer<T>;
begin
  Result := PositionOf(AItem, TEqualityComparer<T>.Default);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.PositionOf(AItem: T; AComparer: IEqualityComparer<T>): TPoint;
var
  X,Y: Integer;
  ARow: IReadOnlyArray<T>;
  ABrowser: IArrayBrowser<T>;

begin
  Result.X := -1;
  Result.Y := -1;

  ABrowser := TArrays.NewBrowser<T>(AComparer);

  for Y:=0 to GetHeight-1 do begin
    ARow := TArrays.NewArray<T>(GetRow(Y));
    X := ARow.FirstIndexOf(AItem, ABrowser);
    if X >= 0 then begin
      Result.X := X;
      Result.Y := Y;
      Break;
    end;
  end;

end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.RotateRight;
var
  AResult: IMatrix<T>;
  aX,aY: Integer;

begin
  AResult := TMatrices.NewMatrix<T>(GetHeight, GetWidth);

  for aY:=0 to AResult.Height-1 do begin
    for aX:=0 to AResult.Width-1 do
      AResult[aX,aY] := Items[AResult.Width-aX-1, aY];
  end;

  AResult.GetData(Items);

end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.RotateLeft;
var
  AResult: IMatrix<T>;
  aX,aY: Integer;

begin
  AResult := TMatrices.NewMatrix<T>(GetHeight, GetWidth);

  for aY:=0 to AResult.Height-1 do begin
    for aX:=0 to AResult.Width-1 do
      AResult[aX,aY] := Items[aX, AResult.Height-aY-1];
  end;

  AResult.GetData(Items);

end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.RotateUpsideDown;
var
  aX,aY: Integer;
  AResult: IMatrix<T>;

begin
  AResult := TMatrices.NewMatrix<T>(GetWidth, GetHeight);

  for aY:=0 to AResult.Height-1 do begin
    for aX:=0 to AResult.Width-1 do
      AResult[aX,aY] := Items[AResult.Height-aY-1, AResult.Width-aX-1];
  end;

  AResult.GetData(Items);

end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.RowExists(const ARow: Integer): Boolean;
begin
  Result := (ARow >= 0) and (ARow < GetHeight);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.SetData(AData: TArray<TArray<T>>);
var
  Y,X: Integer;

begin
  SetSize(GetMaxLength(AData), Length(AData));
  for Y:=0 to Length(AData)-1 do
    for X:=0 to Length(AData[Y])-1 do
      Items[Y,X] := AData[Y,X];

end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.SetHeight(const AHeight: Integer);
var
  AWidth,i: Integer;
begin
  AWidth := GetWidth;
  SetLength(Items, AHeight);
  SetWidth(AWidth);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.SetItem(X, Y: Integer; AValue: T);
begin
  Items[Y,X] := AValue;
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.SetSize(const AWidth, AHeight: Integer);
begin
  SetHeight(AHeight);
  SetWidth(AWidth);
end;

//------------------------------------------------------------------------------
procedure TMatrixOf<T>.SetWidth(const AWidth: Integer);
var
  i: Integer;
begin
  for i:=0 to Length(Items)-1 do SetLength(Items[i], AWidth);
end;

//------------------------------------------------------------------------------
function TMatrixOf<T>.AsStr(AConverter: IMatrixToStr<T>): string;
begin
  Result := AConverter.Convert(Items);
end;

//==============================================================================
{ TMatrices }

class function TMatrices.NewMatrix<T>: TMatrixOf<T>;
begin
  Result := TMatrixOf<T>.Create;
end;

//------------------------------------------------------------------------------
class function TMatrices.NewMatrix<T>(const AWidth, AHeight: Integer): TMatrixOf<T>;
begin
  Result := TMatrixOf<T>.Create(AWidth, AHeight);
end;

//------------------------------------------------------------------------------
class function TMatrices.NewBoolMatrix: TBoolMatrix;
begin
  Result := TBoolMatrix.Create;
end;

//------------------------------------------------------------------------------
class function TMatrices.NewBoolMatrix(const AWidth,
  AHeight: Integer): TBoolMatrix;
begin
  Result := TBoolMatrix.Create(AWidth, AHeight);
end;

//------------------------------------------------------------------------------
class function TMatrices.NewBoolMatrix(AData: TArray<TArray<Boolean>>): TBoolMatrix;
begin
  Result := TBoolMatrix.Create(AData);
end;

//------------------------------------------------------------------------------
class function TMatrices.NewMatrix<T>(AData: TArray<TArray<T>>): TMatrixOf<T>;
begin
  Result := TMatrixOf<T>.Create(AData);
end;

//------------------------------------------------------------------------------
class function TMatrices.NewMatrixToStr<T>(
  AItemConverter: IValueToStr<T>): TMatrixToStr<T>;
begin
  Result := TMatrixToStr<T>.Create(AItemConverter);
end;

//------------------------------------------------------------------------------
class function TMatrices.NewMatrixToStr<T>: TMatrixToStr<T>;
begin
  Result := TMatrixToStr<T>.Create;
end;

//==============================================================================
{ TBoolMatrix }

procedure TBoolMatrix.AndMask(const X,Y: Integer; AMask: TArray<TArray<Boolean>>);
begin
  Mask(X, Y, AMask, _AND);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.AndMask(const X,Y: Integer; AMask: IReadOnlyMatrix<Boolean>);
begin
  Mask(X, Y, AMask, _AND);
end;

//------------------------------------------------------------------------------
function TBoolMatrix.Clone: IBoolMatrix;
begin
  Result := TBoolMatrix.Create;
  CopyTo(Result);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.Invert;
var
  i: Integer;
  ARow: IBoolArray;

begin
  for i:=0 to GetHeight-1 do begin
    ARow := TArrays.NewBoolArray(GetRow(i));
    ARow.Invert;
    PasteRow(0,i,ARow.Data);
  end;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.Mask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>;
  const AOperation: TBoolOperationType);
var
  AMaskData: TArray<TArray<Boolean>>;
begin
  AMask.GetData(AMaskData);
  Mask(X, Y, AMaskData, AOperation);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.Mask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>;
  const AOperation: TBoolOperationType);
var
  aY: Integer;
  AMaskRow: TArray<Boolean>;
  ARow: IBoolArray;

begin
  for aY:=0 to Length(AMask)-1 do begin

    if (aY + Y) >= GetHeight then Break;
    if (aY + Y) < 0 then Continue;

    AMaskRow := AMask[aY];
    ARow := TArrays.NewBoolArray(GetRow(aY+Y));

    ARow.Mask(AMaskRow, X, AOperation);

    PasteRow(0, aY+Y, ARow.Data);

  end;

end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.OrMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>);
begin
  Mask(X, Y, AMask, _OR);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.XorMask(const X, Y: Integer; AMask: IReadOnlyMatrix<Boolean>);
begin
  Mask(X, Y, AMask, _XOR);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.XorMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>);
begin
  Mask(X, Y, AMask, _XOR);
end;

//------------------------------------------------------------------------------
procedure TBoolMatrix.OrMask(const X, Y: Integer; AMask: TArray<TArray<Boolean>>);
begin
  Mask(X, Y, AMask, _OR);
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TBoolMatrix>.
    Implements<IBoolMatrix>.
    Implements<IReadOnlyBoolMatrix>;

end.
