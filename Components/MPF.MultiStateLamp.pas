unit MPF.MultiStateLamp;
interface uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics;

//==============================================================================
type
  TLampStates = class;

  TLampState = class(TCollectionItem)
  strict private
    FText: string;
    FColor: TColor;
    FFont: TFont;
    FBlink: Boolean;
    FBlinkColor: TColor;
    FBlinkText: string;
    FBlinkFont: TFont;
    FBlinkTimeOn: Integer;
    FBlinkTimeOff: Integer;
    FStateName: string;

    procedure SetColor(const AValue: TColor);
    procedure SetText(const AValue: string);
    procedure SetFont(const AValue: TFont);
    procedure SetBlink(const AValue: Boolean);
    procedure SetBlinkColor(const AValue: TColor);
    procedure SetBlinkText(const AValue: string);
    procedure SetBlinkFont(const AValue: TFont);
    procedure SetBlinkTimeOn(const AValue: Integer);
    procedure SetBlinkTimeOff(const AValue: Integer);
    procedure SetStateName(const AValue: string);
    function GetStates: TLampStates;

 strict protected
    procedure AssignTo(ADest: TPersistent); override;

  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;

    property States: TLampStates read GetStates;

  published
    property Text: string read FText write SetText;
    property Color: TColor read FColor write SetColor;
    property Font: TFont read FFont write SetFont;
    property Blink: Boolean read FBlink write SetBlink default false;
    property BlinkColor: TColor read FBlinkColor write SetBlinkColor default clRed;
    property BlinkText: string read FBlinkText write SetBlinkText;
    property BlinkFont: TFont read FBlinkFont write SetBlinkFont;
    property BlinkTimeOn: Integer read FBlinkTimeOn write SetBlinkTimeOn default 500;
    property BlinkTimeOff: Integer read FBlinkTimeOff write SetBlinkTimeOff default 500;
    property StateName: string read FStateName write SetStateName;

  end;

//------------------------------------------------------------------------------
  TLampStates = class(TCollection)
  strict private
    FOwner: TPersistent;

    function GetNewStateName: string;

  strict protected
    function GetOwner: TPersistent; override;
    procedure AssignTo(ADest: TPersistent); override;
    function GetItem(Index: Integer): TLampState;
    procedure SetItem(Index: Integer; AState: TLampState);
    procedure Update(AItem: TCollectionItem); override;

  public
    constructor Create(AOwner: TPersistent);
    function Add: TLampState;
    function NameExists(const AName: string): Boolean;
    function IndexOfName(const AName: string): Integer;

    property Items[Index: Integer]: TLampState read GetItem write SetItem; default;

  end;

