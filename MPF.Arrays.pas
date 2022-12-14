unit MPF.Arrays;
interface uses System.Generics.Defaults, MPF.Types, MPF.Converters;

//==============================================================================
type
  IArraySorter<T> = interface;
  IArrayBrowser<T> = interface;
  IArrayToStr<T> = interface;
  TArrayOf<T> = class;

//------------------------------------------------------------------------------
  IReadOnlyArray<T> = interface['{11D9911F-9AD8-41FA-97C5-D79EFDA2156A}']
    function GetSize: Integer;
    function GetItem(Index: Integer): T;
    function GetData: TArray<T>;
    function AsStr(AConverter: IArrayToStr<T>): string;
    function FirstIndexOf(AItem: T; ABrowser: IArrayBrowser<T>): Integer;

    property Size: Integer read GetSize;
    property Items[Index: Integer]: T read GetItem; default;
    property Data: TArray<T> read GetData;

  end;

//------------------------------------------------------------------------------
  IArray<T> = interface(IReadOnlyArray<T>)['{D8956F89-2D39-4584-8F82-C12C08DBE43D}']
    procedure SetItem(Index: Integer; AItem: T);
    procedure Clear;
    procedure SetData(const AData: TArray<T>);
    procedure Sort(ASorter: IArraySorter<T>); overload;
    procedure Sort(AComparison: TComparison<T>); overload;
    procedure Sort; overload;
    procedure SetSize(const ASize: Integer);
    procedure Fill(AValue: T);

    property Size: Integer read GetSize write SetSize;
    property Items[Index: Integer]: T read GetItem write SetItem; default;
    property Data: TArray<T> read GetData write SetData;

  end;

//------------------------------------------------------------------------------
  IReadOnlyBoolArray = interface(IReadOnlyArray<Boolean>)['{872A82E3-4311-4E13-9A80-95446734598C}']
  end;

//------------------------------------------------------------------------------
  IBoolArray = interface(IArray<Boolean>)['{D358446B-438C-4997-9C76-46607CEBDAF5}']
    procedure Mask(const AMask: TArray<Boolean>; const AOffset: Integer; const AOperation: TBoolOperationType);
    procedure AndMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure AndMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure OrMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure OrMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure XorMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure XorMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure Invert;
  end;

//------------------------------------------------------------------------------
  IArrayBrowser<T> = interface['{4CB32596-0B54-4E33-A209-A8D1C3503BB5}']
    function CountOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function CountOf(const AItem: T): Integer; overload;
    function FirstIndexOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function FirstIndexOf(const AItem: T): Integer; overload;
    function LastIndexOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function LastIndexOf(const AItem: T): Integer; overload;
    function Exists(const AItem: T; const AArray: IReadOnlyArray<T>): Boolean;
    procedure SetData(AData: IReadOnlyArray<T>);

    property Data: IReadOnlyArray<T> write SetData;

  end;

//------------------------------------------------------------------------------
  IArraySorter<T> = interface['{1342DA44-AE84-48B0-B014-6B17FA5E4FD0}']
    procedure Sort(AArray: IArray<T>); overload;
    function GetSorted(AArray: IReadOnlyArray<T>): TArrayOf<T>; overload;
  end;

//------------------------------------------------------------------------------
  IArrayToStr<T> = interface(IToStr)['{984BE523-034B-495B-9BC1-BC99601CCBEA}']
    function Convert(AData: TArray<T>): string; overload;
    function GetSeparator: string;
    procedure SetSeparator(const AValue: string);
    function GetItemConverter: IValueToStr<T>;
    procedure SetItemConverter(AConverter: IValueToStr<T>);

    property Separator: string read GetSeparator write SetSeparator;
    property ItemConverter: IValueToStr<T> read GetItemConverter write SetItemConverter;

  end;

