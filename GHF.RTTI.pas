{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.RTTI.pas - TghRTTI class unit.                                      }
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

Unit GHF.RTTI;  { RTTI }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Sys, System.RTTI, GHF.List, GHF.TypeListDic, GHF.ClassList,
    GHF.RTTIInstanceType, GHF.SysEx, System.Generics.Collections,
    System.TypInfo;

  Type
    {}//agregar de GHF.RTL lo que sea propio de esta clase (buscar refs. a TypInfo/TypeInfo/RTTI)
    { RTTI class }
    TghRTTI = Class (TghZeroton)
      Private
        Type
          { NOTE: This type, referenced only in GetCompiledTypes, allows us
            to know if the class property CompiledTypes is being referenced
            from some place. There are few WideString types and their
            TTypeData occupies little space (we tried other means without
            success). }
          CompiledTypesMark = Type WideString;

        Class Constructor Create;
        Class Destructor Destroy;
      Protected
        Type
          {$TypeInfo On}
          IIntfMethodContainer = Interface
            Procedure Dummy;
          End;
          {$TypeInfo Off}

          {}//revisar si requiere $TypeInfo
          TClassMethodContainer = Class
            Procedure Dummy; Virtual; Abstract;
          End;

          {}//revisar si requiere $TypeInfo
          TRecMethodContainer = Record
            Procedure Dummy;
          End;

        Class Var
          FCompiledTypes :TghList <TRTTIType>;
          FContext :TRTTIContext;
          Finalized :Boolean;
          FTypes :TghTypeListDic;
          NotCollectedChildClasses :TghClassList <TClass>;

        { Static class methods }
        Class Function ExMethodSample :TRTTIMethod; Static;
        Class Function GetCompiledTypes :TghList <TRTTIType>; Static;
          {}//Inline;
        Class Function GetTypes (Const AKind :TTypeKind)
          :TghList <TRTTIType>; Static;
        Class Function InternalGetCompiledTypes :TghList <TRTTIType>;
          Static;
        Class Function VerifyFreeDescs (Const APackage :TRTTIPackage;
          Const AHandle :THandle) :Boolean; Static;
      Public
        Const
          { Error messages }
          ermNoExRTTIDesc_ = '%s has no extended RTTI description.';
          ermNoExRTTIDesc :String = ermNoExRTTIDesc_;
          ermNoSingleConstructor_ =
            'The %s class does not have an accessible safe single constructor.';
          ermNoSingleConstructor :String = ermNoSingleConstructor_;
          ermNotClassRefType_ = '%s is not a class reference type.';
          ermNotClassRefType :String = ermNotClassRefType_;
          ermNotClassType_ = '%s is not a class type.';
          ermNotClassType :String = ermNotClassType_;

        Type
          { Pointer types for data types declared in native units }
          PRTTIContext = ^TRTTIContext;

          { TMemberVisibility helper }
          TMemberVisibilityHelper = Record Helper For TMemberVisibility
            Public
              { Regular instance methods }
              Function ghIsPublic :Boolean;
          End;

          TMethodKind = (eUnknown, eClassic, eEx, eIntf, eRec);

          { TRTTIContext helper }
          TRTTIContextHelper = Record Helper For TRTTIContext
            Protected
              { Regular instance methods }
              Function ghGetContextToken :IInterface;

              { Instance properties }
              Property ghContextToken :IInterface Read ghGetContextToken;
            Public
              { Static class methods }
              Function ghCheckFindInstanceType (
                Const AQualifiedName :String) :TghRTTIInstanceType;
              Function ghCheckFindType (Const AQualifiedName :String)
                :TRTTIType;
              Function ghFindInstanceType (Const AQualifiedName :String)
                :TghRTTIInstanceType;
          End;

          PRTTIMethodArr = ^TRTTIMethodArr;
          TRTTIMethodArr = TArray <TRTTIMethod>;

          { TRTTIInstanceType helper }
          TRTTIInstanceTypeHelper = Class Helper (TghSys.TObjectHelper) For
          TRTTIInstanceType
            Protected
              { Regular instance methods }
              Function ghInternalDeclaredMethods :PRTTIMethodArr;
          End;

          { TRTTIInterfaceType helper }
          TRTTIInterfaceTypeHelper = Class Helper (
          TghSys.TObjectHelper) For TRTTIInterfaceType
            Protected
              { Regular instance methods }
              Function ghInternalDeclaredMethods :PRTTIMethodArr;
          End;

          { TRTTIMethod helper }
          TRTTIMethodHelper = Class Helper (TghSys.TObjectHelper) For
          TRTTIMethod
            Protected
              { Regular instance methods }
              Function ghGetClassicHandle :PVMTMethodEntry;
              Function ghGetExHandle :PVMTMethodExEntry;
              Function ghGetIsAbstract :Boolean;
              Function ghGetIsPublicConstructor :Boolean;
              Function ghGetKind :TMethodKind;
              Function ghGetParamCount :Integer;
              Function ghInternalExHandle :PVMTMethodExEntry;
            Public
              Type
                { Class reference type }
                TghClassRef = Class Of TRTTIMethod;

              { Instance properties }
              Property ghClassicHandle :PVMTMethodEntry
                Read ghGetClassicHandle;
              Property ghExHandle :PVMTMethodExEntry
                Read ghGetExHandle;
              Property ghIsAbstract :Boolean Read ghGetIsAbstract;
              Property ghIsPublicConstructor :Boolean
                Read ghGetIsPublicConstructor;

              { Instance properties }
              Property ghKind :TMethodKind Read ghGetKind;
              Property ghParamCount :Integer Read ghGetParamCount;
            Protected
              { Regular instance methods }
              Function ghGetClass :TghClassRef;
            Public
              { Instance properties }
              Property ghClass :TghClassRef Read ghGetClass;
          End;

          { TRTTIPackage helper }
          TRTTIPackageHelper = Class Helper (TghSys.TObjectHelper) For
          TRTTIPackage
            Public
              { Regular instance methods }
              Function ghHandleToObject :TDictionary <Pointer, TRTTIObject>;
          End;

          { TTypeInfo helper }
          TTypeInfoHelper = Record Helper For TTypeInfo
            Protected
              { Regular instance methods }
              Function ghGetIsClassOrPtr :Boolean;
              Function ghGetSize :Integer;
            Public
              { Regular instance methods }
              Function ghAttr <T :TCustomAttribute> :T; Overload;
              Function ghAttr <T :TCustomAttribute>
                (Out AAnnotatedParent :PTypeInfo) :T; Overload;
              Function ghCheckAttr <T :TCustomAttribute> :T; Overload;
              Function ghCheckAttr <T :TCustomAttribute>
                (Out AAnnotatedParent :PTypeInfo) :T; Overload;
              Function ghCheckClass :TClass;
              Function ghCheckClassPtrAssignmentCompat (
                Const AValueInfo :PTypeInfo) :PTypeInfo; Overload;
              Function ghCheckClassPtrAssignmentCompat <T>
                :PTypeInfo; Overload;
              Function ghCheckDescendantOf (Const AAncestor :TClass)
                :PTypeInfo;
              Function ghCheckInstanceType :TghRTTIInstanceType;
              Function ghCheckIntfType :TRTTIInterfaceType;
              Function ghCheckKind (Const AKind :TTypeKind) :PTypeInfo;
                Overload;
              Function ghCheckKind (Const AKinds :TTypeKinds) :PTypeInfo;
                Overload;
              Function ghCheckPtrSize :Integer;
              Function ghCheckPtrTypeInfo (
                Const AKind :TTypeKind = System.tkUnknown) :PTypeInfo;
              Function ghCheckRefClass :TClass;
              Function ghClassPtrAssignmentCompat (
                Const AValueInfo :PTypeInfo) :Boolean; Overload;
              Function ghClassPtrAssignmentCompat <T> :Boolean; Overload;
              Procedure ghCreateValue (Out ARef;
                AMakeObjRef :Boolean = False);
              Procedure ghFreeValue (Const ARef;
                Const AUnmakeObjRef :Boolean = False);
              Function ghGetAttr <T :TCustomAttribute> (Out AAttr :T)
                :Boolean; Overload;
              Function ghGetAttr <T :TCustomAttribute> (Out AAttr :T;
                Out AAnnotatedParent :PTypeInfo) :Boolean; Overload;
              Function ghInstanceType :TghRTTIInstanceType;
              Function ghIntfType :TRTTIInterfaceType;
              Function ghIsDescendantOf (Const AAncestor :TClass) :Boolean;
              Function ghIsUntypedPointer :Boolean;
              Procedure ghNewValue (Out ARef);
              Function ghParent :PTypeInfo;
              Function ghPtrSize :Integer;
              Function ghPtrTypeInfo :PTypeInfo;
              Procedure ghRaiseIncompatibleTypes (Const AInfo :PTypeInfo);
                Overload;
              Procedure ghRaiseIncompatibleTypes <T>; Overload;
              Procedure ghRaiseInvalid;
              Function ghRecType :TRTTIRecordType;
              Function ghRefClass :TClass;
              Function ghType :TRTTIType;

              { Instance properties }
              Property ghIsClassOrPtr :Boolean Read ghGetIsClassOrPtr;
              Property ghSize :Integer Read ghGetSize;
          End;

          { Virtual class. Overridable functionality, accessible via the
            Virtual class property. }
          TVirtual = Class
            Public
              Type
                { Class reference type }
                TClassRef = Class Of TVirtual;

              { Virtual class methods }
              Class Function AssignmentCompat (AClass :TClass;
                AInfo :PTypeInfo) :Boolean; Virtual;
              Class Function ClassPtrAssignmentCompat (
                AInfo1, AInfo2 :PTypeInfo) :Boolean; Virtual;
              Class Procedure FreeValue (Const ARef; AInfo :PTypeInfo);
                Virtual;
              Class Procedure InternalCreateValue (Out ARef;
                AInfo :PTypeInfo); Virtual;
              Class Procedure NewValue (Out ARef; AInfo :PTypeInfo);
                Virtual;
          End;

        Class Var
          AutoFreeDescs :Boolean;

        { Static class methods }
        Class Function FormatTypeNames <T1, T2> (Const AFormat :String)
          :String; Static;
        Class Function Info <T> :PTypeInfo; Static; Inline;

        {}//en TVirtual
        Class Procedure InitChildren (
          Const AInstanceType :TghRTTIInstanceType); Static;

        Class Function IntfGUID <T :IInterface> :TGUID; Static;

        { Class properties }
        Class Property CompiledTypes :TghList <TRTTIType>
          Read GetCompiledTypes;///considerar mecanismo para refrescar lista por carga y descarga de paquetes
        Class Property Types [Const AKind :TTypeKind] :TghList <TRTTIType>
          Read GetTypes;
      Protected
        Class Var
          FVirtual :TVirtual.TClassRef;

        { Static class methods }
        Class Function GetClassicMethodClass :TRTTIMethod.TghClassRef;
          Static;
        Class Function GetContext :PRTTIContext; Static;
        Class Function GetExMethodClass :TRTTIMethod.TghClassRef; Static;
        Class Function GetIntfMethodClass :TRTTIMethod.TghClassRef; Static;
        Class Function GetRecMethodClass :TRTTIMethod.TghClassRef; Static;
        Class Procedure SetVirtual (Const AValue :TVirtual.TClassRef);
          Static;

        { Class properties }
        Class Property ClassicMethodClass :TRTTIMethod.TghClassRef
          Read GetClassicMethodClass;
        Class Property ExMethodClass :TRTTIMethod.TghClassRef
          Read GetExMethodClass;
        Class Property IntfMethodClass :TRTTIMethod.TghClassRef
          Read GetIntfMethodClass;
        Class Property RecMethodClass :TRTTIMethod.TghClassRef
          Read GetRecMethodClass;
      Public
        { Class properties }
        Class Property Context :PRTTIContext Read GetContext;
        Class Property Virtual :TVirtual.TClassRef Read FVirtual
          Write SetVirtual;
    End;

