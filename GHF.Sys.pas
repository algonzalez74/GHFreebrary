///Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.Sys.pas - TghSys and TghZeroton classes unit.                       }
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

Unit GHF.Sys;  { System }

{ NOTE: GH Freebrary seeks to avoid the use of version conditional
  directives, in order to keep the code clean. }

{ NOTE: GH Freebrary uses qualified identifiers to reference global
  elements defined in external units, except data types, classes and
  interfaces. }

{ NOTE: Using string typed constants in two or more routines produces
  better executable code than using string true constants or literals. }

{ NOTE: In order to avoid circular unit references, the public parts of
  this unit should not depend on other GH Freebrary units. Moreover, the
  only native unit scope that should be unconditionally referenced, either
  directly or indirectly, from this code file is the System unit scope,
  except the System.Win sub-scope. The intention is that this unit to be
  part of a central base that can be compiled into any project. }

{$ScopedEnums On}

Interface

  Uses
    System.SysUtils, System.DateUtils, System.Generics.Collections,
    System.RegularExpressions, System.TypInfo, System.Classes, System.RTTI,
    System.Types;

  Type
    { Enumerable interface }
    IghEnumerable = Interface (System.IEnumerable)
    ['{BC471050-9A9D-40D3-A7B0-94A38A30976B}']
    End;

    { Enumerator interface }
    IghEnumerator = Interface (System.IEnumerator)
    ['{401993B4-B0D7-47BA-AF8B-0CC66676851B}']
    End;

    { Zeroton class. NOTE: The name of this class was jokingly suggested by
      my friend David Berneda. :-) }
    TghZeroton = Class
      Public
        { Overridden class methods }
        Class Function NewInstance :TObject; Override;
    End;

    { System class. NOTE: TghSys is partial and is complemented by the
      TghSysEx class helper in the GHF.SysEx unit. Any part of this class
      may eventually be moved to that helper (without affecting the code
      that uses it); consider adding both units to the Uses clauses of your
      projects when one of them is needed. }
    TghSys = Class (TghZeroton)
      Private
        Class Constructor Create;
        Class Destructor Destroy;
      Protected
        Class Var
          FExePath :TFileName;

        { Static class methods }
        Class Function GetExePath :TFileName; Static;
      Public
        Const
          { Control characters }

          ccrNUL = #0;  // NUL
          ccrSOH = #1;  // SOH
          ccrSTX = #2;  // STX
          ccrETX = #3;  // ETX
          ccrEOT = #4;  // EOT
          ccrENQ = #5;  // ENQ
          ccrACK = #6;  // ACK
          ccrBEL = #7;  // BEL
          ccrBS  = #8;  // BS
          ccrHT  = #9;  // HT
          ccrLF  = #10;  // LF
          ccrVT  = #11;  // VT
          ccrFF  = #12;  // FF
          ccrCR  = #13;  // CR
          ccrSO  = #14;  // SO
          ccrSI  = #15;  // SI
          ccrDLE = #16;  // DLE
          ccrDC1 = #17;  // DC1
          ccrDC2 = #18;  // DC2
          ccrDC3 = #19;  // DC3
          ccrDC4 = #20;  // DC4
          ccrNAK = #21;  // NAK
          ccrSYN = #22;  // SYN
          ccrETB = #23;  // ETB
          ccrCAN = #24;  // CAN
          ccrEM  = #25;  // EM
          ccrSUB = #26;  // SUB
          ccrESC = #27;  // ESC
          ccrFS  = #28;  // FS
          ccrGS  = #29;  // GS
          ccrRS  = #30;  // RS
          ccrUS  = #31;  // US

          // Composite

          // CR, LF
          ccrCRLF_ = ccrCR + ccrLF;
          ccrCRLF :String = ccrCRLF_;

          // CR, LF, CR, LF
          ccrTwoCRLF_ = ccrCRLF_ + ccrCRLF_;
          ccrTwoCRLF :String = ccrTwoCRLF_;

          ccrTwoLineBreaks_ = System.sLineBreak + System.sLineBreak;
          ccrTwoLineBreaks :String = ccrTwoLineBreaks_;

          { ANSI control characters }

          accNUL = ANSIChar (ccrNUL);
          accSOH = ANSIChar (ccrSOH);
          accSTX = ANSIChar (ccrSTX);
          accETX = ANSIChar (ccrETX);
          accEOT = ANSIChar (ccrEOT);
          accENQ = ANSIChar (ccrENQ);
          accACK = ANSIChar (ccrACK);
          accBEL = ANSIChar (ccrBEL);
          accBS  = ANSIChar (ccrBS);
          accHT  = ANSIChar (ccrHT);
          accLF  = ANSIChar (ccrLF);
          accVT  = ANSIChar (ccrVT);
          accFF  = ANSIChar (ccrFF);
          accCR  = ANSIChar (ccrCR);
          accSO  = ANSIChar (ccrSO);
          accSI  = ANSIChar (ccrSI);
          accDLE = ANSIChar (ccrDLE);
          accDC1 = ANSIChar (ccrDC1);
          accDC2 = ANSIChar (ccrDC2);
          accDC3 = ANSIChar (ccrDC3);
          accDC4 = ANSIChar (ccrDC4);
          accNAK = ANSIChar (ccrNAK);
          accSYN = ANSIChar (ccrSYN);
          accETB = ANSIChar (ccrETB);
          accCAN = ANSIChar (ccrCAN);
          accEM  = ANSIChar (ccrEM);
          accSUB = ANSIChar (ccrSUB);
          accESC = ANSIChar (ccrESC);
          accFS  = ANSIChar (ccrFS);
          accGS  = ANSIChar (ccrGS);
          accRS  = ANSIChar (ccrRS);
          accUS  = ANSIChar (ccrUS);

          // Composite
          accCRLF          :ANSIString = ccrCRLF_;  // CR, LF
          accTwoCRLF       :ANSIString = ccrTwoCRLF_;  // CR, LF, CR, LF
          accTwoLineBreaks :ANSIString = ccrTwoLineBreaks_;

          { Digits }
          dgtBins     = ['0'..'1'];  // Binary
          dgtDecimals = ['0'..'9'];
          dgtHexs     = dgtDecimals + ['A'..'F'];  // Hexadecimal
          dgtOctals   = ['0'..'7'];
          dgtRomans   = ['I', 'V', 'X', 'L', 'C', 'D', 'M'];

          { Maximums }
          maxANSIChr       = System.High (ANSIChar);
          maxChr           = System.High (Char);
          maxDate          = 2958465;  // 31/12/9999
          maxTime          = 0.999999988425926;  // 23:59:59.999
          maxDateTime      = maxDate + maxTime;
          maxPtr           = Pointer (NativeUInt.MaxValue);  // Pointer
          maxReal48        = 1.7e38;
          maxTimeMinute    = 1 - System.DateUtils.OneMinute;  // 23:59
          maxUnsignedInt24 = $FFFFFF;
          maxWideChr       = System.High (WideChar);
          maxYear          = 9999;

          { Characters }
          chrAll         = [#0..maxANSIChr];
          chrDotDecimals = dgtDecimals + ['.'];

          ///revisar si deben ser ResourceStrings
          {$Region 'Error messages (ermXXX)'}
          ermAlreadyHeld_ = '%s is already held.';
          ermAlreadyHeld :String = ermAlreadyHeld_;
          ermAlreadyOwned_ = '%s is already owned.';
          ermAlreadyOwned :String = ermAlreadyOwned_;
          ermCannotOperation_ = 'Cannot perform this operation %s.';
          ermCannotOperation :String = ermCannotOperation_;
          ermCannotStrWhenStr_ = 'Cannot %s (%s) when %s (%s).';
          ermCannotStrWhenStr :String = ermCannotStrWhenStr_;
          ermCannotWhen_ = 'Cannot %s when %s.';
          ermCannotWhen :String = ermCannotWhen_;
          ermCellNotFound_ = 'Cell not found in %s: "%s".';
          ermCellNotFound :String = ermCellNotFound_;
          ermClassFinalized_ = '%s class is finalized.';
          ermClassFinalized :String = ermClassFinalized_;
          ermCreationFailed_ = '%s creation failed.';
          ermCreationFailed :String = ermCreationFailed_;
          ermDestroying_ = '%s is destroying.';
          ermDestroying :String = ermDestroying_;
          ermEmptyArr_ = 'Array of %s elements is empty.';
          ermEmptyArr :String = ermEmptyArr_;
          ermEmptyStr_ = '%s cannot be an empty string.';
          ermEmptyStr :String = ermEmptyStr_;
          ermExclusiveRelationshipEstablished_ =
            'Type of exclusive relationship already established for %s.';
          ermExclusiveRelationshipEstablished :String =
            ermExclusiveRelationshipEstablished_;
          ermExpected_ = '%s was expected.';
          ermExpected :String = ermExpected_;
          ermExpectedGiven_ = '%s was expected, but %s was given.';
          ermExpectedGiven :String = ermExpectedGiven_;
          ermInitPrematurely_ = '%s was initialized prematurely.';
          ermInitPrematurely :String = ermInitPrematurely_;
          ermInUse_ = '%s is already in use.';
          ermInUse :String = ermInUse_;
          ermInvalidChange_ = 'Invalid change of %s.';
          ermInvalidChange :String = ermInvalidChange_;
          ermInvalidClassChange_ = 'Invalid class change (from %s to %s).';{}//o "replacement"
          ermInvalidClassChange = ermInvalidClassChange_;
          ermInvalidClassID_ = 'Invalid %s class ID: "%s".';
          ermInvalidClassID :String = ermInvalidClassID_;
          ermInvalidClassIDs_ = 'Invalid %s class IDs.';
          ermInvalidClassIDs :String = ermInvalidClassIDs_;
          ermInvalidContentOrFile_ = 'Invalid content or file for %s.';
          ermInvalidContentOrFile :String = ermInvalidContentOrFile_;
          ermInvalidObjOwnership_ = 'Invalid object ownership.';
          ermInvalidObjOwnership :String = ermInvalidObjOwnership_;
          ermInvalidOwnership_ = 'Invalid ownership.';{}//quizá "for %s"
          ermInvalidOwnership :String = ermInvalidOwnership_;
          ermInvalidRelationship_ = 'Invalid relationship for %s.';
          ermInvalidRelationship :String = ermInvalidRelationship_;
          ermInvalidScheme_ = 'Invalid scheme: "%s".';
          ermInvalidScheme :String = ermInvalidScheme_;
          ermInvalidStr_ = 'Invalid %s: "%s".';
          ermInvalidStr :String = ermInvalidStr_;
          ermInvalidType_ = '%s is not a valid type for this operation.';
          ermInvalidType :String = ermInvalidType_;
          ermInvalidTypecast_ = 'Invalid typecast (%s as %s).';
          ermInvalidTypecast = ermInvalidTypecast_;
          ermInvalidTypeCombo_ = 'Invalid type combination (%s and %s).';
          ermInvalidTypeCombo = ermInvalidTypeCombo_;
          ermInvalidTypeConversion_ =
            'Invalid type conversion (from %s to %s).';
          ermInvalidTypeConversion = ermInvalidTypeConversion_;
          ermInvalidURI_ = 'Invalid %s URI: "%s".';
          ermInvalidURI :String = ermInvalidURI_;
          ermInvalidValue_ = 'Invalid %s value: %s.';
          ermInvalidValue :String = ermInvalidValue_;
          ermItemNotFound_ = '%s item not found.';
          ermItemNotFound :String = ermItemNotFound_;
          ermNil_ = '%s cannot be Nil.';
          ermNil :String = ermNil_;
          ermIncompatibleTypes_ = 'Incompatible types: %s and %s.';
          ermIncompatibleTypes :String = ermIncompatibleTypes_;
          ermLockedForWriting_ = '%s is locked for writing.';
          ermLockedForWriting :String = ermLockedForWriting_;
          ermNodeInvalidContext_ = 'Node invalid in this context: "%s".';
          ermNodeInvalidContext :String = ermNodeInvalidContext_;
          ermNotAncestor_ = '%s is not ancestor of %s.';
          ermNotAncestor :String = ermNotAncestor_;
          ermNotAncestorOrDescendant_ =
            '%s class is not an ancestor or descendant of %s class.';
          ermNotAncestorOrDescendant :String = ermNotAncestorOrDescendant_;
          ermNotApplicableToType_ =
            'Operation not applicable to the %s type.';
          ermNotApplicableToType = ermNotApplicableToType_;
          ermNotAvailable_ = '%s not available in this context.';
          ermNotAvailable :String = ermNotAvailable_;
          ermNotDescendant_ = '%s is not descendant of %s.';
          ermNotDescendant :String = ermNotDescendant_;
          ermNotExpectedType_ = '%s is not an expected type.';
          ermNotExpectedType :String = ermNotExpectedType_;
          ermNotExpectedTypeValue_ = '%s is not of the expected type.';
          ermNotExpectedTypeValue :String = ermNotExpectedTypeValue_;
          ermNotFound_ = '%s not found.';
          ermNotFound :String = ermNotFound_;
          ermNotFoundEx_ = ermNotFound_ + System.sLineBreak + '%s';
          ermNotFoundEx :String = ermNotFoundEx_;
          ermNotFoundStr_ = '%s not found: "%s".';
          ermNotFoundStr :String = ermNotFoundStr_;
          ermNotInstantiate_ = 'Cannot create instances of the %s class.';
          ermNotInstantiate :String = ermNotInstantiate_;
          ermObjCannotVar_ =
            '%s object instance cannot be converted to/from Variant.';
          ermObjCannotVar :String = ermObjCannotVar_;
          ermOperationInvalidDesignTime_ =
            'Operation invalid at design time.';
          ermOperationInvalidDesignTime :String =
            ermOperationInvalidDesignTime_;
          ermOperationInvalidRunTime_ = 'Operation invalid at run time.';
          ermOperationInvalidRunTime :String = ermOperationInvalidRunTime_;
          ermOutOfRange_ = '%s (%s) is out of range.';
          ermOutOfRange :String = ermOutOfRange_;
          ermPresent_ =
            '%s is already present (duplicate) or should not be present.';
          ermPresent :String = ermPresent_;
          ermPresentEx_ = ermPresent_ + System.sLineBreak + '%s';
          ermPresentEx :String = ermPresentEx_;
          ermPropFalse_ = '%s has its %s property in False.';
          ermPropFalse :String = ermPropFalse_;
          ermPropNotSet_ = '%s property not set.';
          ermPropNotSet :String = ermPropNotSet_;
          ermRegisteredAnotherPurpose_ =
            '%s already registered for another purpose.';
          ermRegisteredAnotherPurpose :String = ermRegisteredAnotherPurpose_;
          ermSingletonInstance_ =
            'Cannot create more than one instance of the %s class.';
          ermSingletonInstance :String = ermSingletonInstance_;
          ermSys_ = 'System error: %s' + System.sLineBreak +
            'Error code: %d.';
          ermSys :String = ermSys_;
          ermThereIsAlready_ = 'There is already %s.';
          ermThereIsAlready :String = ermThereIsAlready_;
          ermThereIsAlreadyOperation_ = 'There is already %s in operation.';
          ermThereIsAlreadyOperation :String = ermThereIsAlreadyOperation_;
          ermTypeNoAttr_ = '%s type has no %s attribute.';
          ermTypeNoAttr :String = ermTypeNoAttr_;
          ermURINotFound_ = '%s URI not found: "%s".';
          ermURINotFound :String = ermURINotFound_;
          {$EndRegion}

          { Formats }

          // ISO

          fmtISODate     = 'yyyy-mm-dd';
          fmtISOTime     = 'hh:nn:ss';
          fmtISODateTime = fmtISODate + '"T"' + fmtISOTime;

          // Time with Milliseconds
          fmtISOTimeMillisecs = fmtISOTime + '.zzz';

          // Date and Time with Milliseconds
          fmtISODateTimeMillisecs = fmtISODate + '"T"' +
            fmtISOTimeMillisecs;

          // For functions such as FormatFloat and FormatDateTime
          fmtQuote = '"''"';

          // Standard

          fmtStdDateTime = fmtISODate + ' ' + fmtISOTime;

          // Date and Time with Milliseconds
          fmtStdDateTimeMillisecs = fmtISODate + ' ' + fmtISOTimeMillisecs;

          { Minimums }
          minReal48     = 2.9e-39;

          { Nil method }
          NilMethod :TMethod = (Code : Nil; Data : Nil);

          { Variant types }
          vrtUnsignedInts32 = [System.varByte, System.varWord,
            System.varLongWord];
          vrtUnsignedInts = vrtUnsignedInts32 + [System.varUInt64];

        Type
          { Pointer types for data types declared in native units }
          PClass = ^TClass;
          PInterface = ^IInterface;
          PObject = ^TObject;
          PPVarArray = ^PVarArray;

          { Any kind method type }
          TAnyKindMethod = Packed Record
            Private
              { Regular instance methods }
              Function ClearNormal :Boolean;
              Function GetIsEmpty :Boolean; Inline;
              Function GetIsRef :Boolean; Inline;
              Function GetNormal :PMethod; Inline;
              Function GetRef :Pointer; Inline;
              Procedure SetNormal (Const AValue :PMethod); Inline;
              Procedure SetRef (Const AValue :Pointer); Inline;
            Public
              { Regular instance methods }
              Procedure Clear; Inline;
              Function ClearRef :Boolean;
              Procedure Init; Inline;

              { Instance properties }
              Property IsEmpty :Boolean Read GetIsEmpty;
              Property IsRef :Boolean Read GetIsRef;
              Property Normal :PMethod Read GetNormal Write SetNormal;
              Property Ref :Pointer Read GetRef Write SetRef;
            Private
              { NOTE: FNormal.Code/FRef <> Nil and FNormal.Data = Nil indicates
                that FRef is an anonymous method reference. }
              Case Byte Of
                0 : (FNormal :TMethod);
                1 : (FRef :Pointer);
          End;

          { Array of 2 elements type }
          TArr2 <T> = Array [0..1] Of T;

          { Array of 3 elements type }
          TArr3 <T> = Array [0..2] Of T;

          { Boolean array type }
          PBoolArr = ^TBoolArr;
          TBoolArr = Array [0..System.MaxInt - 1] Of Boolean;

          { Cardinal array type }
          PCardinalArr = ^TCardinalArr;
          TCardinalArr = Array [0..(System.MaxInt Div
            System.SizeOf (Cardinal)) - 1] Of Cardinal;

          { Const Const Const Function method type }
          TConstConstConstFuncMethod <TConst1, TConst2, TConst3, TResult> =
            Function (Const AConst1 :TConst1; Const AConst2 :TConst2;
            Const AConst3 :TConst3) :TResult Of Object;

          { Const Const Const method type }
          TConstConstConstMethod <TConst1, TConst2, TConst3> = Procedure (
            Const AConst1 :TConst1; Const AConst2 :TConst2;
            Const AConst3 :TConst3) Of Object;

          { Const Const Function method type }
          TConstConstFuncMethod <TConst1, TConst2, TResult> = Function (
            Const AConst1 :TConst1; Const AConst2 :TConst2) :TResult
            Of Object;

          { Const Const method type }
          TConstConstMethod <TConst1, TConst2> = Procedure (
            Const AConst1 :TConst1; Const AConst2 :TConst2) Of Object;

          { Const Const procedure type }
          TConstConstProc <TConst1, TConst2> = Procedure (
            Const AConst1 :TConst1; Const AConst2 :TConst2);

          { Const Const procedure reference type }
          TConstConstProcRef <TConst1, TConst2> = Reference To Procedure (
            Const AConst1 :TConst1; Const AConst2 :TConst2);

          { Const Function type }
          TConstFunc <TConst, TResult> = Function (Const AConst :TConst)
            :TResult;

          { Const Function method type }
          TConstFuncMethod <TConst, TResult> = Function (
            Const AConst :TConst) :TResult Of Object;

          { Const Function reference type }
          TConstFuncRef <TConst, TResult> = Reference To Function (
            Const AConst :TConst) :TResult;

          { Const method type }
          TConstMethod <TConst> = Procedure (Const AConst :TConst)
            Of Object;

          { Const Out Function method type }
          TConstOutFuncMethod <TConst, TOut, TResult> = Function (
            Const AConst :TConst; Out AOut :TOut) :TResult Of Object;

          { Const procedure type }
          TConstProc <TConst> = Procedure (Const AConst :TConst);

          { Const procedure reference type }
          TConstProcRef <TConst> = Reference To Procedure (
            Const AConst :TConst);

          { Const Var Const procedure type }
          TConstVarConstProc <TConst1, TVar, TConst2> = Procedure (
            Const AConst1 :TConst1; Var AVar :TVar;
            Const AConst2 :TConst2);

          { Const Var Var method type }
          TConstVarVarMethod <TConst, TVar1, TVar2> = Procedure (
            Const AConst :TConst; Var AVar1 :TVar1; Var AVar2 :TVar2)
            Of Object;

          { Const Var Out method type }
          TConstVarOutMethod <TConst, TVar, TOut> = Procedure (
            Const AConst :TConst; Var AVar :TVar; Out AOut :TOut)
            Of Object;

          { Const Var reference Const method type }
          TConstVarRefConstMethod <TConst, TVar> = Procedure (
            Const AConst :TConst; Var AVar :TVar; Const ARefConst)
            Of Object;

          { Const Var Reference Var method type }
          TConstVarRefVarMethod <TConst, TVar> = Procedure (
            Const AConst :TConst; Var AVar :TVar; Var ARefVar) Of Object;

          { Const Var Reference Out method type }
          TConstVarRefOutMethod <TConst, TVar> = Procedure (
            Const AConst :TConst; Var AVar :TVar; Out ARefOut) Of Object;

          { Direction side type.  Source, Destination. }
          TDirectionSide = (eSource, eDest);

          { Enumeration function type }
          TEnumerationFunc <TItem> = Function (Const AItem :TItem)
            :Boolean;

          { Enumeration function type }
          TEnumerationFunc <TItem, TParam> = Function (Const AItem :TItem;
            Const AParam :TParam) :Boolean;

          { Enumeration function reference type }
          TEnumerationFuncRef <TItem> = Reference To Function (
            Const AItem :TItem) :Boolean;

          { Enumeration procedure type }
          TEnumerationProc <TItem> = Procedure (Const AItem :TItem;
            Var AContinue :Boolean);

          { Enumeration procedure type }
          TEnumerationProc <TItem, TParam> = Procedure (Const AItem :TItem;
            Const AParam :TParam; Var AContinue :Boolean);

          { Enumeration procedure reference type }
          TEnumerationProcRef <TItem> = Reference To Procedure (
            Const AItem :TItem; Var AContinue :Boolean);

          { Fail action type }
          TFailAction = (eIgnore, eError);

          { Function type }
          TFunc <TResult> = Function :TResult;

          { Function method type }
          TFuncMethod <TResult> = Function :TResult Of Object;

          { Gender type. Undefined/neuter, masculine/male,
            feminine/female. }
          TGender = (eUndefined, eNeuter = eUndefined, eMasculine,
            eMale = eMasculine, eFeminine, eFemale = eFeminine);

          { Generic list remove notification type }
          TGenericListRemoveNotif = System.Generics.Collections.cnRemoved..
            System.Generics.Collections.cnExtracted;

          { TMethod helper }
          TMethodHelper = Record Helper For TMethod
            Protected
              { Regular instance methods }
              Function ghGetDataClass :TClass;
              Function ghGetDataObj :TObject;
              Function ghGetIsEmpty :Boolean; Inline;
            Public
              { Regular instance methods }
              Procedure ghClear; Inline;

              { Instance properties }
              Property ghDataClass :TClass Read ghGetDataClass;
              Property ghDataObj :TObject Read ghGetDataObj;
              Property ghIsEmpty :Boolean Read ghGetIsEmpty;
          End;

          {*************************************************************}
          { Midpoint rounding type.                                     }
          {                                                             }
          { Unbiased (banker’s): -2.5 = -2  -1.5 = -2  1.5 = 2  2.5 = 2 }
          { Toward                                                      }
          {   zero:              -2.5 = -2  -1.5 = -1  1.5 = 1  2.5 = 2 }
          {   infinity:          -2.5 = -3  -1.5 = -2  1.5 = 2  2.5 = 3 }
          {   positive infinity: -2.5 = -2  -1.5 = -1  1.5 = 2  2.5 = 3 }
          {   negative infinity: -2.5 = -3  -1.5 = -2  1.5 = 1  2.5 = 2 }
          {*************************************************************}
          TMidpointRounding = (eUnbiased, eZero, eInfinity, ePositive,
            eNegative);

          { Ordinal Boolean type }
          TOrdBool = 0..1;

          { PANSIChar helper }
          TPANSICharHelper = Record Helper For PANSIChar
            Public
              { Regular instance methods }
              Procedure ghSetRef (Const AValue :ANSIString);
              Procedure ghClearRef;
          End;

          { Pointer helper }
          TPointerHelper = Record Helper For Pointer
            Protected
              { Regular instance methods }
              Function ghGetAsInt :NativeInt;
              Function ghGetAsVar :Variant;
            Public
              { Regular instance methods }
              Function ghClear (Const ASize :Integer) :Integer;
              Function ghFill (Const ASize :Integer;
                Const AValue :Byte = $FF) :Integer;
              Procedure ghFree;
              Function ghGetSet (Const AValue :Pointer) :Pointer;
              Function ghOffset (Const AInc :Integer) :Pointer;
              Function ghOffsetBy <T> :Pointer;
              Function ghSetBlank (Const AValue :Pointer) :Boolean;
              Function ghSetSolid (Const AValue :Pointer) :Boolean;
                Overload; {}//Inline;
              Function ghSetSolid (Const AValue :Pointer;
                Out AFlag :Boolean) :Boolean; Overload; {}//Inline;
              Function ghSetValue (Const AValue :Pointer) :Pointer;
              Function ghShift (Var APtr) :Pointer;

              { Instance properties }
              Property ghAsInt :NativeInt Read ghGetAsInt;
              Property ghAsVar :Variant Read ghGetAsVar;
          End;

          { Process value event type }
          TProcessValueEvent <TValue, TParam> = Procedure (
            ASender :TObject; Const AValue :TValue; Const AParam :TParam)
            Of Object;

          { Process value method type }
          TProcessValueMethod <TValue, TParam> = Procedure (
            Const AValue :TValue; Const AParam :TParam) Of Object;

          { Process value procedure reference type }
          TProcessValueProcRef <TValue, TParam> = Reference To Procedure (
            Const AValue :TValue; Const AParam :TParam);

          { Procedure method type }
          TProcMethod = Procedure Of Object;

          { TRegEx helper }
          TRegExHelper = Record Helper For TRegEx
            Public
              { Static class methods }
              Class Function ghIsMatchClear (
                Const AValue, ARegularExpr :String) :Boolean; Static;
          End;

          { String comparison type }
          TStrComparison = (eOrd { Ordinal }, eOrdAnyCase { Ordinal Any
            Case }, eLocale, eLocaleAnyCase, eSimple, eSimpleAnyCase);

          { String comparison type extended helper }
          TStrComparisonEx = Record Helper For TStrComparison
            Public
              { Regular instance methods }
              Function PredIf (Const ACond :Boolean) :TStrComparison;
              Function SuccIf (Const ACond :Boolean) :TStrComparison;
          End;

          { TStringDynArray helper }
          TStringDynArrayHelper = Record Helper For TStringDynArray
            Protected
              { Regular instance methods }
              Function ghGetData :Pointer;
              Function ghGetLength :Integer;
              Procedure ghSetLengthProp (Const AValue :Integer);
            Public
              { Regular instance methods }
              Function ghSetHigh (Const AValue :Integer) :Integer;
              Function ghSetLength (Const AValue :Integer) :Integer;

              { Instance properties }
              Property ghData :Pointer Read ghGetData;
              Property ghLength :Integer Read ghGetLength
                Write ghSetLengthProp;
          End;

          { Ternary type. Undefined/Default, False, True. }
          PTernary = ^TTernary;
          TTernary = (eUndefined, eDefault = eUndefined, eFalse, eTrue);

          { Two characters type }
          PTwoChrs = ^TTwoChrs;
          TTwoChrs = Packed Record
            { Regular instance methods }
            Function HasValues (Const AValue1, AValue2 :Char) :Boolean;
            Function IsDup (Const AValue :Char) :Boolean;

            Case Byte Of
              0 : (Value1, Value2 :Char);
              1 : (Values :TArr2 <Char>);
              2 : (LowValue, HighValue :Char);
          End;

          { Two integers type }
          TTwoInts = Packed Record
            { Regular instance methods }
            Procedure SetValues (Const A1, A2 :Integer);

            Case Byte Of
              0 : (Value1, Value2 :Integer);
              1 : (Values :TArr2 <Integer>);
              2 : (LowValue, HighValue :Integer);
              3 : (Int64Value :Int64);
          End;

          { Two strings type }
          TTwoStrs = Packed Record
            Value1 :String;
            Value2 :String;
          End;

          { Two ternaries type }
          TTwoTernaries =  (
            eUndefinedUndefined = $0000,  // L-eUndefined, H-eUndefined
            eFalseUndefined     = $0001,  // L-eFalse, H-eUndefined
            eTrueUndefined      = $0002,  // L-eTrue, H-eUndefined
            eUndefinedFalse     = $0100,  // L-eUndefined, H-eFalse
            eFalseFalse         = $0101,  // L-eFalse, H-eFalse
            eTrueFalse          = $0102,  // L-eTrue, H-eFalse
            eUndefinedTrue      = $0200,  // L-eUndefined, H-eTrue
            eFalseTrue          = $0201,  // L-eFalse, H-eTrue
            eTrueTrue           = $0202   // L-eTrue, H-eTrue
            );

          { Two ternaries type extended helper }
          TTwoTernariesEx = Record Helper For TTwoTernaries
            Protected
              {}//probar propiedades y que métodos sean inline
              Function GetValue (Const AIndex :Integer) :TTernary;
              Procedure SetValue (Const AIndex :Integer;
                Const AValue :TTernary);
            Public
              Property LowValue :TTernary Index 0 Read GetValue
                Write SetValue;
              Property HighValue :TTernary Index 1 Read GetValue
                Write SetValue;
              Property Value1 :TTernary Index 0 Read GetValue
                Write SetValue;
              Property Value2 :TTernary Index 1 Read GetValue
                Write SetValue;
              Property Values [Const AIndex :Integer] :TTernary
                Read GetValue Write SetValue;
          End;

          { Value Function method type }
          TValueFuncMethod <TValue, TResult> = Function (AConst :TValue)
            :TResult Of Object;

          { Value Var Var method type }
          TValueVarVarMethod <TValue, TVar1, TVar2> = Procedure (
            AValue :TValue; Var AVar1 :TVar1; Var AVar2 :TVar2) Of Object;

          { TVarData helper }
          TVarDataHelper = Record Helper For TVarData
            Protected
              { Regular instance methods }
              Function ghGetAsVar :PVariant;
            Public
              { Regular instance methods }
              Function ghStrLength :Integer;

              { Instance properties }
              Property ghAsVar :PVariant Read ghGetAsVar;
          End;

          { Var Function reference type }
          TVarFuncRef <TVar, TResult> = Reference To Function (
            Var AConst :TVar) :TResult;

          {}//y similar para OLEVariant (envolviendo a estos métodos)
          { Variant helper }
          TVariantHelper = Record Helper For Variant
            Protected
              { Regular instance methods }
              Function ghGetData :PVarData;
            Public
              { Regular instance methods }
              Function ghBool (
                Const ADefaultResult :Boolean = System.False) :Boolean;
              Function ghDimLength (Const ADim :Integer) :Integer;
              Function ghElement (Const APos :Integer = 0) :Variant;
              Function ghFindData :PVarData;
              Function ghFindSolidData (Out AData :PVarData) :Boolean;
              Function ghFloat :Double; Overload;
              Function ghFloat (Const ADefaultResult :Double) :Double;
                Overload;
              Function ghGetArr (Out AArr :PVarArray; Out AType :TVarType)
                :Boolean;
              Function ghGetVector (Out AArr :PVarArray;
                Out AType :TVarType) :Boolean;
              Function ghHasValue :Boolean;
              Function ghHigh (Const ADim :Integer = 1) :Integer;
              Function ghInt (Const ADefaultResult :Integer = 0) :Integer;
              Function ghInt64 (Const ADefaultResult :Int64 = 0) :Int64;
              Function ghIsArr :Boolean;
              Function ghIsBlank :Boolean;
              Function ghIsBytes :Boolean; Overload;
              Function ghIsBytes (Const AMaxLength :Integer) :Boolean;
                Overload;
              Function ghIsClear :Boolean;
              Function ghIsEmpty :Boolean;
              Function ghIsEqual (Const AValue :Variant) :Boolean;
              Function ghIsInt :Boolean;
              Function ghIsNull :Boolean;
              Function ghIsSolid :Boolean;
              Function ghIsStr :Boolean; Overload;
              Function ghIsStr (Out AData :PVarData) :Boolean; Overload;
              Function ghIsStr (Out AData :PVarData;
                Const AMaxLength :Integer) :Boolean; Overload;
              Function ghIsStr (Const AMaxLength :Integer) :Boolean;
                Overload;
              Function ghIsUnsignedInt :Boolean;
              Function ghIsUnsignedInt32 :Boolean;
              Function ghIsValueUnsignedInt :Boolean;
              Function ghIsValueUnsignedInt32 :Boolean;
              Function ghIsVector (Out AType :TVarType) :Boolean; Overload;
              Function ghIsVector :Boolean; Overload;
              Function ghIsVectorMax (Out AType :TVarType;
                Const ALength :Integer) :Boolean; Overload;
              Function ghIsVectorMax (Const ALength :Integer) :Boolean;
                Overload;
              Function ghIsVectorType (Const AType :TVarType) :Boolean;
                Overload;
              Function ghIsVectorType (Const AType :TVarType;
                Const AMaxLength :Integer) :Boolean; Overload;
              Function ghLength (Const ADim :Integer = 1) :Integer;
              Function ghLow (Const ADim :Integer = 1) :Integer;
              Function ghSetBlank (Const AValue :Variant) :Boolean;
              Procedure ghSetElement (Const APos :Integer;
                Const AValue :Variant);
              Function ghSetSolid (Const AValue :Variant) :Boolean;
              Function ghStr (Const ADefaultResult :String = '') :String;
              Function ghUInt64 (Const ADefaultResult :UInt64 = 0) :UInt64;

              { Instance properties }
              Property ghData :PVarData Read ghGetData;
          End;

          { Var procedure reference type }
          TVarProcRef <TVar> = Reference To Procedure (Var AVar :TVar);

          { Var Const procedure reference type }
          TVarConstProcRef <TVar, TConst> = Reference To Procedure (
            Var AVar :TVar; Const AConst :TConst);

          { TVarRec helper }
          TVarRecHelper = Record Helper For TVarRec
            Protected
              { Regular instance methods }
              Function ghGetAsOLEVar :OLEVariant;
              Function ghGetAsVar :Variant;
            Public
              { Regular instance methods }
              Function ghGetVar (Var AVar :Variant) :Boolean;

              { Instance properties }
              Property ghAsOLEVar :OLEVariant Read ghGetAsOLEVar;
              Property ghAsVar :Variant Read ghGetAsVar;
          End;

          { Verify value continue function reference type }
          TVerifyValueContinueFuncRef <TValue, TParam> = Reference To
            Function (Const AValue :TValue; Const AParam :TParam;
            Var AContinue :Boolean) :Boolean;

          { Check value continue method type }
          TVerifyValueContinueMethod <TValue, TParam> = Function (
            Const AValue :TValue; Const AParam :TParam;
            Var AContinue :Boolean) :Boolean Of Object;

          { Virtual class. Overridable functionality, accessible via the
            Virtual class property. }
          TVirtual = Class
            Public
              Type
                { Class reference type }
                TClassRef = Class Of TVirtual;

              { Virtual class methods }
              Class Function CompareValuesEqual (Const AValue1, AValue2;
                Const ATypeInfo :PTypeInfo; Out AEqual :Boolean) :Boolean;
                Virtual;
              Class Function ComponentInteract (AComponent :TComponent;
                AInteractive :Boolean = System.True) :Boolean; Virtual;
              Class Function GetTVarRecVar (Const AValue :TVarRec;
                Var AVar :Variant) :Boolean; Virtual;
              Class Function InternalParentPath (Const APath :String;
                AUpLevels :Integer; ADelim :Char) :String; Virtual;
              Class Function InternalResolveFilePath (Const AValue :String)
                :String; Virtual;
              Class Function InternalStrIndex (
                Const AValue, ASubStr :String; AStart :Integer;
                AComparisonType :TStrComparison) :Integer; Virtual;
              Class Procedure PrepareBinComparison (Var AStr :String;
                AComparisonType :TStrComparison =
                TStrComparison.eOrdAnyCase); Overload; Virtual;
              Class Procedure PrepareBinComparison (
                Var AStr1, AStr2 :String;
                AComparisonType :TStrComparison =
                TStrComparison.eOrdAnyCase); Overload; Virtual;
              Class Function RightVersion (Const AValue :String;
                AMaxLength :Integer = System.MaxInt) :String; Virtual;
          End;

        Class Var
          { Dummy fields }
          DummyCardinal :Cardinal;
          DummyDateTime :TDateTime;
          DummyInt      :Integer;
          DummyInt64    :Int64;
          DummyPANSIChr :PANSIChar;
          DummyChrPtr   :PChar;
          DummyPtr      :Pointer;
          DummyPWideChr :PWideChar;
          DummyWord     :Word;

        { Static class methods }
        Class Function AbsMax (Const AValue1, AValue2 :Integer) :Integer;
          Static;
        Class Function AbsMin (Const AValue1, AValue2 :Integer) :Integer;
          Static;
        Class Function ANSIStrPtr (Const AValue :ANSIString) :Pointer;
          Static;
        Class Function AreBlank (Const APtr1, APtr2 :Pointer) :Boolean;
          Static;
        Class Function AreSolid (Const APtr1, APtr2 :Pointer) :Boolean;
          Overload; Static;
        Class Function AreSolid (Const AStr1, AStr2 :String) :Boolean;
          Overload; Static;
        Class Function BitOn (Const AValue, ABit :Integer) :Boolean;
          Static;
        Class Function BitValues (Const AValue :Integer) :TArray <Integer>;
          Static;
        Class Function BlankSetTo (Var APtr1; Out APtr2) :Pointer; Static;
        Class Function BytesAdd (Const AValues :Array Of Byte;
          Const AValue :Byte) :TBytes; Overload; Static;
        Class Function BytesAdd (Const AValues :Array Of Byte;
          Const AValue :Pointer; Const ACount :Integer) :TBytes; Overload;
          Static;
        Class Function BytesAdd (Const AValues1 :Array Of Byte;
          Const AValues2 :Array Of Byte) :TBytes; Overload; Static;
        Class Function BytesAddInt (Const AValues :Array Of Byte;
          Const AValue :Integer) :TBytes; Static;
        Class Function BytesAddInt64 (Const AValues :Array Of Byte;
          Const AValue :Int64) :TBytes; Static;
        Class Function BytesAddWord (Const AValues :Array Of Byte;
          Const AValue :Word) :TBytes; Static;
        Class Function BytesAddWordGUID (Const AValues :Array Of Byte;
          Const AValue1 :Word; Const AValue2 :TGUID) :TBytes; Static;
        Class Function BytesAddWordInt (Const AValues :Array Of Byte;
          Const AValue1 :Word; Const AValue2 :Integer) :TBytes; Static;
        Class Function BytesEndBytePtr (Const AValue :TBytes) :PByte;
          Static;
        Class Function BytesEndGUIDPtr (Const AValue :TBytes) :PGUID;
          Static;
        Class Function BytesEndInt (Const AValues :Array Of Byte) :Integer;
          Static;
        Class Function BytesEndInt64Ptr (Const AValue :TBytes) :PInt64;
          Static;
        Class Function BytesEndIntPtr (Const AValue :TBytes) :PInteger;
          Static;
        Class Function BytesEndWordPtr (Const AValue :TBytes) :PWord;
          Overload; Static;
        Class Function BytesEndWordPtr (Const AValue :TBytes;
          Const AReverseIndex :Integer) :PWord; Overload; Static;
        Class Function Call <TItem> (
          Const AProc :TEnumerationProcRef <TItem>; Const AItem :TItem;
          Const ADefaultResult :Boolean = System.False) :Boolean; Overload;
          Static;
        Class Procedure CheckDesigning (Const AValue :Boolean); Static;
        Class Function CheckInc (Var AInt :Cardinal;
          Const AInc :Integer = 1) :Cardinal; Overload; Static;
        Class Function CheckInc (Var AInt :Integer;
          Const AInc :Integer = 1) :Integer; Overload; Static;
        Class Function CheckInc (Var AInt :Word; Const AInc :Integer = 1)
          :Word; Overload; Static;
        Class Function CheckIndex (Const AValue, ACount :Integer) :Integer;
          Overload; Static;
        Class Function CheckIndex (Const AValue :Integer) :Integer;
          Overload; Static;
        Class Function CheckIndexOf <T> (
          Const AMethod :TConstFuncMethod <T, Integer>;
          Const AValue :T) :Integer; Overload; Static;
        Class Function CheckIndexOf <T> (
          Const AMethod :TValueFuncMethod <T, Integer>;
          Const AValue :T) :Integer; Overload; Static;
        Class Function CheckIndexOfResult <T> (Const AValue :Integer)
          :Integer; Static;
        Class Function CheckInRange (Const AValue :Integer;
          Const AMinValue, AMaxValue :Integer) :Integer; Overload; Static;
        Class Function CheckInRange (Const AValue :Int64;
          Const AMinValue, AMaxValue :Int64) :Int64; Overload; Static;
        Class Function CheckInRanges (Const AValue :Integer;
          Const ARanges :Array Of Integer) :Integer; Overload; Static;
        Class Function CheckInt (Const AInt, AValue :Integer) :Integer;
          Static;
        Class Function CheckMin (Const AValue :Integer;
          Const AMin :Integer) :Integer; Overload; Static;
        Class Procedure CheckRunning (Const AValue :Boolean); Static;
        Class Function CheckWord (Const AValue :Integer) :Integer; Static;
        Class Function Chr (Const AValue :ANSIChar) :Char; Static;
        Class Function ChrGroupIndex (Const AValue :String;
          Const AChrs :TSysCharSet; Const ACheckIndex :Integer) :Integer;
          Static;
        Class Function ChrIndex (Const AValue :String; Const AChr :Char;
          Const AStart :Integer = 1) :Integer; Overload; Static;
        Class Function ChrIndex (Const AValue :String;
          Const AChrs :TSysCharSet; Const AStart :Integer = 1) :Integer;
          Overload; Static;
        Class Function ChrIndexIfIs (Const AValue :String;
          Const AIndex :Integer; Const AChrs :TSysCharSet) :Integer;
          Static;
        Class Function ChrIndexLast (Const AValue :String;
          Const AChr :Char; Const AStart :Integer = 1) :Integer; Static;
        Class Function ChrIndexOneLast (Const AValue :String;
          Const AChr :Char; Occurrence :Integer; Const AStart :Integer = 1)
          :Integer; Static;
        Class Function ChrOf (Const AValue :String;
          Const AIndex :Integer = 1) :Char; Static;
        Class Function ChrOfEnd (Const AValue :String;
          Const AReverseIndex :Integer = 1) :Char; Static;

        {}//nombre
        Class Function ChrPlus (Const AValue :Char; Const AInc :Integer)
          :Char; Static; {}//Inline;

        Class Procedure Clear (Var ABool1, ABool2 :Boolean); Overload;
          Static; Inline;
        Class Procedure Clear (Var AInt1, AInt2 :Integer); Overload;
          Static; Inline;
        Class Procedure Clear (Var AInt :Integer; Var ABool :Boolean);
          Overload; Static; Inline;
        Class Procedure Clear (Var APtr; Var ABool :Boolean); Overload;
          Static; Inline;
        Class Procedure Clear (Var APtr; Var AInt :Integer); Overload;
          Static; Inline;
        Class Procedure Clear (Var APtr; Var AInt :Cardinal); Overload;
          Static; Inline;
        Class Procedure Clear (Var APtr1, APtr2); Overload; Static; {}//Inline;
        Class Function ClearEqual (Var AInt :Cardinal;
          Const AValue :Cardinal) :Boolean;
        Class Procedure ClearIndexBytes (Var AIndex :Integer;
          Var AByte1, AByte2); Static;
        Class Procedure ClearIndexInt (Var AIndex :Integer; Var AInt);
          Static;
        Class Function ClearMem (Const AMem :Pointer; Const ASize :Integer)
          :Integer; Static;
        Class Function CommaConcat (Const AValues :Array Of String;
          Const AIncludeEmpties :Boolean = System.False) :String; Static;
        Class Function CommaConcatHexInts (Const AValues :Array Of Integer)
          :String; Static;
        Class Function CommaConcatInts (Const AValues :Array Of Integer)
          :String; Static;
        Class Function CompareStrs (Const AValue1, AValue2 :String;
          Const AType :TStrComparison) :Integer; Static;
        Class Function CompareStrsSimple (Const AValue1, AValue2 :String;
          Const AAnyCase :Boolean = System.False) :Integer; Static;
        Class Function Concat (Const AValue1, AValue2 :String;
          Const ASeparator :String = ' ') :String; Overload; Static;
        Class Function Concat (Const AValue1, AValue2, ASeparator :String;
          Const AIncludeEmpties :Boolean) :String; Overload; Static;
        Class Function Concat (Const AValues :Array Of String;
          Const ASeparator :String = ' ') :String; Overload; Static;
        Class Function ConcatChrs (Const AValue1, AValue2 :Char;
          Const AReverse :Boolean) :String; Static;
        Class Function ConcatFilePaths (Const APath1, APath2 :String)
          :String; Static;
        Class Function ConcatHexInts (Const AValues :Array Of Integer;
          Const ASeparator :String = ' ') :String; Static;
        Class Function ConcatInts (Const AValues :Array Of Integer;
          Const ASeparator :String = ' ') :String; Static;
        Class Function ConcatVerifyAffixes (Const AValue1, AValue2 :String;
          Const ASeparator :Char) :String; Overload; Static;
        Class Function ConcatVerifyAffixes (
          Const AValue1, AValue2, ASeparator :String) :String; Overload;
          Static;
        Class Function CopyMem <T> (Const ASource :T; Const ADest :Pointer)
          :Integer;
        Class Function Correlative (Const Value :Integer;
          Const Base1 :Boolean = System.False) :Integer; Static;
        Class Function DeleteRight (Const AValue :String;
          Const AChrs :Integer = 1) :String; Overload; Static;
        Class Function DerivedFilePath (Const APath :String;
          Const AUpLevels :Integer; Const ASubPath :String) :String;
          Overload; Static;
        Class Function DerivedFilePath (Const APath, ASubPath :String)
          :String; Overload; Static;
        Class Function DerivedPath (Const APath :String;
          Const AUpLevels :Integer; Const ASubPath :String;
          Const ADelim :Char = System.SysUtils.PathDelim) :String;
          Overload; Static;
        Class Function DerivedPath (Const APath, ASubPath :String;
          Const ADelim :Char = System.SysUtils.PathDelim) :String;
          Overload; Static;
        Class Function DivCeil (Const ADividend, ADivisor :Integer)
          :Integer; Static;
        Class Function EnclosedStr (Const AValue, ASubStr :String) :String;
          Static;
        Class Function EndChr (Const AValue :String;
          Const AReverseIndex :Integer = 1) :Char; Static;
        Class Function EnsureCardinal (Const AValue :Integer) :Integer;
          Static;
        Class Function EnsureIndex (Const AValue, ACount :Integer)
          :Integer; Static;
        Class Function EnsureIndexMax (Const AValue, ACount :Integer)
          :Integer; Static;
        Class Function EnsureIndexMin (Const AValue :Integer) :Integer;
          Static;
        Class Function ExeDerivedPath (Const AUpLevels :Integer;
          Const ASubPath :String) :String; Overload; Static;
        Class Function ExeDerivedPath (Const ASubPath :String) :String;
          Overload; Static;
        Class Function ExpandFilePath (Const AValue :String) :String;
          Static;
        Class Function FileExists (Const APath :String;
          Const ASpecialAttrs :Integer = 0) :Boolean; Overload; Static;
        Class Function FileExists (Const ADir, AMask :String;
          Const ASpecialAttrs :Integer = 0) :Boolean; Overload; Static;
        Class Function FirstFile (Const APath :String;
          Const ASpecialAttrs :Integer = 0;
          Const ACloseHandle :Boolean = System.False) :TSearchRec;
          Overload; Static;
        Class Function FirstFile (Const APath :String;
          Const ACloseHandle :Boolean) :TSearchRec; Overload; Static;
        Class Function FirstFile (Const ADir, AMask :String;
          Const ASpecialAttrs :Integer = 0;
          Const ACloseHandle :Boolean = System.False) :TSearchRec;
          Overload; Static;
        Class Function FirstFile (Const ADir, AMask :String;
          Const ACloseHandle :Boolean) :TSearchRec; Overload; Static;
        Class Function FormatISODate (Const AValue :TDateTime) :String;
          Overload; Static;
        Class Function FormatISODate :String; Overload; Static;
        Class Function FormatISODateTime (Const AValue :TDateTime) :String;
          Overload; Static;
        Class Function FormatISODateTime :String; Overload; Static;
        Class Function FormatISOTime (Const AValue :TDateTime) :String;
          Overload; Static;
        Class Function FormatISOTime :String; Overload; Static;
        Class Function FormatStdDateTime (Const AValue :TDateTime) :String;
          Overload; Static;
        Class Function FormatStdDateTime :String; Overload; Static;
        Class Procedure FreeClear (Const AObjs :Array Of PObject;
          Const AUnmakeRefs :Boolean = False); Overload; Static;
        Class Procedure FreeClear_ <T> (Var ARef :T;
          Const AUnmakeObjRef :Boolean = False); Overload; Static;
          Deprecated 'Temporary name due to compiler bug.';
        Class Function GetIntf (Const AValue :IInterface; Const AID :TGUID;
          Var AIntf) :Boolean; Overload; Static;
        Class Function GetIntf (Var AIntf; Const AID :TGUID) :Boolean;
          Overload; Static; Inline;
        Class Function GetObj (Const AIntf :IInterface; Var AObj) :Boolean;
          Static;
        Class Function GetSetAncestor (Var AClass; Const AValue :TClass)
          :TClass; Static; {}//Inline;
        Class Function GetSetDescendant (Var AClass; Const AValue :TClass)
          :TClass; Static; {}//Inline;
        Class Function GetSetInt (Var AInt :Integer; Const AValue :Integer)
          :Integer; Static;
        Class Function GetSetInt64 (Var AInt64 :Int64; Const AValue :Int64)
          :Int64; Static;
        Class Function GetSetMod (Var AInt :Integer;
          Const ADivisor :Integer) :Integer; Static; Inline;
        Class Function GetSetPtr (Var APtr; Const AValue :Pointer)
          :Pointer; Static;
        Class Function GetStrPos (Const AValues :Array Of String;
          Const AValue :String; Out APos :Integer;
          Const AStart :Integer = 0;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Boolean; Static;
        Class Function GUIDPos (Const AValues :Array Of TGUID;
          Const AValue :TGUID; Const AStart :Integer = 0) :Integer; Static;
        Class Function GUIDsEqual (Const AValue1, AValue2 :TGUID) :Boolean;
          Static;
        Class Function GUIDsEqualFromD2 (Const AValue1, AValue2 :TGUID)
          :Boolean; Static;
        Class Function GUIDsIn (Const AValues, AGroup :Array Of TGUID)
          :Boolean; Static;
        Class Function HasBitOff (Const AValue, AMask :Integer) :Boolean;
          Static;
        Class Function HasBitOn (Const AValue, AMask :Integer) :Boolean;
          Overload; Static; Inline;
        Class Function HasBitOn (Const AValue :Integer;
          Const AMask :Cardinal) :Boolean; Overload; Static; Inline;
        Class Function HasBitOnOff (
          Const AValue, AOnMask, AOffMask :Integer) :Boolean; Static;
        Class Function HasBitsOn (Const AValue, AMask :Integer) :Boolean;
          Overload; Static; Inline;
        Class Function HasBitsOn (Const AValue :Integer;
          Const AMasks :Array Of Integer) :Boolean; Overload; Static;
        Class Function HighBit (Const AValue :Integer) :Integer; Static;
        Class Function IfThen (Const ACond :Boolean; Const AValue1 :Char;
          Const AValue2 :Char = #0) :Char; Overload; Static; {}//Inline;
        Class Function IfThen (Const ACond :Boolean;
          Const AValue1 :Pointer; Const AValue2 :Pointer = Nil) :Pointer;
          Overload; Static; Inline;
        Class Function Inc (Var AInt :Cardinal; Const AInc :Integer = 1)
          :Cardinal; Overload; Static; Inline;
        Class Function Inc (Var AInt :Integer; Const AInc :Integer = 1)
          :Integer; Overload; Static; Inline;
        Class Function Inc (Var AInt :Word; Const AInc :Integer = 1) :Word;
          Overload; Static; Inline;
        Class Function IncBy <T> (Var AInt :Integer) :Integer; Static;
        Class Function IncBySelected <T1, T2> (Var AInt :Integer;
          Const ACond :Boolean) :Integer; Static;
        Class Function IncIfGreater (Const AValue1, AValue2 :Integer;
          Const AInc :Integer; Const ADefaultResult :Integer) :Integer;
          Overload; Static;
        Class Function IncIfGreater (Const AValue1, AValue2 :Integer;
          Const AInc :Integer = 1) :Integer; Overload; Static;
        Class Function IncIfPositive (Const AValue :Integer;
          Const AInc :Integer; Const ADefaultResult :Integer) :Integer;
          Overload; Static;
        Class Function IncIfPositive (Const AValue :Integer;
          Const AInc :Integer = 1) :Integer; Overload; Static;
        Class Function IncSelected (Var AInt1, AInt2 :Integer;
          Const ACond :Boolean) :Boolean; Static;{}//Inline
        Class Function IncWhen (Var AInt :Integer; Const ACond :Boolean;
          Const AInc :Integer = 1) :Boolean; Static;
        Class Function IndexLeftOfOptional (Const AValue :String;
          Const AChr :Char; Const AStartIndex :Integer = 1) :Integer;
          Static;
        Class Function IndexRightOfOptionalURLScheme (Const AURL :String)
          :Integer; Static;
        Class Function InRanges (Const AValue :Integer;
          Const ARanges :Array Of Integer) :Boolean;
        Class Function InsertStr (Const AValue, ASubStr :String;
          Const AIndex :Integer) :String;
        Class Function InSymmetricRange (Const AValue, ALimit :Integer)
          :Boolean; Static;
        Class Function Intf (Const AIntf :IInterface; Const AID :TGUID)
          :IInterface; Overload; Static; Inline;
        Class Function IntVar (Const AValue :Integer) :Variant; Static;
        Class Function IsIndex (Const AValue, ACount :Integer) :Boolean;
          Overload; Static; Inline;
        Class Function IsIndex (Const AValue :Integer; Const AStr :String)
          :Boolean; Overload; Static;
        Class Function IsIndex (Const AValue :Integer;
          Const AStr :ANSIString) :Boolean; Overload; Static;
        Class Function IsIndex (Const AValue :Integer;
          Const AStr :WideString) :Boolean; Overload; Static;
        Class Function IsSolidDifferent (Const AValue :Pointer;
          Const AComparisonValue :Pointer) :Boolean; Static;
        Class Function IsVarTypeInt (Const AType :TVarType) :Boolean;
          Static;
        Class Function IsVarTypeStr (Const AType :TVarType) :Boolean;
          Static;
        Class Function Keep (Var AInt :Integer; Const ACond :Boolean)
          :Boolean; Overload; Static; Inline;
        Class Function Keep (Var APtr; Const ACond :Boolean) :Boolean;
          Overload; Static; Inline;
        Class Function Keep (Var APtr; Const ACond :Boolean;
          Out AFlag :Boolean) :Boolean; Overload; Static;
        Class Function Keep (Var AStr :String; Const ACond :Boolean)
          :Boolean; Overload; Static; Inline;
        Class Function KeepIndex (Var AInt :Integer; Const ACond :Boolean)
          :Boolean; Static;
        Class Function LastSysErrorMsg :String; Static;
        Class Function LeftOf (Const AValue :String; Const AChr :Char;
          Const AStartIndex :Integer = 1) :String; Static;
        Class Function LeftOfOptional (Const AValue :String;
          Const AChr :Char; Const AStartIndex :Integer = 1) :String;
          Static;
        Class Function LeftRightOfOptional (Const AValue :String;
          Const AChr :Char) :TTwoStrs; Static;{}//otra con String sin compare
        Class Function LeftRightOfOptionalEx (
          Const AValue, ASubStr :String;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :TTwoStrs; Static;
        Class Function MemBytes <T> (Const AValue :T) :TBytes; Static;
        Class Function MemEqual <T> (Const AValue1, AValue2 :T) :Boolean;
          Static;
        Class Function Modulize (Var AInt :Integer;
          Const ADivisor :Integer) :Integer; Static; Inline;
        Class Function Negate (Var AInt :Integer) :Integer; Static; Inline;
        Class Function NewSingleton (
          Const AInstanceRefClassMethod :TFuncMethod <TghSys.PObject>;
          Const ANewInstanceFunc :System.SysUtils.TFunc <TObject>)
          :TObject; Static;
        Class Function NotPrefixed (Const AValue :String;
          Const APrefix :Char) :String; Static;
        Class Function Obj <T> (Const AValue :T) :TObject; Static;
        Class Function PackTernaries (Const AValue1, AValue2 :TTernary)
          :Integer;
        Class Function ParentFilePath (Const APath :String;
          Const AUpLevels :Integer = 1) :String; Static;
        Class Function ParentPath (Const APath :String;
          Const AUpLevels :Integer = 1;
          Const ADelim :Char = System.SysUtils.PathDelim) :String;
          Overload; Static;
        Class Function ParentPath (Const APath :String; Const ADelim :Char)
          :String; Overload; Static;
        Class Function PortURL (Const AURL :String; Const APort :Word)
          :String; Static;
        Class Function Prefixed (Const AValue :String; Const APrefix :Char;
          Const AAllowEmpty :Boolean = System.False) :String; Overload;
          Static;
        Class Function Prefixed (Const AValue, APrefix :String;
          Const AAllowEmpty :Boolean = System.False;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :String; Overload; Static;
        Class Function Prefixed (
          Const AValue, ASubPrefix, APrefixMark :String;
          Const AAllowEmpty :Boolean = System.False;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :String; Overload; Static;
        Class Function Prefixed (
          Const AValue, ASubPrefix, APrefixMark :String;
          Const AComparisonType :TStrComparison) :String; Overload; Static;
        Class Function PtrVar (Const AValue :Pointer) :Variant; Static;
        Class Function PutChr (Var AStr :String; Const AIndex :Integer;
          Const AValue :Char) :Boolean; Static;
        Class Function PutChrSafe (Var AStr :String; Const AIndex :Integer;
          Const AValue :Char) :Boolean; Static;
        Class Function QuotedFormat (Const AValue :String) :String; Static;
        Class Procedure RaiseExpectedGiven (
          Const AExpected, AGiven :Integer); Static;
        Class Procedure RaiseIndexOutOfRange (Const AValue :Integer);
          Static;
        Class Procedure RaiseInvalidValue (Const AName :String;
          Const AValue :Integer); Static;
        Class Procedure RaiseOutOfRange (Const AName, AValue :String);
          Static;
        Class Procedure RaiseTypecast <TSource, TDest>; Static;
        Class Function RandomBytes (Const ASize :Integer) :TBytes; Static;
        Class Function RawCast <TSource, TDest> (Const AValue :TSource)
          :TDest; Static; {}//Inline;
        Class Function ReplaceChr (Const AValue :String;
          Const AChr, ANewChr :Char) :String; Static;
        Class Function ReplaceChrs (Const AValue :String;
          Const AChrs :TSysCharSet; Const ANewChr :Char) :String; Static;
        Class Function ReplaceLeftOf (
          Const AValue, ASubStr, AReplaceSubStr, AInsertSubStr :String;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :String; Static;
        Class Function ResolveFilePath (Const AValue :String) :String;
          Static;
        Class Function ReturnAddress (ACallers :Integer = 1) :Pointer;
          Static;
        Class Function RightChrs (Const AValue :String;
          Const AChrs :TSysCharSet;
          Const AMaxLength :Integer = System.MaxInt) :String; Static;
        Class Function RightDigits (Const AValue :String;
          Const AMaxLength :Integer = System.MaxInt) :String; Static;
          Inline;
        Class Function RightDigitsDots (Const AValue :String;
          Const AMaxLength :Integer = System.MaxInt) :String; Static;
          Inline;
        Class Function RightInt (Const AValue :String;
          Const AMaxLength :Integer = System.MaxInt) :Integer; Static;
        Class Function RightLeftOf (Const AValue :String;
          Const AChr1, AChr2 :Char) :String; Static;
        Class Function RightLeftOfOptional (Const AValue :String;
          Const AChr1, AChr2 :Char) :String; Static;
        Class Function RightOf (Const AValue :String; Const AChr :Char;
          Const AEndIndex :Integer = System.MaxInt) :String; Static;
        Class Function RightOfOptional (Const AValue :String;
          Const AChr :Char; Const AEndIndex :Integer = System.MaxInt)
          :String; Static;
        Class Function SchemePortURL (Const AURL, AScheme :String;
          Const APort :Word) :String; Static;
        Class Function SchemeURL (Const AURL, AScheme :String) :String;
          Static;
        Class Function SetAncestor (Var AClass; Const AValue :TClass)
          :TClass; Static;
        Class Function SetAncestorOrDescendant (Var AClass;
          Const AValue :TClass) :TClass; Static;
        Class Function SetArrLength <T> (Var AArr :TArray <T>;
          Const AValue :Integer) :Integer; Static;
        Class Function SetBitOn (Var AInt :Integer; Const AMask :Integer)
          :Boolean; Overload; Static;
        Class Function SetBitOn (Var AInt :Word; Const AMask :Word)
          :Boolean; Overload; Static;
        Class Function SetBlank (Out AChr :Char; Const AValue :Char)
          :Boolean; Overload; Static;
        Class Function SetBlank (Out AInt :Cardinal;
          Const AValue :Cardinal) :Boolean; Overload; Static;
        Class Function SetBlank (Out AInt :Integer; Const AValue :Integer)
          :Boolean; Overload; Static;
        Class Function SetBlank (Out APtr; Const AValue :Pointer) :Boolean;
          Overload; Static;
        Class Function SetBlank (Out AStr :String; Const AValue :String)
          :Boolean; Overload; Static;
        Class Function SetBool (Out ABool :Boolean; Const AValue :Boolean)
          :Boolean; Static; Inline;
        Class Function SetBytes (Out ABytes :TBytes; Const AValue :TBytes)
          :TBytes; Static;
        Class Function SetCardinal (Out AInt :Cardinal;
          Const AValue :Cardinal) :Cardinal; Static; Inline;
        Class Function SetChr (Out AChr :Char; Const AValue :Char) :Char;
          Static; Inline;
        Class Function SetDescendant (Var AClass; Const AValue :TClass)
          :TClass; Static;
        Class Procedure SetGUIDRef (Const ARef :Pointer;
          Const AValue :TGUID); Static; Inline;
        Class Function SetHigh <T> (Var AArr :TArray <T>;
          Const AValue :Integer) :Integer; Static;
        Class Function SetIndex (Out AInt :Integer; Const AValue :Integer)
          :Boolean; Overload; Static; {}//Inline;
        Class Function SetIndex (Out AInt :Integer;
          Const AValue, ADefaultValue :Integer) :Boolean; Overload; Static;
        Class Function SetInt (Out AInt :Integer; Const AValue :Integer)
          :Integer; Static; Inline;
        Class Function SetIntCardinal (Out AInt :Integer;
          Const AValue :Integer) :Boolean; Static; {}//Inline;
        Class Procedure SetIntf (Var AIntf; Const AValue :Pointer); Static;
          Inline;
        Class Function SetLength <T> (Var AArr :TArray <T>;
          Const AValue :Integer) :Integer; Static;
        Class Function SetPtr (Out APtr; Const AValue :Pointer) :Pointer;
          Static; {}//Inline;
        Class Function SetSolid (Out AChr :Char; Const AValue :Char)
          :Boolean; Overload; Static; Inline;
        Class Function SetSolid (Out AInt :Cardinal;
          Const AValue :Cardinal) :Boolean; Overload; Static; Inline;
        Class Function SetSolid (Out AInt :Integer; Const AValue :Integer)
          :Boolean; Overload; Static; Inline;
        Class Function SetSolid (Out APtr; Const AValue :Pointer) :Boolean;
          Overload; Static; {}//Inline;
        Class Function SetSolid (Out APtr; Const AValue :Pointer;
          Out AFlag :Boolean) :Boolean; Overload; Static; {}//Inline;
        Class Function SetSolid (Out AStr :String; Const AValue :String)
          :Boolean; Overload; Static; Inline;
        Class Function ShiftPtr (Var APtr1, APtr2) :Pointer; Static;{}//Inline;
        Class Function SignedOne (Const APositive :TOrdBool) :Integer;
          Overload; Static;
        Class Function SignedOne (Const APositive :Boolean) :Integer;
          Overload; Static;
        Class Function Solid (Const AValues :Array Of Pointer) :Pointer;
        Class Function SplitHexInts (Const AValue :String;
          Const ASeparators :Array Of String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitHexInts (Const AValue :String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitHexInts (Const AValue :String;
          Const ASeparators :Array Of String; Const ADefaultValue :Integer;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitHexInts (Const AValue :String;
          Const ADefaultValue :Integer;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitInts (Const AValue :String;
          Const ASeparators :Array Of String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitInts (Const AValue :String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitInts (Const AValue :String;
          Const ASeparators :Array Of String; Const ADefaultValue :Integer;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitInts (Const AValue :String;
          Const ADefaultValue :Integer;
          Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
          Overload; Static;
        Class Function SplitStrs (Const AValue :String;
          Const ASeparators :Array Of String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <String>;
          Overload; Static;
        Class Function SplitStrs (Const AValue :String;
          Const AIncludeEmpties :Boolean = System.False) :TArray <String>;
          Overload; Static;
        Class Function StartsDupChr (Const AValue :String;
          Const AChr :Char) :Boolean; Static;
        Class Function StartsDupChrSafe (Const AValue :String;
          Const AChr :Char) :Boolean; Static;
        Class Function StrBool (Const AValue :String) :Boolean; Static;
        Class Function StrFloat (Const AValue :String) :Double; Static;
        Class Function StrIndex (Const AValue, ASubStr :String;
          Const AStart :Integer = 1;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Integer; Overload; Static;
        Class Function StrIndex (Const AValue, ASubStr :String;
          Const AComparisonType :TStrComparison) :Integer; Overload;
          Static;
        Class Function StrInt (Const AValue :String) :Integer; Static;
        Class Function StrInt64 (Const AValue :String) :Int64; Static;
        Class Function StrOLEVar (Const AValue :String) :OLEVariant;
        Class Function StrPos (Const AValues :Array Of String;
          Const AValue :String; Const AStart :Integer = 0;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Integer; Static;
        Class Function StrsEqual (Const AValue1, AValue2 :String;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Boolean; Static;
        Class Function StrsInts (Const AValues :Array Of String)
          :TArray <Integer>; Overload; Static;
        Class Function StrsInts (Const AValues :Array Of String;
          Const ADefaultValue :Integer) :TArray <Integer>; Overload;
          Static;
        Class Function StrsInts (Const AValues :Array Of String;
          Const APrefix :String) :TArray <Integer>; Overload; Static;
        Class Function StrsInts (Const AValues :Array Of String;
          Const APrefix :String; Const ADefaultValue :Integer)
          :TArray <Integer>; Overload; Static;
        Class Function StrStarts (Const AValue, ASubStr :String;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Boolean; Static;
        Class Function StrStartsSub (Const AValue, ASubStr :String;
          Const AComparisonType :TStrComparison =
          TStrComparison.eOrdAnyCase) :Boolean; Static;
        Class Function StrVar (Const AValue :String) :Variant; Static;
        Class Function SubStr (Const AValue :String;
          Const AStartIndex, AEndIndex :Integer) :String; Static;
        Class Function SwapChrs (Const AValue :TTwoChrs) :TTwoChrs; Static;
        Class Function SwitchBits (
          Const AValue, AOffMask, AOnMask :Integer) :Integer; Static;
          Inline;
        Class Function SymmetricRange (Const ALimit :Integer) :TTwoInts;
          Static;
        Class Function Ternary (Const AValue :Boolean) :TTernary; Static;{}//Inline
        Class Function TurnBits (Const AValue, AMask :Integer;
          Const ACond :Boolean) :Integer; Static;{}//Inline
        Class Function TurnBitsOff (Const AValue, AMask :Integer) :Integer;
          Static; Inline;
        Class Function TurnBitsOffIf (Const ACond :Boolean;
          Const AValue, AMask :Integer) :Integer; Static; Inline;
        Class Function TurnBitsOnIf (Const ACond :Boolean;
          Const AValue, AMask :Integer) :Integer; Static; Inline;
        Class Function TVarRecsVar (Const AValues :Array Of Const)
          :Variant;
        Class Function URLPort (Const AURL :String) :Integer; Static;
        Class Function URLPortIndex (Const AURL :String;
          Out ALength :Integer) :Integer; Static;
        Class Function URLScheme (Const AURL :String) :String; Static;
        Class Function URLSchemeDomainLength (Const AURL :String) :Integer;
          Static;
        Class Function URLSchemeLength (Const AURL :String) :Integer;
          Static;
        Class Function ValueChr (Const AChr1, AChr2 :Char) :Char; Static;
          Inline;
        Class Function ValuesEqual <T> (Const AValue1, AValue2 :T)
          :Boolean; Static;
        Class Function VarArr (Const ASize :Integer;
          Const AType :TVarType = System.varVariant;
          Const AllowLessThanTwo :Boolean = System.True) :Variant;
          Overload; Static;
        Class Function VarArr (Const ASize :Integer;
          Const AAllowLessThanTwo :Boolean) :Variant; Overload; Static;
        Class Function VerifyChr (Const AValue, AMatch :Char) :TTernary;
          Static;
        Class Function VerifyChrs (Const AValue1, AValue2, AMatch :Char)
          :TTwoTernaries; Static;
        Class Function VerifyConcatAffixes (Const AValue1, AValue2 :String;
          Const AAffix :Char) :TTwoTernaries; Static;

        { Class properties }
        Class Property ExePath :TFileName Read GetExePath;
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
    GHF.ENLang, GHF.SysEx, GHF.RTTI, System.Variants, System.Math,
    System.Generics.Defaults, System.StrUtils, GHF.Obs
    {$If Defined (MSWindows)}
    , GHF.Win
    {$EndIf}
    ;

  {}//reordenar métodos por clase alfabéticamente (con excepción de Inlines)

  { Inline routines }

  Procedure TghSys.TMethodHelper.ghClear;
  Begin
    Self := System.Default (TMethod);
  End;

  Procedure TghSys.TAnyKindMethod.Init;
  Begin
    { NOTE: This method must be called when begin to use a TAnyKindMethod
      instance, if it could contain invalid (garbage) data. }

    FNormal.ghClear;
  End;

  Procedure TghSys.TAnyKindMethod.Clear;
  Begin
    If Not ClearRef Then
      Init;
  End;

  {}//inline
  Function TghSys.TMethodHelper.ghGetDataClass :TClass;
  Begin
    Result := Data;
  End;

  {}//inline
  Function TghSys.TMethodHelper.ghGetDataObj :TObject;
  Begin
    Result := Data;
  End;

  Function TghSys.TMethodHelper.ghGetIsEmpty :Boolean;
  Begin
    //Result := (Code = Nil) And (Data = Nil);  // Usual code
    Result := NativeInt (Code) Or NativeInt (Data) = 0;  // More optimal
  End;

  Function TghSys.TAnyKindMethod.GetIsEmpty :Boolean;
  Begin
    Result := FNormal.ghIsEmpty;
  End;

  Function TghSys.TAnyKindMethod.GetIsRef :Boolean;
  Begin
    Result := (FRef <> Nil) And (FNormal.Data = Nil);
  End;

  Function TghSys.TAnyKindMethod.GetNormal :PMethod;
  Begin
    If IsRef Then
      Result := @NilMethod
    Else
      Result := @FNormal;
  End;

  Function TghSys.TAnyKindMethod.GetRef :Pointer;
  Begin
    If IsRef Then
      Result := FRef
    Else
      Result := Nil;
  End;

  Procedure TghSys.TAnyKindMethod.SetNormal (Const AValue :PMethod);
  Begin
    ClearRef;
    FNormal := AValue^;
  End;

  Procedure TghSys.TAnyKindMethod.SetRef (Const AValue :Pointer);
  Begin
    ClearNormal;
    IInterface (FRef) := IInterface (AValue);  // _IntfCopy
  End;

  Class Procedure TghSys.Clear (Var ABool1, ABool2 :Boolean);
  Begin
    ABool1 := System.False;
    ABool2 := System.False;
  End;

  Class Procedure TghSys.Clear (Var AInt1, AInt2 :Integer);
  Begin
    AInt1 := 0;
    AInt2 := 0;
  End;

  Class Procedure TghSys.Clear (Var AInt :Integer; Var ABool :Boolean);
  Begin
    AInt := 0;
    ABool := System.False;
  End;

  Class Procedure TghSys.Clear (Var APtr; Var ABool :Boolean);
  Begin
    Pointer (APtr) := Nil;
    ABool := System.False;
  End;

  Class Procedure TghSys.Clear (Var APtr; Var AInt :Integer);
  Begin
    Pointer (APtr) := Nil;
    AInt := 0;
  End;

  Class Procedure TghSys.Clear (Var APtr; Var AInt :Cardinal);
  Begin
    Pointer (APtr) := Nil;
    AInt := 0;
  End;

  Class Procedure TghSys.Clear (Var APtr1, APtr2);
  Begin
    Pointer (APtr1) := Nil;
    Pointer (APtr2) := Nil;
  End;

  Class Function TghSys.GetIntf (Var AIntf; Const AID :TGUID) :Boolean;
  Begin
    Result := GetIntf (IInterface (AIntf), AID, AIntf);
  End;

  Class Function TghSys.GetSetAncestor (Var AClass; Const AValue :TClass)
    :TClass;
  Begin
    Result := TClass (AClass).ghCheckAncestor (AValue).ghGetSetClassTo (
      AClass);
  End;

  Class Function TghSys.GetSetDescendant (Var AClass; Const AValue :TClass)
    :TClass;
  Begin
    Result := TClass (AClass).ghCheckDescendant (AValue).ghGetSetClassTo (
      AClass);
  End;

  Class Function TghSys.GetSetMod (Var AInt :Integer;
    Const ADivisor :Integer) :Integer;
  Begin
    Result := AInt;
    AInt := AInt Mod ADivisor;{}//o "Result Mod ADivisor" según tamaño
  End;

  Class Function TghSys.HasBitOn (Const AValue, AMask :Integer) :Boolean;
  Begin
    Result := (AValue And AMask) <> 0;
  End;

  Class Function TghSys.HasBitOn (Const AValue :Integer;
    Const AMask :Cardinal) :Boolean;
  Begin
    { Cardinal version to avoid some "Constant expression violates subrange
      bounds" warnings }

    Result := (AValue And AMask) <> 0;
  End;

  Class Function TghSys.HasBitsOn (Const AValue, AMask :Integer) :Boolean;
  Begin
    Result := (AMask <> 0) And ((AValue And AMask) = AMask);
  End;

  Class Function TghSys.IfThen (Const ACond :Boolean; Const AValue1 :Char;
    Const AValue2 :Char = #0) :Char;
  Begin
    If ACond Then
      Result := AValue1
    Else
      Result := AValue2;
  End;

  Class Function TghSys.IfThen (Const ACond :Boolean;
    Const AValue1 :Pointer; Const AValue2 :Pointer = Nil) :Pointer;
  Begin
    If ACond Then
      Result := AValue1
    Else
      Result := AValue2;
  End;

  {}//revisar desbordamientos, y probar tamaño con System.Inc en lugar de +
  Class Function TghSys.Inc (Var AInt :Cardinal; Const AInc :Integer = 1)
    :Cardinal;
  Begin
    AInt := Int64 (AInt) + AInc;
    Result := AInt;
  End;

  {}//revisar desbordamientos, y probar tamaño con System.Inc en lugar de +
  Class Function TghSys.Inc (Var AInt :Integer; Const AInc :Integer = 1)
    :Integer;
  Begin
    AInt := AInt + AInc;
    Result := AInt;
  End;

  {}//revisar desbordamientos, y probar tamaño con System.Inc en lugar de +
  Class Function TghSys.Inc (Var AInt :Word; Const AInc :Integer = 1)
    :Word;
  Begin
    AInt := AInt + AInc;
    Result := AInt;
  End;

  Class Function TghSys.Intf (Const AIntf :IInterface; Const AID :TGUID)
    :IInterface;
  Begin
    AIntf.QueryInterface (AID, Result);
  End;

  Class Function TghSys.IsIndex (Const AValue, ACount :Integer) :Boolean;
  Begin
    Result := (AValue >= 0) And (AValue < ACount);
  End;

  Class Function TghSys.Keep (Var AInt :Integer; Const ACond :Boolean)
    :Boolean;
  Begin
    If Not SetBool (Result, ACond) Then
      AInt := 0;
  End;

  Class Function TghSys.Keep (Var APtr; Const ACond :Boolean) :Boolean;
  Begin
    If Not SetBool (Result, ACond) Then
      Pointer (APtr) := Nil;
  End;

  {}//buscar la mejor forma inline
  Class Function TghSys.Keep (Var APtr; Const ACond :Boolean;
    Out AFlag :Boolean) :Boolean;
  Begin
    Result := Keep (APtr, SetBool (AFlag, ACond));
    //Result := SetBool (AFlag, Keep (APtr, ACond));
  End;

  Class Function TghSys.Keep (Var AStr :String; Const ACond :Boolean)
    :Boolean;
  Begin
    If Not SetBool (Result, ACond) Then
      AStr := '';
  End;

  Class Function TghSys.Modulize (Var AInt :Integer;
    Const ADivisor :Integer) :Integer;
  Begin
    Result := AInt Mod ADivisor;
    AInt := Result;{}//o al revés si es menos CPU
  End;

  Class Function TghSys.Negate (Var AInt :Integer) :Integer;
  Begin
    {}//revisar tamaño invertido
    AInt := Not AInt;
    Result := AInt;
  End;

  Class Function TghSys.RawCast <TSource, TDest> (Const AValue :TSource)
    :TDest;
  Begin
    If System.SizeOf (TDest) <= System.SizeOf (TSource) Then
      Result := TDest ((@AValue)^)
    Else
      RaiseTypecast <TSource, TDest>;
  End;

  Class Function TghSys.RightDigits (Const AValue :String;
    Const AMaxLength :Integer = System.MaxInt) :String;
  Begin
    Result := RightChrs (AValue, dgtDecimals, AMaxLength);
  End;

  Class Function TghSys.RightDigitsDots (Const AValue :String;
    Const AMaxLength :Integer = System.MaxInt) :String;
  Begin
    Result := RightChrs (AValue, chrDotDecimals, AMaxLength);
  End;

  Class Function TghSys.SetBool (Out ABool :Boolean; Const AValue :Boolean)
    :Boolean;
  Begin
    ABool := AValue;

    { NOTE: For this inline method "Result := ABool" can be more efficient
      than "Result := AValue", if AValue is an expression involving
      compiler magic. }
    Result := ABool;
  End;

  Class Function TghSys.SetChr (Out AChr :Char; Const AValue :Char) :Char;
  Begin
    AChr := AValue;

    { NOTE: For this inline method "Result := AChr" can be more efficient
      than "Result := AValue", if AValue is an expression involving
      compiler magic. }
    Result := AChr;
  End;

  {}//que devuelva valor anterior (GetSet)
  Class Procedure TghSys.SetGUIDRef (Const ARef :Pointer;
    Const AValue :TGUID);
  Begin
    If ARef <> Nil Then
      PGUID (ARef)^ := AValue;
  End;

  Class Function TghSys.SetCardinal (Out AInt :Cardinal;
    Const AValue :Cardinal) :Cardinal;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "Result := AInt" can be more
      efficient than "Result := AValue", if AValue is an expression
      involving compiler magic. }
    Result := AInt;
  End;

  Class Function TghSys.SetInt (Out AInt :Integer; Const AValue :Integer)
    :Integer;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "Result := AInt" can be more efficient
      than "Result := AValue", if AValue is an expression involving
      compiler magic. }
    Result := AInt;
  End;

  Class Function TghSys.SetIntCardinal (Out AInt :Integer;
    Const AValue :Integer) :Boolean;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "AInt >= 0" can be more efficient than
      "AValue >= 0", if AValue is an expression involving compiler magic. }
    Result := AInt >= 0;{}//o "> -1" según tamaño compilado
  End;

  {}//que devuelva valor anterior (GetSet)
  Class Procedure TghSys.SetIntf (Var AIntf; Const AValue :Pointer);
  Begin
    IInterface (AIntf) := IInterface (AValue);
  End;

  Class Function TghSys.SetPtr (Out APtr; Const AValue :Pointer) :Pointer;
  Begin
    Result := Pointer (APtr).ghSetValue (AValue);
  End;

  Class Function TghSys.SetSolid (Out AChr :Char; Const AValue :Char)
    :Boolean;
  Begin
    AChr := AValue;

    { NOTE: For this inline method "AChr <> #0" can be more efficient than
      "AValue <> #0", if AValue is an expression involving compiler
      magic. }
    Result := AChr <> #0;
  End;

  Class Function TghSys.SetSolid (Out AInt :Cardinal;
    Const AValue :Cardinal) :Boolean;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "AInt > 0" can be more efficient than
      "AValue > 0", if AValue is an expression involving compiler magic. }
    Result := AInt > 0;
  End;

  Class Function TghSys.SetSolid (Out AInt :Integer; Const AValue :Integer)
    :Boolean;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "AInt <> 0" can be more efficient than
      "AValue <> 0", if AValue is an expression involving compiler magic. }
    Result := AInt <> 0;
  End;

  Class Function TghSys.SetSolid (Out APtr; Const AValue :Pointer)
    :Boolean;
  Begin
    Result := Pointer (APtr).ghSetSolid (AValue);
  End;

  Class Function TghSys.SetSolid (Out APtr; Const AValue :Pointer;
    Out AFlag :Boolean) :Boolean;
  Begin
    Result := Pointer (APtr).ghSetSolid (AValue, AFlag);
  End;

  {}//revisar tamaño considerando acción del Out en el llamador
  Class Function TghSys.SetSolid (Out AStr :String; Const AValue :String)
    :Boolean;
  Begin
    AStr := AValue;

    { NOTE: For this inline method "AStr <> ''" can be more efficient than
      "AValue <> ''", if AValue is an expression involving compiler
      magic. }
    Result := AStr <> '';
  End;

  Class Function TghSys.ShiftPtr (Var APtr1, APtr2) :Pointer;
  Begin
    Result := Pointer (APtr1).ghShift (APtr2);
  End;

  Class Function TghSys.TurnBitsOff (Const AValue, AMask :Integer)
    :Integer;
  Begin
    Result := AValue And Not AMask;
  End;

  Class Function TghSys.SwitchBits (
    Const AValue, AOffMask, AOnMask :Integer) :Integer;
  Begin
    Result := TurnBitsOff (AValue, AOffMask) Or AOnMask;
  End;

  Class Function TghSys.TurnBitsOffIf (Const ACond :Boolean;
    Const AValue, AMask :Integer) :Integer;
  Begin
    If ACond Then
      Result := AValue And Not AMask
    Else
      Result := AValue;
  End;

  Class Function TghSys.TurnBitsOnIf (Const ACond :Boolean;
    Const AValue, AMask :Integer) :Integer;
  Begin
    If ACond Then
      Result := AValue Or AMask
    Else
      Result := AValue;
  End;

  {}//comprobar mejor forma de inline
  Class Function TghSys.ValueChr (Const AChr1, AChr2 :Char) :Char;
  Begin
    If SetChr (Result, AChr1) = #0 Then
      Result := AChr2;
  End;

  { TghSys }

  { TghSys.TAnyKindMethod }

  Function TghSys.TAnyKindMethod.ClearNormal :Boolean;
  Begin
    If SetBool (Result, Not IsRef) Then
      Init;
  End;

  Function TghSys.TAnyKindMethod.ClearRef :Boolean;
  Begin
    { NOTE: This method must be called when finish to use a TAnyKindMethod
      instance, if it could contain a method reference. }

    If SetBool (Result, IsRef) Then
      IInterface (FRef) := Nil;  // _IntfClear
  End;

  { TghSys.TPANSICharHelper }

  Procedure TghSys.TPANSICharHelper.ghSetRef (Const AValue :ANSIString);
  Begin
    PANSIString (@Self)^ := AValue;
  End;

  Procedure TghSys.TPANSICharHelper.ghClearRef;
  Begin
    ghSetRef ('');
  End;

  { TghSys.TPointerHelper }

  Function TghSys.TPointerHelper.ghClear (Const ASize :Integer) :Integer;
  Begin
    System.FillChar (Self^, ASize, 0);
    Result := ASize;
  End;

  Function TghSys.TPointerHelper.ghFill (Const ASize :Integer;
    Const AValue :Byte = $FF) :Integer;
  Begin
    System.FillChar (Self^, ASize, AValue);
    Result := ASize;
  End;

  Procedure TghSys.TPointerHelper.ghFree;
  Begin
    System.FreeMem (Self);
  End;

  Function TghSys.TPointerHelper.ghGetAsInt :NativeInt;
  Begin
    Result := NativeInt (Self);
  End;

  Function TghSys.TPointerHelper.ghGetAsVar :Variant;
  Begin
    If Self <> Nil Then
      Result := NativeUInt (Self)
    Else
      Result := System.Variants.Null;
  End;

  Function TghSys.TPointerHelper.ghGetSet (Const AValue :Pointer) :Pointer;
  Begin
    Result := Self;
    Self := AValue;
  End;

  Function TghSys.TPointerHelper.ghOffset (Const AInc :Integer) :Pointer;
  Begin
    If Self <> Nil Then
      Result := Pointer (ghAsInt + AInc)
    Else
      Result := Nil;
  End;

  Function TghSys.TPointerHelper.ghOffsetBy <T> :Pointer;
  Begin
    Result := ghOffset (System.SizeOf (T));
  End;

  {}//o sin llamar a SetSolid si es tamaño menor
  Function TghSys.TPointerHelper.ghSetBlank (Const AValue :Pointer) :Boolean;
  Begin
    Result := Not ghSetSolid (AValue);
  End;

  Function TghSys.TPointerHelper.ghSetSolid (Const AValue :Pointer)
    :Boolean;
  Begin
    Self := AValue;

    { NOTE: For this inline method "Self <> Nil" can be more efficient than
      "AValue <> Nil", if AValue is an expression involving compiler
      magic. }
    Result := Self <> Nil;
  End;

  Function TghSys.TPointerHelper.ghSetSolid (Const AValue :Pointer;
    Out AFlag :Boolean) :Boolean;
  Begin
    Self := AValue;

    { NOTE: For this inline method "Self <> Nil" can be more efficient than
      "AValue <> Nil", if AValue is an expression involving compiler
      magic. }
    Result := Self <> Nil;

    AFlag := Result;
  End;

  Function TghSys.TPointerHelper.ghSetValue (Const AValue :Pointer)
    :Pointer;
  Begin
    Self := AValue;

    { NOTE: For this inline method "Result := Self" can be more efficient
      than "Result := AValue", if AValue is an expression involving
      compiler magic. }
    Result := Self;
  End;

  Function TghSys.TPointerHelper.ghShift (Var APtr) :Pointer;
  Begin
    Result := Self;
    Self := Pointer (APtr);
    Pointer (APtr) := Nil;
  End;

  { TghSys.TRegExHelper }

  Class Function TghSys.TRegExHelper.ghIsMatchClear (
    Const AValue, ARegularExpr :String) :Boolean;
  Begin
    Result := IsMatch (AValue, ARegularExpr,
      [System.RegularExpressions.roIgnoreCase,
      System.RegularExpressions.roExplicitCapture]);
  End;

  { TghSys.TStrComparisonEx }

  Function TghSys.TStrComparisonEx.PredIf (Const ACond :Boolean)
    :TStrComparison;
  Begin
    If ACond Then
      Result := System.Pred (Self)
    Else
      Result := Self;
  End;

  Function TghSys.TStrComparisonEx.SuccIf (Const ACond :Boolean)
    :TStrComparison;
  Begin
    If ACond Then
      Result := System.Succ (Self)
    Else
      Result := Self;
  End;

  { TghSys.TStringDynArrayHelper }

  Function TghSys.TStringDynArrayHelper.ghGetData :Pointer;
  Begin
    Result := Self;
  End;

  Function TghSys.TStringDynArrayHelper.ghGetLength :Integer;
  Begin
    Result := System.Length (Self);
  End;

  Function TghSys.TStringDynArrayHelper.ghSetHigh (Const AValue :Integer)
    :Integer;
  Begin
    Self.ghLength := AValue + 1;
    Result := AValue;
  End;

  Function TghSys.TStringDynArrayHelper.ghSetLength (Const AValue :Integer)
    :Integer;
  Begin
    Self.ghLength := AValue;
    Result := AValue;
  End;

  Procedure TghSys.TStringDynArrayHelper.ghSetLengthProp (
    Const AValue :Integer);
  Begin
    System.SetLength (Self, AValue);
  End;

  { TghSys.TTwoChrs }

  Function TghSys.TTwoChrs.HasValues (Const AValue1, AValue2 :Char)
    :Boolean;
  Begin
    Result := (Value1 = AValue1) And (Value2 = AValue2);
  End;

  Function TghSys.TTwoChrs.IsDup (Const AValue :Char) :Boolean;
  Begin
    Result := (Value1 = AValue) And (Value2 = AValue);
  End;

  { TghSys.TTwoInts }

  Procedure TghSys.TTwoInts.SetValues (Const A1, A2 :Integer);
  Begin
    Value1 := A1;
    Value2 := A2;
  End;

  { TghSys.TTwoTernariesEx }

  Function TghSys.TTwoTernariesEx.GetValue (Const AIndex :Integer)
    :TTernary;
  Begin
    Result := TghSys.TArr2 <TghSys.TTernary> (Self) [AIndex];
  End;

  Procedure TghSys.TTwoTernariesEx.SetValue (Const AIndex :Integer;
    Const AValue :TTernary);
  Begin
    TghSys.TArr2 <TghSys.TTernary> (Self) [AIndex] := AValue;
  End;

  { TghSys.TVarDataHelper }

  Function TghSys.TVarDataHelper.ghGetAsVar :PVariant;
  Begin
    Result := PVariant (@Self);
  End;

  Function TghSys.TVarDataHelper.ghStrLength :Integer;
  Begin
    Case VType Of
      System.varOLEStr  : Result := System.Length (VOLEStr);
      System.varString  : Result := System.Length (ANSIString (VString));
      System.varUString : Result := String (VUString).Length;
      Else
        Result := 0;
    End;
  End;

  { TghSys.TVariantHelper }

  Function TghSys.TVariantHelper.ghBool (
    Const ADefaultResult :Boolean = System.False) :Boolean;
  Begin
    If ghHasValue Then
      If ghIsStr Then
        Result := TghSys.StrBool (Self)
      Else
        Result := Self
    Else
      Result := ADefaultResult;
  End;

  Function TghSys.TVariantHelper.ghDimLength (Const ADim :Integer) :Integer;
  Begin
    Result := (ghHigh (ADim) - ghLow (ADim)) + 1;
  End;

  Function TghSys.TVariantHelper.ghElement (Const APos :Integer = 0)
    :Variant;
  Begin
    If ghIsArr Then
      Result := Self [ghLow + APos]
    Else
    Begin
      TghSys.CheckInt (APos, 0);
      Result := Self;
    End;
  End;

  Function TghSys.TVariantHelper.ghFindData :PVarData;
  Begin
    Result := System.Variants.FindVarData (Self);
  End;

  Function TghSys.TVariantHelper.ghFindSolidData (Out AData :PVarData)
    :Boolean;
  Begin
    AData := ghFindData;
    Result := AData.VType > System.varNull;
  End;

  Function TghSys.TVariantHelper.ghFloat :Double;
  Begin
    If ghIsNull Then
      Result := 0
    Else
      If ghIsStr Then
        Result := TghSys.StrFloat (Self)
      Else
        Result := Self;
  End;

  Function TghSys.TVariantHelper.ghFloat (Const ADefaultResult :Double)
    :Double;
  Begin
    If ghHasValue Then
      If ghIsStr Then
        Result := TghSys.StrFloat (Self)
      Else
        Result := Self
    Else
      Result := ADefaultResult;
  End;

  {}//probar
  Function TghSys.TVariantHelper.ghGetArr (Out AArr :PVarArray;
    Out AType :TVarType) :Boolean;
  Var
    LData :TVarData Absolute Self;
  Begin
    If LData.VType = (System.varByRef Or System.varVariant) Then
      Result := PVariant (LData.VPointer)^.ghGetArr (AArr, AType)
    Else
    Begin
      AType := LData.VType And System.varTypeMask;

      If TghSys.Keep (
      AArr, TghSys.HasBitOn (LData.VType, System.varArray), Result) Then
        If TghSys.HasBitOn (LData.VType, System.varByRef) Then
          AArr := TghSys.PPVarArray (LData.VPointer)^
        Else
          AArr := LData.VArray;
    End;
  End;

  Function TghSys.TVariantHelper.ghGetData :PVarData;
  Begin
    Result := @Self;
  End;

  Function TghSys.TVariantHelper.ghGetVector (Out AArr :PVarArray;
    Out AType :TVarType) :Boolean;
  Begin
    Result := ghGetArr (AArr, AType) And (AArr.DimCount = 1);
  End;

  Function TghSys.TVariantHelper.ghHasValue :Boolean;
  Var
    LData :PVarData;
  Begin
    Result := ghFindSolidData (LData) And Not LData.ghAsVar^.ghIsClear;
  End;

  Function TghSys.TVariantHelper.ghHigh (Const ADim :Integer = 1)
    :Integer;
  Begin
    Result := System.Variants.VarArrayHighBound (Self, ADim);
  End;

  Function TghSys.TVariantHelper.ghInt (Const ADefaultResult :Integer = 0)
    :Integer;
  Begin
    If ghHasValue Then
      If ghIsStr Then
        Result := TghSys.StrInt (Self)
      Else
        Result := System.Trunc (Self)
    Else
      Result := ADefaultResult;
  End;

  Function TghSys.TVariantHelper.ghInt64 (Const ADefaultResult :Int64 = 0)
    :Int64;
  Begin
    If ghHasValue Then
      If ghIsStr Then
        Result := TghSys.StrInt64 (Self)
      Else
        Result := System.Trunc (Self)
    Else
      Result := ADefaultResult;
  End;

  Function TghSys.TVariantHelper.ghIsArr :Boolean;
  Begin
    Result := System.Variants.VarIsArray (Self);
  End;

  Function TghSys.TVariantHelper.ghIsBlank :Boolean;
  Begin
    Result := ghFindData.VType <= System.varNull;  // varEmpty or varNull
  End;

  Function TghSys.TVariantHelper.ghIsBytes :Boolean;
  Begin
    Result := ghIsVectorType (System.varByte);
  End;

  Function TghSys.TVariantHelper.ghIsBytes (Const AMaxLength :Integer)
    :Boolean;
  Begin
    Result := ghIsVectorType (System.varByte, AMaxLength);
  End;

  Function TghSys.TVariantHelper.ghIsClear :Boolean;
  Begin
    Result := System.Variants.VarIsClear (Self);
  End;

  Function TghSys.TVariantHelper.ghIsEmpty :Boolean;
  Begin
    Result := System.Variants.VarIsEmpty (Self);
  End;

  Function TghSys.TVariantHelper.ghIsEqual (Const AValue :Variant)
    :Boolean;
  Begin
    Result := (ghData.VType = AValue.ghData.VType) And (Self = AValue);
  End;

  Function TghSys.TVariantHelper.ghIsInt :Boolean;
  Begin
    Result := TghSys.IsVarTypeInt (ghFindData.VType);
  End;

  Function TghSys.TVariantHelper.ghIsNull :Boolean;
  Begin
    Result := System.Variants.VarIsNull (Self);
  End;

  Function TghSys.TVariantHelper.ghIsSolid :Boolean;
  Begin
    Result := ghFindData.VType > System.varNull;
  End;

  Function TghSys.TVariantHelper.ghIsStr :Boolean;
  Begin
    Result := System.Variants.VarIsStr (Self);
  End;

  Function TghSys.TVariantHelper.ghIsStr (Out AData :PVarData) :Boolean;
  Begin
    ADAta := ghFindData;
    Result := TghSys.IsVarTypeStr (AData.VType);
  End;

  Function TghSys.TVariantHelper.ghIsStr (Out AData :PVarData;
    Const AMaxLength :Integer) :Boolean;
  Begin
    Result := ghIsStr (AData) And (AData.ghStrLength <= AMaxLength);
  End;

  Function TghSys.TVariantHelper.ghIsStr (Const AMaxLength :Integer)
    :Boolean;
  Var
    LData :PVarData;
  Begin
    Result := ghIsStr (LData, AMaxLength);
  End;

  Function TghSys.TVariantHelper.ghIsUnsignedInt :Boolean;
  Begin
    Result := ghFindData.VType In TghSys.vrtUnsignedInts;
  End;

  Function TghSys.TVariantHelper.ghIsUnsignedInt32 :Boolean;
  Begin
    Result := ghFindData.VType In TghSys.vrtUnsignedInts32;
  End;

  {}//probar
  Function TghSys.TVariantHelper.ghIsValueUnsignedInt :Boolean;
  Begin
    Result := ghIsInt And (Self >= 0);
  End;

  {}//probar
  Function TghSys.TVariantHelper.ghIsValueUnsignedInt32 :Boolean;
  Begin
    Result := ghIsInt And (Self >= 0) And (Self <= Cardinal.MaxValue);
  End;

  Function TghSys.TVariantHelper.ghIsVector (Out AType :TVarType) :Boolean;
  Var
    LArr :PVarArray;
  Begin
    Result := ghGetVector (LArr, AType);
  End;

  Function TghSys.TVariantHelper.ghIsVector :Boolean;
  Begin
    Result := ghIsVector (TghSys.DummyWord);
  End;

  Function TghSys.TVariantHelper.ghIsVectorMax (Out AType :TVarType;
    Const ALength :Integer) :Boolean;
  Var
    LArr :PVarArray;
  Begin
    Result := ghGetVector (LArr, AType) And
      (LArr.Bounds [0].ElementCount <= ALength);
  End;

  Function TghSys.TVariantHelper.ghIsVectorMax (Const ALength :Integer)
    :Boolean;
  Begin
    Result := ghIsVectorMax (TghSys.DummyWord, ALength);
  End;

  Function TghSys.TVariantHelper.ghIsVectorType (Const AType :TVarType)
    :Boolean;
  Var
    LType :TVarType;
  Begin
    Result := ghIsVector (LType) And (LType = AType);
  End;

  Function TghSys.TVariantHelper.ghIsVectorType (Const AType :TVarType;
    Const AMaxLength :Integer) :Boolean;
  Var
    LType :TVarType;
  Begin
    Result := ghIsVectorMax (LType, AMaxLength) And (LType = AType);
  End;

  Function TghSys.TVariantHelper.ghLength (Const ADim :Integer = 1)
    :Integer;
  Begin
    If ghIsArr Then
      Result := ghDimLength (ADim)
    Else
      Result := TghSys.CheckInt (ADim, 1);
  End;

  Function TghSys.TVariantHelper.ghLow (Const ADim :Integer = 1)
    :Integer;
  Begin
    Result := System.Variants.VarArrayLowBound (Self, ADim);
  End;

  Function TghSys.TVariantHelper.ghSetBlank (Const AValue :Variant)
    :Boolean;
  Begin
    Self := AValue;
    Result := ghIsBlank;
  End;

  Procedure TghSys.TVariantHelper.ghSetElement (Const APos :Integer;
    Const AValue :Variant);
  Begin
    If ghIsArr Then
      Self [ghLow + APos] := AValue
    Else
    Begin
      TghSys.CheckInt (APos, 0);
      Self := AValue;
    End;
  End;

  Function TghSys.TVariantHelper.ghSetSolid (Const AValue :Variant)
    :Boolean;
  Begin
    Self := AValue;
    Result := ghIsSolid;
  End;

  Function TghSys.TVariantHelper.ghStr (Const ADefaultResult :String = '')
    :String;
  Begin
    Result := System.Variants.VarToStrDef (Self, ADefaultResult);
  End;

  Function TghSys.TVariantHelper.ghUInt64 (
    Const ADefaultResult :UInt64 = 0) :UInt64;
  Begin
    Result := UInt64 (ghInt64 (ADefaultResult));
  End;

  { TghSys.TVarRecHelper }

  Function TghSys.TVarRecHelper.ghGetAsOLEVar :OLEVariant;
  Begin
    Result := OLEVariant (ghAsVar);
  End;

  Function TghSys.TVarRecHelper.ghGetAsVar :Variant;
  Begin
    If Not ghGetVar (Result) Then
      Result := System.Variants.Null;
  End;

  Function TghSys.TVarRecHelper.ghGetVar (Var AVar :Variant) :Boolean;
  Begin
    Result := TghSys.Virtual.GetTVarRecVar (Self, AVar);
  End;

  { TghSys.TVirtual }

  Class Function TghSys.TVirtual.CompareValuesEqual (
    Const AValue1, AValue2; Const ATypeInfo :PTypeInfo;
    Out AEqual :Boolean) :Boolean;
  Begin
    Result := False;
  End;

  Class Function TghSys.TVirtual.ComponentInteract (AComponent :TComponent;
    AInteractive :Boolean = System.True) :Boolean;
  Var
    LState :TComponentState Absolute AComponent;
  Begin
    LState := AComponent.ComponentState * [System.Classes.csLoading,
      System.Classes.csWriting, System.Classes.csDestroying,
      System.Classes.csUpdating];
    Result := (AInteractive And (LState = [])) Or
      (Not AInteractive And (LState <> []));
  End;

  Class Function TghSys.TVirtual.GetTVarRecVar (
    Const AValue :TVarRec; Var AVar :Variant) :Boolean;
  Begin
    Case AValue.VType Of
      System.vtInteger       : AVar := AValue.VInteger;
      System.vtBoolean       : AVar := AValue.VBoolean;
      System.vtChar          : AVar := AValue.VChar;
      System.vtExtended      : AVar := AValue.VExtended^;
      System.vtString        : AVar := AValue.VString^;
      System.vtPointer       : AVar := AValue.VPointer.ghAsVar;
      System.vtPChar         : AVar := ANSIString (AValue.VPChar);
      System.vtObject        : AVar := PtrVar (AValue.VObject);
      System.vtClass         : AVar := PtrVar (AValue.VClass);
      System.vtWideChar      : AVar := AValue.VWideChar;
      System.vtPWideChar     : AVar := WideString (AValue.VPWideChar);
      System.vtANSIString    : AVar := ANSIString (AValue.VANSIString);
      System.vtCurrency      : AVar := AValue.VCurrency^;
      System.vtVariant       : AVar := AValue.VVariant^;
      System.vtInterface     : AVar := IInterface (AValue.VInterface);
      System.vtWideString    : AVar := WideString (AValue.VWideString);
      System.vtInt64         : AVar := AValue.VInt64^;
      System.vtUnicodeString : AVar := String (AValue.VUnicodeString);
      Else
        System.Exit (System.False);
    End;

    Result := System.True;
  End;

  {}//probar
  Class Function TghSys.TVirtual.InternalParentPath (Const APath :String;
    AUpLevels :Integer; ADelim :Char) :String;
  Var
    I :Integer Absolute AUpLevels;
    LEndsDelim :Boolean;
  Begin
    If Not SetBool (LEndsDelim, EndChr (APath) = ADelim) And
    (AUpLevels < 1) Then
      Result := APath
    Else
    Begin
      If AUpLevels > 0 Then
        I := ChrIndexOneLast (
          APath, ADelim, AUpLevels + System.Ord (LEndsDelim))
      Else
        I := APath.Length;

      If Keep (Result, I > 0) Then
        Result := System.StrUtils.LeftStr (APath, I - 1);
    End;
  End;

  {}//probar
  Class Function TghSys.TVirtual.InternalResolveFilePath (
    Const AValue :String) :String;
  Begin
    {$If Defined (MSWindows)}
    If AValue [1] = System.SysUtils.PathDelim Then
      // \XXX -> <ExeDrive>:\XXX
      System.Exit (TghWin.ExeRootPath (AValue));

    If TghWin.PathHintsDrive (AValue) Then  // C:\XXX, E:XXX, \\XXX\XXX\XXX
    {$Else}
    If AValue [1] = System.SysUtils.PathDelim Then  // /...
    {$EndIf}
      System.Exit (AValue);

    // ..\XXX -> <ExeDirPath>\..\XXX, XXX -> <ExeDirPath>/XXX
    Result := ExeDerivedPath (AValue);
  End;

  Class Function TghSys.TVirtual.InternalStrIndex (
    Const AValue, ASubStr :String; AStart :Integer;
    AComparisonType :TStrComparison) :Integer;
  Var
    LValue, LSubStr :String;
  Begin
    LValue := AValue;
    LSubStr := ASubStr;
    PrepareBinComparison (LValue, LSubStr, AComparisonType);
    Result := System.Pos (LSubStr, LValue, AStart);
  End;

  Class Procedure TghSys.TVirtual.PrepareBinComparison (Var AStr :String;
    AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase);
  Begin
    Case AComparisonType Of
      TStrComparison.eOrdAnyCase    : AStr := AStr.LowerCase (AStr);
      TStrComparison.eLocaleAnyCase : AStr := AStr.ToLower;

      TStrComparison.eSimple        :
        AStr := TghSys.DefaultLang.SimpleStr (AStr);

      TghSys.TStrComparison.eSimpleAnyCase :
        AStr := TghSys.DefaultLang.LowerSimpleStr (AStr);
    End;
  End;

  Class Procedure TghSys.TVirtual.PrepareBinComparison (
    Var AStr1, AStr2 :String;
    AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase);
  Begin
    PrepareBinComparison (AStr1, AComparisonType);
    PrepareBinComparison (AStr2, AComparisonType);
  End;

  Class Function TghSys.TVirtual.RightVersion (Const AValue :String;
    AMaxLength :Integer = System.MaxInt) :String;
  Begin
    Result := NotPrefixed (RightDigitsDots (AValue, AMaxLength), '.');
  End;

  { Constructors and destructors }

  Class Constructor TghSys.Create;
  Begin
    TVirtual.ghInitVirtualClass (FVirtual);
    FDefaultLang := TghENLang;
  End;

  Class Destructor TghSys.Destroy;
  Begin
    Finalized := System.True;
    TVirtual.ghFinalizeVirtualClass;
  End;

  { Protected static class methods }

  Class Function TghSys.GetExePath :TFileName;
  Begin
    If FExePath = '' Then
      FExePath := System.ParamStr (0);

    Result := FExePath;
  End;

  Class Procedure TghSys.SetVirtual (Const AValue :TVirtual.TClassRef);
  Begin
    TVirtual.ghSetVirtualClass (AValue);
  End;

  { Public static class methods }

  Class Function TghSys.AbsMax (Const AValue1, AValue2 :Integer) :Integer;
  Begin
    Result := System.Abs (System.Math.Max (AValue1, AValue2));
  End;

  Class Function TghSys.AbsMin (Const AValue1, AValue2 :Integer) :Integer;
  Begin
    Result := System.Abs (System.Math.Min (AValue1, AValue2));
  End;

  Class Function TghSys.ANSIStrPtr (Const AValue :ANSIString) :Pointer;
  Asm
    // NOTE: This method is OK, it has no explicit code.
  End;

  Class Function TghSys.AreBlank (Const APtr1, APtr2 :Pointer) :Boolean;
  Begin
    Result := NativeInt (APtr1) Or NativeInt (APtr2) = 0;
  End;

  Class Function TghSys.AreSolid (Const APtr1, APtr2 :Pointer) :Boolean;
  Begin
    Result := (APtr1 <> Nil) And (APtr2 <> Nil);
  End;

  Class Function TghSys.AreSolid (Const AStr1, AStr2 :String) :Boolean;
  Begin
    Result := (AStr1 <> '') And (AStr2 <> '');
  End;

  Class Function TghSys.BitOn (Const AValue, ABit :Integer) :Boolean;
  Begin
    Result := (AValue And (1 ShL ABit)) <> 0;
  End;

  {}//probar
  Class Function TghSys.BitValues (Const AValue :Integer)
    :TArray <Integer>;
  Var
    I, J :Integer;
  Begin
    J := -1;
    System.SetLength (Result, 32);

    For I := 0 To 31 Do
      If HasBitOn (AValue, 1 ShL I) Then
        Result [Inc (J)] := 1 ShL I;

    System.SetLength (Result, J + 1);
  End;

  {}//probar
  Class Function TghSys.BlankSetTo (Var APtr1; Out APtr2) :Pointer;
  Begin
    Result := Pointer (APtr2).ghSetValue (Pointer (APtr1).ghGetSet (Nil));
  End;

  ///probar
  Class Function TghSys.BytesAdd (Const AValues :Array Of Byte;
    Const AValue :Byte) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 1);
    BytesEndBytePtr (Result)^ := AValue;
  End;

  ///probar
  Class Function TghSys.BytesAdd (Const AValues :Array Of Byte;
    Const AValue :Pointer; Const ACount :Integer) :TBytes;
  Var
    LLength :Integer;
  Begin
    If TghSys.SetSolid (LLength, System.Length (AValues)) Then
      Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, ACount)
    Else
      System.SetLength (Result, ACount);

    If ACount > 0 Then
      System.Move (AValue^, Result [LLength], ACount);
  End;

  ///probar
  Class Function TghSys.BytesAdd (Const AValues1 :Array Of Byte;
    Const AValues2 :Array Of Byte) :TBytes;
  Begin
    Result := BytesAdd (AValues1, @AValues2 [0], System.Length (AValues2));
  End;

  {}//probar
  Class Function TghSys.BytesAddInt (Const AValues :Array Of Byte;
    Const AValue :Integer) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 4);
    BytesEndIntPtr (Result)^ := AValue;
  End;

  {}//probar
  Class Function TghSys.BytesAddInt64 (Const AValues :Array Of Byte;
    Const AValue :Int64) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 8);
    BytesEndInt64Ptr (Result)^ := AValue;
  End;

  {}//probar
  Class Function TghSys.BytesAddWord (Const AValues :Array Of Byte;
    Const AValue :Word) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 2);
    BytesEndWordPtr (Result)^ := AValue;
  End;

  {}//probar
  Class Function TghSys.BytesAddWordGUID (Const AValues :Array Of Byte;
    Const AValue1 :Word; Const AValue2 :TGUID) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 18);
    BytesEndWordPtr (Result, 8)^ := AValue1;
    BytesEndGUIDPtr (Result)^ := AValue2;
  End;

  {}//probar
  Class Function TghSys.BytesAddWordInt (Const AValues :Array Of Byte;
    Const AValue1 :Word; Const AValue2 :Integer) :TBytes;
  Begin
    Result := TArray.ghCopy <Byte> (AValues, 0, System.MaxInt, 6);
    BytesEndWordPtr (Result, 2)^ := AValue1;
    BytesEndIntPtr (Result)^ := AValue2;
  End;

  Class Function TghSys.BytesEndBytePtr (Const AValue :TBytes) :PByte;
  Begin
    Result := @AValue [System.High (AValue)];
  End;

  Class Function TghSys.BytesEndGUIDPtr (Const AValue :TBytes) :PGUID;
  Begin
    Result := @AValue [System.High (AValue) - 15];
  End;

  Class Function TghSys.BytesEndInt (Const AValues :Array Of Byte)
    :Integer;
  Begin
    Result := PInteger (@AValues [System.High (AValues) - 3])^;
  End;

  Class Function TghSys.BytesEndInt64Ptr (Const AValue :TBytes) :PInt64;
  Begin
    Result := @AValue [System.High (AValue) - 7];
  End;

  Class Function TghSys.BytesEndIntPtr (Const AValue :TBytes) :PInteger;
  Begin
    Result := @AValue [System.High (AValue) - 3];
  End;

  Class Function TghSys.BytesEndWordPtr (Const AValue :TBytes) :PWord;
  Begin
    Result := @AValue [System.High (AValue) - 1];
  End;

  {}//probar
  Class Function TghSys.BytesEndWordPtr (Const AValue :TBytes;
    Const AReverseIndex :Integer) :PWord;
  Begin
    Result := @AValue [System.High (AValue) -
      System.Succ (AReverseIndex * 2)];
  End;

  Class Function TghSys.Call <TItem> (
    Const AProc :TEnumerationProcRef <TItem>; Const AItem :TItem;
    Const ADefaultResult :Boolean = System.False) :Boolean;
  Begin
    If Assigned (AProc) Then
    Begin
      Result := System.True;
      AProc (AItem, Result);
    End
    Else
      Result := ADefaultResult;
  End;

  Class Procedure TghSys.CheckDesigning (Const AValue :Boolean);
  Begin
    If Not AValue Then
      EInvalidOpException.ghRaise (ermOperationInvalidRunTime);
  End;

  {}//probar y/u optimizar
  Class Function TghSys.CheckInc (Var AInt :Cardinal;
    Const AInc :Integer = 1) :Cardinal;
  Begin
    CheckInRange (Int64 (AInt) + Int64 (AInc), 0, Cardinal.MaxValue);
    Result := Inc (AInt, AInc);
  End;

  {}//probar y/u optimizar
  Class Function TghSys.CheckInc (Var AInt :Integer;
    Const AInc :Integer = 1) :Integer;
  Begin
    CheckInRange (
      Int64 (AInt) + Int64 (AInc), Integer.MinValue, System.MaxInt);
    Result := Inc (AInt, AInc);
  End;

  {}//probar y/u optimizar
  Class Function TghSys.CheckInc (Var AInt :Word; Const AInc :Integer = 1)
    :Word;
  Begin
    CheckInRange (AInt + AInc, Word.MinValue, Word.MaxValue);
    Result := Inc (AInt, AInc);
  End;

  Class Function TghSys.CheckIndex (Const AValue, ACount :Integer) :Integer;
  Begin
    If Not IsIndex (AValue, ACount) Then
      RaiseIndexOutOfRange (AValue);

    Result := AValue;
  End;

  {}//revisar forma de menor tamaño
  Class Function TghSys.CheckIndex (Const AValue :Integer) :Integer;
  Begin
    If AValue < 0 Then
      RaiseIndexOutOfRange (AValue);

    Result := AValue;
  End;

  Class Function TghSys.CheckIndexOf <T> (
    Const AMethod :TConstFuncMethod <T, Integer>; Const AValue :T)
    :Integer;
  Begin
    Result := CheckIndexOfResult <T> (AMethod (AValue));
  End;

  Class Function TghSys.CheckIndexOf <T> (
    Const AMethod :TValueFuncMethod <T, Integer>; Const AValue :T)
    :Integer;
  Begin
    Result := CheckIndexOfResult <T> (AMethod (AValue));
  End;

  Class Function TghSys.CheckIndexOfResult <T> (Const AValue :Integer)
    :Integer;
  Begin
    If AValue < 0 Then
      EArgumentException.ghRaiseType <T> (ermItemNotFound);

    Result := AValue;
  End;

  Class Function TghSys.CheckInRange (Const AValue :Integer;
    Const AMinValue, AMaxValue :Integer) :Integer;
  Begin
    If Not System.Math.InRange (AValue, AMinValue, AMaxValue) Then
      RaiseOutOfRange ('Integer value', AValue.ToString);{}//RaiseIntValueOutOfRange

    Result := AValue;
  End;

  Class Function TghSys.CheckInRange (Const AValue :Int64;
    Const AMinValue, AMaxValue :Int64) :Int64;
  Begin
    If Not System.Math.InRange (AValue, AMinValue, AMaxValue) Then
      RaiseOutOfRange ('Integer value', AValue.ToString);{}//RaiseIntValueOutOfRange

    Result := AValue;
  End;

  Class Function TghSys.CheckInRanges (Const AValue :Integer;
    Const ARanges :Array Of Integer) :Integer;
  Begin
    If Not InRanges (AValue, ARanges) Then
      RaiseOutOfRange ('Integer value', AValue.ToString);{}//RaiseIntValueOutOfRange

    Result := AValue;
  End;

  {}//revisar forma de menor tamaño
  Class Function TghSys.CheckInt (Const AInt, AValue :Integer) :Integer;
  Begin
    If AInt <> AValue Then
      RaiseExpectedGiven (AValue, AInt);

    Result := AInt;
  End;

  Class Function TghSys.CheckMin (Const AValue :Integer;
    Const AMin :Integer) :Integer;
  Begin
    Result := CheckInRange (AValue, AMin, System.MaxInt);
  End;

  Class Procedure TghSys.CheckRunning (Const AValue :Boolean);
  Begin
    If Not AValue Then
      EInvalidOpException.ghRaise (ermOperationInvalidDesignTime);
  End;

  Class Function TghSys.CheckWord (Const AValue :Integer) :Integer;
  Begin
    Result := CheckInRange (AValue, Word.MinValue, Word.MaxValue);
  End;

  Class Function TghSys.Chr (Const AValue :ANSIChar) :Char;
  Begin
    Result := String (AValue) [1];
  End;

  Class Function TghSys.ChrGroupIndex (Const AValue :String;
    Const AChrs :TSysCharSet; Const ACheckIndex :Integer) :Integer;
  Begin
    Result := ChrIndexIfIs (AValue, ACheckIndex, AChrs);

    While (Result > 1) And
    System.SysUtils.CharInSet (AValue [Result - 1], AChrs) Do
      System.Dec (Result);
  End;

  Class Function TghSys.ChrIndex (Const AValue :String; Const AChr :Char;
    Const AStart :Integer = 1) :Integer;
  Begin
    For Result := AStart To AValue.Length Do
      If AValue [Result] = AChr Then
        System.Exit;

    Result := 0;
  End;

  Class Function TghSys.ChrIndex (Const AValue :String;
    Const AChrs :TSysCharSet; Const AStart :Integer = 1) :Integer;
  Begin
    For Result := AStart To AValue.Length Do
      If System.SysUtils.CharInSet (AValue [Result], AChrs) Then
        System.Exit;

    Result := 0;
  End;

  Class Function TghSys.ChrIndexIfIs (Const AValue :String;
    Const AIndex :Integer; Const AChrs :TSysCharSet) :Integer;
  Begin
    If Keep (
    Result, System.SysUtils.CharInSet (ChrOf (AValue, AIndex), AChrs)) Then
      Result := AIndex;
  End;

  Class Function TghSys.ChrIndexLast (Const AValue :String;
    Const AChr :Char; Const AStart :Integer = 1) :Integer;
  Begin
    For Result := AValue.Length DownTo AStart Do
      If AValue [Result] = AChr Then
        System.Exit;

    Result := 0;
  End;

  Class Function TghSys.ChrIndexOneLast (Const AValue :String;
    Const AChr :Char; Occurrence :Integer; Const AStart :Integer = 1)
    :Integer;
  Begin
    If Occurrence > 0 Then
      For Result := AValue.Length DownTo AStart Do
        If (AValue [Result] = AChr) And (Inc (Occurrence, -1) = 0) Then
          System.Exit;

    Result := 0;
  End;

  Class Function TghSys.ChrOf (Const AValue :String;
    Const AIndex :Integer = 1) :Char;
  Begin
    If IsIndex (AIndex, AValue) Then
      Result := AValue [AIndex]
    Else
      Result := #0;
  End;

  Class Function TghSys.ChrOfEnd (Const AValue :String;
    Const AReverseIndex :Integer = 1) :Char;
  Begin
    Result := ChrOf (AValue, AValue.Length - System.Pred (AReverseIndex));
  End;

  Class Function TghSys.ChrPlus (Const AValue :Char; Const AInc :Integer)
    :Char;
  Begin
    Result := Char (System.Ord (AValue) + AInc);
  End;

  Class Function TghSys.ClearEqual (Var AInt :Cardinal;
    Const AValue :Cardinal) :Boolean;
  Begin
    If TghSys.SetBool (Result, AInt = AValue) Then
      AInt := 0;
  End;

  Class Procedure TghSys.ClearIndexBytes (Var AIndex :Integer;
    Var AByte1, AByte2);
  Begin
    AIndex := -1;
    Byte (AByte1) := 0;
    Byte (AByte2) := 0;
  End;

  Class Procedure TghSys.ClearIndexInt (Var AIndex :Integer; Var AInt);
  Begin
    AIndex := -1;
    Integer (AInt) := 0;
  End;

  Class Function TghSys.ClearMem (Const AMem :Pointer;
    Const ASize :Integer) :Integer;
  Begin
    Result := AMem.ghClear (ASize);
  End;

  Class Function TghSys.CommaConcat (Const AValues :Array Of String;
    Const AIncludeEmpties :Boolean = System.False) :String;
  Begin
    If AIncludeEmpties Then
      Result := String.Join (', ', AValues)
    Else
      Result := Concat (AValues, ', ');
  End;

  Class Function TghSys.CommaConcatHexInts (
    Const AValues :Array Of Integer) :String;
  Begin
    Result := ConcatHexInts (AValues, ', ');
  End;

  Class Function TghSys.CommaConcatInts (Const AValues :Array Of Integer)
    :String;
  Begin
    Result := ConcatInts (AValues, ', ');
  End;

  {}//probar
  {$Warn No_RetVal Off}
  Class Function TghSys.CompareStrs (Const AValue1, AValue2 :String;
    Const AType :TStrComparison) :Integer;
  Begin
    Case AType Of
      TStrComparison.eOrd : Result := AValue1.CompareTo (AValue2);

      TStrComparison.eOrdAnyCase :
        Result := System.SysUtils.CompareText (AValue1, AValue2);

      TStrComparison.eLocale :
        Result := System.SysUtils.ANSICompareStr (AValue1, AValue2);

      TStrComparison.eLocaleAnyCase :
        Result := System.SysUtils.ANSICompareText (AValue1, AValue2);

      TStrComparison.eSimple :
        Result := CompareStrsSimple (AValue1, AValue2);

      TStrComparison.eSimpleAnyCase :
        Result := CompareStrsSimple (AValue1, AValue2, System.True);
    End;
  End;
  {$Warn No_RetVal On}

  {}//probar, y para caso "DefaultLang := TghESLang" (ñ)
  Class Function TghSys.CompareStrsSimple (Const AValue1, AValue2 :String;
    Const AAnyCase :Boolean = System.False) :Integer;
  Begin
    Result := CompareStrs (
      DefaultLang.SimpleStr (AValue1), DefaultLang.SimpleStr (AValue2),
      TStrComparison.eLocale.SuccIf (AAnyCase));
  End;

  Class Function TghSys.Concat (Const AValue1, AValue2 :String;
    Const ASeparator :String = ' ') :String;
  Begin
    If (AValue1 <> '') And (AValue2 <> '') Then
      Result := AValue1 + ASeparator + AValue2
    Else
      Result := AValue1 + AValue2;
  End;

  Class Function TghSys.Concat (Const AValue1, AValue2, ASeparator :String;
    Const AIncludeEmpties :Boolean) :String;
  Begin
    If AIncludeEmpties Then
      Result := AValue1 + ASeparator + AValue2
    Else
      Result := Concat (AValue1, AValue2, ASeparator);
  End;

  {}//probar
  Class Function TghSys.Concat (Const AValues :Array Of String;
    Const ASeparator :String = ' ') :String;
  Var
    I :Integer;
  Begin
    { NOTE: Use String.Join instead of this method if empty strings should
      be included. }

    // [], ',' -> ''
    If System.Length (AValues) = 0 Then
      System.Exit ('');

    // ['foo', '', 'bar'], ',' -> 'foo,bar'

    Result := AValues [0];

    For I := 1 To System.High (AValues) Do
      Result := Concat (Result, AValues [I], ASeparator);
  End;

  Class Function TghSys.ConcatChrs (Const AValue1, AValue2 :Char;
    Const AReverse :Boolean) :String;
  Begin
    If AReverse Then
      Result := AValue2 + AValue1
    Else
      Result := AValue1 + AValue2;
  End;

  Class Function TghSys.ConcatFilePaths (Const APath1, APath2 :String)
    :String;
  Begin
    Result := ConcatVerifyAffixes (
      APath1, APath2, System.SysUtils.PathDelim);
  End;

  {}//probar
  Class Function TghSys.ConcatHexInts (Const AValues :Array Of Integer;
    Const ASeparator :String = ' ') :String;
  Var
    I :Integer;
  Begin
    If System.Length (AValues) = 0 Then
      System.Exit ('');

    Result := AValues [0].ToHexString;

    For I := 1 To System.High (AValues) Do
      Result := Result + ASeparator + AValues [I].ToHexString;
  End;

  {}//probar
  Class Function TghSys.ConcatInts (Const AValues :Array Of Integer;
    Const ASeparator :String = ' ') :String;
  Var
    I :Integer;
  Begin
    If System.Length (AValues) = 0 Then
      System.Exit ('');

    Result := AValues [0].ToString;

    For I := 1 To System.High (AValues) Do
      Result := Result + ASeparator + AValues [I].ToString;
  End;

  {}//probar
  Class Function TghSys.ConcatVerifyAffixes (
    Const AValue1, AValue2 :String; Const ASeparator :Char) :String;
  Begin
    Case VerifyConcatAffixes (AValue1, AValue2, ASeparator) Of
      TTwoTernaries.eUndefinedUndefined : Result := '';  // Empty strings
      TTwoTernaries.eFalseUndefined     : Result := AValue1;
      TTwoTernaries.eTrueUndefined      : Result := DeleteRight (AValue1);
      TTwoTernaries.eUndefinedFalse     : Result := AValue2;

      TTwoTernaries.eFalseFalse         :
        Result := AValue1 + ASeparator + AValue2;

      TTwoTernaries.eUndefinedTrue      :
        Result := System.Copy (AValue2, 2);

      TTwoTernaries.eTrueTrue           :
        Result := AValue1 + System.Copy (AValue2, 2);

      Else  // eTrueFalse/eFalseTrue
        Result := AValue1 + AValue2;
    End;
  End;

  {}//pendiente
  Class Function TghSys.ConcatVerifyAffixes (
    Const AValue1, AValue2, ASeparator :String) :String;
  Begin
  End;

  ///probar
  Class Function TghSys.CopyMem <T> (Const ASource :T;
    Const ADest :Pointer) :Integer;
  Begin
    Result := System.SizeOf (T);
    System.Move (ASource, ADest^, Result);
  End;

  ///probar
  Class Function TghSys.Correlative (Const Value :Integer;
    Const Base1 :Boolean = System.False) :Integer;
  Begin
    Result := Value + TghSys.SignedOne (Not Odd (Value) XOr Base1);
  End;

  Class Function TghSys.DeleteRight (Const AValue :String;
    Const AChrs :Integer = 1) :String;
  Begin
    Result := System.StrUtils.LeftStr (AValue, AValue.Length - AChrs);
  End;

  {}//probar
  Class Function TghSys.DerivedFilePath (Const APath :String;
    Const AUpLevels :Integer; Const ASubPath :String) :String;
  Begin
    Result := TghSys.ConcatFilePaths (
      ParentFilePath (APath, AUpLevels), ASubPath);
  End;

  Class Function TghSys.DerivedFilePath (Const APath, ASubPath :String)
    :String;
  Begin
    Result := DerivedFilePath (APath, 1, ASubPath);
  End;

  {}//probar
  Class Function TghSys.DerivedPath (Const APath :String;
    Const AUpLevels :Integer; Const ASubPath :String;
    Const ADelim :Char = System.SysUtils.PathDelim) :String;
  Begin
    Result := ConcatVerifyAffixes (
      ParentPath (APath, AUpLevels, ADelim), ASubPath, ADelim);
  End;

  Class Function TghSys.DerivedPath (Const APath, ASubPath :String;
    Const ADelim :Char = System.SysUtils.PathDelim) :String;
  Begin
    Result := DerivedPath (APath, 1, ASubPath, ADelim);
  End;

  Class Function TghSys.DivCeil (Const ADividend, ADivisor :Integer)
    :Integer;
  Begin
    Result := (ADividend + (ADivisor - 1)) Div ADivisor;
  End;

  Class Function TghSys.EnclosedStr (Const AValue, ASubStr :String)
    :String;
  Begin
    Result := ASubStr + AValue + ASubStr;
  End;

  Class Function TghSys.EndChr (Const AValue :String;
    Const AReverseIndex :Integer = 1) :Char;
  Begin
    Result := AValue [AValue.Length - System.Pred (AReverseIndex)];
  End;

  Class Function TghSys.EnsureCardinal (Const AValue :Integer) :Integer;
  Begin
    If AValue >= 0 Then
      Result := AValue
    Else
      Result := 0;
  End;

  Class Function TghSys.EnsureIndex (Const AValue, ACount :Integer)
    :Integer;
  Begin
    Result := System.Math.EnsureRange (AValue, 0, ACount - 1);
  End;

  Class Function TghSys.EnsureIndexMax (Const AValue, ACount :Integer) :Integer;
  Begin
    Result := System.Math.Min (AValue, ACount - 1);
  End;

  Class Function TghSys.EnsureIndexMin (Const AValue :Integer) :Integer;
  Begin
    Result := System.Math.Max (AValue, 0);
  End;

  Class Function TghSys.ExeDerivedPath (Const AUpLevels :Integer;
    Const ASubPath :String) :String;
  Begin
    Result := DerivedFilePath (ExePath, AUpLevels, ASubPath);
  End;

  Class Function TghSys.ExeDerivedPath (Const ASubPath :String) :String;
  Begin
    Result := ExeDerivedPath (1, ASubPath);
  End;

  Class Function TghSys.ExpandFilePath (Const AValue :String) :String;
  Begin
    // ..\XXX -> <ExeParentDirPath>\XXX
    Result := System.SysUtils.ExpandFileName (ResolveFilePath (AValue));
  End;

  Class Function TghSys.FileExists (Const APath :String;
    Const ASpecialAttrs :Integer = 0) :Boolean;
  Begin
    Result := FirstFile (APath, ASpecialAttrs, System.True).Name <> '';
  End;

  Class Function TghSys.FileExists (Const ADir, AMask :String;
    Const ASpecialAttrs :Integer = 0) :Boolean;
  Begin
    Result := FirstFile (ADir, AMask, ASpecialAttrs, System.True).Name <> '';
  End;

  Class Function TghSys.FirstFile (Const APath :String;
    Const ASpecialAttrs :Integer = 0;
    Const ACloseHandle :Boolean = System.False) :TSearchRec;
  Begin
    If System.SysUtils.FindFirst (APath, ASpecialAttrs, Result) <> 0 Then
      Result.Name := ''  // No file found
    Else
      If ACloseHandle Then
        // FindClose invalidates the Result.FindHandle field only
        System.SysUtils.FindClose (Result);
  End;

  Class Function TghSys.FirstFile (Const APath :String;
    Const ACloseHandle :Boolean) :TSearchRec;
  Begin
    Result := FirstFile (APath, 0, ACloseHandle);
  End;

  Class Function TghSys.FirstFile (Const ADir, AMask :String;
    Const ASpecialAttrs :Integer = 0;
    Const ACloseHandle :Boolean = System.False) :TSearchRec;
  Begin
    Result := FirstFile (
      ConcatFilePaths (ADir, AMask), ASpecialAttrs, ACloseHandle);
  End;

  Class Function TghSys.FirstFile (Const ADir, AMask :String;
    Const ACloseHandle :Boolean) :TSearchRec;
  Begin
    Result := FirstFile (ADir, AMask, 0, ACloseHandle);
  End;

  Class Function TghSys.FormatISODate (Const AValue :TDateTime) :String;
  Begin
    Result := System.SysUtils.FormatDateTime (fmtISODate, AValue);
  End;

  Class Function TghSys.FormatISODate :String;
  Begin
    Result := FormatISODate (System.SysUtils.Date);
  End;

  Class Function TghSys.FormatISODateTime (Const AValue :TDateTime)
    :String;
  Begin
    Result := System.SysUtils.FormatDateTime (fmtISODateTime, AValue);
  End;

  Class Function TghSys.FormatISODateTime :String;
  Begin
    Result := FormatISODateTime (System.SysUtils.Now);
  End;

  Class Function TghSys.FormatISOTime (Const AValue :TDateTime) :String;
  Begin
    Result := System.SysUtils.FormatDateTime (fmtISOTime, AValue);
  End;

  Class Function TghSys.FormatISOTime :String;
  Begin
    Result := FormatISOTime (System.SysUtils.Time);
  End;

  Class Function TghSys.FormatStdDateTime (Const AValue :TDateTime)
    :String;
  Begin
    Result := System.SysUtils.FormatDateTime (fmtStdDateTime, AValue);
  End;

  Class Function TghSys.FormatStdDateTime :String;
  Begin
    Result := FormatStdDateTime (System.SysUtils.Now);
  End;

  Class Procedure TghSys.FreeClear (Const AObjs :Array Of PObject;
    Const AUnmakeRefs :Boolean = False);
  Var
    LObj :PObject;
  Begin
    For LObj In AObjs Do
    Begin
      If AUnmakeRefs Then
        TghObs.UnmakeObjRef (LObj^);

      System.SysUtils.FreeAndNil (LObj^);
    End;
  End;

  Class Procedure TghSys.FreeClear_ <T> (Var ARef :T;
    Const AUnmakeObjRef :Boolean = False);
  Begin
    TghRTTI.Info <T>.ghFreeValue (ARef, AUnmakeObjRef);
    ARef := System.Default (T);
  End;

  Class Function TghSys.GetIntf (Const AValue :IInterface;
    Const AID :TGUID; Var AIntf) :Boolean;
  Var
    LIntf :IInterface;
  Begin
    If SetBool (Result, AValue.QueryInterface (AID, LIntf) = S_OK) Then
      IInterface (AIntf) := LIntf;
  End;

  Class Function TghSys.GetObj (Const AIntf :IInterface; Var AObj)
    :Boolean;
  Begin
    Result := SetSolid (AObj, TObject (AIntf));
  End;

  Class Function TghSys.GetSetInt (Var AInt :Integer;
    Const AValue :Integer) :Integer;
  Begin
    Result := AInt;
    AInt := AValue;
  End;

  Class Function TghSys.GetSetInt64 (Var AInt64 :Int64;
    Const AValue :Int64) :Int64;
  Begin
    Result := AInt64;
    AInt64 := AValue;
  End;

  Class Function TghSys.GetSetPtr (Var APtr; Const AValue :Pointer)
    :Pointer;
  Begin
    Result := Pointer (APtr).ghGetSet (AValue);
  End;

  Class Function TghSys.GetStrPos (Const AValues :Array Of String;
    Const AValue :String; Out APos :Integer;
    Const AStart :Integer = 0;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Boolean;
  Begin
    Result := SetIntCardinal (
      APos, StrPos (AValues, AValue, AStart, AComparisonType));
  End;

  Class Function TghSys.GUIDPos (Const AValues :Array Of TGUID;
    Const AValue :TGUID; Const AStart :Integer = 0) :Integer;
  Begin
    For Result := AStart To System.High (AValues) Do
      If GUIDsEqual (AValues [Result], AValue) Then
        System.Exit;

    Result := -1;
  End;

  Class Function TghSys.GUIDsEqual (Const AValue1, AValue2 :TGUID) :Boolean;
  Var
    LGUID1 :Array [0..3] Of Integer Absolute AValue1;
    LGUID2 :Array [0..3] Of Integer Absolute AValue2;
  Begin
    Result := (LGUID1 [0] = LGUID2 [0]) And (LGUID1 [1] = LGUID2 [1]) And
      (LGUID1 [2] = LGUID2 [2]) And (LGUID1 [3] = LGUID2 [3]);
  End;

  Class Function TghSys.GUIDsEqualFromD2 (Const AValue1, AValue2 :TGUID)
    :Boolean;
  Var
    LGUID1 :Array [0..3] Of Integer Absolute AValue1;
    LGUID2 :Array [0..3] Of Integer Absolute AValue2;
  Begin
    Result := (LGUID1 [1] = LGUID2 [1]) And (LGUID1 [2] = LGUID2 [2]) And
      (LGUID1 [3] = LGUID2 [3]);
  End;

  Class Function TghSys.GUIDsIn (Const AValues, AGroup :Array Of TGUID)
    :Boolean;
  Var
    LValue :TGUID;
  Begin
    For LValue In AValues Do
      If GUIDPos (AGroup, LValue) = -1 Then
        System.Exit (System.False);

    Result := System.True;
  End;

  Class Function TghSys.HasBitOff (Const AValue, AMask :Integer) :Boolean;
  Begin
    Result := (AValue And AMask) <> AMask;
  End;

  Class Function TghSys.HasBitOnOff (
    Const AValue, AOnMask, AOffMask :Integer) :Boolean;
  Begin
    Result := HasBitOn (AValue, AOnMask) And HasBitOff (AValue, AOffMask);
  End;

  Class Function TghSys.HasBitsOn (Const AValue :Integer;
    Const AMasks :Array Of Integer) :Boolean;
  Var
    LMask :Integer;
  Begin
    For LMask In AMasks Do
      If HasBitsOn (AValue, LMask) Then
        System.Exit (System.True);

    Result := System.False;
  End;

  Class Function TghSys.HighBit (Const AValue :Integer) :Integer;
  Asm
    BSR EAX, EAX  // 1 -> 0, 2..3 -> 1, 4..7 -> 2, 8..15 -> 3,...
    JNZ @Exit
    Mov EAX, $FFFFFFFF  // Return -1 when Value is zero
    @Exit:
  End;

  Class Function TghSys.IncBy <T> (Var AInt :Integer) :Integer;
  Begin
    Result := Inc (AInt, System.SizeOf (T));
  End;

  Class Function TghSys.IncBySelected <T1, T2> (Var AInt :Integer;
    Const ACond :Boolean) :Integer;
  Begin
    If ACond Then
      Result := IncBy <T2> (AInt)
    Else
      Result := IncBy <T1> (AInt);
  End;

  Class Function TghSys.IncIfGreater (Const AValue1, AValue2 :Integer;
    Const AInc :Integer; Const ADefaultResult :Integer) :Integer;
  Begin
    If AValue1 > AValue2 Then
      Result := AValue1 + AInc
    Else
      Result := ADefaultResult;
  End;

  Class Function TghSys.IncIfGreater (Const AValue1, AValue2 :Integer;
    Const AInc :Integer = 1) :Integer;
  Begin
    Result := IncIfGreater (AValue1, AValue2, AInc, AValue1);
  End;

  Class Function TghSys.IncIfPositive (Const AValue :Integer;
    Const AInc :Integer; Const ADefaultResult :Integer) :Integer;
  Begin
    Result := IncIfGreater (AValue, 0, AInc, ADefaultResult);
  End;

  Class Function TghSys.IncIfPositive (Const AValue :Integer;
    Const AInc :Integer = 1) :Integer;
  Begin
    Result := IncIfGreater (AValue, 0, AInc);
  End;

  Class Function TghSys.IncSelected (Var AInt1, AInt2 :Integer;
    Const ACond :Boolean) :Boolean;
  Begin
    Result := ACond;

    If Result Then
      System.Inc (AInt2)
    Else
      System.Inc (AInt1);
  End;

  Class Function TghSys.IncWhen (Var AInt :Integer; Const ACond :Boolean;
    Const AInc :Integer = 1) :Boolean;
  Begin
    If TghSys.SetBool (Result, ACond) Then
      AInt := AInt + AInc;
  End;

  Class Function TghSys.IndexLeftOfOptional (Const AValue :String;
    Const AChr :Char; Const AStartIndex :Integer = 1) :Integer;
  Begin
    Result := ChrIndex (AValue, AChr, AStartIndex) - 1;

    If Result = -1 Then
      Result := AValue.Length;
  End;

  Class Function TghSys.IndexRightOfOptionalURLScheme (Const AURL :String)
    :Integer;
  Begin
    // https://... -> 9, en.wikipedia.org -> 1
    Result := IncIfPositive (URLSchemeLength (AURL), 4, 1);
  End;

  {}//probar
  Class Function TghSys.InRanges (Const AValue :Integer;
    Const ARanges :Array Of Integer) :Boolean;
  Var
    I :Integer;
  Begin
    For I := 0 To System.High (ARanges) Div 2 Do
      If System.Math.InRange (
      AValue, ARanges [I * 2], ARanges [(I * 2) + 1]) Then
        System.Exit (True);

    Result := False;
  End;

  Class Function TghSys.InsertStr (Const AValue, ASubStr :String;
    Const AIndex :Integer) :String;
  Begin
    Result := AValue;
    System.Insert (ASubStr, Result, AIndex);
  End;

  {}//probar incluso con Integer.MinValue
  Class Function TghSys.InSymmetricRange (Const AValue, ALimit :Integer)
    :Boolean;
  Var
    LRange :TTwoInts;
  Begin
    LRange := SymmetricRange (ALimit);
    Result := System.Math.InRange (
      AValue, LRange.LowValue, LRange.HighValue);
  End;

  Class Function TghSys.IntVar (Const AValue :Integer) :Variant;
  Begin
    If AValue = 0 Then
      Result := System.Variants.Null
    Else
      Result := AValue;
  End;

  Class Function TghSys.IsIndex (Const AValue :Integer; Const AStr :String)
    :Boolean;
  Begin
    Result := (AValue > 0) And (AValue <= AStr.Length);
  End;

  Class Function TghSys.IsIndex (Const AValue :Integer;
    Const AStr :ANSIString) :Boolean;
  Begin
    Result := (AValue > 0) And (AValue <= System.Length (AStr));
  End;

  Class Function TghSys.IsIndex (Const AValue :Integer;
    Const AStr :WideString) :Boolean;
  Begin
    Result := (AValue > 0) And (AValue <= System.Length (AStr));
  End;

  Class Function TghSys.IsSolidDifferent (Const AValue :Pointer;
    Const AComparisonValue :Pointer) :Boolean;
  Begin
    Result := (AValue <> Nil) And (AValue <> AComparisonValue);
  End;

  Class Function TghSys.IsVarTypeInt (Const AType :TVarType) :Boolean;
  Begin
    Result := AType In [System.varSmallInt, System.varInteger,
      System.varShortInt, System.varByte, System.varWord,
      System.varLongWord, System.varInt64, System.varUInt64];
  End;

  Class Function TghSys.IsVarTypeStr (Const AType :TVarType) :Boolean;
  Begin
    Result := (AType = System.varOleStr) Or (AType = System.varString) Or
      (AType = System.varUString);
  End;

  Class Function TghSys.KeepIndex (Var AInt :Integer; Const ACond :Boolean)
    :Boolean;
  Begin
    If Not SetBool (Result, ACond) Then
      AInt := -1;
  End;

  Class Function TghSys.LastSysErrorMsg :String;
  Begin
    Result := System.SysUtils.SysErrorMessage (System.GetLastError);
  End;

  Class Function TghSys.LeftOf (Const AValue :String; Const AChr :Char;
    Const AStartIndex :Integer = 1) :String;
  Begin
    Result := SubStr (
      AValue, AStartIndex, ChrIndex (AValue, AChr, AStartIndex) - 1);
  End;

  Class Function TghSys.LeftOfOptional (Const AValue :String;
    Const AChr :Char; Const AStartIndex :Integer = 1) :String;
  Begin
    Result := SubStr (AValue, AStartIndex,
      IndexLeftOfOptional (AValue, AChr, AStartIndex));
  End;

  Class Function TghSys.LeftRightOfOptional (Const AValue :String;
    Const AChr :Char) :TTwoStrs;
  Var
    I :Integer;
  Begin
    I := ChrIndex (AValue, AChr);

    If I = 0 Then
    Begin
      Result.Value1 := AValue;
      Result.Value2 := '';
    End
    Else
    Begin
      Result.Value1 := System.StrUtils.LeftStr (AValue, I - 1);
      Result.Value2 := System.Copy (AValue, I + 1);
    End;
  End;

  Class Function TghSys.LeftRightOfOptionalEx (
    Const AValue, ASubStr :String;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :TTwoStrs;
  Var
    I :Integer;
  Begin
    I := StrIndex (AValue, ASubStr, 1, AComparisonType);

    If I = 0 Then
    Begin
      Result.Value1 := AValue;
      Result.Value2 := '';
    End
    Else
    Begin
      Result.Value1 := System.StrUtils.LeftStr (AValue, I - 1);
      Result.Value2 := System.Copy (AValue, I + ASubStr.Length);
    End;
  End;

  ///probar
  Class Function TghSys.MemBytes <T> (Const AValue :T) :TBytes;
  Begin
    System.SetLength (Result, System.SizeOf (T));
    CopyMem <T> (AValue, Result);
  End;

  ///probar
  Class Function TghSys.MemEqual <T> (Const AValue1, AValue2 :T) :Boolean;
  Begin
    Result := System.SysUtils.CompareMem (
      @AValue1, @AValue2, System.SizeOf (T));
  End;

  {$Warn No_RetVal Off}
  Class Function TghSys.NewSingleton (
    Const AInstanceRefClassMethod :TFuncMethod <TghSys.PObject>;
    Const ANewInstanceFunc :System.SysUtils.TFunc <TObject>) :TObject;
  Var
    LRef :TghSys.PObject;
  Begin
    LRef := AInstanceRefClassMethod;

    If LRef^ = Nil Then
      Result := ANewInstanceFunc.ghSetTo (LRef^)
    Else
      TMethod (AInstanceRefClassMethod).ghDataClass.ghRaiseNotConstruct (
        TghSys.ermSingletonInstance);
  End;
  {$Warn No_RetVal On}

  Class Function TghSys.NotPrefixed (Const AValue :String;
    Const APrefix :Char) :String;
  Begin
    If ChrOf (AValue) = APrefix Then
      Result := System.Copy (AValue, 2)
    Else
      Result := AValue;
  End;

  Class Function TghSys.Obj <T> (Const AValue :T) :TObject;
  Begin
    TghRTTI.Info <T>.ghCheckKind (System.tkClass);
    Result := PObject (@AValue)^;
  End;

  {}//probar
  Class Function TghSys.PackTernaries (Const AValue1, AValue2 :TTernary)
    :Integer;
  Begin
    Result := (System.Ord (AValue1) ShL 2) Or System.Ord (AValue2);
  End;

  Class Function TghSys.ParentFilePath (Const APath :String;
    Const AUpLevels :Integer = 1) :String;
  Begin
    {$If Defined (MSWindows)}
    Result := TghWin.ParentFilePath (APath, AUpLevels);
    {$Else}
    Result := ParentPath (APath, AUpLevels);
    {$EndIf}
  End;

  {}//probar
  Class Function TghSys.ParentPath (Const APath :String;
    Const AUpLevels :Integer = 1;
    Const ADelim :Char = System.SysUtils.PathDelim) :String;
  Begin
    If Keep (Result, APath <> '') Then
      Result := Virtual.InternalParentPath (APath, AUpLevels, ADelim);
  End;

  Class Function TghSys.ParentPath (Const APath :String;
    Const ADelim :Char) :String;
  Begin
    Result := ParentPath (APath, 1, ADelim);
  End;

  {}//probar
  Class Function TghSys.PortURL (Const AURL :String; Const APort :Word)
    :String;
  Var
    I, LLength :Integer;
  Begin
    If SetInt (I, URLPortIndex (AURL, LLength)) > 0 Then
      Result := System.StrUtils.StuffString (
        AURL, I, LLength, APort.ToString)
    Else
      Result := InsertStr (AURL, ':' + APort.ToString,
        URLSchemeDomainLength (AURL) + 1);
  End;

  Class Function TghSys.Prefixed (Const AValue :String;
    Const APrefix :Char; Const AAllowEmpty :Boolean = System.False)
    :String;
  Begin
    If AValue = '' Then
      If AAllowEmpty Then
        Result := APrefix
      Else
        Result := ''
    Else
      If AValue [1] = APrefix Then
        Result := AValue
      Else
        Result := APrefix + AValue;
  End;

  Class Function TghSys.Prefixed (Const AValue, APrefix :String;
    Const AAllowEmpty :Boolean = System.False;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :String;
  Begin
    If AValue = '' Then
      If AAllowEmpty Then
        Result := APrefix
      Else
        Result := ''
    Else
      If StrStarts (AValue, APrefix, AComparisonType) Then
        Result := AValue
      Else
        Result := APrefix + AValue;
  End;

  Class Function TghSys.Prefixed (
    Const AValue, ASubPrefix, APrefixMark :String;
    Const AAllowEmpty :Boolean = System.False;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :String;
  Begin
    If (AValue = '') And Not AAllowEmpty Then
      System.Exit ('');

    Result := ASubPrefix + APrefixMark;  // Prefix to put

    If AValue = '' Then
      System.Exit;

    If StrStarts (AValue, Result, AComparisonType) Then
      Result := AValue
    Else
      Result := ReplaceLeftOf (
        AValue, APrefixMark, ASubPrefix, Result, AComparisonType);
  End;

  Class Function TghSys.Prefixed (
    Const AValue, ASubPrefix, APrefixMark :String;
    Const AComparisonType :TStrComparison) :String;
  Begin
    Result := Prefixed (
      AValue, ASubPrefix, APrefixMark, System.False, AComparisonType);
  End;

  Class Function TghSys.PtrVar (Const AValue :Pointer) :Variant;
  Begin
    Result := AValue.ghAsVar;
  End;

  Class Function TghSys.PutChr (Var AStr :String; Const AIndex :Integer;
    Const AValue :Char) :Boolean;
  Begin
    { NOTE: A direct character assignment in a string always calls to
      UniqueString. This method first checks if specified character matches
      the character in the given position (but it does not check the
      validity of Index). }

    If AValue <> AStr [AIndex] Then
    Begin
      AStr [AIndex] := AValue;
      Result := System.True;
    End
    Else
      Result := System.False;
  End;

  Class Function TghSys.PutChrSafe (Var AStr :String; Const AIndex :Integer;
    Const AValue :Char) :Boolean;
  Begin
    Result := IsIndex (AIndex, AStr) And PutChr (AStr, AIndex, AValue);
  End;

  Class Function TghSys.QuotedFormat (Const AValue :String) :String;
  Begin
    Result := EnclosedStr (AValue, fmtQuote);
  End;

  Class Procedure TghSys.RaiseExpectedGiven (
    Const AExpected, AGiven :Integer);
  Begin
    Exception.ghRaise (
      ermExpectedGiven, [AExpected.ToString, AGiven.ToString]);
  End;

  Class Procedure TghSys.RaiseIndexOutOfRange (Const AValue :Integer);
  Begin
    RaiseOutOfRange ('Index', AValue.ToString);
  End;

  Class Procedure TghSys.RaiseInvalidValue (Const AName :String;
    Const AValue :Integer);
  Begin
    Exception.ghRaise (ermInvalidValue, [AName, AValue.ToString]);
  End;

  Class Procedure TghSys.RaiseOutOfRange (Const AName, AValue :String);
  Begin
    EArgumentOutOfRangeException.ghRaise (ermOutOfRange, [AName, AValue]);
  End;

  Class Procedure TghSys.RaiseTypecast <TSource, TDest>;
  Begin
    EInvalidOpException.ghRaiseTypes <TSource, TDest> (ermInvalidTypecast);
  End;

  {}//que permita cualquier tamaño, probando frecuencia de GUIDs que inician igual
  ///probar
  Class Function TghSys.RandomBytes (Const ASize :Integer) :TBytes;
  Var
    I, LBlockSize :Integer;
  Begin
    LBlockSize := System.SizeOf (TGUID);
    System.SetLength (Result, CheckMin (ASize, LBlockSize));

    For I := 0 To DivCeil (ASize, LBlockSize) - 1 Do
      TArray.ghFixedCopy <Byte> (
        TGUID.NewGuid.ToByteArray, Result, 0, I * LBlockSize,
        System.Math.Min (LBlockSize, ASize - (I * LBlockSize)));///posible método
  End;

  {}//optimizar si cada asignación de carácter llama a UniqueString
  Class Function TghSys.ReplaceChr (Const AValue :String;
    Const AChr, ANewChr :Char) :String;
  Var
    I :Integer;
  Begin
    Result := AValue;

    For I := 1 To Result.Length Do
      If Result [I] = AChr Then
        Result [I] := ANewChr;
  End;

  {}//optimizar si cada asignación de carácter llama a UniqueString
  Class Function TghSys.ReplaceChrs (Const AValue :String;
    Const AChrs :TSysCharSet; Const ANewChr :Char) :String;
  Var
    I :Integer;
  Begin
    Result := AValue;

    For I := 1 To Result.Length Do
      If System.SysUtils.CharInSet (Result [I], AChrs) Then
        Result [I] := ANewChr;
  End;

  Class Function TghSys.ReplaceLeftOf (
    Const AValue, ASubStr, AReplaceSubStr, AInsertSubStr :String;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :String;
  Var
    I :Integer;
  Begin
    If SetSolid (I, StrIndex (AValue, ASubStr, AComparisonType)) Then
      Result := AReplaceSubStr + System.Copy (AValue, I)
    Else
      Result := AInsertSubStr + AValue;
  End;

  Class Function TghSys.ResolveFilePath (Const AValue :String) :String;
  Begin
    If Keep (Result, AValue <> '') Then
      Result := Virtual.InternalResolveFilePath (AValue);
  End;

  { NOTE: This function takes into acount only the ACallers most direct
    caller routines that have an EBP stack frame.  The compiler does not
    generate stack frame for this function. }
  Class Function TghSys.ReturnAddress (ACallers :Integer = 1) :Pointer;
  Asm
    Mov ECX, EBP  // Stack frame of the most direct caller

    @Loop:            // Repeat
      Dec EAX         // Dec (ACallers)
      JZ  @Exit       // If ACallers = 0 Then Break
      Mov ECX, [ECX]  // Stack frame (EBP) of previous caller
      Jmp @Loop       // Until False

    @Exit:
      Mov EAX, [ECX + 4]  // Result := Return address of "that" caller
  End;

  Class Function TghSys.RightChrs (Const AValue :String;
    Const AChrs :TSysCharSet; Const AMaxLength :Integer = System.MaxInt)
    :String;
  Var
    I, LLength :Integer;
  Begin
    LLength := AValue.Length;

    For I := LLength DownTo 1 Do
      If (LLength - I >= AMaxLength) Or
      Not System.SysUtils.CharInSet (AValue [I], AChrs) Then
        System.Exit (System.Copy (AValue, I + 1));

    Result := AValue;
  End;

  Class Function TghSys.RightInt (Const AValue :String;
    Const AMaxLength :Integer = System.MaxInt) :Integer;
  Begin
    Result := StrInt (RightDigits (AValue, AMaxLength));
  End;

  {}//probar
  Class Function TghSys.RightLeftOf (Const AValue :String;
    Const AChr1, AChr2 :Char) :String;
  Begin
    If SetSolid (Result, RightOf (AValue, AChr1)) Then
      Result := LeftOf (Result, AChr2);
  End;

  {}//probar
  Class Function TghSys.RightLeftOfOptional (Const AValue :String;
    Const AChr1, AChr2 :Char) :String;
  Begin
    Result := LeftOfOptional (RightOfOptional (AValue, AChr1), AChr2);
  End;

  {}//probar
  Class Function TghSys.RightOf (Const AValue :String; Const AChr :Char;
    Const AEndIndex :Integer = System.MaxInt) :String;
  Var
    I :Integer;
  Begin
    If Keep (Result, SetSolid (I, ChrIndex (AValue, AChr))) Then
      Result := SubStr (AValue, I + 1, AEndIndex)
  End;

  Class Function TghSys.RightOfOptional (Const AValue :String;
    Const AChr :Char; Const AEndIndex :Integer = System.MaxInt) :String;
  Begin
    Result := SubStr (AValue, ChrIndex (AValue, AChr) + 1, AEndIndex);
  End;

  Class Function TghSys.SchemePortURL (Const AURL, AScheme :String;
    Const APort :Word) :String;
  Begin
    Result := SchemeURL (PortURL (AURL, APort), AScheme);
  End;

  {}//probar
  Class Function TghSys.SchemeURL (Const AURL, AScheme :String) :String;
  Begin
    Result := Prefixed (AURL, AScheme, '://');
  End;

  Class Function TghSys.SetAncestor (Var AClass; Const AValue :TClass)
    :TClass;
  Begin
    Result := TClass (AClass).ghCheckAncestor (AValue).ghSetClassTo (
      AClass);
  End;

  Class Function TghSys.SetAncestorOrDescendant (Var AClass;
    Const AValue :TClass) :TClass;
  Begin
    Result := TClass (AClass).ghCheckAncestorOrDescendant (
      AValue).ghSetClassTo (AClass);
  End;

  Class Function TghSys.SetArrLength <T> (Var AArr :TArray <T>;
    Const AValue :Integer) :Integer;
  Begin
    System.SetLength (AArr, AValue);
    Result := AValue;
  End;

  Class Function TghSys.SetBitOn (Var AInt :Integer; Const AMask :Integer)
    :Boolean;
  Begin
    Result := Not HasBitsOn (AInt, AMask);
    AInt := AInt Or AMask;
  End;

  Class Function TghSys.SetBitOn (Var AInt :Word; Const AMask :Word)
    :Boolean;
  Begin
    Result := Not HasBitsOn (AInt, AMask);
    AInt := AInt Or AMask;
  End;

  {}//o sin llamar a SetSolid si es tamaño menor
  Class Function TghSys.SetBlank (Out AChr :Char; Const AValue :Char)
    :Boolean;
  Begin
    Result := Not SetSolid (AChr, AValue);
  End;

  {}//o sin llamar a SetSolid si es tamaño menor
  Class Function TghSys.SetBlank (Out AInt :Cardinal;
    Const AValue :Cardinal) :Boolean;
  Begin
    Result := Not SetSolid (AInt, AValue);
  End;

  {}//o sin llamar a SetSolid si es tamaño menor
  Class Function TghSys.SetBlank (Out AInt :Integer; Const AValue :Integer)
    :Boolean;
  Begin
    Result := Not SetSolid (AInt, AValue);
  End;

  Class Function TghSys.SetBlank (Out APtr; Const AValue :Pointer)
    :Boolean;
  Begin
    Result := Pointer (APtr).ghSetBlank (AValue);
  End;

  {}//o sin llamar a SetSolid si es tamaño menor
  Class Function TghSys.SetBlank (Out AStr :String; Const AValue :String)
    :Boolean;
  Begin
    Result := Not SetSolid (AStr, AValue);
  End;

  Class Function TghSys.SetBytes (Out ABytes :TBytes; Const AValue :TBytes)
    :TBytes;
  Begin
    ABytes := AValue;
    Result := ABytes;
  End;

  Class Function TghSys.SetDescendant (Var AClass; Const AValue :TClass)
    :TClass;
  Begin
    Result := TClass (AClass).ghCheckDescendant (AValue).ghSetClassTo (
      AClass);
  End;

  Class Function TghSys.SetHigh <T> (Var AArr :TArray <T>;
    Const AValue :Integer) :Integer;
  Begin
    System.SetLength (AArr, AValue + 1);
    Result := AValue;
  End;

  Class Function TghSys.SetIndex (Out AInt :Integer; Const AValue :Integer)
    :Boolean;
  Begin
    AInt := AValue;

    { NOTE: For this inline method "AInt >= 0" can be more efficient than
      "AValue >= 0", if AValue is an expression involving compiler magic. }
    Result := AInt >= 0;
  End;

  {}//buscar forma Inline
  Class Function TghSys.SetIndex (Out AInt :Integer;
    Const AValue, ADefaultValue :Integer) :Boolean;
  Begin
    If SetBool (Result, AValue >= 0) Then
      AInt := AValue
    Else
      AInt := ADefaultValue;
  End;

  Class Function TghSys.SetLength <T> (Var AArr :TArray <T>;
    Const AValue :Integer) :Integer;
  Begin
    System.SetLength (AArr, AValue);
    Result := AValue;
  End;

  Class Function TghSys.SignedOne (Const APositive :TOrdBool) :Integer;
  Begin
    Result := (APositive * 2) - 1;
  End;

  Class Function TghSys.SignedOne (Const APositive :Boolean) :Integer;
  Begin
    {}//o código directo si no queda inline
    Result := SignedOne (Ord (APositive));
  End;

  Class Function TghSys.Solid (Const AValues :Array Of Pointer) :Pointer;
  Begin
    For Result In AValues Do
      If Result <> Nil Then
        System.Exit;

    Result := Nil;
  End;

  {}//probar
  Class Function TghSys.SplitHexInts (Const AValue :String;
    Const ASeparators :Array Of String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := StrsInts (SplitStrs (AValue, ASeparators, AIncludeEmpties),
      '$');
  End;

  Class Function TghSys.SplitHexInts (Const AValue :String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := SplitHexInts (AValue, [' '], AIncludeEmpties);
  End;

  {}//probar
  Class Function TghSys.SplitHexInts (Const AValue :String;
    Const ASeparators :Array Of String; Const ADefaultValue :Integer;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := StrsInts (SplitStrs (AValue, ASeparators, AIncludeEmpties),
      '$', ADefaultValue);
  End;

  Class Function TghSys.SplitHexInts (Const AValue :String;
    Const ADefaultValue :Integer;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := SplitHexInts (AValue, [' '], ADefaultValue, AIncludeEmpties);
  End;

  {}//probar
  Class Function TghSys.SplitInts (Const AValue :String;
    Const ASeparators :Array Of String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := StrsInts (SplitStrs (AValue, ASeparators, AIncludeEmpties));
  End;

  Class Function TghSys.SplitInts (Const AValue :String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := SplitInts (AValue, [' '], AIncludeEmpties);
  End;

  {}//probar
  Class Function TghSys.SplitInts (Const AValue :String;
    Const ASeparators :Array Of String; Const ADefaultValue :Integer;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := StrsInts (SplitStrs (AValue, ASeparators, AIncludeEmpties),
      ADefaultValue);
  End;

  Class Function TghSys.SplitInts (Const AValue :String;
    Const ADefaultValue :Integer;
    Const AIncludeEmpties :Boolean = System.False) :TArray <Integer>;
  Begin
    Result := SplitInts (AValue, [' '], ADefaultValue, AIncludeEmpties);
  End;

  {}//probar
  Class Function TghSys.SplitStrs (Const AValue :String;
    Const ASeparators :Array Of String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <String>;
  Begin
    Result := AValue.Split (
      ASeparators, TStringSplitOptions (Not AIncludeEmpties));
  End;

  Class Function TghSys.SplitStrs (Const AValue :String;
    Const AIncludeEmpties :Boolean = System.False) :TArray <String>;
  Begin
    Result := SplitStrs (AValue, [' '], AIncludeEmpties);
  End;

  Class Function TghSys.StartsDupChr (Const AValue :String;
    Const AChr :Char) :Boolean;
  Begin
    // NOTE: This method does not check the string length

    Result := (AValue [1] = AChr) And (AValue [2] = AChr);
  End;

  Class Function TghSys.StartsDupChrSafe (Const AValue :String;
    Const AChr :Char) :Boolean;
  Begin
    Result := (AValue.Length > 1) And StartsDupChr (AValue, AChr);
  End;

  Class Function TghSys.StrBool (Const AValue :String) :Boolean;
  Begin
    Result := System.SysUtils.StrToBoolDef (AValue, System.False);
  End;

  Class Function TghSys.StrFloat (Const AValue :String) :Double;
  Begin
    Result := System.SysUtils.StrToFloatDef (AValue, 0);
  End;

  Class Function TghSys.StrIndex (Const AValue, ASubStr :String;
    Const AStart :Integer = 1;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Integer;
  Begin
    If Keep (Result, AreSolid (AValue, ASubStr)) Then
      Result := Virtual.InternalStrIndex (
        AValue, ASubStr, AStart, AComparisonType);
  End;

  Class Function TghSys.StrIndex (Const AValue, ASubStr :String;
    Const AComparisonType :TStrComparison) :Integer;
  Begin
    Result := StrIndex (AValue, ASubStr, 1, AComparisonType);
  End;

  Class Function TghSys.StrInt (Const AValue :String) :Integer;
  Begin
    Result := System.SysUtils.StrToIntDef (AValue, 0);
  End;

  Class Function TghSys.StrInt64 (Const AValue :String) :Int64;
  Begin
    Result := System.SysUtils.StrToInt64Def (AValue, 0);
  End;

  Class Function TghSys.StrOLEVar (Const AValue :String) :OLEVariant;
  Begin
    Result := OLEVariant (StrVar (AValue));
  End;

  {}//probar
  Class Function TghSys.StrPos (Const AValues :Array Of String;
    Const AValue :String; Const AStart :Integer = 0;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Integer;
  Begin
    For Result := AStart To System.High (AValues) Do
      If StrsEqual (AValues [Result], AValue, AComparisonType) Then
        System.Exit;

    Result := -1;
  End;

  Class Function TghSys.StrsEqual (Const AValue1, AValue2 :String;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Boolean;
  Begin
    Result := CompareStrs (AValue1, AValue2, AComparisonType) = 0;
  End;

  {}//probar
  Class Function TghSys.StrsInts (Const AValues :Array Of String)
    :TArray <Integer>;
  Var
    I :Integer;
  Begin
    For I := 0 To
    TghSys.SetHigh <Integer> (Result, System.High (AValues)) Do
      Result [I] := AValues [I].ToInteger;
  End;

  {}//probar
  Class Function TghSys.StrsInts (Const AValues :Array Of String;
    Const ADefaultValue :Integer) :TArray <Integer>;
  Var
    I :Integer;
  Begin
    For I := 0 To
    TghSys.SetHigh <Integer> (Result, System.High (AValues)) Do
      Result [I] := System.SysUtils.StrToIntDef (
        AValues [I], ADefaultValue);
  End;

  {}//probar
  Class Function TghSys.StrsInts (Const AValues :Array Of String;
    Const APrefix :String) :TArray <Integer>;
  Var
    I :Integer;
  Begin
    For I := 0 To
    TghSys.SetHigh <Integer> (Result, System.High (AValues)) Do
      Result [I] := (APrefix + AValues [I]).ToInteger;
  End;

  {}//probar
  Class Function TghSys.StrsInts (Const AValues :Array Of String;
    Const APrefix :String; Const ADefaultValue :Integer)
    :TArray <Integer>;
  Var
    I :Integer;
  Begin
    For I := 0 To
    TghSys.SetHigh <Integer> (Result, System.High (AValues)) Do
      Result [I] := System.SysUtils.StrToIntDef (
        APrefix + AValues [I], ADefaultValue);
  End;

  Class Function TghSys.StrStarts (Const AValue, ASubStr :String;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Boolean;
  Begin
    Result := AreSolid (AValue, ASubStr) And StrsEqual (
      System.StrUtils.LeftStr (AValue, ASubStr.Length), ASubStr,
      AComparisonType);
  End;

  Class Function TghSys.StrStartsSub (Const AValue, ASubStr :String;
    Const AComparisonType :TStrComparison = TStrComparison.eOrdAnyCase)
    :Boolean;
  Begin
    Result := (AValue.Length > ASubStr.Length) And
      StrStarts (AValue, ASubStr, AComparisonType);
  End;

  Class Function TghSys.StrVar (Const AValue :String) :Variant;
  Begin
    If AValue = '' Then
      Result := System.Variants.Null
    Else
      Result := AValue;
  End;

  Class Function TghSys.SubStr (Const AValue :String;
    Const AStartIndex, AEndIndex :Integer) :String;
  Begin
    Result := System.Copy (AValue, AStartIndex,
      AEndIndex - EnsureCardinal (AStartIndex - 1));
  End;

  Class Function TghSys.SwapChrs (Const AValue :TTwoChrs) :TTwoChrs;
  Begin
    Result.Value1 := AValue.Value2;
    Result.Value2 := AValue.Value1;
  End;

  Class Function TghSys.SymmetricRange (Const ALimit :Integer) :TTwoInts;
  Begin
    Result.LowValue := -System.Abs (ALimit);
    Result.HighValue := AbsMax (ALimit, -System.MaxInt);
  End;

  Class Function TghSys.Ternary (Const AValue :Boolean) :TTernary;
  Begin
    Result := System.Succ (TTernary (AValue));
  End;

  Class Function TghSys.TurnBits (Const AValue, AMask :Integer;
    Const ACond :Boolean) :Integer;
  Begin
    If ACond Then
      Result := AValue Or AMask
    Else
      Result := AValue And Not AMask;
  End;

  Class Function TghSys.TVarRecsVar (Const AValues :Array Of Const)
    :Variant;
  Var
    I :Integer;
  Begin
    Result := VarArr (System.Length (AValues), System.False);

    For I := 0 To System.High (AValues) Do
      Result.ghSetElement (I, AValues [I].ghAsVar);
  End;

  Class Function TghSys.URLPort (Const AURL :String) :Integer;
  Var
    I :Integer;
  Begin
    If SetSolid (I, URLPortIndex (AURL, Result)) Then
      Result := System.Copy (AURL, I, Result).ToInteger;
  End;

  {}//probar de nuevo
  Class Function TghSys.URLPortIndex (Const AURL :String;
    Out ALength :Integer) :Integer;
  Var
    I, LValueLength :Integer;
  Begin
    LValueLength := AURL.Length;
    Clear (ALength, Result);

    For I := IndexRightOfOptionalURLScheme (AURL) To LValueLength Do
      If AURL [I] = '/' Then
        System.Exit (System.Math.IfThen (ALength > 0, Result))
      Else
        If Result = 0 Then
          If (AURL [I] = ':') And (I < LValueLength) Then
            Result := I + 1
          Else
        Else
          If Not IncWhen (
          ALength, System.SysUtils.CharInSet (AURL [I], dgtDecimals)) Then
            Clear (ALength, Result);
  End;

  {}//probar de nuevo
  Class Function TghSys.URLScheme (Const AURL :String) :String;
  Var
    LLength :Integer;
  Begin
    If Keep (Result, SetSolid (LLength, URLSchemeLength (AURL))) Then
      Result := System.StrUtils.LeftStr (AURL, LLength)
  End;

  {}//probar de nuevo
  Class Function TghSys.URLSchemeDomainLength (Const AURL :String)
    :Integer;
  Var
    I :Integer;
  Begin
    // Text after the scheme and before the path
    If SetSolid (Result, IndexLeftOfOptional (
    AURL, '/', IndexRightOfOptionalURLScheme (AURL) + 1)) And

    // We discard the port
    (SetInt (I, ChrGroupIndex (AURL, dgtDecimals, Result)) > 1) And
    (AURL [I - 1] = ':') Then

      Result := I - 2;
  End;

  Class Function TghSys.URLSchemeLength (Const AURL :String) :Integer;
  Begin
    Result := IncIfPositive (Pos ('://', AURL), -1);
  End;

  {}//probar
  Class Function TghSys.ValuesEqual <T> (Const AValue1, AValue2 :T)
    :Boolean;
  Begin
    If Not Virtual.CompareValuesEqual (
    AValue1, AValue2, System.TypeInfo (T), Result) Then
      Result:= TEqualityComparer <T>.Default.Equals (AValue1, AValue2);
  End;

  Class Function TghSys.VarArr (Const ASize :Integer;
    Const AType :TVarType = System.varVariant;
    Const AllowLessThanTwo :Boolean = System.True) :Variant;
  Begin
    If (ASize > 1) Or AllowLessThanTwo Then
      Result := System.Variants.VarArrayCreate ([0, ASize - 1], AType)
    Else
      Result := System.Variants.Unassigned;
  End;

  Class Function TghSys.VarArr (Const ASize :Integer;
    Const AAllowLessThanTwo :Boolean) :Variant;
  Begin
    Result := VarArr (ASize, System.varVariant, AAllowLessThanTwo);
  End;

  Class Function TghSys.VerifyChr (Const AValue, AMatch :Char) :TTernary;
  Begin
    If AValue = #0 Then
      Result := TTernary.eUndefined
    Else
      Result := Ternary (AValue = AMatch);
  End;

  Class Function TghSys.VerifyChrs (Const AValue1, AValue2, AMatch :Char)
    :TTwoTernaries;
  Begin
    Result.Value1 := VerifyChr (AValue1, AMatch);
    Result.Value2 := VerifyChr (AValue2, AMatch);
  End;

  Class Function TghSys.VerifyConcatAffixes (
    Const AValue1, AValue2 :String; Const AAffix :Char) :TTwoTernaries;
  Begin
    Result := VerifyChrs (ChrOfEnd (AValue1), ChrOf (AValue2), AAffix);
  End;

  { TghZeroton }

  { Public overridden class methods }

  {$Warn No_RetVal Off}
  Class Function TghZeroton.NewInstance :TObject;
  Begin
    ghRaiseNotInstantiate;  // This raises an ENoConstructException
  End;
  {$Warn No_RetVal On}

End.

