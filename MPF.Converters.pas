unit MPF.Converters;
interface

//==============================================================================
type
  IToStr = interface['{0825B399-348B-4D99-8D8E-E77D1A840C30}']
    function GetPrefix: string;
    procedure SetPrefix(const AValue: string);
    function GetSuffix: string;
    procedure SetSuffix(const AValue: string);

    property Prefix: string read GetPrefix write SetPrefix;
    property Suffix: string read GetSuffix write SetSuffix;

  end;

//------------------------------------------------------------------------------
  IValueToStr<T> = interface(IToStr)['{B3C17985-E954-4B59-B42F-1487367657CF}']
    function Convert(const AValue: T): string;
  end;

//------------------------------------------------------------------------------
  IMatrixToStr<T> = interface(IToStr)['{96F386D6-B018-4F42-9A85-445EE8BB9634}']
    function Convert(AData: TArray<TArray<T>>): string;
    function GetItemConverter: IValueToStr<T>;
    procedure SetItemConverter(const AItemConverter: IValueToStr<T>);
    function GetRowSeparator: string;
    procedure SetRowSeparator(const AValue: string);
    function GetColSeparator: string;
    procedure SetColSeparator(const AValue: string);

    property ItemConverter: IValueToStr<T> read GetItemConverter write SetItemConverter;
    property RowSeparator: string read GetRowSeparator write SetRowSeparator;
    property ColSeparator: string read GetColSeparator write SetColSeparator;

  end;

//------------------------------------------------------------------------------
  TToStr = class(TInterfacedObject)
  strict private
    Prefix: string;
    Suffix: string;

  strict protected
    function GetPrefix: string;
    procedure SetPrefix(const AValue: string);
    function GetSuffix: string;
    procedure SetSuffix(const AValue: string);

  public
    constructor Create; overload; virtual;
    constructor Create(const APrefix, ASuffix: string); overload; virtual;

  end;

//------------------------------------------------------------------------------
  TValueToStr<T> = class(TToStr)
  strict protected
    function Convert(const AValue: T): string; virtual;
    function ConvertValue(const AValue: T): string; virtual; abstract;
  end;

//------------------------------------------------------------------------------
  TByteToStr = class(TValueToStr<Byte>, IValueToStr<Byte>)
  strict protected
    function ConvertValue(const AValue: Byte): string; override;
  end;

//------------------------------------------------------------------------------
  TByteToHex = class(TValueToStr<Byte>, IValueToStr<Byte>)
  strict protected
    function ConvertValue(const AValue: Byte): string; override;
  end;

//------------------------------------------------------------------------------
  TBoolToStr = class(TValueToStr<Boolean>, IValueToStr<Boolean>)
  strict private
    FalseStr: string;
    TrueStr: string;
  strict protected
    function ConvertValue(const AValue: Boolean): string; override;
  public
    constructor Create; override;
    constructor Create(const AFalseStr, ATrueStr: string); reintroduce; overload;
    constructor Create(const APrefix, AFalseStr, ATrueStr, ASuffix: string); reintroduce; overload;
  end;

//------------------------------------------------------------------------------
  TMatrixToStr<T> = class(TToStr, IMatrixToStr<T>)
  strict private
    RowSeparator: string;
    ColSeparator: string;
    ItemConverter: IValueToStr<T>;
    function Convert(AData: TArray<TArray<T>>): string;
    function GetItemConverter: IValueToStr<T>;
    procedure SetItemConverter(const AItemConverter: IValueToStr<T>);
    function GetRowSeparator: string;
    procedure SetRowSeparator(const AValue: string);
    function GetColSeparator: string;
    procedure SetColSeparator(const AValue: string);
  public
    constructor Create; override;
    constructor Create(AItemConverter: IValueToStr<T>); overload;
  end;

//==============================================================================
  TConverters = class
    class function NewByteToStr: TByteToStr; overload;
    class function NewByteToStr(const APrefix, ASuffix: string): TByteToStr; overload;

    class function NewByteToHex: TByteToHex; overload;
    class function NewByteToHex(const APrefix, ASuffix: string): TByteToHex; overload;

    class function NewBoolToStr: TBoolToStr; overload;
    class function NewBoolToStr(const AFalseStr, ATrueStr: string): TBoolToStr; overload;
    class function NewBoolToStr(const APrefix, AFalseStr, ATrueStr, ASuffix: string): TBoolToStr; overload;

  end;

//==============================================================================
implementation uses SysUtils, Spring.Container;


//==============================================================================
{ TToStr }

constructor TToStr.Create(const APrefix, ASuffix: string);
begin
  inherited Create;
  Prefix := APrefix;
  Suffix := ASuffix;
end;

//------------------------------------------------------------------------------
constructor TToStr.Create;
begin
  inherited;
  Prefix := '';
  Suffix := '';
end;

//------------------------------------------------------------------------------
function TToStr.GetPrefix: string;
begin
  Result := Prefix;
end;

//------------------------------------------------------------------------------
function TToStr.GetSuffix: string;
begin
  Result := Suffix;
end;

