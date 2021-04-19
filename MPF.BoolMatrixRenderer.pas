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

    property Position: TPoint read GetPosition write SetPosition;
    property ZoomX: Integer read GetZoomX write SetZoomX;
    property ZoomY:Integer read GetZoomY write SetZoomY;

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

    function GetPosition: TPoint;
    procedure SetPosition(const APosition: TPoint);
    function GetZoomX: Integer;
    procedure SetZoomX(const AZoomX: Integer);
    function GetZoomY: Integer;
    procedure SetZoomY(const AZoomY: Integer);
    procedure Draw(AMatrix: IReadOnlyMatrix<Boolean>; ACanvas: TCanvas);
    function ValidateZoom(const AValue: Integer): Boolean;

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
            if AMatrix[X,Y] then
              ACanvas.Pixels[(ZoomX*X)+ZX-1+Position.X,(ZoomY*Y)+ZY-1+Position.Y] := clBlack;
  finally
    ACanvas.Unlock;
  end;
end;

//------------------------------------------------------------------------------
function TBoolMatrixRenderer.GetPosition: TPoint;
begin
  Result := Position;
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
procedure TBoolMatrixRenderer.SetPosition(const APosition: TPoint);
begin
  Position := APosition;
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
