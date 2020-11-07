{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpModel.Cnae;

interface

uses
{PROJETO}
  tftCore.Controller;

type
  TCNAE = class(TtftEntity)
  strict private
    FCD_CNAE: string;
    FDS_CNAE: string;
  public
    property CD_CNAE: string read FCD_CNAE write FCD_CNAE;
    property DS_CNAE: string read FDS_CNAE write FDS_CNAE;
  end;

implementation

end.
