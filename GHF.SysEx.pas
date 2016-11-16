///Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.SysEx.pas - TghSysEx helper unit.                                   }
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

Unit GHF.SysEx;  { System Extended }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys, System.TypInfo, GHF.Obs, System.RTTI, System.Classes,
    System.SysUtils, GHF.Lang, System.Generics.Collections;

  Type
    { System class Extended helper. Complement of the TghSys partial class. }
    TghSysEx = Class Helper For TghSys
      Protected
        Class Var
          FDefaultLang :TghLang.TClassRef;
          Finalized :Boolean;
          VirtualClasses :TDictionary <TClass, TghSys.PClass>;

        { Static class methods }
        Class Procedure SetDefaultLang (Const AValue :TghLang.TClassRef);
          Static;
      Public
        Type
          {}//mejorar semántica de ghIsDescendant, ghCheckAncestor, ghCheckDescendant y ghCheckAncestorOrDescendant
          { TObject helper }
          TObjectHelper = Class Helper For TObject
            Protected
              { Regular instance methods }
              Function ghGetAsPtr :Pointer;{}//inline
            Public
              { Regular class methods }
              Class Function ghCheckAncestor (Const AClass :TClass)
                :TClass;
              Class Function ghCheckAncestorOrDescendant (
                Const AClass :TClass) :TClass;
              Class Procedure ghCheckClassFinalized (
                Const AFinalized :Boolean);
              Class Function ghCheckDescendant (Const AClass :TClass)
                :TClass;
              Class Function ghClassAsPtr :Pointer;{}//inline
              Class Function ghClassAssignmentCompat (
                Const AInfo :PTypeInfo) :Boolean;
              Class Function ghClassInfo :PTypeInfo;
              Class Function ghClassNamed (Const AName :String) :Boolean;
              Class Procedure ghFinalizeVirtualClass;
              Class Function ghGetSetClassTo (Out ADest) :TClass;
              Class Procedure ghInitVirtualClass (Out ARef);
              Class Function ghIsDerived (Const AClass :TClass;
                Const AAllowIndirect :Boolean) :Boolean;
              Class Function ghIsDerivedNamed (Const AClass :TClass;
                Const AName :String) :Boolean; Overload;
              Class Function ghIsDerivedNamed (Const AClass :TClass;
                Const AAllowIndirect :Boolean; Const AName :String)
                :Boolean; Overload;
              Class Function ghIsDescendant (Const AClass :TClass)
                :Boolean;
              Class Procedure ghRaiseClassFinalized;
              Class Procedure ghRaiseNotConstruct (Const AMsg :String);
              Class Procedure ghRaiseNotInstantiate;
              Class Function ghSetClassTo (Out ADest) :TClass;
              Class Procedure ghSetVirtualClass (Const AReal :TClass);

              { Regular instance methods }
              Function ghAsOr <T :Class> (Const ADefaultResult :T) :T;
              Function ghAsOrNil <T :Class> :T;
              Procedure ghAttachObserver (Const AObserver :IghObserver);
                Overload;
              Function ghAttachObserver (Const AHandler :TghObs.TObsEvent;
                Const AEventIDs :Integer = TghObs.oeiAllObjChanging Or
                TghObs.oeiAllObjChanged Or TghObs.oeiAllObjStateChanging Or
                TghObs.oeiAllObjStateChanged Or
                TghObs.oeiAllObjPosChanging Or
                TghObs.oeiAllObjPosChanged) :IghControlledObserver;
                Overload;
              Function ghAttachObserver (
                Const AHandler :TghObs.TObsEventRef;
                Const AEventIDs :Integer = TghObs.oeiAllObjChanging Or
                TghObs.oeiAllObjChanged Or TghObs.oeiAllObjStateChanging Or
                TghObs.oeiAllObjStateChanged Or
                TghObs.oeiAllObjPosChanging Or
                TghObs.oeiAllObjPosChanged) :IghControlledObserver;
                Overload;
              Function ghAttachOrDetachObserver (
                Const AObserver :IghObserver; Const ACond :Boolean)
                :Boolean;
              Procedure ghCall (Const AMethodAddress :Pointer); Overload;
              Procedure ghCall <TParam> (Const AMethodAddress :Pointer;
                Const AParam :TParam); Overload;
              Procedure ghCall <TParam1, TParam2> (
                Const AMethodAddress :Pointer; Const AParam1 :TParam1;
                Const AParam2 :TParam2); Overload;
              Procedure ghCall <TParam1, TParam2, TParam3> (
                Const AMethodAddress :Pointer; Const AParam1 :TParam1;
                Const AParam2 :TParam2; Const AParam3 :TParam3); Overload;
              Function ghCall <TResult> (Const AMethodAddress :Pointer)
                :TResult; Overload;
              Function ghCall <TParam, TResult> (
                Const AMethodAddress :Pointer; Const AParam :TParam)
                :TResult; Overload;
              Function ghCall <TParam1, TParam2, TResult> (
                Const AMethodAddress :Pointer; Const AParam1 :TParam1;
                Const AParam2 :TParam2) :TResult; Overload;
              Function ghCall <TParam1, TParam2, TParam3, TResult> (
                Const AMethodAddress :Pointer; Const AParam1 :TParam1;
                Const AParam2 :TParam2; Const AParam3 :TParam3) :TResult;
                Overload;
              Function ghCheckSolid :Pointer;
              Function ghConstruct (Const AConstructor :TRTTIMethod)
                :TObject; Overload;
              Function ghConstruct (Const AConstructor :TRTTIMethod;
                Const AParams :Array Of TValue) :TObject; Overload;
              Function ghConstruct (Const ASafe :Boolean = System.True)
                :TObject; Overload;
              Procedure ghDetachObserver (Const AObserver :IghObserver);
              Procedure ghDisableNotif;
              Procedure ghEnableNotif;
              Function ghEnsureAs (Const AClass :TClass) :TObject;
                Overload;
              Function ghEnsureAs <T :Class> :T; Overload;
              Function ghFindHolder <T :Class> :T;
              Function ghGetSetTo (Out ADest) :TObject;
              Function ghHold (Const AObj :TObject) :TObject;
              Function ghHolder :TObject;
              Procedure ghHoldIntfRef (Const ARef);
              Function ghHoldRef (Const ARef) :TObject; Overload;
              Function ghHoldRef (Out ARef; Const AObj :TObject) :TObject;
                Overload;
              Function ghHoldSet (Out ARef; Const AObj :TObject) :TObject;
              Function ghIntf (Const AID :TGUID) :IInterface; Overload;
              Function ghIntf <T :IInterface> :T; Overload;
              Function ghMethodRec (Const AAddress :Pointer) :TMethod;
              Procedure ghNotify (Const AEventID :Integer); Overload;
              Procedure ghNotify (Const AEventIDs :Array Of Integer);
                Overload;
              Procedure ghNotifyChanged;
              Procedure ghNotifyChanging;
              Procedure ghNotifyPosChanged;
              Procedure ghNotifyPosChanging;
              Function ghPlaceClass (Const AClass :TClass;
                Const AAllowAncestor :Boolean = System.False) :TObject;
              Procedure ghPreDestroy;
              Function ghRelatedDestroying :Boolean;
              Function ghReplaceNil (Out ADest) :Boolean;
              Function ghSetBlankTo (Out ADest) :Boolean;
              Function ghSetRef (Out ARef) :TObject;
              Function ghSetSolidTo (Out ADest) :Boolean;
              Function ghSetTo (Out ADest) :TObject;
              Procedure ghUnHold;

              { Instance properties }
              Property ghAsPtr :Pointer Read ghGetAsPtr;
          End;

          { TArray helper }
          TArrayHelper = Class Helper (TObjectHelper) For TArray
            Public
              { Static class methods }
              Class Function ghCheckSolid <T> (
                Const AValues :Array Of TArray <T>) :TArray <T>; Static;
              Class Function ghCopy <T> (Const AValues :Array Of T;
                Const AStartIndex :Integer = 0;
                Const ACount :Integer = System.MaxInt;
                Const AExtraSize :Integer = 0) :TArray <T>; Static;
              Class Procedure ghEnsureLength <T> (Var AArr :TArray <T>;
                Const ALength :Integer); Static;
              Class Function ghLeft <T> (Const AValues :Array Of T;
                Const ACount :Integer = 1; Const AExtraSize :Integer = 0)
                :TArray <T>; Static;
              Class Function ghMemEqual <T> (
                Const AValues1, AValues2 :Array Of T) :Boolean; Static;
              Class Function ghNew <T> (Const ALength :Integer)
                :TArray <T>; Static;
              Class Function ghRight <T> (Const AValues :Array Of T;
                Const ACount :Integer = 1; Const AExtraSize :Integer = 0)
                :TArray <T>; Static;
              Class Function ghSameLength <T> (
                Const AValues1, AValues2 :Array Of T; Out ALength :Integer)
                :Boolean; Static;
              Class Function ghSetLength <T> (Var AArr :TArray <T>;
                Const ALength :Integer) :Integer; Static;
              Class Function ghSetSameLength <T> (Var AArr :TArray <T>;
                Const AValues :Array Of T) :Integer; Overload; Static;
              Class Function ghSetSameLength <T1, T2> (
                Var AArr :TArray <T1>; Const AValues :Array Of T2)
                :Integer; Overload; Static;
              Class Function ghSetSolid <T> (Out AArr :TArray <T>;
                Const AValue :TArray <T>) :Boolean; Static;
              Class Function ghShift <T> (Const AValues :Array Of T;
                ACount :Integer = -1;
                Const ACircular :Boolean = System.False) :TArray <T>;
                Static;
              Class Function ghSolid <T> (
                Const AValues :Array Of TArray <T>) :TArray <T>; Static;
              Class Function ghTrim <T> (Const AValues :Array Of T;
                Const ACount :Integer = 1; Const AExtraSize :Integer = 0)
                :TArray <T>; Overload; Static;

              {}//añadir nota, implementar copy propio (InternalCopy), o revisar si los parches lo corrigen
              //(quality report RSP-9887)
              class procedure ghCheckArrays(Source, Destination: Pointer; SourceIndex, SourceLength, DestIndex, DestLength, Count: NativeInt); static;
              class procedure ghFixedCopy<T>(const Source, Destination: array of T; SourceIndex, DestIndex, Count: NativeInt); static;
          End;

          { TPersistent helper }
          TPersistentHelper = Class Helper (TObjectHelper) For TPersistent
            Protected
              { Regular instance methods }
              Procedure ghCheckDesigning;
              Procedure ghCheckRunning;
              Function ghGetDesigning :Boolean;
              Function ghGetOwnerComponent :TComponent;
            Public
              { Regular class methods }
              Class Procedure ghRegClass;

              { Regular instance methods }
              Function ghStateFilePath (Const AValue :TFileName) :String;

              { Instance properties }
              Property ghDesigning :Boolean Read ghGetDesigning;
              Property ghOwnerComponent :TComponent
                Read ghGetOwnerComponent;
          End;

          { TComponent helper }
          TComponentHelper = Class Helper (TPersistentHelper) For
          TComponent
            Protected
              { Regular instance methods }
              Function ghGetDesigning :Boolean;
              Function ghGetLoading :Boolean;
            Public
              { Regular instance methods }
              Procedure ghCheckDesigning;
              Procedure ghCheckRunning;
              Function ghDesigningInteract (
                Const AInteractive :Boolean = System.True) :Boolean;
              Function ghEnumComponents (Const AClass :TComponentClass;
                Const AProc :TEnumerationProcRef <TComponent>;
                Const ARecurse :Boolean = System.False) :TComponent;
                Overload;
              Function ghEnumComponents (
                Const AProc :TEnumerationProcRef <TComponent>;
                Const ARecurse :Boolean = System.False) :TComponent;
                Overload;
              Function ghEnumComponents <T :TComponent> (
                Const AProc :TEnumerationProcRef <T>;
                Const ARecurse :Boolean = System.False) :T; Overload;
              Function ghFirstComponent (Const AClass :TComponentClass;
                Const ARecurse :Boolean = System.False) :TComponent;
                Overload;
              Function ghFirstComponent <T :TComponent> (
                Const ARecurse :Boolean = System.False) :T; Overload;
              Function ghInteract (
                Const AInteractive :Boolean = System.True) :Boolean;
              Procedure ghSetSubcomponent (Const AName :String);

              { Instance properties }
              Property ghDesigning :Boolean Read ghGetDesigning;
              Property ghLoading :Boolean Read ghGetLoading;
          End;

          { Exception helper }
          TExceptionHelper = Class Helper (TObjectHelper) For Exception
            Public
              Constructor ghCreate (Const AMsg :String;
                Const APrevException :Exception); Overload;
              Constructor ghCreate (Const AMsg :String;
                Const AParams :Array Of Const;
                Const APrevException :Exception); Overload;

              { Regular class methods }
              Class Procedure ghRaise (Const AMsg :String;
                Const ACallers :Integer = 1); Overload;
              Class Procedure ghRaise (Const AMsg :String;
                Const AParams :Array Of Const;
                Const ACallers :Integer = 1); Overload;
              Class Procedure ghRaise (Const AMsg :String;
                Const APrevException :Exception;
                Const ACallers :Integer = 1); Overload;
              Class Procedure ghRaise (Const AMsg :String;
                Const AParams :Array Of Const;
                Const APrevException :Exception;
                Const ACallers :Integer = 1); Overload;
              Class Procedure ghRaiseType <T> (Const AErrorFormat :String;
                Const ACallers :Integer = 1);
              Class Procedure ghRaiseTypes <T1, T2> (
                Const AErrorFormat :String; Const ACallers :Integer = 1);
          End;

          { TInterfacedObject helper }
          TInterfacedObjectHelper = Class Helper (TObjectHelper) For
          TInterfacedObject
            Public
              Type
                { Class reference type }
                TClassRef = Class Of TInterfacedObject;
          End;

          { TStream helper }
          TStreamHelper = Class Helper (TObjectHelper) For TStream
            Public
              { Regular instance methods }
              Function ghRead (Var ABuffer :TBytes) :Integer; Overload;
              Function ghRead (Const ACount :Integer = System.MaxInt)
                :TBytes; Overload;
              Function ghReadIn (Var ABuffer :TBytes;
                Const ACount :Integer = System.MaxInt) :Integer;
              Function ghReadSize (Const ACount :Int64) :Int64;
              Function ghWrite (Const ABuffer :TBytes) :Integer; Overload;
          End;

          { TMemoryStream helper }
          TMemoryStreamHelper = Class Helper (TStreamHelper) For
          TMemoryStream
            Public
              { Regular instance methods }
              Function ghLoadEnd (Const AFilePath :String) :Boolean;
          End;

          { TReader helper }
          TReaderHelper = Class Helper (TObjectHelper) For TReader
            Public
              { Regular instance methods }
              Procedure ghReadList (Const AItemProc :TProc;
                Const AMarker :TValueType = System.Classes.vaList);
              Procedure ghReadProp (AInstance :TPersistent); Inline;
          End;

          { TStrings helper }
          TStringsHelper = Class Helper (TPersistentHelper) For TStrings
            Protected
              { Regular instance methods }
              Function ghGetCompareType :TStrComparison;
              Function ghGetCount :Integer;
              Procedure ghSetCount (Const AValue :Integer);
            Public
              { Regular instance methods }
              Procedure ghDeleteAfter (Const AValue :String);
              Procedure ghDeleteFrom (Const AValue :String);
              Procedure ghDeleteLast;
              Function ghFreeObj (Const AIndex :Integer) :Boolean;
              Procedure ghFreeObjs;
              Function ghIndexOfSub (Const AValue :String;
                Const AStartChr :Integer = 1) :TTwoInts;
              Function ghLast :String;

              { Instance properties }
              Property ghCompareType :TStrComparison Read ghGetCompareType;
              Property ghCount:Integer Read ghGetCount Write ghSetCount;
          End;

          { TStringStream helper }
          TStringStreamHelper = Class Helper (TMemoryStreamHelper) For
          TStringStream
            Public
              { Regular instance methods }
              Procedure ghLoadAdd (Const AFilePath, AValue :String);
              Procedure ghLoadAddSave (Const AFilePath, AValue :String);
              Procedure ghWriteSave (Const AValue, AFilePath :String);
          End;

          { TWriter helper }
          TWriterHelper = Class Helper (TObjectHelper) For TWriter
            Public
              { Regular instance methods }
              Function ghGetPropPath :String;
              Procedure ghSetPropPath (Const AValue :String);
              Procedure ghWriteProp (Const AName, AValue :String);
              Procedure ghWritePropList (Const AObj :TPersistent;
                Const AHeaderProc :TProc = Nil);
              Procedure ghWritePropName (Const AValue :String); Inline;
              Procedure ghWriteValue (Const AValue :TValueType); Inline;

              { Instance properties }
              Property ghPropPath :String Read ghGetPropPath
                Write ghSetPropPath;
          End;

        { Class properties }
        Class Property DefaultLang :TghLang.TClassRef Read FDefaultLang
          Write SetDefaultLang;
    End;

