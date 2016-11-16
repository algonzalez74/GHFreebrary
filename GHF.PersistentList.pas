{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.PersistentList.pas - TghPersistentList class unit.                  }
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

Unit GHF.PersistentList;  { Persistent List }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Classes, GHF.List;

  Type
    {}//derivar de TghObjList <T :Class> cuando �ste exista
    { Persistent List class }
    TghPersistentList <T :TPersistent> = Class (TghList <T>)
      Public
        { Regular instance methods }
        Procedure DefineProp (Const Filer :TFiler; Const Name :String);
        Procedure Read (Reader :TReader);
        Procedure Write (Writer :TWriter);

        { Overridden instance methods }
        Procedure AfterConstruction; Override;
    End;

Implementation

  Uses
    GHF.RTTI, GHF.Sys, GHF.SysEx;

  { TghPersistentList <T> }

  { Public regular instance methods }

  Procedure TghPersistentList <T>.DefineProp (Const Filer :TFiler;
    Const Name :String);
  Begin
    Filer.DefineProperty (Name, Read, Write, Count > 0);
  End;

  {}//trabajando en mejora
{  Procedure TghPersistentList <T>.Read (Reader :TReader);
  Begin
    Reader.ReadList (
      Procedure
      Begin
        If Reader.ReadEmptyList Then
          Add (Nil)
        Else
        Begin
          Add (Pointer (
            TghRTTI.FindClassType (Reader.ReadStrProp).CreateInstance));

          While Not Reader.ReadListEnd Do
            Reader.ReadProperty (Last);
        End;
      End, System.Classes.vaCollection);
  End;}

  Procedure TghPersistentList <T>.Read (Reader :TReader);
  Begin
    Reader.CheckValue (System.Classes.vaCollection);

    While Not Reader.EndOfList Do
    Begin
      Reader.ReadListBegin;

      If Reader.EndOfList Then
        Add (Nil)
      Else
      Begin
        Reader.ReadStr;  // 'Class'
        AddTyped (
          TghRTTI.Context.ghFindInstanceType (Reader.ReadString).Handle);

        While Not Reader.EndOfList Do
          Reader.ghReadProp (Last);
      End;

      Reader.ReadListEnd;
    End;

    Reader.ReadListEnd;
  End;

  Procedure TghPersistentList <T>.Write (Writer :TWriter);
  Var
    Obj :TPersistent;
    SavedPropPath :String;
  Begin
    Writer.ghWriteValue (System.Classes.vaCollection);
    SavedPropPath := Writer.ghPropPath;
    Writer.ghPropPath := '';

    Try
      For Obj In Self Do
        Writer.ghWritePropList (Obj,
          Procedure
          Begin
            Writer.ghWriteProp ('Class', Obj.QualifiedClassName);

            If (Obj Is TComponent) And (TComponent (Obj).Name <> '') Then
              Writer.ghWriteProp ('Name', TComponent (Obj).Name);
          End);
    Finally
      Writer.ghPropPath := SavedPropPath;
    End;

    Writer.WriteListEnd;
  End;

  { Public overridden instance methods }

  Procedure TghPersistentList <T>.AfterConstruction;
  Begin
    Inherited AfterConstruction;
    OwnsItems := System.True;
  End;

End.


