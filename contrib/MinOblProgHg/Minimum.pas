unit Minimum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, opengl, math, AppEvnts, ExtCtrls, StdCtrls, ComCtrls, jpeg;

type
  point = record
    eini, erel: real;
    bet, tet, fi: real;
    emolec, eout: real;
    rekomb, molec: boolean;
  end;
  TForm1 = class(TForm)
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Eini: TLabel;
    Erel: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label4: TLabel;
    Edit3: TEdit;
    CheckBox5: TCheckBox;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    eps1, r: real;
    number: integer;
    t, ini, center, xc: point;
    sympl: array [1..4] of point;
    a00, a01, a02, a03: point;
    fmax, fmin: real;
    fnext, fnext2: real;
    process: integer;
    atom: string;
    filename: string;
    procedure fn;
    procedure getsymplex;
    procedure Saveinit;
    procedure savecenter;
    function GetFileName: integer;
    procedure savefunction;
    procedure sortpoints;
    procedure minimization;
    procedure invertion;
    procedure extension;
    procedure intension;
    procedure reduction;
    procedure senddata;
    procedure getdata;
    procedure Initpoint;
  end;

var
  Form1: TForm1;

implementation
uses
  area, traj_Hg, traj_Xe, traj_Kr, setka;

{$R *.dfm}

procedure TForm1.Saveinit;
// вывод каждой начальной точки поиска в файл
var
  tf: textfile;
  fname: string;
begin
  fname := atom + 'InitPoint' + edit1.Text + edit2.Text + inttostr(number) + '.txt';
  assignfile(tf, fname);
  if fileexists(fname) then begin
    append(tf);
  end else begin
    rewrite(tf);
  end;
  if atom = 'Hg' then begin
    if form3.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form3.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form3.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Xe' then begin
    if form4.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1,'        ',
                  1,'        ',
                  floattostrf(form4.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form4.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Kr' then begin
    if form5.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form5.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form5.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZJ, fffixed, 7, 6));
    end;
  end;
  Closefile(tf);
end;

procedure TForm1.Savecenter;
// вывод каждого центра симплекса в файл
var
  tf: textfile;
  fname: string;
begin
  fname := atom + edit1.Text + edit2.Text + 'Center' + inttostr(number) + '.txt';
  assignfile(tf, fname);
  if fileexists(fname) then begin
    append(tf);
  end else begin
    rewrite(tf);
  end;
  if atom = 'Hg' then begin
    if form3.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrsf(t.eini, fffixed, 7, 3), '        ',
                    floattostrsf(t.erel, fffixed, 7, 3), '        ',
                    floattostrsf(t.bet, fffixed, 7, 3), '        ',
                    floattostrsf(t.tet, fffixed, 7, 3), '        ',
                    floattostrsf(t.fi, fffixed, 7, 3), '        ',
                    floattostrsf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1,'        ',
                  1,'        ',
                  floattostrf(form3.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form3.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Xe' then begin
    if form4.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form4.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form4.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Kr' then begin
    if form5.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form5.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form5.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZJ, fffixed, 7, 6));
    end;
  end;
  Closefile(tf);
end;

procedure TForm1.SaveFunction;
// вывод каждой вершины симплекса в файл
var
  tf: textfile;
  fname: string;
begin
  fname := atom + edit1.Text + edit2.Text + 'SymplexPoints' + inttostr(number) + '.txt';
  assignfile(tf, fname);
  if fileexists(fname) then begin
    append(tf);
  end else begin
    rewrite(tf);
  end;
  if atom = 'Hg' then begin
    if form3.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form3.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form3.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form3.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Xe' then begin
    if form4.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form4.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form4.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form4.ZJ, fffixed, 7, 6));
    end;
  end;
  if atom = 'Kr' then begin
    if form5.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    1, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end else begin
        writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                    floattostrf(t.erel, fffixed, 7, 3), '        ',
                    floattostrf(t.bet, fffixed, 7, 3), '        ',
                    floattostrf(t.tet, fffixed, 7, 3), '        ',
                    floattostrf(t.fi, fffixed, 7, 3), '        ',
                    floattostrf(t.emolec, fffixed, 7, 6), '        ',
                    floattostrf(t.eout, fffixed, 7, 6), '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0, '        ',
                    0);
      end;
    end else begin
      writeln(tf, floattostrf(t.eini, fffixed, 7, 3), '        ',
                  floattostrf(t.erel, fffixed, 7, 3), '        ',
                  floattostrf(t.bet, fffixed, 7, 3), '        ',
                  floattostrf(t.tet, fffixed, 7, 3), '        ',
                  floattostrf(t.fi, fffixed, 7, 3), '        ',
                  floattostrf(t.emolec, fffixed, 7, 6), '        ',
                  floattostrf(t.eout, fffixed, 7, 6), '        ',
                  1, '        ',
                  1, '        ',
                  floattostrf(form5.evib0, fffixed, 7, 6), '        ',
                  floattostrf(form5.erot0, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZV, fffixed, 7, 6), '        ',
                  floattostrf(form5.ZJ, fffixed, 7, 6));
    end;
  end;
  Closefile(tf);