//------------------------------------------------------------------------------
  TMpfMultiStateLamp = class(TWinControl)
  strict private
    FStates: TLampStates;
    Panel: TPanel;
    FStateId: Integer;
    Timer: TTimer;
    BlinkOn: Boolean;

    procedure SetStates(const AValue: TLampStates);
    procedure SetStateId(const AValue: Integer);
    procedure UpdatePanel;
    procedure TimerEvent(ASender: TObject);
    procedure PanelClicked(ASender: TObject);
    function GetBevelOuter: TBevelCut;
    procedure SetBevelOuter(const AValue: TBevelCut);
    function GetActiveState: TLampState;
    function GetStateName: string;
    procedure SetStateName(const AValue: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Update; override;

  published
    property Align;
    property DoubleBuffered;
    property ParentDoubleBuffered;
    property States: TLampStates read FStates write SetStates;
    property StateId: Integer read FStateId write SetStateId;
    property BevelOuter: TBevelCut read GetBevelOuter write SetBevelOuter;
    property ActiveState: TLampState read GetActiveState;
    property StateName: string read GetStateName write SetStateName;

    property OnClick;

  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation

procedure Register;
begin
  RegisterComponents('MPF', [TMpfMultiStateLamp]);
end;

//==============================================================================
{ TLampState }

procedure TLampState.AssignTo(ADest: TPersistent);
var
  ADestState: TLampState;

begin
  if ADest is TLampState then begin
    ADestState := ADest as TLampState;
    ADestState.Text := Text;
    ADestState.Color := Color;
    ADestState.Font.Assign(Font);
    ADestState.Blink := Blink;
    ADestState.BlinkColor := BlinkColor;
    ADestState.BlinkText := BlinkText;
    ADestState.BlinkFont.Assign(BlinkFont);
    ADestState.BlinkTimeOn := BlinkTimeOn;
    ADestState.BlinkTimeOff := BlinkTimeOff;
    ADestState.StateName := StateName;
  end;

end;

//------------------------------------------------------------------------------
constructor TLampState.Create(ACollection: TCollection);
begin
  inherited;
  FColor := clGray;
  FFont := TFont.Create;
  FBlinkFont := TFont.Create;
  FBlinkTimeOn := 500;
  FBlinkTimeOff := 500;
end;

//------------------------------------------------------------------------------
destructor TLampState.Destroy;
begin
  FBlinkFont.Free;
  FFont.Free;
  inherited;
end;

//------------------------------------------------------------------------------
function TLampState.GetStates: TLampStates;
begin
  if Collection is TLampStates then
    Result := Collection as TLampStates
  else
    Result := nil;
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlink(const AValue: Boolean);
begin
  if AValue = FBlink then Exit;
  FBlink := AValue;
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlinkColor(const AValue: TColor);
begin
  if AValue = FBlinkColor then Exit;
  FBlinkColor := AValue;
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlinkFont(const AValue: TFont);
begin
  FBlinkFont.Assign(AValue);
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlinkText(const AValue: string);
begin
  if AValue = FBlinkText then Exit;
  FBlinkText := AValue;
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlinkTimeOff(const AValue: Integer);
begin
  if AValue = FBlinkTimeOff then Exit;
  if AValue > 0 then begin
    FBlinkTimeOff := AValue;
    Changed(false);
  end;
end;

//------------------------------------------------------------------------------
procedure TLampState.SetBlinkTimeOn(const AValue: Integer);
begin
  if AValue = FBlinkTimeOn then Exit;
  if AValue > 0 then begin
    FBlinkTimeOn := AValue;
    Changed(false);
  end;
end;

//------------------------------------------------------------------------------
procedure TLampState.SetColor(const AValue: TColor);
begin
  if AValue = FColor then Exit;
  FColor := AValue;
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetFont(const AValue: TFont);
begin
  FFont.Assign(AValue);
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetStateName(const AValue: string);
begin
  if AValue = FStateName then Exit;

  if AValue = '' then
    raise Exception.Create('State name can not be empty.');

  if States.NameExists(AValue) and (States.IndexOfName(AValue) <> Index) then
    raise Exception.Create('State: ' + AValue + ' already exists.');
    
  FStateName := AValue;
  Changed(false);
end;

//------------------------------------------------------------------------------
procedure TLampState.SetText(const AValue: string);
begin
  if AValue = FText then Exit;
  FText := AValue;
  Changed(false);
end;

//==============================================================================

{ TLampStates }

function TLampStates.Add: TLampState;
begin
  Result := inherited Add as TLampState;
  Result.StateName := GetNewStateName;
end;

//------------------------------------------------------------------------------
procedure TLampStates.AssignTo(ADest: TPersistent);
var
  ADestStates: TLampStates;
  i: Integer;
  AState: TLampState;

begin
  if ADest is TLampStates then begin
    ADestStates := ADest as TLampStates;
    ADestStates.Clear;
    for i:=0 to Count-1 do begin
      AState := ADestStates.Add;
      AState.Assign(Items[i]);
    end;

  end;

end;

//------------------------------------------------------------------------------
constructor TLampStates.Create(AOwner: TPersistent);
begin
  inherited Create(TLampState);
  FOwner := AOwner;
end;

//------------------------------------------------------------------------------
function TLampStates.GetItem(Index: Integer): TLampState;
begin
  Result := inherited GetItem(Index) as TLampState;
end;

//------------------------------------------------------------------------------
function TLampStates.GetNewStateName: string;
var
  i: UInt32;

begin
  for i:=1 to $FFFFFFFF do begin
    Result := 'State' + i.ToString;
    if not NameExists(Result) then Break;
  end;
end;

//------------------------------------------------------------------------------
function TLampStates.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

//------------------------------------------------------------------------------
function TLampStates.IndexOfName(const AName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Count-1 do
    if UpperCase(Items[i].StateName) = UpperCase(AName) then begin
      Result := i;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function TLampStates.NameExists(const AName: string): Boolean;
begin
  Result := IndexOfName(AName) >= 0;
end;

//------------------------------------------------------------------------------
procedure TLampStates.SetItem(Index: Integer; AState: TLampState);
begin
  inherited SetItem(Index, AState);
end;

//------------------------------------------------------------------------------
procedure TLampStates.Update(AItem: TCollectionItem);
var
  AComponent: TMpfMultiStateLamp;

begin
  inherited;

  if Owner is TMpfMultiStateLamp then begin
    AComponent := Owner as TMpfMultiStateLamp;

    if Assigned(AItem) then begin
      if AComponent.StateId = AItem.Index then AComponent.Update;
    end else
      AComponent.Update;

  end;

end;

//==============================================================================
{ TMpfMultiStateLamp }

constructor TMpfMultiStateLamp.Create(AOwner: TComponent);
begin
  inherited;
  FStates := TLampStates.Create(Self);

  Timer := TTimer.Create(Self);
  Timer.Enabled := false;
  Timer.OnTimer := TimerEvent;

  Panel := TPanel.Create(Self);
  Panel.Align := alClient;
  Panel.BevelOuter := bvLowered;
  Panel.ParentBackground := false;
  Panel.OnClick := PanelClicked;

  FStateId := -1;

  Height := 32;
  Width := 64;

end;

//------------------------------------------------------------------------------
destructor TMpfMultiStateLamp.Destroy;
begin
  Timer.Free;
  Panel.Free;
  inherited;
end;

//------------------------------------------------------------------------------
function TMpfMultiStateLamp.GetActiveState: TLampState;
begin
  if (StateId >= 0) and (StateId < States.Count) then
    Result := States[StateId]
  else
    Result := nil;
end;

//------------------------------------------------------------------------------
function TMpfMultiStateLamp.GetBevelOuter: TBevelCut;
begin
  Result := Panel.BevelOuter;
end;

//------------------------------------------------------------------------------
function TMpfMultiStateLamp.GetStateName: string;
begin
  if Assigned(ActiveState) then Result := ActiveState.StateName else Result := '';
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.PanelClicked(ASender: TObject);
begin
  if Assigned(OnClick) then OnClick(Self);
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.SetBevelOuter(const AValue: TBevelCut);
begin
  Panel.BevelOuter := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.SetStateId(const AValue: Integer);
begin
  if AValue = FStateId then Exit;
  Timer.Enabled := false;

  if (AValue >= -1) and (AValue < States.Count) then
    FStateId := AValue
  else
    FStateId := -1;

  UpdatePanel;

end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.SetStateName(const AValue: string);
begin
  StateId := States.IndexOfName(AValue);  
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.SetStates(const AValue: TLampStates);
begin
  FStates.Assign(AValue);
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.TimerEvent(ASender: TObject);
begin

  if Assigned(ActiveState) then begin

    BlinkOn := not BlinkOn;
    if BlinkOn then
      Timer.Interval := ActiveState.BlinkTimeOn
    else
      Timer.Interval := ActiveState.BlinkTimeOff;

  end else
    Timer.Enabled := false;

  UpdatePanel;

end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.Update;
begin
  inherited;
  UpdatePanel;
end;

//------------------------------------------------------------------------------
procedure TMpfMultiStateLamp.UpdatePanel;
begin
  if Assigned(ActiveState) then begin
    Timer.Enabled := ActiveState.Blink;

    if ActiveState.Blink then begin

      if BlinkOn then begin
        Panel.Caption := ActiveState.Text;
        Panel.Color := ActiveState.Color;
        Panel.Font.Assign(ActiveState.Font);
      end else begin
        Panel.Caption := ActiveState.BlinkText;
        Panel.Color := ActiveState.BlinkColor;
        Panel.Font.Assign(ActiveState.BlinkFont);
      end;

    end else begin
      Panel.Caption := ActiveState.Text;
      Panel.Color := ActiveState.Color;
      Panel.Font.Assign(ActiveState.Font);
    end;

    Panel.Parent := Self;

  end else begin

    Panel.Parent := nil;
    Timer.Enabled := false;

  end;

end;

end.
