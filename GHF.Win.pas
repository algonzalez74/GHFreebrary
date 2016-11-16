{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Win.pas - TghWin class unit.                                        }
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

Unit GHF.Win;  { Windows }

{ NOTE: In order to avoid circular unit references, the public parts of
  this unit should not depend on other Windows GH Freebrary units.
  Moreover, the only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System and WinAPI unit scopes. The intention is that this unit to be part
  of a central base that can be compiled into any Windows project. }

{$ScopedEnums On}

Interface

  Uses
    WinAPI.Messages, WinAPI.Windows, GHF.Sys;

  Type
    { Windows class }
    TghWin = Class (TghZeroton)
      Private
        Class Constructor Create;
        Class Destructor Destroy;
      Public
        Const
          { Class IDs }

          // MSXML. NOTE: Versions 2.6 and earlier are obsolete.

          // MSXML2.DOMDocument.3.0
          cliMSXMLDoc30 :TGUID = '{F5078F32-C551-11D3-89B9-0000F81FE221}';

          // MSXML2.DOMDocument.4.0
          cliMSXMLDoc40 :TGUID = '{88D969C0-F192-11D4-A65F-0040963251E5}';

          // MSXML2.DOMDocument.5.0
          cliMSXMLDoc50 :TGUID = '{88D969E5-F192-11D4-A65F-0040963251E5}';

          // MSXML2.DOMDocument.6.0
          cliMSXMLDoc60 :TGUID = '{88D96A05-F192-11D4-A65F-0040963251E5}';

          { Messages }

          { Range from wm_User + $400 up to wm_User + $5FF (512 values
            reserved by GH Freebrary) }
          msgMin        = wm_User + $400;  // Minimum
          msgCloseModal = msgMin;
          msgMax        = msgMin + $1FF;  // Maximum

          { MSXML Document Class IDs }
          MSXMLDocClassIDs :Array [0..3] Of TGUID = (
            // MSXML2.DOMDocument.3.0
            '{F5078F32-C551-11D3-89B9-0000F81FE221}',

            // MSXML2.DOMDocument.4.0
            '{88D969C0-F192-11D4-A65F-0040963251E5}',

            // MSXML2.DOMDocument.5.0
            '{88D969E5-F192-11D4-A65F-0040963251E5}',

            // MSXML2.DOMDocument.6.0
            '{88D96A05-F192-11D4-A65F-0040963251E5}');

          { MSXML Schema Cache Class IDs }
          MSXMLSchemaCacheClassIDs :Array [0..3] Of TGUID = (
            // MSXML2.XMLSchemaCache.3.0
            '{F5078F34-C551-11D3-89B9-0000F81FE221}',

            // MSXML2.XMLSchemaCache.4.0
            '{88D969C2-F192-11D4-A65F-0040963251E5}',

            // MSXML2.XMLSchemaCache.5.0
            '{88D969E7-F192-11D4-A65F-0040963251E5}',

            // MSXML2.XMLSchemaCache.6.0
            '{88D96A07-F192-11D4-A65F-0040963251E5}');

          { MSXML Versions }
          MSXMLVersions :Array [0..3] Of String =
            ('3.0', '4.0', '5.0', '6.0');

          { OpenXML }
          oxmSharedStrs :String = 'sharedStrings.xml';

          { Programmatic IDs }

          // MSXML
          priMSXMLSchemaCache :String = 'MSXML2.XMLSchemaCache';

        Type
          { Virtual class. Overridable functionality, accessible via the
            Virtual class property. }
          TVirtual = Class
            Public
              Type
                { Class reference type }
                TClassRef = Class Of TVirtual;

              { Virtual class methods }
              Class Function InternalParentFilePath (Const APath :String;
                AUpLevels :Integer) :String; Virtual;
              Class Function InternalSearchFilePath (Const APath :String;
                Out AFullPath :String) :Cardinal; Virtual;
              Class Function MSXMLDocClassIDsValid (
                Const AValues :Array Of TGUID) :Boolean; Virtual;
              Class Function MSXMLSchemaCacheClassID (
                Const AVersionID :TGUID) :TGUID; Virtual;
              Class Function MSXMLVersion (Const AClassID :TGUID) :String;
                Virtual;
              Class Function ProgIDVersion (Const AClassID :TGUID) :String;
                Virtual;
              Class Function VersionedClassID (
                Const AProgIDBase, AVersion :String) :TGUID; Overload;
                Virtual;
              Class Function VersionedClassID (Const AProgIDBase :String;
                Const AVersionID :TGUID) :TGUID; Overload; Virtual;
          End;

        { Static class methods }
        Class Procedure CheckMSXMLDocClassIDs (
          Const AValues :Array Of TGUID); Static;
        Class Function CheckSearchFilePath (Const APath :String) :String;
          Static;
        Class Function ClassID (Const AProgID :String) :TGUID; Overload;
          Static;
        Class Function COMDispatch (Const AClassID :TGUID) :IDispatch;
          Overload; Static;
        Class Function COMDispatch (Const AClassIDs :Array Of TGUID;
          Const AUsedClassID :PGUID = Nil) :IDispatch; Overload; Static;
        Class Function COMObj (Const AClassID, AIntfID :TGUID) :IUnknown;
          Overload; Static;
        Class Function COMObj (Const AClassIDs :Array Of TGUID;
          Const AIntfID :TGUID; Const AUsedClassID :PGUID = Nil) :IUnknown;
            Overload; Static;
        Class Function COMObj (Const AClassIDs :Array Of TGUID;
          Const AUsedClassID :PGUID = Nil) :IUnknown; Overload; Static;
        Class Function CreateCOMObj (Const AClassID, AIntfID :TGUID;
          Out AIntf) :Integer; Overload; Static;
        Class Function CreateCOMObj (Const AClassID :TGUID; Out AIntf)
          :Integer; Overload; Static;
        Class Function ExeDrive :String; Static;
        Class Function ExeRootPath (Const ASubPath :String) :String;
          Static;
        Class Function GetClassID (Const AProgID :String; Out AID :TGUID)
          :Integer; Overload; Static;
        Class Function GetProgID (Const AClassID :TGUID;
          Out AProgID :String) :Integer; Static;
        Class Function MsgPending (Const AWindow :THandle;
          Const AMinID, AMaxID :Integer) :Boolean; Overload; Static;
        Class Function MsgPending (Const AWindow :THandle = 0;
          Const AID :Integer = 0) :Boolean; Overload; Static;
        Class Function MSXMLSchemaCache (Const AVersionClassID :TGUID)
          :IDispatch; Static;
        Class Function ParentFilePath (Const APath :String;
          Const AUpLevels :Integer = 1) :String; Static;
        Class Function PathHintsDrive (Const AValue :String) :Boolean;
          Static;
        Class Function PeekMsg (Out AMsg :TMsg; Const AWindow :THandle;
          Const AMinID, AMaxID :Integer;
          Const ARemove :Boolean = System.False) :Boolean; Overload;
          Static;
        Class Function PeekMsg (Out AMsg :TMsg; Const AWindow :THandle = 0;
          Const AID :Integer = 0; Const ARemove :Boolean = System.False)
          :Boolean; Overload; Static;
        Class Function ProgID (Const AClassID :TGUID) :String; Static;
        Class Function SearchFilePath (Const APath :String) :String;
          Static;
      Protected
        Class Var
          FVirtual :TVirtual.TClassRef;

        { Static class methods }
        Class Procedure SetVirtual (Const AValue :TVirtual.TClassRef);
          Static;
      Public
        { Class properties }
        Class Property Virtual :TVirtual.TClassRef Read FVirtual
          Write SetVirtual;
    End;

