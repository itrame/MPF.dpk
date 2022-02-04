unit MPF.FileLoader;
interface

//==============================================================================
type
  IFileLoader<I> = interface['{297CC8A5-D8CD-4948-90A0-5795C2E204BB}']
    procedure LoadFromFile(AObject: I; const AFileName: string);
  end;

//==============================================================================
implementation

end.
