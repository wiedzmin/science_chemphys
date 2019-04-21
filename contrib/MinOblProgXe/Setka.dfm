object Form6: TForm6
  Left = 256
  Top = 178
  Width = 696
  Height = 480
  Caption = 'Form6'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 657
    Height = 417
    TabOrder = 0
    object Label1: TLabel
      Left = 144
      Top = 88
      Width = 76
      Height = 13
      Caption = #1064#1072#1075' '#1089#1077#1090#1082#1080' '#1087#1086' b'
    end
    object Label2: TLabel
      Left = 144
      Top = 144
      Width = 82
      Height = 13
      Caption = #1064#1072#1075' '#1089#1077#1090#1082#1080' '#1087#1086' tet'
    end
    object Label3: TLabel
      Left = 144
      Top = 200
      Width = 75
      Height = 13
      Caption = #1064#1072#1075' '#1089#1077#1090#1082#1080' '#1087#1086' fi'
    end
    object Label4: TLabel
      Left = 200
      Top = 32
      Width = 105
      Height = 13
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1096#1072#1075#1080' '#1089#1077#1090#1082#1080':'
    end
    object Label6: TLabel
      Left = 11
      Top = 384
      Width = 3
      Height = 13
    end
    object Label5: TLabel
      Left = 8
      Top = 360
      Width = 3
      Height = 13
    end
    object Label7: TLabel
      Left = 184
      Top = 240
      Width = 22
      Height = 13
      Caption = 'bmin'
    end
    object Label8: TLabel
      Left = 296
      Top = 240
      Width = 28
      Height = 13
      Caption = 'tetmin'
    end
    object Label9: TLabel
      Left = 432
      Top = 240
      Width = 21
      Height = 13
      Caption = 'fimin'
    end
    object Label10: TLabel
      Left = 296
      Top = 304
      Width = 6
      Height = 13
      Caption = 'b'
    end
    object Label11: TLabel
      Left = 384
      Top = 304
      Width = 12
      Height = 13
      Caption = 'tet'
    end
    object Label12: TLabel
      Left = 520
      Top = 304
      Width = 5
      Height = 13
      Caption = 'fi'
    end
    object Edit1: TEdit
      Left = 240
      Top = 80
      Width = 177
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 240
      Top = 136
      Width = 177
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 240
      Top = 192
      Width = 177
      Height = 21
      TabOrder = 2
    end
    object Button1: TButton
      Left = 168
      Top = 344
      Width = 121
      Height = 33
      Caption = #1047#1072#1087#1091#1089#1082
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 376
      Top = 344
      Width = 129
      Height = 33
      Caption = #1042#1086#1079#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1088#1072#1089#1095#1077#1090#1072
      TabOrder = 4
      OnClick = Button2Click
    end
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 400
      Width = 657
      Height = 17
      Min = 0
      Max = 100
      TabOrder = 5
    end
    object Edit4: TEdit
      Left = 152
      Top = 256
      Width = 89
      Height = 21
      TabOrder = 6
    end
    object Edit5: TEdit
      Left = 272
      Top = 256
      Width = 89
      Height = 21
      TabOrder = 7
    end
    object Edit6: TEdit
      Left = 400
      Top = 256
      Width = 89
      Height = 21
      TabOrder = 8
    end
    object RadioButton1: TRadioButton
      Left = 48
      Top = 288
      Width = 177
      Height = 17
      Caption = #1054#1082#1088#1077#1089#1090#1085#1086#1089#1090#1100' bmin,tetmin,fimin'
      TabOrder = 9
    end
    object RadioButton2: TRadioButton
      Left = 48
      Top = 304
      Width = 217
      Height = 25
      Caption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1086#1082#1088#1077#1089#1090#1085#1086#1089#1090#1100
      TabOrder = 10
    end
    object Edit7: TEdit
      Left = 312
      Top = 304
      Width = 57
      Height = 21
      TabOrder = 11
    end
    object Edit8: TEdit
      Left = 416
      Top = 304
      Width = 57
      Height = 21
      TabOrder = 12
    end
    object Edit9: TEdit
      Left = 528
      Top = 304
      Width = 73
      Height = 21
      TabOrder = 13
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 48
    Top = 96
  end
  object ExcelWorkbook1: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 512
    Top = 80
  end
  object ExcelApplication1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 512
    Top = 144
  end
  object ExcelWorksheet1: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 512
    Top = 192
  end
end