end;

procedure TForm1.Getsymplex;
var
  i: integer;
begin
  t.tet := t.tet/30;
  t.fi := t.fi/30;
  fn;
  ini := t;
  center := t;
  number := getfilename;
  saveinit;
  savecenter;
  for i := 1 to 4 do begin
    sympl[i].eini := t.eini;
    sympl[i].erel := t.erel;
  end;
  t.tet := t.tet/30;
  t.fi := t.fi/30;
  sympl[1].eini := t.eini;
  sympl[2].eini := t.eini;
  sympl[3].eini := t.eini;
  sympl[4].eini := t.eini;
  sympl[1].erel := t.erel;
  sympl[2].erel := t.erel;
  sympl[3].erel := t.erel;
  sympl[4].erel := t.erel;
  sympl[1].bet := t.bet - sqrt(6)/3;
  sympl[1].tet := t.tet - sqrt(2)/3*r;
  sympl[1].fi := t.fi - r/3;
  sympl[2].bet := t.bet;
  sympl[2].tet := t.tet + 2*sqrt(2)/3*r;
  sympl[2].fi := t.fi - r/3;
  sympl[3].bet := t.bet + sqrt(6)/3*r;
  sympl[3].tet := t.tet - sqrt(2)/3*r;
  sympl[3].fi := t.fi - r/3;
  sympl[4].bet := t.bet + 0;
  sympl[4].tet := t.tet + 0;
  sympl[4].fi := t.fi + r;
  for i := 1 to 4 do begin
    t := sympl[i];
    fn;
    savefunction;
    sympl[i].emolec := t.emolec;
    sympl[i].eout := t.eout;
    sympl[i].rekomb := t.rekomb;
    sympl[i].molec := t.molec;
  end;
end;

procedure TForm1.sortpoints;
var
  bufer: point;
  bufer1: array [1..4] of point;
  i, i1: integer;
begin
  i1 := 0;
  for i := 1 to 4 do begin
    bufer1[i] := sympl[i];
    if sympl[i].molec = false then begin
      sympl[i].emolec := 999;
      inc(i1);
    end;
  end;
  if i1 = 4 then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    Initpoint;
    eps1 := 0.001;
    if r > 0.001 then r := r - 0.001;
    filename := atom + edit1.Text + edit2.Text + 'Center' + inttostr(number) + '.txt';
    deletefile(filename);
    filename := atom + edit1.Text + edit2.Text + 'SymplexPoints' + inttostr(number) + '.txt';
    deletefile(filename);
    getsymplex;
    minimization;
    exit;
  end;
  if sympl[1].emolec < sympl[2].emolec then begin
    bufer := sympl[1];
    sympl[1] := sympl[2];
    sympl[2] := bufer;
  end;
  if sympl[1].emolec < sympl[3].emolec then begin
    bufer := sympl[1];
    sympl[1] := sympl[3];
    sympl[3] := bufer;
  end;
  if sympl[1].emolec < sympl[4].emolec then begin
    bufer := sympl[1];
    sympl[1] := sympl[4];
    sympl[4] := bufer;
  end;
  if sympl[2].emolec < sympl[3].emolec then begin
    bufer := sympl[2];
    sympl[2] := sympl[3];
    sympl[3] := bufer;
  end;
  if sympl[2].emolec < sympl[4].emolec then begin
    bufer := sympl[2];
    sympl[2] := sympl[4];
    sympl[4] := bufer;
  end;
  if sympl[3].emolec < sympl[4].emolec then begin
    bufer := sympl[3];
    sympl[3] := sympl[4];
    sympl[4] := bufer;
  end;
  for i := 1 to 4 do begin
    sympl[i].emolec := bufer1[i].emolec;
  end;
