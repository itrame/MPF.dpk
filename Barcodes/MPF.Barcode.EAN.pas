unit MPF.Barcode.EAN;
interface uses System.SysUtils, System.Classes, MPF.Barcode1D;

//==============================================================================
type
  IMpfEANCoder = interface(IMpfBarcode1D)['{E0CC9E86-2F24-459B-AB14-EA812660F5A9}']
  end;

//==============================================================================
implementation uses zint, zint_common, MPF.Helpers, Spring.Container;

//==============================================================================
type
  TMpfEANCoder = class(TMpfBarcode1D, IMpfEANCoder)
  protected
    function ValidateContent(const AContent: string): Boolean; override;
  public
    constructor Create;
  end;

//==============================================================================
{ TMpfEANCoder }

constructor TMpfEANCoder.Create;
begin
  inherited;
  Symbology := zsEANx;
  Content := '123456789012';
end;

//------------------------------------------------------------------------------
function TMpfEANCoder.ValidateContent(const AContent: string): Boolean;
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
initialization
  GlobalContainer.RegisterType<TMpfEANCoder>.Implements<IMpfEANCoder>;

end.
