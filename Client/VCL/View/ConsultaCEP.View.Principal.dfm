object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Consulta de CEP'
  ClientHeight = 310
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 321
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 317
    object CEP: TLabeledEdit
      Left = 20
      Top = 32
      Width = 121
      Height = 23
      EditLabel.Width = 21
      EditLabel.Height = 15
      EditLabel.Caption = 'CEP'
      TabOrder = 0
      Text = ''
      OnKeyDown = CEPKeyDown
    end
    object BtConsulta: TButton
      Left = 168
      Top = 31
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 1
      OnClick = BtConsultaClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 81
    Width = 321
    Height = 229
    Align = alClient
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 1
    ExplicitWidth = 317
    ExplicitHeight = 228
    object Label1: TLabel
      Left = 24
      Top = 5
      Width = 24
      Height = 15
      Caption = 'CEP:'
    end
    object lbl_CEP: TLabel
      Left = 109
      Top = 5
      Width = 9
      Height = 15
      Caption = '...'
    end
    object Label2: TLabel
      Left = 24
      Top = 24
      Width = 23
      Height = 15
      Caption = 'Rua:'
    end
    object lbl_Rua: TLabel
      Left = 109
      Top = 24
      Width = 9
      Height = 15
      Caption = '...'
    end
    object Label4: TLabel
      Left = 24
      Top = 43
      Width = 80
      Height = 15
      Caption = 'Complemento:'
    end
    object lbl_Complemento: TLabel
      Left = 109
      Top = 43
      Width = 9
      Height = 15
      Caption = '...'
    end
    object Label3: TLabel
      Left = 24
      Top = 63
      Width = 34
      Height = 15
      Caption = 'Bairro:'
    end
    object lbl_Bairro: TLabel
      Left = 109
      Top = 63
      Width = 9
      Height = 15
      Caption = '...'
    end
    object Label7: TLabel
      Left = 24
      Top = 82
      Width = 40
      Height = 15
      Caption = 'Cidade:'
    end
    object lbl_Cidade: TLabel
      Left = 109
      Top = 82
      Width = 9
      Height = 15
      Caption = '...'
    end
    object Label9: TLabel
      Left = 24
      Top = 102
      Width = 17
      Height = 15
      Caption = 'UF:'
    end
    object lbl_UF: TLabel
      Left = 109
      Top = 102
      Width = 9
      Height = 15
      Caption = '...'
    end
  end
end
