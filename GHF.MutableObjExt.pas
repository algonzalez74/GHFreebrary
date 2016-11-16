{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.MutableObjExt.pas - TghMutableObjExt class unit.                    }
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

Unit GHF.MutableObjExt;  { Mutable Object Extension }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.ObjExt;

  Type
    { Mutable Object Extension class }
    TghMutableObjExt <T :Class> = Class Abstract (TghObjExt <T>)
      Protected
        { Fields }
        LockWriteCount :Cardinal;

        { Regular instance methods }
        Procedure CheckWriteUnlocked;
        Function GetWriteLocked :Boolean;

        { Virtual instance methods }
        Procedure OwnerChanged (AEventID :Integer); Virtual;
        Procedure OwnerChanging (AEventID :Integer); Virtual;

        { IghObserver }
        Procedure HandleEvent (AObj :TObject; AEventID :Integer); Override;
      Public
        { Regular instance methods }
        Procedure LockWrite;
        Procedure UnlockWrite;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;
        Procedure UpdateOwner; Virtual; Abstract;

        { Properties }
        Property WriteLocked :Boolean Read GetWriteLocked;
    End;

Implementation

  Uses
    GHF.SysEx, System.SysUtils, GHF.Sys, GHF.Obs;

  { TghMutableObjExt }

  { Protected regular instance methods }

  Procedure TghMutableObjExt <T>.CheckWriteUnlocked;
  Begin
    If WriteLocked Then
      EInvalidOpException.ghRaise (
        TghSys.ermLockedForWriting, [T.ClassName + ' object']);
  End;

  Function TghMutableObjExt <T>.GetWriteLocked :Boolean;
  Begin
    Result := LockWriteCount > 0;
  End;

  { Protected virtual instance methods }

  Procedure TghMutableObjExt <T>.OwnerChanged (AEventID :Integer);
  Begin
    CheckWriteUnlocked;
  End;

  Procedure TghMutableObjExt <T>.OwnerChanging (AEventID :Integer);
  Begin
    CheckWriteUnlocked;
  End;

  { Public regular instance methods }

  Procedure TghMutableObjExt <T>.LockWrite;
  Begin
    System.Inc (LockWriteCount);
  End;

  Procedure TghMutableObjExt <T>.UnlockWrite;
  Begin
    TghSys.CheckInc (LockWriteCount, -1);
  End;

  { Public overridden instance methods }

  Procedure TghMutableObjExt <T>.BeforeDestruction;
  Begin
    CheckWriteUnlocked;
    Inherited BeforeDestruction;
  End;

  { IghObserver }

  Procedure TghMutableObjExt <T>.HandleEvent (AObj :TObject;
    AEventID :Integer);
  Begin
    { Compiler bug "E2015 Operator not applicable to this operand type"
      (XE7) }
    //If AObj = Owner Then

    If AObj = Owner.ghAsPtr Then
      If TghSys.HasBitOn (AEventID, TghObs.oeiObjChanging) Then
        OwnerChanging (AEventID)
      Else
        If TghSys.HasBitOn (AEventID, TghObs.oeiObjChanged) Then
          OwnerChanged (AEventID);
  End;

End.

