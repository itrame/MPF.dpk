unit MPF.Helpers;
interface uses SysUtils, MPF.Types, Vcl.StdCtrls, Vcl.ComCtrls, Spring.Collections,
  Classes;

//==============================================================================
type
  TBoolArray = TArray<Boolean>;

  TByteHelper = record helper for Byte
    function GetBit(Index: Byte): Boolean;
    procedure SetBit(Index: Byte; const AValue: Boolean);
    function ToString: string;
    function GetLo: Byte;
    procedure SetLo(const AValue: Byte);
    function GetHi: Byte;
    procedure SetHi(const AValue: Byte);
    function BCDToInt: Integer;
    function ToBin(const AL, AH: string; const ASep: string = ''): string;
    function IsAsciiDigit: Boolean;
    function ToHex: string;

    property Bit[Index: Byte]: Boolean read GetBit write SetBit;
    property Hi: Byte read GetHi write SetHi;
    property Lo: Byte read GetLo write SetLo;

  end;

//------------------------------------------------------------------------------
//  TWordHelper = record helper for Word
//    function Hi: Byte;
//    function Lo: Byte;
//    function ToStr: string;
//    function ToBytes: TBytes;
//  end;

//------------------------------------------------------------------------------
  TBytesHelper = record helper for TBytes
    function GetWord(const APos: Integer): Word;
    procedure SetWord(const APos: Integer; const AValue: Word);
    function GetInt16(const APos: Integer): Int16;
    function GetUInt32(const APos: Integer): UInt32;
    function GetUInt64(const APos: Integer): UInt64;
    function GetBCD(const APos: Integer): Byte;
    function ToHex(const APrefix, ASuffix, ASeparator: string): string; overload;
    function ToHex: string; overload;
    function ToAnsiStr(const ATerminator: Byte = $00): string;
    function GetSize: UInt32;
    procedure SetSize(const ASize: UInt32);
    procedure Attach(const AValue: Word); overload;
    procedure Attach(const AValue: UInt32); overload;

    property Size: UInt32 read GetSize write SetSize;
  end;

//------------------------------------------------------------------------------
  TBoolArrayHelper = record helper for TBoolArray
    function ToStr(const ATrueStr, AFalseStr: string; const ASep: string = ''): string;
    function Clone: TBoolArray;
  end;

//------------------------------------------------------------------------------
  TStringHelper = record helper for string
    function DeleteLeading(const AChar: Char): string;
    function DeleteEnding(const AChar: Char): string;
    function DeleteChar(const AChar: Char): string;
    function ToBool(const ATrueStr, AFalseStr: string; const ADefault: Boolean = False): Boolean;
    function ToInteger: Integer;
    function IsOnlyDigits: Boolean;
    function ToBytes: TBytes;
    function HexToBytes: TBytes;
    function HexToInt: Integer;
    function Length: Integer;
  end;

//------------------------------------------------------------------------------
  TStringsHelper = class helper for TStrings
    function AllEqual(const APattern: string): Boolean;
    function GetFirstOther(const AText: string): string;
    procedure FromList(AList: IList<string>);
  end;

//------------------------------------------------------------------------------
  TUInt32Helper = record helper for UInt32
    function ToBytes: TBytes;
    function ToString: string;
  end;

//------------------------------------------------------------------------------
  TBoolHelper = record helper for Boolean
    function ToString(const ATrueStr, AFalseStr: string): string;
    function ToStr(const ATrueStr, AFalseStr: string): string;
  end;

//------------------------------------------------------------------------------
  TListBoxHelper = class helper for TListBox
    function FirstSelectedIndex: Integer;
    function LastSelectedIndex: Integer;
    function IsFirstSelected: Boolean;
    function IsLastSelected: Boolean;
  end;

//------------------------------------------------------------------------------
  TDateTimeHelper = record helper for TDateTime
    function ToStr: string;
  end;

//------------------------------------------------------------------------------
  TListColumnsHelper = class helper for TListColumns
    function GetColumn(const ACaption: string): TListColumn;
  end;

//------------------------------------------------------------------------------
  TListItemHelper = class helper for TListItem
    procedure SetValue(const AColName, AValue: string);
  end;

