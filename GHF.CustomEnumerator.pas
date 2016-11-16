{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.CustomEnumerator.pas - TghCustomEnumerator class unit.              }
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

Unit GHF.CustomEnumerator;  { Custom Enumerator }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Generics.Defaults, GHF.Sys;

  Type
    { Custom Enumerator class }
    TghCustomEnumerator = Class (TSingletonImplementation, IEnumerator,
      IghEnumerator, IEnumerable, IghEnumerable)
      Protected
        { Instance fields }
        FIndex :Integer;
        Subject :TObject;

        { Regular instance methods }
        Procedure CheckIdle;

        { Virtual instance methods }
        Function GetCount :Integer; Virtual; Abstract;

        { IInterface }
        Function _Release :Integer; StdCall;

        { IEnumerator }
        Function GetCurrent :TObject; Virtual; Abstract;
      Public
        Constructor Create (ASubject :TObject); Virtual;

        { Virtual instance methods }
        Function Arr :TArray <TObject>; Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property Count :Integer Read GetCount;
        Property Index :Integer Read FIndex;

        { IEnumerator }
        Function MoveNext: Boolean; Virtual;
        Procedure Reset; Virtual;
        Property Current :TObject Read GetCurrent;

        { IEnumerable }
        Function GetEnumerator :IEnumerator;
    End;

    { Custom Enumerator class (generic version) }
    TghCustomEnumerator <T> = Class (TghCustomEnumerator, IEnumerator <T>,
      IEnumerable <T>)
      Protected
        { IEnumerator }
        Function GetCurrent :TObject; Override;

        { IEnumerator <T>. NOTE: We avoid the E2211 compiler error
          ("declaration of 'GetCurrent' differs from declaration in
          interface 'System.IEnumerator<T>'") by using this method
          resolution —the alternative method name 'GetCurrentT' is
          necessary—.  Furthermore, in order to avoid the F2084 internal
          error (compiler bug), GetCurrentT must not be overridden.  This
          method is only a wrapper of the InternalGetCurrentT virtual
          method, which should be overridden in descendant classes. }
        Function GetCurrentT :T; {}//Inline;
        Function IEnumerator <T>.GetCurrent = GetCurrentT;
        Function InternalGetCurrentT :T; Virtual; Abstract;
      Public
        { Virtual instance methods }
        Function Arr :TArray <T>; Reintroduce; Virtual;

        { IEnumerator <T> }
        Property Current :T Read GetCurrentT;

        { IEnumerable <T> }
        Function IEnumerable <T>.GetEnumerator = GetEnumeratorT;
        Function GetEnumeratorT :IEnumerator <T>;
    End;

Implementation

  Uses
    GHF.Obs, GHF.RTTI, System.SysUtils, GHF.SysEx;

  { TghCustomEnumerator }

  { Constructors and destructors }

  Constructor TghCustomEnumerator.Create (ASubject :TObject);
  Begin
    Inherited Create;
    Subject := ASubject;
    FIndex := -1;
  End;

  { Protected regular instance methods }

  Procedure TghCustomEnumerator.CheckIdle;
  Begin
    If Index > -1 Then
      EInvalidOpException.ghRaise (TghSys.ermInUse, ['The enumerator']);
  End;

  { Public virtual instance methods }

  {}//comprobar uso de interfaz y valor de Index
  Function TghCustomEnumerator.Arr :TArray <TObject>;
  Var
    LObj :TObject;
  Begin
    SetLength (Result, Count);

    For LObj In Self Do
      Result [Index] := LObj;
  End;

  { Public overridden instance methods }

  Procedure TghCustomEnumerator.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

  { IInterface }

  Function TghCustomEnumerator._Release :Integer;
  Begin
    Result := Inherited _Release;
    Reset;
  End;

  { IEnumerator }

  Function TghCustomEnumerator.MoveNext :Boolean;
  Begin
    Result := FIndex < Count - 1;

    If Result Then
      Inc (FIndex);
  End;

  Procedure TghCustomEnumerator.Reset;
  Begin
    FIndex := -1;
  End;

  { IEnumerable }

  Function TghCustomEnumerator.GetEnumerator :IEnumerator;
  Begin
    CheckIdle;
    Result := Self;
  End;

  { TghCustomEnumerator <T> }

  { Public virtual instance methods }

  {}//comprobar uso de interfaz y valor de Index
  Function TghCustomEnumerator <T>.Arr :TArray <T>;
  Var
    Value :T;
  Begin
    SetLength (Result, Count);

    For Value In IEnumerable <T> (Self) Do
      Result [Index] := Value;
  End;

  { IEnumerator }

  Function TghCustomEnumerator <T>.GetCurrent :TObject;
  Begin
    Result := TghSys.Obj <T> (Current);
  End;

  { IEnumerator <T> }

  Function TghCustomEnumerator <T>.GetCurrentT :T;
  Begin
    Result := InternalGetCurrentT;
  End;

  { IEnumerable <T> }

  Function TghCustomEnumerator <T>.GetEnumeratorT :IEnumerator <T>;
  Begin
    CheckIdle;
    Result := Self
  End;

End.