//------------------------------------------------------------------------------
  TArrayOf<T> = class(TInterfacedObject, IArray<T>, IReadOnlyArray<T>)
  strict private
    Items: TArray<T>;

    procedure Clear;
    procedure Sort(ASorter: IArraySorter<T>); overload;
    procedure Sort(AComparison: TComparison<T>); overload;
    procedure Sort; overload;
    procedure SetSize(const ASize: Integer);
    function AsStr(AConverter: IArrayToStr<T>): string;
    procedure Fill(AValue: T);
    function FirstIndexOf(AItem: T; ABrowser: IArrayBrowser<T>): Integer;

  strict protected
    function GetSize: Integer;
    function GetItem(Index: Integer): T;
    procedure SetItem(Index: Integer; AItem: T);
    function GetData: TArray<T>;
    procedure SetData(const AData: TArray<T>);

  public
    constructor Create(const AData: TArray<T>); overload;
    constructor Create(const ASize: Integer); overload;

  end;

//------------------------------------------------------------------------------
  TBoolArray = class(TArrayOf<Boolean>, IBoolArray, IReadOnlyBoolArray)
  strict private
    procedure Mask(const AMask: TArray<Boolean>; const AOffset: Integer; const AOperation: TBoolOperationType);
    procedure AndMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure AndMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure OrMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure OrMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure XorMask(const AMask: TArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure XorMask(const AMask: IReadOnlyArray<Boolean>; const AOffset: Integer = 0); overload;
    procedure Invert;
  end;

//------------------------------------------------------------------------------
  TArrayBrowser<T> = class(TInterfacedObject, IArrayBrowser<T>)
  strict private
    Comparer: IEqualityComparer<T>;
    Data: IReadOnlyArray<T>;
    function CountOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function CountOf(const AItem: T): Integer; overload;
    function FirstIndexOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function FirstIndexOf(const AItem: T): Integer; overload;
    function LastIndexOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer; overload;
    function LastIndexOf(const AItem: T): Integer; overload;
    function Exists(const AItem: T; const AArray: IReadOnlyArray<T>): Boolean;
    procedure SetData(AData: IReadOnlyArray<T>);

  public
    constructor Create; overload;
    constructor Create(AComparer: IEqualityComparer<T>); overload;

  end;

//------------------------------------------------------------------------------
  TArraySorter<T> = class(TInterfacedObject, IArraySorter<T>)
  strict private
    Comparer: IComparer<T>;
    procedure Sort(AArray: IArray<T>); overload;
    function GetSorted(AArray: IReadOnlyArray<T>): TArrayOf<T>; overload;
  public
    constructor Create; overload;
    constructor Create(AComparer: IComparer<T>); overload;
    constructor Create(AComparison: TComparison<T>); overload;
  end;

//------------------------------------------------------------------------------
  TArrayToStr<T> = class(TToStr, IArrayToStr<T>)
  strict private
    Separator: string;
    ItemConverter: IValueToStr<T>;

    function Convert(AData: TArray<T>): string; overload;
    function GetSeparator: string;
    procedure SetSeparator(const AValue: string);
    function GetItemConverter: IValueToStr<T>;
    procedure SetItemConverter(AConverter: IValueToStr<T>);

  public
    constructor Create; override;
    constructor Create(AItemConverter: IValueToStr<T>); overload;
    constructor Create(const ASeparator: string; AItemConverter: IValueToStr<T>); overload;
    constructor Create(const APrefix, ASeparator, ASuffix: string;
      AItemConverter: IValueToStr<T>); overload;

  end;


//------------------------------------------------------------------------------
  TBoolOperation = class
    class function Get(const AArray1: TArray<Boolean>; const AOperation: TBoolOperationType;
      const AArray2: TArray<Boolean>): TArray<Boolean>; overload;

    class function Get(const AArray1: IReadOnlyArray<Boolean>; const AOperation: TBoolOperationType;
      const AArray2: IReadOnlyArray<Boolean>): TBoolArray; overload;

    class function Get(const AValue1: Boolean; const AOperation: TBoolOperationType;
      const AValue2: Boolean): Boolean; overload;

    class function Invert(const AArray: TArray<Boolean>): TArray<Boolean>;

  end;

//==============================================================================
  TArrays = class
    class function NewArray<T>: TArrayOf<T>; overload;
    class function NewArray<T>(const AData: TArray<T>): TArrayOf<T>; overload;
    class function NewArray<T>(const ASize: Integer): TArrayOf<T>; overload;
    class function NewArray<T>(ASource: IReadOnlyArray<T>): TArrayOf<T>; overload;

    class function NewBoolArray: TBoolArray; overload;
    class function NewBoolArray(const AData: TArray<Boolean>): TBoolArray; overload;
    class function NewBoolArray(const ASize: Integer): TBoolArray; overload;
    class function NewBoolArray(ASource: IReadOnlyArray<Boolean>): TBoolArray; overload;

    class function NewBrowser<T>: TArrayBrowser<T>; overload;
    class function NewBrowser<T>(AComparer: IEqualityComparer<T>): TArrayBrowser<T>; overload;
    class function NewSorter<T>: IArraySorter<T>; overload;
    class function NewSorter<T>(AComparison: TComparison<T>): IArraySorter<T>; overload;

    class function NewArrayToStr<T>: TArrayToStr<T>; overload;
    class function NewArrayToStr<T>(AItemConverter: IValueToStr<T>): TArrayToStr<T>; overload;

    class function NewArrayToStr<T>(const ASeparator: string;
      AItemConverter: IValueToStr<T>): TArrayToStr<T>; overload;

    class function NewArrayToStr<T>(const APrefix, ASeparator, ASuffix: string;
      AItemConverter: IValueToStr<T>): TArrayToStr<T>; overload;

    class function NewBytesFromString(const AString: string): TArrayOf<Byte>;

  end;

//==============================================================================
implementation uses SysUtils, System.Generics.Collections, Math, Spring.Container;

//==============================================================================
{ TArrayOf<T> }

function TArrayOf<T>.AsStr(AConverter: IArrayToStr<T>): string;
begin
  Result := AConverter.Convert(Items);
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.Clear;
begin
  Items := [];
end;

//------------------------------------------------------------------------------
constructor TArrayOf<T>.Create(const AData: TArray<T>);
begin
  Create;
  SetData(AData);
end;

//------------------------------------------------------------------------------
function TArrayOf<T>.GetSize: Integer;
begin
  Result := Length(Items);
end;

//------------------------------------------------------------------------------
constructor TArrayOf<T>.Create(const ASize: Integer);
begin
  inherited Create;
  SetSize(ASize);
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.Fill(AValue: T);
var
  i: Integer;
begin
  for i:=0 to GetSize-1 do Items[i] := AValue;
end;

//------------------------------------------------------------------------------
function TArrayOf<T>.FirstIndexOf(AItem: T; ABrowser: IArrayBrowser<T>): Integer;
begin
  Result := ABrowser.FirstIndexOf(AItem, Self);
end;

//------------------------------------------------------------------------------
function TArrayOf<T>.GetData: TArray<T>;
begin
  Result := Items;
end;

//------------------------------------------------------------------------------
function TArrayOf<T>.GetItem(Index: Integer): T;
begin
  Result := Items[Index];
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.SetData(const AData: TArray<T>);
begin
  Items := AData;
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.SetItem(Index: Integer; AItem: T);
begin
  Items[Index] := AItem;
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.SetSize(const ASize: Integer);
begin
  SetLength(Items, ASize);
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.Sort;
var
  AComparer: IComparer<T>;
begin
  AComparer := TComparer<T>.Default;
  TArray.Sort<T>(Items, AComparer);
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.Sort(AComparison: TComparison<T>);
var
  AComparer: IComparer<T>;
begin
  AComparer := TComparer<T>.Construct(AComparison);
  TArray.Sort<T>(Items, AComparer);
end;

//------------------------------------------------------------------------------
procedure TArrayOf<T>.Sort(ASorter: IArraySorter<T>);
begin
  ASorter.Sort(Self);
end;

//==============================================================================
{ TArrays }

class function TArrays.NewArray<T>(const AData: TArray<T>): TArrayOf<T>;
begin
  Result := TArrayOf<T>.Create(AData);
end;

//------------------------------------------------------------------------------
class function TArrays.NewArray<T>(const ASize: Integer): TArrayOf<T>;
begin
  Result := TArrayOf<T>.Create(ASize);
end;

//------------------------------------------------------------------------------
class function TArrays.NewBoolArray: TBoolArray;
begin
  Result := TBoolArray.Create;
end;

//------------------------------------------------------------------------------
class function TArrays.NewBoolArray(const AData: TArray<Boolean>): TBoolArray;
begin
  Result := TBoolArray.Create(AData);
end;

//------------------------------------------------------------------------------
class function TArrays.NewBoolArray(const ASize: Integer): TBoolArray;
begin
  Result := TBoolArray.Create(ASize);
end;

//------------------------------------------------------------------------------
class function TArrays.NewBrowser<T>(AComparer: IEqualityComparer<T>): TArrayBrowser<T>;
begin
  Result := TArrayBrowser<T>.Create(AComparer);
end;

//------------------------------------------------------------------------------
class function TArrays.NewBytesFromString(const AString: string): TArrayOf<Byte>;
var
  AData: TBytes;
  i: Integer;
begin
  for i:=1 to Length(AString) do AData := AData + [Byte(AString[i])];
  Result := NewArray<Byte>(AData);
end;

//------------------------------------------------------------------------------
class function TArrays.NewSorter<T>(AComparison: TComparison<T>): IArraySorter<T>;
begin
  Result := TArraySorter<T>.Create(AComparison);
end;

//------------------------------------------------------------------------------
class function TArrays.NewSorter<T>: IArraySorter<T>;
begin
  Result := TArraySorter<T>.Create;
end;

//------------------------------------------------------------------------------
class function TArrays.NewBrowser<T>: TArrayBrowser<T>;
begin
  Result := TArrayBrowser<T>.Create;
end;

//------------------------------------------------------------------------------
class function TArrays.NewArray<T>: TArrayOf<T>;
begin
  Result := TArrayOf<T>.Create;
end;

//------------------------------------------------------------------------------
class function TArrays.NewArrayToStr<T>: TArrayToStr<T>;
begin
  Result := TArrayToStr<T>.Create;
end;

//------------------------------------------------------------------------------
class function TArrays.NewArrayToStr<T>(
  AItemConverter: IValueToStr<T>): TArrayToStr<T>;
begin
  Result := TArrayToStr<T>.Create(AItemConverter);
end;

//------------------------------------------------------------------------------
class function TArrays.NewArrayToStr<T>(const ASeparator: string;
  AItemConverter: IValueToStr<T>): TArrayToStr<T>;
begin
  Result := TArrayToStr<T>.Create(ASeparator, AItemConverter);
end;

//------------------------------------------------------------------------------
class function TArrays.NewArrayToStr<T>(const APrefix, ASeparator,
  ASuffix: string; AItemConverter: IValueToStr<T>): TArrayToStr<T>;
begin
  Result := TArrayToStr<T>.Create(APrefix, ASeparator, ASuffix, AItemConverter);
end;

//------------------------------------------------------------------------------
class function TArrays.NewArray<T>(ASource: IReadOnlyArray<T>): TArrayOf<T>;
begin
  Result := TArrayOf<T>.Create(ASource.Data);
end;

//------------------------------------------------------------------------------
class function TArrays.NewBoolArray(ASource: IReadOnlyArray<Boolean>): TBoolArray;
begin
  Result := NewBoolArray(ASource.Data);
end;

//==============================================================================
{ TBoolOperation }

class function TBoolOperation.Get(const AArray1: TArray<Boolean>;
  const AOperation: TBoolOperationType; const AArray2: TArray<Boolean>): TArray<Boolean>;
var
  AResultSize: Integer;
  i: Integer;

begin
  AResultSize := Min(Length(AArray1), Length(AArray2));
  SetLength(Result, AResultSize);
  for i:=0 to AResultSize-1 do
    case AOperation of
      _OR: Result[i] := AArray1[i] or AArray2[i];
      _AND: Result[i] := AArray1[i] and AArray2[i];
      _XOR: Result[i] := AArray1[i] xor AArray2[i];
    end;
end;

//------------------------------------------------------------------------------
class function TBoolOperation.Get(const AArray1: IReadOnlyArray<Boolean>;
  const AOperation: TBoolOperationType;
  const AArray2: IReadOnlyArray<Boolean>): TBoolArray;
var
  AResultData: TArray<Boolean>;
begin
  AResultData := Get(AArray1.Data, AOperation, AArray2.Data);
  Result := TArrays.NewBoolArray(AResultData);
end;

//------------------------------------------------------------------------------
class function TBoolOperation.Get(const AValue1: Boolean;
  const AOperation: TBoolOperationType; const AValue2: Boolean): Boolean;
begin
    case AOperation of
      _OR:  Result := AValue1 or AValue2;
      _AND: Result := AValue1 and AValue2;
      _XOR: Result := AValue1 xor AValue2;
    else
      Result := AValue1;
    end;
end;

//------------------------------------------------------------------------------
class function TBoolOperation.Invert(const AArray: TArray<Boolean>): TArray<Boolean>;
var
  i: Integer;
begin
  Result := AArray;
  for i:=0 to Length(Result)-1 do Result[i] := not Result[i];
end;

//==============================================================================
{ TBoolArray }

procedure TBoolArray.AndMask(const AMask: IReadOnlyArray<Boolean>;
  const AOffset: Integer);
begin
  AndMask(AMask.Data, AOffset);
end;

//------------------------------------------------------------------------------
procedure TBoolArray.Invert;
begin
  SetData( TBoolOperation.Invert(GetData) );
end;

//------------------------------------------------------------------------------
procedure TBoolArray.Mask(const AMask: TArray<Boolean>; const AOffset: Integer;
  const AOperation: TBoolOperationType);
var
  i: Integer;
  ANewValue: Boolean;

begin
  for i:=0 to Length(AMask)-1 do begin
    if (i + AOffset) >= GetSize then Break;
    if (i + AOffset) < 0 then Continue;

    ANewValue := TBoolOperation.Get( GetItem(i+AOffset), AOperation, AMask[i] );
    SetItem(i + AOffset, ANewValue);
  end;

end;

//------------------------------------------------------------------------------
procedure TBoolArray.OrMask(const AMask: IReadOnlyArray<Boolean>;
  const AOffset: Integer);
begin
  OrMask(AMask.Data, AOffset);
end;

//------------------------------------------------------------------------------
procedure TBoolArray.XorMask(const AMask: IReadOnlyArray<Boolean>;
  const AOffset: Integer);
begin
  XorMask(AMask.Data, AOffset);
end;

//------------------------------------------------------------------------------
procedure TBoolArray.XorMask(const AMask: TArray<Boolean>; const AOffset: Integer);
begin
  Mask(AMask, AOffset, _XOR);
end;

//------------------------------------------------------------------------------
procedure TBoolArray.OrMask(const AMask: TArray<Boolean>; const AOffset: Integer);
begin
  Mask(AMask, AOffset, _OR);
end;

//------------------------------------------------------------------------------
procedure TBoolArray.AndMask(const AMask: TArray<Boolean>;
  const AOffset: Integer);
begin
  Mask(AMask, AOffset, _AND);
end;



//==============================================================================
{ TArrayBrowser<T> }

function TArrayBrowser<T>.CountOf(const AItem: T; const AArray: IReadOnlyArray<T>): Integer;
var
  i: Integer;
begin
  if not Assigned(Comparer) then raise Exception.Create('No Comparer!');

  Result := 0;
  for i:=0 to AArray.Size-1 do
    if Comparer.Equals(AArray[i], AItem) then Result := Result + 1;

end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.CountOf(const AItem: T): Integer;
begin
  Result := CountOf(AItem, Data);
end;

//------------------------------------------------------------------------------
constructor TArrayBrowser<T>.Create(AComparer: IEqualityComparer<T>);
begin
  inherited Create;
  Comparer := AComparer;
end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.Exists(const AItem: T; const AArray: IReadOnlyArray<T>): Boolean;
begin
  Result := FirstIndexOf(AItem, AArray) >= 0;
end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.FirstIndexOf(const AItem: T): Integer;
begin
  Result := FirstIndexOf(AItem, Data);
end;

//------------------------------------------------------------------------------
constructor TArrayBrowser<T>.Create;
begin
  Create(TEqualityComparer<T>.Default);
end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.FirstIndexOf(const AItem: T;
  const AArray: IReadOnlyArray<T>): Integer;
var
  i: Integer;

begin
  Result := -1;

  if not Assigned(Comparer) then
    raise Exception.Create('No Comparer!');

  for i:=0 to AArray.Size-1 do
    if Comparer.Equals(AArray[i], AItem) then begin
      Result := i;
      Break;
    end;

end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.LastIndexOf(const AItem: T): Integer;
begin
  Result := LastIndexOf(AItem, Data);
end;

//------------------------------------------------------------------------------
function TArrayBrowser<T>.LastIndexOf(const AItem: T;
  const AArray: IReadOnlyArray<T>): Integer;
var
  i: Integer;

begin
  Result := -1;

  if not Assigned(Comparer) then
    raise Exception.Create('No Comparer!');


  for i:=AArray.Size-1 downto 0 do
    if Comparer.Equals(AArray[i], AItem) then begin
      Result := i;
      Break;
    end;

end;

//------------------------------------------------------------------------------
procedure TArrayBrowser<T>.SetData(AData: IReadOnlyArray<T>);
begin
  Data := AData;
end;

//==============================================================================
{ TArraySorter<T> }

constructor TArraySorter<T>.Create(AComparer: IComparer<T>);
begin
  inherited Create;
  Comparer := AComparer;
end;

//------------------------------------------------------------------------------
constructor TArraySorter<T>.Create(AComparison: TComparison<T>);
begin
  inherited Create;
  Comparer := TComparer<T>.Construct(AComparison);
end;

//------------------------------------------------------------------------------
constructor TArraySorter<T>.Create;
begin
  inherited;
  Comparer := TComparer<T>.Default;
end;

//------------------------------------------------------------------------------
function TArraySorter<T>.GetSorted(AArray: IReadOnlyArray<T>): TArrayOf<T>;
var
  AResult: IArray<T>;
begin
  AResult := TArrays.NewArray<T>(AArray.Data);
  Sort(AResult);
  Result := AResult as TArrayOf<T>;
end;

//------------------------------------------------------------------------------
procedure TArraySorter<T>.Sort(AArray: IArray<T>);
begin
  TArray.Sort<T>(AArray.Data, Comparer);
end;

//==============================================================================
{ TArrayToStr<T> }

function TArrayToStr<T>.Convert(AData: TArray<T>): string;
var
  i: Integer;

begin
  if not Assigned(ItemConverter) then
    raise Exception.Create('No Item Converter!');

  Result := GetPrefix;

  for i:=0 to Length(AData)-1 do begin
    Result := Result + ItemConverter.Convert(AData[i]);
    if i < (Length(AData) - 1) then Result := Result + Separator;
  end;

  Result := Result + GetSuffix;
end;

//------------------------------------------------------------------------------
constructor TArrayToStr<T>.Create;
begin
  inherited Create('[',']');
  Separator := ' ';
end;

//------------------------------------------------------------------------------
constructor TArrayToStr<T>.Create(AItemConverter: IValueToStr<T>);
begin
  Create;
  ItemConverter := AItemConverter;
end;

//------------------------------------------------------------------------------
constructor TArrayToStr<T>.Create(const ASeparator: string;
  AItemConverter: IValueToStr<T>);
begin
  Create(AItemConverter);
  Separator := ASeparator;
end;

//------------------------------------------------------------------------------
function TArrayToStr<T>.GetItemConverter: IValueToStr<T>;
begin
  Result := ItemConverter;
end;

//------------------------------------------------------------------------------
function TArrayToStr<T>.GetSeparator: string;
begin
  Result := Separator;
end;

//------------------------------------------------------------------------------
procedure TArrayToStr<T>.SetItemConverter(AConverter: IValueToStr<T>);
begin
  ItemConverter := AConverter;
end;

//------------------------------------------------------------------------------
procedure TArrayToStr<T>.SetSeparator(const AValue: string);
begin
  Separator := AValue;
end;

//------------------------------------------------------------------------------
constructor TArrayToStr<T>.Create(const APrefix, ASeparator, ASuffix: string;
  AItemConverter: IValueToStr<T>);
begin
  Create(ASeparator, AItemConverter);
  SetPrefix(APrefix);
  SetSuffix(ASuffix);
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TBoolArray>.
    Implements<IBoolArray>.
    Implements<IReadOnlyBoolArray>;


end.

