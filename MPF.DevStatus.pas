unit MPF.DevStatus;
interface

//==============================================================================
type
  IMpfDevStatus = interface['{0E26E47D-8EA0-4C6F-A6EB-019AD2A8FDAC}']
    function GetTimeStamp: TDateTime;
    property TimeStamp: TDateTime read GetTimeStamp;
  end;

//------------------------------------------------------------------------------
  IMpfEditableDevStatus = interface(IMpfDevStatus)['{1765B6EE-5BD2-4CA8-A59A-E36C48BCB74E}']
    procedure SetTimeStamp(const AValue: TDateTime);
    property TimeStamp: TDateTime read GetTimeStamp write SetTimeStamp;
  end;

//------------------------------------------------------------------------------
  TMpfDevStatus = class(TInterfacedObject, IMpfDevStatus, IMpfEditableDevStatus)
  strict private
    function GetTimeStamp: TDateTime;
    procedure SetTimeStamp(const AValue: TDateTime);
  strict protected
    TimeStamp: TDateTime;
    procedure CopyTo(ADest: TObject); virtual;
  public
    constructor Create;
  end;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
{ TMpfDevStatus }

procedure TMpfDevStatus.CopyTo(ADest: TObject);
var
  ADestStatus: TMpfDevStatus;
begin
  if ADest is TMpfDevStatus then begin
    ADestStatus := ADest as TMpfDevStatus;
    ADestStatus.TimeStamp := TimeStamp;
  end;
end;

//------------------------------------------------------------------------------
constructor TMpfDevStatus.Create;
begin
  inherited;
  TimeStamp := Now;
end;

//------------------------------------------------------------------------------
function TMpfDevStatus.GetTimeStamp: TDateTime;
begin
  Result := TimeStamp;
end;

//------------------------------------------------------------------------------
procedure TMpfDevStatus.SetTimeStamp(const AValue: TDateTime);
begin
  TimeStamp := AValue;
end;

end.
