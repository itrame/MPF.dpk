unit MPF.Observers;
interface

//==============================================================================
type
  IMpfObserver = interface['{3ABFE7C1-5019-4414-8CA1-9826D548D49D}']
    procedure ObservedFree(ASender: TObject);
  end;


  IMpfObservable = interface['{7CB2A673-1D9D-4D6F-9525-B1E90C9F95D3}']
    procedure UnregisterObserver(AObserver: IMpfObserver);
    procedure RegisterObserver(AObserver: IMpfObserver);
  end;


  IMpfObservers = interface['{71CBCBC5-8F54-4BA2-A192-8662C8F6AC5B}']
    procedure NotifyFree;
    procedure UnregisterObserver(AObserver: IMpfObserver);
    procedure RegisterObserver(AObserver: IMpfObserver);
  end;

//==============================================================================
function NewMpfObservers: IMpfObservers;

//==============================================================================
implementation uses Spring.Collections;


type
  TMpfObservers = class(TInterfacedObject, IMpfObservers)
  strict private
    Observers: IList<IMpfObserver>;
    procedure NotifyFree;
    procedure UnregisterObserver(AObserver: IMpfObserver);
    procedure RegisterObserver(AObserver: IMpfObserver);
    function Exists(AObserver: IMpfObserver): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

//==============================================================================
{ TMpfObservers }

procedure TMpfObservers.RegisterObserver(AObserver: IMpfObserver);
begin
  if not Exists(AObserver) then Observers.Add(AObserver);
end;


constructor TMpfObservers.Create;
begin
  inherited;
  Observers := TCollections.CreateInterfaceList<IMpfObserver>;
end;


destructor TMpfObservers.Destroy;
begin
  NotifyFree;
  Observers.Clear;
  inherited;
end;


function TMpfObservers.Exists(AObserver: IMpfObserver): Boolean;
begin
  Result := Observers.IndexOf(AObserver) >= 0;
end;


procedure TMpfObservers.NotifyFree;
var
  AObserver: IMpfObserver;
begin
  for AObserver in Observers do AObserver.ObservedFree(Self);
end;


procedure TMpfObservers.UnregisterObserver(AObserver: IMpfObserver);
begin
  Observers.Remove(AObserver);
end;

//==============================================================================
function NewMpfObservers: IMpfObservers;
begin
  Result := TMpfObservers.Create;
end;

end.
