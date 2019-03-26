unit Area;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, opengl, math, AppEvnts, ExtCtrls, StdCtrls, ComCtrls, jpeg;

type
  point1 = record
    eini, erel: real;
    bet, tet, fi: real;
    emolec, eout: real;
    rekomb, molec: boolean;
  end;
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    sympl1: array of point1;
    k: integer;
    t, c: point1;
    fileindex: integer;
    step, r, step1: real;
    filename: string;
    areaend: boolean;
    bet: real;
    evibc, erotc, zvc, zjc: real;
    procedure InArea;
    procedure Rekombination;
    procedure GetPointUp;
    procedure MashtabSymplex;
    procedure Senddata;
    procedure FileOutput;
  end;

var
  Form2: TForm2;

implementation
uses
  minimum, traj_Hg, traj_Xe, traj_Kr, setka;

{$R *.dfm}

procedure TForm2.Senddata;
begin
  t.tet := t.tet / 30;
  t.fi := t.fi / 30;
  form1.t.eini := t.eini;
  form1.t.erel := t.erel;
  form1.t.bet := t.bet;
  form1.t.tet := t.tet;
  form1.t.fi := t.fi;
  form1.t.emolec := t.emolec;
  form1.t.eout := t.eout;
  form1.t.rekomb := t.rekomb;
  form1.t.molec := t.molec;
  form1.fn;
end;

procedure TForm2.FileOutput;
var
  tf: textfile;
  fname: string;
begin
  fname := filename;
  assignfile(tf, fname);
  if fileexists(fname) then begin
    append(tf);
  end
  else begin
    rewrite(tf);
  end;
  append(tf);
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
      end
      else begin
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
    end
    else begin
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
      end
      else begin
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
    end
    else begin
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
      end
      else begin
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
    end
    else begin
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

procedure TForm2.InArea;
var
  i, j: integer;
  i1: boolean;
begin
  filename := form1.atom + form1.Edit1.Text + form1.Edit2.Text + 'InitPoints.txt';
  c.eini := StrToInt(Form1.Edit1.Text);
  c.erel := StrToInt(Form1.Edit2.Text);
  c.bet := bet;
  c.tet := 50;
  c.fi := 100;
  t := c;
  senddata;
  c.emolec := form1.t.emolec;
  c.eout := form1.t.eout;
  c.rekomb := form1.t.rekomb;
  c.molec := form1.t.molec;
  if c.rekomb = false then begin
    i1 := false;
    c.tet := -step1;
    c.fi := -step1;
    for i := 1 to round(180 / step1) do begin
      c.tet := c.tet + step1;
      c.fi := -step1;
      for j := 1 xto round(360 / step1) do begin
        c.fi := c.fi + step1;
        t := c;
        senddata;
        c.emolec := form1.t.emolec;
        c.eout := form1.t.eout;
        c.rekomb := form1.t.rekomb;
        c.molec := form1.t.molec;
        if c.rekomb = true then begin
          i1 := true;
          break;
        end;
      end;
      if i1 = true then break;
    end;
    if i1 = false then areaend := true;
  end;
  if form1.atom = 'Hg' then begin
    evibc := form3.evib0;
    erotc := form3.erot0;
    zvc := form3.ZV;
    zjc := form3.ZJ;
  end;
  if form1.atom = 'Xe' then begin
    evibc := form4.evib0;
    erotc := form4.erot0;
    zvc := form4.ZV;
    zjc := form4.ZJ;
  end;
  if form1.atom = 'Kr' then begin
    evibc := form5.evib0;
    erotc := form5.erot0;
    zvc := form5.ZV;
    zjc := form5.ZJ;
  end;
  for i := 0 to k - 1 do begin
    sympl1[i].eini := c.eini;
    sympl1[i].erel := c.erel;
  end;
  sympl1[0].bet := c.bet;
  sympl1[1].bet := c.bet;
  sympl1[2].bet := c.bet;
  sympl1[3].bet := c.bet;
  sympl1[4].bet := c.bet;
  sympl1[5].bet := c.bet;
  sympl1[0].tet := c.tet - r;
  sympl1[0].fi := c.fi;
  sympl1[1].tet := c.tet - r/2;
  sympl1[1].fi := c.fi + sqrt(3)/2*r;
  sympl1[2].tet := c.tet + r/2;
  sympl1[2].fi := c.fi + sqrt(3)/2*r;
  sympl1[3].tet := c.tet + r;
  sympl1[3].fi := c.fi;
  sympl1[4].tet := c.tet + r/2;
  sympl1[4].fi := c.fi - sqrt(3)/2*r;
  sympl1[5].tet := c.tet - r/2;
  sympl1[5].fi := c.fi - sqrt(3)/2*r;
  for i := 0 to k - 1 do begin
    t := sympl1[i];
    senddata;
    sympl1[i].emolec := form1.t.emolec;
    sympl1[i].eout := form1.t.eout;
    sympl1[i].rekomb := form1.t.rekomb;
    sympl1[i].molec := form1.t.molec;
    t.emolec := form1.t.emolec;
    t.eout := form1.t.eout;
    t.rekomb := form1.t.rekomb;
    t.molec := form1.t.molec;
    t.tet := t.tet * 30;
    t.fi := t.fi * 30;
    FileOutput;
  end;
