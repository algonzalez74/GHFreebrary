{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Persistent.pas - TghPersistent class unit.                          }
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

Unit GHF.Persistent;  { Persistent }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Classes, System.SysUtils;

  Type
    { Persistent class }
    TghPersistent = Class Abstract (TPersistent)
      Protected
        { Virtual instance methods }
        Function GetAsVar :Variant; Virtual;
        Function GetSerialized :TBytes; Virtual;
        Procedure SetSerialized (Const AValue :TBytes); Virtual;

        { Overridden instance methods }
        Function GetOwner :TPersistent; Override;
      Public
        Constructor Create (Const AHolder :TObject = Nil); Overload;
          Virtual;

        { Virtual instance methods }
        Procedure Changed; Virtual;
        Procedure Changing; Virtual;
        Procedure Deserialize (Const AStream :TStream); Virtual;
        Procedure Serialize (Const AStream :TStream); Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property AsVar :Variant Read GetAsVar;
        Property Serialized :TBytes Read GetSerialized Write SetSerialized;
    End;

Implementation

  Uses
    GHF.Obs, GHF.RTTI, GHF.Sys, GHF.Observer, GHF.SysEx, System.Variants;

  { TghPersistent }

  Constructor TghPersistent.Create (Const AHolder :TObject = Nil);
  Begin
    Inherited Create;

    If AHolder <> Nil Then
      AHolder.ghHold (Self);
  End;

  Procedure TghPersistent.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

  Procedure TghPersistent.Changed;
  Begin
    ghNotifyChanged;
  End;

  Procedure TghPersistent.Changing;
  Begin
    ghNotifyChanging;
  End;

  Procedure TghPersistent.Deserialize (Const AStream :TStream);
  Begin
    {}//mecanismo DFM
  End;

  Function TghPersistent.GetAsVar :Variant;
  Begin
    Result := System.Variants.Null;
  End;

  {}//probar
  Function TghPersistent.GetOwner :TPersistent;
  Begin
    Result := ghHolder.ghAsOrNil <TPersistent>;
  End;

  Function TghPersistent.GetSerialized :TBytes;
  Var
    LStream :TBytesStream;
  Begin
    LStream := TBytesStream.Create;

    Try
      Serialize (LStream);
      Result := LStream.Bytes;
    Finally
      LStream.Free;
    End;
  End;

  Procedure TghPersistent.Serialize (Const AStream :TStream);
  Begin
    {}//mecanismo DFM
  End;

  Procedure TghPersistent.SetSerialized (Const AValue :TBytes);
  Var
    LStream :TBytesStream;
  Begin
    LStream := TBytesStream.Create (AValue);

    Try
      Deserialize (LStream);
    Finally
      LStream.Free;
    End;
  End;

End.

