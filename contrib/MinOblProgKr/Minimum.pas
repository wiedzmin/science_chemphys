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
    CheckBox5: TCheckBox;
    Label4: TLabel;
    Edit3: TEdit;
    CheckBox6: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
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
  assignfile(tf,fname);
  if fileexists(fname) then begin
    append(tf);
  end else begin
    rewrite(tf);
  end;
  if form1.atom = 'Hg' then begin
    if form3.NLO <> 1 then begin
      if t.molec = true then begin
        writeln(tf, floattostrf(t.eini, ,7, 3) ,'         ',
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
  if form1.atom = 'Xe' then begin
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
  if form1.atom = 'Kr' then begin
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
  if form1.atom = 'Hg' then begin
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
  if form1.atom = 'Xe' then begin
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
  if form1.atom = 'Kr' then begin
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
  if form1.atom = 'Hg' then begin
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
  if form1.atom = 'Xe' then begin
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
                  (form4.evib0, fffixed, 7, 6), '        ',
                  (form4.erot0, fffixed, 7, 6), '        ',
                  (form4.ZV, fffixed, 7, 6), '        ',
                  (form4.ZJ, fffixed, 7, 6));
    end;
  end;
  if form1.atom = 'Kr' then begin
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
                  1,'        ',
                  1,'        ',
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
  t.tet := t.tet / 30;
  t.fi := t.fi / 30;
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
    if (sympl[i].bet < 0) and (atom = 'Hg') then begin
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
  end;
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
    center.bet := 1/4*(sympl[1].bet + sympl[2].bet + sympl[3].bet + sympl[4].bet);
    center.tet := 1/4*(sympl[1].tet + sympl[2].tet + sympl[3].tet + sympl[4].tet);
    center.fi := 1/4*(sympl[1].fi + sympl[2].fi + sympl[3].fi + sympl[4].fi);
    if (center.bet = t1.tet) and (center.tet = center.tet) and (center.fi = center.fi) then exit;
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
    t := center;
    fn;
    center.emolec := t.emolec;
    center.eout := t.eout;
    center.rekomb := t.rekomb;
    center.molec := t.molec;
    savecenter;
  until 1/4*(sqrt(sqr(sympl[1].emolec - center.emolec) +
                    sqr(sympl[2].emolec - center.emolec) +
                    sqr(sympl[3].emolec - center.emolec) +
                    sqr(sympl[4].emolec - center.emolec))) <= eps1;
end;

procedure TForm1.invertion;
begin
  a00 := sympl[1];
  a01.eini := t.eini;
  a01.erel := t.erel;
  a01.bet := xc.bet + 1*(xc.bet - a00.bet);
  a01.tet := xc.tet + 1*(xc.tet - a00.tet);
  a01.fi := xc.fi + 1*(xc.fi - a00.fi);
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
    if process=1 then minimization;
    if process=2 then form2.Rekombination;
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
    a02.bet := xc.bet + 2*(a01.bet - xc.bet);
    a02.tet := xc.tet + 2*(a01.tet - xc.tet);
    a02.fi := xc.fi + 2*(a01.fi - xc.fi);
    t := a02;
    fn;
    a02.emolec := t.emolec;
    fnext2 := a02.emolec;
    if fnext2<fmin then begin
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
    a03.bet := xc.bet + 0.5*(sympl[1].bet - xc.bet);
    a03.tet := xc.tet + 0.5*(sympl[1].tet - xc.tet);
    a03.fi := xc.fi + 0.5*(sympl[1].fi - xc.fi);
    t := a03;
    fn;
    a03.emolec := t.emolec;
    sympl[1] := a03;
  end;
end;

procedure TForm1.reduction;
begin
  if fnext > fmax then begin
    sympl[1].bet := sympl[4].bet + 0.5*(sympl[1].bet - sympl[4].bet);
    sympl[1].tet := sympl[4].tet + 0.5*(sympl[1].tet - sympl[4].tet);
    sympl[1].fi := sympl[4].fi + 0.5*(sympl[1].fi - sympl[4].fi);
    sympl[2].bet := sympl[4].bet + 0.5*(sympl[2].bet - sympl[4].bet);
    sympl[2].tet := sympl[4].tet + 0.5*(sympl[2].tet - sympl[4].tet);
    sympl[2].fi := sympl[4].fi + 0.5*(sympl[2].fi - sympl[4].fi);
    sympl[3].bet := sympl[4].bet + 0.5*(sympl[3].bet - sympl[4].bet);
    sympl[3].tet := sympl[4].tet + 0.5*(sympl[3].tet - sympl[4].tet);
    sympl[3].fi := sympl[4].fi + 0.5*(sympl[3].fi - sympl[4].fi);
    sympl[4].bet := sympl[4].bet + 0.5*(sympl[4].bet - sympl[4].bet);
    sympl[4].tet := sympl[4].tet + 0.5*(sympl[4].tet - sympl[4].tet);
    sympl[4].fi := sympl[4].fi + 0.5*(sympl[4].fi - sympl[4].fi);
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
  max, tt: integer;
