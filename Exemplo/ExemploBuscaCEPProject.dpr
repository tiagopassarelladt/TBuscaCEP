program ExemploBuscaCEPProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  ExemploTBuscaCEP in 'ExemploTBuscaCEP.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
