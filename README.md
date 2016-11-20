# GH Freebrary
GH Freebrary is a general purpose class library for modern versions of Delphi. This is a beta release, all units compile in Delphi XE7.

Compare the following two code blocks (the first one borrowed from stackoverflow.com).

(1) A method to get a hypothetical <i>DisplayLabel</i> RTTI attribute of a given class, NOT using GH Freebrary:
<pre><code>implementation

uses
  Rtti;

class function TArtifactInspector.DisplayLabelFor(AClass: TClass): string;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Attribute: TCustomAttribute;
begin
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(AClass);
    for Attribute in RttiType.GetAttributes do
      if Attribute is DisplayLabelAttribute then
        Exit(DisplayLabelAttribute(Attribute).Text);
    Result := '';
  finally
    RttiContext.Free;
  end;
end;</code></pre>

(2) Same method using GH Freebrary:
<pre><code>implementation

uses
  GHF.SysEx, GHF.RTTI;

class function TArtifactInspector.DisplayLabelFor(AClass: TClass): string;
var
  Attribute: DisplayLabelAttribute;
begin
  if AClass.ghClassInfo.ghGetAttr&lt;DisplayLabelAttribute&gt;(Attribute) then
    Result := Attribute.Text
  else
    Result := '';
end;</code></pre>

When I was 16 years old, Professor De Lira revealed to me that in Turbo Pascal there was a file type called <i>unit</i>. Since then I write .pas code that aims to make life easier. And I still feel the same emotion when I see the results!

Use GHF if you agree that most of the code written for a complex software solution should be located below the layer that such a solution represents, not inside it.

Any suggestions or contributions will be greatly appreciated.

Al Gonzalez.
