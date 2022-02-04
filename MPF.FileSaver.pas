unit MPF.FileSaver;
interface

//==============================================================================
type
  IFileSaver<I> = interface['{ABB6B3F6-A7BC-4A87-9C42-90F4347A588C}']
    procedure SaveToFile(AObject: I; const AFileName: string);
  end;

//==============================================================================
implementation

end.
