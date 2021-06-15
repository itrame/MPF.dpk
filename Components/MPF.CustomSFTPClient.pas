unit MPF.CustomSFTPClient;
interface uses System.SysUtils, System.Classes, tgputtysftp, Spring.Collections,
  tgputtylib;

//==============================================================================
type
  TMpfSFTPFile = class(TPersistent)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
  end;

//------------------------------------------------------------------------------
  TMpfSFTPFiles = class(TPersistent)
  private
    FItems: IList<TMpfSFTPFile>;
    function GetItem(Index: Integer): TMpfSFTPFile;
    function GetCount: Integer;
    function Add(const AName: string): TMpfSFTPFile;
    procedure Clear;

  public
    constructor Create;
    destructor Destroy; override;

    property Items[Index: Integer]: TMpfSFTPFile read GetItem; default;
    property Count: Integer read GetCount;

  end;

//------------------------------------------------------------------------------
  TMpfCustomSFTPClient = class(TComponent)
  private
    FHost: string;
    FPort: Word;
    FUser: string;
    FPassword: string;
    FDLLInfo: string;
    FConnection: TTgPuttySFTP;
    FLastMessage: string;
    FFiles: TMpfSFTPFiles;
    FRemoteDir: string;
    FLocalDir: string;
    FConnectTimeout: Integer;

    FOnMessage: TNotifyEvent;

    function ConnectionVerifyHostKey(const host:PAnsiChar; const port:Integer;
      const fingerprint:PAnsiChar; const verificationstatus:Integer;
      var storehostkey:Boolean): Boolean;

    procedure ConnectionMessage(const AMsg: AnsiString; const AIsError: Boolean);
    function ConnectionListing(const AFiles: Pfxp_names):Boolean;
    procedure DoOnMessage;
    function ExtractFileName(const AFullPath: string): string;
    function IsConnected: Boolean;

  protected
    property Host: string read FHost write FHost;
    property Port: Word read FPort write FPort default 22;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property DLLInfo: string read FDLLInfo;
    property LastMessage: string read FLastMessage;
    property Files: TMpfSFTPFiles read FFiles;
    property RemoteDir: string read FRemoteDir write FRemoteDir;
    property LocalDir: string read FLocalDir write FLocalDir;
    property Connected: Boolean read IsConnected;
    property ConnectTimeout: Integer read FConnectTimeout write FConnectTimeout default 5000;

    property OnMessage: TNotifyEvent read FOnMessage write FOnMessage;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure ListDirectory;
    procedure DownloadFile(const ARemoteFile, ALocalFile: string;
      const AAppend: Boolean = false); overload;
    procedure DownloadFile(const ARemoteFile: string); overload;
    procedure DownloadStream(const ARemoteFile: string; ADest: TStream;
      const AAppend: Boolean = false);

  end;

//==============================================================================
implementation uses Forms;

//==============================================================================
{ TMpfSFTPClient }

procedure TMpfCustomSFTPClient.Connect;
begin
  if Assigned(FConnection) then
    raise Exception.Create('Already connected.');

  try
    FConnection := TTGPuttySFTP.Create(true);
  except
    raise Exception.Create('Can not create internal connection object.' + #13 +
      'Check tgputtylib.dll exists in EXE directory.');
  end;

  try
    FConnection.HostName := Utf8Encode(FHost);
    FConnection.Port := FPort;
    FConnection.UserName := UTF8Encode(FUser);
    FConnection.Password := UTF8Encode(FPassword);
    FConnection.ConnectionTimeoutTicks := FConnectTimeout;
    FConnection.OnVerifyHostKey := ConnectionVerifyHostKey;
    FConnection.OnMessage := ConnectionMessage;
    FConnection.OnListing := ConnectionListing;
    FConnection.Connect;
  except
    FreeAndNil(FConnection);
  end;

end;

//------------------------------------------------------------------------------
function TMpfCustomSFTPClient.ConnectionListing(const AFiles: Pfxp_names): Boolean;
var
  i: Integer;

begin
  {$POINTERMATH ON}
  FFiles.Clear;
  for i:=0 to AFiles.nnames-1 do
    FFiles.Add( Utf8ToString(AFiles.names[i].filename) );

  Result := true;
  {$POINTERMATH OFF}
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.ConnectionMessage(const AMsg: AnsiString;
  const AIsError: Boolean);
begin
  FLastMessage := Utf8ToString(AMsg);
  DoOnMessage;
end;

