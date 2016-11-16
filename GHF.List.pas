{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.List.pas - TghList class unit.                                      }
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

Unit GHF.List;  { List }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Generics.Collections, System.TypInfo, GHF.Sys, GHF.Obs;

  Type
    {}//problema ya no presente en XE7, refactorizar
    { NOTE: We avoid using generic object parameters with default value in
      methods of generic classes, because these cause Internal Error
      URW1154 when those classes are referenced from another unit (quality
      report #129713). }

    {}//usar el nombre completo "TghList <T>" en comentarios y otros lugares (y lo mismo con otras clases)
    {}//prefijo A en parámetros
    {}//separar derivado TghObjList <T :Class> y reemplazar el uso de TghObjList clásica
    {}//agregar paralelismo en algunos métodos
    {}//agregar seguridad para hilos
    { List class }
    TghList <T> = Class (TList <T>)
      Protected
        Type
          PT = ^T;

        Var
          FItemObserver :IghObserver;
          FOwnsItems :Boolean;

        { Regular instance methods }
        Function GetItemObserver :IghObserver;{}//Inline;
        Function GetObserveItems :Boolean;{}//Inline;
        Function InternalReplaceItem (Const Index :Integer; Const Value :T)
          :T;
        Procedure NewItem (Out AItem :T; Const ATypeInfo :PTypeInfo = Nil);
        Function ObjsOwned :Boolean; {}//Inline;
        Procedure SetObserveItems (Const Value :Boolean);
        Procedure SetOwnsItems (Const Value :Boolean);

        { Virtual instance methods }
        Procedure InitItem (Var Item :T; Info :PTypeInfo = Nil); Virtual;
        Procedure ItemObsEvent (Const ASender :IghObserver; AObj :TObject;
          AEventID :Integer); Virtual;
        Procedure ObjNotify (Const Obj :TObject;
          Const Action :TCollectionNotification); Virtual;
        Procedure OwnedItemDeleted (Const Value :T); Virtual;

        { Overridden instance methods }
        Procedure Notify (Const Value :T; Action :TCollectionNotification);
          Override;

        { Instance properties }
        Property ItemObserver :IghObserver Read GetItemObserver;
      Public
        // Simple constructor to facilitate RTTI
        Constructor Create; Overload; Virtual;

        Constructor Create (Const AOnNotify :TCollectionNotifyEvent <T>);
          Overload; Virtual;
        Constructor Create (Const AOwnsItems :Boolean); Overload; Virtual;
        Constructor Create (Const Values :Array Of T); Overload; Virtual;

        { Regular instance methods }
        Function Add :T; Overload;{}//Inline;
        Function Add <AType> :AType; Overload;{}//Inline;
        Function AddIf (Const Value :T; Const Condition :Boolean)
          :Integer; Overload;
        Function AddIf (Const Value :T; Const Condition :Boolean;
          Const NotPassedList :TghList <T>) :Integer; Overload;
        Function AddTyped (Const Info :PTypeInfo) :T;{}//Inline;
        Procedure CreateItem (Out Item :T); Overload;{}//Inline;
        Procedure DeleteAfter (Const Value :T); Inline;
        Procedure DeleteFrom (Const Value :T); Inline;
        Procedure DeleteLast; Inline;
        Procedure Extract <TParam> (Const Index :Integer;
          Const TakingProc :TghSys.TProcessValueProcRef <T, TParam>;
          Const TakingParam :TParam); Overload;
        Function Extract <TParam> (Const Param :TParam;
          Const VerifyFunc :TghSys.TVerifyValueContinueFuncRef <T, TParam>;
          Const TakingProc :TghSys.TProcessValueProcRef <T, TParam>)
          :Integer; Overload;
        Function ExtractItem (Const Index :Integer) :T; Overload; Inline;
        Function InternalValue (Const Index :Integer) :PT;
        Procedure Lock;
        Procedure Remove (Const Value :T;
          Const Notif :TghSys.TGenericListRemoveNotif); Overload;{}//Inline;
        Function ReplaceItem (Const Index :Integer; Const Value :T) :T;
        Procedure Unlock;

        { Virtual instance methods }
        Procedure CreateItem (Out AItem :T; AInfo :PTypeInfo); Overload;
          Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;

        { Instance properties }
        Property ObserveItems :Boolean Read GetObserveItems
          Write SetObserveItems;
        Property OwnsItems :Boolean Read FOwnsItems Write SetOwnsItems;
    End;

Implementation

  Uses
    GHF.RTTI, System.SysUtils, GHF.SysEx, GHF.Observer;

  {}//reordenar métodos alfabéticamente (en todas las secciones Implementation)

  { TghList <T> }

  { Inline methods }

  Procedure TghList <T>.DeleteAfter (Const Value :T);
  Var
    I :Integer;
  Begin
    I := IndexOf (Value);

    If I > -1 Then
      Count := I + 1;
  End;

  Procedure TghList <T>.DeleteFrom (Const Value :T);
  Var
    I :Integer;
  Begin
    I := IndexOf (Value);

    If I > -1 Then
      Count := I;
  End;

  Procedure TghList <T>.DeleteLast;
  Begin
    If Count > 0 Then
      Delete (Count - 1);
  End;

  Function TghList <T>.ExtractItem (Const Index :Integer) :T;
  Begin
    Result := Items [Index];

    { NOTE: DoDelete is a private method in the parent class, which is in
      another unit, but the compiler allows to do this in generic classes
      (quality report #80948). }
    DoDelete (Index, System.Generics.Collections.cnExtracted);
  End;

  { Constructors and destructors }

  Constructor TghList <T>.Create;
  Begin
    Inherited Create;
  End;

  Constructor TghList <T>.Create (
    Const AOnNotify :TCollectionNotifyEvent <T>);
  Begin
    Inherited Create;
    OnNotify := AOnNotify;
  End;

  Constructor TghList <T>.Create (Const AOwnsItems :Boolean);
  Begin
    Inherited Create;
    OwnsItems := AOwnsItems;
  End;

  Constructor TghList <T>.Create (Const Values :Array Of T);
  Begin
    Inherited Create;
    AddRange (Values);
  End;

  { Protected regular instance methods }

  Function TghList <T>.GetItemObserver :IghObserver;
  Begin
    If Not ObserveItems Then
      EInvalidOpException.ghRaise (TghSys.ermNotAvailable, ['Observer']);

    Result := FItemObserver;
  End;

  Function TghList <T>.GetObserveItems :Boolean;
  Begin
    Result := FItemObserver <> Nil;
  End;

  Function TghList <T>.InternalReplaceItem (Const Index :Integer;
    Const Value :T) :T;
  Begin
    Result := Items [Index];
    FItems [Index] := Value;
  End;

  Procedure TghList <T>.NewItem (Out AItem :T;
    Const ATypeInfo :PTypeInfo = Nil);
  Begin
    If OwnsItems Then
      If ATypeInfo <> Nil Then
        TghRTTI.Info <T>.ghCheckClassPtrAssignmentCompat (
          ATypeInfo).ghNewValue (AItem)
      Else
        TghRTTI.Info <T>.ghNewValue (AItem)
    Else
      AItem := System.Default (T);
  End;

  Function TghList <T>.ObjsOwned :Boolean;
  Begin
    Result := OwnsItems And (TghRTTI.Info <T>.Kind = System.tkClass);
  End;

  Procedure TghList <T>.SetObserveItems (Const Value :Boolean);
  Begin
    If Value <> ObserveItems Then
      If Not Value Then
        FItemObserver := Nil
      Else
        If TghRTTI.Info <T>.Kind = System.tkClass Then
          FItemObserver := TghObserver.Create (ItemObsEvent)
        Else
          EInvalidOpException.ghRaise (
            TghSys.ermNotApplicableToType, [TghRTTI.Info <T>.Name]);
  End;

  Procedure TghList <T>.SetOwnsItems (Const Value :Boolean);
  Begin
    If Value <> FOwnsItems Then
      If Value And Not TghRTTI.Info <T>.ghIsClassOrPtr Then
        EInvalidOpException.ghRaise (TghSys.ermInvalidOwnership)
      Else
        FOwnsItems := Value;
  End;

  { Protected virtual instance methods }

  Procedure TghList <T>.InitItem (Var Item :T; Info :PTypeInfo = Nil);
  Begin
    { NOTE: Descendant classes can override this method to call some
      particular constructor of T, if Item is an owned object. See Add and
      CreateItem methods. }

    If ObjsOwned Then
      PObject (@Item).ghConstruct;
  End;

  Procedure TghList <T>.ItemObsEvent (Const ASender :IghObserver;
    AObj :TObject; AEventID :Integer);
  Begin
    If TghSys.HasBitOn (AEventID, TghObs.oeiObjChanges) Then
      ghNotify (AEventID)
    Else
      If TghSys.HasBitOn (AEventID, TghObs.oeiObjFree) Then
        Remove (T ((@AObj)^), System.Generics.Collections.cnExtracted);
  End;

  Procedure TghList <T>.ObjNotify (Const Obj :TObject;
    Const Action :TCollectionNotification);
  Begin
    If ObserveItems Then
      Obj.ghAttachOrDetachObserver (ItemObserver,
        Action = System.Generics.Collections.cnAdded);
  End;

  Procedure TghList <T>.OwnedItemDeleted (Const Value :T);
  Var
    LInfo :PTypeInfo;
  Begin
    LInfo := TghRTTI.Info <T>;

    If (LInfo.Kind <> System.tkClass) Or
    Not PObject (@Value)^.ghRelatedDestroying Then
      LInfo.ghFreeValue (Value);
  End;

  { Protected overridden instance methods }

  Procedure TghList <T>.Notify (Const Value :T;
    Action :TCollectionNotification);
  Var
    AValue :Pointer Absolute Value;
  Begin
    Inherited Notify (Value, Action);

    If (TghRTTI.Info <T>.Kind = System.tkClass) And (AValue <> Nil) Then
      ObjNotify (AValue, Action);

    If OwnsItems And (Action = System.Generics.Collections.cnRemoved) And
    (AValue <> Nil) Then
      OwnedItemDeleted (Value);

    ghNotifyChanged;
  End;

  { Public regular instance methods }

  Function TghList <T>.Add :T;
  Begin
    Result := Add <T>;
  End;

  Function TghList <T>.Add <AType> :AType;
  Begin
    T ((@Result)^) := AddTyped (TypeInfo (AType));
  End;

  Function TghList <T>.AddIf (Const Value :T; Const Condition :Boolean)
    :Integer;
  Begin
    If Condition Then
      Result := Add (Value)
    Else
      Result := -1;
  End;

  Function TghList <T>.AddIf (Const Value :T; Const Condition :Boolean;
    Const NotPassedList :TghList <T>) :Integer;
  Begin
    Result := AddIf (Value, Condition);

    If Result = -1 Then
      NotPassedList.Add (Value);
  End;

  Function TghList <T>.AddTyped (Const Info :PTypeInfo) :T;
  Begin
    CreateItem (Result, Info);
    Add (Result);
  End;

  Procedure TghList <T>.CreateItem (Out Item :T);
  Begin
    CreateItem (Item, TypeInfo (T));
  End;

  Procedure TghList <T>.Extract <TParam> (Const Index :Integer;
    Const TakingProc :TghSys.TProcessValueProcRef <T, TParam>;
    Const TakingParam :TParam);
  Begin
    If Assigned (TakingProc) Then
      TakingProc (Items [Index], TakingParam);

    { NOTE: DoDelete is a private method in the parent class, which is in
      another unit, but the compiler allows to do this in generic classes
      (quality report #80948). }
    DoDelete (Index, System.Generics.Collections.cnExtracted);
  End;

  Function TghList <T>.Extract <TParam> (Const Param :TParam;
    Const VerifyFunc :TghSys.TVerifyValueContinueFuncRef <T, TParam>;
    Const TakingProc :TghSys.TProcessValueProcRef <T, TParam>) :Integer;
  Var
    AContinue :Boolean;
    I :Integer;
  Begin
    { NOTE: Do not use this method if VerifyFunc or TakingProc can alter
      the list content. }

    TghSys.Clear (Result, I);
    AContinue := System.True;

    While (I < Count) And AContinue Do
      If TghSys.IncSelected (
      I, Result, VerifyFunc (Items [I], Param, AContinue)) Then
        Extract <TParam> (I, TakingProc, Param);
  End;

  Function TghList <T>.InternalValue (Const Index :Integer) :PT;
  Begin
    If TghSys.IsIndex (Index, Count) Then
      Result := @FItems [Index]
    Else
      Result := Nil;
  End;

  Procedure TghList <T>.Lock;
  Begin
    { NOTE: FArrayManager is a private field in the parent class, which is
      in another unit, but the compiler allows to do this in generic
      classes (quality report #80948). }
    TMonitor.Enter (FArrayManager);
  End;

  Procedure TghList <T>.Remove (Const Value :T;
    Const Notif :TghSys.TGenericListRemoveNotif);
  Var
    I :Integer;
  Begin
    If TghSys.SetInt (I, IndexOf (Value)) > -1 Then
      { NOTE: DoDelete is a private method in the parent class, which is in
        another unit, but the compiler allows to do this in generic classes
        (quality report #80948). }
      DoDelete (I, Notif);
  End;

  Function TghList <T>.ReplaceItem (Const Index :Integer; Const Value :T)
    :T;
  Begin
    Result := InternalReplaceItem (Index, Value);
    Notify (Result, System.Generics.Collections.cnExtracted);
    Notify (Value, System.Generics.Collections.cnAdded);
  End;

  Procedure TghList <T>.Unlock;
  Begin
    { NOTE: FArrayManager is a private field in the parent class, which is
      in another unit, but the compiler allows to do this in generic
      classes (quality report #80948). }
    TMonitor.Exit (FArrayManager);
  End;

  { Public virtual instance methods }

  Procedure TghList <T>.CreateItem (Out AItem :T; AInfo :PTypeInfo);
  Begin
    { NOTE: Descendant classes can override this method to create object
      instances as usual, if items of the list are owned objects. }

    { We create and initialize a new item (object instance, allocated
      pointer or simple data) }

    NewItem (AItem, AInfo);

    Try
      InitItem (AItem, AInfo);
    Except
      If OwnsItems Then
        TghRTTI.Info <T>.ghFreeValue (AItem);

      Raise;
    End;
  End;

  { Public overridden instance methods }

  Procedure TghList <T>.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

End.

