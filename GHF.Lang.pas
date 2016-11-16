{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Lang.pas - TghLang class unit.                                      }
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

Unit GHF.Lang;  { Language }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys;

  Type
    { Language class }
    TghLang = Class (TghZeroton)
      Public
        Const
          // Common delta between upper- and lowercase letters
          DefaultChrCaseDelta = 32;

        Type
          { Character case type. Undefined/default, lower case,
            upper case. }
          TChrCase = (eUndefined, eDefault = eUndefined, eLower, eUpper);

          { Class reference type }
          TClassRef = Class Of TghLang;

        { Regular class methods }
        Class Function LowerChrOf (Const AValue :String;
          Const AIndex :Integer = 1) :Char;
        Class Function LowerChrStr (Const AValue :String;
          Const AIndex :Integer = 1) :String;
        Class Function LowerSimpleStr (Const AValue :String) :String;
        Class Function PutLowerChr (Var AStr :String;
          Const AIndex :Integer = 1) :Boolean;
        Class Function PutLowerChrSafe (Var AStr :String;
          Const AIndex :Integer = 1) :Boolean;
        Class Function PutUpperChr (Var AStr :String;
          Const AIndex :Integer = 1) :Boolean;
        Class Function PutUpperChrSafe (Var AStr :String;
          Const AIndex :Integer = 1) :Boolean;
        Class Function SimpleChr (Const AValue :Char) :Char;
        Class Function SimpleChrStr (Const AValue :String;
          Const AIndex :Integer) :String;
        Class Function SimpleStr (Const AValue :String) :String;
        Class Function SimplifyChr (Var AStr :String;
          Const AIndex :Integer) :Boolean;
        Class Function SimplifyChrSafe (Var AStr :String;
          Const AIndex :Integer) :Boolean;
        Class Procedure SimplifyStrs (Var AStr1, AStr2 :String);
        Class Function UpperChrOf (Const AValue :String;
          Const AIndex :Integer = 1) :Char;
        Class Function UpperChrStr (Const AValue :String;
          Const AIndex :Integer = 1) :String;
        Class Function UpperSimpleChr (Const AValue :Char) :Char;
        Class Function UpperSimpleStr (Const AValue :String) :String;
        Class Procedure UpperSimplifyStrs (Var AStr1, AStr2 :String);

        { Virtual class methods }
        Class Function ChrComposition (AValue :Char;
          ATyping :Boolean = System.False) :String; Virtual; Abstract;
        Class Function LowerChr (AValue :Char) :Char; Virtual;
        Class Function LowerStr (Const AValue :String) :String; Virtual;
        Class Function UpperChr (AValue :Char) :Char; Virtual;
        Class Function UpperStr (Const AValue :String) :String; Virtual;
    End;

Implementation

  Uses
    System.SysUtils, System.Character, GHF.SysEx;

  { Inline routines }{}

  { TghLang }

  { Public regular class methods }

  Class Function TghLang.LowerChrOf (Const AValue :String;
    Const AIndex :Integer = 1) :Char;
  Begin
    Result := LowerChr (TghSys.ChrOf (AValue, AIndex));
  End;

  {}//versión no Safe y otra Safe
  Class Function TghLang.LowerChrStr (Const AValue :String;
    Const AIndex :Integer = 1) :String;
  Begin
    Result := AValue;
    PutLowerChrSafe (Result, AIndex);
  End;

  Class Function TghLang.LowerSimpleStr (Const AValue :String) :String;
  Begin
    Result := LowerStr (SimpleStr (AValue));
  End;

  Class Function TghLang.PutLowerChr (Var AStr :String;
    Const AIndex :Integer = 1) :Boolean;
  Begin
    Result := TghSys.PutChr (AStr, AIndex, LowerChr (AStr [AIndex]));
  End;

  Class Function TghLang.PutLowerChrSafe (Var AStr :String;
    Const AIndex :Integer = 1) :Boolean;
  Begin
    Result := TghSys.IsIndex (AIndex, AStr) And PutLowerChr (AStr, AIndex);
  End;

  Class Function TghLang.PutUpperChr (Var AStr :String;
    Const AIndex :Integer = 1) :Boolean;
  Begin
    Result := TghSys.PutChr (AStr, AIndex, UpperChr (AStr [AIndex]));
  End;

  Class Function TghLang.PutUpperChrSafe (Var AStr :String;
    Const AIndex :Integer = 1) :Boolean;
  Begin
    Result := TghSys.IsIndex (AIndex, AStr) And PutUpperChr (AStr, AIndex);
  End;

  Class Function TghLang.SimpleChr (Const AValue :Char) :Char;
  Begin
    Result := ChrComposition (AValue) [1];
  End;

  {}//versión no Safe y otra Safe
  Class Function TghLang.SimpleChrStr (Const AValue :String;
    Const AIndex :Integer) :String;
  Begin
    Result := AValue;
    SimplifyChrSafe (Result, AIndex);
  End;

  Class Function TghLang.SimpleStr (Const AValue :String) :String;
  Var
    I :Integer;
  Begin
    Result := AValue;

    For I := 1 To Length (Result) Do
      TghSys.PutChr (Result, I, SimpleChr (Result [I]));
  End;

  Class Function TghLang.SimplifyChr (Var AStr :String;
    Const AIndex :Integer) :Boolean;
  Begin
    Result := TghSys.PutChr (AStr, AIndex, SimpleChr (AStr [AIndex]));
  End;

  Class Function TghLang.SimplifyChrSafe (Var AStr :String;
    Const AIndex :Integer) :Boolean;
  Begin
    Result := TghSys.IsIndex (AIndex, AStr) And SimplifyChr (AStr, AIndex);
  End;

  Class Procedure TghLang.SimplifyStrs (Var AStr1, AStr2 :String);
  Begin
    AStr1 := SimpleStr (AStr1);
    AStr2 := SimpleStr (AStr2);
  End;

  Class Function TghLang.UpperChrOf (Const AValue :String;
    Const AIndex :Integer = 1) :Char;
  Begin
    Result := UpperChr (TghSys.ChrOf (AValue, AIndex));
  End;

  {}//versión no Safe y otra Safe
  Class Function TghLang.UpperChrStr (Const AValue :String;
    Const AIndex :Integer = 1) :String;
  Begin
    Result := AValue;
    PutUpperChrSafe (Result, AIndex);
  End;

  Class Function TghLang.UpperSimpleChr (Const AValue :Char) :Char;
  Begin
    Result := UpperChr (SimpleChr (AValue));
  End;

  Class Function TghLang.UpperSimpleStr (Const AValue :String) :String;
  Begin
    Result := UpperStr (SimpleStr (AValue));
  End;

  Class Procedure TghLang.UpperSimplifyStrs (Var AStr1, AStr2 :String);
  Begin
    AStr1 := UpperSimpleStr (AStr1);
    AStr2 := UpperSimpleStr (AStr2);
  End;

  { Public virtual class methods }

  Class Function TghLang.LowerChr (AValue :Char) :Char;
  Begin
    Result := AValue.ToLower;
  End;

  Class Function TghLang.LowerStr (Const AValue :String) :String;
  Begin
    Result := AValue.ToLower;
  End;

  Class Function TghLang.UpperChr (AValue :Char) :Char;
  Begin
    Result := AValue.ToUpper;
  End;

  Class Function TghLang.UpperStr (Const AValue :String) :String;
  Begin
    Result := AValue.ToUpper;
  End;

End.

