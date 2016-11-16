{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.VCL.pas - TghVCL class unit.                                        }
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

Unit GHF.VCL;  { VCL }

{ NOTE: In order to avoid circular unit references, the public parts of
  this unit should not depend on other Windows or VCL GH Freebrary units.
  Moreover, the only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and VCL unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any VCL project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys, VCL.Forms, VCL.Controls, WinAPI.Windows, GHF.SysEx;

  Type
    { VCL class }
    TghVCL = Class (TghZeroton)
      Private
        Class Constructor Create;
        Class Destructor Destroy;
      Public
        Type
          { Pointer types for data types declared in native units }
          PCustomForm = ^TCustomForm;

          { TWinControl helper }
          TWinControlHelper = Class Helper (TghSys.TComponentHelper) For
          TWinControl
            Public
              { Regular instance methods }
              Function ghFirstFocusableControl (
                Const ATabStop :Boolean = System.True) :TWinControl;
              Function ghMsgPending (Const AMinID, AMaxID :Integer)
                :Boolean; Overload;
              Function ghMsgPending (Const AID :Integer = 0) :Boolean;
                Overload;
              Function ghPeekMsg (Out AMsg :TMsg;
                Const AMinID, AMaxID :Integer;
                Const ARemove :Boolean = System.False) :Boolean; Overload;
              Function ghPeekMsg (Out AMsg :TMsg; Const AID :Integer = 0;
                Const ARemove :Boolean = System.False) :Boolean; Overload;
              Function ghReleasePending :Boolean;
          End;

          { TForm helper }
          TFormHelper = Class Helper (TWinControlHelper) For TForm
            Public
              { Regular class methods }
              Class Function ghDefaultInstance :TForm;

              { Regular instance methods }
              Function ghFocusFirstControl (
                Const ATabStop :Boolean = System.True) :Boolean;
              Function ghHasFocus :Boolean; Overload;
              Function ghHasFocus (Const AControl :TWinControl) :Boolean;
                Overload;
              Procedure ghRefocusControl;
              Function ghRefocusFirstControl (
                Const ATabStop :Boolean = System.True) :Boolean;
          End;

          { Record type for TghWin.msgCloseModal Windows message }
          TMsgCloseModal = Packed Record
            ID :Cardinal;
            ModalResult :TModalResult;
            Unused :LongInt;
            Result :LongInt;
          End;

          { Virtual class. Overridable functionality, accessible via the
            Virtual class property. }
          TVirtual = Class
            Public
              Type
                { Class reference type }
                TClassRef = Class Of TVirtual;
          End;
      Protected
        Class Var
          FVirtual :TVirtual.TClassRef;

        { Static class methods }
        Class Procedure SetVirtual (Const AValue :TVirtual.TClassRef);
          Static;
      Public
        { Class properties }
        Class Property Virtual :TVirtual.TClassRef Read FVirtual
          Write SetVirtual;
    End;

Implementation

  Uses
    GHF.Win;

  { TghVCL }

  { TghVCL.TFormHelper }

  Class Function TghVCL.TFormHelper.ghDefaultInstance :TForm;
  Begin
    Result := VCL.Forms.Application.ghFirstComponent (Self).ghAsPtr;
  End;

  Function TghVCL.TFormHelper.ghFocusFirstControl (
    Const ATabStop :Boolean = System.True) :Boolean;
  Begin
    ActiveControl := ghFirstFocusableControl (ATabStop);
    Result := ActiveControl <> Nil;
  End;

  Function TghVCL.TFormHelper.ghHasFocus :Boolean;
  Begin
    Result := VCL.Forms.Screen.ActiveForm = Self;
  End;

  Function TghVCL.TFormHelper.ghHasFocus (Const AControl :TWinControl)
    :Boolean;
  Begin
    Result := ghHasFocus And AControl.ContainsControl (ActiveControl);
  End;

  Procedure TghVCL.TFormHelper.ghRefocusControl;
  Var
    LControl :TWinControl;
  Begin
    If ActiveControl = Nil Then
      System.Exit;

    LControl := ActiveControl;
    ActiveControl := Nil;

    If LControl.CanFocus Then
      ActiveControl := LControl;
  End;

  Function TghVCL.TFormHelper.ghRefocusFirstControl (
    Const ATabStop :Boolean = System.True) :Boolean;
  Begin
    ActiveControl := Nil;
    Result := ghFocusFirstControl (ATabStop);
  End;

  { TghVCL.TWinControlHelper }

  Function TghVCL.TWinControlHelper.ghFirstFocusableControl (
    Const ATabStop :Boolean = System.True) :TWinControl;
  Begin
    Result := FindNextControl (Nil, System.True, ATabStop, System.False);
  End;

  Function TghVCL.TWinControlHelper.ghMsgPending (
    Const AMinID, AMaxID :Integer) :Boolean;
  Begin
    Result := TghWin.MsgPending (Handle, AMinID, AMaxID);
  End;

  Function TghVCL.TWinControlHelper.ghMsgPending (Const AID :Integer = 0)
    :Boolean;
  Begin
    Result := TghWin.MsgPending (Handle, AID);
  End;

  Function TghVCL.TWinControlHelper.ghPeekMsg (Out AMsg :TMsg;
    Const AMinID, AMaxID :Integer; Const ARemove :Boolean = System.False)
    :Boolean;
  Begin
    Result := TghWin.PeekMsg (AMsg, Handle, AMinID, AMaxID, ARemove);
  End;

  Function TghVCL.TWinControlHelper.ghPeekMsg (Out AMsg :TMsg;
    Const AID :Integer = 0; Const ARemove :Boolean = System.False)
    :Boolean;
  Begin
    Result := TghWin.PeekMsg (AMsg, Handle, AID, ARemove);
  End;

  Function TghVCL.TWinControlHelper.ghReleasePending :Boolean;
  Begin
    Result := ghMsgPending (VCL.Controls.cm_Release);
  End;

  { Constructors and destructors }

  Class Constructor TghVCL.Create;
  Begin
    TVirtual.ghInitVirtualClass (FVirtual);
  End;

  Class Destructor TghVCL.Destroy;
  Begin
    TVirtual.ghFinalizeVirtualClass;
  End;

  { Protected static class methods }

  Class Procedure TghVCL.SetVirtual (Const AValue :TVirtual.TClassRef);
  Begin
    TVirtual.ghSetVirtualClass (AValue);
  End;

End.

