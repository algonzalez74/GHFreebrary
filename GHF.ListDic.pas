{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.ListDic.pas - TghListDic class unit.                                }
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

Unit GHF.ListDic;  { List Dictionary }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Dic, GHF.List;

  Type
    {}//problema ya no presente en XE7, refactorizar
    { NOTE: We avoid using generic object parameters with default value in
      methods of generic classes, because these cause Internal Error
      URW1154 when those classes are referenced from another unit (quality
      report #129713). }

    { List Dictionary class }
    TghListDic <TKey, ATItem> = Class (TghDic <TKey, TghList <ATItem>>)
      Protected
        { Virtual instance methods }
        Function FeedItem (Const Value :Pointer) :ATItem; Virtual;

        { Overridden instance methods }
        Procedure HandleAbsentKey (Const Key :TKey); Override;
      Public
        { Overridden instance methods }
        Procedure AfterConstruction; Override;
    End;

Implementation

  Uses
    GHF.Sys, GHF.SysEx, System.TypInfo;

  { TghListDic <TKey, ATItem> }

  { Protected virtual instance methods }

  Function TghListDic <TKey, ATItem>.FeedItem (Const Value :Pointer)
    :ATItem;
  Begin
    Result := TghSys.RawCast <Pointer, ATItem> (Value);
  End;

  { Protected overridden instance methods }


  Procedure TghListDic <TKey, ATItem>.HandleAbsentKey (Const Key :TKey);
  Var
    NewList :TghList <ATItem>;
  Begin
    NewList := Nil;
    FFeedValues.Extract <TKey> (Key, VerifyFeedValue,

      Procedure (Const Value :Pointer; Const Key :TKey)
      Begin
        If NewList = Nil Then
        Begin
          NewList := TghList <ATItem>.Create;
          ghHold (NewList);
          Add (Key, NewList);
        End;

        NewList.Add (FeedItem (Value));
      End);
  End;

  { Public overridden instance methods }

  Procedure TghListDic <TKey, ATItem>.AfterConstruction;
  Begin
    Inherited AfterConstruction;
    FeedValuesDirect := System.False;
  End;

End.



