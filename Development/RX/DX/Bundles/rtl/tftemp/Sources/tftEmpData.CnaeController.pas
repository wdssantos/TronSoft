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
  tftEmpModel.Cnae;

type
  TCnaeController = class(TtftFDController<TCNAE>)
  protected
    procedure BeforeSave; override;
    procedure SetPrimaryKeys; override;
  end;

implementation

{ TCnaeController }

procedure TCnaeController.BeforeSave;
begin
  inherited;
end;

procedure TCnaeController.SetPrimaryKeys;
begin
  PrimaryKeys.Add('CD_CNAE');
end;

end.