Implementation

  Uses
    GHF.Obs, System.SysUtils;

  { Inline routines }

  Class Function TghRTTI.Info <T> :PTypeInfo;
  Begin
    Result := System.TypeInfo (T);
  End;

  Class Function TghRTTI.GetCompiledTypes :TghList <TRTTIType>;
  Begin
    ghCheckClassFinalized (Finalized);

    // Trick (see declaration of CompiledTypesMark)
    If Info <CompiledTypesMark> = Nil Then;

    Result := InternalGetCompiledTypes;
  End;

  { TghRTTI }

  { TghRTTI.TMemberVisibilityHelper }

  Function TghRTTI.TMemberVisibilityHelper.ghIsPublic :Boolean;
  Begin
    Result := Self In
      [System.TypInfo.mvPublic, System.TypInfo.mvPublished];
  End;

  { TghRTTI.TRecMethodContainer }

  Procedure TghRTTI.TRecMethodContainer.Dummy;
  Begin
  End;

  { TghRTTI.TRTTIContextHelper }

  Function TghRTTI.TRTTIContextHelper.ghCheckFindInstanceType (
    Const AQualifiedName :String) :TghRTTIInstanceType;
  Begin
    If TghSys.SetBlank (Result, ghFindInstanceType (AQualifiedName)) Then
      Exception.ghRaise (TghSys.ermNotFoundStr, ['Class', AQualifiedName]);
  End;

  Function TghRTTI.TRTTIContextHelper.ghCheckFindType (
    Const AQualifiedName :String) :TRTTIType;
  Begin
    If TghSys.SetBlank (Result, FindType (AQualifiedName)) Then
      Exception.ghRaise (TghSys.ermNotFoundStr, ['Type', AQualifiedName]);
  End;

  Function TghRTTI.TRTTIContextHelper.ghFindInstanceType (
    Const AQualifiedName :String) :TghRTTIInstanceType;
  Begin
    If TghSys.SetSolid (Result, FindType (AQualifiedName)) Then
      Result := Result.ghEnsureAs <TghRTTIInstanceType>;
  End;

  Function TghRTTI.TRTTIContextHelper.ghGetContextToken :IInterface;
  Begin
    Result := Self.FContextToken;
  End;

  { TghRTTI.TRTTIInstanceTypeHelper }

  Function TghRTTI.TRTTIInstanceTypeHelper.ghInternalDeclaredMethods
    :PRTTIMethodArr;
  Begin
    Self.ReadMethData;
    Result := @Self.FMeths;
  End;

  { TghRTTI.TRTTIInterfaceTypeHelper }

  Function TghRTTI.TRTTIInterfaceTypeHelper.ghInternalDeclaredMethods
    :PRTTIMethodArr;
  Begin
    Result := @Self.FMethods;
  End;

  { TghRTTI.TRTTIMethodHelper }

  Function TghRTTI.TRTTIMethodHelper.ghGetClassicHandle :PVMTMethodEntry;
  Var
    LExHandle :PVMTMethodExEntry Absolute Result;
  Begin
    If ghKind = TghRTTI.TMethodKind.eClassic Then
      Result := Handle
    Else
      If TghSys.SetSolid (LExHandle, ghExHandle) Then
        Result := LExHandle.Entry;
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetExHandle :PVMTMethodExEntry;
  Begin
    If TghSys.Keep (Result, ghKind = TghRTTI.TMethodKind.eEx) Then
      Result := Handle;
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetIsAbstract :Boolean;
  Var
    LHandle :PVMTMethodExEntry;
  Begin
    If TghSys.SetSolid (LHandle, ghExHandle, Result) Then
      Result := TghSys.HasBitOn (LHandle.Flags, 1 ShL 7 { mfAbstract });
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetIsPublicConstructor :Boolean;
  Begin
    Result := IsConstructor And Visibility.ghIsPublic;
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetKind :TMethodKind;
  Begin
    If ClassType = TghRTTI.ClassicMethodClass Then
      Result := TghRTTI.TMethodKind.eClassic
    Else
      If ClassType = TghRTTI.ExMethodClass Then
        Result := TghRTTI.TMethodKind.eEx
      Else
        If ClassType = TghRTTI.IntfMethodClass Then
          Result := TghRTTI.TMethodKind.eIntf
        Else
          If ClassType = TghRTTI.RecMethodClass Then
            Result := TghRTTI.TMethodKind.eRec
          Else
            Result := TghRTTI.TMethodKind.eUnknown;
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetParamCount :Integer;
  Begin
    {}//mejorar con acceso a internals para que no se copie/cree array
    Result := System.Length (GetParameters);
    {Case Kind Of
      eClassic :
      eExtended      :
      eIntf    :
      eRec     :
      Else
        Result := 0;
    End;}
  End;

  Function TghRTTI.TRTTIMethodHelper.ghGetClass :TghClassRef;
  Begin
    Result := TghClassRef (ClassType);
  End;

  Function TghRTTI.TRTTIMethodHelper.ghInternalExHandle :PVMTMethodExEntry;
  Begin
    Result := Handle;
  End;

  { TghRTTI.TRTTIPackageHelper }

  Function TghRTTI.TRTTIPackageHelper.ghHandleToObject
    :TDictionary <Pointer, TRTTIObject>;
  Begin
    Result := Self.FHandleToObject;
  End;

  { TghRTTI.TTypeInfoHelper }

  Function TghRTTI.TTypeInfoHelper.ghAttr <T> :T;
  Var
    LAttr :TCustomAttribute;
  Begin
    For LAttr In ghType.GetAttributes Do
      If LAttr Is T Then
        System.Exit (LAttr.ghAsPtr);

    Result := Nil;
  End;

  Function TghRTTI.TTypeInfoHelper.ghAttr <T>
    (Out AAnnotatedParent :PTypeInfo) :T;
  Begin
    AAnnotatedParent := @Self;

    While TghSys.SetBlank (Result, AAnnotatedParent.ghAttr <T>.ghAsPtr) And
    TghSys.SetSolid (AAnnotatedParent, AAnnotatedParent.ghParent) Do;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckAttr <T> :T;
  Begin
    If TghSys.SetBlank (Result, ghAttr <T>.ghAsPtr) Then
      Exception.ghRaise (TghSys.ermTypeNoAttr, [Name, T.ClassName]);
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckAttr <T>
    (Out AAnnotatedParent :PTypeInfo) :T;
  Begin
    If TghSys.SetBlank (Result, ghAttr <T> (AAnnotatedParent).ghAsPtr) Then
      Exception.ghRaise (TghSys.ermTypeNoAttr, [Name, T.ClassName]);
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckClass :TClass;
  Begin
    Result := ghCheckKind (System.tkClass).TypeData.ClassType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckClassPtrAssignmentCompat (
    Const AValueInfo :PTypeInfo) :PTypeInfo;
  Begin
    If Not ghClassPtrAssignmentCompat (AValueInfo) Then
      ghRaiseIncompatibleTypes (AValueInfo);

    Result := AValueInfo;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckClassPtrAssignmentCompat <T>
    :PTypeInfo;
  Begin
    Result := ghCheckClassPtrAssignmentCompat (TghRTTI.Info <T>);
  End;

  ///probar
  Function TghRTTI.TTypeInfoHelper.ghCheckDescendantOf (
    Const AAncestor :TClass) :PTypeInfo;
  Begin
    If Not ghIsDescendantOf (AAncestor) Then
      Exception.ghRaise (TghSys.ermNotDescendant,
        [ghType.QualifiedName, AAncestor.QualifiedClassName]);

    Result := @Self;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckInstanceType :TghRTTIInstanceType;
  Begin
    Result := ghCheckKind (System.tkClass).ghInstanceType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckIntfType :TRTTIInterfaceType;
  Begin
    Result := ghCheckKind (System.tkInterface).ghIntfType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckKind (Const AKind :TTypeKind)
    :PTypeInfo;
  Begin
    If Kind <> AKind Then
      ghRaiseInvalid;

    Result := @Self;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckKind (Const AKinds :TTypeKinds)
    :PTypeInfo;
  Begin
    If Not (Kind In AKinds) Then
      ghRaiseInvalid;

    Result := @Self;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckPtrSize :Integer;
  Begin
    If TghSys.SetBlank (Result, ghPtrSize) Then
      ghRaiseInvalid;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckPtrTypeInfo (
    Const AKind :TTypeKind = System.tkUnknown) :PTypeInfo;
  Begin
    Result := ghPtrTypeInfo;

    If (Result = Nil) Or
    Not (AKind In [System.tkUnknown, Result.Kind]) Then
      ghRaiseInvalid;
  End;

  Function TghRTTI.TTypeInfoHelper.ghCheckRefClass :TClass;
  Begin
    Result := ghCheckKind (tkClassRef).ghRefClass;
  End;

  Function TghRTTI.TTypeInfoHelper.ghClassPtrAssignmentCompat (
    Const AValueInfo :PTypeInfo) :Boolean;
  Begin
    Result := TghRTTI.Virtual.ClassPtrAssignmentCompat (@Self, AValueInfo);
  End;

  Function TghRTTI.TTypeInfoHelper.ghClassPtrAssignmentCompat <T> :Boolean;
  Begin
    Result := ghClassPtrAssignmentCompat (TghRTTI.Info <T>);
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghCreateValue (Out ARef;
    AMakeObjRef :Boolean = False);
  Begin
    If TghSys.SetBool (
    AMakeObjRef, AMakeObjRef And (Kind = System.tkClass)) Then
      TghObs.UnmakeObjRef (ARef);

    ghNewValue (ARef);

    Try
      TghRTTI.Virtual.InternalCreateValue (ARef, @Self);

      If AMakeObjRef Then
        TghObs.MakeObjRef (ARef);
    Except
      ghFreeValue (ARef, AMakeObjRef);
      Raise;
    End;
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghFreeValue (Const ARef;
    Const AUnmakeObjRef :Boolean = False);
  Begin
    If AUnmakeObjRef And (Kind = System.tkClass) Then
      TghObs.UnmakeObjRef (ARef);

    TghRTTI.Virtual.FreeValue (ARef, @Self);
  End;

  Function TghRTTI.TTypeInfoHelper.ghGetAttr <T> (Out AAttr :T) :Boolean;
  Begin
    Result := TghSys.SetSolid (AAttr, ghAttr <T>.ghAsPtr);
  End;

  Function TghRTTI.TTypeInfoHelper.ghGetAttr <T> (Out AAttr :T;
    Out AAnnotatedParent :PTypeInfo) :Boolean;
  Begin
    Result := TghSys.SetSolid (
      AAttr, ghAttr <T> (AAnnotatedParent).ghAsPtr);
  End;

  Function TghRTTI.TTypeInfoHelper.ghGetIsClassOrPtr :Boolean;
  Begin
    Result := Kind In [System.tkClass, System.tkPointer];
  End;

  {}//mejorar con un case completo (sin llamar a ghType)
  Function TghRTTI.TTypeInfoHelper.ghGetSize :Integer;
  Begin
    Case Kind Of
      System.tkString : Result := TypeData.MaxLength + 1;
      System.tkArray  : Result := TypeData.ArrayData.Size;
      System.tkRecord : Result := TypeData.RecSize;
      Else
        Result := ghType.TypeSize;
    End;
  End;

  Function TghRTTI.TTypeInfoHelper.ghInstanceType :TghRTTIInstanceType;
  Begin
    Result := ghType.ghEnsureAs <TghRTTIInstanceType>
  End;

  Function TghRTTI.TTypeInfoHelper.ghIntfType :TRTTIInterfaceType;
  Begin
    Result := ghType As TRTTIInterfaceType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghIsDescendantOf (
    Const AAncestor :TClass) :Boolean;
  Begin
    Result := (Kind = System.tkClass) And
      TypeData.ClassType.InheritsFrom (AAncestor);
  End;

  Function TghRTTI.TTypeInfoHelper.ghIsUntypedPointer :Boolean;
  Begin
    Result := (Kind = System.tkPointer) And (TypeData.RefType = Nil);
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghNewValue (Out ARef);
  Begin
    TghRTTI.Virtual.NewValue (ARef, @Self);
  End;

  Function TghRTTI.TTypeInfoHelper.ghParent :PTypeInfo;
  Var
    LBase :TRTTIType Absolute Result;
  Begin
    If TghSys.SetSolid (LBase, ghType.BaseType) Then
      Result := LBase.Handle;
  End;

  Function TghRTTI.TTypeInfoHelper.ghPtrSize :Integer;
  Var
    LInfo :PTypeInfo;
  Begin
    If TghSys.Keep (Result, TghSys.SetSolid (LInfo, ghPtrTypeInfo)) Then
      Result := LInfo.ghSize;
  End;

  Function TghRTTI.TTypeInfoHelper.ghPtrTypeInfo :PTypeInfo;
  Var
    LRefType :PPTypeInfo Absolute Result;
  Begin
    { This method checks if Self is a typed pointer type description and
      returns the referenced type's description. }

    If TghSys.Keep (Result, Kind = System.tkPointer) And
    TghSys.SetSolid (LRefType, TypeData.RefType) Then
      Result := LRefType^;
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghRaiseIncompatibleTypes (
    Const AInfo :PTypeInfo);
  Begin
    Exception.ghRaise (TghSys.ermIncompatibleTypes, [Name, AInfo.Name]);
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghRaiseIncompatibleTypes <T>;
  Begin
    ghRaiseIncompatibleTypes (TghRTTI.Info <T>);
  End;

  Procedure TghRTTI.TTypeInfoHelper.ghRaiseInvalid;
  Begin
    Exception.ghRaise (TghSys.ermInvalidType, [Name]);
  End;

  Function TghRTTI.TTypeInfoHelper.ghRecType :TRTTIRecordType;
  Begin
    Result := ghType As TRTTIRecordType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghRefClass :TClass;
  Begin
    If TghSys.Keep (Result, Kind = System.tkClassRef) Then
      Result := TypeData.InstanceType^.TypeData.ClassType;
  End;

  Function TghRTTI.TTypeInfoHelper.ghType :TRTTIType;
  Begin
    Result := TghRTTI.Context.GetType (@Self);
  End;

  { TghRTTI.TVirtual }

  Class Function TghRTTI.TVirtual.AssignmentCompat (AClass :TClass;
    AInfo :PTypeInfo) :Boolean;
  Begin
    { This method returns True if a value of AInfo type can be assigned to
      a object variable of AClass type. }

    Result := AInfo.ghIsDescendantOf (AClass) Or
      AInfo.ghIsUntypedPointer;
  End;

  Class Function TghRTTI.TVirtual.ClassPtrAssignmentCompat (
    AInfo1, AInfo2 :PTypeInfo) :Boolean;
  Begin
    { This method returns True if a object/pointer value of AInfo2 type can
      be assigned to a object/pointer variable of AInfo1 type. }

    Case AInfo1.Kind Of
      System.tkClass   :
        Result := (AInfo1 = AInfo2) Or
          AssignmentCompat (AInfo1.TypeData.ClassType, AInfo2);

      System.tkPointer :
        If AInfo1 = AInfo2 Then
          Result := System.True
        Else
          If AInfo1.TypeData.RefType = Nil Then
            Result := AInfo2.Kind In [System.tkClass, System.tkPointer]
          Else
            Result := (AInfo2.TypeData.RefType = Nil) Or
              (AInfo2.TypeData.RefType = AInfo1.TypeData.RefType)
      Else
        Result := System.False;
    End;
  End;

  Class Procedure TghRTTI.TVirtual.FreeValue (Const ARef;
    AInfo :PTypeInfo);
  Begin
    Case AInfo.Kind Of
      System.tkClass   : TObject (ARef).Free;
      System.tkPointer : Pointer (ARef).ghFree;
    End;
  End;

  Class Procedure TghRTTI.TVirtual.InternalCreateValue (Out ARef;
    AInfo :PTypeInfo);
  Begin
    If AInfo.Kind = System.tkClass Then
      TObject (ARef).ghConstruct;
  End;

  Class Procedure TghRTTI.TVirtual.NewValue (Out ARef; AInfo :PTypeInfo);
  Var
    ASize :Integer;
  Begin
    Case AInfo.Kind Of
      System.tkString  : ShortString (ARef) := '';  // AValue [0] := 0;

      System.tkClass   :
        TObject (ARef) := AInfo.TypeData.ClassType.NewInstance;

      System.tkVariant : TVarData (ARef).VType := System.varEmpty;

      Else
      Begin
        ASize := AInfo.ghPtrSize;

        If ASize > 0 Then  // Blank memory allocation for typed pointers
          Pointer (ARef) := System.AllocMem (ASize)
        Else  // Simple blanking for another types
          (@ARef).ghClear (AInfo.ghSize);
      End;
    End;
  End;

  { Constructors and destructors }

  // Call back routine
  Procedure OnUnloadModule (Const AInstance :THandle);
  Var
    LPackage :TRTTIPackage;
  Begin
    { If descriptions related to the AInstance package must be freed now.
      NOTE: This helps to resolve a bug related to packages with custom
      attributes (quality report RSP-11620). }
    If TghRTTI.AutoFreeDescs Then
      For LPackage In TghRTTI.Context.GetPackages Do
        If TghRTTI.VerifyFreeDescs (LPackage, AInstance) Then
          Break;
  End;

  Class Constructor TghRTTI.Create;
  Begin
    TVirtual.ghInitVirtualClass (FVirtual);
    AddModuleUnloadProc (TModuleUnloadProcLW (@OnUnloadModule));
    AutoFreeDescs := System.True;
  End;

  Class Destructor TghRTTI.Destroy;
  Var
    LInfo :TPair <Pointer, TRTTIObject>;
    LPackage :TRTTIPackage;
  Begin
    { We restore the class of the extended class type descriptions (from
      TghRTTIInstanceType to TRTTIInstanceType again).  NOTE: This is
      necessary if we are removing a package from the IDE, since the
      TghRTTIInstanceType class is in that package. }
    For LPackage In Context.GetPackages Do
      If Not (AutoFreeDescs And VerifyFreeDescs (LPackage, HInstance)) Then
        For LInfo In LPackage.ghHandleToObject Do
          If (PTypeInfo (LInfo.Key).Kind = System.tkClass) And {}//comparar velocidad sin esta condición
          (LInfo.Value.ClassType = TghRTTIInstanceType) Then
            TghSys.PClass (LInfo.Value)^ := TRTTIInstanceType;

    { NOTE: This call must be done here, before the Finalization section of
      the System unit calls FinalizeMemoryManager. }
    RemoveModuleUnloadProc (TModuleUnloadProcLW (@OnUnloadModule));

    Finalized := System.True;
    FContext.Free;

    {}//posible destrucción por destructor de TghObs (observación de objetos globales)
    {}//O simple liberador de array de objetos (ver creaciones y considerar similar a Reg en TObjectHelper)
    TghSys.FreeClear ([@FCompiledTypes, @FTypes, @NotCollectedChildClasses]);
    TVirtual.ghFinalizeVirtualClass;
  End;

  { Protected static class methods }

  {}//probar
  Class Function TghRTTI.ExMethodSample :TRTTIMethod;
  Begin
    Result := Info <
      TClassMethodContainer>.ghInstanceType.ghInternalDeclaredMethods^ [0];
  End;

  {}//probar
  Class Function TghRTTI.GetClassicMethodClass :TRTTIMethod.TghClassRef;
  Var
    LExMethod :TRTTIMethod Absolute Result;
  Begin
    LExMethod := ExMethodSample;
    Result := (LExMethod.Package.ghHandleToObject [
      LExMethod.ghInternalExHandle.Entry] As TRTTIMethod).ghClass;
  End;

  Class Function TghRTTI.GetContext :PRTTIContext;
  Begin
    ghCheckClassFinalized (Finalized);

    // If our context has not yet been initialized
    If FContext.ghContextToken = Nil Then
      FContext := TRTTIContext.Create;

    Result := @FContext;
  End;

  Class Function TghRTTI.GetExMethodClass :TRTTIMethod.TghClassRef;
  Begin
    Result := ExMethodSample.ghClass;
  End;

  {}//probar
  Class Function TghRTTI.GetIntfMethodClass :TRTTIMethod.TghClassRef;
  Begin
    Result := Info <IIntfMethodContainer>.ghIntfType.
      ghInternalDeclaredMethods^ [0].ghClass;
  End;

  {}//probar
  Class Function TghRTTI.GetRecMethodClass :TRTTIMethod.TghClassRef;
  Begin
    Result := Info <TRecMethodContainer>.ghRecType.
      GetDeclaredMethods [0].ghClass;
  End;

  Class Function TghRTTI.GetTypes (Const AKind :TTypeKind)
    :TghList <TRTTIType>;
  Begin
    ghCheckClassFinalized (Finalized);

    If FTypes = Nil Then
    Begin
      FTypes := TghTypeListDic.Create;

      { If the list of compiled types is already loaded or the
        TghRTTI.CompiledTypes property is referenced. }
      If (FCompiledTypes <> Nil) Or (Context.FindType (
      'GHF.RTTI.TghRTTI.CompiledTypesMark') <> Nil) Then
        FTypes.FeedValues.AddRange (
          TghList <Pointer> (InternalGetCompiledTypes))
      Else
        FTypes.FeedValues.AddRange (TArray <Pointer> (Context.GetTypes));
    End;

    Result := FTypes [AKind];
  End;

  Class Function TghRTTI.InternalGetCompiledTypes :TghList <TRTTIType>;
  Begin
    If FCompiledTypes = Nil Then
      TghList <TRTTIType>.Create (Context.GetTypes).ghSetRef (
        FCompiledTypes);

    Result := FCompiledTypes;
  End;

  Class Procedure TghRTTI.SetVirtual (Const AValue :TVirtual.TClassRef);
  Begin
    TVirtual.ghSetVirtualClass (AValue);
  End;

  Class Function TghRTTI.VerifyFreeDescs (Const APackage :TRTTIPackage;
    Const AHandle :THandle) :Boolean;
  Begin
    If TghSys.SetBool (Result, APackage.Handle = AHandle) Then
      // We free the TRTTIObject instances (descriptions) of the package
      APackage.ghHandleToObject.Clear;
  End;

  { Public static class methods }

  Class Function TghRTTI.FormatTypeNames <T1, T2> (Const AFormat :String)
    :String;
  Begin
    Result := System.SysUtils.Format (
      AFormat, [Info <T1>.Name, Info <T2>.Name]);
  End;

  Class Procedure TghRTTI.InitChildren (
    Const AInstanceType :TghRTTIInstanceType);
  Var
    LType :TRTTIType;
  Begin
    If NotCollectedChildClasses = Nil Then
    Begin
      NotCollectedChildClasses := TghClassList <TClass>.Create;

      For LType In Types [System.tkClass] Do
        AInstanceType.Children.AddChild (AInstanceType.MetaclassType,
          (LType As TRTTIInstanceType).MetaclassType,
          NotCollectedChildClasses);
    End
    Else
      { We extract AInstanceType.MetaclassType's children from the
        NotCollectedChildClasses list, and add them to
        AInstanceType.Children. }
      NotCollectedChildClasses.ExtractChildren (
        AInstanceType.MetaclassType, AInstanceType.Children);
  End;

  Class Function TghRTTI.IntfGUID <T> :TGUID;
  Begin
    Result := Info <T>.TypeData.GUID;
  End;

End.

