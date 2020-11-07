{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpData.CnaeController;

interface

uses
{PROJETO}
  tftData.FDController,
  tftData.Messages,
  tftEmpModel.Cnae,
{IDE}
  System.SysUtils;

type
  ECD_CNAEException = class(Exception);

  TCnaeController = class(TtftFDController<TCNAE>)
  protected
    procedure BeforeSave; override;
    procedure SetPrimaryKeys; override;
  end;

implementation

{ TCnaeController }

procedure TCnaeController.BeforeSave;
begin
  if Entity.CD_CNAE.Trim.IsEmpty then
  begin
    raise ECD_CNAEException.CreateFmt(SRequiredField, ['CD_CNAE']);
  end;

end;

procedure TCnaeController.SetPrimaryKeys;
begin
  PrimaryKeys.Add('CD_CNAE');
end;

end.

