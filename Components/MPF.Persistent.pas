unit MPF.Persistent;
interface uses Classes;

type
  TmpfPersistent = class(TPersistent)
  strict private
    FOwner: TPersistent;
    function GetOwnerComponent: TComponent;
  strict protected
    function GetOwner: TPersistent; override;
    procedure SetDesignParam<T>(var AParam: T; const AValue: T);
    property OwnerComponent: TComponent read GetOwnerComponent;
    property Owner: TPersistent read FOwner;
  public
    constructor Create(AOwner: TPersistent);
  end;

implementation


constructor TmpfPersistent.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
end;


function TmpfPersistent.GetOwner: TPersistent;
begin
  Result := FOwner;
end;


function TmpfPersistent.GetOwnerComponent: TComponent;
begin
  if Owner is TComponent then
    Result := Owner as TComponent
  else
    Result := nil;
end;


procedure TmpfPersistent.SetDesignParam<T>(var AParam: T; const AValue: T);
begin
  if Assigned(OwnerComponent) then begin
    if (csDesigning in OwnerComponent.ComponentState) or (csReading in OwnerComponent.ComponentState) then
      AParam := AValue;
  end;
end;

end.
