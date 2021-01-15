unit _MPF.Converters;
interface

//==============================================================================
type
  IToStrConverter<T> = interface['{37A17E1E-72D3-48D7-9810-2D84CD1DA0F9}']
    function GetPrefix: string;
    procedure SetPrefix(const APrefix: string);
    function GetSuffix: string;
    procedure SetSuffix(const ASuffix: string);
    property Prefix: string read GetPrefix write SetPrefix;
    property Suffix: string read GetSuffix write SetSuffix;
  end;

//------------------------------------------------------------------------------
  IValueToStrConverter<T> = interface(IToStrConverter<T>)['{C5458C00-20E8-40C6-B8CF-0E577E29FC28}']
    function Convert(const AValue: T): string;
  end;

//------------------------------------------------------------------------------
  IBoolToStrConverter = IToStrConverter<Boolean>;
  IByteToStrConverter = IValueToStrConverter<Byte>;

//------------------------------------------------------------------------------
  IArrayToStrConverter<T> = interface(IToStrConverter<T>)['{84E11968-8844-4913-8F5D-FC33472328A6}']
    function Convert(AArray: TArray<T>): string;
  end;

//------------------------------------------------------------------------------
  TToStrConverter<T> = class(TInterfacedObject, IToStrConverter<T>)
  strict private
    Prefix: string;
    Suffix: string;
    procedure SetPrefix(const APrefix: string);
    procedure SetSuffix(const ASuffix: string);
  strict protected
    function GetPrefix: string;
    function GetSuffix: string;
  public
    constructor Create;  overload; virtual;
    constructor Create(const APrefix, ASuffix: string); overload; virtual;
  end;

//------------------------------------------------------------------------------
  TValueToStrConverter<T> = class(TToStrConverter<T>, IValueToStrConverter<T>)
  strict private
    function Convert(const AValue: T): string;
  strict protected
    function ConvertValue(const AValue: T): string; virtual; abstract;
  end;

//------------------------------------------------------------------------------
  TBoolToStrConverter = class(TValueToStrConverter<Boolean>, IBoolToStrConverter)
  strict private
    FalseString: string;
    TrueString: string;
  strict protected
    function ConvertValue(const AValue: Boolean): string; override;
  public
    constructor Create; overload; override;
    constructor Create(const APrefix, AFalseString, ATrueString, ASuffix: string); reintroduce; overload;
  end;

//------------------------------------------------------------------------------
  TIntToStrConverter<T: record> = class(TValueToStrConverter<T>)
  strict private
    MaxLength: Integer;
    function InsertLeadingZeros(const AStrValue: string): string;
  strict protected
    function Convert(const AValue: T): string;
  public
    constructor Create(const AMaxLength: Integer); reintroduce; overload;
    constructor Create(const APrefix, ASuffix: string; const AMaxLength: Integer); reintroduce; overload;
  end;

//------------------------------------------------------------------------------
  TByteToStrConverter = class(TIntToStrConverter<Byte>, IByteToStrConverter)
  strict protected
    function ConvertValue(const AValue: Byte): string; override;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const APrefix, ASuffix: string); reintroduce; overload;
  end;

//------------------------------------------------------------------------------
  TArrayToStrConverter<T> = class(TToStrConverter<T>, IArrayToStrConverter<T>)
  strict private
    Separator: string;
    ItemConverter: IValueToStrConverter<T>;
    function Convert(AArray: TArray<T>): string;
  public
    constructor Create(const APrefix, ASeparator, ASuffix: string; AItemConverter: IValueToStrConverter<T>);
  end;

//------------------------------------------------------------------------------
  TConverters = class
    class function NewBoolToStr: IBoolToStrConverter; overload;
    class function NewBoolToStr(const AFalseString, ATrueString: string): IBoolToStrConverter; overload;
    class function NewByteToStr: IByteToStrConverter; overload;
    class function NewByteToStr(const APrefix, ASuffix: string): IByteToStrConverter; overload;

    class function NewArrayToStr<T>(const APrefix, ASeparator, ASuffix: string;
      AItemConverter: IValueToStrConverter<T>): IArrayToStrConverter<T>;
  end;

//==============================================================================
implementation uses SysUtils, Spring.Container;

//==============================================================================
{ TArrayToStrConverter<T> }

constructor TArrayToStrConverter<T>.Create(const APrefix, ASeparator,
  ASuffix: string; AItemConverter: IValueToStrConverter<T>);
begin
  inherited Create(APrefix, ASuffix);
  Separator := ASeparator;
  ItemConverter := AItemConverter;
end;

//------------------------------------------------------------------------------
function TArrayToStrConverter<T>.Convert(AArray: TArray<T>): string;
var
  i: Integer;

