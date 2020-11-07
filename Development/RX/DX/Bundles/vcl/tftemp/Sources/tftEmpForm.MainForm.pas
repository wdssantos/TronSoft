{ *********************************************************** }
{ *                                                         * }
{ *  TronSoft - Desenvolvimento de Software Especializado.  * }
{ *                                                         * }
{ *              Copyright(c) 2020 TronSoft.                * }
{ *                                                         * }
{ *********************************************************** }

unit tftEmpForm.MainForm;

interface

uses
{PROJETO}
  tftCore.RESTRequest,
  tftEmpData.CnaeController,
  tftEmpData.EmpresaController,
  tftEmpModel.Cnae,
  tftEmpModel.Empresas,
  tftForm.BaseForm,
{IDE}
  System.Classes, Vcl.StdCtrls, Vcl.Controls, Vcl.Mask;

type
  TfrmMain = class(TfrmBase)
    edtCNPJ: TMaskEdit;
    edtRAZAO_SOCIAL: TEdit;
    edtNOME_FANTASIA: TEdit;
    labCNPJ: TLabel;
    labRAZAO_SOCIAL: TLabel;
    labNOME_FANTASIA: TLabel;
    labDT_ABERTURA: TLabel;
    edtDT_ABERTURA: TMaskEdit;
    cbxCD_CNAE_1: TComboBox;
    cbxCD_CNAE_2: TComboBox;
    labCD_CNAE_1: TLabel;
    labCD_CNAE_2: TLabel;
    btnPost: TButton;
    btnNew: TButton;
    btnDel: TButton;
    labIfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    FCnaeController: TCnaeController;
    FEmpresa: TEmpresa;
    FEmpresaController: TEmpresaController;
    FSettings: TtftRESTRequest;
    procedure DoUpdate(const AEntity: TEmpresa);
  end;

implementation

uses
{PROJETO}
  tftCore.Controller,
  tftCore.RESTRequestParams,
  tftCore.RESTRequestTronSoftSimpleAuthenticator,
  tftEmpData.Session,
{IDE}
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  Vcl.Forms,
  Winapi.Windows;

{$R *.dfm}

procedure TfrmMain.edtCNPJExit(Sender: TObject);
begin
  if edtCNPJ.Modified then
  begin
    if string(edtCNPJ.Text).Trim <> '' then
    begin
      if Assigned(FEmpresa) then
      begin
        FreeAndNil(FEmpresa);
      end;
      try
        try
          FEmpresa := FEmpresaController.FirstOrDefault([string(edtCNPJ.Text).ToInt64]);
          if not Assigned(FEmpresa) then
          begin
            FEmpresa := TEmpresa.Create;
            FEmpresa.CNPJ := edtCNPJ.Text;
            FEmpresa.DT_ABERTURA := Date;
          end;
        except
          FEmpresa := TEmpresa.Create;
        end;
      finally
        DoUpdate(FEmpresa);
      end;
    end
    else
    begin
      FEmpresa := TEmpresa.Create;
      DoUpdate(FEmpresa);
    end;
    edtCNPJ.Modified := False;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  LCnae: TCNAE;
  LList: TList<TCNAE>;var
  LTronSoftSimple: TtftRESTRequestTronSoftSimpleAuthenticator;
begin
  inherited;

  FCnaeController := TCnaeController.Create(damSession.Connection);

  FSettings := TtftRESTRequest.Create;
  FSettings.Params.AuthMethod := TtftRESTAuthMethod.TronSoftSimple;

  LTronSoftSimple := TtftRESTRequestTronSoftSimpleAuthenticator(FSettings.Params.Authenticator);
  LTronSoftSimple.Active := True;
  LTronSoftSimple.SettingName := 'CNAE';
  LTronSoftSimple.ContentType := 'application/json';
  LTronSoftSimple.BaseURL := 'http://3.20.200.202:3333/cnae';
  LTronSoftSimple.SettingFileName := ChangeFileExt(Application.ExeName, '.ini');
  LTronSoftSimple.SaveSettings;

  try
    FSettings.Execute(
      procedure(AResponse: string)
        var
          LJSONArray: TJSONArray;
          LJSONProp: TJSONObject;
          LJSONValue: TJSONValue;
        begin
          if FSettings.ResponseCode = 200 then
          begin
            LJSONArray := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(AResponse), 0) as TJSONArray;
            if Assigned(LJSONArray) then
            begin
              for LJSONValue in LJSONArray do
              begin
                LJSONProp := LJSONValue as TJSONObject;
                if LJSONProp.Count = 0 then
                begin
                  Continue;
                end;
                LCnae := TCNAE.Create;
                try
                  LCnae.CD_CNAE := LJSONProp.Pairs[0].JsonValue.Value;
                  if not Assigned(FCnaeController.FirstOrDefault([LCnae.CD_CNAE])) then
                  begin
                    LCnae.DS_CNAE := LJSONProp.Pairs[1].JsonValue.Value;
                    FCnaeController.Save(LCnae);
                  end;
                finally
                  FreeAndNil(LCnae);
                end;
              end;
              FreeAndNIL(LJSONArray);
            end;
          end;
        end);
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(Format('Não foi possível carregar a lista de CNAE da web. Erro: %s.', [E.Message])), 'Informação', MB_ICONINFORMATION)
    end;
  end;

  FEmpresaController := TEmpresaController.Create(damSession.Connection);
  FEmpresa := TEmpresa.Create;

  LList := FCnaeController.ToList;
  try
    for LCnae in LList do
    begin
      cbxCD_CNAE_1.Items.AddObject(LCnae.DS_CNAE, LCnae);
      cbxCD_CNAE_2.Items.AddObject(LCnae.DS_CNAE, LCnae);
    end;
  finally
    FreeAndNil(LList);
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEmpresaController);
  FreeAndNil(FCnaeController);
  FreeAndNil(FEmpresa);
  FreeAndNil(FSettings);
  inherited;
