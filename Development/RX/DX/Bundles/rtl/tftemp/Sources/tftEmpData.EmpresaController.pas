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
  tftEmpModel.Empresas;

type
  TEmpresaController = class(TtftFDController<TEmpresa>)
  protected
    procedure BeforeSave; override;
    procedure SetPrimaryKeys; override;
  end;

implementation

{ TEmpresaController }

procedure TEmpresaController.BeforeSave;
begin
  inherited;
end;

procedure TEmpresaController.SetPrimaryKeys;
begin
  PrimaryKeys.Add('CNPJ');
end;

end.
