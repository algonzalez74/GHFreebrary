{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.XMLDoc.pas - TghXMLDoc class unit.                                  }
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

Unit GHF.XMLDoc;  { XML Document }

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, WinAPI and XML unit scopes. The intention is that this unit to be
  part of a central base that can be compiled into any Windows project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys;

  Type
    { XML Document class }
    TghXMLDoc = Class
      Protected
        { Instance fields }
        FClassID :TGUID;
        FContent :OLEVariant;
        FPath :String;
        FValidationError :OLEVariant;
        FWorkNode :OLEVariant;

        { Regular instance methods }
        Function GetVersion :String;
        Function GetWorkLevel :Integer;
        Function GetWorkNode :OLEVariant;
        Procedure RaiseNodeNotFound (Const AExpr :String);
        Procedure SetWorkLevel (Value :Integer);
        Procedure SetWorkNode (Const Value :OLEVariant);
      Public
        Constructor Create (Const ClassIDs :Array Of TGUID;
          Const AContent :String = ''); Overload; Virtual;
        Constructor Create (Const AContent :String = ''); Overload;
          Virtual;

        { Regular instance methods }
        Procedure AddSchema (Const NameSpace :String;
          Const Schema :OLEVariant;
          Const ValidateContent :Boolean = System.False); Overload;
        Procedure AddSchema (Const Schema :OLEVariant;
          Const ValidateContent :Boolean = System.False); Overload;
        Function CreateElement (Name :String; Const Text :String = '')
          :OLEVariant; Overload;
        Function CreateElement (Const Name, Attr :String;
          Const AttrValue :OLEVariant) :OLEVariant; Overload;
        Function CreateElement (Const Name, Text :String;
          Const Attrs :Array Of Const) :OLEVariant; Overload;
        Function CreateElement (Const Name :String;
          Const Attrs :Array Of Const) :OLEVariant; Overload;
        Function CreateElement (Const ParentLevel :Integer;
          Const Name :String; Const Text :String = '') :OLEVariant;
          Overload;
        Function CreateElement (Const ParentLevel :Integer;
          Const Name, Attr :String; Const AttrValue :OLEVariant)
          :OLEVariant; Overload;
        Function CreateElement (Const ParentLevel :Integer;
          Const Name, Text :String; Const Attrs :Array Of Const)
          :OLEVariant; Overload;
        Function CreateElement (Const ParentLevel :Integer;
          Const Name :String; Const Attrs :Array Of Const)
          :OLEVariant; Overload;
        Function FindNode (Const Expr :String) :OLEVariant; Overload;
        Function FindNode (Const Expr :String;
          Const Params :Array Of Const) :OLEVariant; Overload;
        Function FindNodes (Const Expr :String) :OLEVariant; Overload;
        Function FindNodes (Const Expr :String;
          Const Params :Array Of Const) :OLEVariant; Overload;
        Function FormatContent :String;
        Function LocateNode (Const Expr :String;
          Const ARaiseError :Boolean = System.False) :Boolean;
        Function Node (Const Expr :String; Const Params :Array Of Const)
          :OLEVariant; Overload;
        Function Nodes (Const Expr :String; Const Params :Array Of Const)
          :OLEVariant; Overload;
        Function Validate :OLEVariant;

        { Virtual instance methods }
        Function DefaultClassIDs :TArray <TGUID>;
        Function Load (Const AContent :String) :Boolean; Virtual;
        Function Node (Const Expr :String) :OLEVariant; Overload; Virtual;
        Function Nodes (Const Expr :String) :OLEVariant; Overload; Virtual;
        Procedure Save (Const APath :String = ''); Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property ClassID :TGUID Read FClassID;
        Property Content :OLEVariant Read FContent;
        Property Path :String Read FPath;
        Property ValidationError :OLEVariant Read FValidationError;
        Property Version :String Read GetVersion;
        Property WorkLevel :Integer Read GetWorkLevel Write SetWorkLevel;
        Property WorkNode :OLEVariant Read GetWorkNode Write SetWorkNode;
    End;

