unit MPF.BoldCheckBox;
interface uses System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

//==============================================================================
type
  TMpfBoldCheckBox = class(TCheckBox)
  private
    procedure UpdateBold;
  strict protected
    procedure Click; override;
//  published
//    property Caption;
//    property Checked;
  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation uses Vcl.Graphics, System.UITypes;

//==============================================================================
procedure Register;
begin
  RegisterComponents('MPF', [TMpfBoldCheckBox]);
end;

//==============================================================================
{ TMpfBoldCheckBox }

procedure TMpfBoldCheckBox.Click;
begin
  inherited;
  UpdateBold;
end;

//------------------------------------------------------------------------------
procedure TMpfBoldCheckBox.UpdateBold;
begin
  if Checked then
    Font.Style := Font.Style + [fsBold]
  else
    Font.Style := Font.Style - [fsBold];
end;

end.
