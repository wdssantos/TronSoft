program tftEmp;

uses
{PROJETO}
  tftEmpData.Session,
  tftEmpData.SessionDam,
  tftEmpForm.MainForm,
{IDE}
  Vcl.Forms;

{$R *.res}

var
  frmMain: TfrmMain;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdamSession, damSession);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
