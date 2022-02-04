unit MPF.HexToBytes;
interface uses SysUtils;

//==============================================================================
type
  IHexToBytes = interface['{547D9BFE-EC0D-4416-ADF7-2E5202928C86}']
    function GetPrefix: string;
    procedure SetPrefix(const APrefix: string);
    function GetBytes(const AString: string): TBytes;

    property Prefix: string read GetPrefix write SetPrefix;

  end;

//==============================================================================
implementation uses Spring.Container, MPF.Helpers;

//==============================================================================
type
  THexToBytes = class(TInterfacedObject, IHexToBytes)
  private
    Prefix: string;

    function GetPrefix: string;
    procedure SetPrefix(const APrefix: string);
    function GetBytes(const AString: string): TBytes;

  public
    constructor Create;

  end;

//==============================================================================
{ THexToBytes }

constructor THexToBytes.Create;
begin
  inherited;
  Prefix := '0x';
end;

//------------------------------------------------------------------------------
function THexToBytes.GetBytes(const AString: string): TBytes;
var
  APos, ADataPos, APrefixLength, AStringLength: Integer;
  AByteStr: string;
  AValue: Integer;

begin
  Result := [];
  APrefixLength := Length(Prefix);
  AStringLength := Length(AString);

  APos := Pos(Prefix, AString);

  if APos > 0 then
    repeat

      ADataPos := APos + APrefixLength;
      if ADataPos < AStringLength then begin
        AByteStr := AString[ADataPos] + AString[ADataPos+1];

        try
          try
            AValue := AByteStr.HexToInt;
            if (AValue <= $FF) and (AValue >= $00) then Result := Result + [Byte(AValue)];
          except end;

        finally
          APos := Pos(Prefix, AString, ADataPos + 2);
        end;

      end else Break;

    until APos = 0;

end;

//------------------------------------------------------------------------------
function THexToBytes.GetPrefix: string;
begin
  Result := Prefix;
end;

//------------------------------------------------------------------------------
procedure THexToBytes.SetPrefix(const APrefix: string);
begin
  Prefix := APrefix;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<THexToBytes>.Implements<IHexToBytes>;

end.
