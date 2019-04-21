object Form1: TForm1
  Left = 164
  Top = 206
  Width = 699
  Height = 502
  Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1099#1093' '#1091#1089#1083#1086#1074#1080#1081' '#1088#1077#1082#1086#1084#1073#1080#1085#1072#1094#1080#1080' '#1080#1086#1085#1086#1074' Cs+ '#1080' Br-'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 673
    Height = 457
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Eini: TLabel
      Left = 80
      Top = 208
      Width = 22
      Height = 16
      Caption = 'Eini'
    end
    object Erel: TLabel
      Left = 384
      Top = 208
      Width = 24
      Height = 16
      Caption = 'Erel'
    end
    object Label1: TLabel
      Left = 256
      Top = 16
      Width = 163
      Height = 16
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1088#1077#1090#1100#1077' '#1090#1077#1083#1086' R:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 168
      Top = 168
      Width = 291
      Height = 16
      Caption = #1042#1074#1086#1076' '#1101#1085#1077#1088#1075#1080#1081' '#1080#1089#1093#1086#1076#1085#1099#1093' '#1088#1077#1072#1075#1077#1085#1090#1086#1074' Eini '#1080' Erel:'
    end
    object Label3: TLabel
      Left = 272
      Top = 280
      Width = 75
      Height = 16
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100':'
    end
    object Label4: TLabel
      Left = 504
      Top = 16
      Width = 135
      Height = 16
      Caption = #1080#1079#1084#1077#1085#1077#1085#1085#1072#1103' '#1084#1072#1089#1089#1072' R'
    end
    object Label5: TLabel
      Left = 152
      Top = 232
      Width = 401
      Height = 16
      Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1090#1086#1095#1082#1072' '#1088#1072#1089#1095#1077#1090#1086#1074' ('#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1073#1086#1083#1100#1096#1086#1075#1086' '#1095#1080#1089#1083#1072' '#1091#1079#1083#1086#1074')'
    end
    object Label6: TLabel
      Left = 64
      Top = 264
      Width = 22
      Height = 16
      Caption = 'Eini'
    end
    object Label7: TLabel
      Left = 376
      Top = 264
      Width = 24
      Height = 16
      Caption = 'Erel'
    end
    object CheckBox1: TCheckBox
      Left = 24
      Top = 296
      Width = 625
      Height = 41
      Caption = 
        #1055#1086#1080#1089#1082' '#1090#1086#1095#1082#1080' '#1089' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1081' '#1089#1090#1072#1073#1080#1083#1080#1079#1072#1094#1080#1077#1081' '#1084#1086#1083#1077#1082#1091#1083#1099' CsBr '#1087#1088#1080' '#1076#1072#1085#1085#1099 +
        #1093' R, Eini '#1080' Erel'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 24
      Top = 336
      Width = 641
      Height = 25
      Caption = 
        #1055#1086#1080#1089#1082' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1085#1072#1095#1072#1083#1100#1085#1099#1093' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074', '#1087#1088#1080#1074#1086#1076#1103#1097#1080#1093' '#1082' '#1088#1077#1082#1086#1084#1073#1080#1085#1072#1094#1080#1080', ' +
        #1087#1088#1080' '#1076#1072#1085#1085#1099#1093' R, Eini '#1080' Erel'
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 112
      Top = 200
      Width = 137
      Height = 24
      TabOrder = 2
    end
    object Edit2: TEdit
      Left = 416
      Top = 200
      Width = 145
      Height = 24
      TabOrder = 3
    end
    object Button1: TButton
      Left = 272
      Top = 416
      Width = 97
      Height = 25
      Caption = #1047#1072#1087#1091#1089#1082
      TabOrder = 4
      OnClick = Button1Click
    end
    object RadioButton1: TRadioButton
      Left = 256
      Top = 40
      Width = 201
      Height = 25
      Caption = 'Hg'
      TabOrder = 5
    end
    object RadioButton2: TRadioButton
      Left = 256
      Top = 72
      Width = 265
      Height = 17
      Caption = 'Xe'
      TabOrder = 6
    end
    object RadioButton3: TRadioButton
      Left = 256
      Top = 96
      Width = 313
      Height = 25
      Caption = 'Kr'
      TabOrder = 7
    end
    object CheckBox3: TCheckBox
      Left = 24
      Top = 368
      Width = 633
      Height = 25
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1089#1077#1090#1082#1077
      TabOrder = 8
    end
    object CheckBox4: TCheckBox
      Left = 24
      Top = 400
      Width = 497
      Height = 17
      Caption = #1054#1073#1093#1086#1076' '#1074#1089#1077#1093' '#1091#1079#1083#1086#1074' '#1089#1077#1090#1082#1080
      TabOrder = 9
    end
    object CheckBox5: TCheckBox
      Left = 128
      Top = 136
      Width = 201
      Height = 17
      Caption = #1055#1086#1080#1089#1082' '#1089' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103#1084#1080
      TabOrder = 10
    end
    object Edit3: TEdit
      Left = 512
      Top = 40
      Width = 121
      Height = 24
      TabOrder = 11
    end
    object CheckBox6: TCheckBox
      Left = 336
      Top = 136
      Width = 313
      Height = 17
      Caption = #1041#1086#1083#1100#1096#1086#1077' '#1095#1080#1089#1083#1086' '#1091#1079#1083#1086#1074' '#1085#1072#1095#1080#1085#1072#1103' '#1086#1090' '#1074#1074#1077#1076#1077#1085#1085#1086#1075#1086
      TabOrder = 12
    end
    object Edit4: TEdit
      Left = 112
      Top = 256
      Width = 121
      Height = 24
      TabOrder = 13
      Text = '10'
    end
    object Edit5: TEdit
      Left = 424
      Top = 264
      Width = 121
      Height = 24
      TabOrder = 14
      Text = '10'
    end
  end
end
