{}//Unit under construction, the author shall check the Uses clauses and Inline routines before removing this line.
{*************************************************************************}
{ GH Freebrary                                                            }
{                                                                         }
{ GHF.FDConnection.pas - TghFDConnection class unit.                      }
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

Unit GHF.FDConnection;  { FireDAC Connection }

{ NOTE: The only native unit scopes that should be unconditionally
  referenced, either directly or indirectly, from this code file are the
  System, Data and FireDAC unit scopes, except the System.Win and Data.Win
  sub-scopes. The intention is that this unit to be part of a central base
  that can be compiled into any project. }

{$ScopedEnums On}

Interface

  Uses
    FireDAC.Comp.Client;

  Type
    { FireDAC Connection class }
    TghFDConnection = Class (TFDConnection)
      Public
        { Regular instance methods }
        Procedure PrepareLogin (
          Const AServer, ADatabase, AUser, APassword :String);
        Function Query (Const AStatement :String;
          Const AParams :Array Of Variant) :TFDQuery;

        { Overridden instance methods }
        Procedure BeforeDestruction; Override;
    End;

Implementation

  Uses
    GHF.SysEx;

  { TghFDConnection }

  Procedure TghFDConnection.BeforeDestruction;
  Begin
    ghPreDestroy;
    Inherited BeforeDestruction;
  End;

  Procedure TghFDConnection.PrepareLogin (
    Const AServer, ADatabase, AUser, APassword :String);
  Begin
    Params.Values ['Server'] := AServer;
    Params.Values ['Database'] := ADatabase;
    Params.Values ['User_Name'] := AUser;
    Params.Values ['Password'] := APassword;
  End;

  Function TghFDConnection.Query (Const AStatement :String;
    Const AParams :Array Of Variant) :TFDQuery;
  Var
    I :Integer;
  Begin
    Result := TFDQuery.Create (Self);

    Try
      Result.Connection := Self;
      Result.SQL.Text := AStatement;

      For I := 0 To Result.ParamCount - 1 Do
        Result.Params [I].Value := AParams [I];

      Result.Open;
    Except
      Result.Free;
      Raise;
    End;
  End;

End.

