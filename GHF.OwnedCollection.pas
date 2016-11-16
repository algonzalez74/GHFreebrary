{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.OwnedCollection.pas - TghOwnedCollection class unit.                }
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

Unit GHF.OwnedCollection;  { Owned Collection }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

{}//prefijo A en parámetros

Interface

  Uses
    System.Classes, GHF.Obs;

  Type
    { Owned Collection class }
    TghOwnedCollection = Class (TOwnedCollection)
      Protected
        { Instance fields }
        ItemObserver :IghObserver;

        { Overridden instance methods }
        Procedure Notify (Item :TCollectionItem;
          Action :TCollectionNotification); Override;
      Public
        Constructor Create (Const AOwner :TPersistent;
          Const AItemClass :TCollectionItemClass;
          Const AItemObserver :IghObserver = Nil); Virtual;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;
    End;

    { Owned Collection class }
    TghOwnedCollection <T :TCollectionItem> = Class (TghOwnedCollection)
      Protected
        { Regular instance methods }
        Function GetItem (Const Index :Integer) :T;
        Procedure SetItem (Const Index :Integer; Const Value :T);
      Public
        Constructor Create (Const AOwner :TPersistent;
          Const AItemObserver :IghObserver = Nil); Reintroduce; Virtual;

        { Regular instance methods }
        Function Add :T;

        { Instance properties }
        Property Items [Const Index :Integer] :T Read GetItem
          Write SetItem; Default;
    End;

Implementation

  Uses
    GHF.SysEx;

  { TghOwnedCollection }

  Constructor TghOwnedCollection.Create (Const AOwner :TPersistent;
    Const AItemClass :TCollectionItemClass;
    Const AItemObserver :IghObserver = Nil);
  Begin
    Inherited Create (AOwner, AItemClass);
    ItemObserver := AItemObserver;
  End;

  { Protected overridden instance methods }

  Procedure TghOwnedCollection.Notify (Item :TCollectionItem;
    Action :TCollectionNotification);
  Begin
    Inherited Notify (Item, Action);

    If ItemObserver <> Nil Then
      Item.ghAttachOrDetachObserver (ItemObserver,
        Action = System.Classes.cnAdded);
  End;

  { Public overridden instance methods }

  Procedure TghOwnedCollection.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

  { TghOwnedCollection <T> }

  Constructor TghOwnedCollection <T>.Create (Const AOwner :TPersistent;
    Const AItemObserver :IghObserver = Nil);
  Begin
    Inherited Create (AOwner, T, AItemObserver);
  End;

  { Protected regular instance methods }

  Function TghOwnedCollection <T>.GetItem (Const Index :Integer) :T;
  Begin
    Result := T (Inherited GetItem (Index));
  End;

  Procedure TghOwnedCollection <T>.SetItem (Const Index :Integer;
    Const Value :T);
  Begin
    Inherited SetItem (Index, Value);
  End;

  { Public regular instance methods }

  Function TghOwnedCollection <T>.Add :T;
  Begin
    Result := T (Inherited Add);
  End;

End.

