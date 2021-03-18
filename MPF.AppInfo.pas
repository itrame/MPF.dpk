unit MPF.AppInfo;
interface uses MPF.Version;

//==============================================================================
type
  IAppInfo = interface['{4B042589-8C93-493B-B9FE-4D8C8667BB31}']
    function GetVersion: IAppVersion;
    function GetFileName: string;
    function GetDirectory: string;
    function GetFileVersion: IVersion;
    function GetAppName: string;

    property FileVersion: IVersion read GetFileVersion;
    property Version: IAppVersion read GetVersion;
    property FileName: string read GetFileName;
    property Directory: string read GetDirectory;
    property AppName: string read GetAppName;

  end;

//==============================================================================
function NewAppInfo(const AAppName: string; const ACompile: TCompile = Release): IAppInfo;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
type
  TAppInfo = class(TInterfacedObject, IAppInfo)
  strict private
    Compile: TCompile;
    AppName: string;
    function GetVersion: IAppVersion;
    function GetFileName: string;
    function GetDirectory: string;
    function GetFileVersion: IVersion;
    function GetAppName: string;
  public
    constructor Create(const AAppName: string); overload;
    constructor Create(const AAppName: string; const ACompile: TCompile); overload;
  end;

//==============================================================================
{ TAppInfo }

constructor TAppInfo.Create(const AAppName: string);
begin
  inherited Create;
  AppName := AAppName;
  Compile := Release;
end;

//------------------------------------------------------------------------------
constructor TAppInfo.Create(const AAppName: string; const ACompile: TCompile);
begin
  inherited Create;
  AppName := AAppName;
  Compile := ACompile;
end;

//------------------------------------------------------------------------------
function TAppInfo.GetAppName: string;
begin
  Result := AppName;
end;

//------------------------------------------------------------------------------
function TAppInfo.GetDirectory: string;
begin
  Result := ExtractFileDir(GetFileName);
end;

//------------------------------------------------------------------------------
function TAppInfo.GetFileName: string;
begin
  Result := ParamStr(0);
end;

//------------------------------------------------------------------------------
function TAppInfo.GetFileVersion: IVersion;
var
  AVersionReader: IFileVersionReader;
begin
  AVersionReader := NewFileVersionReader;
  Result := AVersionReader.GetVersion( GetFileName );
end;

//------------------------------------------------------------------------------
function TAppInfo.GetVersion: IAppVersion;
begin
  Result := NewAppVersion( GetFileVersion, Compile );
end;

//==============================================================================
function NewAppInfo(const AAppName: string; const ACompile: TCompile = Release): IAppInfo;
begin
  Result := TAppInfo.Create(AAppName, ACompile);
end;

end.
