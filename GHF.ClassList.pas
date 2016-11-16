{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.ClassList.pas - TghClassList class unit.                            }
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

Unit GHF.ClassList;  { Class List }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Generics.Collections, GHF.List, GHF.Sys;

  Type
    {}//problema ya no presente en XE7, refactorizar
    { NOTE: We avoid using generic object parameters with default value in
      methods of generic classes, because these cause Internal Error
      URW1154 when those classes are referenced from another unit (quality
      report #129713). }

    {}//prefijo A en parámetros
    { Class List class }
    TghClassList <T> = Class (TghList <T>)
      Private
        Class Constructor Create;
      Public
        { Regular instance methods }
        Function AddChild (Const Parent, Value :T;
          Const AllowIndirect :Boolean = System.False) :Integer; Overload;
        Function AddChild (Const Parent, Value :T;
          Const NotChildList :TghClassList <T>;
          Const AllowIndirect :Boolean = System.False) :Integer; Overload;
        Function ExtractChildren (Const Parent :T;
          Const TakingProc :TghSys.TProcessValueProcRef <T, T>;
          Const AllowIndirect :Boolean = System.False) :Integer; Overload;
        Function ExtractChildren (Const Parent :T;
          Const TakingList :TghClassList <T>;
          Const AllowIndirect :Boolean = System.False) :Integer; Overload;
    End;

Implementation

  Uses
    GHF.RTTI, System.TypInfo, GHF.SysEx;

  { TghClassList <T> }

  Class Constructor TghClassList <T>.Create;
  Begin
    TghRTTI.Info <T>.ghCheckKind (System.tkClassRef);
  End;

  { Public regular instance methods }

  Function TghClassList <T>.AddChild (Const Parent, Value :T;
    Const AllowIndirect :Boolean = System.False) :Integer;
  Begin
    Result := AddIf (Value, TghSys.PClass (@Parent).ghIsDerived (
      TghSys.PClass (@Value)^, AllowIndirect));
  End;

  Function TghClassList <T>.AddChild (Const Parent, Value :T;
    Const NotChildList :TghClassList <T>;
    Const AllowIndirect :Boolean = System.False) :Integer;
  Begin
    Result := AddIf (Value, TghSys.PClass (@Parent).ghIsDerived (
      TghSys.PClass (@Value)^, AllowIndirect), NotChildList);
  End;

  Function TghClassList <T>.ExtractChildren (Const Parent :T;
    Const TakingProc :TghSys.TProcessValueProcRef <T, T>;
    Const AllowIndirect :Boolean = System.False) :Integer;
  Begin
    Result := Extract <T> (Parent,

      Function (Const AClass :T; Const Parent :T;
        Var AContinue :Boolean) :Boolean
      Begin
        Result := TghSys.PClass (@Parent).ghIsDerived (
          TghSys.PClass (@AClass)^, AllowIndirect);
      End,

      TakingProc);
  End;

  Function TghClassList <T>.ExtractChildren (Const Parent :T;
    Const TakingList :TghClassList <T>;
    Const AllowIndirect :Boolean = System.False) :Integer;
  Begin
   Result := ExtractChildren (Parent,

      Procedure (Const AClass :T; Const Parent :T)
      Begin
        TakingList.Add (AClass);
      End,

      AllowIndirect);
  End;

End.