end;

procedure TfrmMain.btnDelClick(Sender: TObject);
begin
  if (FEmpresa.CNPJ.Trim = '') or
    ((FEmpresa.CNPJ.Trim <> '') and
     (Application.MessageBox(PChar(Format('Tem certeza de que deseja excluir a empresa ''%s?''',
       [edtRAZAO_SOCIAL.Text])), 'Confirmação', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes)) then
  begin
    Exit;
  end;
  FEmpresaController.Entry(FEmpresa).State := TEntityState.Deleted;
  FEmpresaController.Save(FEmpresa);
  FreeAndNil(FEmpresa);
  FEmpresa := TEmpresa.Create;
  DoUpdate(FEmpresa);
  edtCNPJ.SetFocus;
end;

procedure TfrmMain.btnNewClick(Sender: TObject);
begin
  if Assigned(FEmpresa) then
  begin
    FreeAndNil(FEmpresa);
  end;
  FEmpresa := TEmpresa.Create;
  FEmpresa.DT_ABERTURA := Date;
  DoUpdate(FEmpresa);
  edtCNPJ.SetFocus;
end;

procedure TfrmMain.btnPostClick(Sender: TObject);
begin
  if not Assigned(FEmpresa) then
  begin
    Exit;
  end;

  FEmpresa.CNPJ := edtCNPJ.Text;
  FEmpresa.RAZAO_SOCIAL := edtRAZAO_SOCIAL.Text;
  FEmpresa.NOME_FANTASIA := edtNOME_FANTASIA.Text;
  FEmpresa.DT_ABERTURA := StrToDate(edtDT_ABERTURA.Text);

  if cbxCD_CNAE_1.ItemIndex > -1 then
  begin
    FEmpresa.CD_CNAE_1 := TCNAE(cbxCD_CNAE_1.Items.Objects[cbxCD_CNAE_1.ItemIndex]).CD_CNAE;
  end
  else
  begin
    FEmpresa.CD_CNAE_1 := '';
  end;

  if cbxCD_CNAE_2.ItemIndex > -1 then
  begin
    FEmpresa.CD_CNAE_2 := TCNAE(cbxCD_CNAE_2.Items.Objects[cbxCD_CNAE_2.ItemIndex]).CD_CNAE;
  end
  else
  begin
    FEmpresa.CD_CNAE_2 := '';
  end;

  FEmpresaController.Save(FEmpresa);
end;

procedure TfrmMain.DoUpdate(const AEntity: TEmpresa);
var
  LCnae: TCNAE;
begin
  edtCNPJ.Text := AEntity.CNPJ;

  if AEntity.DT_ABERTURA > 0 then
  begin
    edtDT_ABERTURA.Text := FormatDateTime('dd/mm/yyyy', AEntity.DT_ABERTURA);
  end
  else
  begin
    edtDT_ABERTURA.Clear;
  end;

  edtRAZAO_SOCIAL.Text := AEntity.RAZAO_SOCIAL;
  edtNOME_FANTASIA.Text := AEntity.NOME_FANTASIA;

  LCnae := FCnaeController.FirstOrDefault([AEntity.CD_CNAE_1]);
  if Assigned(LCnae) then
  begin
    cbxCD_CNAE_1.Text := LCnae.DS_CNAE;
    FreeAndNil(LCnae);
  end
  else
  begin
    cbxCD_CNAE_1.Text := '';
  end;

  LCnae := FCnaeController.FirstOrDefault([AEntity.CD_CNAE_2]);
  if Assigned(LCnae) then
  begin
    cbxCD_CNAE_2.Text := LCnae.DS_CNAE;
    FreeAndNil(LCnae);
  end
  else
  begin
    cbxCD_CNAE_2.Text := '';
  end;
end;

end.

