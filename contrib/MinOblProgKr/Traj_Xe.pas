unit Traj_Xe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, opengl, math, AppEvnts, ExtCtrls, StdCtrls, ComCtrls, jpeg;

type
  point0 = record
    eini, erel: real;
    bet, tet, fi: real;
    emolec, eout: real;
    rekomb, molec: boolean;
  end;
  parr = array [1..6] of real;
  qarr = array [1..6] of real;
  rarr = array [1..3] of real;
  TForm4 = class(TForm)
  private
    { Private declarations }
    A1, A2, A3, p1, p2, p3, S1, S2, S3, C1, C2, C3, ALF1, ALF2, ALF3: real;
    procedure Spectr;
    procedure Integr(p: parr; q: qarr);
    procedure fun(var p: parr; var q: qarr; var r: rarr; var zp: parr; var zq: qarr; var esys: real);
    function f(r: real): real;
    function fp(r: real): real;
    function fpp(r: real): real;
  public
    { Public declarations }
    RM: array [1..1000000, 1..11] of real;
    EPS, HT, ZG, ZF: real;
    D2: real;
    G2, G3, M1, M2, M3, MU2, MU: real;
    RINI, RZ, NLO, ZV, ZJ: real;
    KT: int64;
    t: point0;
    evib0, erot0: real;
    procedure Init;
    procedure ReadIni;
    procedure Culc_traj;
  end;

var
  Form4: TForm4;
  filename: string[255];
  workdir: string[255];

implementation

uses
  mmsystem, inifiles, minimum, area, traj_Hg, traj_Kr, setka;
var
  inifile: tinifile;

{$R *.dfm}

procedure tform4.Integr;
var
  zr:array [0..12, 0..4] of real;
  za:array [0..12, 0..6] of real;
  po: parr;
  qo: qarr;
  r: rarr;
  zp: parr;
  zq: qarr;
  esys, esys0, h, er, sq, sp, spq, ca, evib, erot: real;
  l, n, k, nt: integer;
  recomb: boolean;
