unit Setka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, OleServer, Grids,
  xmldom, Xmlxform, Provider, Excel2000, IdHeaderCoder;

type
  point2 = record
    eini, erel: real;
    bet, tet, fi: real;
    emolec, eout: real;
    rekomb, molec: boolean;
    evib, erot: real;
    zv, zj: real;
  end;
  TForm6 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Label6: TLabel;
    Label5: TLabel;
    ExcelWorkbook1: TExcelWorkbook;
    ExcelApplication1: TExcelApplication;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ExcelWorksheet1: TExcelWorksheet;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit7: TEdit;
    Label10: TLabel;
    Edit8: TEdit;
    Label11: TLabel;
    Edit9: TEdit;
    Label12: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bstep, tetstep, fistep: real;
    bini, tetini, fiini: real;
    bend, tetend, fiend: real;
    t: point2;
    step: integer;
    initstep: integer;
    continue1, interrupt: boolean;
    timesum: real;
    timetr, osttime: real;
    stepcount, oststep: real;
    continue2: boolean;
    bini1, tetini1, fiini1: real;
    timefile: textfile;
    tfilename: string;
    lasttime: real;
    filename: olevariant;
    bmin, tetmin, fimin, emolecmin: real;
    db, dtet, dfi: real;
    lcid: integer;
    bprev, tetprev, fiprev, emolecprev: real;
    bmins, tetmins, fimins, emolecmins: real;
    sqotkl, maxotkl: real;
    bmax, tetmax, fimax, bpr, tetpr, fipr, emolecmax, emolecpr: real;
    procedure readdata;
    procedure setka;
    procedure senddata;
    procedure savetofile;
    procedure continue;
    procedure readexcel;
    procedure getsetka;
    procedure allsetka;
  end;

var
  Form6: TForm6;

implementation

uses
  area, traj_Hg, traj_Xe, traj_Kr, minimum;

{$R *.dfm}

procedure TForm6.getsetka;
begin
  db := bmin;
  dtet := tetmin;
  dfi := fimin;
  if Radiobutton1.Checked = true then begin
    if (bmin > 1) and (tetmin > 5) and (fimin > 5) and (tetmin < 90) and (fimin < 180) then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
    end;
    if bmin <= 1 then begin
      bini := 0;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + 2*db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
    end;
    if tetmin <= 5 then begin
      bini := bmin - db;
      tetini := 0;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + 2*dtet;
      fiend := fimin + dfi;
    end;
    if fimin <= 5 then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := 0;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + 2*dfi;
    end;
    if tetmin >= 90 then begin
      dtet := 180 - tetmin;
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
      if dtet <= 5 then begin
        tetini := tetmin - 2*dtet;
        tetend := 180;
      end;
    end;
    if fimin >= 90 then begin
      dfi := 180 - fimin;
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
      if dfi <= 5 then begin
        fiini := fimin - 2*dtet; fiend := 360;
      end;
    end;
  end;
  if Radiobutton2.Checked = true then begin
    db := strtofloat(edit7.Text);
    dtet := strtofloat(edit8.Text);
    dfi := strtofloat(edit9.Text);
    if (bmin > 1) and (tetmin > 5) and (fimin > 5) and (tetmin < 90) and (fimin < 180) then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
    end;
    if bmin <= 1 then begin
      bini := 0;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + 2*db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
    end;
    if tetmin <= 5 then begin
      bini := bmin - db;
      tetini := 0;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + 2*dtet;
      fiend := fimin + dfi;
    end;
    if fimin <= 5 then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := 0;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + 2*dfi;
    end;
    if 180 - tetmin <= 5 then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
      tetini := tetmin - 2*dtet;
      tetend := 180;
    end;
    if 360 - fimin <= 5 then begin
      bini := bmin - db;
      tetini := tetmin - dtet;
      fiini := fimin - dfi;
      bend := bmin + db;
      tetend := tetmin + dtet;
      fiend := fimin + dfi;
      fiini := fimin - 2*dtet;
      fiend := 360;
    end;
  end;