end;

procedure TForm1.minimization;
var
  i: integer;
  t1: point;
begin
  repeat
    sortpoints;
    fmax := sympl[1].emolec;
    fmin := sympl[4].emolec;
    xc.bet := 1/3*(sympl[2].bet + sympl[3].bet + sympl[4].bet);
    xc.tet := 1/3*(sympl[2].tet + sympl[3].tet + sympl[4].tet);
    xc.fi := 1/3*(sympl[2].fi + sympl[3].fi + sympl[4].fi);
    invertion;
    for i := 1 to 4 do begin
      t := sympl[i];
      fn;
      sympl[i].emolec := t.emolec;
      sympl[i].eout := t.eout;
      sympl[i].rekomb := t.rekomb;
      sympl[i].molec := t.molec;
      savefunction;
    end;
    t1 := center;
    center.bet := 1/4 * (sympl[1].bet + sympl[2].bet + sympl[3].bet + sympl[4].bet);
    center.tet := 1/4 * (sympl[1].tet + sympl[2].tet + sympl[3].tet + sympl[4].tet);
    center.fi := 1/4 * (sympl[1].fi + sympl[2].fi + sympl[3].fi + sympl[4].fi);
    if (center.bet < 0) or (center.tet < 0) then begin
      t.eini := strtofloat(Edit1.Text);
      t.erel := strtofloat(Edit2.Text);
      Initpoint;
      eps1 := 0.001;
      filename := atom + edit1.Text + edit2.Text + 'Center' + inttostr(number) + '.txt';
      deletefile(filename);
      filename := atom + edit1.Text + edit2.Text + 'SymplexPoints' + inttostr(number) + '.txt';
      deletefile(filename);
      getsymplex;
      minimization;
      exit;
    end;
    if (center.bet = t1.tet) and (center.tet = center.tet) and (center.fi = center.fi) then exit;
    t := center;
    fn;
    center.emolec := t.emolec;
    center.eout := t.eout;
    center.rekomb := t.rekomb;
    center.molec := t.molec;
    savecenter;
  until 1/4 * (sqrt(sqr(sympl[1].emolec - center.emolec) +
                      sqr(sympl[2].emolec - center.emolec) +
                      sqr(sympl[3].emolec - center.emolec) +
                      sqr(sympl[4].emolec - center.emolec))) <= eps1;
end;

procedure TForm1.invertion;
begin
  a00 := sympl[1];
  a01.eini := t.eini;
  a01.erel := t.erel;
  a01.bet := xc.bet + 1 * (xc.bet - a00.bet);
  a01.tet := xc.tet + 1 * (xc.tet - a00.tet);
  a01.fi := xc.fi + 1 * (xc.fi - a00.fi);
  t := a01;
  fn;
  a01.emolec := t.emolec;
  fnext := a01.emolec;
  if (sympl[1].molec = false) and (a01.molec = false) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    Initpoint;
    eps1 := 0.001;
    filename := atom + edit1.Text + edit2.Text + 'Center' + inttostr(number) + '.txt';
    deletefile(filename);
    filename := atom + edit1.Text + edit2.Text + 'SymplexPoints' + inttostr(number) + '.txt';
    deletefile(filename);
    getsymplex;
    if process = 1 then minimization;
    if process = 2 then form2.Rekombination;
    exit;
  end;
  extension;
  intension;
  reduction;
end;

procedure TForm1.extension;
begin
  if fnext <= fmin then begin
    a02.eini := t.eini;
    a02.erel := t.erel;
    a02.bet := xc.bet + 2 * (a01.bet - xc.bet);
    a02.tet := xc.tet + 2 * (a01.tet - xc.tet);
    a02.fi := xc.fi + 2 * (a01.fi - xc.fi);
    t := a02;
    fn;
    a02.emolec := t.emolec;
    fnext2 := a02.emolec;
    if fnext2 < fmin then begin
      sympl[1] := a02;
    end else begin
      sympl[1] := a01;
    end;
  end else begin
    sympl[1] := a01;
  end;
