unit MPF.XML;
interface uses Xml.XmlIntf;
//==============================================================================
function TryGetAttribute(ANode: IXmlNode; const AAttr: string; ADefault: Variant): Variant;

//==============================================================================
implementation

function TryGetAttribute(ANode: IXmlNode; const AAttr: string; ADefault: Variant): Variant;
begin
  try
    Result := ANode.GetAttributeNS(AAttr,'');
  except
    Result := ADefault;
  end;
end;

end.
