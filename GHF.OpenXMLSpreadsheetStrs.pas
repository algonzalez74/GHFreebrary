{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.OpenXMLSpreadsheetStrs.pas - TghOpenXMLSpreadsheetStrs class unit.  }
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

Unit GHF.OpenXMLSpreadsheetStrs;

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and XML unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any Windows project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.OpenXMLPart;

  Type
    { OpenXML Spreadsheet Strings class }
    TghOpenXMLSpreadsheetStrs = Class (TghOpenXMLPart)
      Protected
        { Regular instance methods }
        Function Element (Const Index :Integer) :OLEVariant;
        Function GetValue (Const Index :Integer) :String;
        Procedure SetValue (Const Index :Integer; Const Value :String);
      Public
        Constructor CreateFromDir (Const APath :String); Virtual;

        { Static class methods }
        Class Function CalcPath (Const DirPath :String) :String; Static;

        { Instance properties }
        Property Values [Const Index :Integer] :String Read GetValue
          Write SetValue; Default;
    End;

Implementation

  Uses
    GHF.Sys, GHF.Win;

  { TghOpenXMLSpreadsheetStrs }

  Constructor TghOpenXMLSpreadsheetStrs.CreateFromDir (
    Const APath :String);
  Begin
    Create (CalcPath (APath));
  End;
  
  { Protected regular instance methods }

  Function TghOpenXMLSpreadsheetStrs.Element (Const Index :Integer)
    :OLEVariant;
  Begin
    Result := FindNode ('/_:sst/_:si[%d]', [Index + 1]);
  End;

  Function TghOpenXMLSpreadsheetStrs.GetValue (Const Index :Integer)
    :String;
  Begin
    Result := Element (Index).Text;
  End;

  Procedure TghOpenXMLSpreadsheetStrs.SetValue (Const Index :Integer;
    Const Value :String);
  Begin
    WorkNode := Element (Index);
    Nodes ('*').RemoveAll;
    CreateElement ('t', Value)
  End;

  { Public static class methods }

  Class Function TghOpenXMLSpreadsheetStrs.CalcPath (Const DirPath :String)
    :String;
  Begin
    If DirPath <> '' Then
      Result := TghSys.ConcatFilePaths (DirPath, TghWin.oxmSharedStrs)
    Else
      Result := '';
  End;

End.
