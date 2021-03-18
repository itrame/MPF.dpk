unit MPF.AppInfo;
interface uses MPF.Version;

//==============================================================================
type
  IAppInfo = interface['{4B042589-8C93-493B-B9FE-4D8C8667BB31}']
    function GetVersion: IAppVersion;
    function GetFileName: string;
    function GetDirectory: string;
    function GetFileVersion: IVersion;

    property FileVersion: IVersion read GetFileVersion;
    property Version: IAppVersion read GetVersion;
    property FileName: string read GetFileName;
    property Directory: string read GetDirectory;

  end;

//==============================================================================
function NewAppInfo(ACompile: TCompile = Release): IAppInfo;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
type
  TAppInfo = class(TInterfacedObject, IAppInfo)
  strict private
    Compile: TCompile;
    function GetVersion: IAppVersion;
    function GetFileName: string;
    function GetDirectory: string;
    function GetFileVersion: IVersion;
  public
    constructor Create; overload;
    constructor Create(ACompile: TCompile); overload;
  end;

//==============================================================================
{ TAppInfo }

constructor TAppInfo.Create;
begin
  inherited;
  Compile := Release;
end;

//------------------------------------------------------------------------------
constructor TAppInfo.Create(ACompile: TCompile);
begin
  inherited Create;
  Compile := ACompile;
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
function NewAppInfo(ACompile: TCompile = Release): IAppInfo;
begin
  Result := TAppInfo.Create(ACompile);
end;

end.