end;

procedure TForm1.intension;
begin
  if (fnext > sympl[2].emolec) and (fnext > sympl[3].emolec) and (fnext > sympl[4].emolec) then begin
    a03.eini := t.eini;
    a03.erel := t.erel;
    a03.bet := xc.bet + 0.5 * (sympl[1].bet - xc.bet);
    a03.tet := xc.tet + 0.5 * (sympl[1].tet - xc.tet);
    a03.fi := xc.fi + 0.5 * (sympl[1].fi - xc.fi);
    t := a03;
    fn;
    a03.emolec := t.emolec;
    sympl[1] := a03;
  end;
end;

procedure TForm1.reduction;
begin
  if fnext > fmax then begin
    sympl[1].bet := sympl[4].bet + 0.5 * (sympl[1].bet - sympl[4].bet);
    sympl[1].tet := sympl[4].tet + 0.5 * (sympl[1].tet - sympl[4].tet);
    sympl[1].fi := sympl[4].fi + 0.5 * (sympl[1].fi - sympl[4].fi);
    sympl[2].bet := sympl[4].bet + 0.5 * (sympl[2].bet - sympl[4].bet);
    sympl[2].tet := sympl[4].tet + 0.5 * (sympl[2].tet - sympl[4].tet);
    sympl[2].fi := sympl[4].fi + 0.5 * (sympl[2].fi - sympl[4].fi);
    sympl[3].bet := sympl[4].bet + 0.5 * (sympl[3].bet - sympl[4].bet);
    sympl[3].tet := sympl[4].tet + 0.5 * (sympl[3].tet - sympl[4].tet);
    sympl[3].fi := sympl[4].fi + 0.5 * (sympl[3].fi - sympl[4].fi);
    sympl[4].bet := sympl[4].bet + 0.5 * (sympl[4].bet - sympl[4].bet);
    sympl[4].tet := sympl[4].tet + 0.5 * (sympl[4].tet - sympl[4].tet);
    sympl[4].fi := sympl[4].fi + 0.5 * (sympl[4].fi - sympl[4].fi);
  end;
end;

procedure TForm1.fn;
begin
  t.tet := t.tet * 30;
  t.fi := t.fi * 30;
  senddata;
  getdata;
end;

procedure TForm1.senddata;
begin
  if atom = 'Hg' then begin
    form3.t.eini := t.eini;
    form3.t.erel := t.erel;
    form3.t.bet := t.bet;
    form3.t.tet := t.tet;
    form3.t.fi := t.fi;
    form3.t.emolec := t.emolec;
    form3.t.eout := t.eout;
    form3.t.rekomb := t.rekomb;
    form3.t.molec := t.molec;
    form3.ReadIni;
    form3.Init;
    form3.Culc_traj;
  end;
  if atom = 'Xe' then begin
    form4.t.eini := t.eini;
    form4.t.erel := t.erel;
    form4.t.bet := t.bet;
    form4.t.tet := t.tet;
    form4.t.fi := t.fi;
    form4.t.emolec := t.emolec;
    form4.t.eout := t.eout;
    form4.t.rekomb := t.rekomb;
    form4.t.molec := t.molec;
    form4.ReadIni;
    form4.Init;
    form4.Culc_traj;
  end;
  if atom = 'Kr' then begin
    form5.t.eini := t.eini;
    form5.t.erel := t.erel;
    form5.t.bet := t.bet;
    form5.t.tet := t.tet;
    form5.t.fi := t.fi;
    form5.t.emolec := t.emolec;
    form5.t.eout := t.eout;
    form5.t.rekomb := t.rekomb;
    form5.t.molec := t.molec;
    form5.ReadIni;
    form5.Init;
    form5.Culc_traj;
  end;
end;

