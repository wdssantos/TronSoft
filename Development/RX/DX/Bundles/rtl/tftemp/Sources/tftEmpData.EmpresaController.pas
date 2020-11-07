{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpData.EmpresaController;

interface

uses
{PROJETO}
  tftData.FDController,
  tftData.Messages,
  tftEmpModel.Empresas,
{IDE}
  System.SysUtils;

type
  ECNPJException = class(Exception);
  ECD_CNAE_1Exception = class(Exception);

  TEmpresaController = class(TtftFDController<TEmpresa>)
  protected
    procedure BeforeInsertOrUpdate; override;
    procedure SetPrimaryKeys; override;
  end;

implementation

uses
{PROJETO}
  tftCore.Controller;

{ TEmpresaController }

procedure TEmpresaController.BeforeInsertOrUpdate;
begin
  if Entity.CNPJ.Trim.IsEmpty then
  begin
    raise ECNPJException.CreateFmt(SRequiredField, ['CNPJ']);
  end;

  if Entity.CD_CNAE_1.Trim.IsEmpty then
  begin
    raise ECD_CNAE_1Exception.CreateFmt(SRequiredField, ['CD_CNAE_1']);
  end;
end;

procedure TEmpresaController.SetPrimaryKeys;
begin
  PrimaryKeys.Add('CNPJ');
end;

end.

