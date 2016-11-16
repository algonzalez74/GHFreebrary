{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.KeyRetrieve.pas - TghKeyRetrieve class unit.                        }
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

Unit GHF.KeyRetrieve;  { Key Retrieve }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.CustomRetrieve, GHF.Dic;

  Type
    {}//revisar si Param podría ser genérico
    { Key Retrieve class }
    TghKeyRetrieve = Class (TghCustomRetrieve)
      Private
        Class Destructor Destroy;
      Protected
        Class Var
          Finalized :Boolean;
          Dic :TghDic <Pointer, TghKeyRetrieve>;

        Var
          Key :Pointer;

        Constructor Create (Owner :TObject; Param :Pointer); Override;

        { Overridden class methods }
        Class Function FindInstance (Param :Pointer) :TghCustomRetrieve;
          Override;
      Public
        Destructor Destroy; Override;
    End;

Implementation

  Uses
    System.SysUtils, System.Generics.Collections, GHF.Sys, GHF.SysEx;

  { TghKeyRetrieve }

  Class Destructor TghKeyRetrieve.Destroy;
  Begin
    Finalized := System.True;
    System.SysUtils.FreeAndNil (Dic);
  End;

  Constructor TghKeyRetrieve.Create (Owner :TObject; Param :Pointer);
  Begin
    Inherited Create (Owner, Param);
    Key := Param;
    Dic.Add (Key, Self);
  End;

  Destructor TghKeyRetrieve.Destroy;
  Begin
    Inherited Destroy;

    If Not Finalized Then
      Dic.ExtractPair (Key);
  End;

  { Protected overridden instance methods }

  Class Function TghKeyRetrieve.FindInstance (Param :Pointer)
    :TghCustomRetrieve;
  Begin
    If Dic = Nil Then
    Begin
      ghCheckClassFinalized (Finalized);
      Dic := TghDic <Pointer, TghKeyRetrieve>.Create (
        [System.Generics.Collections.doOwnsValues]);
      Result := Nil;
    End
    Else
      Dic.TryGetValue (Param, TghKeyRetrieve (Result));
  End;

End.

