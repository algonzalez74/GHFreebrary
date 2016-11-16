{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.InterfacedSingleton.pas - TghInterfacedSingleton class unit.        }
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

Unit GHF.InterfacedSingleton;  { Interfaced Singleton }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Uses
    GHF.InterfacedObj, GHF.Sys;

  Type
    { Interfaced Singleton class }
    TghInterfacedSingleton = Class (TghInterfacedObj)
      Protected
        { Virtual class methods }
        Class Function InstanceRef :TghSys.PObject; Virtual; Abstract;
      Public
        { Overridden instance methods }
        Procedure FreeInstance; Override;

        { Overridden class methods }
        Class Function NewInstance :TObject; Override;
    End;

Implementation

  Uses
    GHF.SysEx;

  { TghInterfacedSingleton }

  { Public overridden instance methods }

  Procedure TghInterfacedSingleton.FreeInstance;
  Begin
    InstanceRef^ := Nil;
    Inherited FreeInstance;
  End;

  { Public overridden class methods }

  Class Function TghInterfacedSingleton.NewInstance :TObject;
  Begin
    { NOTE: This form is not supported by the compiler due to use of
      "Inherited" (E2010 Incompatible types). }
    // Result := TghSys.NewSingleton (InstanceRef, Inherited NewInstance);

    Result := TghSys.NewSingleton (InstanceRef,
      Function :TObject
      Begin
        Result := Inherited NewInstance;
      End);
  End;

End.