//------------------------------------------------------------------------------
procedure TToStr.SetPrefix(const AValue: string);
begin
  Prefix := AValue;
end;

//------------------------------------------------------------------------------
procedure TToStr.SetSuffix(const AValue: string);
begin
  Suffix := AValue;
end;

//==============================================================================
{ TConverters }

class function TConverters.NewBoolToStr: TBoolToStr;
begin
  Result := TBoolToStr.Create;
end;

//------------------------------------------------------------------------------
class function TConverters.NewBoolToStr(const AFalseStr,
  ATrueStr: string): TBoolToStr;
begin
  Result := TBoolToStr.Create(AFalseStr, ATrueStr);
end;

//------------------------------------------------------------------------------
class function TConverters.NewBoolToStr(const APrefix, AFalseStr, ATrueStr,
  ASuffix: string): TBoolToStr;
begin
  Result := TBoolToStr.Create(APrefix, AFalseStr, ATrueStr, ASuffix);
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToHex(const APrefix, ASuffix: string): TByteToHex;
begin
  Result := TByteToHex.Create(APrefix, ASuffix);
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToHex: TByteToHex;
begin
  Result := TByteToHex.Create;
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToStr(const APrefix, ASuffix: string): TByteToStr;
begin
  Result := TByteToStr.Create(APrefix, ASuffix);
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToStr: TByteToStr;
begin
  Result := TByteToStr.Create;
end;

//==============================================================================
{ TByteToStr }

function TByteToStr.ConvertValue(const AValue: Byte): string;
begin
  Result := AValue.ToString;
end;

//==============================================================================
{ TValueToStr<T> }

function TValueToStr<T>.Convert(const AValue: T): string;
begin
  Result := GetPrefix + ConvertValue(AValue) + GetSuffix;
end;

//==============================================================================
{ TMatrixToStr<T> }

function TMatrixToStr<T>.Convert(AData: TArray<TArray<T>>): string;
var
  X,Y: Integer;

begin
  Result := GetPrefix;

  for Y:=0 to Length(AData)-1 do begin

    for X:=0 to Length(AData[Y])-1 do begin
      Result := Result + ItemConverter.Convert(AData[Y,X]);
      if X < (Length(AData[Y])-1) then Result := Result + ColSeparator;
    end;

    if Y < (Length(AData)-1) then Result := Result + RowSeparator;

  end;

  Result := Result + GetSuffix;

end;

//------------------------------------------------------------------------------
constructor TMatrixToStr<T>.Create;
begin
  inherited Create;
  RowSeparator := #13;
  ColSeparator := ' ';
end;

//------------------------------------------------------------------------------
constructor TMatrixToStr<T>.Create(AItemConverter: IValueToStr<T>);
begin
  Create;
  ItemConverter := AItemConverter;
end;

//------------------------------------------------------------------------------
function TMatrixToStr<T>.GetColSeparator: string;
begin
  Result := ColSeparator;
end;

//------------------------------------------------------------------------------
function TMatrixToStr<T>.GetItemConverter: IValueToStr<T>;
begin
  Result := ItemConverter;
end;

//------------------------------------------------------------------------------
function TMatrixToStr<T>.GetRowSeparator: string;
begin
  Result := RowSeparator;
end;

//------------------------------------------------------------------------------
procedure TMatrixToStr<T>.SetColSeparator(const AValue: string);
begin
  ColSeparator := AValue;
end;

//------------------------------------------------------------------------------
procedure TMatrixToStr<T>.SetItemConverter(const AItemConverter: IValueToStr<T>);
begin
  ItemConverter := AItemConverter;
end;

//------------------------------------------------------------------------------
procedure TMatrixToStr<T>.SetRowSeparator(const AValue: string);
begin
  RowSeparator := AValue;
end;

//==============================================================================
{ TBoolToStr }

function TBoolToStr.ConvertValue(const AValue: Boolean): string;
begin
  if AValue then Result := TrueStr else Result := FalseStr;
end;

//------------------------------------------------------------------------------
constructor TBoolToStr.Create(const AFalseStr, ATrueStr: string);
begin
  inherited Create;
  FalseStr := AFalseStr;
  TrueStr := ATrueStr;
end;

//------------------------------------------------------------------------------
constructor TBoolToStr.Create(const APrefix, AFalseStr, ATrueStr, ASuffix: string);
begin
  inherited Create(APrefix, ASuffix);
  FalseStr := AFalseStr;
  TrueStr := ATrueStr;
end;

//------------------------------------------------------------------------------
constructor TBoolToStr.Create;
begin
  Create('FALSE','TRUE');
end;

//==============================================================================
{ TByteToHex }

function TByteToHex.ConvertValue(const AValue: Byte): string;
begin
  Result := AValue.ToHexString;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TByteToStr>.
    Implements<IValueToStr<Byte>>('DEC').AsDefault;

  GlobalContainer.RegisterType<TByteToHex>.
    Implements<IValueToStr<Byte>>('HEX');

  GlobalContainer.RegisterType<TBoolToStr>.
    Implements<IValueToStr<Boolean>>;

end.
