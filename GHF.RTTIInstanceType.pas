{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.RTTIInstanceType.pas - TghRTTIInstanceType class unit.              }
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

Unit GHF.RTTIInstanceType;  { RTTI Instance Type }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.ClassList, GHF.KeyRetrieve, System.RTTI;

  Type
    { RTTI Instance Type class. NOTE: This class should not declare new
      instance fields, because its purpose is to replace the class of live
      TRTTIInstanceType objects.  }
    TghRTTIInstanceType = Class (TRTTIInstanceType)
      Protected
        Type
          TExData = Class (TghKeyRetrieve)
            Protected
              { Instance fields }
              FChildren :TghClassList <TClass>;
              FDescendants :TghClassList <TClass>;
          End;

        { Regular instance methods }
        Function GetChildren :TghClassList <TClass>;
        Function GetDescendants :TghClassList <TClass>;
      Public
        { Regular instance methods }
        Function CheckSimpleConstructor (
          Const ASafe :Boolean = System.True) :TRTTIMethod;

        { Virtual instance methods }
        Function CreateObj (AConstructor :TRTTIMethod) :TObject; Overload;
          Virtual;
        Function CreateObj :TObject; Overload; Virtual;
        Function SimpleConstructor (ASafe :Boolean = System.True)
          :TRTTIMethod; Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property Children :TghClassList <TClass> Read GetChildren;
        Property Descendants :TghClassList <TClass> Read GetDescendants;
    End;

Implementation

  Uses
    GHF.RTTI, GHF.Obs, System.TypInfo, GHF.Sys, System.SysUtils, GHF.SysEx;

  { TghRTTIInstanceType }

  { Protected regular instance methods }

  Function TghRTTIInstanceType.GetChildren :TghClassList <TClass>;
  Var
    ExData :TExData;
  Begin
    ExData := TExData.Get (Self);

    If ExData.FChildren = Nil Then
    Begin
      ExData.ghHoldSet (ExData.FChildren, TghClassList <TClass>.Create);
      TghRTTI.InitChildren (Self);
    End;

    Result := ExData.FChildren;
  End;

  Function TghRTTIInstanceType.GetDescendants :TghClassList <TClass>;
  Var
    ExData :TExData;

    Procedure AddChildren (AClass :TClass);
    Begin
      For AClass In AClass.ghClassInfo.ghInstanceType.Children Do
      Begin
        ExData.FDescendants.Add (AClass);
        AddChildren (AClass);
      End;
    End;
  Begin
    ExData := TExData.Get (Self);

    If ExData.FDescendants = Nil Then
    Begin
      ExData.ghHoldSet (ExData.FDescendants, TghClassList <TClass>.Create);
      AddChildren (MetaclassType);
    End;

    Result := ExData.FDescendants;
  End;

  { Public regular instance methods }

  Function TghRTTIInstanceType.CheckSimpleConstructor (
    Const ASafe :Boolean = System.True) :TRTTIMethod;
  Begin
    If SimpleConstructor (ASafe).ghSetBlankTo (Result) Then
      EInvalidOpException.ghRaise (TghRTTI.ermNoSingleConstructor, [Name]);
  End;

  { Public virtual instance methods }

  Function TghRTTIInstanceType.CreateObj (AConstructor :TRTTIMethod)
    :TObject;
  Begin
    Result := AConstructor.Invoke (MetaclassType, []).AsObject;
  End;

  Function TghRTTIInstanceType.CreateObj :TObject;
  Begin
    Result := CheckSimpleConstructor.Invoke (MetaclassType, []).AsObject;
  End;

  Function TghRTTIInstanceType.SimpleConstructor (
    ASafe :Boolean = System.True) :TRTTIMethod;
  Var
    LParamConstructor :TRTTIMethod;
  Begin
    LParamConstructor := Nil;

    For Result In GetMethods Do
      If Result.ghIsPublicConstructor And Not Result.ghIsAbstract Then
        If Result.ghParamCount = 0 Then
          If ASafe And (LParamConstructor <> Nil) And
          (Result.Parent <> LParamConstructor.Parent) Then
            System.Break  // Exit in "Result := Nil;"
          Else
            System.Exit  // A simple one found (at least TObject.Create)
        Else
          Result.ghReplaceNil (LParamConstructor);

    Result := Nil;
  End;

  { Public overridden instance methods }

  Procedure TghRTTIInstanceType.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

End.

