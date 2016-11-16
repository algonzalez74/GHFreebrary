{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.OpenXMLSpreadsheet.pas - TghOpenXMLSpreadsheet class and            }
{                              TghOpenXMLSpreadsheetBook class unit.      }
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

Unit GHF.OpenXMLSpreadsheet;  { OpenXML Spreadsheet }

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and XML unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any Windows project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.OpenXMLPart, GHF.OpenXMLSpreadsheetStrs, System.Contnrs;

  Type
    TghOpenXMLSpreadsheetBook = Class;

    { OpenXML Spreadsheet class }
    TghOpenXMLSpreadsheet = Class (TghOpenXMLPart)
      Protected
        { Instance fields }
        FBook :TghOpenXMLSpreadsheetBook;
        FStrs :TghOpenXMLSpreadsheetStrs;

        { Regular instance methods }
        Function GetStrs :TghOpenXMLSpreadsheetStrs;

        { Virtual instance methods }
        Function GetValue (Const ACell :String) :Variant; Virtual;
      Public
        ID :Integer;
        
        Constructor Create (Const ABook :TghOpenXMLSpreadsheetBook;
          Const AContent :String = ''); Reintroduce; Overload; Virtual;
        Destructor Destroy; Override;

        { Regular instance methods }
        Function Cell (Const Column :Char; Const Row :Integer) :OLEVariant;
          Overload;
        Function FindCell (Const Ref :String) :OLEVariant;
        Function Float (Const ACell :String) :Double; Overload;
        Function Float (Const Column :Char; Const Row :Integer) :Double;
          Overload;
        Function HasValue (Const ACell :String) :Boolean; Overload;
        Function HasValue (Const Column :Char; Const Row :Integer)
          :Boolean; Overload;
        Function Int (Const ACell :String) :Integer; Overload;
        Function Int (Const Column :Char; Const Row :Integer) :Integer;
          Overload;
        Function IsNull (Const ACell :String) :Boolean; Overload;
        Function IsNull (Const Column :Char; Const Row :Integer) :Boolean;
          Overload;
        Function Str (Const ACell :String) :String; Overload;
        Function Str (Const Column :Char; Const Row :Integer) :String;
          Overload;
        Function Value (Const Column :Char; Const Row :Integer) :Variant;

        { Virtual instance methods }
        Function Cell (Const Ref :String) :OLEVariant; Overload; Virtual;

        { Instance properties }
        Property Book :TghOpenXMLSpreadsheetBook Read FBook;
        Property Strs :TghOpenXMLSpreadsheetStrs Read GetStrs;
        Property Values [Const ACell :String] :Variant
          Read GetValue; Default;
    End;

    {}//revisar referencia circular de ambas clases y posible solución con helper
    { OpenXML Spreadsheet Book class }
    TghOpenXMLSpreadsheetBook = Class (TghOpenXMLPart)
      Protected
        FSheets :TObjectList;
        FStrs :TghOpenXMLSpreadsheetStrs;

        { Regular instance methods }
        Function GetStrs :TghOpenXMLSpreadsheetStrs;

        { Virtual instance methods }
        Function GetSheet (Const Name :String) :TghOpenXMLSpreadsheet;
          Virtual;
      Public
        Destructor Destroy; Override;

        { Regular instance methods }
        Procedure SaveSheets;

        { Instance properties }
        Property Sheets [Const Name :String] :TghOpenXMLSpreadsheet
          Read GetSheet; Default;
        Property Strs :TghOpenXMLSpreadsheetStrs Read GetStrs;
    End;

