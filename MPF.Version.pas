unit MPF.Version;
interface uses Classes;

//==============================================================================
//type


//------------------------------------------------------------------------------
//  IFileVersionReader = interface['{35B1DA93-230A-471C-8B4B-455779D42018}']
//    function GetVersion(const AFileName: string): IVersion;
//  end;

//==============================================================================
//function NewFileVersionReader: IFileVersionReader;
//function NewAppVersion(AVersion: IVersion; const ACompile: TCompile): IAppVersion;

//==============================================================================
implementation uses Windows, SysUtils;

//==============================================================================
//type




//------------------------------------------------------------------------------
//  TFileVersionReader = class(TInterfacedObject, IFileVersionReader)
//  strict private
//    function GetVersion(const AFileName: string): IVersion;
//  end;

//==============================================================================
{ TMpFileVersionReader }

//function TFileVersionReader.GetVersion(const AFileName: string): IVersion;
//var
//  AVerInfoSize, AVerValueSize, ADummy: UInt32;
//  AVerInfo: Pointer;
//  AVerValue: PVSFixedFileInfo;
//  AMajor, AMinor, ARelease, ABuild: UInt16;
//
//begin
//  AVerInfoSize := GetFileVersionInfoSize(PChar(AFileName), ADummy);
//  if AVerInfoSize < 1 then Exit;
//
//  GetMem(AVerInfo, AVerInfoSize);
//  try
//
//    if GetFileVersionInfo(PChar(AFileName), 0, AVerInfoSize, AVerInfo) then
//    begin
//      VerQueryValue(AVerInfo, '\', Pointer(AVerValue), AVerValueSize);
//      with AVerValue^ do
//      begin
//        AMajor := dwFileVersionMS shr 16;
//        AMinor := dwFileVersionMS and $FFFF;
//        ARelease := dwFileVersionLS shr 16;
//        ABuild := dwFileVersionLS and $FFFF;
//      end;
//
//      Result := NewVersion(AMajor, AMinor, ARelease, ABuild);
//
//    end;
//
//  finally
//    FreeMem(AVerInfo, AVerInfoSize);
//  end;
//
//end;





//==============================================================================
//function NewFileVersionReader: IFileVersionReader;
//begin
//  Result := TFileVersionReader.Create;
//end;
//
////------------------------------------------------------------------------------
//function NewVersion(const AMajor, AMinor, ARelease, ABuild: UInt16): IVersion;
//begin
//  Result := TVersion.Create(AMajor, AMinor, ARelease, ABuild);
//end;
//
////------------------------------------------------------------------------------
//function NewAppVersion(AVersion: IVersion; const ACompile: TCompile): IAppVersion;
//begin
//  Result := TAppVersion.Create(AVersion, ACompile);
//end;

end.


