unit MPF.ApplicationInfo;
interface uses MPF.ApplicationVersion;

//==============================================================================
type
  IMpfApplicationInfo = interface['{67285492-009A-4321-8D68-A145FE5BDCED}']
    function GetVersion: IMpfApplicationVersion;
    function GetAppName: string;
    procedure SetAppName(const AAppName: string);
    procedure SetVersion(const AMajor, AMinor, ARelease, ABuild: UInt32; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromFile(const AFileName: string; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromExe(const ACompile: TMpfCompile = Release);
    function GetAppNameVer: string;
    function GetAppNameVerSep: string;
    procedure SetAppNameVerSep(const ASep: string);

    property Version: IMpfApplicationVersion read GetVersion;
    property AppName: string read GetAppName write SetAppName;
    property AppNameVer: string read GetAppNameVer;
    property AppNameVerSep: string read GetAppNameVerSep write SetAppNameVerSep;

  end;

//==============================================================================
implementation uses SysUtils, Spring.Container, Spring.Services,
  MPF.FileVersionReader, MPF.Version;

//==============================================================================
type
  TMpfApplicationInfo = class(TInterfacedObject, IMpfApplicationInfo)
  strict private
    Version: IMpfEditableApplicationVersion;
    AppName: string;
    AppNameVerSep: string;
    function GetVersion: IMpfApplicationVersion;
    procedure SetVersion(const AMajor, AMinor, ARelease, ABuild: UInt32; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromFile(const AFileName: string; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromExe(const ACompile: TMpfCompile = Release);
    function GetAppName: string;
    procedure SetAppName(const AAppName: string);
    function GetAppNameVer: string;
    function GetAppNameVerSep: string;
    procedure SetAppNameVerSep(const ASep: string);
  public
    constructor Create;
  end;


//==============================================================================
{ TMpfApplicationInfo }

constructor TMpfApplicationInfo.Create;
begin
  inherited;
  Version := ServiceLocator.GetService<IMpfEditableApplicationVersion>;
  AppNameVerSep := ' ';
end;

//------------------------------------------------------------------------------
function TMpfApplicationInfo.GetAppName: string;
begin
  Result := AppName;
end;

//------------------------------------------------------------------------------
function TMpfApplicationInfo.GetAppNameVer: string;
begin
  Result := AppName + ' ' + Version.ToStr;
end;

//------------------------------------------------------------------------------
function TMpfApplicationInfo.GetAppNameVerSep: string;
begin
  Result := AppNameVerSep;
end;

//------------------------------------------------------------------------------
function TMpfApplicationInfo.GetVersion: IMpfApplicationVersion;
begin
  if not Supports(Version, IMpfApplicationVersion, Result) then Result := nil;
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationInfo.SetAppName(const AAppName: string);
begin
  AppName := AAppName;
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationInfo.SetAppNameVerSep(const ASep: string);
begin
  AppNameVerSep := ASep;
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationInfo.SetVersion(const AMajor, AMinor, ARelease,
  ABuild: UInt32; const ACompile: TMpfCompile);
begin
  Version.Major := AMajor;
  Version.Minor := AMinor;
  Version.Release := ARelease;
  Version.Build := ABuild;
  Version.Compile := ACompile;
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationInfo.SetVersionFromExe(const ACompile: TMpfCompile);
begin
  SetVersionFromFile(ParamStr(0), ACompile);
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationInfo.SetVersionFromFile(const AFileName: string;
  const ACompile: TMpfCompile);
var
  AReader: IMpfFileVersionReader;
  AFileVersion: IMpfVersion;
begin
  AReader := ServiceLocator.GetService<IMpfFileVersionReader>;
  AFileVersion := AReader.GetVersion(AFileName);
  AFileVersion.CopyTo(Version);
  Version.Compile := ACompile;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TMpfApplicationInfo>.
    Implements<IMpfApplicationInfo>;

end.
