{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpData.SessionDam;

interface

uses
{PROJETO}
  tftData.SessionBase,
{IDE}
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.VCLUI.Wait,
  FireDAC.Phys.IBBase, System.Classes, Data.DB, FireDAC.Comp.Client, FireDAC.ConsoleUI.Wait;

type
  TdamSession = class(TdamSessionBase)
    Connection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