Implementation

  Uses
    GHF.RTTI, GHF.ControlledObserver, System.Math, System.RTLConsts;

  { TghSysEx }

  { TghSysEx.TArrayHelper }

  Class Function TghSysEx.TArrayHelper.ghCheckSolid <T> (
    Const AValues :Array Of TArray <T>) :TArray <T>;
  Begin
    If Not ghSetSolid <T> (Result, ghSolid <T> (AValues)) Then
      EArgumentException.ghRaise (ermEmptyArr, [TghRTTI.Info <T>.Name]);
  End;

  Class Function TghSysEx.TArrayHelper.ghCopy <T> (
    Const AValues :Array Of T; Const AStartIndex :Integer = 0;
    Const ACount :Integer = System.MaxInt; Const AExtraSize :Integer = 0)
    :TArray <T>;
  Var
    LActualCount :Integer;
  Begin
    {}// NOTE: Consider bug of TArray.Copy (quality report RSP-9887).

    Result := Nil;
    LActualCount := System.Math.Min (
      ACount, System.Length (AValues) - AStartIndex);
    System.SetLength (Result, LActualCount + System.Abs (AExtraSize));
    ghFixedCopy <T> (AValues, Result, AStartIndex,
      TghSys.AbsMin (AExtraSize, 0), LActualCount);
  End;

  Class Procedure TghSysEx.TArrayHelper.ghEnsureLength <T> (
    Var AArr :TArray <T>; Const ALength :Integer);
  Begin
    If System.Length (AArr) < ALength Then
      System.SetLength (AArr, ALength);
  End;

  Class Function TghSysEx.TArrayHelper.ghLeft <T> (Const AValues :Array Of T;
    Const ACount :Integer = 1; Const AExtraSize :Integer = 0) :TArray <T>;
  Begin
    Result := ghCopy <T> (AValues, 0, ACount, AExtraSize);
  End;

  Class Function TghSysEx.TArrayHelper.ghMemEqual <T> (
    Const AValues1, AValues2 :Array Of T) :Boolean;
  Var
    LLength :Integer;
  Begin
    Result := ghSameLength <T> (AValues1, AValues2, LLength) And
      ((LLength = 0) Or System.SysUtils.CompareMem (
      @AValues1 [0], @AValues2 [0], System.SizeOf (T) * LLength));///quizá con sobrecarga para punteros MemEqual <T> (@AValues1 [0], @AValues2 [0], LLength);
  End;

  Class Function TghSysEx.TArrayHelper.ghNew <T> (Const ALength :Integer)
    :TArray <T>;
  Begin
    Result := Nil;
    System.SetLength (Result, ALength);
  End;

  Class Function TghSysEx.TArrayHelper.ghRight <T> (Const AValues :Array Of T;
    Const ACount :Integer = 1; Const AExtraSize :Integer = 0) :TArray <T>;
  Begin
    Result := ghCopy <T> (
      AValues, System.Length (AValues) - ACount, ACount, AExtraSize);
  End;

  Class Function TghSysEx.TArrayHelper.ghSameLength <T> (
    Const AValues1, AValues2 :Array Of T; Out ALength :Integer) :Boolean;
  Begin
    Result := SetInt (ALength, System.Length (AValues1)) =
      System.Length (AValues2);
  End;

  Class Function TghSysEx.TArrayHelper.ghSetLength <T> (
    Var AArr :TArray <T>; Const ALength :Integer) :Integer;
  Begin
    System.SetLength (AArr, ALength);
    Result := ALength;
  End;

  Class Function TghSysEx.TArrayHelper.ghSetSameLength <T> (
    Var AArr :TArray <T>; Const AValues :Array Of T) :Integer;
  Begin
    System.SetLength (
      AArr, TghSys.SetInt (Result, System.Length (AValues)));
  End;

  Class Function TghSysEx.TArrayHelper.ghSetSameLength <T1, T2> (
    Var AArr :TArray <T1>; Const AValues :Array Of T2) :Integer;
  Begin
    System.SetLength (
      AArr, TghSys.SetInt (Result, System.Length (AValues)));
  End;

  Class Function TghSysEx.TArrayHelper.ghSetSolid <T> (
    Out AArr :TArray <T>; Const AValue :TArray <T>) :Boolean;
  Begin
    AArr := AValue;
    Result := AArr <> Nil;
  End;

  {}//volver a probar por ajustes hechos
  Class Function TghSysEx.TArrayHelper.ghShift <T> (
    Const AValues :Array Of T; ACount :Integer = -1;
    Const ACircular :Boolean = System.False) :TArray <T>;
  Var
    LLength :Integer;
  Begin
    If SetSolid (LLength, System.Length (AValues)) And
    ((ACount = 0) Or (ACircular And (Modulize (ACount, LLength) = 0))) Then
      System.Exit (ghCopy <T> (AValues));  // No shifting is required

    If Not InSymmetricRange (ACount, System.High (AValues)) Then
      System.Exit (ghNew <T> (LLength));  // Shifting clears the array

    Result := ghTrim <T> (AValues, ACount, -ACount);

    If ACircular Then  // We recover the 'moved away' segment
      ghFixedCopy <T> (AValues, Result,
        System.Math.IfThen (ACount > 0, LLength - ACount),
        System.Math.IfThen (ACount < 0, LLength + ACount),
        System.Abs (ACount));
  End;

  Class Function TghSysEx.TArrayHelper.ghSolid <T> (
    Const AValues :Array Of TArray <T>) :TArray <T>;
  Var
    I :Integer;
  Begin
    For I := 0 To System.High (AValues) Do
      If AValues [I] <> Nil Then
        System.Exit (AValues [I]);

    Result := Nil;
  End;

  Class Function TghSysEx.TArrayHelper.ghTrim <T> (Const AValues :Array Of T;
    Const ACount :Integer = 1; Const AExtraSize :Integer = 0) :TArray <T>;
  Begin
    Result := ghCopy <T> (AValues, TghSys.AbsMin (ACount, 0),
      System.Length (AValues) - System.Abs (ACount), AExtraSize);
  End;

  class procedure TghSysEx.TArrayHelper.ghCheckArrays(Source, Destination: Pointer; SourceIndex, SourceLength, DestIndex, DestLength, Count: NativeInt);
  begin
    if (SourceIndex < 0) or (DestIndex < 0) or (SourceIndex >= SourceLength) or (DestIndex >= DestLength) or
       (SourceIndex + Count > SourceLength) or (DestIndex + Count > DestLength) then
      raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);
    if Source = Destination then
      raise EArgumentException.CreateRes(@sSameArrays);
  end;

  class procedure TghSysEx.TArrayHelper.ghFixedCopy<T>(const Source, Destination: array of T; SourceIndex, DestIndex, Count: NativeInt);
  begin
    ghCheckArrays(Pointer(@Source[0]), Pointer(@Destination[0]), SourceIndex, Length(Source), DestIndex, Length(Destination), Count);
    if IsManagedType(T) then
      System.CopyArray(Pointer(@Destination[DestIndex]), Pointer(@Source[SourceIndex]), TypeInfo(T), Count)
    else
      System.Move(Pointer(@Source[SourceIndex])^, Pointer(@Destination[DestIndex])^, Count * System.SizeOf(T));
  end;

  { TghSysEx.TComponentHelper }

  Procedure TghSysEx.TComponentHelper.ghCheckDesigning;
  Begin
    TghSys.CheckDesigning (ghDesigning);
  End;

  Procedure TghSysEx.TComponentHelper.ghCheckRunning;
  Begin
    TghSys.CheckRunning (ghDesigning);
  End;

  Function TghSysEx.TComponentHelper.ghDesigningInteract (
    Const AInteractive :Boolean = System.True) :Boolean;
  Begin
    Result := ghDesigning And ghInteract (AInteractive);
  End;

  Function TghSysEx.TComponentHelper.ghEnumComponents (
    Const AClass :TComponentClass;
    Const AProc :TEnumerationProcRef <TComponent>;
    Const ARecurse :Boolean = System.False) :TComponent;
  Var
    I :Integer;
  Begin
    { NOTE: Use the TghObjList's enumeration instead of this method if
      AProc can alter the Components/ComponentCount properties. }

    For I := 0 To ComponentCount - 1 Do
    Begin
      Result := Components [I];

      If ((AClass <> Nil) And Not (Result Is AClass)) Or
      TghSys.Call <TComponent> (AProc, Result) Then
        If ARecurse Then
          Result := Components [I].ghEnumComponents (
            AClass, AProc, System.True)
        Else
          Result := Nil;

      If Result <> Nil Then
        System.Exit;
    End;

    Result := Nil;
  End;

  Function TghSysEx.TComponentHelper.ghEnumComponents (
    Const AProc :TEnumerationProcRef <TComponent>;
    Const ARecurse :Boolean = System.False) :TComponent;
  Begin
    Result := ghEnumComponents (Nil, AProc, ARecurse);
  End;

  Function TghSysEx.TComponentHelper.ghEnumComponents <T> (
    Const AProc :TEnumerationProcRef <T>;
    Const ARecurse :Boolean = System.False) :T;
  Begin
    Result := T (ghEnumComponents (
      T, TghSys.TEnumerationProcRef <TComponent> (AProc), ARecurse));
  End;

  Function TghSysEx.TComponentHelper.ghFirstComponent (
    Const AClass :TComponentClass; Const ARecurse :Boolean = System.False)
    :TComponent;
  Var
    I :Integer;
  Begin
    Result := Nil;

    For I := 0 To ComponentCount - 1 Do
    Begin
      If Components [I] Is AClass Then
        Result := Components [I]
      Else
        If ARecurse Then
          Result := Components [I].ghFirstComponent (AClass, System.True);

      If Result <> Nil Then
        System.Exit;
    End;
  End;

  Function TghSysEx.TComponentHelper.ghFirstComponent <T> (
    Const ARecurse :Boolean = System.False) :T;
  Begin
    Result := T (ghFirstComponent (T, ARecurse));
  End;

  Function TghSysEx.TComponentHelper.ghInteract (
    Const AInteractive :Boolean = System.True) :Boolean;
  Begin
    Result := TghSys.Virtual.ComponentInteract (Self, AInteractive);
  End;

  Function TghSysEx.TComponentHelper.ghGetDesigning :Boolean;
  Begin
    Result := System.Classes.csDesigning In ComponentState;
  End;

  Function TghSysEx.TComponentHelper.ghGetLoading :Boolean;
  Begin
    Result := System.Classes.csLoading In ComponentState;
  End;

  Procedure TghSysEx.TComponentHelper.ghSetSubcomponent (
    Const AName :String);
  Begin
    Name := AName;
    SetSubComponent (True);
  End;

  { TghSysEx.TExceptionHelper }

  Constructor TghSysEx.TExceptionHelper.ghCreate (Const AMsg :String;
    Const APrevException :Exception);
  Begin
    Create (AMsg + TghSys.ccrTwoLineBreaks + APrevException.Message);
  End;

  Constructor TghSysEx.TExceptionHelper.ghCreate (Const AMsg :String;
    Const AParams :Array Of Const; Const APrevException :Exception);
  Begin
    ghCreate (System.SysUtils.Format (AMsg, AParams), APrevException);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaise (Const AMsg :String;
    Const ACallers :Integer = 1);
  Begin
    Raise Create (AMsg) At TghSys.ReturnAddress (ACallers);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaise (Const AMsg :String;
    Const AParams :Array Of Const; Const ACallers :Integer = 1);
  Begin
    Raise CreateFmt (AMsg, AParams) At TghSys.ReturnAddress (ACallers);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaise (Const AMsg :String;
    Const APrevException :Exception; Const ACallers :Integer = 1);
  Begin
    Raise ghCreate (AMsg, APrevException) At TghSys.ReturnAddress (ACallers);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaise (Const AMsg :String;
    Const AParams :Array Of Const; Const APrevException :Exception;
    Const ACallers :Integer = 1);
  Begin
    Raise ghCreate (AMsg, AParams, APrevException) At
      TghSys.ReturnAddress (ACallers);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaiseType <T> (
    Const AErrorFormat :String; Const ACallers :Integer = 1);
  Begin
    ghRaise (AErrorFormat, [TghRTTI.Info <T>.Name], ACallers + 1);
  End;

  Class Procedure TghSysEx.TExceptionHelper.ghRaiseTypes <T1, T2> (
    Const AErrorFormat :String; Const ACallers :Integer = 1);
  Begin
    ghRaise (TghRTTI.FormatTypeNames <T1, T2> (
      AErrorFormat), ACallers + 1);
  End;

  { TghSysEx.TMemoryStreamHelper }

  Function TghSysEx.TMemoryStreamHelper.ghLoadEnd (Const AFilePath :String)
    :Boolean;
  Begin
    If Not TghSys.SetBool (Result,
    System.SysUtils.FileExists (AFilePath)) Then
      System.Exit;

    LoadFromFile (AFilePath);
    Seek (0, System.Classes.soFromEnd);
  End;

  { TghSysEx.TObjectHelper }

  Function TghSysEx.TObjectHelper.ghAsOr <T> (Const ADefaultResult :T) :T;
  Begin
    If Self Is T Then
      Result := T (Self)
    Else
      Result := ADefaultResult;
  End;

  Function TghSysEx.TObjectHelper.ghAsOrNil <T> :T;
  Begin
    Result := ghAsOr <T> (Nil);
    {}//usar la más óptima opción
{    If Self Is T Then
      Result := T (Self)
    Else
      Result := Nil;}
  End;

  Procedure TghSysEx.TObjectHelper.ghAttachObserver (
    Const AObserver :IghObserver);
  Begin
    TghObs.Attach (Self, AObserver);
  End;

  Function TghSysEx.TObjectHelper.ghAttachObserver (
    Const AHandler :TghObs.TObsEvent;
    Const AEventIDs :Integer = TghObs.oeiAllObjChanging Or
    TghObs.oeiAllObjChanged Or TghObs.oeiAllObjStateChanging Or
    TghObs.oeiAllObjStateChanged Or TghObs.oeiAllObjPosChanging Or
    TghObs.oeiAllObjPosChanged) :IghControlledObserver;
  Begin
    Result := TghControlledObserver.Create (AHandler, AEventIDs);
    ghAttachObserver (Result);
  End;

  Function TghSysEx.TObjectHelper.ghAttachObserver (
    Const AHandler :TghObs.TObsEventRef;
    Const AEventIDs :Integer = TghObs.oeiAllObjChanging Or
    TghObs.oeiAllObjChanged Or TghObs.oeiAllObjStateChanging Or
    TghObs.oeiAllObjStateChanged Or TghObs.oeiAllObjPosChanging Or
    TghObs.oeiAllObjPosChanged) :IghControlledObserver;
  Begin
    Result := TghControlledObserver.Create (AHandler, AEventIDs);
    ghAttachObserver (Result);
  End;

  Function TghSysEx.TObjectHelper.ghAttachOrDetachObserver (
    Const AObserver :IghObserver; Const ACond :Boolean) :Boolean;
  Begin
    If TghSys.SetBool (Result, ACond) Then
      ghAttachObserver (AObserver)
    Else
      ghDetachObserver (AObserver);
  End;

  Procedure TghSysEx.TObjectHelper.ghCall (Const AMethodAddress :Pointer);
  Begin
    TghSys.TProcMethod (ghMethodRec (AMethodAddress));
  End;

  Procedure TghSysEx.TObjectHelper.ghCall <TParam> (
    Const AMethodAddress :Pointer; Const AParam :TParam);
  Begin
    TghSys.TConstMethod <TParam> (ghMethodRec (AMethodAddress)) (AParam);
  End;

  Procedure TghSysEx.TObjectHelper.ghCall <TParam1, TParam2> (
    Const AMethodAddress :Pointer; Const AParam1 :TParam1;
    Const AParam2 :TParam2);
  Begin
    TghSys.TConstConstMethod <TParam1, TParam2> (
      ghMethodRec (AMethodAddress)) (AParam1, AParam2);
  End;

  Procedure TghSysEx.TObjectHelper.ghCall <TParam1, TParam2, TParam3> (
    Const AMethodAddress :Pointer; Const AParam1 :TParam1;
    Const AParam2 :TParam2; Const AParam3 :TParam3);
  Begin
    TghSys.TConstConstConstMethod <TParam1, TParam2, TParam3> (
      ghMethodRec (AMethodAddress)) (AParam1, AParam2, AParam3);
  End;

  Function TghSysEx.TObjectHelper.ghCall <TResult> (
    Const AMethodAddress :Pointer) :TResult;
  Begin
    Result := TghSys.TFuncMethod <TResult> (
      ghMethodRec (AMethodAddress)) ();
  End;

  Function TghSysEx.TObjectHelper.ghCall <TParam, TResult> (
    Const AMethodAddress :Pointer; Const AParam :TParam) :TResult;
  Begin
    Result := TghSys.TConstFuncMethod <TParam, TResult> (
      ghMethodRec (AMethodAddress)) (AParam);
  End;

  Function TghSysEx.TObjectHelper.ghCall <TParam1, TParam2, TResult> (
    Const AMethodAddress :Pointer; Const AParam1 :TParam1;
    Const AParam2 :TParam2) :TResult;
  Begin
    Result := TghSys.TConstConstFuncMethod <TParam1, TParam2, TResult> (
      ghMethodRec (AMethodAddress)) (AParam1, AParam2);
  End;

  Function TghSysEx.TObjectHelper.ghCall <
    TParam1, TParam2, TParam3, TResult> (
    Const AMethodAddress :Pointer; Const AParam1 :TParam1;
    Const AParam2 :TParam2; Const AParam3 :TParam3) :TResult;
  Begin
    Result := TghSys.TConstConstConstFuncMethod <TParam1, TParam2, TParam3,
      TResult> (ghMethodRec (AMethodAddress)) (AParam1, AParam2, AParam3);
  End;

  {}//comparar contra forma Begin-Result := AClass-If...
  {$Warn No_RetVal Off}
  Class Function TghSysEx.TObjectHelper.ghCheckAncestor (
    Const AClass :TClass) :TClass;
  Begin
    If InheritsFrom (AClass) Then
      Result := AClass
    Else
      Exception.ghRaise (TghSys.ermNotAncestor,
        [AClass.QualifiedClassName, QualifiedClassName]);
  End;
  {$Warn No_RetVal On}

  {}//comparar contra forma Begin-Result := AClass-If...
  {$Warn No_RetVal Off}
  Class Function TghSysEx.TObjectHelper.ghCheckAncestorOrDescendant (
    Const AClass :TClass) :TClass;
  Begin
    If InheritsFrom (AClass) Or ghIsDescendant (AClass) Then
      Result := AClass
    Else
      Exception.ghRaise (TghSys.ermNotAncestorOrDescendant,
        [AClass.QualifiedClassName, QualifiedClassName]);
  End;

  Class Procedure TghSysEx.TObjectHelper.ghCheckClassFinalized (
    Const AFinalized :Boolean);
  Begin
    If AFinalized Then
      ghRaiseClassFinalized;
  End;

  {}//comparar contra forma Begin-Result := AClass-If...
  {$Warn No_RetVal Off}
  Class Function TghSysEx.TObjectHelper.ghCheckDescendant (
    Const AClass :TClass) :TClass;
  Begin
    If ghIsDescendant (AClass) Then
      Result := AClass
    Else
      Exception.ghRaise (TghSys.ermNotDescendant,
        [AClass.QualifiedClassName, QualifiedClassName]);
  End;
  {$Warn No_RetVal On}

  Function TghSysEx.TObjectHelper.ghCheckSolid :Pointer;
  Begin
    If Self = Nil Then
      Exception.ghRaise (TghSys.ermNil, ['Object instance']);

    Result := Self;
  End;

  Class Function TghSysEx.TObjectHelper.ghClassAsPtr :Pointer;
  Begin
    Result := Self;
  End;

  Class Function TghSysEx.TObjectHelper.ghClassAssignmentCompat (
    Const AInfo :PTypeInfo) :Boolean;
  Begin
    Result := TghRTTI.Virtual.AssignmentCompat (Self, AInfo);
  End;

  Class Function TghSysEx.TObjectHelper.ghClassInfo :PTypeInfo;
  Begin
    Result := ClassInfo;
  End;

  Class Function TghSysEx.TObjectHelper.ghClassNamed (Const AName :String)
    :Boolean;
  Begin
    If TghSys.ChrIndex (AName, '.') > 0 Then
      Result := System.SysUtils.ANSISameText (AName, QualifiedClassName)
    Else
      Result := System.SysUtils.ANSISameText (AName, ClassName);
  End;

  Function TghSysEx.TObjectHelper.ghConstruct (
    Const AConstructor :TRTTIMethod) :TObject;
  Begin
    AConstructor.Invoke (Self, []);
    AfterConstruction;
    Result := Self;
  End;

  Function TghSysEx.TObjectHelper.ghConstruct (
    Const AConstructor :TRTTIMethod; Const AParams :Array Of TValue)
    :TObject;
  Begin
    AConstructor.Invoke (Self, AParams);
    AfterConstruction;
    Result := Self;
  End;

  Function TghSysEx.TObjectHelper.ghConstruct (
    Const ASafe :Boolean = System.True) :TObject;
  Begin
    Result := ghConstruct (
      ghClassInfo.ghInstanceType.CheckSimpleConstructor (ASafe));
  End;

  Procedure TghSysEx.TObjectHelper.ghDetachObserver (
    Const AObserver :IghObserver);
  Begin
    TghObs.Detach (Self, AObserver);
  End;

  Procedure TghSysEx.TObjectHelper.ghDisableNotif;
  Begin
    TghObs.DisableNotif (Self);
  End;

  Procedure TghSysEx.TObjectHelper.ghEnableNotif;
  Begin
    TghObs.EnableNotif (Self);
  End;

  Function TghSysEx.TObjectHelper.ghEnsureAs (Const AClass :TClass)
    :TObject;
  Begin
    If Not (Self Is AClass) Then
      ghPlaceClass (AClass);{}//revisar si es más eficiente llamar a Set/Put/GetSet/-Class

    Result := Self;
  End;

  Function TghSysEx.TObjectHelper.ghEnsureAs <T> :T;
  Begin
    Result := T (ghEnsureAs (T));
  End;

  {}//probar
  Function TghSysEx.TObjectHelper.ghFindHolder <T> :T;
  Var
    LHolder :TObject Absolute Result;
  Begin
    LHolder := ghHolder;

    While (LHolder <> Nil) And Not (LHolder Is T) Do
      LHolder := LHolder.ghHolder;
  End;

  Class Procedure TghSysEx.TObjectHelper.ghFinalizeVirtualClass;
  Begin
    TghSys.VirtualClasses.Remove (Self);

    If TghSys.Finalized And (TghSys.VirtualClasses.Count = 0) Then
      System.SysUtils.FreeAndNil (TghSys.VirtualClasses);
  End;

  Function TghSysEx.TObjectHelper.ghGetAsPtr :Pointer;
  Begin
    Result := Self;
  End;

  Class Function TghSysEx.TObjectHelper.ghGetSetClassTo (Out ADest)
    :TClass;
  Begin
    {}//o código directo para que sea inline (ver tamaños)
    Result := TghSys.GetSetPtr (ADest, Self);
  End;

  Function TghSysEx.TObjectHelper.ghGetSetTo (Out ADest) :TObject;
  Begin
    {}//o código directo para que sea inline (ver tamaños)
    Result := TghSys.GetSetPtr (ADest, Self);
  End;

  Function TghSysEx.TObjectHelper.ghHold (Const AObj :TObject) :TObject;
  Begin
    Result := TghObs.Hold (Self, AObj);
  End;

  Function TghSysEx.TObjectHelper.ghHolder :TObject;
  Begin
    Result := TghObs.HolderOf (Self);
  End;

  Procedure TghSysEx.TObjectHelper.ghHoldIntfRef (Const ARef);
  Begin
    TghObs.HoldIntfRef (Self, ARef);
  End;

  Function TghSysEx.TObjectHelper.ghHoldRef (Const ARef) :TObject;
  Begin
    Result := TghObs.HoldObjRef (Self, ARef);
  End;

  Function TghSysEx.TObjectHelper.ghHoldRef (Out ARef; Const AObj :TObject)
    :TObject;
  Begin
    Result := AObj.ghSetRef (ARef);
    ghHoldRef (ARef);{}//o Result acá si genera menos código máquina
  End;

  Function TghSysEx.TObjectHelper.ghHoldSet (Out ARef; Const AObj :TObject)
    :TObject;
  Begin
    Result := AObj.ghSetRef (ARef);
    ghHoldRef (ARef);{}//o Result acá si genera menos código máquina
    ghHold (AObj);{}//o Result acá si genera menos código máquina
  End;

  Class Procedure TghSysEx.TObjectHelper.ghInitVirtualClass (Out ARef);
  Begin
    TClass (ARef) := Self;

    If TghSys.VirtualClasses = Nil Then
      TghSys.VirtualClasses := TDictionary <TClass, TghSys.PClass>.Create;

    TghSys.VirtualClasses.Add (Self, @ARef);
  End;

  Function TghSysEx.TObjectHelper.ghIntf (Const AID :TGUID) :IInterface;
  Begin
    GetInterface (AID, Result);
  End;

  Function TghSysEx.TObjectHelper.ghIntf <T> :T;
  Begin
    Result := T (ghIntf (TghRTTI.IntfGUID <T>));
  End;

  Class Function TghSysEx.TObjectHelper.ghIsDerived (Const AClass :TClass;
    Const AAllowIndirect :Boolean) :Boolean;
  Begin
    If AAllowIndirect Then
      Result := (AClass <> Self) And AClass.InheritsFrom (Self)
    Else
      Result := AClass.ClassParent = Self;
  End;

  Class Function TghSysEx.TObjectHelper.ghIsDerivedNamed (
    Const AClass :TClass; Const AName :String) :Boolean;
  Begin
    Result := (AClass.ClassParent = Self) And AClass.ghClassNamed (AName);
  End;

  Class Function TghSysEx.TObjectHelper.ghIsDerivedNamed (
    Const AClass :TClass; Const AAllowIndirect :Boolean;
    Const AName :String) :Boolean;
  Begin
    Result := ghIsDerived (AClass, AAllowIndirect) And
      AClass.ghClassNamed (AName);
  End;

  Class Function TghSysEx.TObjectHelper.ghIsDescendant (
    Const AClass :TClass) :Boolean;
  Begin
    Result := AClass.InheritsFrom (Self);
  End;

  Function TghSysEx.TObjectHelper.ghMethodRec (Const AAddress :Pointer)
    :TMethod;
  Begin
    Result.Data := Self;
    Result.Code := AAddress;
  End;

  Procedure TghSysEx.TObjectHelper.ghNotify (Const AEventID :Integer);
  Begin
    TghObs.Notify (Self, AEventID);
  End;

  Procedure TghSysEx.TObjectHelper.ghNotify (
    Const AEventIDs :Array Of Integer);
  Var
    LID :Integer;
  Begin
    For LID In AEventIDs Do
      ghNotify (LID);
  End;

  Procedure TghSysEx.TObjectHelper.ghNotifyChanged;
  Begin
    ghNotify (TghObs.oeiObjChanged);
  End;

  Procedure TghSysEx.TObjectHelper.ghNotifyChanging;
  Begin
    ghNotify (TghObs.oeiObjChanging);
  End;

  Procedure TghSysEx.TObjectHelper.ghNotifyPosChanged;
  Begin
    ghNotify (TghObs.oeiObjPosChanged);
  End;

  Procedure TghSysEx.TObjectHelper.ghNotifyPosChanging;
  Begin
    ghNotify (TghObs.oeiObjPosChanging);
  End;

  {}//revisar, agregando métodos Set/GetSet/Put-Class para centralizar código
  Function TghSysEx.TObjectHelper.ghPlaceClass (Const AClass :TClass;
    Const AAllowAncestor :Boolean = System.False) :TObject;
  Begin
    If (AClass.InstanceSize = InstanceSize) And
    (AClass.InheritsFrom (ClassType) Or
    (AAllowAncestor And InheritsFrom (AClass))) Then
      TghSys.PClass (ghSetTo (Result))^ := AClass
    Else
      EArgumentException.ghRaise (TghSys.ermInvalidClassChange,
        [QualifiedClassName, AClass.QualifiedClassName]);
  End;

  Procedure TghSysEx.TObjectHelper.ghPreDestroy;
  Begin
    TghObs.PreDestroy (Self);
  End;

  Class Procedure TghSysEx.TObjectHelper.ghRaiseClassFinalized;
  Begin
    EInvalidOpException.ghRaise (
      TghSys.ermClassFinalized, [QualifiedClassName]);
  End;

  Class Procedure TghSysEx.TObjectHelper.ghRaiseNotConstruct (
    Const AMsg :String);
  Begin
    ENoConstructException.ghRaise (AMsg, [QualifiedClassName]);
  End;

  Class Procedure TghSysEx.TObjectHelper.ghRaiseNotInstantiate;
  Begin
    ghRaiseNotConstruct (TghSys.ermNotInstantiate);
  End;

  Function TghSysEx.TObjectHelper.ghRelatedDestroying :Boolean;
  Begin
    Result := TghObs.RelatedDestroying (Self);
  End;

  {}//asegurar que sea inline
  Function TghSysEx.TObjectHelper.ghReplaceNil (Out ADest) :Boolean;
  Begin
    If TghSys.SetBool (Result, TObject (ADest) = Nil) Then
      TObject (ADest) := Self;
  End;

  Function TghSysEx.TObjectHelper.ghSetBlankTo (Out ADest) :Boolean;
  Begin
    Result := TghSys.SetBlank (ADest, Self);
    {}//buscar forma de menor tamaño (incluso código directo)
    //Result := Pointer (Dest).SetBlank (Self);
  End;

  Class Function TghSysEx.TObjectHelper.ghSetClassTo (Out ADest) :TClass;
  Begin
    {}//o código directo para que sea inline (ver tamaños)
    Result := TghSys.SetPtr (ADest, Self);
  End;

  Function TghSysEx.TObjectHelper.ghSetRef (Out ARef) :TObject;
  Begin
    Result := TghObs.SetObjRef (ARef, Self);
  End;

  Function TghSysEx.TObjectHelper.ghSetSolidTo (Out ADest) :Boolean;
  Begin
    Result := TghSys.SetSolid (ADest, Self);
    {}//buscar forma de menor tamaño (incluso código directo)
    //Result := Pointer (Dest).SetSolid (Self);
  End;

  Function TghSysEx.TObjectHelper.ghSetTo (Out ADest) :TObject;
  Begin
    {}//o código directo para que sea inline (ver tamaños)
    Result := TghSys.SetPtr (ADest, Self);
  End;

  Class Procedure TghSysEx.TObjectHelper.ghSetVirtualClass (
    Const AReal :TClass);
  Begin
    TghSys.SetAncestorOrDescendant (TghSys.VirtualClasses [Self]^, AReal);
  End;

  Procedure TghSysEx.TObjectHelper.ghUnHold;
  Begin
    TghObs.UnHold (Self);
  End;

  { TghSysEx.TPersistentHelper }

  Procedure TghSysEx.TPersistentHelper.ghCheckDesigning;
  Begin
    TghSys.CheckDesigning (ghDesigning);
  End;

  Procedure TghSysEx.TPersistentHelper.ghCheckRunning;
  Begin
    TghSys.CheckRunning (Not ghDesigning);
  End;

  {}//considerar sea TComponent al llamarse por ghStateFilePath
  Function TghSysEx.TPersistentHelper.ghGetDesigning :Boolean;
  Var
    LComponent :TComponent;
  Begin
    LComponent := ghOwnerComponent;
    Result := (LComponent <> Nil) And LComponent.ghDesigning;
  End;

  Function TghSysEx.TPersistentHelper.ghGetOwnerComponent :TComponent;
  Var
    AResult :TPersistent Absolute Result;
  Begin
    AResult := GetOwner;

    While (AResult <> Nil) And Not (AResult Is TComponent) Do
      AResult := AResult.GetOwner;
  End;

  Class Procedure TghSysEx.TPersistentHelper.ghRegClass;
  Begin
    System.Classes.RegisterClass (Self);
  End;

  Function TghSysEx.TPersistentHelper.ghStateFilePath (
    Const AValue :TFileName) :String;
  Begin
    If ghDesigning Then
      Result := AValue
    Else
      Result := TghSys.ExpandFilePath (AValue);  // Expanded in run time
  End;

  { TghSysEx.TReaderHelper }

  Procedure TghSysEx.TReaderHelper.ghReadList (Const AItemProc :TProc;
    Const AMarker :TValueType = System.Classes.vaList);
  Begin
    CheckValue (AMarker);

    While Not EndOfList Do
      AItemProc;

    ReadListEnd;
  End;

  Procedure TghSysEx.TReaderHelper.ghReadProp (AInstance :TPersistent);
  Begin
    ReadProperty (AInstance);
  End;

  { TghSysEx.TStreamHelper }

  Function TghSysEx.TStreamHelper.ghRead (Var ABuffer :TBytes) :Integer;
  Begin
    Result := Read (ABuffer, System.Length (ABuffer));
  End;

  Function TghSysEx.TStreamHelper.ghRead (
    Const ACount :Integer = System.MaxInt) :TBytes;
  Begin
    ghReadIn (Result, ACount);
  End;

  Function TghSysEx.TStreamHelper.ghReadIn (Var ABuffer :TBytes;
    Const ACount :Integer = System.MaxInt) :Integer;
  Begin
    Result := Read (
      ABuffer, TghSys.SetArrLength <Byte> (ABuffer, ghReadSize (ACount)));
  End;

  {}//optimizar
  Function TghSysEx.TStreamHelper.ghReadSize (Const ACount :Int64) :Int64;
  Begin
    Result := System.Math.Min (Size - Position, ACount)
  End;

  Function TghSysEx.TStreamHelper.ghWrite (Const ABuffer :TBytes) :Integer;
  Begin
    Result := Write (ABuffer, System.Length (ABuffer));
  End;

  { TghSysEx.TStringsHelper }

  Procedure TghSysEx.TStringsHelper.ghDeleteAfter (Const AValue :String);
  Var
    I :Integer;
  Begin
    I := IndexOf (AValue);

    If I > -1 Then
      ghCount := I + 1;
  End;

  Procedure TghSysEx.TStringsHelper.ghDeleteFrom (Const AValue :String);
  Var
    I :Integer;
  Begin
    I := IndexOf (AValue);

    If I > -1 Then
      ghCount := I;
  End;

  Procedure TghSysEx.TStringsHelper.ghDeleteLast;
  Begin
    If Count > 0 Then
      Delete (Count - 1);
  End;

  Function TghSysEx.TStringsHelper.ghFreeObj (Const AIndex :Integer)
    :Boolean;
  Var
    Obj :TObject;
  Begin
    If Not TghSys.SetSolid (Obj, Objects [AIndex], Result) Then
      System.Exit;

    Objects [AIndex] := Nil;
    Obj.Free;
  End;

  Procedure TghSysEx.TStringsHelper.ghFreeObjs;
  Var
    I :Integer;
  Begin
    I := 0;

    While I < Count Do
      If ghFreeObj (I) Then
        I := 0
      Else
        Inc (I);
  End;

  Function TghSysEx.TStringsHelper.ghGetCompareType :TStrComparison;
  Begin
    If InheritsFrom (TStringList) Then
      // See TStringList.CompareStrings
      Result := TghSys.TStrComparison.eLocaleAnyCase.PredIf (
        TStringList (Self).CaseSensitive)
    Else
      // See TStrings.CompareStrings
      Result := TghSys.TStrComparison.eLocaleAnyCase;
  End;

  {}//probar
  Function TghSysEx.TStringsHelper.ghIndexOfSub (Const AValue :String;
    Const AStartChr :Integer = 1) :TTwoInts;
  Var
    I :Integer;
  Begin
    For I := 0 To Count - 1 Do
      If TghSys.SetSolid (Result.LowValue, TghSys.StrIndex (
      Strings [I], AValue, AStartChr, ghCompareType)) Then
      Begin
        Result.HighValue := I;
        System.Exit;
      End;

    Result.SetValues (0, -1);
  End;

  Function TghSysEx.TStringsHelper.ghLast :String;
  Begin
    Result := Strings [Count - 1];
  End;

  Function TghSysEx.TStringsHelper.ghGetCount :Integer;
  Begin
    Result := GetCount;{}//o Count
  End;

  Procedure TghSysEx.TStringsHelper.ghSetCount (Const AValue :Integer);
  Var
    I :Integer;
  Begin
    I := AValue - Count;
    BeginUpdate;

    Try
      If I > 0 Then
        For I := 1 To I Do
          Add ('')
      Else
        For I := -1 DownTo I Do
          Delete (Count - 1);
    Finally
      EndUpdate;
    End;
  End;

  { TghSysEx.TStringStreamHelper }

  Procedure TghSysEx.TStringStreamHelper.ghLoadAdd (
    Const AFilePath, AValue :String);
  Begin
    If Not ghLoadEnd (AFilePath) Then
      Clear;

    WriteString (AValue);
  End;

  Procedure TghSysEx.TStringStreamHelper.ghLoadAddSave (
    Const AFilePath, AValue :String);
  Begin
    ghLoadAdd (AFilePath, AValue);
    SaveToFile (AFilePath);
  End;

  Procedure TghSysEx.TStringStreamHelper.ghWriteSave (
    Const AValue, AFilePath :String);
  Begin
    WriteString (AValue);
    SaveToFile (AFilePath);
  End;

  { TghSysEx.TWriterHelper }

  Function TghSysEx.TWriterHelper.ghGetPropPath :String;
  Begin
    Result := Self.FPropPath;
  End;

  Procedure TghSysEx.TWriterHelper.ghSetPropPath (Const AValue :String);
  Begin
    Self.FPropPath := AValue;
  End;

  Procedure TghSysEx.TWriterHelper.ghWriteProp (Const AName :String;
    Const AValue :String);
  Begin
    ghWritePropName (AName);
    WriteString (AValue);
  End;

  Procedure TghSysEx.TWriterHelper.ghWritePropList (
    Const AObj :TPersistent; Const AHeaderProc :TProc = Nil);
  Begin
    WriteListBegin;

    If AObj <> Nil Then
    Begin
      If @AHeaderProc <> Nil Then
        AHeaderProc;

      WriteProperties (AObj);
    End;

    WriteListEnd;
  End;

  Procedure TghSysEx.TWriterHelper.ghWritePropName (Const AValue :String);
  Begin
    WritePropName (AValue);
  End;

  Procedure TghSysEx.TWriterHelper.ghWriteValue (
    Const AValue :TValueType);
  Begin
    WriteValue (AValue);
  End;

  { Protected static class methods }

  Class Procedure TghSysEx.SetDefaultLang (
    Const AValue :TghLang.TClassRef);
  Begin
    SetAncestorOrDescendant (FDefaultLang, AValue);
  End;

End.

