unit MPF.FileVersionReader;
interface uses Classes, MPF.Version;

//==============================================================================
type
  IMpfFileVersionReader = interface['{35B1DA93-230A-471C-8B4B-455779D42018}']
    function GetVersion(const AFileName: string): IMpfVersion;
  end;

//==============================================================================
implementation uses Windows, SysUtils, Spring.Services, Spring.Container;

//==============================================================================
type
  TMpfFileVersionReader = class(TInterfacedObject, IMpfFileVersionReader)
  strict private
    function GetVersion(const AFileName: string): IMpfVersion;
  end;

//==============================================================================
{ TMpfFileVersionReader }

function TMpfFileVersionReader.GetVersion(const AFileName: string): IMpfVersion;
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

      Result := ServiceLocator.GetService<IMpfVersion>([AMajor, AMinor, ARelease, ABuild]);

    end;

  finally
    FreeMem(AVerInfo, AVerInfoSize);
  end;

end;

//==============================================================================
initialization
  GlobalContainer.RegisterType<TMpfFileVersionReader>.
    Implements<IMpfFileVersionReader>;

end.