//------------------------------------------------------------------------------
  TListViewHelper = class helper for TListView
    function GetSelectedObjects: IList<TObject>;
    function GetSelectedIndexes: IList<Integer>;
    function IsFirstSelected: Boolean;
    function IsLastSelected: Boolean;
    function GetTopIndex: Integer;
    procedure SetTopIndex(const AIndex: Integer);
    procedure SelectObject(AObject: TObject);
    function ItemOfObject(AObject: TObject): TListItem;
    procedure SetSelectedObjects(AObjects: IList<TObject>);
    function GetSelectedObject: TObject;
    function AllChecked: Boolean;
    procedure CheckAll;
    procedure UncheckAll;

    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property SelectedObject: TObject read GetSelectedObject;

  end;

//------------------------------------------------------------------------------
  TComboBoxHelper = class helper for TComboBox
    function GetSelectedText: string;
    procedure SetSelectedText(const AText: string);
    function GetSelectedObject: TObject;
    procedure SetSelectedObject(const AValue: TObject);

    property SelectedText: string read GetSelectedText write SetSelectedText;
    property SelectedObject: TObject read GetSelectedObject write SetSelectedObject;

  end;

//------------------------------------------------------------------------------
  TTreeNodesHelper = class helper for TTreeNodes
    function GetExpandedObjects: IList<TObject>;
    procedure SetExpandedObjects(AObjects: IList<TObject>);
    function GetSelectedObjects: IList<TObject>;
    procedure SetSelectedObjects(AObjects: IList<TObject>);
    procedure ExpandSelected;
    procedure UnselectAll;
  end;

//------------------------------------------------------------------------------
  TTreeViewHelper = class helper for TTreeView
    function GetSelectedObject: TObject;
    function GetSelectedObjects: IList<TObject>;
    function NodeOfData(const AData: Pointer): TTreeNode;
  end;

//------------------------------------------------------------------------------
function ToTimeStr(const AHour, AMin: Byte): string;

//==============================================================================
implementation uses Character, System.Types;

//==============================================================================
{ TByteHelper }

function TByteHelper.BCDToInt: Integer;
begin
  Result := (10 * Hi) + Lo;
end;

//------------------------------------------------------------------------------
function TByteHelper.GetBit(Index: Byte): Boolean;
begin
  if Index > 7 then
    raise Exception.Create('GetBit for TByte - bit index: ' + IntToStr(Index) + ' > 7!');

  Result := ((Self shr Index) and $01) = $01;

end;

//------------------------------------------------------------------------------
function TByteHelper.GetHi: Byte;
begin
  Result := Self shr 4;
end;

//------------------------------------------------------------------------------
function TByteHelper.IsAsciiDigit: Boolean;
begin
  Result := (Self >= $30) and (Self <= $39);
end;

//------------------------------------------------------------------------------
function TByteHelper.GetLo: Byte;
begin
  Result := Self and $0F;
end;

//------------------------------------------------------------------------------
procedure TByteHelper.SetBit(Index: Byte; const AValue: Boolean);
var
  AMask: Byte;

begin
  if Index > 7 then
    raise Exception.Create('GetBit for TByte - bit index: ' + Index.ToString + ' > 7!');

  AMask := $01 shl Index;
  if AValue then
    Self := Self or AMask
  else
    Self := Self and (not AMask);

end;

//------------------------------------------------------------------------------
procedure TByteHelper.SetHi(const AValue: Byte);
begin
  Self := Self or ((AValue and $0F) shl 4);
end;

//------------------------------------------------------------------------------
procedure TByteHelper.SetLo(const AValue: Byte);
begin

  Self := Self or (AValue and $0F);
end;

//------------------------------------------------------------------------------
function TByteHelper.ToBin(const AL, AH, ASep: string): string;
var
  i: Integer;
begin
  Result := '';
  for i:=7 downto 0 do begin
    if Bit[i] then Result := Result + AH else Result := Result + AL;
    if i > 0 then Result := Result + ASep;
  end;
end;

//------------------------------------------------------------------------------
function TByteHelper.ToHex: string;
begin
  Result := IntToHex(Self, 2);
end;

//------------------------------------------------------------------------------
function TByteHelper.ToString: string;
begin
  Result := IntToStr(Self);
end;

//==============================================================================
{ TBytesHelper }

procedure TBytesHelper.Attach(const AValue: Word);
var
  ALByte, AHByte: Byte;
begin
  AHByte := AValue shr 8;
  ALByte := AValue and $00FF;
  Self := Self + [AHByte, ALByte];
end;

//------------------------------------------------------------------------------
procedure TBytesHelper.Attach(const AValue: UInt32);
var
  AByte: Byte;

