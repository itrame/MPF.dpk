unit MPF.TouchList;
interface uses System.SysUtils, System.Classes, Vcl.Controls, StdCtrls;

//==============================================================================
type
  TMpfTouchList = class(TWinControl)
  private
    TextLabel: TLabel;
    LeftButton, RightButton: TButton;
    FItems: TStringList;
    FItemIndex: Integer;

    procedure SetItems(const AValue: TStringList);
    procedure SetItemIndex(const AValue: Integer);
    procedure ButtonClicked(ASender: TObject);
    procedure DecItemIndex;
    procedure IncItemIndex;
    function GetText: string;
    procedure ItemsChanged(ASender: TObject);

  strict protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Resize; override;

    procedure UpdateCtrls;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Update; override;

  published
    property Items: TStringList read FItems write SetItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Text: string read GetText;
    property Font;
    property DoubleBuffered;
    property ParentDoubleBuffered;
    property ParentFont;
    property Align;
    property AlignWithMargins;
    property Margins;

  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation

//==============================================================================
procedure Register;
begin
  RegisterComponents('MPF', [TMpfTouchList]);
end;

//==============================================================================
{ TMpfTouchList }

procedure TMpfTouchList.ButtonClicked(ASender: TObject);
begin
  if ASender = LeftButton then DecItemIndex;
  if ASender = RightButton then IncItemIndex;
end;

//------------------------------------------------------------------------------
constructor TMpfTouchList.Create(AOwner: TComponent);
begin
  inherited;
  Height := 32;
  Width := 128;
  DoubleBuffered := true;

  TextLabel := TLabel.Create(Self);
  TextLabel.AutoSize := false;
  TextLabel.Alignment := taCenter;
  TextLabel.Parent := Self;
  TextLabel.Align := alClient;
  TextLabel.WordWrap := true;
  TextLabel.Layout := tlCenter;

  LeftButton := TButton.Create(Self);
  LeftButton.Parent := Self;
  LeftButton.Caption := '<';
  LeftButton.Align := alLeft;
  LeftButton.OnClick := ButtonClicked;


  RightButton := TButton.Create(Self);
  RightButton.Parent := Self;
  RightButton.Caption := '>';
  RightButton.Align := alRight;
  RightButton.OnClick := ButtonClicked;

  FItems := TStringList.Create;
  FItems.OnChange := ItemsChanged;

  FItemIndex := -1;

end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.DecItemIndex;
begin
  Dec(FItemIndex);
  if FItemIndex < 0 then FItemIndex := FItems.Count-1;
  UpdateCtrls;
end;

//------------------------------------------------------------------------------
destructor TMpfTouchList.Destroy;
begin
  FItems.Free;
  TextLabel.Free;
  inherited;
end;

//------------------------------------------------------------------------------
function TMpfTouchList.GetText: string;
begin
  Result := TextLabel.Caption;
end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.IncItemIndex;
begin
  Inc(FItemIndex);
  if FItemIndex >= FItems.Count then
    if FItems.Count > 0 then
      FItemIndex := 0
    else
      FItemIndex := -1;

  UpdateCtrls;

end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.ItemsChanged(ASender: TObject);
begin
  if (FItemIndex >= FItems.Count) then SetItemIndex(-1);
end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.Resize;
begin
  inherited;
  if Assigned(Parent) then begin
    LeftButton.Width := ClientHeight;
    RightButton.Width := ClientHeight;
//
//    TextLabel.Width := ClientWidth - LeftButton.Width - RightButton.Width - 2;
//    TextLabel.Left := LeftButton.Width + 1;
//
//    TextLabel.Top := Round((ClientHeight - TextLabel.Height) / 2);
  end;

end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.SetItemIndex(const AValue: Integer);
begin
  if AValue  = FItemIndex then Exit;

  if (AValue < -1) or (AValue >= FItems.Count) then
    FItemIndex := -1
  else
    FItemIndex := AValue;

  UpdateCtrls;

end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.SetItems(const AValue: TStringList);
begin
  FItems.Assign(AValue);
end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(AParent) then Update;
end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.Update;
begin
  inherited;
  UpdateCtrls;
end;

//------------------------------------------------------------------------------
procedure TMpfTouchList.UpdateCtrls;
begin
  if (FItemIndex >= 0) and (FItemIndex < FItems.Count) then
    TextLabel.Caption := FItems[FItemIndex]
  else
    TextLabel.Caption := '';
end;

end.
