unit MPF.Filer;
interface

//==============================================================================
type
  IFiler<I> = interface['{E7F24484-2939-427E-B23F-6846F46D5807}']
    procedure LoadFromFile(AObject: I; const AFileName: string);
    procedure SaveToFile(AObject: I; const AFileName: string);
  end;

//==============================================================================
implementation

end.
