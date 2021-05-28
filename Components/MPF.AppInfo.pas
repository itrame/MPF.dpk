unit MPF.AppInfo;
interface uses Classes, MPF.Persistent;

//==============================================================================
type
  TCompile = (cAlpha, cBeta, cRelease);


  TVersion = class(TmpfPersistent)
  strict private
    procedure SetBuild(const Value: UInt16);
    procedure SetMajor(const Value: UInt16);
    procedure SetMinor(const Value: UInt16);
    procedure SetRelease(const Value: UInt16);
  private
    FMajor: UInt16;
    FMinor: UInt16;
    FRelease: UInt16;
    FBuild: UInt16;
  strict protected
    function AsString: string; virtual;
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent);
  published
    property Major: UInt16 read FMajor write SetMajor;
    property Minor: UInt16 read FMinor write SetMinor;
    property Release: UInt16 read FRelease write SetRelease;
    property Build: UInt16 read FBuild write SetBuild;
    property Text: string read AsString;
  end;


  TAppVersion = class(TVersion)
  strict private
    procedure SetCompile(const AValue: TCompile);
  private
    FCompile: TCompile;
  strict protected
    procedure AssignTo(ADest: TPersistent); override;
    function AsString: string; override;
  public
    constructor Create(AOwner: TPersistent); overload;
  published
    property Compile: TCompile read FCompile write SetCompile;
  end;


  TmpfAppInfo = class(TComponent)
  private
    FAppName: string;
    FVersion: TAppVersion;
    FSeparator: string;
    FFileVersion: TAppVersion;
    function GetFileVersion: TAppVersion;
    procedure SetAppName(const Value: string);
    procedure SetVersion(AVersion: TAppVersion);
    function GetFileName: string;
    function GetDirectory: string;
    function GetAppNameVer: string;
    procedure UpdateFileVersion;
    function GetAppNameFileVer: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FileName: string read GetFileName;
    property Directory: string read GetDirectory;
    property FileVersion: TAppVersion read GetFileVersion;
    property AppNameFileVer: string read GetAppNameFileVer;
  published
    property AppName: string read FAppName write SetAppName;
    property Version: TAppVersion read FVersion write SetVersion;
    property AppNameVer: string read GetAppNameVer;
    property Separator: string read FSeparator write FSeparator;
  end;

//==============================================================================
procedure Register;

//==============================================================================
implementation uses SysUtils, Windows;

//==============================================================================
{ TVersion }

procedure TVersion.AssignTo(ADest: TPersistent);
var
  ADestVer: TVersion;
begin
  if ADest is TVersion then begin
    ADestVer := ADest as TVersion;
    ADestVer.FMajor := FMajor;
    ADestVer.FMinor := FMinor;
    ADestVer.FRelease := FRelease;
    ADestVer.FBuild := FBuild;
  end;
end;


function TVersion.AsString: string;
begin
  Result := FMajor.ToString + '.' + FMinor.ToString + '.' + FRelease.ToString +
    '.' + FBuild.ToString;
end;


constructor TVersion.Create(AOwner: TPersistent);
begin
  inherited;
  FMajor := 1;
  FMinor := 0;
  FRelease := 0;
  FBuild := 1;
end;


procedure TVersion.SetBuild(const Value: UInt16);
begin
  SetDesignParam(FBuild, Value);
end;


procedure TVersion.SetMajor(const Value: UInt16);
begin
  SetDesignParam(FMajor, Value);
end;


procedure TVersion.SetMinor(const Value: UInt16);
begin
  SetDesignParam(FMinor, Value);
end;


procedure TVersion.SetRelease(const Value: UInt16);
begin
  SetDesignParam(FRelease, Value);
end;

//==============================================================================
{ TAppVersion }

procedure TAppVersion.AssignTo(ADest: TPersistent);
var
  ADestAppVer: TAppVersion;
begin
  inherited;
  if ADest is TAppVersion then begin
    ADestAppVer := ADest as TAppVersion;
    ADestAppVer.FCompile := FCompile;
  end;
end;


function TAppVersion.AsString: string;
begin
  Result := inherited;
  case FCompile of
    cAlpha:    Result := Result + 'a';
    cBeta:     Result := Result + 'b';
  end;
end;


constructor TAppVersion.Create(AOwner: TPersistent);
begin
  inherited;
  FCompile := cRelease;
end;


procedure TAppVersion.SetCompile(const AValue: TCompile);
begin
  SetDesignParam(FCompile, AValue);
end;

//==============================================================================
{ TmpfAppInfo }

constructor TmpfAppInfo.Create(AOwner: TComponent);
begin
  inherited;
  FVersion := TAppVersion.Create(Self);
  FFileVersion := TAppVersion.Create(Self);
  FSeparator := ' v';
end;


destructor TmpfAppInfo.Destroy;
begin
  FFileVersion.Free;
  FVersion.Free;
  inherited;
end;


function TmpfAppInfo.GetAppNameFileVer: string;
begin
  Result := AppName + Separator + FileVersion.Text;
end;


function TmpfAppInfo.GetAppNameVer: string;
begin
  Result := AppName + Separator + Version.Text;
end;


function TmpfAppInfo.GetDirectory: string;
begin
  Result := ExtractFileDir(FileName);
end;


function TmpfAppInfo.GetFileName: string;
begin
  Result := ParamStr(0);
end;


function TmpfAppInfo.GetFileVersion: TAppVersion;
begin
  UpdateFileVersion;
  Result := FFileVersion;
end;


procedure TmpfAppInfo.SetAppName(const Value: string);
begin
  if (csDesigning in ComponentState) or (csReading in ComponentState) then
    FAppName := Value;
end;


procedure TmpfAppInfo.SetVersion(AVersion: TAppVersion);
begin
  FVersion.Assign(AVersion);
end;


procedure TmpfAppInfo.UpdateFileVersion;
var
  AVerInfoSize, AVerValueSize, ADummy: UInt32;
  AVerInfo: Pointer;
  AVerValue: PVSFixedFileInfo;

begin
  AVerInfoSize := GetFileVersionInfoSize(PChar(FileName), ADummy);
  if AVerInfoSize < 1 then Exit;

  GetMem(AVerInfo, AVerInfoSize);
  try

    if GetFileVersionInfo(PChar(FileName), 0, AVerInfoSize, AVerInfo) then
    begin
      VerQueryValue(AVerInfo, '\', Pointer(AVerValue), AVerValueSize);
      with AVerValue^ do
      begin
        FFileVersion.FMajor := dwFileVersionMS shr 16;
        FFileVersion.FMinor := dwFileVersionMS and $FFFF;
        FFileVersion.FRelease := dwFileVersionLS shr 16;
        FFileVersion.FBuild := dwFileVersionLS and $FFFF;
      end;

    end;

    FFileVersion.FCompile := FVersion.FCompile;

  finally
    FreeMem(AVerInfo, AVerInfoSize);
  end;


end;

//==============================================================================

procedure Register;
begin
  RegisterComponents('MPF', [TmpfAppInfo]);
end;

end.
