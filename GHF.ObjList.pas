{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.ObjList.pas - TghObjList class unit.                                }
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

Unit GHF.ObjList;  { Object List }

{}//sustituir su uso por clase nueva descendiente de genérica

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

Interface

  Uses
    System.Contnrs, System.Classes, GHF.Sys;

  Type
    {}//revisar qué métodos pueden ser inline
    {}//con observador para objetos no componentes
    { Object List class }
    TghObjList = Class (TObjectList)
      Protected
        { Instance fields }
        AuxLists :TList;

        {}//manejarlo con TghObs
        ComponentNexus :TComponent;  // TComponentNexus

        { Regular instance methods }
        Function InternalEnum (Const ATempList :TghObjList;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
        Function InternalAddItems (Const List :TObjectList;
          AStartIndex :Integer; Const AEndIndex :Integer;
          Const AClass :TClass) :Integer; Overload;
        Function InternalAddItems (Const List :TStrings;
          AStartIndex :Integer; Const AEndIndex :Integer;
          Const AClass :TClass) :Integer; Overload;

        { Overridden instance methods }
        Procedure Notify (Ptr :Pointer; Action :TListNotification);
          Override;
      Public
        Destructor Destroy; Override;

        { Regular instance methods }

        Function AddComponents (Const Owner :TComponent;
          Const AClass :TComponentClass = Nil;
          Const Recurse :Boolean = System.False) :Integer; Overload;
        Function AddComponents (Const Owner :TComponent;
          Const Recurse :Boolean) :Integer; Overload;
        Function AddItems (Const List :TObjectList;
          AStartIndex :Integer = 0; Const AEndIndex :Integer = System.MaxInt;
          Const AClass :TClass = Nil) :Integer; Overload;
        Function AddItems (Const List :TObjectList;
          Const AStartIndex :Integer; Const AClass :TClass) :Integer;
          Overload;
        Function AddItems (Const List :TObjectList; Const AClass :TClass)
          :Integer; Overload;
        Function AddItems (Const List :TStrings;
          AStartIndex :Integer = 0; Const AEndIndex :Integer = System.MaxInt;
          Const AClass :TClass = Nil) :Integer; Overload;
        Function AddItems (Const List :TStrings;
          Const AStartIndex :Integer; Const AClass :TClass) :Integer;
          Overload;
        Function AddItems (Const List :TStrings; Const AClass :TClass)
          :Integer; Overload;

        // Call methods without AParam parameter }
        Procedure Call (Const AStartIndex, AEndIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer); Overload;
        Procedure Call (Const AStartIndex :Integer; Const AClass :TClass;
          Const AMethodAddress :Pointer); Overload;
        Procedure Call (Const AStartIndex, AEndIndex :Integer;
          Const AMethodAddress :Pointer); Overload;
        Procedure Call (Const AClass :TClass;
          Const AMethodAddress :Pointer); Overload;
        Procedure Call (Const AStartIndex :Integer;
          Const AMethodAddress :Pointer); Overload;
        Procedure Call (Const AMethodAddress :Pointer); Overload;
        Function Call <TResult> (Const AStartIndex, AEndIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer) :TResult;
          Overload;
        Function Call <TResult> (Const AStartIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer) :TResult;
          Overload;
        Function Call <TResult> (Const AStartIndex, AEndIndex :Integer;
          Const AMethodAddress :Pointer) :TResult; Overload;
        Function Call <TResult> (Const AClass :TClass;
          Const AMethodAddress :Pointer) :TResult; Overload;
        Function Call <TResult> (Const AStartIndex :Integer;
          Const AMethodAddress :Pointer) :TResult; Overload;
        Function Call <TResult> (Const AMethodAddress :Pointer) :TResult;
          Overload;

        // Call methods with AParam parameter }
        Procedure Call <TParam> (Const AStartIndex, AEndIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer;
          Const AParam :TParam); Overload;
        Procedure Call <TParam> (Const AStartIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer;
          Const AParam :TParam); Overload;
        Procedure Call <TParam> (Const AStartIndex, AEndIndex :Integer;
          Const AMethodAddress :Pointer; Const AParam :TParam); Overload;
        Procedure Call <TParam> (Const AClass :TClass;
          Const AMethodAddress :Pointer; Const AParam :TParam); Overload;
        Procedure Call <TParam> (Const AStartIndex :Integer;
          Const AMethodAddress :Pointer; Const AParam :TParam); Overload;
        Procedure Call <TParam> (Const AMethodAddress :Pointer;
          Const AParam :TParam); Overload;
        Function Call <TParam, TResult> (
          Const AStartIndex, AEndIndex :Integer; Const AClass :TClass;
          Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
          Overload;
        Function Call <TParam, TResult> (Const AStartIndex :Integer;
          Const AClass :TClass; Const AMethodAddress :Pointer;
          Const AParam :TParam) :TResult; Overload;
        Function Call <TParam, TResult> (Const AStartIndex, AEndIndex :Integer;
          Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
          Overload;
        Function Call <TParam, TResult> (Const AClass :TClass;
          Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
          Overload;
        Function Call <TParam, TResult> (Const AStartIndex :Integer;
          Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
          Overload;
        Function Call <TParam, TResult> (Const AMethodAddress :Pointer;
          Const AParam :TParam) :TResult; Overload;

        Function Clone (Const AStartIndex :Integer; Const AClass :TClass)
          :TghObjList; Overload;
        Function Clone (Const AClass :TClass) :TghObjList; Overload;
        Function Enum (Const AStartIndex, AEndIndex :Integer;
          Const AClass :TClass;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
          Overload;
        Function Enum (Const AStartIndex :Integer; Const AClass :TClass;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
          Overload;
        Function Enum (Const AStartIndex, AEndIndex :Integer;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
          Overload;
        Function Enum (Const AClass :TClass;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
          Overload;
        Function Enum (Const AStartIndex :Integer;
          Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
          Overload;
        Function Enum (Const AProc :TghSys.TEnumerationProcRef <TObject>)
          :TObject; Overload;
        Function Remove (Const Index :Integer) :TObject; Overload;

        { Virtual instance methods }
        Function Clone (AStartIndex :Integer = 0;
          AEndIndex :Integer = System.MaxInt; AClass :TClass = Nil) :TghObjList;
          Overload; Virtual;
    End;

    { Object List class type }
    TghObjListClass = Class Of TghObjList;

Implementation

  Uses
    System.Variants, System.SysUtils, System.Types, GHF.Obs, GHF.SysEx;

  Type
    TComponentNexus = Class (TComponent)
      Protected
        { Instance fields }
        List :TghObjList;

        { Overridden instance methods }
        Procedure Notification (AComponent :TComponent;
          Operation :TOperation); Override;
      Public
        Constructor Create (Const AList :TghObjList); Reintroduce;
    End;

  { TComponentNexus }

  Constructor TComponentNexus.Create (Const AList :TghObjList);
  Begin
    Inherited Create (Nil);
    List := AList;
  End;

  { Protected overridden instance methods }

  Procedure TComponentNexus.Notification (AComponent :TComponent;
    Operation :TOperation);
  Begin
    If Operation = System.Classes.opRemove Then
      List.Extract (AComponent);

    Inherited Notification (AComponent, Operation);
  End;

  { TghObjList }

  Destructor TghObjList.Destroy;
  Begin
    ghPreDestroy;
    System.SysUtils.FreeAndNil (AuxLists);{}//respecto a ObjFree
    Inherited Destroy;
    ComponentNexus.Free;{}//respecto a ObjFree
  End;

  { Protected regular instance methods }

  Function TghObjList.InternalEnum (Const ATempList :TghObjList;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    While ATempList.Count > 0 Do
    Begin
      Result := ATempList.Remove (0);

      { If the object is still in this (Self) list, we call to AProc. NOTE:
        AProc could destroy any object in the list (see AuxLists field). }
      If (IndexOf (Result) > -1) And
      Not TghSys.Call <TObject> (AProc, Result) Then
        System.Exit;  // AProc stopped the enumeration
    End;

    Result := Nil;
  End;

  Function TghObjList.InternalAddItems (Const List :TObjectList;
    AStartIndex :Integer; Const AEndIndex :Integer; Const AClass :TClass)
    :Integer;
  Begin
    Result := 0;

    For AStartIndex := AStartIndex To AEndIndex Do
      If (AClass = Nil) Or (List [AStartIndex] Is AClass) Then
      Begin
        Add (List [AStartIndex]);
        Inc (Result);
      End;
  End;

  Function TghObjList.InternalAddItems (Const List :TStrings;
    AStartIndex :Integer; Const AEndIndex :Integer; Const AClass :TClass)
    :Integer;
  Begin
    Result := 0;

    For AStartIndex := AStartIndex To AEndIndex Do
      If (AClass = Nil) Or (List.Objects [AStartIndex] Is AClass) Then
      Begin
        Add (List.Objects [AStartIndex]);
        Inc (Result);
      End;
  End;

  { Protected overridden instance methods }

  Procedure TghObjList.Notify (Ptr :Pointer; Action :TListNotification);
  Var
    I :Integer;
  Begin
    If TObject (Ptr) Is TComponent Then
      If Action = lnAdded Then
      Begin
        If ComponentNexus = Nil Then
          ComponentNexus := TComponentNexus.Create (Self);

        TComponent (Ptr).FreeNotification (ComponentNexus);
      End
      Else  // lnExtracted, lnDeleted
        TComponent (Ptr).RemoveFreeNotification (ComponentNexus)
    Else
      If (AuxLists <> Nil) And (Action In [lnExtracted, lnDeleted]) Then
        For I := 0 To AuxLists.Count - 1 Do
          TghObjList (AuxLists [I]).Remove (TObject (Ptr));

    Inherited Notify (Ptr, Action);
  End;

  { Public regular instance methods }

  Function TghObjList.AddComponents (Const Owner :TComponent;
    Const AClass :TComponentClass = Nil;
    Const Recurse :Boolean = System.False) :Integer;
  Var
    I :Integer;
  Begin
    Result := 0;

    For I := 0 To Owner.ComponentCount - 1 Do
    Begin
      If (AClass = Nil) Or (Owner.Components [I] Is AClass) Then
      Begin
        Add (Owner.Components [I]);
        Inc (Result);
      End;

      If Recurse Then
        Inc (Result,
          AddComponents (Owner.Components [I], AClass, System.True));
    End;
  End;

  Function TghObjList.AddComponents (Const Owner :TComponent;
    Const Recurse :Boolean) :Integer;
  Begin
    Result := AddComponents (Owner, TComponentClass (Nil), Recurse);
  End;

  Function TghObjList.AddItems (Const List :TObjectList;
    AStartIndex :Integer = 0; Const AEndIndex :Integer = System.MaxInt;
    Const AClass :TClass = Nil) :Integer;
  Begin
    Result := InternalAddItems (List, TghSys.EnsureIndexMin (AStartIndex),
      TghSys.EnsureIndexMax (AEndIndex, List.Count), AClass);
  End;

  Function TghObjList.AddItems (Const List :TObjectList;
    Const AStartIndex :Integer; Const AClass :TClass) :Integer;
  Begin
    Result := InternalAddItems (List, TghSys.EnsureIndexMin (AStartIndex),
      List.Count - 1, AClass);
  End;

  Function TghObjList.AddItems (Const List :TObjectList;
    Const AClass :TClass) :Integer;
  Begin
    Result := InternalAddItems (List, 0, List.Count - 1, AClass);
  End;

  Function TghObjList.AddItems (Const List :TStrings;
    AStartIndex :Integer = 0; Const AEndIndex :Integer = System.MaxInt;
    Const AClass :TClass = Nil) :Integer;
  Begin
    Result := InternalAddItems (List, TghSys.EnsureIndexMin (AStartIndex),
      TghSys.EnsureIndexMax (AEndIndex, List.Count), AClass);
  End;

  Function TghObjList.AddItems (Const List :TStrings;
    Const AStartIndex :Integer; Const AClass :TClass) :Integer;
  Begin
    Result := InternalAddItems (List, TghSys.EnsureIndexMin (AStartIndex),
      List.Count - 1, AClass);
  End;

  Function TghObjList.AddItems (Const List :TStrings; Const AClass :TClass)
    :Integer;
  Begin
    Result := InternalAddItems (List, 0, List.Count - 1, AClass);
  End;

  Procedure TghObjList.Call (Const AStartIndex, AEndIndex :Integer;
    Const AClass :TClass; Const AMethodAddress :Pointer);
  Begin
    Enum (AStartIndex, AEndIndex, AClass,
      Procedure (Const AObj :TObject; Var AContinue :Boolean)
      Begin
        AObj.ghCall (AMethodAddress);
      End);
  End;

  Procedure TghObjList.Call (Const AStartIndex :Integer;
    Const AClass :TClass; Const AMethodAddress :Pointer);
  Begin
    Call (AStartIndex, Count - 1, AClass, AMethodAddress);
  End;

  Procedure TghObjList.Call (Const AStartIndex, AEndIndex :Integer;
    Const AMethodAddress :Pointer);
  Begin
    Call (AStartIndex, AEndIndex, TClass (Nil), AMethodAddress);
  End;

  Procedure TghObjList.Call (Const AClass :TClass;
    Const AMethodAddress :Pointer);
  Begin
    Call (0, Count - 1, AClass, AMethodAddress);
  End;

  Procedure TghObjList.Call (Const AStartIndex :Integer;
    Const AMethodAddress :Pointer);
  Begin
    Call (AStartIndex, Count - 1, TClass (Nil), AMethodAddress);
  End;

  Procedure TghObjList.Call (Const AMethodAddress :Pointer);
  Begin
    Call (0, Count - 1, TClass (Nil), AMethodAddress);
  End;

  Function TghObjList.Call <TResult> (
    Const AStartIndex, AEndIndex :Integer; Const AClass :TClass;
    Const AMethodAddress :Pointer) :TResult;
  Var
    LResult :TResult;
  Begin
    Enum (AStartIndex, AEndIndex, AClass,
      Procedure (Const AObj :TObject; Var AContinue :Boolean)
      Begin
        LResult := AObj.ghCall <TResult> (AMethodAddress);
      End);

    Result := LResult;  // Result of the last called method
  End;

  Function TghObjList.Call <TResult> (Const AStartIndex :Integer;
    Const AClass :TClass; Const AMethodAddress :Pointer) :TResult;
  Begin
    Result := Call <TResult> (
      AStartIndex, Count - 1, AClass, AMethodAddress);
  End;

  Function TghObjList.Call <TResult> (
    Const AStartIndex, AEndIndex :Integer; Const AMethodAddress :Pointer)
    :TResult;
  Begin
    Result := Call <TResult> (AStartIndex, AEndIndex, Nil, AMethodAddress);
  End;

  Function TghObjList.Call <TResult> (Const AClass :TClass;
    Const AMethodAddress :Pointer) :TResult;
  Begin
    Result := Call <TResult> (0, Count - 1, AClass, AMethodAddress);
  End;

  Function TghObjList.Call <TResult> (Const AStartIndex :Integer;
    Const AMethodAddress :Pointer) :TResult;
  Begin
    Result := Call <TResult> (AStartIndex, Count - 1, Nil, AMethodAddress);
  End;

  Function TghObjList.Call <TResult> (Const AMethodAddress :Pointer)
    :TResult;
  Begin
    Result := Call <TResult> (0, Count - 1, Nil, AMethodAddress);
  End;

  Procedure TghObjList.Call <TParam> (
    Const AStartIndex, AEndIndex :Integer; Const AClass :TClass;
    Const AMethodAddress :Pointer; Const AParam :TParam);
  Begin
    Enum (AStartIndex, AEndIndex, AClass,
      Procedure (Const AObj :TObject; Var AContinue :Boolean)
      Begin
        AObj.ghCall <TParam> (AMethodAddress, AParam);
      End);
  End;

  Procedure TghObjList.Call <TParam> (Const AStartIndex :Integer;
    Const AClass :TClass; Const AMethodAddress :Pointer;
    Const AParam :TParam);
  Begin
    Call <TParam> (AStartIndex, Count - 1, AClass, AMethodAddress, AParam);
  End;

  Procedure TghObjList.Call <TParam> (
    Const AStartIndex, AEndIndex :Integer; Const AMethodAddress :Pointer;
    Const AParam :TParam);
  Begin
    Call <TParam> (AStartIndex, AEndIndex, Nil, AMethodAddress, AParam);
  End;

  Procedure TghObjList.Call <TParam> (Const AClass :TClass;
    Const AMethodAddress :Pointer; Const AParam :TParam);
  Begin
    Call <TParam> (0, Count - 1, AClass, AMethodAddress, AParam);
  End;

  Procedure TghObjList.Call <TParam> (Const AStartIndex :Integer;
    Const AMethodAddress :Pointer; Const AParam :TParam);
  Begin
    Call <TParam> (AStartIndex, Count - 1, Nil, AMethodAddress, AParam);
  End;

  Procedure TghObjList.Call <TParam> (Const AMethodAddress :Pointer;
    Const AParam :TParam);
  Begin
    Call <TParam> (0, Count - 1, Nil, AMethodAddress, AParam);
  End;

  Function TghObjList.Call <TParam, TResult> (
    Const AStartIndex, AEndIndex :Integer; Const AClass :TClass;
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Var
    LResult :TResult;
  Begin
    Enum (AStartIndex, AEndIndex, AClass,
      Procedure (Const AObj :TObject; Var AContinue :Boolean)
      Begin
        LResult := AObj.ghCall <TParam, TResult> (AMethodAddress, AParam);
      End);

    Result := LResult;  // Result of the last called method
  End;

  Function TghObjList.Call <TParam, TResult> (Const AStartIndex :Integer;
    Const AClass :TClass; Const AMethodAddress :Pointer;
    Const AParam :TParam) :TResult;
  Begin
    Result := Call <TParam, TResult> (
      AStartIndex, Count - 1, AClass, AMethodAddress, AParam);
  End;

  Function TghObjList.Call <TParam, TResult> (
    Const AStartIndex, AEndIndex :Integer;
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Begin
    Result := Call <TParam, TResult> (
      AStartIndex, AEndIndex, Nil, AMethodAddress, AParam);
  End;

  Function TghObjList.Call <TParam, TResult> (Const AClass :TClass;
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Begin
    Result := Call <TParam, TResult> (
      0, Count - 1, AClass, AMethodAddress, AParam);
  End;

  Function TghObjList.Call <TParam, TResult> (Const AStartIndex :Integer;
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Begin
    Result := Call <TParam, TResult> (AStartIndex, Count - 1, Nil,
      AMethodAddress, AParam);
  End;

  Function TghObjList.Call <TParam, TResult> (
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Begin
    Result := Call <TParam, TResult> (
      0, Count - 1, Nil, AMethodAddress, AParam);
  End;

  Function TghObjList.Clone (Const AStartIndex :Integer;
    Const AClass :TClass) :TghObjList;
  Begin
    Result := Clone (AStartIndex, Count - 1, AClass);
  End;

  Function TghObjList.Clone (Const AClass :TClass) :TghObjList;
  Begin
    Result := Clone (0, Count - 1, AClass);
  End;

  Function TghObjList.Enum (Const AStartIndex, AEndIndex :Integer;
    Const AClass :TClass;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Var
    TempList :TghObjList;
  Begin
    { NOTE: We use a temporary list (snapshot of specific sublist) because
      AProc could alter the content of the list. }
    TempList := TghObjList.Create (System.False);

    Try
      If TempList.AddItems (Self, AStartIndex, AEndIndex, AClass) > 0 Then
      Begin
        If AuxLists = Nil Then
          AuxLists := TList.Create;

        AuxLists.Add (TempList);

        Try
          Result := InternalEnum (TempList, AProc);
        Finally
          AuxLists.Remove (TempList);
        End;
      End
      Else
        Result := Nil;
    Finally
      TempList.Free;
    End;
  End;

  Function TghObjList.Enum (Const AStartIndex :Integer;
    Const AClass :TClass;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    Result := Enum (AStartIndex, Count - 1, AClass, AProc);
  End;

  Function TghObjList.Enum (Const AStartIndex, AEndIndex :Integer;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    Result := Enum (AStartIndex, AEndIndex, Nil, AProc);
  End;

  Function TghObjList.Enum (Const AClass :TClass;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    Result := Enum (0, Count - 1, AClass, AProc);
  End;

  Function TghObjList.Enum (Const AStartIndex :Integer;
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    Result := Enum (AStartIndex, Count - 1, Nil, AProc);
  End;

  Function TghObjList.Enum (
    Const AProc :TghSys.TEnumerationProcRef <TObject>) :TObject;
  Begin
    Result := Enum (0, Count - 1, Nil, AProc);
  End;

  Function TghObjList.Remove (Const Index :Integer) :TObject;
  Begin
    Result := Items [Index];
    Delete (Index);
  End;

  { Public virtual instance methods }

  Function TghObjList.Clone (AStartIndex :Integer = 0;
    AEndIndex :Integer = System.MaxInt; AClass :TClass = Nil) :TghObjList;
  Begin
    Result := TghObjListClass (ClassType).Create (System.False);

    Try
      Result.AddItems (Self, AStartIndex, AEndIndex, AClass);
    Except
      Result.Free;
      Raise;
    End;
  End;

End.