end;

procedure TForm2.Rekombination;
begin
  r := 10;
  k := 6;
  bet := 0;
  areaend := false;
  step1 := 5;
  setlength(sympl1, k);
  Inarea;
  if areaend = true then begin
    repeat
      areaend := false;
      bet := bet + 0.5;
      Inarea;
    until areaend = false;
  end;
  getpointup;
end;

procedure TForm2.GetPointUp;
var
  tf: textfile;
  fname: string;
  pointprev: array of point1;
  i, j: integer;
begin
  j := 0;
  repeat
    setlength(pointprev, k);
    for i := 0 to k - 1 do begin
      if j = 0 then step := 0 else step := 0.5;
      sympl1[i].bet := sympl1[i].bet + step;
      bet := sympl1[i].bet;
      t := sympl1[i];
      senddata;
      sympl1[i].emolec := form1.t.emolec;
      sympl1[i].eout := form1.t.eout;
      sympl1[i].rekomb := form1.t.rekomb;
      sympl1[i].molec := form1.t.molec;
    end;
    for i := 0 to k - 1 do begin
      pointprev[i] := sympl1[i];
    end;
    inc(Form1.number);
    if areaend = false then MashtabSymplex;
    inc(j);
  until areaend = true;
end;

procedure TForm2.MashtabSymplex;
var
  koef, pointt, point0, pointprev: point1;
  i, j: integer;
  tf: textfile;
  fname: string;
  evib, erot, zv, zj: real;
  koef1: real;
  ab: integer;
  r: real;
  c1, c2: boolean;