begin
  AByte := (AValue and $FF000000) shr 24;
  Self := Self + [AByte];

  AByte := (AValue and $00FF0000) shr 16;
  Self := Self + [AByte];

  AByte := (AValue and $0000FF00) shr 8;
  Self := Self + [AByte];

  AByte := AValue and $000000FF;
  Self := Self + [AByte];

end;

//------------------------------------------------------------------------------
function TBytesHelper.GetBCD(const APos: Integer): Byte;
begin
  Result := (Self[APos] shr 4)*10 + (Self[APos] and $0F);
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetInt16(const APos: Integer): Int16;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetSize: UInt32;
begin
  Result := Length(Self);
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetUInt32(const APos: Integer): UInt32;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
  Result := (Result shl 8) or Self[APos+2];
  Result := (Result shl 8) or Self[APos+3];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetUInt64(const APos: Integer): UInt64;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
  Result := (Result shl 8) or Self[APos+2];
  Result := (Result shl 8) or Self[APos+3];
  Result := (Result shl 8) or Self[APos+4];
  Result := (Result shl 8) or Self[APos+5];
  Result := (Result shl 8) or Self[APos+6];
  Result := (Result shl 8) or Self[APos+7];
end;

//------------------------------------------------------------------------------
function TBytesHelper.GetWord(const APos: Integer): Word;
begin
  Result := (Self[APos] shl 8) or Self[APos+1];
end;

//------------------------------------------------------------------------------
procedure TBytesHelper.SetSize(const ASize: UInt32);
begin
  SetLength(Self, ASize);
end;

//------------------------------------------------------------------------------
procedure TBytesHelper.SetWord(const APos: Integer; const AValue: Word);
begin
  Self[APos] := AValue shr 8;
  Self[APos+1] := AValue and $00FF;
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToAnsiStr(const ATerminator: Byte = $00): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    if Self[i] = ATerminator then Break;
    Result := Result + Char(Self[i]);
  end;
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToHex: string;
begin
  Result := ToHex('', '', ' ');
end;

//------------------------------------------------------------------------------
function TBytesHelper.ToHex(const APrefix, ASuffix, ASeparator: string): string;
var
  i: Integer;
  AItemStr: string;

begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    AItemStr := APrefix + IntToHex(Self[i], 2) + ASuffix;
    Result := Result + AItemStr;
    if i < Length(Self)-1 then Result := Result + ASeparator;
  end;

end;

//==============================================================================
{ TStringHelper }

function TStringHelper.DeleteChar(const AChar: Char): string;
var
  i: Integer;
begin
  Result := '';
  for i:=1 to Length do
    if Self[i] = AChar then
      Continue
    else
      Result := Result + Self[i];
end;

//------------------------------------------------------------------------------
function TStringHelper.DeleteEnding(const AChar: Char): string;
begin
  Result := Self;
  while Length > 0 do
    if Self[Result.Length] = AChar then Delete(Result, Result.Length, 1) else Break;
end;

//------------------------------------------------------------------------------
function TStringHelper.DeleteLeading(const AChar: Char): string;
begin
  Result := Self;
  while Result.Length > 0 do
    if Result[1] = AChar then Delete(Result, 1, 1) else Break;
end;

//------------------------------------------------------------------------------
function TStringHelper.HexToBytes: TBytes;
var
  AByteStr: string;
  AByteCount, i, AValue: Integer;

begin
  Result := [];
  AByteCount := Length div 2;

  if AByteCount > 0 then
    for i:=0 to AByteCount-1 do begin
      AByteStr := Self[i*2+1] + Self[i*2+2];
      AValue := AByteStr.HexToInt;

      if (AValue > 255) or (AValue < 0) then
        raise Exception.Create('Value: ' + AByteStr + ' out of range.');

      Result := Result + [AValue];

    end;

end;

//------------------------------------------------------------------------------
function TStringHelper.HexToInt: Integer;
begin
  Result := StrToInt('$' + Self);
end;

//------------------------------------------------------------------------------
function TStringHelper.IsOnlyDigits: Boolean;
var
  i: Integer;
begin
  Result := true;
  for i:=1 to Length do
    if not Self[i].IsDigit then begin
      Result := false;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function TStringHelper.Length: Integer;
begin
  Result := System.Length(Self);
end;

//------------------------------------------------------------------------------
function TStringHelper.ToBool(const ATrueStr, AFalseStr: string;
  const ADefault: Boolean): Boolean;
begin
  if UpperCase(Self) = UpperCase(ATrueStr) then begin
    Result := true;
    Exit;
  end;

  if UpperCase(Self) = UpperCase(AFalseStr) then begin
    Result := false;
    Exit;
  end;

  Result := ADefault;

