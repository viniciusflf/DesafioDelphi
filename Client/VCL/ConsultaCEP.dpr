program ConsultaCEP;

uses
  Vcl.Forms,
  ConsultaCEP.View.Principal in 'View\ConsultaCEP.View.Principal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
