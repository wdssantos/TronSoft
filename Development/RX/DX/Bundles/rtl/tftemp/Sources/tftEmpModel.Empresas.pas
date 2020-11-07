{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpModel.Empresas;

interface

uses
{PROJETO}
  tftCore.Controller;

type
  TEmpresa = class(TtftEntity)
  strict private
    FCNPJ: string;
    FRAZAO_SOCIAL: string;
    FDT_ABERTURA: TDate;
    FNOME_FANTASIA: string;
    FCD_CNAE_2: string;
    FCD_CNAE_1: string;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property RAZAO_SOCIAL: string read FRAZAO_SOCIAL write FRAZAO_SOCIAL;
    property NOME_FANTASIA: string read FNOME_FANTASIA write FNOME_FANTASIA;
    property DT_ABERTURA: TDate read FDT_ABERTURA write FDT_ABERTURA;
    property CD_CNAE_1: string read FCD_CNAE_1 write FCD_CNAE_1;
    property CD_CNAE_2: string read FCD_CNAE_2 write FCD_CNAE_2;
  end;

implementation

end.