Implementation

  Uses
    System.Variants, System.SysUtils, WinAPI.MSXML, XML.XMLDoc, GHF.Obs,
    GHF.Win, GHF.SysEx;

  { TghXMLDoc }

  Constructor TghXMLDoc.Create (Const ClassIDs :Array Of TGUID;
    Const AContent :String = '');
  Begin
    TghWin.CheckMSXMLDocClassIDs (ClassIDs);

    { After calling TghWin.COMDispatch, FClassID is the class ID that this
      function used to create the FContent COM object (a DOMDocument).
      NOTE: With some versions of MSXML, it is not reliable to use
      IProvideClassInfo or IPersistStream.GetClassID to get the class ID of
      a DOMDocument instance (do not use them for that purpose). }
    FContent := TghWin.COMDispatch (ClassIDs, @FClassID);
    Content.Async := System.False;

    If (AContent <> '') And Not Load (AContent) Then
      EArgumentException.ghRaise (
        TghSys.ermInvalidContentOrFile, ['XML document']);
  End;

  Constructor TghXMLDoc.Create (Const AContent :String = '');
  Begin
    Create (DefaultClassIDs, AContent);
  End;

  { Protected regular instance methods }

  Function TghXMLDoc.GetVersion :String;
  Begin
    Result := TghWin.Virtual.MSXMLVersion (ClassID);
  End;

  Function TghXMLDoc.GetWorkLevel :Integer;
  Var
    ANode :OLEVariant;
  Begin
    ANode := WorkNode;
    Result := 0;

    While Not System.Variants.VarIsClear (ANode.ParentNode) Do
    Begin
      ANode := ANode.ParentNode;
      Inc (Result);
    End;
  End;

  Function TghXMLDoc.GetWorkNode :OLEVariant;
  Begin
    If System.Variants.VarIsClear (FWorkNode) Then
      If System.Variants.VarIsClear (Content.DocumentElement) Then
        FWorkNode := Content
      Else
        FWorkNode := Content.DocumentElement;

    Result := FWorkNode;
  End;

  Procedure TghXMLDoc.RaiseNodeNotFound (Const AExpr :String);
  Begin
    Exception.ghRaise (
      TghSys.ermNotFoundStr, ['XML document node(s)', AExpr]);
  End;

  Procedure TghXMLDoc.SetWorkLevel (Value :Integer);
  Begin
    If Value = WorkLevel Then
      System.Exit;

    Case Value Of
      0 : WorkNode := Content;
      1 : WorkNode := Content.DocumentElement;
      Else
        If Value > 0 Then
          If Value > WorkLevel Then
            {}//probar
            Exception.ghRaise (TghSys.ermCannotStrWhenStr,
              ['point out a work level greater than 1', Value.ToString,
              'current level is less than it', WorkLevel.ToString])
          Else
            WorkLevel := Value - WorkLevel
        Else
          While (Value < 0) And (WorkLevel > 0) Do
          Begin
            WorkNode := WorkNode.ParentNode;
            Inc (Value);
          End;
    End;
  End;

  Procedure TghXMLDoc.SetWorkNode (Const Value :OLEVariant);
  Begin
    If System.Variants.VarIsStr (Value) Then  // Node by expression
      FWorkNode := FindNode (Value)
    Else  // Node by automation object
      FWorkNode := IDispatch (Value);
  End;

  { Public regular instance methods }

  Procedure TghXMLDoc.AddSchema (Const NameSpace :String;
    Const Schema :OLEVariant;
    Const ValidateContent :Boolean = System.False);
  Begin
    { NOTE: This call to VarIsNull is correct here, instead of the typical
      VarIsClear (automation/MSXML bug?). }
    If System.Variants.VarIsNull (Content.Schemas) Then
      Content.Schemas := TghWin.MSXMLSchemaCache (ClassID);

    Content.Schemas.Add (NameSpace, Schema);

    If ValidateContent Then
      Validate;
  End;

  Procedure TghXMLDoc.AddSchema (Const Schema :OLEVariant;
    Const ValidateContent :Boolean = System.False);
  Begin
    AddSchema ('', Schema, ValidateContent);
  End;

  Function TghXMLDoc.CreateElement (Name :String; Const Text :String = '')
    :OLEVariant;
  Var
    NameSpace :String;
  Begin
    If Content.ChildNodes.Length = 0 Then
      Content.AppendChild (Content.CreateProcessingInstruction ('xml',
        'version="1.0" encoding="UTF-8"'));

    If TghSys.ChrIndex (Name, ' ') > 0 Then  // Name and name space
      With TghSys.LeftRightOfOptional (Name, ' ') Do  {}//LeftRightOf, ya no With
      Begin
        Name := Value1;
        NameSpace := Value2;
      End
    Else  // Name only, we use the document name space (if any)
      If Not System.Variants.VarIsClear (Content.DocumentElement) Then
        NameSpace := Content.DocumentElement.NameSpaceURI;

    Result := Content.CreateNode (
      WinAPI.MSXML.Node_Element, Name, NameSpace);

    If Text <> '' Then
      Result.Text := Text;

    WorkNode.AppendChild (Result);
    WorkNode := Result;
  End;

  Function TghXMLDoc.CreateElement (Const Name, Attr :String;
    Const AttrValue :OLEVariant) :OLEVariant;
  Begin
    Result := CreateElement (Name);
    Result.SetAttribute (Attr, AttrValue);
  End;

  Function TghXMLDoc.CreateElement (Const Name, Text :String;
    Const Attrs :Array Of Const) :OLEVariant;
  Var
    I :Integer;
  Begin
    Result := CreateElement (Name, Text);

    For I := 0 To System.High (Attrs) Div 2 Do
      Result.SetAttribute (
        Attrs [I * 2].ghAsOLEVar, Attrs [(I * 2) + 1].ghAsOLEVar);{}//probar (helper)
  End;

  Function TghXMLDoc.CreateElement (Const Name :String;
    Const Attrs :Array Of Const) :OLEVariant;
  Begin
    Result := CreateElement (Name, '', Attrs);
  End;

  Function TghXMLDoc.CreateElement (Const ParentLevel :Integer;
    Const Name :String; Const Text :String = '') :OLEVariant;
  Begin
    WorkLevel := ParentLevel;
    Result := CreateElement (Name, Text);
  End;

  Function TghXMLDoc.CreateElement (Const ParentLevel :Integer;
    Const Name, Attr :String; Const AttrValue :OLEVariant) :OLEVariant;
  Begin
    WorkLevel := ParentLevel;
    Result := CreateElement (Name, Attr, AttrValue);
  End;

  Function TghXMLDoc.CreateElement (Const ParentLevel :Integer;
    Const Name, Text :String; Const Attrs :Array Of Const)
    :OLEVariant;
  Begin
    WorkLevel := ParentLevel;
    Result := CreateElement (Name, Text, Attrs);
  End;

  Function TghXMLDoc.CreateElement (Const ParentLevel :Integer;
    Const Name :String; Const Attrs :Array Of Const) :OLEVariant;
  Begin
    WorkLevel := ParentLevel;
    Result := CreateElement (Name, Attrs);
  End;

  Function TghXMLDoc.FindNode (Const Expr :String) :OLEVariant;
  Begin
    Result := Node (Expr);

    If System.Variants.VarIsClear (Result) Then
      RaiseNodeNotFound (Expr);
  End;

  Function TghXMLDoc.FindNode (Const Expr :String;
    Const Params :Array Of Const) :OLEVariant;
  Begin
    Result := FindNode (System.SysUtils.Format (Expr, Params));
  End;

  Function TghXMLDoc.FindNodes (Const Expr :String) :OLEVariant;
  Begin
    Result := Nodes (Expr);

    If Result.Length = 0 Then
      RaiseNodeNotFound (Expr);
  End;

  Function TghXMLDoc.FindNodes (Const Expr :String;
    Const Params :Array Of Const) :OLEVariant;
  Begin
    Result := FindNodes (System.SysUtils.Format (Expr, Params));
  End;

  Function TghXMLDoc.FormatContent :String;
  Begin
    Result := XML.XMLDoc.FormatXMLData (Content.XML);
  End;

  {$Warn No_RetVal Off}
  Function TghXMLDoc.LocateNode (Const Expr :String;
    Const ARaiseError :Boolean = System.False) :Boolean;
  Var
    ANode :OLEVariant;
  Begin
    ANode := Node (Expr);

    If System.Variants.VarIsClear (ANode) Then
      If ARaiseError Then
        RaiseNodeNotFound (Expr)
      Else
        Result := System.False
    Else
    Begin
      WorkNode := ANode;
      Result := System.True;
    End;
  End;
  {$Warn No_RetVal On}

  Function TghXMLDoc.Node (Const Expr :String;
    Const Params :Array Of Const) :OLEVariant;
  Begin
    Result := Node (System.SysUtils.Format (Expr, Params));
  End;

  Function TghXMLDoc.Nodes (Const Expr :String;
    Const Params :Array Of Const) :OLEVariant;
  Begin
    Result := Nodes (System.SysUtils.Format (Expr, Params));
  End;

  Function TghXMLDoc.Validate :OLEVariant;
  Begin
    FValidationError := Content.Validate;
    Result := FValidationError;
  End;

  { Public virtual instance methods }

  Function TghXMLDoc.DefaultClassIDs :TArray <TGUID>;
  Begin
    { Preferred class IDs of MSXML DOMDocument. NOTE:
      MSXML2.DOMDocument.5.0 (TghWin.cliMSXMLDoc50) is part of Microsoft
      Office and not a formal Windows standard. }
    Result := [TghWin.cliMSXMLDoc60, TghWin.cliMSXMLDoc40,
      TghWin.cliMSXMLDoc30];
  End;

  Function TghXMLDoc.Load (Const AContent :String) :Boolean;
  Var
    Prefix :String;
  Begin
    If (AContent = '') Or (AContent [1] = '<') Then
    Begin
      Result := Content.LoadXML (AContent);  // XML text
      FPath := '';
    End
    Else  // File path
    Begin
      FPath := TghWin.CheckSearchFilePath (AContent);
      Result := Content.Load (FPath);

      If Not Result Then
        FPath := '';
    End;

    FWorkNode := System.Variants.Unassigned;

    If Result And (Content.DocumentElement.NameSpaceURI <> '') Then
    Begin
      Prefix := Content.DocumentElement.Prefix;

      If Prefix = '' Then
        { NOTE: The SelectNodes and SelectSingleNode methods of MSXML need
          that every name space in SelectionNamespaces has a prefix.  We
          use the "_" alias when the document element has no prefix. }
        Prefix := '_';

      Content.SetProperty ('SelectionNamespaces', System.SysUtils.Format (
        'xmlns:%s="%s"', [Prefix, Content.DocumentElement.NameSpaceURI]));
    End;
  End;

  Function TghXMLDoc.Node (Const Expr :String) :OLEVariant;
  Begin
    { We search from the current work node by using the given XPath
      expression.  NOTE: Expr can be a relative or absolute path. }
    Result := WorkNode.SelectSingleNode (Expr);
  End;

  Function TghXMLDoc.Nodes (Const Expr :String) :OLEVariant;
  Begin
    { We search from the current work node by using the given XPath
      expression.  NOTE: Expr can be a relative or absolute path. }
    Result := WorkNode.SelectNodes (Expr);
  End;

  Procedure TghXMLDoc.Save (Const APath :String = '');
  Var
    ExpandedPath :String;
  Begin
    If APath = '' Then
      Content.Save (Path)
    Else
    Begin
      ExpandedPath := ExpandFileName (APath);
      Content.Save (ExpandedPath);  // Exception if the Save method fails
      FPath := ExpandedPath;
    End;
  End;

  { Public overridden instance methods }

  Procedure TghXMLDoc.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

End.

