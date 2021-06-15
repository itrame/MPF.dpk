unit MPF.SFTPClient;
interface uses System.SysUtils, System.Classes, MPF.CustomSFTPClient,
  MPF.Observers;

//==============================================================================
type
  TMpfSFTPClient = class(TMpfCustomSFTPClient, IMpfObservable)
  private
    FObservers: IMpfObservers;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LastMessage;
    property Files;
    property Connected;
    procedure UnregisterObserver(AObserver: IMpfObserver);
    procedure RegisterObserver(AObserver: IMpfObserver);

  published
    property Host;
    property Port;
    property User;
    property Password;
    property DLLInfo;
    property RemoteDir;
    property LocalDir;
    property ConnectTimeout;

    property OnMessage;

  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation

//==============================================================================
procedure Register;
begin
  RegisterComponents('MPF', [TMpfSFTPClient]);
end;

//==============================================================================
{ TMpfSFTPClient }

constructor TMpfSFTPClient.Create(AOwner: TComponent);
begin
  inherited;
  FObservers := NewMpfObservers;
end;

//------------------------------------------------------------------------------
destructor TMpfSFTPClient.Destroy;
begin
  FObservers.NotifyFree;
  inherited;
end;

//------------------------------------------------------------------------------
procedure TMpfSFTPClient.RegisterObserver(AObserver: IMpfObserver);
begin
  FObservers.RegisterObserver(AObserver);
end;

//------------------------------------------------------------------------------
procedure TMpfSFTPClient.UnregisterObserver(AObserver: IMpfObserver);
begin
  FObservers.UnregisterObserver(AObserver);
end;

end.
