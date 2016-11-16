{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Design.pas - TghDesign class unit.                                  }
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

Unit GHF.Design;  { Design }

{$ScopedEnums On}

{$R GHF.Design.res}  // Component bitmaps and other resources

Interface

  Uses
    GHF.Sys, DesignEditors, GHF.List, System.Classes, System.TypInfo,
    GHF.SysEx;

  Type
    { Design class }
    TghDesign = Class (TghZeroton)
      Public
        Type
          { TPropertyEditor helper }
          TPropertyEditorHelper = Class Helper (TghSys.TObjectHelper) For
          TPropertyEditor
            Public
              { Regular instance methods }
              Function ghList <TItem :TPersistent> (Const Index :Integer = 0;
                Info :PPropInfo = Nil) :TghList <TItem>; Inline;
              Function ghObj <T :Class> (Const Index :Integer = 0;
                Info :PPropInfo = Nil) :T;
          End;
    End;

Implementation

  { Inline routines }

  Function TghDesign.TPropertyEditorHelper.ghList <TItem> (
    Const Index :Integer = 0; Info :PPropInfo = Nil) :TghList <TItem>;
  Begin
    Result := ghObj <TghList <TItem>> (Index, Info);
  End;

  { TghDesign }

  { TghDesign.TPropertyEditorHelper }

  Function TghDesign.TPropertyEditorHelper.ghObj <T> (
    Const Index :Integer = 0; Info :PPropInfo = Nil) :T;
  Begin
    If Info = Nil Then
      Info := GetPropInfo;

    Result := GetObjectProp (GetComponent (Index), Info) As T;
  End;

End.

