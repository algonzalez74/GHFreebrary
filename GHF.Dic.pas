///Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Dic.pas - TghDic class unit.                                        }
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

Unit GHF.Dic;  { Dictionary }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    System.Generics.Collections, System.Generics.Defaults, GHF.Sys,
    GHF.List, GHF.Obs, GHF.CustomEnumerator;

  Type
    ///problema ya no presente en XE7, refactorizar
    { NOTE: We avoid using generic object parameters with default value in
      methods of generic classes, because these cause Internal Error
      URW1154 when those classes are referenced from another unit (quality
      report #129713). }

    ///prefijo A en parámetros
    ///agregar seguridad para hilos
    ///con propiedad para llamar a SetCapacity o TrimExcess tras eliminar según proporción Count-Capacity
    { Dictionary class }
    TghDic <TKey, TValue> = Class (TDictionary <TKey, TValue>)
      Private
        Class Constructor Create;
      Protected
        Type
          PKey = ^TKey;
          PValue = ^TValue;

          TKeyComparer = Class (TInterfacedObject,
            IEqualityComparer <TKey>)
            Protected
              { Instance fields }
              Dic :TghDic <TKey, TValue>;
              Internal :IEqualityComparer <TKey>;
              VerifyingAbsentKey :Boolean;

              { IEqualityComparer }
              Function Equals (Const Left, Right :TKey) :Boolean;
                Reintroduce; Overload;
              Function GetHashCode (Const Value :TKey) :Integer;
                Reintroduce; Overload;
            Public
              Constructor Create (Const ADic :TghDic <TKey, TValue>;
                Const AInternal :IEqualityComparer <TKey>);
          End;

        Class Var
          ValidOwnerships :TDictionaryOwnerships;

        Var
          AbsentKeysVerify :Boolean;
          FeedValuesDirect :Boolean;
          FFeedValues :TghList <Pointer>;
          FKeyObserver :IghObserver;
          FOwnerships :TDictionaryOwnerships;

        { Regular instance methods }
        Function AllValuesMoveNext :Boolean;
        Procedure DoAddNew (Const HashCode, AIndex :Integer;
          Const Key :TKey);
        Function GetFeedValues :TghList <Pointer>;///Inline;
        Function GetKeyObserver :IghObserver;///Inline;
        Function GetObserveKeys :Boolean;///Inline;
        Function Index (Const Key :TKey) :Integer;///Inline;
        Function IndexFor (Const Key :TKey; Out HashCode :Integer)
          :Integer;
        Function InternalValue (Const AKey :TKey;
          Const AForce :Boolean = System.False) :PValue;
        Function KeyObjsOwned :Boolean; ///Inline;
        Procedure NewValue (Out Value :TValue);
        Function RawIndexValue (Const AIndex :Integer) :TValue; Inline;
        Procedure SetObserveKeys (Const Value :Boolean);
        Procedure SetOwnerships (Const Value :TDictionaryOwnerships);
        Function ValueObjsOwned :Boolean;///Inline;

        { Virtual instance methods }
        Procedure AddFeedValue (Const Value :Pointer; Const Key :TKey);
          Virtual;
        Procedure FeedValuesNotify (Sender :TObject; Const Item :Pointer;
          Action :TCollectionNotification); Virtual;
        Procedure HandleAbsentKey (Const Key :TKey); Virtual;
        Procedure InitValue (Var Value :TValue; Const Key :TKey); Virtual;
        Procedure KeyObjNotify (Const Obj :TObject;
          Const Action :TCollectionNotification); Virtual;
        Procedure KeyObsEvent (Const ASender :IghObserver; AObj :TObject;
          AEventID :Integer); Virtual;
        Procedure OwnedKeyDeleted (Const Value :TKey); Virtual;
        Procedure OwnedValueDeleted (Const Value :TValue); Virtual;
        Function VerifyFeedValue (Const Value :Pointer; Const Key :TKey;
          Var AContinue :Boolean) :Boolean; Virtual;

        { Overridden instance methods }
        Procedure KeyNotify (Const Key :TKey;
          Action :TCollectionNotification); Override;
        Procedure ValueNotify (Const Value :TValue;
          Action :TCollectionNotification); Override;

        { Instance properties }
        Property KeyObserver :IghObserver Read GetKeyObserver;
      Public
        Type
          TAllValues = Class (TghCustomEnumerator <TValue>)
            Protected
              { Instance fields }
              RawIndex :Integer;

              { Regular instance methods }
              Function Dic :TghDic <TKey, TValue>; Inline;

              { Overridden instance methods }
              Function GetCount :Integer; Override;
              Function InternalGetCurrentT :TValue; Override;
            Public
              Constructor Create (ASubject :TObject); Override;

              { Overridden instance methods }
              Function MoveNext: Boolean; Override;
              Procedure Reset; Override;
          End;

        Constructor Create (Const AOwnerships :TDictionaryOwnerships);
          Overload; Virtual;
        Destructor Destroy; Override;

        { Regular instance methods }
        Function Add (Const Key :TKey) :TValue; Overload;
        Function EnsureValue (Const Key :TKey) :TValue;
        Procedure Remove (Const Key :TKey;
          Const Notif :TghSys.TGenericListRemoveNotif); Overload;///Inline;

        { Virtual instance methods }
        ///revisar si conviene con Info como TghList <T>.CreateItem
        Procedure CreateValue (Out Value :TValue; Const Key :TKey);
          Virtual;

        { Overridden instance methods }
        Procedure AfterConstruction; Override;

        Property FeedValues :TghList <Pointer> Read GetFeedValues;
        Property ObserveKeys :Boolean Read GetObserveKeys
          Write SetObserveKeys;
        Property Ownerships :TDictionaryOwnerships Read FOwnerships
          Write SetOwnerships;
      Protected
        { Instance fields }
        FAllValues :TAllValues;

        { Regular instance methods }
        Function GetAllValues :TAllValues;///Inline;
      Public
        { Instance properties }
        Property AllValues :TAllValues Read GetAllValues;
    End;

Implementation

  Uses
    GHF.RTTI, System.TypInfo, System.Math, System.SysUtils,
    GHF.SysEx, GHF.Observer;

  { Inline methods }

  Function TghDic <TKey, TValue>.RawIndexValue (Const AIndex :Integer)
    :TValue;
  Begin
    { NOTE: The compiler has problems to expose the private types TItem and
      TItemArray of TDictionary in others units, despite that private
      fields are accessible in derived generic classes. }
    Result := FItems [AIndex].Value;
  End;

  Function TghDic <TKey, TValue>.TAllValues.Dic :TghDic <TKey, TValue>;
  Begin
    Result := TghDic <TKey, TValue> (Subject);
  End;

  { TghDic <TKey, TValue> }

  Class Constructor TghDic <TKey, TValue>.Create;
  Begin
    If TghRTTI.Info <TKey>.ghIsClassOrPtr Then
      // Keys are destructible objects or releasable pointers
      ValidOwnerships := [System.Generics.Collections.doOwnsKeys];

    If TghRTTI.Info <TValue>.ghIsClassOrPtr Then
      // Values are destructible objects or releasable pointers
      Include (ValidOwnerships, System.Generics.Collections.doOwnsValues);
  End;

  Constructor TghDic <TKey, TValue>.Create (
    Const AOwnerships :TDictionaryOwnerships);
  Begin
    Create;
    Ownerships := AOwnerships;
  End;

  Destructor TghDic <TKey, TValue>.Destroy;
  Begin
    {}//resolver para mover a BeforeDestruction (como en demás clases)
    { NOTE: In this case it is better to call the inherited destructor
      before the ghPreDestroy method, since the owned object-values are
      not observed by the dictionary. }
    Inherited Destroy;
    ghPreDestroy;
  End;

  Function TghDic <TKey, TValue>.Add (Const Key :TKey) :TValue;
  Begin
    CreateValue (Result, Key);
    Add (Key, Result);
  End;

  Procedure TghDic <TKey, TValue>.AddFeedValue (Const Value :Pointer;
    Const Key :TKey);
  Begin
    If FeedValuesDirect Then
      Add (Key, TghSys.RawCast <Pointer, TValue> (Value));
  End;

  Procedure TghDic <TKey, TValue>.AfterConstruction;
  Begin
    Inherited AfterConstruction;

    { We wrap the key comparer object in order to add new entries from
      FeedValues when necessary.  NOTE: FComparer is a private field in the
      parent class, which is in another unit, but the compiler allows to do
      this in generic classes (quality report #80948). }
    FComparer := TKeyComparer.Create (Self, FComparer);

    FeedValuesDirect := System.True;
  End;

  Function TghDic <TKey, TValue>.AllValuesMoveNext :Boolean;
  Var
    RawLength :Integer;
  Begin
    { NOTE: This method does the work of TAllValues.MoveNext.  The
      inherited private field FItems is not accesible there. }

    RawLength := Length (FItems);

    While FAllValues.RawIndex < RawLength - 1 Do
      If FItems [TghSys.Inc (FAllValues.RawIndex)].HashCode <>
      -1 { EMPTY_HASH } Then
      Begin
        Inc (FAllValues.FIndex);
        System.Exit (System.True);
      End;

    Result := (FFeedValues <> Nil) And FeedValuesDirect And
      (FAllValues.FIndex - Count < FFeedValues.Count - 1);

    If Result Then
      Inc (FAllValues.FIndex);
  End;

  Procedure TghDic <TKey, TValue>.CreateValue (Out Value :TValue;
    Const Key :TKey);
  Begin
    { NOTE: Descendant classes can override this method to create object
      instances as usual, if values of the dictionary are owned objects. }

    { We create and initialize a new value (object instance, allocated
      pointer or simple data) }

    NewValue (Value);

    Try
      InitValue (Value, Key);
    Except
      If System.Generics.Collections.doOwnsValues In Ownerships Then
        TghRTTI.Info <TValue>.ghFreeValue (Value);

      Raise;
    End;
  End;

  Procedure TghDic <TKey, TValue>.DoAddNew (
    Const HashCode, AIndex :Integer; Const Key :TKey);
  Var
    Value :TValue;
  Begin
    CreateValue (Value, Key);
    DoAdd (HashCode, AIndex, Key, Value);
  End;

  Function TghDic <TKey, TValue>.EnsureValue (Const Key :TKey) :TValue;
  Var
    LHashCode, LIndex :Integer;
  Begin
    If TghSys.SetInt (LIndex, IndexFor (Key, LHashCode)) < 0 Then
      DoAddNew (LHashCode, TghSys.Negate (LIndex), Key);

    Result := FItems [LIndex].Value;
  End;

  Procedure TghDic <TKey, TValue>.FeedValuesNotify (Sender :TObject;
    Const Item :Pointer; Action :TCollectionNotification);
  Begin
    If (Action = System.Generics.Collections.cnRemoved) And
    (System.Generics.Collections.doOwnsValues In Ownerships) And
    (FeedValuesDirect) And (Item <> Nil) Then
      OwnedValueDeleted (TghSys.RawCast <Pointer, TValue> (Item));

    If FFeedValues <> Nil Then  // If Self is not destroying
      AbsentKeysVerify := FFeedValues.Count > 0;
  End;

  Function TghDic <TKey, TValue>.GetAllValues :TAllValues;
  Begin
    If FAllValues = Nil then
      ghHoldSet (FAllValues, TAllValues.Create (Self));

    Result := FAllValues;
  End;

  Function TghDic <TKey, TValue>.GetFeedValues :TghList <Pointer>;
  Begin
    If FFeedValues = Nil Then
      ghHoldSet (FFeedValues, TghList <Pointer>.Create (FeedValuesNotify));

    Result := FFeedValues;
  End;

  Function TghDic <TKey, TValue>.GetKeyObserver :IghObserver;
  Begin
    If Not ObserveKeys Then
      EInvalidOpException.ghRaise (TghSys.ermNotAvailable, ['Observer']);

    Result := FKeyObserver;
  End;

  Function TghDic <TKey, TValue>.GetObserveKeys :Boolean;
  Begin
    Result := FKeyObserver <> Nil;
  End;

  Procedure TghDic <TKey, TValue>.HandleAbsentKey (Const Key :TKey);
  Begin
    FFeedValues.Extract <TKey> (Key, VerifyFeedValue, AddFeedValue);
  End;

  Function TghDic <TKey, TValue>.Index (Const Key :TKey) :Integer;
  Begin
    { NOTE: The value returned by this method could be invalidated if the
      dictionary adds or removes items, changes its capacity or calls
      Rehash method. }

    If Count > 0 Then
      Result := GetBucketIndex (Key, Hash (Key))
    Else
      Result := -1;
  End;

  Function TghDic <TKey, TValue>.IndexFor (Const Key :TKey;
    Out HashCode :Integer) :Integer;
  Begin
    If Count >= FGrowThreshold Then
      Grow;

    HashCode := Hash (Key);
    Result := GetBucketIndex (Key, HashCode);
  End;

  Procedure TghDic <TKey, TValue>.InitValue (Var Value :TValue;
    Const Key :TKey);
  Begin
    { NOTE: Descendant classes can override this method to call some
      particular constructor of TValue, if Value is an owned object. See
      DoAddNew and CreateValue methods. }

    If ValueObjsOwned Then
      PObject (@Value).ghConstruct;
  End;

  Function TghDic <TKey, TValue>.InternalValue (Const AKey :TKey;
    Const AForce :Boolean = System.False) :PValue;
  Var
    LHashCode, LIndex :Integer;
  Begin
    { NOTE: The pointer returned by this method could be invalidated if the
      dictionary adds or removes items, changes its capacity or calls
      Rehash method. }

    If AForce Then
      If TghSys.SetInt (LIndex, IndexFor (AKey, LHashCode)) < 0 Then
        DoAddNew (LHashCode, TghSys.Negate (LIndex), AKey)
      Else
    Else
      If TghSys.SetInt (LIndex, Index (AKey)) < 0 Then
        System.Exit (Nil);

    Result := @FItems [LIndex].Value;
  End;

  Procedure TghDic <TKey, TValue>.KeyNotify (Const Key :TKey;
    Action :TCollectionNotification);
  Var
    AKey :Pointer Absolute Key;
  Begin
    Inherited KeyNotify (Key, Action);

    If (TghRTTI.Info <TKey>.Kind = System.tkClass) And (AKey <> Nil) Then
      KeyObjNotify (AKey, Action);

    If (Action = System.Generics.Collections.cnRemoved) And
    (System.Generics.Collections.doOwnsKeys In Ownerships) And
    (AKey <> Nil) Then
      OwnedKeyDeleted (Key);
  End;

  Procedure TghDic <TKey, TValue>.KeyObjNotify (Const Obj :TObject;
    Const Action :TCollectionNotification);
  Begin
    If ObserveKeys Then
      Obj.ghAttachOrDetachObserver (KeyObserver,
        Action = System.Generics.Collections.cnAdded);
  End;

  Function TghDic <TKey, TValue>.KeyObjsOwned :Boolean;
  Begin
    Result := (System.Generics.Collections.doOwnsKeys In Ownerships) And
      (TghRTTI.Info <TKey>.Kind = System.tkClass);
  End;

  Procedure TghDic <TKey, TValue>.KeyObsEvent (Const ASender :IghObserver;
    AObj :TObject; AEventID :Integer);
  Begin
    If TghSys.HasBitOn (AEventID, TghObs.oeiObjFree) Then
      Remove (TKey ((@AObj)^), System.Generics.Collections.cnExtracted);
  End;

  Procedure TghDic <TKey, TValue>.NewValue (Out Value :TValue);
  Begin
    If System.Generics.Collections.doOwnsValues In Ownerships Then
      TghRTTI.Info <TValue>.ghNewValue (Value)
    Else
      Value := System.Default (TValue);
  End;

  Procedure TghDic <TKey, TValue>.OwnedKeyDeleted (Const Value :TKey);
  Begin
    If (TghRTTI.Info <TKey>.Kind <> System.tkClass) Or
    Not PObject (@Value).ghRelatedDestroying Then
      TghRTTI.Info <TKey>.ghFreeValue (Value);
  End;

  Procedure TghDic <TKey, TValue>.OwnedValueDeleted (Const Value :TValue);
  Begin
    If (TghRTTI.Info <TValue>.Kind <> System.tkClass) Or
    Not PObject (@Value).ghRelatedDestroying Then
      TghRTTI.Info <TValue>.ghFreeValue (Value);
  End;

  Procedure TghDic <TKey, TValue>.Remove (Const Key :TKey;
    Const Notif :TghSys.TGenericListRemoveNotif);
  Begin
    { NOTE: DoRemove and Hash are private methods in the parent class,
      which is in another unit, but the compiler allows to do this in
      generic classes (quality report #80948). }
    DoRemove (Key, Hash (Key), Notif);
  End;

  Procedure TghDic <TKey, TValue>.SetObserveKeys (Const Value :Boolean);
  Begin
    If Value <> ObserveKeys Then
      If Not Value Then
        FKeyObserver := Nil
      Else
        If TghRTTI.Info <TKey>.Kind = System.tkClass Then
          FKeyObserver := TghObserver.Create (KeyObsEvent)
        Else
          EInvalidOpException.ghRaiseType <TKey> (
            TghSys.ermNotApplicableToType);
  End;

  Procedure TghDic <TKey, TValue>.SetOwnerships (
    Const Value :TDictionaryOwnerships);
  Begin
    If Value = FOwnerships Then
      System.Exit;

    If Value - ValidOwnerships <> [] Then
      Exception.ghRaise (TghSys.ermInvalidOwnership);

    FOwnerships := Value;
  End;

  Procedure TghDic <TKey, TValue>.ValueNotify (Const Value :TValue;
    Action :TCollectionNotification);
  Begin
    Inherited ValueNotify (Value, Action);

    If (Action = System.Generics.Collections.cnRemoved) And
    (System.Generics.Collections.doOwnsValues In Ownerships) And
    (PPointer (@Value)^ <> Nil) Then
      OwnedValueDeleted (Value);
  End;

  Function TghDic <TKey, TValue>.ValueObjsOwned :Boolean;
  Begin
    Result := (System.Generics.Collections.doOwnsValues In Ownerships) And
      (TghRTTI.Info <TValue>.Kind = System.tkClass);
  End;

  Function TghDic <TKey, TValue>.VerifyFeedValue (Const Value :Pointer;
    Const Key :TKey; Var AContinue :Boolean) :Boolean;
  Begin
    TghSys.Clear (Result, AContinue);
  End;

  { TghDic <TKey, TValue>.TAllValues }

  Constructor TghDic <TKey, TValue>.TAllValues.Create (ASubject :TObject);
  Begin
    Inherited Create (ASubject);
    RawIndex := -1;
  End;

  Function TghDic <TKey, TValue>.TAllValues.GetCount :Integer;
  Begin
    Result := Dic.Count;

    If (Dic.FFeedValues <> Nil) And Dic.FeedValuesDirect Then
      Inc (Result, Dic.FFeedValues.Count);
  End;

  Function TghDic <TKey, TValue>.TAllValues.InternalGetCurrentT :TValue;
  Begin
    If Index < Dic.Count Then
      Result := Dic.RawIndexValue (RawIndex)
    Else
      Result := TghSys.RawCast <Pointer, TValue> (
        Dic.FFeedValues [Index - Dic.Count]);
  End;

  Function TghDic <TKey, TValue>.TAllValues.MoveNext: Boolean;
  Begin
    // NOTE: The private field Dic.FItems is not accesible here.
    Result := Dic.AllValuesMoveNext;
  End;

  Procedure TghDic <TKey, TValue>.TAllValues.Reset;
  Begin
    Inherited Reset;
    RawIndex := -1;
  End;

  { TghDic <TKey, TValue>.TKeyComparer }

  Constructor TghDic <TKey, TValue>.TKeyComparer.Create (
    Const ADic :TghDic <TKey, TValue>;
    Const AInternal :IEqualityComparer <TKey>);
  Begin
    Dic := ADic;
    Internal := AInternal;
  End;

  Function TghDic <TKey, TValue>.TKeyComparer.Equals (
    Const Left, Right :TKey) :Boolean;
  Begin
    { NOTE: This resolves bug related to 3-byte keys (quality report
      RSP-9805). }
    If System.SizeOf (TKey) = 3 Then
      Result := System.SysUtils.CompareMem (@Left, @Right, 3)
    Else
      Result := Internal.Equals (Left, Right);
  End;

  Function TghDic <TKey, TValue>.TKeyComparer.GetHashCode (
    Const Value :TKey) :Integer;
  Begin
    If Dic.AbsentKeysVerify And Not VerifyingAbsentKey Then///que se permita recursión en esto
    Begin
      VerifyingAbsentKey := System.True;

      Try
        If Not Dic.ContainsKey (Value) Then
          Dic.HandleAbsentKey (Value);
      Finally
        VerifyingAbsentKey := System.False;
      End;
    End;

    { NOTE: This resolves bug related to 3-byte keys (quality report
      RSP-9805). }
    If System.SizeOf (TKey) = 3 Then
      Result := System.Generics.Defaults.BobJenkinsHash (Value, 3, 0)
    Else
      Result := Internal.GetHashCode (Value);
  End;

End.

