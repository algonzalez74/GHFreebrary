{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.OpenXMLRels.pas - TghOpenXMLRels class unit.                        }
{                                                                         }
{ This software is distributed under the open source BSD license.         }
{                                                                         }
{ Copyright (c) 2002-2016, Al Gonzalez (@algonzalez74)                    }
{ All rights reserved.                                                    }
{                                                                         }
{ Redistribution and use in source and binary forms, with or without      }
{ modification, are permitted provided that the following conditions are  }
{ met:                                                                    }
{                                                                         }
{   - Redistributions of source code must retain the above copyright      }
{     notice, this list of conditions and the following disclaimer.       }
{   - Redistributions in binary form must reproduce the above copyright   }
{     notice, this list of conditions and the following disclaimer in the }
{     documentation and/or other materials provided with the              }
{     distribution.                                                       }
{   - Neither the name of Al Gonzalez nor the names of his contributors   }
{     may be used to endorse or promote products derived from this        }
{     software without specific prior written permission.                 }
{                                                                         }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS }
{ IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   }
{ TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A         }
{ PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT      }
{ HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,  }
{ SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        }
{ LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   }
{ DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   }
{ THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     }
{ (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   }
{ OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    }
{*************************************************************************}

Unit GHF.OpenXMLRels;  { OpenXML Relationships }

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and XML unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any Windows project. }

{$ScopedEnums On}

{}//revisar y/o corregir uso de abreviación Rels

Interface

  Uses
    GHF.XMLDoc;

  Type
    { OpenXML Relationships class }
    TghOpenXMLRels = Class (TghXMLDoc)
      Public
        Constructor CreateForPart (Const APath :String); Virtual;

        { Static class methods }
        Class Function CalcPath (Const PartPath :String) :String; Static;

        { Regular instance methods }
        Function ElementTargetPath (Const Element :OLEVariant) :String;
        Function Target (Const ID :String) :String;
        Function TargetPath (Const ID :String) :String;
    End;

Implementation

  Uses
    System.SysUtils, GHF.Win, GHF.Sys;

  { TghOpenXMLRels }

  Constructor TghOpenXMLRels.CreateForPart (Const APath :String);
  Begin
    Create (CalcPath (APath));
  End;

  { Public static class methods }

  Class Function TghOpenXMLRels.CalcPath (Const PartPath :String) :String;
  Begin
    If PartPath <> '' Then
      { Relationship file of PartPath file, example: ...\xl\workbook.xml ->
        ...\xl\_rels\workbook.xml.rels }
      Result := TghSys.DerivedFilePath (
        PartPath, '_rels\' + ExtractFileName (PartPath) + '.rels')
    Else
      Result := '';
  End;

  { Public regular instance methods }

  Function TghOpenXMLRels.ElementTargetPath (Const Element :OLEVariant)
    :String;
  Begin
    Result := TargetPath (Element.GetAttribute ('r:id'));
  End;

  Function TghOpenXMLRels.Target (Const ID :String) :String;
  Begin
    Result := FindNode ('/_:Relationships/_:Relationship[@Id="%s"]',
      [ID]).GetAttribute ('Target');
  End;

  {}//probar
  Function TghOpenXMLRels.TargetPath (Const ID :String) :String;
  Begin
    If Path <> '' Then
      // Example: worksheets/sheet14.xml -> ...\xl\worksheets\sheet14.xml
      Result := TghSys.DerivedFilePath (Path, 2,
        TghSys.ReplaceChr (Target (ID), '/', System.SysUtils.PathDelim))
    Else
      Result := '';
  End;

End.

