program Project2;

uses
  Forms,
  Minimum in 'Minimum.pas' {Form1},
  Area in 'Area.pas' {Form2},
  traj_Hg in 'traj_Hg.pas' {Form3},
  Traj_Xe in 'Traj_Xe.pas' {Form4},
  Traj_Kr in 'Traj_Kr.pas' {Form5},
  Setka in 'Setka.pas' {Form6};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