end;

procedure TForm6.readdata;
begin
  bstep := strtofloat(edit1.Text);
  tetstep := strtofloat(edit2.Text);
  fistep := strtofloat(edit3.Text);
  {bmin := strtofloat(edit4.Text);
   tetmin := strtofloat(edit5.Text);
   fimin := strtofloat(edit6.Text); }
  step := 0;
  continue1 := false;
  getsetka;
  stepcount := ((bend - bini)/bstep) * ((tetend - tetini)/tetstep) * ((fiend - fiini)/fistep);
  setka;
end;

procedure TForm6.setka;
var
  i, j, k: integer;
  rf: textfile;
  rfname: string;
begin
  interrupt := false;
  Button1.Enabled := false;
  timesum := 0;
  t.bet := bini;
  t.tet := tetini;
  t.fi := fiini;
  bprev := t.bet;
  tetprev := t.tet;
  fiprev := t.fi;
  emolecprev := 999;
  bmins := t.bet;
  tetmins := t.tet;
  fimins := t.fi;
  emolecmins := 999;
  bpr := t.bet;
  tetpr := t.tet;
  fipr := t.fi;
  emolecpr := 0;
  bmax := t.bet;
  tetmax := t.tet;
  fimax := t.fi;
  emolecmax := 0;
  repeat
    repeat
      repeat
        if continue1 = false then begin
          if t.rekomb = true then begin
            bprev := t.bet;
            tetprev := t.tet;
            fiprev := t.fi;
            emolecprev := emolecmins;
            bpr := t.bet;
            tetpr := t.tet;
            fipr := t.fi;
            emolecpr := emolecmax;
          end;
          senddata;
          t.emolec := form1.t.emolec;
          t.eout := form1.t.eout;
          t.rekomb := form1.t.rekomb;
          t.molec := form1.t.molec;
          if (abs(t.emolec) > 1E5) then t.emolec := 0;
          if (abs(t.eout) > 1E5) then t.eout := 0;
          if (t.emolec < emolecprev) and (t.rekomb = true) then begin
            bmins := t.bet;
            tetmins := t.tet;
            fimins := t.fi;
            emolecmins := t.emolec;
          end;
          if (t.emolec > emolecmax) and (t.rekomb = true) then begin
            bmax := t.bet;
            tetmax := t.tet;
            fimax := t.fi;
            emolecmax := t.emolec;
            maxotkl := emolecmax - emolecmin;
          end;
          sqotkl := sqotkl + abs(t.emolec - emolecmin);
          if form1.atom = 'Hg' then begin
            t.evib := form3.evib0;
            t.erot := form3.erot0;
            t.zv := form3.zv;
            t.zj := form3.zj;
          end;
          if form1.atom = 'Xe' then begin
            t.evib := form4.evib0;
            t.erot := form4.erot0;
            t.zv := form4.zv;
            t.zj := form4.zj;
          end;
          if form1.atom = 'Kr' then begin
            t.evib := form5.evib0;
            t.erot := form5.erot0;
            t.zv := form5.zv;
            t.zj := form5.zj;
          end;
          step := step + 1;
          timetr := (timesum + lasttime)/step;
          oststep := stepcount - step;
          osttime := timetr * oststep;
          application.ProcessMessages;
          progressbar1.Position := round(100*step / (step + oststep));
          if interrupt = true then exit;
          savetofile;
          t.fi := t.fi + fistep;
        end else continue1 := false;
      until t.fi >= (fiend - fistep);
      t.tet := t.tet + tetstep;
      t.fi := fiini;
    until t.tet >= (tetend - tetstep);
    t.bet := t.bet + bstep;
    t.tet := tetini;
  until t.bet >= bend;
  sqotkl := sqotkl / step;
  Button1.Enabled := true;
  rfname := form1.atom + form1.Edit1.Text + form1.Edit2.Text + 'result.txt';
  assignfile(rf, rfname);
  rewrite(rf);
  writeln(rf, floattostrf(bmins, fffixed, 7, 3), '    ',
              floattostrf(tetmins, fffixed, 7, 3), '    ',
              floattostrf(fimins, fffixed, 7, 3), '    ',
              floattostrf(emolecmins, fffixed, 7, 3), '    ',
              floattostrf(maxotkl, fffixed, 7, 3), '    ',
              floattostrf(sqotkl, fffixed, 7, 3));
  closefile(rf);
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  timer1.Enabled := true;
  t.eini := strtofloat(form1.Edit1.Text);
  t.erel := strtofloat(form1.Edit2.Text);
  readexcel;
  readdata;
  form6.Hide;
  form1.Show;
  form1.RadioButton1.Checked := false;
  form1.RadioButton2.Checked := false;
  form1.RadioButton3.Checked := false;
  form1.CheckBox3.Checked := false;
  form1.Edit1.Text := '';
  form1.Edit2.Text := '';
  initstep := 0;
  continue2 := false;
