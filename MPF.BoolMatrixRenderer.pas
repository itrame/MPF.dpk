unit MPF.BoolMatrixRenderer;
interface uses System.Types, Vcl.Graphics, MPF.Matrices;

//==============================================================================
type
  IBoolMatrixRenderer = interface['{094CD9F9-0786-4288-B324-48D6216FFDB6}']
    function GetPosition: TPoint;
    procedure SetPosition(const APosition: TPoint);
    function GetZoomX: Integer;
    procedure SetZoomX(const AZoomX: Integer);
    function GetZoomY: Integer;
    procedure SetZoomY(const AZoomY: Integer);
    procedure Draw(AMatrix: IReadOnlyMatrix<Boolean>; ACanvas: TCanvas);
    function GetTrueColor: TColor;
    procedure SetTrueColor(const AColor: TColor);
    function GetFalseColor: TColor;
    procedure SetFalseColor(const AColor: TColor);
    function IsTransparentTrue: Boolean;
    procedure SetTransparentTrue(const AValue: Boolean);
    function IsTransparentFalse: Boolean;
    procedure SetTransparentFalse(const AValue: Boolean);

    property Position: TPoint read GetPosition write SetPosition;
    property ZoomX: Integer read GetZoomX write SetZoomX;
    property ZoomY:Integer read GetZoomY write SetZoomY;
    property TrueColor: TColor read GetTrueColor write SetTrueColor;
    property FalseColor: TColor read GetFalseColor write SetFalseColor;
    property TransparentTrue: Boolean read IsTransparentTrue write SetTransparentTrue;
    property TransparentFalse: Boolean read IsTransparentFalse write SetTransparentFalse;

  end;

//==============================================================================
function NewBoolMatrixRender: IBoolMatrixRenderer;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
type
  TBoolMatrixRenderer = class(TInterfacedObject, IBoolMatrixRenderer)
  strict private
    Position: TPoint;
    ZoomX, ZoomY: Integer;
    FalseColor, TrueColor: TColor;
    TransparentTrue, TransparentFalse: Boolean;

    function GetPosition: TPoint;
    procedure SetPosition(const APosition: TPoint);
    function GetZoomX: Integer;
    procedure SetZoomX(const AZoomX: Integer);
    function GetZoomY: Integer;
    procedure SetZoomY(const AZoomY: Integer);
    procedure Draw(AMatrix: IReadOnlyMatrix<Boolean>; ACanvas: TCanvas);
    function ValidateZoom(const AValue: Integer): Boolean;
    function GetTrueColor: TColor;
    procedure SetTrueColor(const AColor: TColor);
    function GetFalseColor: TColor;
    procedure SetFalseColor(const AColor: TColor);
    function IsTransparentTrue: Boolean;
    procedure SetTransparentTrue(const AValue: Boolean);
    function IsTransparentFalse: Boolean;
    procedure SetTransparentFalse(const AValue: Boolean);

  public
    constructor Create;

  end;

//==============================================================================
{ TBoolMatrixRenderer }

constructor TBoolMatrixRenderer.Create;
begin
  inherited;
  Position.X := 0;
  Position.Y := 0;
  ZoomX := 1;
  ZoomY := 1;
  FalseColor := clWhite;
  TrueColor := clBlack;
  TransparentTrue := false;
  TransparentFalse := true;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.Draw(AMatrix: IReadOnlyMatrix<Boolean>; ACanvas: TCanvas);
var
  X, Y, ZX, ZY: Integer;
begin
  ACanvas.Lock;
  try
    for X:=0 to AMatrix.Width-1 do
      for Y:=0 to AMatrix.Height-1 do
        for ZX:=0 to ZoomX-1 do
          for ZY:=0 to ZoomY-1 do
            if AMatrix[X,Y] then begin
              if not TransparentTrue then
                ACanvas.Pixels[(ZoomX*X)+ZX+Position.X,(ZoomY*Y)+ZY+Position.Y] := TrueColor;
            end else begin
              if not TransparentFalse then
                ACanvas.Pixels[(ZoomX*X)+ZX+Position.X,(ZoomY*Y)+ZY+Position.Y] := FalseColor;
            end;
  finally
    ACanvas.Unlock;
  end;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetFalseColor: TColor;
begin
  Result := FalseColor;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetPosition: TPoint;
begin
  Result := Position;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetTrueColor: TColor;
begin
  Result := TrueColor;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetZoomX: Integer;
begin
  Result := ZoomX;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetZoomY: Integer;
begin
  Result := ZoomY;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.IsTransparentFalse: Boolean;
begin
  Result := TransparentFalse;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.IsTransparentTrue: Boolean;
begin
  Result := TransparentTrue;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetFalseColor(const AColor: TColor);
begin
  FalseColor := AColor;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetPosition(const APosition: TPoint);
begin
  Position := APosition;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetTransparentFalse(const AValue: Boolean);
begin
  TransparentFalse := AValue;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetTransparentTrue(const AValue: Boolean);
begin
  TransparentTrue := AValue;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetTrueColor(const AColor: TColor);
begin
  TrueColor := AColor;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetZoomX(const AZoomX: Integer);
begin
  if AZoomX = ZoomX then Exit;
  if not ValidateZoom(AZoomX) then Exit;
  ZoomX := AZoomX;
end;

//------------------------------------------------------------------------------
procedure TBoolMatrixRenderer.SetZoomY(const AZoomY: Integer);
begin
  if AZoomY = ZoomY then Exit;
  if not ValidateZoom(AZoomY) then Exit;
  ZoomY := AZoomY;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.ValidateZoom(const AValue: Integer): Boolean;
begin
  if AValue <= 0 then raise Exception.Create(
    'Invalid Zoom value: ' + AValue.ToString + '. Zoom value must be > 0.');
  Result := true;
end;

//==============================================================================
function NewBoolMatrixRender: IBoolMatrixRenderer;
begin
  Result := TBoolMatrixRenderer.Create;
end;

end.
