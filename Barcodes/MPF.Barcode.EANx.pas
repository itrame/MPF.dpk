unit MPF.Barcode.EANx;
interface uses System.SysUtils, System.Classes, MPF.Barcode1D;

//==============================================================================
type
  TMpfEANx = class(TMpfBarcode1D)
  protected
    function ValidateContent(const AContent: string): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation uses zint, zint_common, MPF.Helpers;

//==============================================================================
{ TMpfEANxCoder }

constructor TMpfEANx.Create(AOwner: TComponent);
begin
  inherited;
  Symbology := zsEANx;
  Content := '123456789012';
  Row := 0;
end;

//------------------------------------------------------------------------------
function TMpfEANx.ValidateContent(const AContent: string): Boolean;
begin
  if AContent = '' then
    raise Exception.Create('EANx Content can not be empty.');

  if Length(AContent) > 12 then
    raise Exception.Create('EANx Content length can not be > 12.');

  if not AContent.IsOnlyDigits then
    raise Exception.Create('EANx Content should has only digits.');

  Result := true;
end;

//==============================================================================
procedure Register;
begin
  RegisterComponents('MPF', [TMpfEANx]);
end;
end.