end;

//------------------------------------------------------------------------------
function TStringHelper.ToBytes: TBytes;
var
  i: Integer;
begin
  Result := [];
  for i:=1 to Length do Result := Result + [Byte(Self[i])];
end;

//------------------------------------------------------------------------------
function TStringHelper.ToInteger: Integer;
begin
  Result := StrToInt(Self);
end;

//==============================================================================
{ TUInt32Helper }

function TUInt32Helper.ToBytes: TBytes;
begin
  Result := [(Self and $FF000000) shr 24];
  Result := Result + [(Self and $00FF0000) shr 16];
  Result := Result + [(Self and $0000FF00) shr 8];
  Result := Result + [Self and $000000FF];

end;

//==============================================================================
function ToTimeStr(const AHour, AMin: Byte): string;
var
  AHrStr,AMinStr: string;
begin
  AHrStr := AHour.ToString;
  AMinStr := AMin.ToString;
  if Length(AMinStr) < 2 then AMinStr := '0' + AMinStr;
  Result := AHrStr + ':' + AMinStr;
end;

//------------------------------------------------------------------------------
function TUInt32Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

//==============================================================================
{ TBoolHelper }

function TBoolHelper.ToStr(const ATrueStr, AFalseStr: string): string;
begin
  Result := ToString(ATrueStr, AFalseStr);
end;

//------------------------------------------------------------------------------
function TBoolHelper.ToString(const ATrueStr, AFalseStr: string): string;
begin
  if Self then Result := ATrueStr else Result := AFalseStr;
end;

//==============================================================================
{ TListBoxHelper }

function TListBoxHelper.FirstSelectedIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to Self.Count-1 do
    if Self.Selected[i] then begin
      Result := i;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function TListBoxHelper.IsFirstSelected: Boolean;
begin
  Result := FirstSelectedIndex = 0;
end;

//------------------------------------------------------------------------------
function TListBoxHelper.IsLastSelected: Boolean;
begin
  Result := LastSelectedIndex = (Self.Count-1);
end;

//------------------------------------------------------------------------------
function TListBoxHelper.LastSelectedIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:=Self.Count-1 downto 0 do
    if Self.Selected[i] then begin
      Result := i;
      Break;
    end;
end;

//==============================================================================
{ TBoolArrayHelper }

function TBoolArrayHelper.Clone: TBoolArray;
var
  i: Integer;
begin
  Result := [];
  for i:=0 to Length(Self)-1 do
    Result := Result + [Self[i]];
end;

//------------------------------------------------------------------------------
function TBoolArrayHelper.ToStr(const ATrueStr, AFalseStr: string;
  const ASep: string = ''): string;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to Length(Self)-1 do begin
    Result := Result + Self[i].ToString(ATrueStr, AFalseStr);
    if i < (Length(Self)-1) then Result := Result + ASep;
  end;
end;

//==============================================================================
{ TDateTimeHelper }

function TDateTimeHelper.ToStr: string;
begin
  Result := DateTimeToStr(Self);
end;

//==============================================================================
{ TListColumnsHelper }

function TListColumnsHelper.GetColumn(const ACaption: string): TListColumn;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to Self.Count-1 do
    if Self[i].Caption = ACaption then begin
      Result := Self[i];
      Break;
    end;
end;

//==============================================================================
{ TListItemHelper }

procedure TListItemHelper.SetValue(const AColName, AValue: string);
var
  i, AColId: Integer;
  AListView: TListView;

begin
  if not Assigned(Self.Owner) then Exit;
  if not (Self.Owner.Owner is TListView) then Exit;
  AListView := Self.Owner.Owner as TListView;

  AColId := -1;
  for i:=0 to AListView.Columns.Count-1 do
    if AListView.Columns[i].Caption = AColName then begin
      AColId := i;
      Break;
    end;

  if AColId < 0 then Exit;

  for i:=SubItems.Count to AColId do
    SubItems.Add('');

  SubItems[AColId-1] := AValue;

end;

//==============================================================================
{ TListViewHelper }

function TListViewHelper.IsFirstSelected: Boolean;
begin
  Result := false;
  if Items.Count = 0 then Exit;
  Result := Items[0].Selected;
end;

//------------------------------------------------------------------------------
function TListViewHelper.AllChecked: Boolean;
var
  i: Integer;

begin
  if Items.Count > 0 then begin
    Result := true;
    for i:=0 to Items.Count-1 do
      if not Items[i].Checked then begin
        Result := false;
        Break;
      end;
  end else
    Result := false;

