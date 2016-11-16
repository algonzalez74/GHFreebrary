{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.LatinScriptLang.pas - TghLatinScriptLang class unit.                }
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

Unit GHF.LatinScriptLang; { Latin Script Language }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Lang;

  Type
    TghLatinScriptLang = Class (TghLang)
      Public
        Const
          { Characters }
          chrDiacritics = ['´', '¨', '`', '^', '~', '¸'];

          DiacriticLetterCount = 8;
        Type
          { Diacritic type type }
          TDiacriticType = (eNone, eAcuteAccent { ´ }, eDiaeresis { ¨ },
            eGraveAccent { ` }, eCircumflex { ^ }, eTilde { ~ },
            eCedilla { ¸ });

          { Diacritic letters type }
          TDiacriticLetters = Array [TDiacriticType,
            0..DiacriticLetterCount - 1,
            TghLang.TChrCase.eLower..TghLang.TChrCase.eUpper] Of Char;

        Const
          { Diacritics }
          Diacritics :Array [TDiacriticType.eAcuteAccent..
            TDiacriticType.eCedilla] Of Char =
            ('´', '¨', '`', '^', '~', '¸');

          { Letters }

          { Default letters that can be written with diacritics (a, e, i,
            o, u, y, n, c) }
          lttDiacritics :TDiacriticLetters =

            ((('a', 'A'), ('e', 'E'), ('i', 'I'), ('o', 'O'), ('u', 'U'),
             ('y', 'Y'), ('n', 'N'), ('c', 'C')),  // eNone

            (('á', 'Á'), ('é', 'É'), ('í', 'Í'), ('ó', 'Ó'), ('ú', 'Ú'),
             ('ý', 'Ý'), (#0, #0), (#0, #0)),  // eAcuteAccent

            (('ä', 'Ä'), ('ë', 'Ë'), ('ï', 'Ï'), ('ö', 'Ö'), ('ü', 'Ü'),
             ('ÿ', 'Ÿ'), (#0, #0), (#0, #0)),  // eDiaeresis

            (('à', 'À'), ('è', 'È'), ('ì', 'Ì'), ('ò', 'Ò'), ('ù', 'Ù'),
             (#0, #0), (#0, #0), (#0, #0)),  // eGraveAccent

            (('â', 'Â'), ('ê', 'Ê'), ('î', 'Î'), ('ô', 'Ô'), ('û', 'Û'),
             (#0, #0), (#0, #0), (#0, #0)),  // eCircumflex

            (('ã', 'Ã'), (#0, #0), (#0, #0), ('õ', 'Õ'), (#0, #0),
             (#0, #0), ('ñ', 'Ñ'), (#0, #0)),  // eTilde

            ((#0, #0), (#0, #0), (#0, #0), (#0, #0), (#0, #0),
             (#0, #0), (#0, #0), ('ç', 'Ç')));  // eCedilla

        { Static class methods }
        Class Function DiacriticType (Const AValue :Char) :TDiacriticType;
          Overload; Static;

        { Virtual class methods }
        Class Function ComposeChr (AValue :Char;
          ADiacritic :TDiacriticType) :Char; Virtual;
        Class Function DiacriticComposition (AValue :Char;
          ATyping :Boolean = System.False) :String; Virtual;
        Class Function DiacriticType (Const AValue :Char;
          Out ALetterIndex :Integer; Out ACase :TghLang.TChrCase)
          :TDiacriticType; Overload; Virtual;

        { Overridden class methods }
        Class Function ChrComposition (AValue :Char;
          ATyping :Boolean = System.False) :String; Override;
    End;

Implementation

  Uses
    GHF.Sys;

  { Inline routines }{}

  { TghLatinScriptLang }

  { Public static class methods }

  {}//probar
  Class Function TghLatinScriptLang.DiacriticType (Const AValue :Char)
    :TDiacriticType;
  Begin
    For Result := System.Low (Diacritics) To System.High (Diacritics) Do
      If AValue = Diacritics [Result] Then
        System.Exit;

    Result := TDiacriticType.eNone;
  End;

  { Public virtual class methods }

  {}//probar
  Class Function TghLatinScriptLang.ComposeChr (AValue :Char;
    ADiacritic :TDiacriticType) :Char;
  Var
    LCase :TChrCase;
    LLetter :Integer;
  Begin
    DiacriticType (AValue, LLetter, LCase);

    If LLetter = -1 Then  // If AValue is not in lttDiacritics table
      Result := TghSys.IfThen (ADiacritic = TDiacriticType.eNone, AValue)
    Else
      // Same letter with the specified diacritic (or #0)
      Result := lttDiacritics [ADiacritic, LLetter, LCase];
  End;

  {}//probar
  Class Function TghLatinScriptLang.DiacriticComposition (AValue :Char;
    ATyping :Boolean = System.False) :String;
  Begin
    If DiacriticType (AValue) = TDiacriticType.eNone Then
      System.Exit ('');

    Result := AValue;

    If ATyping Then  // For keyboard entries
      Result := Result + ' ';  // ´ + space -> ´
  End;

  {}//probar
  Class Function TghLatinScriptLang.DiacriticType (Const AValue :Char;
    Out ALetterIndex :Integer; Out ACase :TghLang.TChrCase)
    :TDiacriticType;
  Var
    LCase :TChrCase;
    LLetter :Integer;
  Begin
    For Result := System.Low (TDiacriticType) To
    System.High (TDiacriticType) Do
      For LLetter := 0 To DiacriticLetterCount - 1 Do
        For LCase := TChrCase.eLower To TChrCase.eUpper Do
          If lttDiacritics [Result, LLetter, LCase] = AValue Then
          Begin
            ALetterIndex := LLetter;
            ACase := LCase;
            System.Exit;
          End;

    TghSys.ClearIndexBytes (ALetterIndex, Result, ACase);
  End;

  { Public overridden class methods }

  {}//probar
  Class Function TghLatinScriptLang.ChrComposition (AValue :Char;
    ATyping :Boolean = System.False) :String;
  Var
    LCase :TChrCase;
    LDiacritic :TDiacriticType;
    LLetter :Integer;
  Begin
    If TghSys.SetSolid (
    Result, DiacriticComposition (AValue, ATyping)) Then
      System.Exit;

    LDiacritic := DiacriticType (AValue, LLetter, LCase);

    If LDiacritic = TDiacriticType.eNone Then
      System.Exit (AValue);

    Result := TghSys.ConcatChrs (
      lttDiacritics [TDiacriticType.eNone, LLetter, LCase],
      Diacritics [LDiacritic], ATyping);
  End;

End.

