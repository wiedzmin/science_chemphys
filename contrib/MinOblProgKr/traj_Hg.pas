unit traj_Hg;

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
  varr = record
    v13, v12, v23: real;
  end;
  TForm3 = class(TForm)
  private
    { Private declarations }
    A1, A2, A3, S1, S2, S3, C1, C2, C3, ALF1, ALF2, ALF3: real;
    procedure Spectr;
    procedure Integr(p: parr; q: qarr);
    procedure fun(var p: parr; var q: qarr; var r: rarr;  var zp: parr; var zq: qarr; var esys: real);
    function f(r: real): real;
    function fp(r: real): real;
    function fpp(r: real): real;
    function fint(r: real): real;
  public
    { Public declarations }
    RM: array [1..100000, 1..11] of real;
    v_arr: array[1..100000] of varr;
    EPS, HT, ZG, ZF: real;
    D2, d1, d3, a, r01, r02, r03, c, s: real;
    G2, G3, M1, M2, M3, MU2, MU: real;
    RINI, RZ, NLO, ZV, ZJ: real;
    KT: integer;
    t: point0;
    evib0, erot0: real;
    procedure Init;
    procedure ReadIni;
    procedure Culc_traj;
  end;

var
  Form3: TForm3;
  filename: string[255];
  workdir: string[255];


implementation

uses
  mmsystem, inifiles, minimum, area, traj_Xe, traj_Kr, setka;
var
  inifile: tinifile;

{$R *.dfm}

function tform3.fint;
begin
  result := a*exp(-r/s) - 1/r - (alf2 + alf3) / 2 / power(r, 4) - c/power(r, 6);
end;