end;

//------------------------------------------------------------------------------
procedure TListViewHelper.CheckAll;
var
  i: Integer;
begin
  for i:=0 to Items.Count-1 do Items[i].Checked := true;
end;

//------------------------------------------------------------------------------
function TListViewHelper.GetSelectedIndexes: IList<Integer>;
var
  i: Integer;
  AItem: TListItem;

begin
  Result := TCollections.CreateList<Integer>;
  for i:=0 to Items.Count-1 do begin
    AItem := Items[i];
    if AItem.Selected then Result.Add(i);
  end;

end;

//------------------------------------------------------------------------------
function TListViewHelper.GetSelectedObject: TObject;
begin
  if Assigned(Selected) then Result := Selected.Data else Result := nil;
end;

//------------------------------------------------------------------------------
function TListViewHelper.GetSelectedObjects: IList<TObject>;
var
  i: Integer;
  AItem: TListItem;

begin
  Result := TCollections.CreateList<TObject>;
  for i:=0 to Items.Count-1 do begin
    AItem := Items[i];
    if AItem.Selected then begin
      if AItem.Data <> nil then Result.Add(AItem.Data);
    end;
  end;

end;

//------------------------------------------------------------------------------
function TListViewHelper.GetTopIndex: Integer;
var
  AItem: TListItem;
begin
  AItem := TopItem;
  if Assigned(AItem) then Result := AItem.Index else Result := -1;
end;

//------------------------------------------------------------------------------
function TListViewHelper.IsLastSelected: Boolean;
begin
  Result := false;
  if Items.Count = 0 then Exit;
  Result := Items[Items.Count-1].Selected;
end;

//------------------------------------------------------------------------------
function TListViewHelper.ItemOfObject(AObject: TObject): TListItem;
var
  AItem: TListItem;
  AItemObject: TObject;
  i: Integer;

begin
  Result := nil;
  for i:=0 to Items.Count-1 do begin
    AItem := Items[i];
    AItemObject := AItem.Data;
    if AItemObject = AObject then begin
      Result := AItem;
      Break;
    end;
  end;

end;

//------------------------------------------------------------------------------
procedure TListViewHelper.SelectObject(AObject: TObject);
var
  AItem: TListItem;
begin
  AItem := ItemOfObject(AObject);
  if Assigned(AItem) then
    ItemIndex := AItem.Index
  else
    ItemIndex := -1;
end;

//------------------------------------------------------------------------------
procedure TListViewHelper.SetSelectedObjects(AObjects: IList<TObject>);
var
  i: Integer;
  AItemObject: TObject;

begin
  Items.BeginUpdate;
  try

    for i:=0 to Items.Count-1 do begin
      AItemObject := Items[i].Data;
      Items[i].Selected := AObjects.IndexOf(AItemObject) >= 0;
    end;

  finally
    Items.EndUpdate;
  end;

end;

//------------------------------------------------------------------------------
procedure TListViewHelper.SetTopIndex(const AIndex: Integer);
var
  ABottomItem: TListItem;
  ABottomIndex: Integer;

begin
  if AIndex < 0 then Exit;
  if AIndex >= Items.Count then Exit;

  ABottomIndex := AIndex + VisibleRowCount;

  if ABottomIndex < Items.Count then
    ABottomItem := Items[ABottomIndex-1]
  else
    ABottomItem := Items[Items.Count-1];

  ABottomItem.MakeVisible(true);

end;

//------------------------------------------------------------------------------
procedure TListViewHelper.UncheckAll;
var
  i: Integer;
begin
  for i:=0 to Items.Count-1 do Items[i].Checked := false;
end;

//==============================================================================
{ TStringsHelper }

function TStringsHelper.AllEqual(const APattern: string): Boolean;
var
  i: Integer;

begin
  if Count < 1 then begin
    Result := false;
    Exit;
  end;

  Result := true;
  for i:=0 to Count-1 do
    if Self[i] <> APattern then begin
      Result := false;
      Break;
    end;

end;

//------------------------------------------------------------------------------
procedure TStringsHelper.FromList(AList: IList<string>);
var
  AElement: string;

begin
  try
    BeginUpdate;
    Clear;
    for AElement in AList do Add(AElement);
  finally
    EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
function TStringsHelper.GetFirstOther(const AText: string): string;
var
  i: Integer;

begin
  Result := '';

  for i:=0 to Count-1 do
    if Self[i] <> AText then begin
      Result := Self[i];
      Break;
    end;