begin
  max := 0;
  if FindFirst(atom + edit1.Text + edit2.Text + 'Center*.txt', faAnyFile, sr) = 0 then
  begin
    repeat
      tname := sr.Name;
      delete(tname,length(tname) - 3, 4);
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
  if checkbox5.Checked then begin
    if (t.erel = 1) and (t.eini = 1) then begin
      t.bet := 2.783 + 0.05 * random;
      t.tet := 71.285 + random * 0.1;
      t.fi := 95.165 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 1) then begin
      t.bet := 2.316 + 0.05 * random;
      t.tet := 76.47 + random * 0.1;
      t.fi := 97.78 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 1) then begin
      t.bet := 1.938 + 0.05 * random;
      t.tet := 78.791 + random * 0.1;
      t.fi := 99.609 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 1) then begin
      t.bet := 1.64 + 0.05 * random;
      t.tet := 78.777 + random * 0.1;
      t.fi := 100.737 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 1) then begin
      t.bet := 0.283 + 0.05 * random;
      t.tet := 94.836 + random * 0.1;
      t.fi := 179.931 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 1) then begin
      t.bet := 0.322 + 0.05 * random;
      t.tet := 61.604 + random * 0.1;
      t.fi := 188.579 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 1) then begin
      t.bet := 0.359 + 0.05 * random;
      t.tet := 59.734 + random * 0.1;
      t.fi := 179.711 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 1) then begin
      t.bet := 0.409 + 0.05 * random;
      t.tet := 58.136 + random * 0.1;
      t.fi := 180.165 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 1) then begin
      t.bet := 0.486 + 0.05 * random;
      t.tet := 56.172 + random * 0.1;
      t.fi := 180.254 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 1) then begin
      t.bet := 0.643 + 0.05 * random;
      t.tet := 53.561 + random * 0.1;
      t.fi := 182.976 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 2) then begin
      t.bet := 2.601 + 0.05 * random;
      t.tet := 66.353 + random * 0.1;
      t.fi := 98.816 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 2) then begin
      t.bet := 2.211 + 0.05 * random;
      t.tet := 73.562 + random * 0.1;
      t.fi := 100.144 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 2) then begin
      t.bet := 1.882 + 0.05 * random;
      t.tet := 76.644 + random * 0.1;
      t.fi := 101.391 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 2) then begin
      t.bet := 1.609 + 0.05 * random;
      t.tet := 77.569 + random * 0.1;
      t.fi := 102.348 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 2) then begin
      t.bet := 0.449 + 0.05 * random;
      t.tet := 90.977 + random * 0.1;
      t.fi := 177.088 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 2) then begin
      t.bet := 0.228 + 0.05 * random;
      t.tet := 94.696 + random * 0.1;
      t.fi := 181.273 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 2) then begin
      t.bet := 0.308 + 0.05 * random;
      t.tet := 59.904 + random * 0.1;
      t.fi := 156.103 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 2) then begin
      t.bet := 0.287 + 0.05 * random;
      t.tet := 59.258 + random * 0.1;
      t.fi := 180.179 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 2) then begin
      t.bet := 0.341 + 0.05 * random;
      t.tet := 57.748 + random * 0.1;
      t.fi := 179.987 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 2) then begin
      t.bet := 0.42 + 0.05 * random;
      t.tet := 58.203 + random * 0.1;
      t.fi := 119.741 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 3) then begin
      t.bet := 2.461 + 0.05 * random;
      t.tet := 61.399 + random * 0.1;
      t.fi := 102.96 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 3) then begin
      t.bet := 2.122 + 0.05 * random;
      t.tet := 70.795 + random * 0.1;
      t.fi := 102.568 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 3) then begin
      t.bet := 1.836 + 0.05 * random;
      t.tet := 74.798 + random * 0.1;
      t.fi := 103.12 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 3) then begin
      t.bet := 1.573 + 0.05 * random;
      t.tet := 76.279 + random * 0.1;
      t.fi := 104.076 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 3) then begin
      t.bet := 0.587 + 0.05 * random;
      t.tet := 87.605 + random * 0.1;
      t.fi := 177.837 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 3) then begin
      t.bet := 0.988 + 0.05 * random;
      t.tet := 65.652 + random * 0.1;
      t.fi := 103.293 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 3) then begin
      t.bet := 0.185 + 0.05 * random;
      t.tet := 61.148 + random * 0.1;
      t.fi := 188.117 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 3) then begin
      t.bet := 0.195 + 0.05 * random;
      t.tet := 59.888 + random * 0.1;
      t.fi := 178.154 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 3) then begin
      t.bet := 0.23 + 0.05 * random;
      t.tet := 58.778 + random * 0.1;
      t.fi := 179.608 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 3) then begin
      t.bet := 0.292 + 0.05 * random;
      t.tet := 57.288 + random * 0.1;
      t.fi := 181.309 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 4) then begin
      t.bet := 2.341 + 0.05 * random;
      t.tet := 55.937 + random * 0.1;
      t.fi := 108.871 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 4) then begin
      t.bet := 2.048 + 0.05 * random;
      t.tet := 68.118 + random * 0.1;
      t.fi := 105.161 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 4) then begin
      t.bet := 1.777 + 0.05 * random;
      t.tet := 72.59 + random * 0.1;
      t.fi := 105.594 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 4) then begin
      t.bet := 1.534 + 0.05 * random;
      t.tet := 74.768 + random * 0.1;
      t.fi := 106.067 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 4) then begin
      t.bet := 1.368 + 0.05 * random;
      t.tet := 73.392 + random * 0.1;
      t.fi := 103.618 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 4) then begin
      t.bet := 1.108 + 0.05 * random;
      t.tet := 67.269 + random * 0.1;
      t.fi := 101.497 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 4) then begin
      t.bet := 0.137 + 0.05 * random;
      t.tet := 61.059 + random * 0.1;
      t.fi := 169.253 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 4) then begin
      t.bet := 0.101 + 0.05 * random;
      t.tet := 60.408 + random * 0.1;
      t.fi := 182.585 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 4) then begin
      t.bet := 0.138 + 0.05 * random;
      t.tet := 59.425 + random * 0.1;
      t.fi := 181.479 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 4) then begin
      t.bet := 0.001 + 0.05 * random;
      t.tet := 59.099 + random * 0.1;
      t.fi := 90.09 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 5) then begin
      t.bet := 2.232 + 0.05 * random;
      t.tet := 48.441 + random * 0.1;
      t.fi := 120.881 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 5) then begin
      t.bet := 1.982 + 0.05 * random;
      t.tet := 65.373 + random * 0.1;
      t.fi := 108.077 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 5) then begin
      t.bet := 1.733 + 0.05 * random;
      t.tet := 70.673 + random * 0.1;
      t.fi := 107.674 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 5) then begin
      t.bet := 1.508 + 0.05 * random;
      t.tet := 73.268 + random * 0.1;
      t.fi := 107.771 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 5) then begin
      t.bet := 1.352 + 0.05 * random;
      t.tet := 73.032 + random * 0.1;
      t.fi := 105.083 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 5) then begin
      t.bet := 1.156 + 0.05 * random;
      t.tet := 68.223 + random * 0.1;
      t.fi := 100.799 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 5) then begin
      t.bet := 0.21 + 0.05 * random;
      t.tet := 61.043 + random * 0.1;
      t.fi := 125.578 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 5) then begin
      t.bet := 0.061 + 0.05 * random;
      t.tet := 60.644 + random * 0.1;
      t.fi := 114.146 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 5) then begin
      t.bet := 0.011 + 0.05 * random;
      t.tet := 60.084 + random * 0.1;
      t.fi := 93.856 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 5) then begin
      t.bet := 0 + 0.05 * random;
      t.tet := 59.317 + random * 0.1;
      t.fi := 88.497 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 6) then begin
      t.bet := 2.139 + 0.05 * random;
      t.tet := 36.96 + random * 0.1;
      t.fi := 158.818 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 6) then begin
      t.bet := 1.93 + 0.05 * random;
      t.tet := 62.788 + random * 0.1;
      t.fi := 110.754 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 6) then begin
      t.bet := 1.696 + 0.05 * random;
      t.tet := 68.68 + random * 0.1;
      t.fi := 109.966 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 6) then begin
      t.bet := 1.195 + 0.05 * random;
      t.tet := 72.803 + random * 0.1;
      t.fi := 145.745 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 6) then begin
      t.bet := 0.831 + 0.05 * random;
      t.tet := 79.471 + random * 0.1;
      t.fi := 176.698 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 6) then begin
      t.bet := 1.174 + 0.05 * random;
      t.tet := 68.641 + random * 0.1;
      t.fi := 101.146 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 6) then begin
      t.bet := 0.681 + 0.05 * random;
      t.tet := 62.887 + random * 0.1;
      t.fi := 100.096 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 6) then begin
      t.bet := 0.017 + 0.05 * random;
      t.tet := 60.587 + random * 0.1;
      t.fi := 100.355 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 6) then begin
      t.bet := 0.005 + 0.05 * random;
      t.tet := 59.997 + random * 0.1;
      t.fi := 38.451 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 6) then begin
      t.bet := 0.033 + 0.05 * random;
      t.tet := 59.304 + random * 0.1;
      t.fi := 136.489 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 7) then begin
      t.bet := 2.093 + 0.05 * random;
      t.tet := 35.483 + random * 0.1;
      t.fi := 153.038 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 7) then begin
      t.bet := 1.883 + 0.05 * random;
      t.tet := 59.218 + random * 0.1;
      t.fi := 117.635 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 7) then begin
      t.bet := 1.662 + 0.05 * random;
      t.tet := 66.747 + random * 0.1;
      t.fi := 112.329 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 7) then begin
      t.bet := 1.004 + 0.05 * random;
      t.tet := 75.41 + random * 0.1;
      t.fi := 170.798 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 7) then begin
      t.bet := 0.886 + 0.05 * random;
      t.tet := 77.162 + random * 0.1;
      t.fi := 176.39 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 7) then begin
      t.bet := 1.171 + 0.05 * random;
      t.tet := 68.191 + random * 0.1;
      t.fi := 102.529 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 7) then begin
      t.bet := 0.844 + 0.05 * random;
      t.tet := 64.047 + random * 0.1;
      t.fi := 98.252 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 7) then begin
      t.bet := 0.082 + 0.05 * random;
      t.tet := 59.889 + random * 0.1;
      t.fi := 121.717 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 7) then begin
      t.bet := 0.032 + 0.05 * random;
      t.tet := 59.989 + random * 0.1;
      t.fi := 71.458 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 7) then begin
      t.bet := 0.068 + 0.05 * random;
      t.tet := 61.035 + random * 0.1;
      t.fi := 67.897 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 8) then begin
      t.bet := 2.038 + 0.05 * random;
      t.tet := 34.404 + random * 0.1;
      t.fi := 145.731 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 8) then begin
      t.bet := 1.827 + 0.05 * random;
      t.tet := 56.728 + random * 0.1;
      t.fi := 120.336 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 8) then begin
      t.bet := 1.635 + 0.05 * random;
      t.tet := 64.66 + random * 0.1;
      t.fi := 115.779 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 8) then begin
      t.bet := 1.361 + 0.05 * random;
      t.tet := 68.501 + random * 0.1;
      t.fi := 124.75 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 8) then begin
      t.bet := 1.296 + 0.05 * random;
      t.tet := 70.45 + random * 0.1;
      t.fi := 109.822 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 8) then begin
      t.bet := 1.131 + 0.05 * random;
      t.tet := 70.793 + random * 0.1;
      t.fi := 106.16 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 8) then begin
      t.bet := 0.851 + 0.05 * random;
      t.tet := 64.183 + random * 0.1;
      t.fi := 99.517 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 8) then begin
      t.bet := 0.063 + 0.05 * random;
      t.tet := 60.171 + random * 0.1;
      t.fi := 72.138 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 8) then begin
      t.bet := 0.053 + 0.05 * random;
      t.tet := 59.825 + random * 0.1;
      t.fi := 77.511 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 8) then begin
      t.bet := 0.029 + 0.05 * random;
      t.tet := 59.397 + random * 0.1;
      t.fi := 81.58 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 9) then begin
      t.bet := 2.029 + 0.05 * random;
      t.tet := 29.398 + random * 0.1;
      t.fi := 161.758 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 9) then begin
      t.bet := 1.77 + 0.05 * random;
      t.tet := 52.657 + random * 0.1;
      t.fi := 131.639 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 9) then begin
      t.bet := 1.602 + 0.05 * random;
      t.tet := 63 + random * 0.1;
      t.fi := 117.579 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 9) then begin
      t.bet := 1.426 + 0.05 * random;
      t.tet := 67.412 + random * 0.1;
      t.fi := 115.24 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 9) then begin
      t.bet := 1.245 + 0.05 * random;
      t.tet := 70.256 + random * 0.1;
      t.fi := 115.951 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 9) then begin
      t.bet := 1.182 + 0.05 * random;
      t.tet := 68.351 + random * 0.1;
      t.fi := 103.301 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 9) then begin
      t.bet := 0.974 + 0.05 * random;
      t.tet := 65.029 + random * 0.1;
      t.fi := 97.432 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 9) then begin
      t.bet := 0.122 + 0.05 * random;
      t.tet := 59.973 + random * 0.1;
      t.fi := 69.817 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 9) then begin
      t.bet := 0.133 + 0.05 * random;
      t.tet := 59.818 + random * 0.1;
      t.fi := 51.78 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 9) then begin
      t.bet := 0.109 + 0.05 * random;
      t.tet := 59.412 + random * 0.1;
      t.fi := 63.578 + random * 0.1;
    end;
    if (t.erel = 1) and (t.eini = 10) then begin
      t.bet := 1.984 + 0.05 * random;
      t.tet := 34.264 + random * 0.1;
      t.fi := 127.523 + random * 0.1;
    end;
    if (t.erel = 2) and (t.eini = 10) then begin
      t.bet := 1.708 + 0.05 * random;
      t.tet := 46.577 + random * 0.1;
      t.fi := 178.345 + random * 0.1;
    end;
    if (t.erel = 3) and (t.eini = 10) then begin
      t.bet := 1.572 + 0.05 * random;
      t.tet := 61.03 + random * 0.1;
      t.fi := 121.27 + random * 0.1;
    end;
    if (t.erel = 4) and (t.eini = 10) then begin
      t.bet := 1.234 + 0.05 * random;
      t.tet := 65.556 + random * 0.1;
      t.fi := 159.228 + random * 0.1;
    end;
    if (t.erel = 5) and (t.eini = 10) then begin
      t.bet := 1.296 + 0.05 * random;
      t.tet := 67.861 + random * 0.1;
      t.fi := 111.09 + random * 0.1;
    end;
    if (t.erel = 6) and (t.eini = 10) then begin
      t.bet := 1.011 + 0.05 * random;
      t.tet := 69.508 + random * 0.1;
      t.fi := 127.175 + random * 0.1;
    end;
    if (t.erel = 7) and (t.eini = 10) then begin
      t.bet := 1.01 + 0.05 * random;
      t.tet := 65.231 + random * 0.1;
      t.fi := 97.497 + random * 0.1;
    end;
    if (t.erel = 8) and (t.eini = 10) then begin
      t.bet := 0.569 + 0.05 * random;
      t.tet := 61.183 + random * 0.1;
      t.fi := 89.186 + random * 0.1;
    end;
    if (t.erel = 9) and (t.eini = 10) then begin
      t.bet := 0.176 + 0.05 * random;
      t.tet := 59.671 + random * 0.1;
      t.fi := 43.484 + random * 0.1;
    end;
    if (t.erel = 10) and (t.eini = 10) then begin
      t.bet := 0.108 + 0.05 * random;
      t.tet := 59.259 + random * 0.1;
      t.fi := 70.983 + random * 0.1;
    end;
  end else begin
    t.bet := 0 + 3 * random;
    t.tet := 0 + 180 * random;
    t.fi := 0 + 360 * random;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  if RadioButton1.Checked then atom := 'Hg';
  if RadioButton2.Checked then atom := 'Xe';
  if RadioButton3.Checked then atom := 'Kr';
  if (checkbox1.Checked) and not (Checkbox2.Checked) and not(checkbox6.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    for i := 1 to 100 do begin
      initpoint;
      eps1 := 0.001;
      r := 1;
      process := 1;
      getsymplex;
      minimization;
    end;
  end;
  if (checkbox1.Checked) and not (Checkbox2.Checked) and (checkbox6.Checked) then begin
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
        t.erel := t.erel+1;
        edit2.Text := floattostr(t.erel);
      until ((t.erel = 11) and (t.eini < strtofloat(edit4.Text))) or
        ((t.erel = strtofloat(edit5.Text)+1) and (t.eini = strtofloat(edit4.Text)));
      t.eini := t.eini+1;
      edit1.Text := floattostr(t.eini);
      t.erel := 1;
      edit2.Text := floattostr(t.erel);
    until (t.eini = strtofloat(edit4.Text) + 1);
  end;
  if (checkbox2.Checked) and not (Checkbox1.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    process := 2;
    form2.Rekombination;
  end;
  if (checkbox1.Checked) and (Checkbox2.Checked) then begin
    t.eini := strtofloat(Edit1.Text);
    t.erel := strtofloat(Edit2.Text);
    for i := 1 to 5 do begin
      initpoint;
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
  // process := 0; atom := '';
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