Implementation

  Uses
    System.SysUtils, System.Win.COMObj, WinAPI.ActiveX, GHF.SysEx;

  { Inline routines }{}

  { TghWin }

  { TghWin.TVirtual }

  {}//probar
  Class Function TghWin.TVirtual.InternalParentFilePath (
    Const APath :String; AUpLevels :Integer) :String;
  Var
    LDrive :String;
  Begin
    LDrive := System.SysUtils.ExtractFileDrive (APath);

    If TghSys.SetSolid (Result, TghSys.ParentPath (System.Copy (
    APath, LDrive.Length + 1), AUpLevels, System.SysUtils.PathDelim)) Then
      Result := LDrive + Result;
  End;

  {}//probar
  Class Function TghWin.TVirtual.InternalSearchFilePath (Const APath :String;
    Out AFullPath :String) :Cardinal;
  Var
    LFullPath :Array [0..WinAPI.Windows.Max_Path] Of Char;
  Begin
    Result := WinAPI.Windows.SearchPath (Nil, PChar (APath), Nil,
      WinAPI.Windows.Max_Path + 1, LFullPath, TghSys.DummyChrPtr);

    If Result.ToBoolean Then
      AFullPath := LFullPath;
  End;

  Class Function TghWin.TVirtual.MSXMLDocClassIDsValid (
    Const AValues :Array Of TGUID) :Boolean;
  Begin
    Result := TghSys.GUIDsIn (AValues, MSXMLDocClassIDs);
  End;

  Class Function TghWin.TVirtual.MSXMLSchemaCacheClassID (
    Const AVersionID :TGUID) :TGUID;
  Var
    I :Integer Absolute Result;
  Begin
    I := TghSys.GUIDPos (MSXMLDocClassIDs, AVersionID);

    If I > -1 Then
      Result := MSXMLSchemaCacheClassIDs [I]
    Else
      Result := VersionedClassID (priMSXMLSchemaCache, AVersionID);
  End;

  Class Function TghWin.TVirtual.MSXMLVersion (Const AClassID :TGUID)
    :String;
  Var
    I :Integer;
  Begin
    I := TghSys.GUIDPos (MSXMLDocClassIDs, AClassID);

    If I = -1 Then
      I := TghSys.GUIDPos (MSXMLSchemaCacheClassIDs, AClassID);

    If I > -1 Then
      Result := MSXMLVersions [I]
    Else
      Result := ProgIDVersion (AClassID);
  End;

  Class Function TghWin.TVirtual.ProgIDVersion (Const AClassID :TGUID)
    :String;
  Begin
    Result := TghSys.Virtual.RightVersion (ProgID (AClassID));
  End;

  Class Function TghWin.TVirtual.VersionedClassID (
    Const AProgIDBase, AVersion :String) :TGUID;
  Begin
    Result := ClassID (AProgIDBase + '.' + AVersion);
  End;

  Class Function TghWin.TVirtual.VersionedClassID (
    Const AProgIDBase :String; Const AVersionID :TGUID) :TGUID;
  Begin
    Result := VersionedClassID (AProgIDBase, ProgIDVersion (AVersionID));
  End;

  { Constructors and destructors }

  Class Constructor TghWin.Create;
  Begin
    TVirtual.ghInitVirtualClass (FVirtual);
  End;

  Class Destructor TghWin.Destroy;
  Begin
    TVirtual.ghFinalizeVirtualClass;
  End;

  { Protected static class methods }

  Class Procedure TghWin.SetVirtual (Const AValue :TVirtual.TClassRef);
  Begin
    TVirtual.ghSetVirtualClass (AValue);
  End;

  { Public static class methods }

  Class Procedure TghWin.CheckMSXMLDocClassIDs (
    Const AValues :Array Of TGUID);
  Begin
    If Not Virtual.MSXMLDocClassIDsValid (AValues) Then
      Exception.ghRaise (TghSys.ermInvalidClassIDs, ['XML document']);
  End;

  {}//probar
  Class Function TghWin.CheckSearchFilePath (Const APath :String) :String;
  Begin
    If Not Virtual.InternalSearchFilePath (APath, Result).ToBoolean Then
      {}//simplificar en TghSys obviando GetLastError
      System.SysUtils.RaiseLastOSError (System.GetLastError,
        sLineBreak + 'Searched path: "' + APath + '".')
  End;

  Class Function TghWin.ClassID (Const AProgID :String) :TGUID;
  Begin
    GetClassID (AProgID, Result);
  End;

  Class Function TghWin.COMDispatch (Const AClassID :TGUID) :IDispatch;
  Begin
    Result := IDispatch (COMObj (AClassID, IDispatch));
  End;

  Class Function TghWin.COMDispatch (Const AClassIDs :Array Of TGUID;
    Const AUsedClassID :PGUID = Nil) :IDispatch;
  Begin
    Result := IDispatch (COMObj (AClassIDs, IDispatch, AUsedClassID));
  End;

  Class Function TghWin.COMObj (Const AClassID, AIntfID :TGUID) :IUnknown;
  Begin
    System.Win.COMObj.OLECheck (CreateCOMObj (AClassID, AIntfID, Result));
  End;

  Class Function TghWin.COMObj (Const AClassIDs :Array Of TGUID;
    Const AIntfID :TGUID; Const AUsedClassID :PGUID = Nil) :IUnknown;
  Var
    LError :Integer;
    LID :TGUID;
  Begin
    LError := WinAPI.Windows.E_InvalidArg;  // If AClassIDs is empty

    For LID In AClassIDs Do
    Begin
      LError := CreateCOMObj (LID, AIntfID, Result);

      If LError = WinAPI.Windows.S_OK Then
      Begin
        TghSys.SetGUIDRef (AUsedClassID, LID);
        System.Exit;
      End;
    End;

    OLEError (LError);
  End;

  Class Function TghWin.COMObj (Const AClassIDs :Array Of TGUID;
    Const AUsedClassID :PGUID = Nil) :IUnknown;
  Begin
    Result := COMObj (AClassIDs, IUnknown, AUsedClassID);
  End;

  Class Function TghWin.CreateCOMObj (Const AClassID, AIntfID :TGUID;
    Out AIntf) :Integer;
  Begin
    Result := WinAPI.ActiveX.CoCreateInstance (AClassID, Nil,
      ClsCtx_InProc_Server Or ClsCtx_Local_Server, AIntfID, AIntf);
  End;

  Class Function TghWin.CreateCOMObj (Const AClassID :TGUID; Out AIntf)
    :Integer;
  Begin
    Result := CreateCOMObj (AClassID, IUnknown, AIntf);
  End;

  Class Function TghWin.ExeDrive :String;
  Begin
    Result := System.SysUtils.ExtractFileDrive (TghSys.ExePath);
  End;

  Class Function TghWin.ExeRootPath (Const ASubPath :String) :String;
  Begin
    Result := TghSys.ConcatFilePaths (ExeDrive, ASubPath);
  End;

  {}//asegurar que AID regrese en ceros si CLSIDFromProgID retorna error
  Class Function TghWin.GetClassID (Const AProgID :String; Out AID :TGUID)
    :Integer;
  Begin
    Result := WinAPI.ActiveX.CLSIDFromProgID (PChar (AProgID), AID);
  End;

  Class Function TghWin.GetProgID (Const AClassID :TGUID;
    Out AProgID :String) :Integer;
  Var
    LProgID :POLEStr;
  Begin
    Result := WinAPI.ActiveX.ProgIDFromCLSID (AClassID, LProgID);

    If Result = WinAPI.Windows.S_OK Then
    Begin
      AProgID := LProgID;
      CoTaskMemFree (LProgID);
    End;
  End;

  Class Function TghWin.MsgPending (Const AWindow :THandle;
    Const AMinID, AMaxID :Integer) :Boolean;
  Var
    LMsg :TMsg;
  Begin
    Result := PeekMsg (LMsg, AWindow, AMinID, AMaxID);
  End;

  Class Function TghWin.MsgPending (Const AWindow :THandle = 0;
    Const AID :Integer = 0) :Boolean;
  Begin
    Result := MsgPending (AWindow, AID, AID);
  End;

  Class Function TghWin.MSXMLSchemaCache (Const AVersionClassID :TGUID)
    :IDispatch;
  Begin
    Result := COMDispatch (
      Virtual.MSXMLSchemaCacheClassID (AVersionClassID));
  End;

  {}//probar
  Class Function TghWin.ParentFilePath (Const APath :String;
    Const AUpLevels :Integer = 1) :String;
  Begin
    If TghSys.Keep (Result, APath <> '') Then
      Result := Virtual.InternalParentFilePath (APath, AUpLevels);
  End;

  Class Function TghWin.PathHintsDrive (Const AValue :String) :Boolean;
  Begin
    Result := (AValue.Length > 1) And
      ((AValue [2] = System.SysUtils.DriveDelim) Or
      TghSys.StartsDupChr (AValue, System.SysUtils.PathDelim));
  End;

  Class Function TghWin.PeekMsg (Out AMsg :TMsg; Const AWindow :THandle;
    Const AMinID, AMaxID :Integer; Const ARemove :Boolean = System.False)
    :Boolean;
  Begin
    Result := WinAPI.Windows.PeekMessage (
      AMsg, AWindow, AMinID, AMaxID, System.Ord (ARemove));
  End;

  Class Function TghWin.PeekMsg (Out AMsg :TMsg;
    Const AWindow :THandle = 0; Const AID :Integer = 0;
    Const ARemove :Boolean = System.False) :Boolean;
  Begin
    Result := PeekMsg (AMsg, AWindow, AID, AID, ARemove);
  End;

  Class Function TghWin.ProgID (Const AClassID :TGUID) :String;
  Begin
    GetProgID (AClassID, Result);
  End;

  Class Function TghWin.SearchFilePath (Const APath :String) :String;
  Begin
    Virtual.InternalSearchFilePath (APath, Result);
  End;

End.

