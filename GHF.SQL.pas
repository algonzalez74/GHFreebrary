{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.SQL.pas - TghSQL class unit.                                        }
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

Unit GHF.SQL;  { SQL }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys, System.Types;

  Type
    { SQL class }
    TghSQL = Class (TghZeroton)
      Public
        Type
          { Class reference type }
          TClassRef = Class Of TghSQL;

        { Regular class methods }
        Class Function ConcatLiteralValues (
          Const AValues :Array Of Variant; Const ASeparator :String = ', ')
          :String; Overload;
        Class Function ConcatLiteralValues (Const AValues :Variant;
          Const ASeparator :String = ', ') :String; Overload;
        Class Function LiteralDate (Const AValue :TDateTime) :String;
          Overload;
        Class Function LiteralDate :String; Overload;
        Class Function LiteralDateTime (Const AValue :TDateTime) :String;
          Overload;
        Class Function LiteralDateTime :String; Overload;
        Class Function LiteralTime (Const AValue :TDateTime) :String;
          Overload;
        Class Function LiteralTime :String; Overload;
        Class Function LiteralValues (Const AValues :Array Of Variant)
          :TArray <String>; Overload;
        Class Function LiteralValues (Const AValues :Variant)
          :TArray <String>; Overload;

        { Virtual class methods }
        Class Function LiteralDateFormat :String; Virtual;
        Class Function LiteralDateTimeFormat :String; Virtual;
        Class Function LiteralTimeFormat :String; Virtual;
        Class Function LiteralValue (Const AValue :Variant) :String;
          Virtual;
    End;

Implementation

  Uses
    System.SysUtils, GHF.SysEx;

  { TghSQL }

  { Public regular class methods }

  Class Function TghSQL.ConcatLiteralValues (
    Const AValues :Array Of Variant; Const ASeparator :String = ', ')
    :String;
  Begin
    Result := String.Join (ASeparator, LiteralValues (AValues));
  End;

  Class Function TghSQL.ConcatLiteralValues (Const AValues :Variant;
    Const ASeparator :String = ', ') :String;
  Begin
    Result := String.Join (ASeparator, LiteralValues (AValues));
  End;

  Class Function TghSQL.LiteralDate (Const AValue :TDateTime) :String;
  Begin
    Result := System.SysUtils.FormatDateTime (LiteralDateFormat, AValue);
  End;

  Class Function TghSQL.LiteralDate :String;
  Begin
    Result := LiteralDate (System.SysUtils.Date);
  End;

  Class Function TghSQL.LiteralDateTime (Const AValue :TDateTime) :String;
  Begin
    Result := System.SysUtils.FormatDateTime (
      LiteralDateTimeFormat, AValue);
  End;

  Class Function TghSQL.LiteralDateTime :String;
  Begin
    Result := LiteralDateTime (System.SysUtils.Now);
  End;

  Class Function TghSQL.LiteralTime (Const AValue :TDateTime) :String;
  Begin
    Result := System.SysUtils.FormatDateTime (LiteralTimeFormat, AValue);
  End;

  Class Function TghSQL.LiteralTime :String;
  Begin
    Result := LiteralTime (System.SysUtils.Time);
  End;

  Class Function TghSQL.LiteralValues (Const AValues :Array Of Variant)
    :TArray <String>;
  Var
    I :Integer;
  Begin
    For I := 0 To
    TghSys.SetHigh <String> (Result, System.High (AValues)) Do
      Result [I] := LiteralValue (AValues [I]);
  End;

  {}//probar
  Class Function TghSQL.LiteralValues (Const AValues :Variant)
    :TArray <String>;
  Var
    I :Integer;
  Begin
    If AValues.ghIsArr Then
      For I := 0 To TghSys.SetHigh <String> (Result, AValues.ghHigh) Do
        Result [I] := LiteralValue (AValues [I])
    Else
      Result [TghSys.SetHigh <String> (Result, 0)] :=
        LiteralValue (AValues);
  End;

  { Public virtual class methods }

  Class Function TghSQL.LiteralDateFormat :String;
  Begin
    Result := TghSys.QuotedFormat (TghSys.fmtISODate);
  End;

  Class Function TghSQL.LiteralDateTimeFormat :String;
  Begin
    Result := TghSys.QuotedFormat (TghSys.fmtStdDateTime);
  End;

  Class Function TghSQL.LiteralTimeFormat :String;
  Begin
    Result := TghSys.QuotedFormat (TghSys.fmtISOTime);
  End;

  Class Function TghSQL.LiteralValue (Const AValue :Variant) :String;
  Begin
    If AValue.ghIsSolid Then
      If AValue.ghIsStr Then
        Result := System.SysUtils.QuotedStr (AValue)
      Else
        If AValue.ghFindData.VType = varDate Then
          If System.Frac (AValue) = 0 Then
            Result := LiteralDate (AValue)
          Else
            Result := LiteralDateTime (AValue)
        Else
          Result := AValue
    Else
      Result := 'Null'  // varEmpty or varNull
  End;

End.