procedure TForm1.getdata;
begin
  if atom = 'Hg' then begin
    t.eini := form3.t.eini;
    t.erel := form3.t.erel;
    t.bet := form3.t.bet;
    t.tet := form3.t.tet;
    t.fi := form3.t.fi;
    t.emolec := form3.t.emolec;
    t.eout := form3.t.eout;
    t.rekomb := form3.t.rekomb;
    t.molec := form3.t.molec;
  end;
  if atom = 'Xe' then begin
    t.eini := form4.t.eini;
    t.erel := form4.t.erel;
    t.bet := form4.t.bet;
    t.tet := form4.t.tet;
    t.fi := form4.t.fi;
    t.emolec := form4.t.emolec;
    t.eout := form4.t.eout;
    t.rekomb := form4.t.rekomb;
    t.molec := form4.t.molec;
  end;
  if atom = 'Kr' then begin
    t.eini := form5.t.eini;
    t.erel := form5.t.erel;
    t.bet := form5.t.bet;
    t.tet := form5.t.tet;
    t.fi := form5.t.fi;
    t.emolec := form5.t.emolec;
    t.eout := form5.t.eout;
    t.rekomb := form5.t.rekomb;
    t.molec := form5.t.molec;
  end;
end;

function TForm1.GetFileName;
var
  sr: TSearchRec;
  tname: string;
  max,tt: integer;
begin
  max := 0;
  if FindFirst(atom + edit1.Text + edit2.Text + 'Center*.txt', faAnyFile, sr) = 0 then
  begin
    repeat
      tname := sr.Name;
      delete(tname, length(tname) - 3,4);
      if ((t.eini = 10) and (t.erel < 10)) or ((t.eini < 10) and (t.erel = 10)) then delete(tname, 1, 11);
      if ((t.eini = 10) and (t.erel = 10)) then delete(tname, 1, 12);
      if ((t.eini < 10) and (t.erel < 10)) then delete(tname, 1, 10);
      try
        tt := strtoint(tname);
      except
        on EconvertError do tt := 0;
      end;
      if tt > max then max := tt;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  result := max + 1;
end;

procedure TForm1.Initpoint;
begin
  randomize;
  t.bet := 0 + 3 * random;
  t.tet := 0 + 180 * random;
  t.fi := 0 + 360 * random;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  if RadioButton1.Checked then atom := 'Hg';
  if RadioButton2.Checked then atom := 'Xe';
  if RadioButton3.Checked then atom := 'Kr';
  if (checkbox1.Checked) and not(Checkbox2.Checked) and not(checkbox5.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    for i := 1 to 100 do begin
      Initpoint;
      eps1 := 0.001;
      r := 1;
      process := 1;
      getsymplex;
      minimization;
    end;
  end;
  if (checkbox1.Checked) and not(Checkbox2.Checked) and (checkbox5.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    repeat
      repeat
        for i := 1 to 100 do begin
          Initpoint;
          eps1 := 0.001;
          r := 1;
          process := 1;
          getsymplex;
          minimization;
        end;
        t.erel := t.erel + 1;
        edit2.Text := floattostr(t.erel);
      until ((t.erel = 11) and (t.eini < strtofloat(edit4.Text))) or ((t.erel = strtofloat(edit5.Text) + 1) and (t.eini = strtofloat(edit4.Text)));
      t.eini := t.eini + 1;
      edit1.Text := floattostr(t.eini);
      t.erel := 1;
      edit2.Text := floattostr(t.erel);
    until (t.eini = strtofloat(edit4.Text) + 1);
  end;
  if (checkbox2.Checked) and not(Checkbox1.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    process := 2;
    form2.Rekombination;
  end;
  if (checkbox1.Checked) and (Checkbox2.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    for i := 1 to 5 do begin
      Initpoint;
      eps1 := 0.001;
      r := 1;
      process := 1;
      getsymplex;
      minimization;
    end;
    process := 2;
    form2.Rekombination;
  end;
  if checkbox3.Checked then begin
    form1.Hide;
    form6.Show;
  end;
  if checkbox4.checked then form6.allsetka;
  CheckBox1.Checked := false;
  CheckBox2.Checked := false;
  checkbox3.Checked := false;
  RadioButton1.Checked := false;
  RadioButton2.Checked := false;
  RadioButton3.Checked := false;
  // process := 0;
  // atom := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CheckBox1.Checked := false;
  CheckBox2.Checked := false;
  RadioButton1.Checked := false;
  RadioButton2.Checked := false;
  RadioButton3.Checked := false;
  process := 0;
  atom := '';
end;

end.
