{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.CustomRetrieve.pas - TghCustomRetrieve class unit.                  }
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

Unit GHF.CustomRetrieve;  { Custom Retrieve }

{ NOTE: The only native unit scope that should be unconditionally
  referenced, either directly or indirectly, from this code file is the
  System unit scope, except the System.Win sub-scope. The intention is that
  this unit to be part of a central base that can be compiled into any
  project. }

{$ScopedEnums On}

Interface

  Type
    {}//revisar si Owner y Param podrían ser el mismo, o si Param podría ser genérico,
    //y si debiera tener campo FOwner
    { Custom Retrieve class }
    TghCustomRetrieve = Class
      Protected
        { NOTE: You can override this protected constructor but don't call
          it directly, use the Get method. }
        Constructor Create (Owner :TObject; Param :Pointer); Overload;
          Virtual;

        { Virtual class methods }
        Class Function FindInstance (Param :Pointer) :TghCustomRetrieve;
          Virtual; Abstract;
      Public
        { Regular class methods }
        {}//posible conversión a constructores, con tercero para establecer variable
        Class Function Get (Const Owner :TObject;
          Const Param :Pointer) :Pointer; Overload;
        Class Function Get (Const Owner :TObject) :Pointer; Overload;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;
    End;

Implementation

  Uses
    GHF.Sys, GHF.SysEx, GHF.Obs;

  { TghCustomRetrieve }

  Constructor TghCustomRetrieve.Create (Owner :TObject; Param :Pointer);
  Begin
    Inherited Create;
    Owner.ghHold (Self);
  End;

  { Public regular class methods }

  Class Function TghCustomRetrieve.Get (Const Owner :TObject;
    Const Param :Pointer) :Pointer;
  Begin
    Result := FindInstance (Param);

    // If the instance does not exists, we create and initialize one.
    If Result = Nil Then
      Result := Self.Create (Owner, Param);
  End;

  Class Function TghCustomRetrieve.Get (Const Owner :TObject) :Pointer;
  Begin
    Result := Get (Owner, Owner);
  End;

  { Public overridden instance methods }

  Procedure TghCustomRetrieve.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

End.

