{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Design.PersistentListProp.pas - TghPersistentListProp class unit.   }
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

Unit GHF.Design.PersistentListProp;  { Persistent List Property }

{$ScopedEnums On}

Interface

  Uses
    GHF.Design, System.Classes, DesignEditors, DesignIntf;

  Type
    ///pendiente probar herencia visual (GetIsDefault) y paRevertable
    { Persistent List Property class }
    TghPersistentListProp <TItem :TPersistent> = Class (TClassProperty)
      Protected
        { Overridden instance methods }
        Function GetIsDefault :Boolean; Override;
      Public
        { Overridden instance methods }
        Function GetAttributes :TPropertyAttributes; Override;
        Procedure GetProperties (Proc :TGetPropProc); Override;
    End;

Implementation

  Uses
    GHF.Design.PersistentListCountProp, GHF.Design.PersistentListItemProp;

  { TghPersistentListProp <TItem> }

  { Protected overridden instance methods }

  Function TghPersistentListProp <TItem>.GetIsDefault :Boolean;
  Begin
    Result := System.False;
  End;

  { Public overridden instance methods }

  Function TghPersistentListProp <TItem>.GetAttributes :TPropertyAttributes;
  Begin
    Result := Inherited GetAttributes + [DesignIntf.paVolatileSubProperties];
  End;

  Procedure TghPersistentListProp <TItem>.GetProperties (Proc :TGetPropProc);
  Var
    I :Integer;
  Begin
    Inherited GetProperties (Proc);
    Proc (TghPersistentListCountProp <TItem>.Create (Self));

    If PropCount = 1 Then{}//revisar con paMultiSelect
      For I := 0 To ghList <TItem>.Count - 1 Do
        Proc (TghPersistentListItemProp <TItem>.Create (Self, I));
  End;

End.

