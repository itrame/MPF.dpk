unit MPF.ApplicationVersion;
interface uses MPF.Version;

//==============================================================================
type
  TMpfCompile = (Alpha, Beta, Release);

//------------------------------------------------------------------------------
  IMpfApplicationVersion = interface(IMpfVersion)['{75C1562F-B604-45E0-8A37-4A155F9788EC}']
    function GetCompile: TMpfCompile;
    property Compile: TMpfCompile read GetCompile;
  end;

//------------------------------------------------------------------------------
  IMpfEditableApplicationVersion = interface(IMpfEditableVersion)['{55FD3653-F8C7-48EC-A0C3-AC719D9DD9A9}']
    function GetCompile: TMpfCompile;
    procedure SetCompile(const AValue: TMpfCompile);
    property Compile: TMpfCompile read GetCompile write SetCompile;
  end;

//==============================================================================
implementation uses Spring.Container;

//==============================================================================
type
  TMpfApplicationVersion = class(TMpfVersion, IMpfVersion, IMpfEditableVersion,
    IMpfApplicationVersion, IMpfEditableApplicationVersion)
  strict private
    Compile: TMpfCompile;
    function GetCompile: TMpfCompile;
    procedure SetCompile(const AValue: TMpfCompile);
  strict protected
    function ToStr: string; override;
  public
    constructor Create(const ACompile: TMpfCompile);
//    constructor Create(AVersion: IMpfVersion; const ACompile: TMpfCompile); overload;
//    constructor Create(const AMajor, AMinor, ARelease, ABuild: UInt32; const ACompile: TMpfCompile);
  end;

//==============================================================================
{ TMpfApplicationVersion }

//constructor TMpfApplicationVersion.Create(AVersion: IMpfVersion;
//  const ACompile: TMpfCompile);
//begin
//  inherited Create(AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build);
//  Compile := ACompile;
//end;

//------------------------------------------------------------------------------
//constructor TMpfApplicationVersion.Create(const AMajor, AMinor, ARelease,
//  ABuild: UInt32; const ACompile: TMpfCompile);
//begin
//  inherited Create(AMajor, AMinor, ARelease, ABuild);
//  Compile := ACompile;
//end;

//------------------------------------------------------------------------------
constructor TMpfApplicationVersion.Create(const ACompile: TMpfCompile);
begin
  inherited Create(0,0,0,0);
  Compile := ACompile;
end;

//------------------------------------------------------------------------------
function TMpfApplicationVersion.GetCompile: TMpfCompile;
begin
  Result := Compile;
end;

//------------------------------------------------------------------------------
procedure TMpfApplicationVersion.SetCompile(const AValue: TMpfCompile);
begin
  Compile := AValue;
end;

//------------------------------------------------------------------------------
function TMpfApplicationVersion.ToStr: string;
begin
  Result := inherited;
  case Compile of
    Alpha:  Result := Result + 'a';
    Beta:   Result := Result + 'b';
  end;
end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TMpfApplicationVersion>.
    Implements<IMpfApplicationVersion>.
    Implements<IMpfEditableApplicationVersion>;
end.
