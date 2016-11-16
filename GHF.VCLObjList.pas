{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.VCLObjList.pas - TghVCLObjList class unit.                          }
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

Unit GHF.VCLObjList;  { VCL Object List }

{}//sustituir su uso por clase nueva descendiente de genérica

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and VCL unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any VCL project. }

Interface

  Uses
    GHF.ObjList, VCL.Controls;

  Type
    { VCL Object List class }
    TghVCLObjList = Class (TghObjList)
      Public
        { Regular instance methods }
        Function AddControls (Const Parent :TWinControl;
          Const AClass :TControlClass = Nil;
          Const Recurse :Boolean = False) :Integer; Overload;
        Function AddControls (Const Parent :TWinControl;
          Const Recurse :Boolean) :Integer; Overload;
    End;

Implementation

  {Uses
    System.Classes, System.Contnrs;}{}

  { TghVCLObjList }

  { Public regular instance methods }

  Function TghVCLObjList.AddControls (Const Parent :TWinControl;
    Const AClass :TControlClass = Nil; Const Recurse :Boolean = False)
    :Integer;
  Var
    I :Integer;
  Begin
    Result := 0;

    For I := 0 To Parent.ControlCount - 1 Do
    Begin
      If (AClass = Nil) Or (Parent.Controls [I] Is AClass) Then
      Begin
        Add (Parent.Controls [I]);
        Inc (Result);
      End;

      If Recurse And (Parent.Controls [I] Is TWinControl) Then
        Inc (Result, AddControls (TWinControl (Parent.Controls [I]),
          AClass, True));
    End;
  End;

  Function TghVCLObjList.AddControls (Const Parent :TWinControl;
    Const Recurse :Boolean) :Integer;
  Begin
    Result := AddControls (Parent, TControlClass (Nil), Recurse);
  End;

End.