begin
  if not Assigned(ItemConverter) then
    raise Exception.Create('No Item Converter defined!');

  Result := GetPrefix;

  for i:=0 to Length(AArray)-1 do begin
    Result := Result + ItemConverter.Convert(AArray[i]);
    if i < (Length(AArray) - 1) then Result := Result + Separator;
  end;

  Result := Result + GetSuffix;
end;

//==============================================================================
{ TBoolToStrConverter }

constructor TBoolToStrConverter.Create;
begin
  inherited;
  FalseString := 'FALSE';
  TrueString := 'TRUE';
end;

//------------------------------------------------------------------------------
function TBoolToStrConverter.ConvertValue(const AValue: Boolean): string;
begin
  if AValue then Result := TrueString else Result := FalseString;
end;

//------------------------------------------------------------------------------
constructor TBoolToStrConverter.Create(const APrefix, AFalseString, ATrueString, ASuffix: string);
begin
  inherited Create(APrefix, ASuffix);
  FalseString := AFalseString;
  TrueString := ATrueString;
end;

//==============================================================================
{ TToStrConverter }

constructor TToStrConverter<T>.Create(const APrefix, ASuffix: string);
begin
  inherited Create;
  Prefix := APrefix;
  Suffix := ASuffix;
end;

//------------------------------------------------------------------------------
function TToStrConverter<T>.GetPrefix: string;
begin
  Result := Prefix;
end;

//------------------------------------------------------------------------------
function TToStrConverter<T>.GetSuffix: string;
begin
  Result := Suffix;
end;

//------------------------------------------------------------------------------
procedure TToStrConverter<T>.SetPrefix(const APrefix: string);
begin
  Prefix := APrefix;
end;

//------------------------------------------------------------------------------
procedure TToStrConverter<T>.SetSuffix(const ASuffix: string);
begin
  Suffix := ASuffix;
end;

//------------------------------------------------------------------------------
constructor TToStrConverter<T>.Create;
begin
  inherited;
  Prefix := '';
  Suffix := '';
end;

//==============================================================================
{ TIntToStrConverter<T> }

function TIntToStrConverter<T>.Convert(const AValue: T): string;
begin
  Result := ConvertValue(AValue);
  Result := InsertLeadingZeros(Result);
  Result := GetPrefix + Result + GetSuffix;
end;

//------------------------------------------------------------------------------
constructor TIntToStrConverter<T>.Create(const AMaxLength: Integer);
begin
  inherited Create;
  MaxLength := AMaxLength;
end;

//------------------------------------------------------------------------------
constructor TIntToStrConverter<T>.Create(const APrefix, ASuffix: string;
  const AMaxLength: Integer);
begin
  inherited Create(APrefix, ASuffix);
  MaxLength := AMaxLength;
end;

//------------------------------------------------------------------------------
function TIntToStrConverter<T>.InsertLeadingZeros(const AStrValue: string): string;
var
  i: Integer;
begin
  Result := AStrValue;
  for i:=Length(AStrValue) to MaxLength-1 do
    Result := '0' + Result;
end;

//==============================================================================
{ TConverters }

class function TConverters.NewArrayToStr<T>(const APrefix, ASeparator, ASuffix: string;
      AItemConverter: IValueToStrConverter<T>): IArrayToStrConverter<T>;
begin
  Result := TArrayToStrConverter<T>.Create(APrefix, ASeparator, ASuffix, AItemConverter);
end;

//------------------------------------------------------------------------------
class function TConverters.NewBoolToStr(const AFalseString,
  ATrueString: string): IBoolToStrConverter;
begin
  Result := TBoolToStrConverter.Create(AFalseString, ATrueString);
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToStr(const APrefix, ASuffix: string): IByteToStrConverter;
begin
  Result := TByteToStrConverter.Create(APrefix, ASuffix);
end;

//------------------------------------------------------------------------------
class function TConverters.NewByteToStr: IByteToStrConverter;
begin
  Result := TByteToStrConverter.Create;
end;

//------------------------------------------------------------------------------
class function TConverters.NewBoolToStr: IBoolToStrConverter;
begin
  Result := TBoolToStrConverter.Create;
end;

//==============================================================================
{ TValueToStrConverter<T> }

function TValueToStrConverter<T>.Convert(const AValue: T): string;
begin
  Result := GetPrefix + ConvertValue(AValue) + GetSuffix;
end;

//==============================================================================
{ TByteToStrConverter }

function TByteToStrConverter.ConvertValue(const AValue: Byte): string;
begin
  Result := AValue.ToString;
end;

//------------------------------------------------------------------------------
constructor TByteToStrConverter.Create(const APrefix, ASuffix: string);
begin
  inherited Create(APrefix, ASuffix, 3);
end;

//------------------------------------------------------------------------------
constructor TByteToStrConverter.Create;
begin
  inherited Create(3);
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TBoolToStrConverter>.
    Implements<IBoolToStrConverter>;

  GlobalContainer.RegisterType<TByteToStrConverter>.
    Implements<IByteToStrConverter>;

end.
