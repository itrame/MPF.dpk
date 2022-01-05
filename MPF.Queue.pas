unit MPF.Queue;
interface uses Spring.Collections;

//==============================================================================
type
  IMpfReadOnlyQueue<T> = interface['{D2AACABE-B137-4A7E-92B7-1CE3DF817F72}']
    function GetMaxCount: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): T;
    function GetLast: T;
    function GetFirst: T;
    function GetEnumerator: IEnumerator<T>;

    property MaxCount: Integer read GetMaxCount;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: T read GetItem; default;
    property Last: T read GetLast;
    property First: T read GetFirst;

  end;

//------------------------------------------------------------------------------
  IMpfConfigurableQueue<T> = interface(IMpfReadOnlyQueue<T>)['{7A4E7DA1-6932-4A54-90A6-9257D71970EB}']
    procedure SetMaxCount(const AValue: Integer);
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
  end;

//------------------------------------------------------------------------------
  IMpfQueue<T> = interface(IMpfConfigurableQueue<T>)['{EFDFB9AF-EF3E-4728-B116-FDC9F924E07B}']
    function Dequeue: T;
    procedure Enqueue(AItem: T);
    procedure Clear;
  end;

//==============================================================================
  TMpfQueue<T> = class(TInterfacedObject, IMpfReadOnlyQueue<T>, IMpfConfigurableQueue<T>,
    IMpfQueue<T>)
  strict private
    Items: IQueue<T>;
    MaxCount: Integer;

    function GetMaxCount: Integer;
    procedure SetMaxCount(const AValue: Integer);
    function GetCount: Integer;
    function GetItem(Index: Integer): T;
    function Dequeue: T;
    procedure Enqueue(AItem: T);
    procedure Clear;
    function GetLast: T;
    function GetFirst: T;
    function GetEnumerator: IEnumerator<T>;

  public
    constructor Create;

  end;

//==============================================================================
  TMpfQueues = class
    class function NewQueue<T>: IMpfQueue<T>;
  end;

//==============================================================================
implementation uses SysUtils;

//==============================================================================
{ TMpfQueue<T> }

procedure TMpfQueue<T>.Clear;
begin
  Items.Clear;
end;

//------------------------------------------------------------------------------
constructor TMpfQueue<T>.Create;
begin
  inherited;
  Items := TCollections.CreateQueue<T>;
  MaxCount := 1;
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.Dequeue: T;
begin
  Result := Items.Dequeue;
end;

//------------------------------------------------------------------------------
procedure TMpfQueue<T>.Enqueue(AItem: T);
begin
  if MaxCount >= 0 then begin
    if MaxCount > 0 then begin
      while Items.Count >= MaxCount do Items.Dequeue;
      Items.Enqueue(AItem);
    end;
  end else
    Items.Enqueue(AItem);
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetCount: Integer;
begin
  Result := Items.Count;
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := Items.GetEnumerator;
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetFirst: T;
begin
  if Items.Count > 0 then
    Result := Items.ElementAt(0)
  else
    raise Exception.Create('TMpfQueue out of bound.');
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetItem(Index: Integer): T;
begin
  Result := Items.ElementAt(Index);
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetLast: T;
begin
  if Items.Count > 0 then
    Result := Items.ElementAt(Items.Count-1)
  else
    raise Exception.Create('TMpfQueue out of bound.');
end;

//------------------------------------------------------------------------------
function TMpfQueue<T>.GetMaxCount: Integer;
begin
  Result := MaxCount;
end;

//------------------------------------------------------------------------------
procedure TMpfQueue<T>.SetMaxCount(const AValue: Integer);
begin
  if AValue = MaxCount then Exit;
  if AValue < -1 then
    raise Exception.Create('Invalid MaxCount value: ' + AValue.ToString);

  MaxCount := AValue;
  if MaxCount >= 0 then while Items.Count > MaxCount do Items.Dequeue;

end;

//==============================================================================
{ TMpfQueues }

class function TMpfQueues.NewQueue<T>: IMpfQueue<T>;
begin
  Result := TMpfQueue<T>.Create;
end;

end.