end;

procedure TForm6.readexcel;
var
  bm, tetm, fim, emolecm: olevariant;
  i1,k1: integer;
  j1: string;
begin
  lcid := LOCALE_USER_DEFAULT;
  filename := GetCurrentDir + '\Minimum' + form1.atom + '.xls';
  // запускаем Excel
  ExcelApplication1.AutoConnect := true;
  // открываем книгу
  ExcelWorkbook1.ConnectTo(ExcelApplication1.Workbooks.Open(FileName,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            EmptyParam,
                                                            lcid));
  // соединяемся с книгой
  ExcelApplication1.ConnectTo(ExcelWorkbook1.Application);
  ExcelWorksheet1.ConnectTo(ExcelWorkbook1.ActiveSheet as ExcelWorksheet); // XLappNewWorkbook(excelworkbook1,filename);
  i1 := 5*round(t.eini - 1) + 2;
  k1 := round(t.erel) + 1;
  j1 := base64_tbl[k1];
  bm := ExcelWorksheet1.Range[j1+inttostr(i1), EmptyParam];
  tetm := ExcelWorksheet1.Range[j1+inttostr(1 + i1), EmptyParam];
  fim := ExcelWorksheet1.Range[j1+inttostr(2 + i1), EmptyParam];
  emolecm := ExcelWorksheet1.Range[j1+inttostr(3 + i1), EmptyParam];
  bmin := strtofloat(vartostr(bm));
  tetmin := strtofloat(vartostr(tetm));
  fimin := strtofloat(vartostr(fim));
  emolecmin := strtofloat(vartostr(emolecm));
  ExcelApplication1.Workbooks.Close(lcid);
end;

procedure TForm6.senddata;
begin
  t.tet := t.tet / 30;
  t.fi := t.fi / 30;
  form1.t.eini := t.eini;
  form1.t.erel := t.erel;
  form1.t.bet := t.bet;
  form1.t.tet := t.tet;
  form1.t.fi := t.fi;
  form1.fn;
  t.tet := t.tet * 30;
  t.fi := t.fi * 30;
end;

procedure TForm6.savetofile;
var
  tf: textfile;
  fname: string;