begin
  FUN(P, Q, R, ZP, ZQ, ESYS);

  KT := 1;
  ESYS0 := ESYS / 3.67502E-2;
  RM[KT, 1] := KT;
  for L := 1 to 3 do RM[KT, L+1] := R[L];

  RM[KT, 5] := (ESYS / 3.67502E-2) - ESYS0;
  RM[KT, 6] := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 / 3.67502E-2;
  RM[KT, 7] := (sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / 2 / MU / 3.67502E-2;
  RM[KT, 8] := RM[KT, 5] + RM[KT, 6] + RM[KT, 7];
  RM[KT, 9] := SQRT(sqr(P[4]/(M2 + M3) + P[1]/M2) + sqr(P[5]/(M2 + M3) + P[2]/M2) + sqr(P[6]/(M2 + M3) + P[3]/M2));
  RM[KT, 10] := SQRT(sqr(P[4]/(M2 + M3) - P[1]/M3) + sqr(P[5]/(M2 + M3) - P[2]/M3) + sqr(P[6]/(M2 + M3) - P[3]/M3));
  RM[KT, 11] := SQRT(sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / M1;

  // Runge-Kytt (4-order)

  for N := 1 to 5 do begin
    for L := 1 to 6 do begin
      PO[L] := P[L];
      QO[L] := Q[L];
    end;

    for K := 1 to 4 do begin
      IF K = 1 then H := 0;
      IF (K = 2) OR (K = 3) then H := HT/2;
      IF K = 4 then H := HT;
      for L := 1 to 6 do begin
        P[L] := PO[L] + H*ZP[L];
        Q[L] := QO[L] + H*ZQ[L];
      end;

      FUN(P, Q, R, ZP, ZQ, ESYS);

      for L := 1 to 6 do begin
        ZR[L, K] := ZP[L];
        ZR[L+6, K] := ZQ[L];
      end;

      IF K = 1 then begin
        for L := 1 to 6 do begin
          ZA[L, N] := ZP[L];
          ZA[L+6, N] := ZQ[L];
        end;
      end;
    end;

    for L := 1 to 6 do begin
      P[L] := PO[L] + HT/6*(ZR[L, 1] + 2*ZR[L, 2] + 2*ZR[L, 3] + ZR[L, 4]);
      Q[L] := QO[L] + HT/6*(ZR[L+6, 1] + 2*ZR[L+6, 2] + 2*ZR[L+6, 3] + ZR[L+6, 4]);
    end;

    FUN(P, Q, R, ZP, ZQ, ESYS);

    KT := KT+1;
    RM[KT, 1] := KT;

    for L := 1 to 3 do RM[KT, L+1] := R[L];

    RM[KT, 5] := (ESYS / 3.67502E-2) - ESYS0;
    RM[KT, 6] := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 / 3.67502E-2;
    RM[KT, 7] := (sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / 2 / MU / 3.67502E-2;
    RM[KT, 8] := RM[KT, 5] + RM[KT, 6] + RM[KT, 7];
    RM[KT, 9] := SQRT(sqr(P[4]/(M2 + M3) + P[1]/M2) + sqr(P[5]/(M2 + M3) + P[2]/M2) + sqr(P[6]/(M2 + M3) + P[3]/M2));
    RM[KT, 10] := SQRT(sqr(P[4]/(M2 + M3) - P[1]/M3) + sqr(P[5]/(M2 + M3) - P[2]/M3) + sqr(P[6]/(M2 + M3) - P[3]/M3));
    RM[KT, 11] := SQRT(sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / M1;
   end;

  // C ---- Adams (6-order)
  NLO := 0;
  NT := 5;
  recomb := false;
  repeat
    NT := NT + 1;
    IF(NT > 250000) then break;
    //C ----
    IF(R[1] > RINI) AND (R[2] < RZ) AND (R[3] > RINI) THEN begin
      ER := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 + F(R[2]);
      IF (ER < 0) then begin
        recomb := true;
        break;
      end;
    end;

    IF(R[1] > RINI) AND (R[2] > RINI) AND (R[3] > RINI) then break;
    //C ----
    for L := 1 to 6 do begin
      ZA[L, 6] := ZP[L];
      ZA[L+6, 6] := ZQ[L];
    end;
    for L := 1 to 6 do begin
      P[L] := P[L] + HT/1440*(4277*ZA[L, 6]-7923*ZA[L, 5] + 9982*ZA[L, 4]-7298*ZA[L, 3] + 2877*ZA[L, 2]-475*ZA[L, 1]);
      Q[L] := Q[L] + HT/1440*(4277*ZA[L+6, 6] - 7923*ZA[L+6, 5] + 9982*ZA[L+6, 4] - 7298*ZA[L+6, 3] + 2877*ZA[L+6, 2]
                              - 475*ZA[L+6, 1]);
    end;
    for L := 1 to 12 do
      for K := 1 to 5 do
        ZA[L, K] := ZA[L, K+1];
    //C ----
    FUN(P, Q, R, ZP, ZQ, ESYS);
    KT := KT + 1;
    RM[KT, 1] := KT;
    for L := 1 to 3 do
      RM[KT, L+1]:=R[L];
    try
      RM[KT, 5] := (ESYS / 3.67502E-2) - ESYS0;
      RM[KT, 6] := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 / 3.67502E-2;
      RM[KT, 7] := (sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / 2 / MU / 3.67502E-2;
    except
      on E: Exception do begin
        RM[KT, 5]:=0;
        RM[KT, 6]:=0;
        RM[KT, 7]:=0;
        RM[KT, 8]:=0;
      end;
    end;
    try
      RM[KT, 8] := RM[KT, 5] + RM[KT, 6] + RM[KT, 7];
    except
      on E: Exception do RM[KT, 8] := 0;
    end;
    try
      RM[KT, 9] := SQRT(sqr(P[4]/(M2 + M3) + P[1]/M2) + sqr(P[5]/(M2 + M3) + P[2]/M2) + sqr(P[6]/(M2 + M3) + P[3]/M2));
    except
      on E: EAccessViolation do
        RM[KT, 9] := 0;
    end;
    try
      RM[KT, 10] := SQRT(sqr(P[4]/(M2 + M3) - P[1]/M3) + sqr(P[5]/(M2 + M3) - P[2]/M3) + sqr(P[6]/(M2 + M3) - P[3]/M3));
    except
      on E: EAccessViolation do
        RM[KT, 10] := 0;
    end;
    try
      RM[KT, 11] := SQRT(sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / M1;
    except
      on E: EAccessViolation do
        RM[KT, 11]:=0;
    end;
    //C ----
  until false;
  //C -----------------------------------
  if recomb then begin
    SQ := SQRT(sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));
    SP := SQRT(sqr(P[1]) + sqr(P[2]) + sqr(P[3]));
    SPQ := P[1]*Q[1] + P[2]*Q[2] + P[3]*Q[3];
    CA := SPQ / SP / SQ;
    EVIB := sqr(SP) / 2 / MU2*sqr(CA) + F(R[2]) + D2;
    EROT := sqr(SP) / 2 / MU2*(1 - sqr(CA));
    evib0 := evib / 3.67502E-2;
    erot0 := erot / 3.67502E-2;
    ZV := round(EVIB / ZG - 0.5);
    ZF := 1 / (2 * MU2 * sqr(SQ));
    ZJ := round(SQRT(EROT/ZF + 0.25) - 0.5);
    NLO := 1;
    (*Goal functions for the optimization problem*)
    //the internal energy of CsBr; we need to minimize it
    //the recombination passed if Emolec < 4.73 eV.
    t.Emolec := (EVIB + EROT) / 3.67502E-2;
    //the energy taking by third atom from molecule CsBr; we need to maximize it
    t.eout := ((((sqr(rm[kt - 1][11] * (1 + M1/(M2 + M3)))) * MU) / 2)) / 3.67502E-2 - t.erel;
    t.molec := true;
    t.rekomb := true;
  end else begin
    t.rekomb := false;
    t.emolec := (EVIB + EROT) / 3.67502E-2;
    t.eout := ((((sqr(rm[kt - 1][11] * (1 + M1/(M2 + M3)))) * MU) / 2)) / 3.67502E-2 - t.erel;
    if (t.emolec < 2) or (t.emolec > 99) then t.molec := false else t.molec := true;
  end;
end;

procedure tform4.fun;
var
  vrf1, vrf2, vrf3: real;
  function f1(r1, r2, r3: real): real;
  begin
    result:=A2*EXP(-R2/S2) - 1/R2 - (ALF2 + ALF3) / 2 / power(R2,4) - C2/power(R2,6) + A1*EXP(-R1/S1) +
      A3*EXP(-R3/S3) - C1/power(R1, 6) - C3/power(R3, 6) - ALF1/2 *
      (1/power(R1, 4) + 1/power(R3, 4) + (sqr(R2) - sqr(R1) - sqr(R3)) / power(R1, 3) / power(R3, 3)) *
      sqr(1 - (ALF2 + ALF3) / power(R2, 3));
  end;
begin
  //C ---- interatom distances
  R[1] := SQRT(sqr(G3*Q[1] + Q[4]) + sqr(G3*Q[2] + Q[5]) + sqr(G3*Q[3] + Q[6]));
  R[2] := SQRT(sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));
  R[3] := SQRT(sqr(G2*Q[1] - Q[4]) + sqr(G2*Q[2] - Q[5]) + sqr(G2*Q[3] - Q[6]));
  //C ---- potential function and it's derivatives
  ESYS := F1(R[1], R[2], R[3]);
  VRF1 := (-A1/S1 * EXP(-R[1]/S1) + 6*C1/power(R[1], 7) + ALF1/2*sqr(1 - (ALF2 + ALF3)/power(R[2], 3)) *
             (4/power(R[1], 5) + (3*sqr(R[2]) - sqr(R[1]) - 3*sqr(R[3])) / power(R[1], 4) / power(R[3], 3)))/R[1];
  VRF2 := (-A2/S2 * EXP(-R[2]/S2) + 1/sqr(R[2]) + 2*(ALF2 + ALF3)/power(R[2], 5) + 6*C2/power(R[2], 7) -
             ALF1*R[2]/power(R[1], 3)/power(R[3], 3)*sqr(1-(ALF2 + ALF3)/power(R[2], 3))-ALF1 *
             (1/power(R[1], 4) + 1/power(R[3], 4) + (sqr(R[2])-sqr(R[1])-sqr(R[3]))/power(R[1], 3)/power(R[3], 3)) *
             (1-(ALF2 + ALF3)/power(R[2], 3))*3*(ALF2+ALF3)/power(R[2], 4))/R[2];
  VRF3 := (-A3/S3 * EXP(-R[3]/S3) + 6*C3/power(R[3], 7) + ALF1/2*sqr(1 - (ALF2 + ALF3)/power(R[2], 3)) *
             (4/power(R[3], 5) + (3*sqr(R[2]) - sqr(R[3]) - 3*sqr(R[1]))/power(R[1], 3)/power(R[3], 4)))/R[3];
  //C ---- right hands of differential equations
  ZP[1] := -G3*(G3*Q[1] + Q[4])*VRF1 - Q[1]*VRF2 - G2*(G2*Q[1] - Q[4])*VRF3;
  ZP[2] := -G3*(G3*Q[2] + Q[5])*VRF1 - Q[2]*VRF2 - G2*(G2*Q[2] - Q[5])*VRF3;
  ZP[3] := -G3*(G3*Q[3] + Q[6])*VRF1 - Q[3]*VRF2 - G2*(G2*Q[3] - Q[6])*VRF3;
  ZP[4] := -(G3*Q[1] + Q[4])*VRF1 + (G2*Q[1] - Q[4])*VRF3;
  ZP[5] := -(G3*Q[2] + Q[5])*VRF1 + (G2*Q[2] - Q[5])*VRF3;
  ZP[6] := -(G3*Q[3] + Q[6])*VRF1 + (G2*Q[3] - Q[6])*VRF3;
  ZQ[1] := P[1] / MU2;
  ZQ[2] := P[2] / MU2;
  ZQ[3] := P[3] / MU2;
  ZQ[4] := P[4] / MU;
  ZQ[5] := P[5] / MU;
  ZQ[6] := P[6] / MU;
end;

procedure tform4.init;
begin
  s1 := p1;
  s2 := p2;
  s3 := p3;

  EPS := 0.0001;
  RINI := 250.0;
  RZ := 30.0;
end;

procedure tform4.Culc_traj;
var
  zpi, eaini, earel, pini: real;
  c, tcol, atet, afi: real;
  p: parr;
  q: qarr;
  tf: textfile;
  i: integer;
begin
  HT := 50.0;
  ZPI := 4.0 * arctan(1.0);
  M1 := M1 * 1837.0;
  M2 := M2 * 1837.0;
  M3 := M3 * 1837.0;
  MU := M1*(M2 + M3)/(M1 + M2 + M3);
  MU2 := M2*M3 / (M2 + M3);
  G2 := M2 / (M2 + M3);
  G3 := M3 / (M2 + M3);

  spectr; // БШГНБ ОПНЖЕДСПШ

  EAini := t.Eini * 3.67502E-2;
  EArel := t.Erel * 3.67502E-2;
  PINI := -SQRT(2. * MU2 * EAini);
  C := sqr(PINI) / 2 / MU2 - 1 / RINI;
  TCOL := SQRT(MU2/2) / C*(1 / 2 / SQRT(C)*Ln(2*SQRT(C*(C*sqr(RINI) + RINI)) + 2*C*RINI + 1) - SQRT(C*sqr(RINI) + RINI));    // dlog = ln ???
  ATET := t.TET / 180. * ZPI;
  AFI := t.FI / 180. * ZPI;

  P[1] := PINI * COS(ATET);
  P[2] := PINI * SIN(ATET) * COS(AFI);
  P[3] := PINI * SIN(ATET) * SIN(AFI);
  Q[1] := RINI * COS(ATET);
  Q[2] := RINI * SIN(ATET) * COS(AFI);
  Q[3] := RINI * SIN(ATET) * SIN(AFI);
  P[4] := -SQRT(2. * MU * EArel);
  P[5] := 0;
  P[6] := 0;
  Q[4] := P[4] / MU*TCOL;
  Q[5] := t.Bet;
  Q[6] := 0;

  INTEGr(P, Q); // БШГНБ ОПНЖЕДСПШ
end;

function tform4.f;
begin
  result := A2 * EXP(-R/S2) - 1/R - (ALF2 + ALF3) / 2 / power(R, 4) - C2/power(R, 6);
end;

function tform4.fp;
begin
  result := -A2/S2 * EXP(-R/S2) + 1/sqr(R) + 2*(ALF2 + ALF3)/power(R, 5) + 6*C2/power(R, 7);
end;

function tform4.fpp;
begin
  result := A2/sqr(S2) * EXP(-R/S2) - 2./power(R, 3) - 10*(ALF2 + ALF3)/power(R, 6) - 42*C2/power(R, 8);
end;

procedure tform4.Spectr;
var
  r, rl, rh, rmin: real;
begin
  R := 3;
  while ((FP(R) * FP(R - 1)) > 0) do R := R + 1;

  RL := R - 1;
  RH := R;

  while ((RH - RL) >= EPS) do begin
    R := (RL + RH)/2;
    IF((FP(R) * FP(RL)) > 0) then RL := R;
    IF((FP(R) * FP(RH)) > 0) then RH := R;
  end;
  RMIN := (RL + RH)/2;
  D2 := -F(RMIN);
  ZG := SQRT(FPP(RMIN) / MU2);
  ZF := 1 / (2 * MU2 * sqr(RMIN));
end;

procedure TForm4.ReadIni;
var
  name: string;
  tt: string;
begin
  Name := 'Xe.ini';
  name := ExtractFiledir(application.ExeName) + '\' + name;
  inifile := tinifile.Create(name);
  with inifile do begin
    a1 := readfloat('Atom', 'a1', 318.5);
    a2 := readfloat('Atom', 'a2', 127.5);
    a3 := readfloat('Atom', 'a3', 62.84);
    p1 := readfloat('Atom', 'p1', 0.6494);
    p2 := readfloat('Atom', 'p2', 0.7073);
    p3 := readfloat('Atom', 'p3', 0.877);
    alf1 := readfloat('Atom', 'al1', 27.2);
    alf2 := readfloat('Atom', 'al2', 16.5);
    alf3 := readfloat('Atom', 'al3', 32.46);
    c1 := readfloat('Atom', 'c1', 490);
    c2 := readfloat('Atom', 'c2', 87.36);
    c3 := readfloat('Atom', 'c3', 297.3);

    m1 := readfloat('Atom', 'm1', 131.3);
    m2 := readfloat('Atom', 'm2', 132.905);
    m3 := readfloat('Atom', 'm3', 79.904);

  end;
end;

end.
