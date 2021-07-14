unit MPF.XML;
interface uses Xml.XmlIntf;
//==============================================================================
function TryGetAttribute(ANode: IXmlNode; const AAttr: string; ADefault: Variant): Variant;

//==============================================================================
implementation

function TryGetAttribute(ANode: IXmlNode; const AAttr: string; ADefault: Variant): Variant;
begin
  if ANode.HasAttribute(AAttr) then
    Result := ANode.GetAttributeNS(AAttr,'')
  else
    Result := ADefault;
end;

end.
