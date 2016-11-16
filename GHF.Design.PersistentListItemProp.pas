{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Design.PersistentListItemProp.pas - TghPersistentListItemProp class }
{                                         unit.                           }
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

Unit GHF.Design.PersistentListItemProp;  { Persistent List Item Property }

{$ScopedEnums On}

Interface

  Uses
    GHF.Design, System.Classes, DesignEditors, DesignIntf;

  Type
    ///pendiente probar herencia visual (GetIsDefault) y paRevertable
    { Persistent List Item Property class }
    TghPersistentListItemProp <T :TPersistent> = Class (TNestedProperty)
      Private
        Class Constructor Create;
      Protected
        { Instance fields }
        Index :Integer;

        { Overridden instance methods }
        Function GetIsDefault :Boolean; Override;
      Public
        Constructor Create (Parent :TPropertyEditor; AIndex :Integer);
          Reintroduce;

        { Overridden instance methods }
        Function AutoFill :Boolean; Override;
        Function GetAttributes :TPropertyAttributes; Override;
        Function GetName :String; Override;
        Procedure GetProperties (Proc :TGetPropProc); Override;
        Function GetValue :String; Override;
        Procedure GetValues (Proc :TGetStrProc); Override;
        Procedure SetValue (Const Value :String); Override;
    End;

Implementation

  Uses
    GHF.RTTI, System.SysUtils, System.TypInfo, DesignConst, GHF.Sys, GHF.SysEx;

  { TghPersistentListItemProp <T> }

  { Constructors and destructors }

  {}//considerando para velocidad
  Class Constructor TghPersistentListItemProp <T>.Create;
  Begin
    //TghRTTI.ClassTypes [T].Descendants;
  End;

  Constructor TghPersistentListItemProp <T>.Create (Parent :TPropertyEditor;
    AIndex :Integer);
  Begin
    Inherited Create (Parent);
    Index := AIndex;
  End;

  { Protected overridden instance methods }

  Function TghPersistentListItemProp <T>.GetIsDefault :Boolean;
  Begin
    Result := System.False;
  End;

  { Public overridden instance methods }

  Function TghPersistentListItemProp <T>.AutoFill :Boolean;
  Begin
    ///revisar por qué esto no tiene efecto
    Result := System.True;
  End;

  Function TghPersistentListItemProp <T>.GetAttributes :TPropertyAttributes;
  Begin
    Result := [DesignIntf.paValueList, DesignIntf.paSortList];

    If ghList <T> [Index] <> Nil Then
      Result := Result +
        [DesignIntf.paSubProperties, DesignIntf.paVolatileSubProperties];
  End;

  Function TghPersistentListItemProp <T>.GetName :String;
  Begin
    Result := 'Items [' + Index.ToString + ']';
  End;

  Procedure TghPersistentListItemProp <T>.GetProperties (
    Proc :TGetPropProc);
  Var
    Sel :IDesignerSelections;
  Begin
    Sel := TDesignerSelections.Create;
    Sel.Add (ghList <T> [Index]);
    GetComponentProperties (
      Sel, System.TypInfo.tkProperties, Designer, Proc);
  End;

  Function TghPersistentListItemProp <T>.GetValue :String;
  Begin
    If ghList <T> [Index] <> Nil Then
      Result := ghList <T> [Index].QualifiedClassName
    Else
      Result := DesignConst.srNone;
  End;

  {}//excluir clases abstractas
  Procedure TghPersistentListItemProp <T>.GetValues (Proc :TGetStrProc);
  Var
    AClass :TClass;
  Begin
    Proc (DesignConst.srNone);
    Proc (T.QualifiedClassName);

    For AClass In TghRTTI.Info <T>.ghInstanceType.Descendants Do
      Proc (AClass.QualifiedClassName);
  End;

  ///pendiente considerar Assign/copia de propiedades
  Procedure TghPersistentListItemProp <T>.SetValue (Const Value :String);
  Var
    Item :T;
  Begin
    If TghSys.Keep (Item, Value <> DesignConst.srNone) Then
      If ghList <T>.OwnsItems Then
        Try
          ghList <T>.CreateItem (
            Item, TghRTTI.Context.ghFindInstanceType (Value).Handle);
        Except
          On E :Exception Do
            EDesignPropertyError.ghRaise (TghSys.ermCreationFailed,
              ['List item'], E);
        End
      Else
        EDesignPropertyError.ghRaise (TghSys.ermPropFalse,
          ['The persistent object list', 'OwnsItems']);

    ghList <T>.ReplaceItem (Index, Item).Free;
  End;

End.

