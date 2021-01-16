unit MPF.Connections;
interface

//==============================================================================
type
  IIPConnectionInfo = interface['{FAC85938-2524-4FDC-B318-EFF7A101EE88}']
    function GetAddress: string;
    function GetPort: Word;
    property Address: string read GetAddress;
    property Port: Word read GetPort;
  end;

//------------------------------------------------------------------------------
  IConfigurableIPConnection = interface(IIpConnectionInfo)['{0D603E35-6FD2-490A-B276-38C3228B0147}']
    procedure SetAddress(const AAdress: string);
    procedure SetPort(const APort: Word);
    property Address: string read GetAddress write SetAddress;
    property Port: Word read GetPort write SetPort;
  end;

//------------------------------------------------------------------------------
  IConnection = interface['{1B0B63CB-7407-4B8B-961D-42B9589FCDC3}']
    procedure Send(const AData: TArray<Boolean>);
    function Receive(const ACount: Integer): TArray<Byte>;
  end;

//==============================================================================
implementation

end.
