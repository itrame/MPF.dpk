unit _MPF.Arrays;
interface uses MPF.Converters;

//==============================================================================
type
 IMpConstArray = interface['{01B12CD4-A358-4734-9BAD-C67FBB05AC6B}']
    function GetSize: Integer;
    function ToStr: string;
    property Size: Integer read GetSize;
  end;

//------------------------------------------------------------------------------
  IMpReadOnlyArray<T> = interface(IMpConstArray)['{A6534948-7F99-4DCE-AC5A-0BD09ADF563E}']
    function GetItem(Index: Integer): T;
    property Items[Index: Integer]: T read GetItem; default;
  end;

//------------------------------------------------------------------------------
  IMpResizableArray = interface(IMpConstArray)['{21D211B8-407C-4CDA-8E70-FAA5E16D0E62}']
    procedure SetSize(const ASize: Integer);
    property Size: Integer read GetSize write SetSize;
  end;

//------------------------------------------------------------------------------
  IMpArray<T> = interface(IMpReadOnlyArray<T>)['{91CB5A75-D4F8-4FA8-AE5A-94B9FD79B4FD}']
    procedure SetItem(Index: Integer; AValue: T);
    procedure SetSize(const ASize: Integer);
    property Items[Index: Integer]: T read GetItem write SetItem; default;
    property Size: Integer read GetSize write SetSize;
  end;

//------------------------------------------------------------------------------
  TMPFArray<T> = class(TInterfacedObject, IMpConstArray, IMpReadOnlyArray<T>, IMpArray<T>,
    IMpResizableArray)
  strict private
    Items: TArray<T>;
    ToStrConverter: IArrayToStrConverter<T>;
    procedure SetSize(const ASize: Integer);
    procedure SetItem(Index: Integer; AValue: T);
    function GetItem(Index: Integer): T;
    function GetSize: Integer;
    function ToStr: string;
  public
    constructor Create(const ASize: Integer; AToStrConverter: IArrayToStrConverter<T> = nil); overload;
    constructor Create(AData: TArray<T>; AToStrConverter: IArrayToStrConverter<T> = nil); overload;
  end;

//------------------------------------------------------------------------------
  TArrays = class
    class function NewArrayOf<T>(AItems: TArray<T>; AToStrConverter: IArrayToStrConverter<T> = nil): TMPFArray<T>; overload;
    class function NewArrayOf<T>(ASize: Integer; AToStrConverter: IArrayToStrConverter<T> = nil): TMPFArray<T>; overload;
  end;

//==============================================================================
implementation

//==============================================================================
 { TMpArray<T> }

constructor TMPFArray<T>.Create(const ASize: Integer; AToStrConverter: IArrayToStrConverter<T> = nil);
begin
  inherited Create;
  SetSize(ASize);
  ToStrConverter := AToStrConverter;
end;

//------------------------------------------------------------------------------
constructor TMPFArray<T>.Create(AData: TArray<T>; AToStrConverter: IArrayToStrConverter<T> = nil);
var
  i: Integer;
begin
  Create(Length(AData), AToStrConverter);
  for i:=0 to Length(AData)-1 do SetItem(i, AData[i]);
end;

//------------------------------------------------------------------------------
function TMPFArray<T>.GetItem(Index: Integer): T;
begin
  Result := Items[Index];
end;

//------------------------------------------------------------------------------
function TMPFArray<T>.GetSize: Integer;
begin
  Result := Length(Items);
end;

//------------------------------------------------------------------------------
procedure TMPFArray<T>.SetItem(Index: Integer; AValue: T);
begin
  Items[Index] := AValue;
end;

//------------------------------------------------------------------------------
procedure TMPFArray<T>.SetSize(const ASize: Integer);
begin
  SetLength(Items, ASize);
end;

//------------------------------------------------------------------------------
function TMPFArray<T>.ToStr: string;
begin
  if Assigned(ToStrConverter) then begin
    Result := ToStrConverter.Convert(Items);
  end else
    Result := '';
end;

//==============================================================================
{ TArrays }

class function TArrays.NewArrayOf<T>(AItems: TArray<T>;
  AToStrConverter: IArrayToStrConverter<T> = nil): TMPFArray<T>;
begin
  Result := TMPFArray<T>.Create(AItems, AToStrConverter);
end;

//------------------------------------------------------------------------------
class function TArrays.NewArrayOf<T>(ASize: Integer;
  AToStrConverter: IArrayToStrConverter<T> = nil): TMPFArray<T>;
begin
  Result := TMPFArray<T>.Create(ASize, AToStrConverter);
end;

//==============================================================================

end.


