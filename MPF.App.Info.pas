unit MPF.App.Info;
interface uses MPF.App.Version;

//==============================================================================
type
  IMpfAppInfo = interface['{67285492-009A-4321-8D68-A145FE5BDCED}']
    function GetVersion: IMpfApplicationVersion;
    function GetAppName: string;
    procedure SetAppName(const AAppName: string);
    procedure SetVersion(const AMajor, AMinor, ARelease, ABuild: UInt32; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromFile(const AFileName: string; const ACompile: TMpfCompile = Release);
    procedure SetVersionFromExe(const ACompile: TMpfCompile = Release);
    function GetAppNameVer: string;
    function GetAppNameVerSep: string;
    procedure SetAppNameVerSep(const ASep: string);
    function GetExeDir: string;

    property Version: IMpfApplicationVersion read GetVersion;
    property AppName: string read GetAppName write SetAppName;
    property AppNameVer: string read GetAppNameVer;
    property AppNameVerSep: string read GetAppNameVerSep write SetAppNameVerSep;
    property ExeDir: string read GetExeDir;

  end;

//==============================================================================
implementation uses SysUtils, Spring.Container, Spring.Services,
  MPF.FileVersionReader, MPF.Version;

//==============================================================================
type
  TMpfAppInfo = class(TInterfacedObject, IMpfAppInfo)
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
    function GetExeDir: string;
  public
    constructor Create;
  end;


//==============================================================================
{ TMpfAppInfo }

constructor TMpfAppInfo.Create;
begin
  inherited;
  Version := ServiceLocator.GetService<IMpfEditableApplicationVersion>;
  AppNameVerSep := ' ';
end;

//------------------------------------------------------------------------------
function TMpfAppInfo.GetAppName: string;
begin
  Result := AppName;
end;

//------------------------------------------------------------------------------
function TMpfAppInfo.GetAppNameVer: string;
begin
  Result := AppName + ' ' + Version.ToStr;
end;

//------------------------------------------------------------------------------
function TMpfAppInfo.GetAppNameVerSep: string;
begin
  Result := AppNameVerSep;
end;

//------------------------------------------------------------------------------
function TMpfAppInfo.GetExeDir: string;
begin
  Result := ParamStr(0);
end;

//------------------------------------------------------------------------------
function TMpfAppInfo.GetVersion: IMpfApplicationVersion;
begin
  if not Supports(Version, IMpfApplicationVersion, Result) then Result := nil;
end;

//------------------------------------------------------------------------------
procedure TMpfAppInfo.SetAppName(const AAppName: string);
begin
  AppName := AAppName;
end;

//------------------------------------------------------------------------------
procedure TMpfAppInfo.SetAppNameVerSep(const ASep: string);
begin
  AppNameVerSep := ASep;
end;

//------------------------------------------------------------------------------
procedure TMpfAppInfo.SetVersion(const AMajor, AMinor, ARelease,
  ABuild: UInt32; const ACompile: TMpfCompile);
begin
  Version.Major := AMajor;
  Version.Minor := AMinor;
  Version.Release := ARelease;
  Version.Build := ABuild;
  Version.Compile := ACompile;
end;

//------------------------------------------------------------------------------
procedure TMpfAppInfo.SetVersionFromExe(const ACompile: TMpfCompile);
begin
  SetVersionFromFile(ParamStr(0), ACompile);
end;

//------------------------------------------------------------------------------
procedure TMpfAppInfo.SetVersionFromFile(const AFileName: string;
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
  GlobalContainer.RegisterType<TMpfAppInfo>.
    Implements<IMpfAppInfo>;

end.
