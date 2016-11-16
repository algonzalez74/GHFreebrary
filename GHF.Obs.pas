{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Obs.pas - TghObs class unit.                                        }
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

Unit GHF.Obs;  { Observation }

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
    { Observer interface }
    IghObserver = Interface
    ['{F3E6169C-FB1B-42D5-A204-B96E4E80FA2E}']
      { Methods }
      Procedure HandleEvent (AObj :TObject; AEventID :Integer);
    End;

    { Controlled Observer interface }
    IghControlledObserver = Interface (IghObserver)
    ['{52E7EC42-7925-49B1-A510-E7AFB2D157A3}']
      { Methods }
      Function GetEnabled :Boolean;
      Function GetEventIDs :Integer;
      Procedure SetEnabled (Value :Boolean);
      Procedure SetEventIDs (Value :Integer);

      { Instance properties }
      Property Enabled :Boolean Read GetEnabled Write SetEnabled;
      Property EventIDs :Integer Read GetEventIDs Write SetEventIDs;
    End;

    {}//seguridad para hilos con TMonitor y posibles listas separadas por hilo
    { Observation class. NOTE: TghObs is partial and is complemented by the
      TghObsEx class helper in the GHF.ObsEx unit. Any part of this class
      may eventually be moved to that helper (without affecting the code
      that uses it); consider adding both units to the Uses clauses of your
      projects when one of them is needed. }
    TghObs = Class (TghZeroton)
      Private
        Class Destructor Destroy;
      Protected
        Const
          { Item flags }
          itfMultiRel     = $0100;  // Has multiple relations
          itfNotifyEvents = $0200;  // Notifies events (used for objects)
          itfDestroying   = $0400;  // Is destroying (used for objects)
          itfFinishingRel = $0800;  // Item is finishing a relation
          itfAll          = $FF00;

          { Relationships between items }
          rlsNone                 = $00;  // XXX-Nil
          rlsObjHoldsObj          = $01;  // TObject-TObject
          rlsObjHeldByObj         = $02;  // TObject-TObject
          rlsObjHoldsPObj         = $03;  // TObject-PObject
          rlsPObjHeldByObj        = $04;  // PObject-TObject
          rlsObjHoldsPIntf        = $05;  // TObject-PInterface
          rlsPIntfHeldByObj       = $06;  // PInterface-TObject
          rlsPObjReferencesObj    = $07;  // PObject-TObject
          rlsObjReferencedByPObj  = $08;  // TObject-PObject
          rlsPIntfReferencesObj   = $09;  // PInterface-TObject
          rlsObjReferencedByPIntf = $0A;  // TObject-PInterface
          rlsIntfObservesObj      = $0B;  // IghObserver-TObject
          rlsObjObservedByIntf    = $0C;  // TObject-IghObserver
          rlsObjIsObserverIntf    = $0D;  // TObject-IghObserver
          rlsObserverIntfIsObj    = $0E;  // IghObserver-TObject
          rlsMask                 = $FF;

        Type
          PRelatedItem = ^TRelatedItem;

          { Relationship type }
          TRelationship = rlsNone..rlsObserverIntfIsObj;

          { Relationship type extended helper }
          TRelationshipEx = Record Helper For TRelationship
            Public
              { Regular instance methods }
              Function Inverse :TRelationship;
          End;

          { Item information type }
          PItemInfo = ^TItemInfo;
          TItemInfo = Packed Record
            Type
              { Flags type }
              TFlag = Word;

              { Flags type }
              TFlags = Word;

            { Regular instance methods }
            Function AddRelated (Const AValue :Pointer;
              Const ARelationship :TRelationship) :Boolean;
            Function AddSlot :Integer;
            Function CheckDup (Const AItem :PRelatedItem;
              Const ARelatedValue :Pointer;
              Const ARelationship :TRelationship) :Boolean;
            Procedure ClearFlag (Const AValue :TFlag);
            Function ClearRelated (Const AItem :PRelatedItem) :Pointer;
            Function DeleteRelated (Const AValue :Pointer;
              Const ARelationship :TRelationship) :Pointer;
            Procedure Finalize;
            Function GetFlags :TFlags;
            Function GetRelated (Const ARelationship :TRelationship;
              Var APrevIndex :Integer; Out AItem :PRelatedItem) :Boolean;
            Function GetRelationship :TRelationship;
            Procedure InternalAdd (Const ARelatedValue :Pointer;
              Const ARelationship :TRelationship);
            Procedure MakeRelArr;
            Function RelatedItem (Const AIndex :Integer) :PRelatedItem;
              Overload;
            Function RelatedItem (Const ARelationship :TRelationship)
              :PRelatedItem; Overload;
            Function RelatedItemCount :Integer;
            Function RelSlot :Integer;
            Function SetFlag (Const AValue :TFlag) :Boolean;

            { Instance properties }
            Property Flags :TFlags Read GetFlags;
            Property Relationship :TRelationship Read GetRelationship;

            { NOTE: The offset, size and semantics of the two first fields
              (FRelatedItem/RelatedItems and FlagsRelationship/FFlags) must
              be consistent with TRelatedItem. }
            Case Word Of
              0          : (
                FRelatedItem :Pointer;  // Single related item
                FlagsRelationship :Word;  // Flags and relationship
                RelCount :Word);  // Actual relation count

              itfMultiRel : (
                RelatedItems :Pointer;  // TArray <TRelatedItem>
                FFlags :TFlags);  // itfXXX including itfMultiRel
          End;

          { Related item type }
          TRelatedItem = Packed Record
            { NOTE: This little struct must be consistent with the
              first fields of TItemInfo. }
            Value :Pointer;
            FRelationship :Word;  // TRelationship aligned to two bytes

            { Regular instance methods }
            Function ClearIntf :Boolean;
            Function ClearValue :Pointer;
            Function GetRelationship :TRelationship;
            Procedure SetValue (Const AValue :Pointer;
              Const ARelationship :TRelationship);

            { Instance properties }
            Property Relationship :TRelationship Read GetRelationship;
          End;

          { Relationships type }
          TRelationships = Set Of TRelationship;

        Const
          { Relationships between items }

          // All valid relationships set
          rlsAllValid = [rlsNone + 1..High (TRelationship)];

          // Combinable relationships sets
          rlsCombinable :Array [0..5] Of TRelationships = (
            [rlsObjHoldsPObj, rlsObjReferencedByPObj],
            [rlsPObjHeldByObj, rlsPObjReferencesObj],
            [rlsObjHoldsPIntf, rlsObjReferencedByPIntf],
            [rlsPIntfHeldByObj, rlsPIntfReferencesObj],
            [rlsIntfObservesObj, rlsObserverIntfIsObj],
            [rlsObjObservedByIntf, rlsObjIsObserverIntf]);

          // Exclusive relationships set
          rlsExclusive = [rlsObjHeldByObj, rlsPObjHeldByObj,
            rlsPIntfHeldByObj, rlsPObjReferencesObj, rlsPIntfReferencesObj,
            rlsObserverIntfIsObj];

          // Interface value relationships set
          rlsInterfaceValue = [rlsObjObservedByIntf, rlsObjIsObserverIntf];

          // Observation relationships set
          rlsObs = [rlsIntfObservesObj, rlsObjObservedByIntf];

        Class Var
          Finalized :Boolean;

        { Static class methods }
        Class Function AddRel (Const AItem1, AItem2 :Pointer;
          Const ARelationship :TRelationship) :Boolean; Static;
        Class Function AddRelPair (Const AItem1, AItem2 :Pointer;
          Const ARelationship :TRelationship) :Boolean; Static;
        Class Function DeleteRel (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem) :Pointer;
          Overload; Static;
        Class Function DeleteRel (Const AItem1 :Pointer;
          Var AInfo :PItemInfo; Const AItem2 :Pointer;
          Const ARelationship :TRelationship) :Pointer; Overload; Static;
        Class Function DeleteRel (Const AItem1, AItem2 :Pointer;
          Const ARelationship :TRelationship) :Pointer; Overload; Static;
        Class Function DeleteRelPair (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem) :Pointer;
          Overload; Static;
        Class Function DeleteRelPair (Const AItem1, AItem2 :Pointer;
          Const ARelationship :TRelationship) :Pointer; Overload; Static;
        Class Procedure DeleteRels (Const AItem :Pointer;
          Var AInfo :PItemInfo); Static;
        Class Procedure FinishObjRels (Const AObj :TObject;
          Var AInfo :PItemInfo); Static;
        Class Procedure FinishRel (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure FinishRels (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARels :TRelationships = rlsAllValid);
          Static;
        Class Function GetItemInfo (Const AItem :Pointer;
          Var AInfo :PItemInfo) :Boolean; Static;
        Class Function HolderObjItem (Const AItem :Pointer) :PRelatedItem;
          Static;
        Class Procedure InternalNotify (Const AInfo :PItemInfo;
          AObj :TObject; Const AEventID :Integer); Static;
        Class Function ItemInfo (Const AItem :Pointer) :PItemInfo; Static;
        Class Procedure NotifyDetach (Const AObserver :IghObserver;
          Const AObj :TObject); Static;
        Class Procedure NotifyFree (Const AInfo :PItemInfo;
          Const AObj :TObject); Static;
        Class Procedure PreFinishIntfObservesObj (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishObjHoldsObj (Const AObj :TObject;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishObjHoldsPIntf (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishObjHoldsPObj (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishObjIsObserverIntf (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishPIntfReferencesObj (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishPObjReferencesObj (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Procedure PreFinishRel (Const AItem :Pointer;
          Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem); Static;
        Class Function PreFinishRelMethod (
          Const ARelationship :TRelationship)
          :TghSys.TConstVarConstProc <Pointer, PItemInfo, PRelatedItem>;
          Static;
        Class Procedure VerifyRelCount (Const AItem :Pointer;
          Var AInfo :PItemInfo); Static;
      Public
        Const
          { Observation event IDs. NOTE: The high word is reserved for GH
            Freebrary and the low word can be used to specify events
            defined by the application or derived libraries. Example:
            "ColorChangedEventID = TghObs.oeiObjChanged Or $0003;". }

          oeiAttach              = $00010000;
          oeiAllAttach           = $0001FFFF;
          oeiDetach              = $00020000;
          oeiAllDetach           = $0002FFFF;
          oeiEnabledChanged      = $00040000;
          oeiAllEnabledChanged   = $0004FFFF;
          oeiObjChanging         = $00080000;
          oeiAllObjChanging      = $0008FFFF;
          oeiObjChanged          = $00100000;
          oeiAllObjChanged       = $0010FFFF;
          oeiObjStateChanging    = $00200000;
          oeiAllObjStateChanging = $0020FFFF;
          oeiObjStateChanged     = $00400000;
          oeiAllObjStateChanged  = $0040FFFF;
          oeiObjPosChanging      = $00800000;
          oeiAllObjPosChanging   = $0080FFFF;
          oeiObjPosChanged       = $01000000;
          oeiAllObjPosChanged    = $0100FFFF;
          oeiObjBefore           = $02000000;
          oeiAllObjBefore        = $0200FFFF;
          oeiObjAfter            = $04000000;
          oeiAllObjAfter         = $0400FFFF;
          oeiObjFree             = $08000000;
          oeiAllObjFree          = $0800FFFF;

          // Masks
          oeiAll = $0FFFFFFF;  // All -- higher four bits for flags
          oeiObjChanges = oeiObjChanging Or oeiObjChanged;

        Type
          { Observation event type }
          TObsEvent = Procedure (Const ASender :IghObserver; AObj :TObject;
            AEventID :Integer) Of Object;

          { Observation event reference type }
          TObsEventRef = Reference To Procedure (
            Const ASender :IghObserver; AObj :TObject; AEventID :Integer);

        { Static class methods }
        Class Procedure Attach (Const AObj :TObject;
          Const AObserver :IghObserver); Overload; Static;
        Class Procedure ClearIntfRef (Var ARef); Static;
        Class Procedure ClearObjRef (Var ARef); Static;
        Class Procedure Detach (Const AObj :TObject;
          Const AObserver :IghObserver); Static;
        Class Procedure DisableNotif (Const AObj :TObject); Static;
        Class Procedure EnableNotif (Const AObj :TObject); Static;
        Class Function Hold (Const AHolder, AObj :TObject) :TObject;
          Static;
        Class Function HolderOf (Const AObj :TObject) :TObject; Static;
        Class Procedure HoldIntfRef (Const AHolder :TObject; Const ARef);
          Static;
        Class Function HoldObjRef (Const AHolder :TObject; Const ARef)
          :TObject; Static;
        Class Function MakeObjRef (Const ARef) :TObject; Static;
        Class Procedure Notify (Const AObj :TObject;
          Const AEventID :Integer); Overload; Static;
        Class Procedure PreDestroy (Const AObj :TObject); Static;
        Class Function RelatedDestroying (Const AObj :TObject) :Boolean;
          Static;
        Class Function SetObjRef (Out ARef; Const AObj :TObject) :TObject;
          Static;
        Class Procedure UnHold (Const AObj :TObject); Static;
        Class Procedure UnmakeObjRef (Const ARef); Static;
    End;

Implementation

  Uses
    System.SysUtils, WinAPI.Windows, System.Generics.Collections, GHF.RTTI,
    GHF.SysEx, GHF.ObsEx;

  { TghObs }

  { TghObs.TItemInfo }

  {}//probar
  Function TghObs.TItemInfo.AddRelated (Const AValue :Pointer;
    Const ARelationship :TRelationship) :Boolean;
  Var
    I :Integer;
    LItem :PRelatedItem;
  Begin
    If AValue = Nil Then
      System.Exit (System.False);  // Nil related values are ignored

    For I := 0 To RelatedItemCount - 1 Do
    Begin
      LItem := RelatedItem (I);

      If CheckDup (LItem, AValue, ARelationship) Then
        System.Exit (System.False)  // Related item already registered
      Else
        If (LItem.Relationship = ARelationship) And
        (ARelationship In rlsExclusive) Then
          EInvalidOpException.ghRaise (
            TghSys.ermExclusiveRelationshipEstablished,
            ['observation item']);
    End;

    InternalAdd (AValue, ARelationship);
    Result := System.True;  // Related item was added
  End;

  Function TghObs.TItemInfo.AddSlot :Integer;
  Var
    LArr :TArray <TRelatedItem> Absolute RelatedItems;
  Begin
    Result := System.Length (LArr);
    System.SetLength (LArr, Result + 1);
  End;

  {}//probar
  {$Warn No_RetVal Off}
  Function TghObs.TItemInfo.CheckDup (Const AItem :PRelatedItem;
    Const ARelatedValue :Pointer; Const ARelationship :TRelationship)
    :Boolean;
  Var
    I :Integer;
    LRels :TRelationships;
  Begin
    If AItem.Value <> ARelatedValue Then
      System.Exit (System.False);

    If AItem.Relationship = ARelationship Then
      System.Exit (System.True)  // Observation value already registered
    Else
    Begin
      LRels := [AItem.Relationship, ARelationship];

      For I := 0 To System.High (rlsCombinable) Do
        If LRels = rlsCombinable [I] Then
          System.Exit (System.False);

      EInvalidOpException.ghRaise (
        TghSys.ermInvalidRelationship, ['observation items']);
    End;
  End;
  {$Warn No_RetVal On}

  Procedure TghObs.TItemInfo.ClearFlag (Const AValue :TFlag);
  Begin
    FFlags := TghSys.TurnBitsOff (FFlags, AValue);
  End;

  Function TghObs.TItemInfo.ClearRelated (Const AItem :PRelatedItem)
    :Pointer;
  Begin
    If AItem.Relationship = rlsNone Then
      System.Exit (Nil);

    Result := AItem.ClearValue;
    Dec (RelCount);
  End;

  Function TghObs.TItemInfo.DeleteRelated (Const AValue :Pointer;
    Const ARelationship :TRelationship) :Pointer;
  Var
    I :Integer;
    LItem :PRelatedItem;
  Begin
    For I := 0 To RelatedItemCount - 1 Do
    Begin
      LItem := RelatedItem (I);

      If (LItem.Relationship = ARelationship) And
      ((AValue = Nil) Or (LItem.Value = AValue)) Then
        System.Exit (ClearRelated (LItem));
    End;

    Result := Nil;
  End;

  Procedure TghObs.TItemInfo.Finalize;
  Var
    I :Integer;
  Begin
    If RelCount > 0 Then
      For I := 0 To RelatedItemCount - 1 Do
        RelatedItem (I).ClearIntf;

    If TghSys.HasBitOn (Flags, itfMultiRel) Then
      TArray <TRelatedItem> (RelatedItems) := Nil;
  End;

  Function TghObs.TItemInfo.GetFlags :TFlags;
  Begin
    Result := FlagsRelationship And itfAll;
  End;

  Function TghObs.TItemInfo.GetRelated (Const ARelationship :TRelationship;
    Var APrevIndex :Integer; Out AItem :PRelatedItem) :Boolean;
  Var
    LCount :Integer;
  Begin
    // Method to get the 'next' related item of ARelationship type

    LCount := RelatedItemCount;

    While APrevIndex < LCount - 1 Do
    Begin
      AItem := RelatedItem (TghSys.Inc (APrevIndex));

      If AItem.Relationship = ARelationship Then
        System.Exit (System.True);
    End;

    Result := System.False;
  End;

  Function TghObs.TItemInfo.GetRelationship :TRelationship;
  Begin
    Result := PRelatedItem (@Self).Relationship;
  End;

  Procedure TghObs.TItemInfo.InternalAdd (Const ARelatedValue :Pointer;
    Const ARelationship :TRelationship);
  Var
    I :Integer;
  Begin
    If FRelatedItem = Nil Then  // If AValue is the first one
      PRelatedItem (@Self).SetValue (ARelatedValue, ARelationship)
    Else  // For two o more, we use an array
    Begin
      If Not TghSys.SetIndex (I, RelSlot, 1) Then
        MakeRelArr;

      TArray <TRelatedItem> (RelatedItems) [I].SetValue (
        ARelatedValue, ARelationship);
    End;

    TghSys.CheckInc (RelCount);
  End;

  Procedure TghObs.TItemInfo.MakeRelArr;
  Var
    LArr :TArray <TRelatedItem> Absolute RelatedItems;
    LTemp :Pointer;
  Begin
    // We 'convert' the FRelatedItem field in the RelatedItems field
    TghSys.ShiftPtr (LTemp, FRelatedItem);
    SetLength (LArr, 2);
    LArr [0].SetValue (LTemp, Relationship);

    // We 'convert' the FlagsRelationship field in the FFlags field
    FFlags := TghSys.SwitchBits (FlagsRelationship, rlsMask, itfMultiRel);
  End;

  Function TghObs.TItemInfo.RelatedItem (Const AIndex :Integer)
    :PRelatedItem;
  Begin
    If TghSys.HasBitOn (Flags, itfMultiRel) Then
      Result := @TArray <TRelatedItem> (RelatedItems) [AIndex]
    Else
      Result := @Self;  // AIndex must be zero
  End;

  Function TghObs.TItemInfo.RelatedItem (
    Const ARelationship :TRelationship) :PRelatedItem;
  Var
    I :Integer;
  Begin
    For I := 0 To RelatedItemCount - 1 Do
      If PRelatedItem (TghSys.SetPtr (
      Result, RelatedItem (I))).Relationship = ARelationship Then
        System.Exit;

    Result := Nil;
  End;

  Function TghObs.TItemInfo.RelatedItemCount :Integer;
  Begin
    If TghSys.HasBitOn (Flags, itfMultiRel) Then
      Result := System.Length (TArray <TRelatedItem> (RelatedItems))
    Else
      Result := 1;
  End;

  Function TghObs.TItemInfo.RelSlot :Integer;
  Var
    LArr :TArray <TRelatedItem> Absolute RelatedItems;
    LCount :Integer;
  Begin
    If Not TghSys.HasBitOn (Flags, itfMultiRel) Then
      System.Exit (-1);

    LCount := System.Length (LArr);

    // Protection of relations that are being finished
    If TghSys.HasBitOn (Flags, itfFinishingRel) Then
      System.Exit (AddSlot);

    Result := 0;

    While LArr [Result].FRelationship <> rlsNone Do
      If TghSys.Inc (Result) = LCount Then
        System.Exit (AddSlot);
  End;

  Function TghObs.TItemInfo.SetFlag (Const AValue :TFlag) :Boolean;
  Begin
    Result := TghSys.SetBitOn (FFlags, AValue);
  End;

  { TghObs.TRelatedItem }

  Function TghObs.TRelatedItem.ClearIntf :Boolean;
  Begin
    If TghSys.SetBool (Result, Relationship In rlsInterfaceValue) Then
      IInterface (Value) := Nil;  // _IntfClear
  End;

  Function TghObs.TRelatedItem.ClearValue :Pointer;
  Begin
    Result := Value;

    If Not ClearIntf Then
      Value := Nil;

    FRelationship := TghSys.TurnBitsOff (FRelationship, rlsMask);
  End;

  Function TghObs.TRelatedItem.GetRelationship :TRelationship;
  Begin
    // NOTE: The instance could be a TItemInfo.
    Result := FRelationship And rlsMask;
  End;

  Procedure TghObs.TRelatedItem.SetValue (Const AValue :Pointer;
    Const ARelationship :TRelationship);
  Begin
    // NOTE: Value field must be Nil before this.
    If ARelationship In rlsInterfaceValue Then
      TghSys.SetIntf (Value, AValue)  // _IntfCopy
    Else
      Value := AValue;

    { NOTE: The low byte of FRelationship must be rlsNone before this. }
    FRelationship := FRelationship Or ARelationship;
  End;

  Function TghObs.TRelationshipEx.Inverse :TRelationship;
  Begin
    Result := TghSys.Correlative (Self, System.True);
  End;

  { Constructors and destructors }

  Class Destructor TghObs.Destroy;
  Begin
    Finalized := System.True;
    System.SysUtils.FreeAndNil (ItemInfos);
  End;

  { Protected static class methods }

  Class Function TghObs.AddRel (Const AItem1, AItem2 :Pointer;
    Const ARelationship :TRelationship) :Boolean;
  Begin
    Result := ItemInfo (AItem1).AddRelated (AItem2, ARelationship);
  End;

  Class Function TghObs.AddRelPair (Const AItem1, AItem2 :Pointer;
    Const ARelationship :TRelationship) :Boolean;
  Begin
    If TghSys.SetBool (Result, AddRel (AItem1, AItem2, ARelationship)) Then
      AddRel (AItem2, AItem1, ARelationship.Inverse);
  End;

  Class Function TghObs.DeleteRel (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem) :Pointer;
  Begin
    If Result.ghSetSolid (AInfo.ClearRelated (ARelatedItem)) Then
      VerifyRelCount (AItem, AInfo);
  End;

  Class Function TghObs.DeleteRel (Const AItem1 :Pointer;
    Var AInfo :PItemInfo; Const AItem2 :Pointer;
    Const ARelationship :TRelationship) :Pointer;
  Begin
    If Result.ghSetSolid (AInfo.DeleteRelated (AItem2, ARelationship)) Then
      VerifyRelCount (AItem1, AInfo);
  End;

  Class Function TghObs.DeleteRel (Const AItem1, AItem2 :Pointer;
    Const ARelationship :TRelationship) :Pointer;
  Var
    LInfo :PItemInfo Absolute Result;
  Begin
    If GetItemInfo (AItem1, LInfo) Then
      Result := DeleteRel (AItem1, LInfo, AItem2, ARelationship);
  End;

  Class Function TghObs.DeleteRelPair (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem) :Pointer;
  Var
    LRelatedItem :TRelatedItem;
  Begin
    LRelatedItem := ARelatedItem^;

    If Result.ghSetSolid (DeleteRel (AItem, AInfo, ARelatedItem)) Then
      DeleteRel (
        LRelatedItem.Value, AItem, LRelatedItem.Relationship.Inverse);
  End;

  Class Function TghObs.DeleteRelPair (Const AItem1, AItem2 :Pointer;
    Const ARelationship :TRelationship) :Pointer;
  Begin
    If Result.ghSetSolid (DeleteRel (AItem1, AItem2, ARelationship)) Then
      DeleteRel (Result, AItem1, ARelationship.Inverse);
  End;

  Class Procedure TghObs.DeleteRels (Const AItem :Pointer;
    Var AInfo :PItemInfo);
  Var
    I :Integer;
    LItem :PRelatedItem;
  Begin
    For I := 0 To AInfo.RelatedItemCount - 1 Do
    Begin
      LItem := AInfo.RelatedItem (I);

      If (LItem.Relationship <> rlsNone) And
      (DeleteRelPair (AItem, AInfo, LItem) <> Nil) And (AInfo = Nil) Then
        System.Exit;
    End;
  End;

  Class Procedure TghObs.FinishObjRels (Const AObj :TObject;
    Var AInfo :PItemInfo);

    Procedure Finish (Const ARels :TRelationships);
    Begin
      If AInfo <> Nil Then
        FinishRels (AObj, AInfo, ARels);
    End;
  Begin
    Finish ([rlsObjHoldsObj]);
    Finish ([rlsObjHoldsPObj, rlsObjHoldsPIntf]);
    Finish ([rlsObjIsObserverIntf { -> rlsIntfObservesObj }]);
    Finish ([rlsObjHeldByObj]);
    Finish ([rlsObjReferencedByPObj, rlsObjReferencedByPIntf]);
    Finish ([rlsObjObservedByIntf]);
  End;

  Class Procedure TghObs.FinishRel (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Var
    SavedFinishingRel :Boolean;
  Begin
    // This protects the AInfo slots that could be emptied by PreFinishRel
    SavedFinishingRel := Not AInfo.SetFlag (itfFinishingRel);

    Try
      PreFinishRel (AItem, AInfo, ARelatedItem);

      If (AInfo <> Nil) And (ARelatedItem.Value <> Nil) Then
        DeleteRelPair (AItem, AInfo, ARelatedItem);
    Finally
      If (AInfo <> Nil) And Not SavedFinishingRel Then
        AInfo.ClearFlag (itfFinishingRel);
    End;
  End;

  Class Procedure TghObs.FinishRels (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARels :TRelationships = rlsAllValid);
  Var
    I :Integer;
    LItem :PRelatedItem;
  Begin
    For I := 0 To AInfo.RelatedItemCount - 1 Do
    Begin
      LItem := AInfo.RelatedItem (I);

      If (LItem.Relationship <> rlsNone) And
      (LItem.Relationship In ARels) Then
      Begin
        FinishRel (AItem, AInfo, LItem);

        If (AInfo = Nil) Or (AInfo.RelCount = 0) Then
          System.Exit;
      End;
    End;
  End;

  Class Function TghObs.GetItemInfo (Const AItem :Pointer;
    Var AInfo :PItemInfo) :Boolean;
  Begin
    Result := TghSys.Keep (AInfo, ItemInfos <> Nil) And
      ItemInfos.TryGetValue (AItem, AInfo);
  End;

  Class Function TghObs.HolderObjItem (Const AItem :Pointer) :PRelatedItem;
  Var
    LInfo :PItemInfo Absolute Result;
  Begin
    If GetItemInfo (AItem, LInfo) Then
      Result := LInfo.RelatedItem (rlsObjHeldByObj);
  End;

  Class Procedure TghObs.InternalNotify (Const AInfo :PItemInfo;
    AObj :TObject; Const AEventID :Integer);
  Var
    I :Integer;
    LItem :PRelatedItem;
  Begin
    I := -1;

    While AInfo.GetRelated (rlsObjObservedByIntf, I, LItem) Do
      IghObserver (LItem.Value).HandleEvent (AObj, AEventID);

    // We notify changes to observers of the holder object too
    If TghSys.HasBitOn (AEventID, oeiObjChanges) And
    TghSys.SetSolid (AObj, HolderOf (AObj)) Then
      AObj.ghNotify (AEventID);
  End;

  {$Warn No_RetVal Off}{}//sin Else para no usar directiva
  Class Function TghObs.ItemInfo (Const AItem :Pointer) :PItemInfo;
  Begin
    ghCheckClassFinalized (Finalized);

    If AItem = Nil Then
      EArgumentNilException.ghRaise (TghSys.ermNil, ['Observation item'])
    Else
      Result := GetItemInfos.EnsureValue (AItem);
  End;
  {$Warn No_RetVal On}

  Class Procedure TghObs.NotifyDetach (Const AObserver :IghObserver;
    Const AObj :TObject);
  Var
    LInfo :PItemInfo;
  Begin
    If GetItemInfo (AObj, LInfo) And
    TghSys.HasBitOn (LInfo.Flags, itfNotifyEvents) Then
      AObserver.HandleEvent (AObj, oeiDetach);
  End;

  Class Procedure TghObs.NotifyFree (Const AInfo :PItemInfo;
    Const AObj :TObject);
  Begin
    If TghSys.HasBitOn (AInfo.Flags, itfNotifyEvents) Then
      InternalNotify (AInfo, AObj, oeiObjFree);
  End;

  Class Procedure TghObs.PreFinishIntfObservesObj (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsIntfObservesObj Then
      NotifyDetach (IghObserver (AItem), ARelatedItem.Value)
    Else  // rlsObjObservedByIntf
      NotifyDetach (IghObserver (ARelatedItem.Value), AItem);
  End;

  Class Procedure TghObs.PreFinishObjHoldsObj (Const AObj :TObject;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsObjHoldsObj Then
      TObject (ARelatedItem.Value).Free
    Else  // rlsObjHeldByObj
      AObj.Free;
  End;

  Class Procedure TghObs.PreFinishObjHoldsPIntf (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsObjHoldsPIntf Then
      ClearIntfRef (ARelatedItem.Value^)
    Else  // rlsPIntfHeldByObj
      ClearIntfRef (AItem^);
  End;

  Class Procedure TghObs.PreFinishObjHoldsPObj (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsObjHoldsPObj Then
      ClearObjRef (ARelatedItem.Value^)
    Else  // rlsPObjHeldByObj
      ClearObjRef (AItem^);
  End;

  Class Procedure TghObs.PreFinishObjIsObserverIntf (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Var
    LInfo :PItemInfo;
  Begin
    If ARelatedItem.Relationship = rlsObserverIntfIsObj Then
      FinishRels (AItem, AInfo, [rlsIntfObservesObj])
    Else  // rlsObjIsObserverIntf
      If GetItemInfo (ARelatedItem.Value, LInfo) Then
        FinishRels (ARelatedItem.Value, LInfo, [rlsIntfObservesObj]);
  End;

  Class Procedure TghObs.PreFinishPIntfReferencesObj (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsPIntfReferencesObj Then
      TghSys.PInterface (AItem)^ := Nil
    Else  // rlsObjReferencedByPIntf
      TghSys.PInterface (ARelatedItem.Value)^ := Nil;
  End;

  Class Procedure TghObs.PreFinishPObjReferencesObj (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If ARelatedItem.Relationship = rlsPObjReferencesObj Then
      TghSys.PObject (AItem)^ := Nil
    Else  // rlsObjReferencedByPObj
      TghSys.PObject (ARelatedItem.Value)^ := Nil;
  End;

  Class Procedure TghObs.PreFinishRel (Const AItem :Pointer;
    Var AInfo :PItemInfo; Const ARelatedItem :PRelatedItem);
  Begin
    If (ARelatedItem.Relationship <> rlsObjHeldByObj) Or
    Not TghSys.HasBitOn (AInfo.Flags, itfDestroying) Then
      PreFinishRelMethod (ARelatedItem.Relationship) (
        AItem, AInfo, ARelatedItem);
  End;

  Class Function TghObs.PreFinishRelMethod (
    Const ARelationship :TRelationship)
    :TghSys.TConstVarConstProc <Pointer, PItemInfo, PRelatedItem>;
  Begin
    Case ARelationship Of
      rlsObjHoldsObj, rlsObjHeldByObj : Result := @PreFinishObjHoldsObj;
      rlsObjHoldsPObj, rlsPObjHeldByObj : Result := PreFinishObjHoldsPObj;
      rlsObjHoldsPIntf, rlsPIntfHeldByObj :
        Result := PreFinishObjHoldsPIntf;
      rlsPObjReferencesObj, rlsObjReferencedByPObj   :
        Result := PreFinishPObjReferencesObj;
      rlsPIntfReferencesObj, rlsObjReferencedByPIntf :
        Result := PreFinishPIntfReferencesObj;
      rlsIntfObservesObj, rlsObjObservedByIntf :
        Result := PreFinishIntfObservesObj;
      rlsObjIsObserverIntf, rlsObserverIntfIsObj :
        Result := PreFinishObjIsObserverIntf;
      Else
        Result := Nil;
    End;
  End;

  Class Procedure TghObs.VerifyRelCount (Const AItem :Pointer;
    Var AInfo :PItemInfo);
  Begin
    If AInfo.RelCount > 0 Then
      System.Exit;

    ItemInfos.Remove (AItem);
    AInfo := Nil;
  End;

  { Public static class methods }

  {}//comprobar que el objeto observador es destruido cuando deje de observar al
  //último objeto (método Detach elimina rlsObjIsObserverIntf)
  Class Procedure TghObs.Attach (Const AObj :TObject;
    Const AObserver :IghObserver);
  Var
    LObserver :TObject;
  Begin
    If Not AddRelPair (Pointer (AObserver), AObj, rlsIntfObservesObj) Then
      System.Exit;

    If TghSys.GetObj (AObserver, LObserver) Then
      AddRelPair (LObserver, Pointer (AObserver), rlsObjIsObserverIntf);

    AObserver.HandleEvent (AObj, oeiAttach);
  End;

  {}//revisar CPU y conteo de la interfaz
  Class Procedure TghObs.ClearIntfRef (Var ARef);
  Var
    LRef :IInterface Absolute ARef;
  Begin
    If LRef = Nil Then
      System.Exit;

    If TObject (LRef) <> Nil Then
      DeleteRelPair (@ARef, Nil, rlsPIntfReferencesObj);

    LRef := Nil;
  End;

  Class Procedure TghObs.ClearObjRef (Var ARef);
  Begin
    UnmakeObjRef (ARef);
    TObject (ARef) := Nil;
  End;

  Class Procedure TghObs.Detach (Const AObj :TObject;
    Const AObserver :IghObserver);
  Var
    LInfo :PItemInfo;
  Begin
    NotifyDetach (AObserver, AObj);

    { If an Observer-Observed relation is deleted and AObserver no longer
      observes more objects }
    If (DeleteRelPair (Pointer (AObserver), AObj, rlsIntfObservesObj) <>
    Nil) And GetItemInfo (Pointer (AObserver), LInfo) And
    (LInfo.RelatedItem (rlsIntfObservesObj) = Nil) Then
      { We finish possible rlsObserverIntfIsObj relations of AObserver,
        i.e., the rlsObjIsObserverIntf relations added by the Attach method
        (reference count decrement) }
      FinishRels (Pointer (AObserver), LInfo, [rlsObserverIntfIsObj]);
  End;

  Class Procedure TghObs.DisableNotif (Const AObj :TObject);
  Var
    LInfo :PItemInfo;
  Begin
    If GetItemInfo (AObj, LInfo) Then
      LInfo.ClearFlag (itfNotifyEvents);
  End;

  Class Procedure TghObs.EnableNotif (Const AObj :TObject);
  Var
    LInfo :PItemInfo;
  Begin
    If GetItemInfo (AObj, LInfo) Then
      LInfo.SetFlag (itfNotifyEvents);
  End;

  Class Function TghObs.Hold (Const AHolder, AObj :TObject) :TObject;
  Begin
    AddRelPair (AHolder, AObj.ghSetTo (Result), rlsObjHoldsObj);
  End;

  Class Function TghObs.HolderOf (Const AObj :TObject) :TObject;
  Var
    LRelatedItem :PRelatedItem Absolute Result;
  Begin
    If TghSys.SetSolid (LRelatedItem, HolderObjItem (AObj)) Then
      Result := LRelatedItem.Value;
  End;

  Class Procedure TghObs.HoldIntfRef (Const AHolder :TObject; Const ARef);
  Begin
    AddRelPair (AHolder, @ARef, rlsObjHoldsPIntf);
  End;

  Class Function TghObs.HoldObjRef (Const AHolder :TObject; Const ARef)
    :TObject;
  Begin
    AddRelPair (AHolder, @ARef, rlsObjHoldsPObj);
    Result := TObject (ARef);
  End;

  Class Function TghObs.MakeObjRef (Const ARef) :TObject;
  Begin
    If TObject (ARef).ghSetSolidTo (Result) Then
      AddRelPair (@ARef, Result, rlsPObjReferencesObj);
  End;

  Class Procedure TghObs.Notify (Const AObj :TObject;
    Const AEventID :Integer);
  Var
    LInfo :PItemInfo;
  Begin
    If GetItemInfo (AObj, LInfo) And
    TghSys.HasBitOn (LInfo.Flags, itfNotifyEvents) Then
      InternalNotify (LInfo, AObj, AEventID);
  End;

  Class Procedure TghObs.PreDestroy (Const AObj :TObject);
  Var
    LInfo :PItemInfo;
  Begin
    If GetItemInfo (AObj, LInfo) And LInfo.SetFlag (itfDestroying) Then
      Try
        NotifyFree (LInfo, AObj);
        FinishObjRels (AObj, LInfo);

        // We delete any relation created during the FinishObjRels call
        If LInfo <> Nil Then
          DeleteRels (AObj, LInfo);
      Except
        If LInfo <> Nil Then
          LInfo.ClearFlag (itfDestroying);

        Raise;
      End;
  End;

  Class Function TghObs.RelatedDestroying (Const AObj :TObject) :Boolean;
  Var
    LInfo :PItemInfo;
  Begin
    // True if AObj has both related items and the itfDestroying flag
    Result := GetItemInfo (AObj, LInfo) And
      TghSys.HasBitOn (LInfo.Flags, itfDestroying);
  End;

  Class Function TghObs.SetObjRef (Out ARef; Const AObj :TObject) :TObject;
  Begin
    If TObject (ARef) <> Nil Then
      DeleteRelPair (@ARef, Nil, rlsPObjReferencesObj);

    TObject (ARef) := AObj;
    Result := MakeObjRef (ARef);
  End;

  Class Procedure TghObs.UnHold (Const AObj :TObject);
  Begin
    DeleteRelPair (AObj, Nil, rlsObjHeldByObj);
  End;

  Class Procedure TghObs.UnmakeObjRef (Const ARef);
  Begin
    If TObject (ARef) <> Nil Then
      DeleteRelPair (@ARef, Nil, rlsPObjReferencesObj);
  End;

End.

