unit MPF.Version;
interface

//==============================================================================
type
  TCompile = (Alpha, Beta, Release);

//------------------------------------------------------------------------------
  IVersion = interface['{C4544B16-66AD-4DEE-ABCD-F045CEDC0E4B}']
    function GetMajor: UInt16;
    function GetMinor: UInt16;
    function GetRelease: UInt16;
    function GetBuild: UInt16;
    function AsString: string;

    property Major: UInt16 read GetMajor;
    property Minor: UInt16 read GetMinor;
    property Release: UInt16 read GetRelease;
    property Build: UInt16 read GetBuild;

  end;

//------------------------------------------------------------------------------
  IAppVersion = interface(IVersion)['{46CD08A0-6654-4FD1-91E1-257ED312667B}']
    function GetCompile: TCompile;
    property Compile: TCompile read GetCompile;
  end;

//------------------------------------------------------------------------------
  IFileVersionReader = interface['{35B1DA93-230A-471C-8B4B-455779D42018}']
    function GetVersion(const AFileName: string): IVersion;
  end;

//==============================================================================
function NewFileVersionReader: IFileVersionReader;
function NewVersion(const AMajor, AMinor, ARelease, ABuild: UInt16): IVersion;
function NewAppVersion(AVersion: IVersion; const ACompile: TCompile): IAppVersion;

//==============================================================================
implementation uses Windows, SysUtils;

//==============================================================================
type
  TVersion = class(TInterfacedObject, IVersion)
  strict private
    Major: UInt16;
    Minor: UInt16;
    Release: UInt16;
    Build: UInt16;
    function GetMajor: UInt16;
    function GetMinor: UInt16;
    function GetRelease: UInt16;
    function GetBuild: UInt16;
  strict protected
    function AsString: string; virtual;
  public
    constructor Create(const AMajor, AMinor, ARelease, ABuild: UInt16);
  end;

//------------------------------------------------------------------------------
  TAppVersion = class(TVersion, IAppVersion)
  strict private
    Compile: TCompile;
    function GetCompile: TCompile;

  strict protected
    function AsString: string; override;

  public
    constructor Create(const AMajor, AMinor, ARelease, ABuild: UInt16;
      const ACompile: TCompile = Release); overload;

    constructor Create(AVersion: IVersion; const ACompile: TCompile); overload;

  end;

//------------------------------------------------------------------------------
  TFileVersionReader = class(TInterfacedObject, IFileVersionReader)
  strict private
    function GetVersion(const AFileName: string): IVersion;
  end;

//==============================================================================
{ TMpFileVersionReader }

function TFileVersionReader.GetVersion(const AFileName: string): IVersion;
var
  AVerInfoSize, AVerValueSize, ADummy: UInt32;
  AVerInfo: Pointer;
  AVerValue: PVSFixedFileInfo;
  AMajor, AMinor, ARelease, ABuild: UInt16;

begin
  AVerInfoSize := GetFileVersionInfoSize(PChar(AFileName), ADummy);
  if AVerInfoSize < 1 then Exit;

  GetMem(AVerInfo, AVerInfoSize);
  try

    if GetFileVersionInfo(PChar(AFileName), 0, AVerInfoSize, AVerInfo) then
    begin
      VerQueryValue(AVerInfo, '\', Pointer(AVerValue), AVerValueSize);
      with AVerValue^ do
      begin
        AMajor := dwFileVersionMS shr 16;
        AMinor := dwFileVersionMS and $FFFF;
        ARelease := dwFileVersionLS shr 16;
        ABuild := dwFileVersionLS and $FFFF;
      end;

      Result := NewVersion(AMajor, AMinor, ARelease, ABuild);

    end;

  finally
    FreeMem(AVerInfo, AVerInfoSize);
  end;

end;

//==============================================================================
{ TVersion }

function TVersion.AsString: string;
begin
  Result := Major.ToString + '.' + Minor.ToString + '.' + Release.ToString +
    '.' + Build.ToString;
end;

//------------------------------------------------------------------------------
constructor TVersion.Create(const AMajor, AMinor, ARelease, ABuild: UInt16);
begin
  inherited Create;
  Major := AMajor;
  Minor := AMinor;
  Release := ARelease;
  Build := ABuild;
end;

//------------------------------------------------------------------------------
function TVersion.GetBuild: UInt16;
begin
  Result := Build;
end;

//------------------------------------------------------------------------------
function TVersion.GetMajor: UInt16;
begin
  Result := Major;
end;

//------------------------------------------------------------------------------
function TVersion.GetMinor: UInt16;
begin
  Result := Minor;
end;

//------------------------------------------------------------------------------
function TVersion.GetRelease: UInt16;
begin
  Result := Release;
end;

//==============================================================================
{ TAppVersion }

function TAppVersion.AsString: string;
begin
  Result := inherited;
  case Compile of
    Alpha:    Result := Result + 'a';
    Beta:     Result := Result + 'b';
  end;
end;

//------------------------------------------------------------------------------
constructor TAppVersion.Create(const AMajor, AMinor, ARelease, ABuild: UInt16;
  const ACompile: TCompile = Release);
begin
  inherited Create(AMajor, AMinor, ARelease, ABuild);
  Compile := ACompile;
end;

//------------------------------------------------------------------------------
constructor TAppVersion.Create(AVersion: IVersion; const ACompile: TCompile);
begin
  inherited Create(AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build);
  Compile := ACompile;
end;

//------------------------------------------------------------------------------
function TAppVersion.GetCompile: TCompile;
begin
  Result := Compile;
end;

//==============================================================================
function NewFileVersionReader: IFileVersionReader;
begin
  Result := TFileVersionReader.Create;
end;

//------------------------------------------------------------------------------
function NewVersion(const AMajor, AMinor, ARelease, ABuild: UInt16): IVersion;
begin
  Result := TVersion.Create(AMajor, AMinor, ARelease, ABuild);
end;

//------------------------------------------------------------------------------
function NewAppVersion(AVersion: IVersion; const ACompile: TCompile): IAppVersion;
begin
  Result := TAppVersion.Create(AVersion, ACompile);
end;

end.

