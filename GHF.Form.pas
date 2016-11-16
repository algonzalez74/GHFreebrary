{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Form.pas - TghForm class unit.                                      }
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

Unit GHF.Form;  { Form }

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and VCL unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any VCL project. }

{$ScopedEnums On}

Interface

  Uses
    VCL.Forms, VCL.Controls, System.Classes, GHF.VCL, GHF.Win;

  Type
    {}//considerar en derivada capacidades para TDataSource quitadas
    { Form class }
    TghForm = Class (TForm)
      Protected
        { Instance fields }
        AutoModalResult :TModalResult;
        FActiveReader :TReader;
        FInOnCreate :Boolean;
        FOpenParams :PVariant;

        { Regular class methods }
        Class Function InternalExecute (Const AParams :PVariant;
          Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
          :TModalResult;
        Class Function InternalOpen (Const AParams :PVariant) :TghForm;
        Class Function PrepareOpen (Const AParams :PVariant = Nil) :TghForm;

        { Regular instance methods }
        Function GetOpenParam (Const AIndex :Integer) :Variant;
        Function GetOpenParamCount :Integer;

        { Virtual instance methods }
        Function DoExecute :TModalResult; Virtual;
        Procedure DoOpen; Virtual;
        Procedure GetControlStates (AControl :TControl;
          Var AVisible, AEnabled :Boolean); Virtual;
        Procedure UpdateControl (AControl :TControl); Virtual;

        { Overridden instance methods }
        Procedure DoClose (Var Action :TCloseAction); Override;
        Procedure DoCreate; Override;
        Procedure ReadState (Reader :TReader); Override;

        { Message methods }
        Procedure MsgCloseModal (Var AMsg :TghVCL.TMsgCloseModal);
          Message TghWin.msgCloseModal;
      Public
        Constructor Create; Reintroduce; Overload; Virtual;

        { Regular class methods }
        Class Function Execute (Const AParams :Variant;
          Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
          :TModalResult; Overload;
        Class Function Execute (Const AParams :Array Of Const;
          Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
          :TModalResult; Overload;
        Class Function Execute (Const AParam :Pointer;
          Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
          :TModalResult; Overload;
        Class Function Execute :TModalResult; Overload;
        Class Function Open (Const AParams :Variant) :TghForm; Overload;
        Class Function Open (Const AParams :Array Of Const) :TghForm;
          Overload;
        Class Function Open (Const AParam :Pointer) :TghForm; Overload;
        Class Function Open :TghForm; Overload;

        { Regular instance methods }
        Procedure UpdateControls (Const AParent :TWinControl;
          Const AIncludeParent :Boolean = System.False); Overload;
        Procedure UpdateControls (
          Const AIncludeForm :Boolean = System.False); Overload;
        Procedure UpdateControls (Const AParents :Array Of TWinControl;
          Const AIncludeParents :Boolean = System.False); Overload;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property InOnCreate :Boolean Read FInOnCreate;
        Property OpenParams [Const AIndex :Integer] :Variant
          Read GetOpenParam;
        Property OpenParamCount :Integer Read GetOpenParamCount;
        Property ActiveReader :TReader Read FActiveReader;
    End;

    { TghForm Class type }
    TghFormClass = Class Of TghForm;

Implementation

  Uses
    System.Variants, WinAPI.Windows, VCL.StdCtrls, GHF.VCLObjList,
    GHF.ObjList, GHF.Obs, System.Contnrs, GHF.Sys;

  { TghForm }

  Constructor TghForm.Create;
  Begin
    Create (Application);
  End;

  { Protected regular class methods }

  Class Function TghForm.InternalExecute (Const AParams :PVariant;
    Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
    :TModalResult;
  Begin
    With PrepareOpen (AParams) Do{}//dejar de usar With
      Try
        If AAutoModalResult <> VCL.Controls.mrNone Then
        Begin
          AutoModalResult := AAutoModalResult;
          PostMessage (Handle, TghWin.msgCloseModal, AutoModalResult, 0);
        End;

        Result := DoExecute;
      Finally
        FOpenParams := Nil;
        AutoModalResult := VCL.Controls.mrNone;
      End;
  End;

  Class Function TghForm.InternalOpen (Const AParams :PVariant) :TghForm;
  Begin
    Result := PrepareOpen (AParams);

    Try
      Result.DoOpen;
    Finally
      Result.FOpenParams := Nil;
    End;
  End;

  Class Function TghForm.PrepareOpen (Const AParams :PVariant = Nil)
    :TghForm;
  Begin
    Result := ghDefaultInstance.ghAsPtr;

    If (Result = Nil) Or (VCL.Forms.fsModal In Result.FormState) Or
    Result.ghReleasePending Then
    Begin
      Result := TghForm (NewInstance);
      Result.FOpenParams := AParams;
      Result.Create;
    End
    Else
      Result.FOpenParams := AParams;
  End;

  { Protected regular instance methods }

  Function TghForm.GetOpenParam (Const AIndex :Integer) :Variant;
  Begin
    If TghSys.CheckIndex (AIndex) >= OpenParamCount Then
      Result := Unassigned  // Default value of "optional" parameter
    Else
      Result := FOpenParams^.ghElement (AIndex);
  End;

  Function TghForm.GetOpenParamCount :Integer;
  Begin
    If FOpenParams = Nil Then
      Result := 0
    Else
      Result := FOpenParams^.ghLength;
  End;

  { Protected virtual instance methods }

  Function TghForm.DoExecute :TModalResult;
  Begin
    Hide;
    Result := ShowModal;
  End;

  Procedure TghForm.DoOpen;
  Begin
    Show;
  End;

  Procedure TghForm.GetControlStates (AControl :TControl;
    Var AVisible, AEnabled :Boolean);
  Begin
  End;

  Procedure TghForm.UpdateControl (AControl :TControl);
  Var
    AEnabled, AVisible :Boolean;
    Method :TMethod;
  Begin
    TghSys.TValueVarVarMethod <TControl, Boolean, Boolean> (Method) :=
      GetControlStates;

    // We check if the GetControlStates method was overridden
    If Method.Code = @TghForm.GetControlStates Then
      System.Exit;

    AVisible := AControl.Visible;
    AEnabled := AControl.Enabled;
    GetControlStates (AControl, AVisible, AEnabled);
    AControl.Visible := AVisible;
    AControl.Enabled := AEnabled;
  End;
  
  { Protected overridden instance methods }

  Procedure TghForm.DoClose (Var Action :TCloseAction);
  Begin
    If Action = VCL.Forms.caHide Then
      Action := VCL.Forms.caFree;

    Inherited DoClose (Action);
  End;

  Procedure TghForm.DoCreate;
  Begin
    FInOnCreate := System.True;

    Try
      Inherited DoCreate;
    Finally
      FInOnCreate := System.False;
    End;
  End;

  Procedure TghForm.ReadState (Reader :TReader);
  Begin
    FActiveReader := Reader;

    Try
      Inherited ReadState (Reader);
    Finally
      FActiveReader := Nil;
    End;
  End;
  
  { Protected message methods }

  {}//probar
  Procedure TghForm.MsgCloseModal (Var AMsg :TghVCL.TMsgCloseModal);
  Var
    LModalResult :TModalResult;
  Begin
    LModalResult := AMsg.ModalResult;

    If ghEnumComponents <TButton> (
    Procedure (Const AButton :TButton; Var Continue :Boolean)
    Begin
      If AButton.Enabled And (AButton.ModalResult = LModalResult) Then
      Begin
        AButton.Click;
        Continue := System.False;
      End;
    End, System.True) = Nil Then
      ModalResult := LModalResult;
  End;

  { Public regular class methods }

  Class Function TghForm.Execute (Const AParams :Variant;
    Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
    :TModalResult;
  Begin
    Result := InternalExecute (@AParams, AAutoModalResult);
  End;

  Class Function TghForm.Execute (Const AParams :Array Of Const;
    Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
    :TModalResult;
  Begin
    Result := Execute (TghSys.TVarRecsVar (AParams), AAutoModalResult);
  End;

  Class Function TghForm.Execute (Const AParam :Pointer;
    Const AAutoModalResult :TModalResult = VCL.Controls.mrNone)
    :TModalResult;
  Begin
    Result := Execute (TghSys.PtrVar (AParam), AAutoModalResult);
  End;

  Class Function TghForm.Execute :TModalResult;
  Begin
    Result := InternalExecute (Nil);
  End;

  Class Function TghForm.Open (Const AParams :Variant) :TghForm;
  Begin
    Result := InternalOpen (@AParams);
  End;

  Class Function TghForm.Open (Const AParams :Array Of Const) :TghForm;
  Begin
    Result := Open (TghSys.TVarRecsVar (AParams));
  End;

  Class Function TghForm.Open (Const AParam :Pointer) :TghForm;
  Begin
    Result := Open (AParam.ghAsVar);
  End;

  Class Function TghForm.Open :TghForm;
  Begin
    Result := InternalOpen (Nil);
  End;

  { Public regular instance methods }

  Procedure TghForm.UpdateControls (Const AParent :TWinControl;
    Const AIncludeParent :Boolean = System.False);
  Var
    LList :TghVCLObjList;
  Begin
    LList := TghVCLObjList.Create (System.False);

    Try
      If AIncludeParent Then
        LList.Add (Parent);

      LList.AddControls (Parent, System.True);
      LList.Enum (
        Procedure (Const AControl :TObject; Var AContinue :Boolean)
        Begin
          UpdateControl (TControl (AControl));
        End);
    Finally
      LList.Free;
    End;
  End;

  Procedure TghForm.UpdateControls (
    Const AIncludeForm :Boolean = System.False);
  Begin
    UpdateControls (Self, AIncludeForm);
  End;

  Procedure TghForm.UpdateControls (Const AParents :Array Of TWinControl;
    Const AIncludeParents :Boolean = System.False);
  Var
    I :Integer;
  Begin
    For I := 0 To System.High (AParents) Do
      UpdateControls (AParents [I], AIncludeParents);
  End;

  { Public overridden instance methods }

  Procedure TghForm.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

End.

