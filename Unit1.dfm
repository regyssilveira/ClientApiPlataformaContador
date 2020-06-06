object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 486
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 127
    Width = 807
    Height = 356
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    TabWidth = 150
    object TabSheet1: TTabSheet
      Caption = 'Envio por string'
      object Panel1: TPanel
        Left = 0
        Top = 287
        Width = 799
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        object BtnEnviarString: TButton
          AlignWithMargins = True
          Left = 661
          Top = 3
          Width = 135
          Height = 35
          Align = alRight
          Caption = 'Enviar'
          TabOrder = 1
          OnClick = BtnEnviarStringClick
        end
        object BtnCarregarArquivoXML: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 135
          Height = 35
          Align = alLeft
          Caption = 'Abrir arquivo...'
          TabOrder = 0
          OnClick = BtnCarregarArquivoXMLClick
        end
      end
      object MemStringXML: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 793
        Height = 281
        Align = alClient
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Envio por arquivo'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 287
        Width = 799
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object BtnEnviarArquivo: TButton
          AlignWithMargins = True
          Left = 661
          Top = 3
          Width = 135
          Height = 35
          Align = alRight
          Caption = 'Enviar Arquivo...'
          TabOrder = 0
          OnClick = BtnEnviarArquivoClick
        end
      end
    end
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 807
    Height = 118
    Align = alTop
    Caption = 'Login'
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 65
      Width = 36
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object Label2: TLabel
      Left = 165
      Top = 65
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object Label3: TLabel
      Left = 15
      Top = 22
      Width = 70
      Height = 13
      Caption = 'CNPJ Emitente'
    end
    object Label4: TLabel
      Left = 122
      Top = 22
      Width = 38
      Height = 13
      Caption = 'Url Host'
    end
    object BtnLogin: TButton
      Left = 325
      Top = 65
      Width = 135
      Height = 40
      Caption = 'Login'
      TabOrder = 2
      OnClick = BtnLoginClick
    end
    object EdtUsuario: TEdit
      Left = 15
      Top = 81
      Width = 144
      Height = 21
      TabOrder = 3
      Text = 'admin@admin.com'
    end
    object EdtSenha: TEdit
      Left = 165
      Top = 81
      Width = 144
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
      Text = 'admin321#@!'
    end
    object EdtCNPJEmitente: TEdit
      Left = 15
      Top = 38
      Width = 101
      Height = 21
      TabOrder = 0
      Text = '34252121000142'
    end
    object EdtUrlHost: TEdit
      Left = 122
      Top = 38
      Width = 187
      Height = 21
      TabOrder = 1
      Text = 'http://sandbox.plataformadocontador.com.br'
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.xml'
    Filter = 'arquivos xml|*.xml'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = 'Abrir Arquivo XML'
    Left = 400
    Top = 250
  end
end