begin
  c.eini := StrToFloat(Form1.Edit1.Text);
  c.erel := StrToFloat(Form1.Edit2.Text);
  c.tet := 0;
  c.fi := 0;
  for i := 0 to k - 1 do begin
    c.tet := c.tet + sympl1[i].tet;
    c.fi := c.fi + sympl1[i].fi;
  end;
  c.bet := bet;
  c.tet := c.tet / 6;
  c.fi := c.fi / 6;
  t := c;
  senddata;
  c.emolec := form1.t.emolec;
  c.eout := form1.t.eout;
  c.rekomb := form1.t.rekomb;
  c.molec := form1.t.molec;
  step1 := 5;
  if (c.rekomb = false) or (c.tet < 0) or (c.fi < 0) then begin
    InArea;
  end;
  if areaend = true then exit;
  for i := 0 to k - 1 do begin
    koef.bet := 1;
    koef.tet := 1;
    koef.fi := 1;
    koef1 := 1;
    ab := 1;
    j := 0;
    pointt := sympl1[i];
    point0 := pointt;
    c1 := false;
    c2 := false;
    fname := form1.atom + form1.edit1.Text + form1.edit2.Text + 'pointpath' + inttostr(i) + {inttostr(form1.number) + }'.txt';
    assignfile(tf, fname);
    if fileexists(fname) then begin
      append(tf);
    end else begin
      rewrite(tf);
    end;
    append(tf);
    repeat
      pointprev := pointt;
      if form1.atom = 'Hg' then begin
        evib := form3.evib0;
        erot := form3.erot0;
        zv := form3.ZV;
        zj := form3.ZJ;
      end;
      if form1.atom = 'Xe' then begin
        evib := form4.evib0;
        erot := form4.erot0;
        zv := form4.ZV;
        zj := form4.ZJ;
      end;
      if form1.atom = 'Kr' then begin
        evib := form5.evib0;
        erot := form5.erot0;
        zv := form5.ZV;
        zj := form5.ZJ;
      end;
      koef.bet := koef.bet + 0.1*koef1*ab;
      koef.tet := koef.tet + 0.3*koef1*ab;
      koef.fi := koef.fi + 0.3*koef1*ab;
      pointt.bet := c.bet + (point0.bet - c.bet) * koef.bet;
      pointt.tet := c.tet + (point0.tet - c.tet) * koef.tet;
      pointt.fi := c.fi + (point0.fi - c.fi) * koef.fi;
      t := pointt;
      senddata;
      pointt.emolec := form1.t.emolec;
      pointt.eout := form1.t.eout;
      pointt.rekomb := form1.t.rekomb;
      pointt.molec := form1.t.molec;
      if (abs(pointt.emolec) > 1E5) then pointt.emolec := 0;
      koef1 := 1 - 0.99 / 5*pointt.emolec;
      if (ab = 1) and (j = 0) and (pointt.rekomb = false) then begin
        koef.bet := 1;
        koef.tet := 1;
        koef.fi := 1;
        koef1 := 1;
        ab := -1;
        j := 0;
        c1 := false;
        c2 := false;
        pointt := sympl1[i];
        point0 := pointt;
      end;
      inc(j);
      if form1.atom = 'Hg' then begin
        if form3.NLO <> 1 then begin
          if t.molec = true then begin
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3),
                        0, '        ',
                        1, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end else begin
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end;
        end else begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
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
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                        0, '        ',
                        1, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end else begin
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end;
        end else begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
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
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                        0, '        ',
                        1, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end else begin
            writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                        floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                        floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                        floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                        floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                        floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0, '        ',
                        0);
          end;
        end else begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                      1, '        ',
                      1, '        ',
                      floattostrf(form5.evib0, fffixed, 7, 6), '        ',
                      floattostrf(form5.erot0, fffixed, 7, 6), '        ',
                      floattostrf(form5.ZV, fffixed, 7, 6), '        ',
                      floattostrf(form5.ZJ, fffixed, 7, 6));
        end;
      end;
      if (j = 1) and (pointt.tet = c.tet) and (pointt.fi = c.fi) then break;
      if (ab = 1) and (j > 1) then begin
        if (pointt.tet <= 0) or (pointt.tet >= 180) or (pointt.fi <= 0) or (pointt.fi >= 360) then begin
          pointt := pointprev;
          break;
        end;
      end;
      if (ab = 1) and (j = 1) then begin
        if (pointt.tet <= 0) or (pointt.tet >= 180) or (pointt.fi <= 0) or (pointt.fi >= 360) then begin
          pointprev := c;
          c2 := true;
          break;
        end;
      end;
      if (j = 1) then begin
        if (pointprev.tet <= 0) or (pointprev.tet >= 180) or (pointprev.fi <= 0) or (pointprev.fi >= 360) then begin
          if ab = 1 then {begin} pointprev := c; {c2 := true; end;}
          if ab = -1 then pointt := c;
          break;
        end;
      end;
      if (ab = -1) and (j > 1) then begin
        if (abs(pointt.tet - c.tet) < 5) and (abs(pointt.fi - c.fi) < 5) then begin
          pointt := c;
          c1 := true;
          break;
        end;
      end;
    until ((ab = 1) and
             ((pointt.rekomb = false) or
                ((pointt.tet = pointprev.tet) and
                   (pointt.fi = pointprev.fi) and
                   (pointt.bet = pointprev.bet)))) or
      ((ab = -1) and (pointt.rekomb = true));
    closefile(tf);
    fname := form1.atom + form1.Edit1.Text + form1.Edit2.Text + 'point.txt';
    assignfile(tf, fname);
    if fileexists(fname) then begin
      append(tf);
    end else begin
      rewrite(tf);
    end;
    if (ab = 1) and (c2 = false) then begin
      if pointprev.rekomb = false then begin
        if pointprev.molec = true then begin
          writeln(tf, floattostrf(pointprev.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      1, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end else begin
          writeln(tf, floattostrf(pointprev.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end;
      end else begin
        writeln(tf, floattostrf(pointprev.eini,fffixed,7,3),'   ',
                    floattostrf(pointprev.erel,fffixed,7,3),'   ',
                    floattostrf(pointprev.bet,fffixed,7,3),'   ',
                    floattostrf(pointprev.tet,fffixed,7,3),'   ',
                    floattostrf(pointprev.fi,fffixed,7,3),'   ',
                    floattostrf(pointprev.emolec,fffixed,7,3),'   ',
                    floattostrf(pointprev.eout,fffixed,7,3),'        ',
                    1,'        ',
                    1,'        ',
                    floattostrf(evib, fffixed, 7, 6), '        ',
                    floattostrf(erot, fffixed, 7, 6), '        ',
                    floattostrf(ZV, fffixed, 7, 6), '        ',
                    floattostrf(ZJ, fffixed, 7, 6));
      end;
    end;
    if (ab = 1) and (c2 = true) then begin
      if pointprev.rekomb = false then begin
        if pointprev.molec = true then begin
          writeln(tf, floattostrf(pointprev.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      1, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end else begin
          writeln(tf, floattostrf(pointprev.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointprev.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end;
      end else begin
        writeln(tf, floattostrf(pointprev.eini, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.erel, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.bet, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.tet, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.fi, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.emolec, fffixed, 7, 3), '   ',
                    floattostrf(pointprev.eout, fffixed, 7, 3), '        ',
                    1, '        ',
                    1, '        ',
                    floattostrf(evibc, fffixed, 7, 6), '        ',
                    floattostrf(erotc, fffixed, 7, 6), '        ',
                    floattostrf(ZVc, fffixed, 7, 6), '        ',
                    floattostrf(ZJc, fffixed, 7, 6));
      end;
    end;
    if (ab = -1) and (c1 = false) then begin
      if form1.atom = 'Hg' then begin
        evib := form3.evib0;
        erot := form3.erot0;
        zv := form3.ZV;
        zj := form3.ZJ;
      end;
      if form1.atom = 'Xe' then begin
        evib := form4.evib0;
        erot := form4.erot0;
        zv := form4.ZV;
        zj := form4.ZJ;
      end;
      if form1.atom = 'Kr' then begin
        evib := form5.evib0;
        erot := form5.erot0;
        zv := form5.ZV;
        zj := form5.ZJ;
      end;
      if pointt.rekomb = false then begin
        if pointt.molec = true then begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      1, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end else begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.erel, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.bet, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.tet, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.fi, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3) ,'   ',
                      floattostrf(pointt.eout, fffixed, 7, 3) ,'        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end;
      end else begin
        writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                    floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                    floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                    floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                    floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                    floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                    floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                    1, '        ',
                    1, '        ',
                    floattostrf(evib, fffixed, 7, 6), '        ',
                    floattostrf(erot, fffixed, 7, 6), '        ',
                    floattostrf(ZV, fffixed, 7, 6), '        ',
                    floattostrf(ZJ, fffixed, 7, 6));
      end;
    end;
    if (ab = -1) and (c1 = true) then begin
      if pointt.rekomb = false then begin
        if pointt.molec = true then begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      1, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end else begin
          writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                      floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                      floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                      floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                      floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                      floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0, '        ',
                      0);
        end;
      end else begin
        writeln(tf, floattostrf(pointt.eini, fffixed, 7, 3), '   ',
                    floattostrf(pointt.erel, fffixed, 7, 3), '   ',
                    floattostrf(pointt.bet, fffixed, 7, 3), '   ',
                    floattostrf(pointt.tet, fffixed, 7, 3), '   ',
                    floattostrf(pointt.fi, fffixed, 7, 3), '   ',
                    floattostrf(pointt.emolec, fffixed, 7, 3), '   ',
                    floattostrf(pointt.eout, fffixed, 7, 3), '        ',
                    1,'        ',
                    1,'        ',
                    floattostrf(evibc, fffixed, 7, 6), '        ',
                    floattostrf(erotc, fffixed, 7, 6), '        ',
                    floattostrf(ZVc, fffixed, 7, 6), '        ',
                    floattostrf(ZJc, fffixed, 7, 6));
      end;
    end;
    closefile(tf);
    sympl1[i] := pointt;
  end;
end;

end.
