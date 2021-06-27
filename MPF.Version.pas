unit MPF.Version;
interface

//==============================================================================
type
  IMpfEditableVersion = interface;

  IMpfVersion = interface['{95DF0014-3F79-4A37-A8F2-AB985A427682}']
    function GetMajor: UInt32;
    function GetMinor: UInt32;
    function GetRelease: UInt32;
    function GetBuild: UInt32;
    function ToStr: string;
    procedure CopyTo(ADest: IMpfEditableVersion);

    property Major: UInt32 read GetMajor;
    property Minor: UInt32 read GetMinor;
    property Release: UInt32 read GetRelease;
    property Build: UInt32 read GetBuild;

  end;

//------------------------------------------------------------------------------
  IMpfEditableVersion = interface(IMpfVersion)['{605D1E78-0977-4E0E-837A-19FD99F3674F}']
    procedure SetMajor(const AValue: UInt32);
    procedure SetMinor(const AValue: UInt32);
    procedure SetRelease(const AValue: UInt32);
    procedure SetBuild(const AValue: UInt32);

    property Major: UInt32 read GetMajor write SetMajor;
    property Minor: UInt32 read GetMinor write SetMinor;
    property Release: UInt32 read GetRelease write SetRelease;
    property Build: UInt32 read GetBuild write SetBuild;
  end;

//------------------------------------------------------------------------------
  TMpfVersion = class(TInterfacedObject, IMpfVersion, IMpfEditableVersion)
  strict protected
    Major, Minor, Release, Build: UInt32;
    function GetMajor: UInt32;
    function GetMinor: UInt32;
    function GetRelease: UInt32;
    function GetBuild: UInt32;
    procedure SetMajor(const AValue: UInt32);
    procedure SetMinor(const AValue: UInt32);
    procedure SetRelease(const AValue: UInt32);
    procedure SetBuild(const AValue: UInt32);
    function ToStr: string; virtual;
    procedure CopyTo(ADest: IMpfEditableVersion); virtual;
  public
    constructor Create(const AMajor, AMinor, ARelease, ABuild: UInt32);
  end;

//==============================================================================
implementation uses Spring.Container, SysUtils;

//==============================================================================
{ TMpfVersion }

procedure TMpfVersion.CopyTo(ADest: IMpfEditableVersion);
var
  ADestObject: TObject;
  ADestVersion: TMpfVersion;
begin
  ADestObject := ADest as TObject;
  if ADestObject is TMpfVersion then begin
    ADestVersion := ADestObject as TMpfVersion;
    ADestVersion.Major := Major;
    ADestVersion.Minor := Minor;
    ADestVersion.Release := Release;
    ADestVersion.Build := Build;
  end;
end;

//------------------------------------------------------------------------------
constructor TMpfVersion.Create(const AMajor, AMinor, ARelease, ABuild: UInt32);
begin
  inherited Create;
  Major := AMajor;
  Minor := AMinor;
  Release := ARelease;
  Build := ABuild;
end;

//------------------------------------------------------------------------------
function TMpfVersion.GetBuild: UInt32;
begin
  Result := Build;
end;

//------------------------------------------------------------------------------
function TMpfVersion.GetMajor: UInt32;
begin
  Result := Major;
end;

//------------------------------------------------------------------------------
function TMpfVersion.GetMinor: UInt32;
begin
  Result := Minor;
end;

//------------------------------------------------------------------------------
function TMpfVersion.GetRelease: UInt32;
begin
  Result := Release;
end;

//------------------------------------------------------------------------------
procedure TMpfVersion.SetBuild(const AValue: UInt32);
begin
  Build := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfVersion.SetMajor(const AValue: UInt32);
begin
  Major := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfVersion.SetMinor(const AValue: UInt32);
begin
  Minor := AValue;
end;

//------------------------------------------------------------------------------
procedure TMpfVersion.SetRelease(const AValue: UInt32);
begin
  Release := AValue;
end;

//------------------------------------------------------------------------------
function TMpfVersion.ToStr: string;
begin
  Result := Major.ToString + '.' + Minor.ToString + '.' + Release.ToString + '.'
    + Build.ToString;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TMpfVersion>.
    Implements<IMpfVersion>.
    Implements<IMpfEditableVersion>;

end.
