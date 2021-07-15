unit MPF.Enumerator;
interface uses Spring.Collections;

//==============================================================================
type
  IMpfEnumerator<T> = interface['{BA27D479-46FD-40AF-907E-201AEB2F78AC}']
    function GetCurrent: T;
    function MoveNext: Boolean;
    property Current: T read GetCurrent;
  end;

//------------------------------------------------------------------------------
  TMpfListEnumerator<T> = class(TInterfacedObject, IMpfEnumerator<T>)
  strict private
    ID: Integer;
    Items: IList<T>;
    function GetCurrent: T;
    function MoveNext: Boolean;
  public
    constructor Create(AItems: IList<T>);
  end;

//------------------------------------------------------------------------------
  TMpfQueueEnumerator<T> = class(TInterfacedObject, IMpfEnumerator<T>)
  strict private
    ID: Integer;
    Items: IQueue<T>;
    function GetCurrent: T;
    function MoveNext: Boolean;
  public
    constructor Create(AItems: IQueue<T>);
  end;

//==============================================================================
  TMpfEnumerators = class
    class function NewListEnumerator<T>(AItems: IList<T>): IMpfEnumerator<T>;
    class function NewQueueEnumerator<T>(AItems: IQueue<T>): IMpfEnumerator<T>;
  end;

//==============================================================================
implementation

//==============================================================================
{ TMpfListEnumerator }

constructor TMpfListEnumerator<T>.Create(AItems: IList<T>);
begin
  inherited Create;
  Items := AItems;
  ID := -1;
end;

//------------------------------------------------------------------------------
function TMpfListEnumerator<T>.GetCurrent: T;
begin
  Result := Items[ID];
end;

//------------------------------------------------------------------------------
function TMpfListEnumerator<T>.MoveNext: Boolean;
begin
  Result := ID < (Items.Count-1);
  if Result then Inc(ID);
end;

//==============================================================================
{ TMpfQueueEnumerator }

constructor TMpfQueueEnumerator<T>.Create(AItems: IQueue<T>);
begin
  inherited Create;
  Items := AItems;
  ID := -1;
end;

//------------------------------------------------------------------------------
function TMpfQueueEnumerator<T>.GetCurrent: T;
begin
  Result := Items.ElementAt(ID);
end;

//------------------------------------------------------------------------------
function TMpfQueueEnumerator<T>.MoveNext: Boolean;
begin
  Result := ID < (Items.Count-1);
  if Result then Inc(ID);
end;


//==============================================================================
{ TMpfEnumerators }

class function TMpfEnumerators.NewListEnumerator<T>(
  AItems: IList<T>): IMpfEnumerator<T>;
begin
  Result := TMpfListEnumerator<T>.Create(AItems);
end;

//------------------------------------------------------------------------------
class function TMpfEnumerators.NewQueueEnumerator<T>(
  AItems: IQueue<T>): IMpfEnumerator<T>;
begin
  Result := TMpfQueueEnumerator<T>.Create(AItems);
end;

end.