begin
  fname := form1.atom + '_' + form1.Edit1.Text + '_' +
    form1.Edit2.Text{ + '_' + floattostr(bstep) + '_' + floattostr(tetstep) + '_' + floattostr(fistep)} + '.txt';
  assignfile(tf, fname);
  if fileexists(fname) then begin
    append(tf);
  end else begin
    rewrite(tf);
    writeln(tf, 'Сетка:    ', floattostrf(bini, fffixed, 7, 3), '       ',
                              floattostrf(tetini, fffixed, 7, 3), '     ',
                              floattostrf(fiini, fffixed, 7, 3), '      ',
                              floattostrf(bend, fffixed, 7, 3), '       ',
                              floattostrf(tetend, fffixed, 7, 3), '     ',
                              floattostrf(fiend, fffixed, 7, 3), '      ',
                              floattostrf(bstep, fffixed, 7, 3), '      ',
                              floattostrf(tetstep, fffixed, 7, 3), '    ',
                              floattostrf(fistep, fffixed, 7, 3));
  end;
  if form1.atom = 'Hg' then begin
    if form3.NLO<>1 then begin
      writeln(tf, step,'    ', floattostrf(t.eini, fffixed, 7, 3), '     ',
                               floattostrf(t.erel, fffixed, 7, 3), '    ',
                               floattostrf(t.bet, fffixed, 7, 3), '    ',
                               floattostrf(t.tet, fffixed, 7, 3), '    ',
                               floattostrf(t.fi, fffixed, 7, 3), '    ',
                               floattostrf(t.emolec, fffixed, 7, 6), '    ',
                               floattostrf(t.eout, fffixed, 7, 6), '    ',
                               0, '    ',
                               0, '    ',
                               0, '    ',
                               0, '    ',
                               0, '    ',
                               floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end else begin
      writeln(tf, step,'    ', floattostrf(t.eini, fffixed, 7, 3), '     ',
                               floattostrf(t.erel, fffixed, 7, 3), '    ',
                               floattostrf(t.bet, fffixed, 7, 3), '    ',
                               floattostrf(t.tet, fffixed, 7, 3), '    ',
                               floattostrf(t.fi, fffixed, 7, 3), '    ',
                               floattostrf(t.emolec, fffixed, 7, 6), '    ',
                               floattostrf(t.eout, fffixed, 7, 6), '    ',
                               1, '    ',
                               floattostrf(t.evib, fffixed, 7, 6), '    ',
                               floattostrf(t.erot, fffixed, 7, 6), '    ',
                               floattostrf(t.zv, fffixed, 7, 1), '    ',
                               floattostrf(t.zj, fffixed, 7, 1), '    ',
                               floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end;
  end;
  if form1.atom = 'Xe' then begin
    if form4.NLO<>1 then begin
      writeln(tf, step,'    ',floattostrf(t.eini, fffixed, 7, 3), '    ',
                              floattostrf(t.erel, fffixed, 7, 3), '    ',
                              floattostrf(t.bet, fffixed, 7, 3), '    ',
                              floattostrf(t.tet, fffixed, 7, 3), '    ',
                              floattostrf(t.fi, fffixed, 7, 3), '    ',
                              floattostrf(t.emolec, fffixed, 7, 6), '    ',
                              floattostrf(t.eout, fffixed, 7, 6), '    ',
                              0, '    ',
                              0, '    ',
                              0, '    ',
                              0, '    ',
                              0, '    ',
                              floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end else begin
      writeln(tf, step, '    ', floattostrf(t.eini, fffixed, 7, 3), '    ',
                                floattostrf(t.erel, fffixed, 7, 3), '    ',
                                floattostrf(t.bet, fffixed, 7, 3), '    ',
                                floattostrf(t.tet, fffixed, 7, 3), '    ',
                                floattostrf(t.fi, fffixed, 7, 3), '    ',
                                floattostrf(t.emolec, fffixed, 7, 6), '    ',
                                floattostrf(t.eout, fffixed, 7, 6), '    ',
                                1, '    ',
                                floattostrf(t.evib, fffixed, 7, 6), '    ',
                                floattostrf(t.erot, fffixed, 7, 6), '    ',
                                floattostrf(t.zv, fffixed, 7, 1), '    ',
                                floattostrf(t.zj, fffixed, 7, 1), '    ',
                                floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end;
  end;
  if form1.atom = 'Kr' then begin
    if form5.NLO<>1 then begin
      writeln(tf, step, '    ', floattostrf(t.eini, fffixed, 7, 3), '    ',
                                floattostrf(t.erel, fffixed, 7, 3), '    ',
                                floattostrf(t.bet, fffixed, 7, 3), '    ',
                                floattostrf(t.tet, fffixed, 7, 3), '    ',
                                floattostrf(t.fi, fffixed, 7, 3), '    ',
                                floattostrf(t.emolec, fffixed, 7, 6), '    ',
                                floattostrf(t.eout, fffixed, 7, 6), '    ',
                                0, '    ',
                                0, '    ',
                                0, '    ',
                                0, '    ',
                                0, '    ',
                                floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end else begin
      writeln(tf, step, '    ', floattostrf(t.eini, fffixed, 7, 3), '    ',
                                floattostrf(t.erel, fffixed, 7, 3), '    ',
                                floattostrf(t.bet, fffixed, 7, 3), '    ',
                                floattostrf(t.tet, fffixed, 7, 3), '    ',
                                floattostrf(t.fi, fffixed, 7, 3), '    ',
                                floattostrf(t.emolec, fffixed, 7, 6), '    ',
                                floattostrf(t.eout, fffixed, 7, 6), '    ',
                                1, '    ',
                                floattostrf(t.evib, fffixed, 7, 6), '    ',
                                floattostrf(t.erot, fffixed, 7, 6), '    ',
                                floattostrf(t.zv, fffixed, 7, 1), '    ',
                                floattostrf(t.zj, fffixed, 7, 1), '    ',
                                floattostrf(t.emolec - emolecmin, fffixed, 7, 3));
    end;
  end;
  closefile(tf);
end;

procedure TForm6.continue;
var
  tf: textfile;
  fname,tt: string;
i,k: integer;
a,bini0,tetini0,fiini0,bend0,tetend0,fiend0,bstep0,tetstep0,fistep0:string;
step0,eini0,erel0,bet0,tet0,fi0,tt1: string;
begin
  t.eini := strtofloat(form1.Edit1.Text);
  t.erel := strtofloat(form1.Edit2.Text);
  tfilename := form1.atom + '_' + form1.Edit1.Text + '_' + form1.Edit2.Text + 't.txt';
  assignfile(timefile,tfilename);
  reset(timefile);
  readln(timefile,tt1);
  lasttime := strtofloat(tt1);
  closefile(timefile);
  fname := form1.atom+'_'+form1.Edit1.Text+'_'+form1.Edit2.Text{+'_'+floattostr(bstep)+'_'+floattostr(tetstep)+'_'+floattostr(fistep)}+'.txt';
  assignfile(tf,fname);
  reset(tf);
  readln(tf,tt);
  k := 0;
  for i := 1 to length(tt) do begin
    if (k=0) and (tt[i]<>' ') then a := a+tt[i];
    if (tt[i]=' ') and (tt[i-1]<>' ') then k := k+1;
    if (k=1) and (tt[i]<>' ') then bini0 := bini0+tt[i];
    if (k=2) and (tt[i]<>' ') then tetini0 := tetini0+tt[i];
    if (k=3) and (tt[i]<>' ') then fiini0 := fiini0+tt[i];
    if (k=4) and (tt[i]<>' ') then bend0 := bend0+tt[i];
    if (k=5) and (tt[i]<>' ') then tetend0 := tetend0+tt[i];
    if (k=6) and (tt[i]<>' ') then fiend0 := fiend0+tt[i];
    if (k=7) and (tt[i]<>' ') then bstep0 := bstep0+tt[i];
    if (k=8) and (tt[i]<>' ') then tetstep0 := tetstep0+tt[i];
    if (k=9) and (tt[i]<>' ') then fistep0 := fistep0+tt[i];
  end;
  bend := strtofloat(bend0); tetend := strtofloat(tetend0);
  fiend := strtofloat(fiend0); bstep := strtofloat(bstep0);
  tetstep := strtofloat(tetstep0); fistep := strtofloat(fistep0);
  bini1 := strtofloat(bini0); tetini1 := strtofloat(tetini0);
  fiini1 := strtofloat(fiini0);
  i := 0;
  while not(eof(tf)) do begin
    tt := '';
    readln(tf, tt);
    inc(i);
  end;
  step := i;
  initstep := step;
  closefile(tf);
  k := 0;
  for i := 1 to length(tt) do begin
    if (k = 0) and (tt[i] <> ' ') then step0 := step0 + tt[i];
    if (k = 1) and (tt[i] <> ' ') then eini0 := eini0 + tt[i];
    if (tt[i] = ' ') and (tt[i - 1] <> ' ') then k := k + 1;
    if (k = 2) and (tt[i] <> ' ') then erel0 := erel0 + tt[i];
    if (k = 3) and (tt[i] <> ' ') then bet0 := bet0 + tt[i];
    if (k = 4) and (tt[i] <> ' ') then tet0 := tet0 + tt[i];
    if (k = 5) and (tt[i] <> ' ') then fi0 := fi0 + tt[i];
  end;
  bini := strtofloat(bet0);
  tetini := strtofloat(tet0);
  fiini := strtofloat(fi0);
  fiini := fiini + fistep;
  if fiini = fiend then continue1 := true;
  stepcount := ((bend - bini1)/bstep) * ((tetend - tetini1)/tetstep) * ((fiend - fiini1)/fistep);
  setka;
  form6.Hide;
  form1.Show;
  form1.RadioButton1.Checked := false;
  form1.RadioButton2.Checked := false;
  form1.RadioButton3.Checked := false;
  form1.CheckBox3.Checked := false;
  form1.Edit1.Text := '';
  form1.Edit2.Text := '';
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  if Application.MessageBox('Возобновить расчет по сетке, который был прерван?', 'Контроль', MB_OKCANCEL) <> IDOK then
    exit;
  timer1.Enabled := true;
  continue2 := true;
  continue;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  interrupt := true;
  tfilename := form1.atom + '_' + form1.Edit1.Text + '_' + form1.Edit2.Text + 't.txt';
  assignfile(timefile, tfilename);
  rewrite(timefile);
  timesum := timesum + lasttime;
  writeln(timefile,floattostrf(timesum, fffixed, 7, 1));
  closefile(timefile);
  Form1.Show;
end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
  Application.ProcessMessages;
  timesum := timesum + 1;
  DateSeparator := '-';
  TimeSeparator := ':';
  if timesum < 60 then begin
    Label5.Caption := 'Прошло: ' + floattostr(timesum) + ' с.' + '  Рассчитано: ' + floattostr(step) + ' шагов';
  end;
  if (timesum >= 60) and (timesum < 3600) then begin
    LongTimeFormat  :=  'nn/ss';
    Label5.Caption := 'Прошло: ' + timetostr((timesum)) + '  Рассчитано: ' + floattostr(step) + ' шагов';
  end;
  Label6.Caption := 'Осталось: ' + timetostr((osttime)) + ' c.' + '   Осталось рассчитать: ' + floattostr(oststep) + ' шагов';
end;

procedure TForm6.allsetka;
var
  i, j, k: integer;
begin
  for i := 1 to 3 do begin
    if i = 1 then begin
      form1.Radiobutton1.Checked;
      form1.atom := 'Hg';
    end;
    if i = 2 then begin
      form1.RadioButton2.Checked;
      form1.atom := 'Xe';
    end;
    if i = 3 then begin
      form1.RadioButton3.Checked;
      form1.atom := 'Kr';
    end;
    for j := 1 to 10 do begin
      form1.Edit1.Text := inttostr(j);
      for k := 1 to 10 do begin
        form1.Edit2.Text := inttostr(k);
        timer1.Enabled := true;
        t.eini := strtofloat(form1.Edit1.Text);
        t.erel := strtofloat(form1.Edit2.Text);
        form1.Hide;
        form6.Show;
        Edit1.Text := '0,1';
        edit2.Text := '0,1';
        edit3.Text := '0,1';
        Radiobutton2.Checked := true;
        Edit7.Text := '10';
        edit8.Text := '10';
        edit9.Text := '10';
        readexcel;
        readdata;
        form6.Hide;
        form1.Show;
        form1.RadioButton1.Checked := false;
        form1.RadioButton2.Checked := false;
        form1.RadioButton3.Checked := false;
        form1.CheckBox3.Checked := false;
        //form1.Edit1.Text := '';
        //form1.Edit2.Text := '';
        initstep := 0;
      end;
    end;
  end;
end;

end.