procedure tform3.Integr;
var
  zr: array [0..12, 0..4] of real;
  za: array [0..12, 0..6] of real;
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
  RM[KT,1] := KT;
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

    KT := KT + 1;
    RM[KT, 1] := KT;

    for L := 1 to 3 do RM[KT, L+1] := R[L];

    RM[KT, 5] := (ESYS / 3.67502E-2) - ESYS0;
    RM[KT, 6] := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 / 3.67502E-2;
    RM[KT, 7] := (sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / 2 / MU / 3.67502E-2;
    RM[KT, 8] := RM[KT, 5] + RM[KT, 6] + RM[KT, 7];
    RM[KT, 9] := SQRT(sqr(P[4]/(M2 + M3) + P[1]/M2) + sqr(P[5]/(M2 + M3) + P[2]/M2) + sqr(P[6]/(M2 + M3) + P[3]/M2));
    RM[KT, 10] := SQRT(sqr(P[4]/(M2 + M3) - P[1]/M3) + sqr(P[5]/(M2 + M3) - P[2]/M3) + sqr(P[6]/(M2 + M3) - P[3]/M3));
    RM[KT, 11] := SQRT(sqr(P[4]) + sqr(P[5]) + sqr(P[6]))/M1;
  end;

  //   C ---- Adams (6-order)
  NLO := 0;
  NT := 5;
  recomb := false;
  repeat
    NT := NT + 1;
    IF(NT > 250000) then break;
    //C ----
    IF(R[1] > RINI) AND (R[2] < RZ) AND (R[3] > RINI) THEN begin
      ER := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 + Fint(R[2]);
      IF (ER < 0) then begin
        recomb := true;
        break;
      end;
    end;

    IF(R[1] > RINI) AND (R[2] > RINI) AND (R[3] > RINI) then break;
    //C ----
    for L := 1 to 6 do begin
      ZA[L,6] := ZP[L];
      ZA[L+6,6] := ZQ[L];
    end;
    for L := 1 to 6 do begin
      P[L] := P[L] + HT/1440*(4277*ZA[L, 6] - 7923*ZA[L, 5] + 9982*ZA[L, 4] - 7298*ZA[L, 3] + 2877*ZA[L, 2] - 475*ZA[L, 1]);
      Q[L] := Q[L] + HT/1440*(4277*ZA[L+6, 6] - 7923*ZA[L+6, 5] + 9982*ZA[L+6, 4] - 7298*ZA[L+6, 3] + 2877*ZA[L+6, 2] - 475*ZA[L+6, 1]);
    end;
    for L := 1 to 12 do
      for K := 1 to 5 do
        ZA[L, K] := ZA[L, K+1];
    //C ----
    FUN(P, Q, R, ZP, ZQ, ESYS);
    KT := KT + 1;
    RM[KT, 1] := KT;
    for L := 1 to 3 do
      RM[KT, L+1] := R[L];
    RM[KT, 5] := (ESYS / 3.67502E-2) - ESYS0;
    RM[KT, 6] := (sqr(P[1]) + sqr(P[2]) + sqr(P[3])) / 2 / MU2 / 3.67502E-2;
    RM[KT, 7] := (sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / 2 / MU / 3.67502E-2;
    RM[KT, 8] := RM[KT, 5] + RM[KT, 6] + RM[KT, 7];
    RM[KT, 9] := SQRT(sqr(P[4]/(M2 + M3) + P[1]/M2) + sqr(P[5]/(M2 + M3) + P[2]/M2) + sqr(P[6]/(M2 + M3) + P[3]/M2));
    RM[KT, 10] := SQRT(sqr(P[4]/(M2 + M3) - P[1]/M3) + sqr(P[5]/(M2 + M3) - P[2]/M3) + sqr(P[6]/(M2 + M3) - P[3]/M3));
    RM[KT, 11] := SQRT(sqr(P[4]) + sqr(P[5]) + sqr(P[6])) / M1;
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
    ZV := round(EVIB / ZG - 0.5); //ЙНКЕА. ЙБЮМР. ВХЯКН
    ZF := 1 / (2 * MU2 * sqr(SQ));
    ZJ := round(SQRT(EROT/ZF + 0.25) - 0.5); //БПЮЫ. ЙБЮМР. ВХЯКН
    NLO := 1;

    (*Goal functions for the optimization problem*)
    //the internal energy of CsBr; we need to minimize it
    //the recombination passed if Emolec < 4.73 eV.
    t.Emolec := (EVIB + EROT) / 3.67502E-2;
    //the energy taking by third atom from molecule CsBr; we need to maximize it
    t.eout := ((((sqr(rm[kt - 1][11] * (1 + M1/(M2 + M3))))*MU) / 2)) / 3.67502E-2 - t.erel;
    t.molec := true;
    t.rekomb := true;

  end else begin
    t.rekomb := false;
    t.emolec := (EVIB + EROT) / 3.67502E-2;
    t.eout := ((((sqr(rm[kt - 1][11]*(1 + M1/(M2 + M3))))*MU) / 2)) / 3.67502E-2 - t.erel;
    if (t.emolec < 2) or (t.emolec > 99) then t.molec := false else t.molec := true;
  end;
end;

procedure tform3.fun;
var
  vrf1,vrf2,vrf3:real;
  function f1(r1,r2,r3:real):real;
  begin
    //     F(R1,R2,R3)=D1*((R01/R1)**12-2.*(R01/R1)**6)-ALF1/2./R1**4
    //     *+A*EXP(-R2/S)-1./R2-(ALF2+ALF3)/2./R2**4-C/R2**6
    //     *+D3*((R03/R3)**12-2.*(R03/R3)**6)-ALF1/2./R3**4
    result := d1 * (power((R01/r1), 12) - 2*power((r01/r1), 6)) - alf1/2/power(r1, 4)
      + a*exp(-r2/s) - 1/R2 - (ALF2 + ALF3) / 2 / power(R2, 4) - C/power(R2, 6)
      + d3*(power((r03 / r3), 12) - 2*power((r03 / r3), 6)) - alf1/2/power(r3, 4);
  end;
begin
  //C ---- interatom distances
  R[1] := SQRT(sqr(G3*Q[1] + Q[4]) + sqr(G3*Q[2] + Q[5]) + sqr(G3*Q[3] + Q[6]));
  R[2] := SQRT(sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));
  R[3] := SQRT(sqr(G2*Q[1] - Q[4]) + sqr(G2*Q[2] - Q[5]) + sqr(G2*Q[3] - Q[6]));
  //C ---- potential function and it's derivatives
  ESYS := F1(R[1], R[2], R[3]);
  VRF1 := (12. * D1 * power((R01/R[1]), 6) * (1. - power((R01 / R[1]), 6))/R[1] + 2. * ALF1/power(R[1], 5))/R[1];
  VRF2 := (-A/S * EXP(-R[2]/S) + 1./sqr(R[2]) + 2. * (ALF2 + ALF3)/power(R[2], 5) + 6.*C/power(R[2], 7))/R[2];
  VRF3 := (12. * D3 * power((R03/R[3]), 6) * (1. - power((R03/R[3]), 6))/R[3] + 2.*ALF1/power(R[3], 5)) / R[3];
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

procedure tform3.init;
begin
  fillchar(rm, sizeof(rm), 0);

  EPS := 0.0001;
  rini := 250;
  RZ := 30.0;
end;

procedure tform3.Culc_traj;
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
  MU := M1 * (M2 + M3)/(M1 + M2 + M3);
  MU2 := M2 * M3/(M2 + M3);
  G2 := M2/(M2 + M3);
  G3 := M3/(M2 + M3);

  spectr; // БШГНБ ОПНЖЕДСПШ

  EAini := t.Eini * 3.67502E-2;
  EArel := t.Erel * 3.67502E-2;
  PINI := -SQRT(2. * MU2 * EAini);
  C := sqr(PINI) / 2 / MU2-1 / RINI;
  TCOL := SQRT(MU2/2) / C*(1 / 2 / SQRT(C) * Ln(2*SQRT(C*(C*sqr(RINI) + RINI))
                                                + 2*C*RINI + 1) - SQRT(C*sqr(RINI) + RINI));    // dlog = ln ???
  ATET := t.TET/180. * ZPI;
  AFI := t.FI/180. * ZPI;

  P[1] := PINI * COS(ATET);
  P[2] := PINI * SIN(ATET) * COS(AFI);
  P[3] := PINI * SIN(ATET) * SIN(AFI);
  Q[1] := RINI * COS(ATET);
  Q[2] := RINI * SIN(ATET) * COS(AFI);
  Q[3] := RINI * SIN(ATET) * SIN(AFI);
  P[4] := -SQRT(2. * MU * EArel);
  P[5] := 0;
  P[6] := 0;
  Q[4] := P[4]/MU * TCOL;
  Q[5] := t.Bet;
  Q[6] := 0;

  INTEGr(P, Q); // БШГНБ ОПНЖЕДСПШ

end;

function tform3.f;
begin
  result := A*EXP(-R/S) - 1/R - (ALF2 + ALF3) / 2 / power(R, 4) - C/power(R, 6);
end;

function tform3.fp;
begin
  result := -A/S*EXP(-R/S) + 1/sqr(R) + 2*(ALF2 + ALF3)/power(R, 5) + 6*C/power(R, 7);
end;

function tform3.fpp;
begin
  result := A/sqr(S) * EXP(-R/S) - 2./power(R, 3) - 10*(ALF2 + ALF3)/power(R, 6) - 42*C/power(R, 8);
end;

procedure tform3.Spectr;
var
  r, rl, rh, rmin: real;
begin
  R := 3;
  while ((FP(R) * FP(R - 1)) > 0) do R := R + 1;

  RL := R - 1;
  RH := R;

  while ((RH - RL) >= EPS) do begin
    R := (RL + RH) / 2;
    IF((FP(R) * FP(RL)) > 0) then RL := R;
    IF((FP(R) * FP(RH)) > 0) then RH := R;
  end;
  RMIN := (RL + RH)/2;
  D2 := -F(RMIN);
  ZG := SQRT(FPP(RMIN) / MU2);
  ZF := 1/(2 * MU2 * sqr(RMIN));
end;

procedure TForm3.ReadIni;
var
  name: string;
  tt: string;
begin
  Name := 'Hg.ini';
  name := ExtractFiledir(application.ExeName) + '\' + name;
  inifile := tinifile.Create(name);
  with inifile do begin
    a := readfloat('Atom', 'a', 127.5);
    s := readfloat('Atom', 's', 0.7037);
    c := readfloat('Atom', 'c', 87.36);
    d1 := readfloat('Atom', 'd1', 0.0011);
    d3 := readfloat('Atom', 'd3', 0.00081);
    r01 := readfloat('Atom', 'r01', 7.75);
    r03 := readfloat('Atom', 'r03', 7.56);
    alf1 := readfloat('Atom', 'alf1', 34.0);
    alf2 := readfloat('Atom', 'alf2', 16.5);
    alf3 := readfloat('Atom', 'alf3', 32.5);

    m1 := readfloat('Atom', 'm1', 200.593);
    m2 := readfloat('Atom', 'm2', 132.905);
    m3 := readfloat('Atom', 'm3', 79.904);
  end;
end;

end.
