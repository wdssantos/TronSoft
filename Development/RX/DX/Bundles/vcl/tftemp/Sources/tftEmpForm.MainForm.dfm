inherited frmMain: TfrmMain
  Caption = 'Cadastro de Empresa'
  ClientHeight = 204
  ClientWidth = 442
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 458
  ExplicitHeight = 243
  PixelsPerInch = 96
  TextHeight = 13
  object labCNPJ: TLabel
    Left = 8
    Top = 30
    Width = 29
    Height = 13
    Caption = 'CNPJ:'
  end
  object labRAZAO_SOCIAL: TLabel
    Left = 8
    Top = 73
    Width = 64
    Height = 13
    Caption = 'Raz'#227'o Social:'
  end
  object labNOME_FANTASIA: TLabel
    Left = 224
    Top = 73
    Width = 75
    Height = 13
    Caption = 'Nome Fantasia:'
  end
  object labDT_ABERTURA: TLabel
    Left = 125
    Top = 30
    Width = 47
    Height = 13
    Caption = 'Abertura:'
  end
  object labCD_CNAE_1: TLabel
    Left = 8
    Top = 117
    Width = 57
    Height = 13
    Caption = 'CD CNAE 1:'
  end
  object labCD_CNAE_2: TLabel
    Left = 224
    Top = 117
    Width = 57
    Height = 13
    Caption = 'CD CNAE 2:'
  end
  object labIfo: TLabel
    Left = 8
    Top = 8
    Width = 144
    Height = 13
    Caption = 'Digite um CNPJ para consultar'
  end
  object edtCNPJ: TMaskEdit
    Left = 8
    Top = 46
    Width = 111
    Height = 21
    EditMask = '99.999.999/9999-99;0;_'
    MaxLength = 18
    TabOrder = 0
    Text = ''
    OnExit = edtCNPJExit
  end
  object edtRAZAO_SOCIAL: TEdit
    Left = 8
    Top = 89
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object edtNOME_FANTASIA: TEdit
    Left = 224
    Top = 89
    Width = 209
    Height = 21
    TabOrder = 3
  end
  object edtDT_ABERTURA: TMaskEdit
    Left = 125
    Top = 46
    Width = 74
    Height = 21
    EditMask = '!##/##/####;1;_'
    MaxLength = 10
    TabOrder = 1
    Text = '  /  /    '
  end
  object cbxCD_CNAE_1: TComboBox
    Left = 8
    Top = 132
    Width = 210
    Height = 21
    Style = csDropDownList
    TabOrder = 4
  end
  object cbxCD_CNAE_2: TComboBox
    Left = 224
    Top = 132
    Width = 209
    Height = 21
    Style = csDropDownList
    TabOrder = 5
  end
  object btnPost: TButton
    Left = 358
    Top = 169
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Salvar'
    TabOrder = 8
    OnClick = btnPostClick
  end
  object btnNew: TButton
    Left = 277
    Top = 169
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Novo'
    TabOrder = 7
    OnClick = btnNewClick
  end
  object btnDel: TButton
    Left = 8
    Top = 169
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Excluir'
    TabOrder = 6
    OnClick = btnDelClick
  end
end
