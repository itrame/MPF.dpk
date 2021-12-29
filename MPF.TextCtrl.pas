unit MPF.TextCtrl;
interface

//==============================================================================
type
  ITextCtrl = interface['{039D7808-0380-422A-AAAD-353EBA1DC95E}']
    function GetText: string;
    procedure SetText(const AText: string);

    property Text: string read GetText write SetText;

  end;

//==============================================================================
implementation

end.