end;

//==============================================================================
{ TComboBoxHelper }

function TComboBoxHelper.GetSelectedObject: TObject;
begin
  Result := nil;
  if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    Result := Items.Objects[ItemIndex];

end;

//------------------------------------------------------------------------------
function TComboBoxHelper.GetSelectedText: string;
begin
  if ItemIndex >= 0 then
    Result := Items[ItemIndex]
  else
    Result := '';
end;

//------------------------------------------------------------------------------
procedure TComboBoxHelper.SetSelectedObject(const AValue: TObject);
var
  i: Integer;

begin
  ItemIndex := -1;
  for i:=0 to Items.Count-1 do
    if Items.Objects[i] = AValue then begin
      ItemIndex := i;
      Break;
    end;
end;

//------------------------------------------------------------------------------
procedure TComboBoxHelper.SetSelectedText(const AText: string);
begin
  ItemIndex := Items.IndexOf(AText);
end;

//==============================================================================
{ TTreeNodesHelper }

procedure TTreeNodesHelper.ExpandSelected;
var
  ANode: TTreeNode;

begin
  for ANode in Self do
    if ANode.Selected then ANode.Expanded := true;

end;

//------------------------------------------------------------------------------
function TTreeNodesHelper.GetExpandedObjects: IList<TObject>;
var
  ANode: TTreeNode;
  AObject: TObject;

begin
  Result := TCollections.CreateList<TObject>;

  for ANode in Self do begin
    if ANode.Data = nil then Continue;
    if ANode.Expanded then begin
      AObject := ANode.Data;
      Result.Add(AObject);
    end;
  end;

end;

//------------------------------------------------------------------------------
procedure TTreeNodesHelper.SetExpandedObjects(AObjects: IList<TObject>);
var
  ANode: TTreeNode;
  AObject: TObject;

begin
  for ANode in Self do begin
    if ANode.Data = nil then Continue;
    AObject := ANode.Data;
    ANode.Expanded := AObjects.IndexOf(AObject) >= 0;
  end;

end;

//------------------------------------------------------------------------------
procedure TTreeNodesHelper.SetSelectedObjects(AObjects: IList<TObject>);
var
  ANode: TTreeNode;
  AObject: TObject;

begin
  for ANode in Self do begin
    if ANode.Data = nil then Continue;
    AObject := ANode.Data;
    try
      ANode.Selected := AObjects.IndexOf(AObject) >= 0;
    except
    end;
  end;

end;

//------------------------------------------------------------------------------
procedure TTreeNodesHelper.UnselectAll;
var
  ANode: TTreeNode;
begin
  for ANode in Self do ANode.Selected := false;
end;

//------------------------------------------------------------------------------
function TTreeNodesHelper.GetSelectedObjects: IList<TObject>;
var
  ANode: TTreeNode;
  AObject: TObject;

begin
  Result := TCollections.CreateList<TObject>;
  for ANode in Self do
    if ANode.Selected then
      if Assigned(ANode.Data) then begin
        AObject := ANode.Data;
        Result.Add(AObject);
      end;

end;

//==============================================================================
{ TTreeViewHelper }

function TTreeViewHelper.GetSelectedObject: TObject;
begin
  if Assigned(Selected) then Result := Selected.Data else Result := nil;
end;

//------------------------------------------------------------------------------
function TTreeViewHelper.GetSelectedObjects: IList<TObject>;
var
  AItem: TTreeNode;

begin
  Result := TCollections.CreateList<TObject>;
  for AItem in Items do if AItem.Selected then Result.Add(AItem.Data);

end;

//------------------------------------------------------------------------------
function TTreeViewHelper.NodeOfData(const AData: Pointer): TTreeNode;
var
  ANode: TTreeNode;

begin
  Result := nil;
  for ANode in Items do begin
    if AData = ANode.Data then begin
      Result := ANode;
      Break;
    end;
  end;

end;

//==============================================================================
{ TWordHelper }

//function TWordHelper.Hi: Byte;
//begin
//  Result := System.Hi(Self);
//end;
//
////------------------------------------------------------------------------------
//function TWordHelper.Lo: Byte;
//begin
//  Result := System.Lo(Self);
//end;
//
////------------------------------------------------------------------------------
//function TWordHelper.ToBytes: TBytes;
//begin
//  Result := [Self.Hi, Self.Lo];
//end;
//
////------------------------------------------------------------------------------
//function TWordHelper.ToStr: string;
//begin
//  Result := IntToStr(Self);
//end;

end.