//------------------------------------------------------------------------------
function TMpfCustomSFTPClient.ConnectionVerifyHostKey(const host: PAnsiChar;
  const port: Integer; const fingerprint: PAnsiChar;
  const verificationstatus: Integer; var storehostkey: Boolean): Boolean;
begin
  if verificationstatus=0 then begin
     Result := true;
     Exit;
  end else
    Result := false;

//  Result := Application.MessageBox(PWideChar(WideString(
//                'Please confirm the SSH host key fingerprint for '+Utf8ToString(AnsiString(host))+
//                ', port '+IntToStr(port)+':'+sLineBreak+
//                Utf8ToString(AnsiString(fingerprint)))),
//                'Server Verification',
//                MB_YESNO or MB_ICONQUESTION) = IDYES;
//  storehostkey := Result;
end;

//------------------------------------------------------------------------------
constructor TMpfCustomSFTPClient.Create(AOwner: TComponent);
begin
  inherited;
  FPort := 22;
  FDLLInfo := 'Copy tgputtylib.dll to EXE directory.';
  FFiles := TMpfSFTPFiles.Create;
  FConnectTimeout := 5000;
end;

//------------------------------------------------------------------------------
destructor TMpfCustomSFTPClient.Destroy;
begin
  if Connected then begin
    FConnection.OnMessage := nil;
    Disconnect;
    Application.ProcessMessages;
  end;
  FreeAndNil(FFiles);
  inherited;
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.Disconnect;
begin
  if Assigned(FConnection) then begin
    try
      FConnection.Disconnect;
    finally
      FreeAndNil(FConnection);
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.DoOnMessage;
begin
  if Assigned(FOnMessage) then FOnMessage(Self);
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.DownloadFile(const ARemoteFile: string);
var
  ARemoteFileName: string;
  ALocalFile: string;
begin
  ARemoteFileName := ExtractFileName(ARemoteFile);
  ALocalFile := LocalDir + '\' + ARemoteFileName;
  DownloadFile(ARemoteFile, ALocalFile);
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.DownloadStream(const ARemoteFile: string;
  ADest: TStream; const AAppend: Boolean);
begin
  if not Assigned(FConnection) then
    raise Exception.Create('Not connected.');

  FConnection.DownloadStream( Utf8Encode(ARemoteFile), ADest, AAppend );
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.DownloadFile(const ARemoteFile, ALocalFile: string;
  const AAppend: Boolean = false);
begin
  if not Assigned(FConnection) then
    raise Exception.Create('Not connected.');

  FConnection.DownloadFile( Utf8Encode(ARemoteFile), Utf8Encode(ALocalFile),
    AAppend);
end;

//------------------------------------------------------------------------------
function TMpfCustomSFTPClient.ExtractFileName(const AFullPath: string): string;
var
  i: Integer;
begin
  Result := '';
  for i:=Length(AFullPath) downto 1 do begin
    if (AFullPath[i] = '\') or (AFullPath[i] = '/') then
      Break
    else
      Result := AFullPath[i] + Result;
  end;
end;

//------------------------------------------------------------------------------
function TMpfCustomSFTPClient.IsConnected: Boolean;
begin
  Result := false;
  if Assigned(FConnection) then Result := FConnection.Connected;
end;

//------------------------------------------------------------------------------
procedure TMpfCustomSFTPClient.ListDirectory;
begin
  if not Assigned(FConnection) then
    raise Exception.Create('Not connected.');

  FConnection.ListDir( Utf8Encode(FRemoteDir) );
end;

//==============================================================================
{ TMpfSFTPFiles }

function TMpfSFTPFiles.Add(const AName: string): TMpfSFTPFile;
begin
  Result := TMpfSFTPFile.Create(AName);
  FItems.Add(Result);
end;

//------------------------------------------------------------------------------
procedure TMpfSFTPFiles.Clear;
begin
  FItems.Clear;
end;

//------------------------------------------------------------------------------
constructor TMpfSFTPFiles.Create;
begin
  inherited;
  FItems := TCollections.CreateObjectList<TMpfSFTPFile>;
end;

//------------------------------------------------------------------------------
destructor TMpfSFTPFiles.Destroy;
begin
  FItems.Clear;
  inherited;
end;

//------------------------------------------------------------------------------
function TMpfSFTPFiles.GetCount: Integer;
begin
  Result := FItems.Count;
end;

//------------------------------------------------------------------------------
function TMpfSFTPFiles.GetItem(Index: Integer): TMpfSFTPFile;
begin
  Result := FItems[Index];
end;

//==============================================================================
{ TMpfSFTPFile }

constructor TMpfSFTPFile.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

end.
