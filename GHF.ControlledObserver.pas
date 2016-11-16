{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.ControlledObserver.pas - TghControlledObserver class unit.          }
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

Unit GHF.ControlledObserver;  { Controlled Observer }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.Observer, GHF.Obs;

  Type
    { Controlled Observer class }
    TghControlledObserver = Class (TghObserver, IghControlledObserver)
      Protected
        Const
          { Flags }
          osfEnabled = $10000000;

        Var
          FlagsEventIDs :Integer;  // Flags and Events IDs (osfXXX, oeiXXX)

        { IghObserver }
        Procedure HandleEvent (AObj :TObject; AEventID :Integer); Override;

        { IghControlledObserver }
        Function GetEnabled :Boolean;
        Function GetEventIDs :Integer;
        Procedure SetEnabled (Value :Boolean);
        Procedure SetEventIDs (Value :Integer);
      Public
        Constructor Create (AHandler :TghObs.TObsEvent;
          AEventIDs :Integer = TghObs.oeiAllObjChanged); Overload; Virtual;
        Constructor Create (Const AHandler :TghObs.TObsEventRef;
          AEventIDs :Integer = TghObs.oeiAllObjChanged); Overload; Virtual;

        { Instance properties }
        Property Enabled :Boolean Read GetEnabled Write SetEnabled;
        Property EventIDs :Integer Read GetEventIDs Write SetEventIDs;
    End;

Implementation

  Uses
    GHF.Sys;

  { TghControlledObserver }

  Constructor TghControlledObserver.Create (AHandler :TghObs.TObsEvent;
    AEventIDs :Integer = TghObs.oeiAllObjChanged);
  Begin
    Inherited Create (AHandler);
    FlagsEventIDs := osfEnabled Or AEventIDs;
  End;

  Constructor TghControlledObserver.Create (
    Const AHandler :TghObs.TObsEventRef;
    AEventIDs :Integer = TghObs.oeiAllObjChanged);
  Begin
    Inherited Create (AHandler);
    FlagsEventIDs := osfEnabled Or AEventIDs;
  End;

  { IghObserver }

  Procedure TghControlledObserver.HandleEvent (AObj :TObject;
    AEventID :Integer);
  Begin
    If Enabled And TghSys.HasBitsOn (EventIDs, AEventID) Then
      Inherited HandleEvent (AObj, AEventID);
  End;

  { IghControlledObserver }

  Function TghControlledObserver.GetEnabled :Boolean;
  Begin
    Result := TghSys.HasBitOn (FlagsEventIDs, osfEnabled);
  End;

  Function TghControlledObserver.GetEventIDs :Integer;
  Begin
    Result := FlagsEventIDs And TghObs.oeiAll;
  End;

  Procedure TghControlledObserver.SetEnabled (Value :Boolean);
  Begin
    If Value = Enabled Then
      System.Exit;

    FlagsEventIDs := TghSys.TurnBits (FlagsEventIDs, osfEnabled, Value);
  End;

  Procedure TghControlledObserver.SetEventIDs (Value :Integer);
  Begin
    FlagsEventIDs := TghSys.SwitchBits (
      FlagsEventIDs, TghObs.oeiAll, Value);
  End;

End.

