program ConsultaCEP;

uses
  System.StartUpCopy,
  FMX.Forms,
  ConsultaCEP.View.Principal in 'View\ConsultaCEP.View.Principal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
