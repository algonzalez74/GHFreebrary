{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Design.PersistentListCountProp.pas - TghPersistentListCountProp     }
{                                          class unit.                    }
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

{ Persistent List Count Property }
Unit GHF.Design.PersistentListCountProp;

{$ScopedEnums On}

Interface

  Uses
    GHF.Design, System.Classes, DesignEditors, DesignIntf, System.TypInfo;

  Type
    { Persistent List Count Property class }
    {$TypeInfo On}
    TghPersistentListCountProp <TItem :TPersistent> = Class (
      TNestedProperty)
      Protected
        { Regular instance methods }
        Procedure SetCount (Const AValue :Integer);
      Public
        { Overridden instance methods }
        Function AllEqual :Boolean; Override;
        Function GetAttributes :TPropertyAttributes; Override;
        Function GetName :String; Override;
        Function GetPropInfo :PPropInfo; Override;
        Function GetValue :String; Override;
        Procedure SetValue (Const Value :String); Override;
      Published
        { Instance properties }
        Property Count :Integer Write SetCount;
    End;
    {$TypeInfo Off}

Implementation

  Uses
    System.SysUtils, System.SysConst;

  { TghPersistentListCountProp <TItem> }

  { Protected regular instance methods }

  Procedure TghPersistentListCountProp <TItem>.SetCount (Const AValue :Integer);
  Var
    I :Integer;
  Begin
    For I := 0 To PropCount - 1 Do
      ghList <TItem> (I, Inherited GetPropInfo).Count := AValue;

    Modified;
  End;

  { Public overridden instance methods }

  Function TghPersistentListCountProp <TItem>.AllEqual :Boolean;
  Var
    AValue, I :Integer;
  Begin
    If PropCount > 1 Then
    Begin
      AValue := ghList <TItem> (0, Inherited GetPropInfo).Count;

      For I := 1 To PropCount - 1 Do
        If ghList <TItem> (I, Inherited GetPropInfo).Count <> AVAlue Then
          System.Exit (System.False);
    End;

    Result := System.True;
  End;

  Function TghPersistentListCountProp <TItem>.GetAttributes :TPropertyAttributes;
  Begin
    Result := [DesignIntf.paMultiSelect, DesignIntf.paRevertable{}{probar}];
  End;

  Function TghPersistentListCountProp <TItem>.GetName :String;
  Begin
    Result := 'Count';
  End;

  Function TghPersistentListCountProp <TItem>.GetPropInfo :PPropInfo;
  Begin
    { NOTE: To allow the modification of Count in the object inspector, we
      need information of a writable and published property }
    Result := System.TypInfo.GetPropInfo (Self, 'Count');
  End;

  Function TghPersistentListCountProp <TItem>.GetValue :String;
  Begin
    Result := ghList <TItem> (0, Inherited GetPropInfo).Count.ToString;
  End;

  Procedure TghPersistentListCountProp <TItem>.SetValue (Const Value :String);
  Var
    AValue :Integer;
  Begin
    If TryStrToInt (Value, AValue) then
      Count := AValue
    Else
      Raise EDesignPropertyError.CreateResFmt (@SInvalidInteger, [Value]);
  End;

End.