Implementation

  Uses
    System.SysUtils, Variants, System.Classes, System.Types, GHF.Win,
    GHF.Sys, GHF.SysEx;

  { TghOpenXMLSpreadsheet }

  Constructor TghOpenXMLSpreadsheet.Create (
    Const ABook :TghOpenXMLSpreadsheetBook; Const AContent :String = '');
  Begin
    FBook := ABook;
    Create (AContent);
  End;

  Destructor TghOpenXMLSpreadsheet.Destroy;
  Begin
    // We free the owned string object (when FStrs <> Nil)
    System.SysUtils.FreeAndNil (FStrs);

    If (Book <> Nil) And (Book.FSheets <> Nil) Then
      Book.FSheets.Extract (Self);

    Inherited Destroy;
  End;

  { Protected regular instance methods }

  Function TghOpenXMLSpreadsheet.GetStrs :TghOpenXMLSpreadsheetStrs;
  Begin
    If FStrs = Nil Then
      If Book <> Nil Then
        System.Exit (Book.Strs)
      Else
        { sharedStrings.xml in the parent directory
          (...\xl\worksheets\sheet1.xml -> ...\xl\sharedStrings.xml) }
        FStrs := TghOpenXMLSpreadsheetStrs.CreateFromDir (
          TghWin.ParentFilePath (Path, 2));

    Result := FStrs;
  End;

  { Protected virtual instance methods }

  Function TghOpenXMLSpreadsheet.GetValue (Const ACell :String) :Variant;
  Var
    CellObj :OLEVariant;
  Begin
    CellObj := Cell (ACell);

    If VarIsClear (CellObj) Then
      Result := Null
    Else
    Begin
      Result := CellObj.SelectSingleNode ('_:v');

      If VarIsClear (Result) Then
        Result := Null
      Else
        { String type cell (value in sharedStrings.xml).  NOTE: The string
          type cast is necessary here to prevent automation bug with
          WideChar expressions (or literal strings of length 1) in Delphi
          2009-XE2 (quality report #67556). }
        If CellObj.GetAttribute (String ('t')) = 's' Then
          Result := Strs [Result.Text]
        Else  // Other types use direct values
          Result := Result.Text;
    End;
  End;

  { Public regular instance methods }

  Function TghOpenXMLSpreadsheet.Cell (Const Column :Char;
    Const Row :Integer) :OLEVariant;
  Begin
    Result := Cell (Column + IntToStr (Row));
  End;

  Function TghOpenXMLSpreadsheet.FindCell (Const Ref :String) :OLEVariant;
  Begin
    Result := Cell (Ref);

    If VarIsClear (Result) Then
      EArgumentException.ghRaise (
        TghSys.ermCellNotFound, ['spreadsheet', Ref]);
  End;

  Function TghOpenXMLSpreadsheet.Float (Const ACell :String) :Double;
  Begin
    Result := Values [ACell].ghFloat;
  End;

  Function TghOpenXMLSpreadsheet.Float (Const Column :Char;
    Const Row :Integer) :Double;
  Begin
    Result := Value (Column, Row).ghFloat;
  End;

  Function TghOpenXMLSpreadsheet.HasValue (Const ACell :String) :Boolean;
  Begin
    Result := Not VarIsNull (Values [ACell]);
  End;

  Function TghOpenXMLSpreadsheet.HasValue (Const Column :Char;
    Const Row :Integer) :Boolean;
  Begin
    Result := Not VarIsNull (Value (Column, Row));
  End;

  Function TghOpenXMLSpreadsheet.Int (Const ACell :String) :Integer;
  Begin
    Result := Values [ACell].ghInt;
  End;

  Function TghOpenXMLSpreadsheet.Int (Const Column :Char;
    Const Row :Integer) :Integer;
  Begin
    Result := Value (Column, Row).ghInt;
  End;

  Function TghOpenXMLSpreadsheet.IsNull (Const ACell :String) :Boolean;
  Begin
    Result := VarIsNull (Values [ACell]);
  End;

  Function TghOpenXMLSpreadsheet.IsNull (Const Column :Char;
    Const Row :Integer) :Boolean;
  Begin
    Result := VarIsNull (Value (Column, Row));
  End;

  Function TghOpenXMLSpreadsheet.Str (Const ACell :String) :String;
  Begin
    Result := VarToStr (Values [ACell]);
  End;

  Function TghOpenXMLSpreadsheet.Str (Const Column :Char;
    Const Row :Integer) :String;
  Begin
    Result := VarToStr (Value (Column, Row));
  End;

  Function TghOpenXMLSpreadsheet.Value (Const Column :Char;
    Const Row :Integer) :Variant;
  Begin
    Result := Values [Column + IntToStr (Row)];
  End;

  { Public virtual instance methods }

  Function TghOpenXMLSpreadsheet.Cell (Const Ref :String) :OLEVariant;
  Begin
    { First cell (/worksheet/sheetData/row/c) with the r attribute equal to
      Ref }
    Result := Node ('/_:worksheet/_:sheetData/_:row/_:c[@r="%s"]',
      [UpperCase (Ref)]);
  End;

  { TghOpenXMLSpreadsheetBook }

  Destructor TghOpenXMLSpreadsheetBook.Destroy;
  Begin
    System.SysUtils.FreeAndNil (FSheets);
    System.SysUtils.FreeAndNil (FStrs);
    Inherited Destroy;
  End;

  { Protected regular instance methods }

  Function TghOpenXMLSpreadsheetBook.GetStrs :TghOpenXMLSpreadsheetStrs;
  Begin
    If FStrs = Nil Then
      // sharedStrings.xml in the same directory that workbook.xml
      FStrs := TghOpenXMLSpreadsheetStrs.CreateFromDir (
        TghWin.ParentFilePath (Path));

    Result := FStrs
  End;

  { Protected virtual instance methods }

  Function TghOpenXMLSpreadsheetBook.GetSheet (Const Name :String)
    :TghOpenXMLSpreadsheet;
  Var
    ANode :OLEVariant;
    I, ID :Integer;
  Begin
    { First sheet entry (/workbook/sheets/sheet) with the name attribute
      equal to Name }
    ANode := FindNode ('/_:workbook/_:sheets/_:sheet[@name="%s"]', [Name]);

    ID := ANode.GetAttribute ('sheetId');

    If FSheets <> Nil Then
      For I := 0 To FSheets.Count - 1 Do
        If (FSheets [I] As TghOpenXMLSpreadsheet).ID = ID Then
          System.Exit (TghOpenXMLSpreadsheet (FSheets [I]));

    Result := TghOpenXMLSpreadsheet.Create (Self,
      Rels.ElementTargetPath (ANode));

    Try
      Result.ID := ID;
      
      If FSheets = Nil Then
        FSheets := TObjectList.Create;

      FSheets.Add (Result);
    Except
      Result.Free;
      Raise;
    End;
  End;

  { Public regular instance methods }

  Procedure TghOpenXMLSpreadsheetBook.SaveSheets;
  Var
    I :Integer;
  Begin
    If FSheets <> Nil Then
      For I := 0 To FSheets.Count - 1 Do
        (FSheets [I] As TghOpenXMLSpreadsheet).Save;
  End;

End.
