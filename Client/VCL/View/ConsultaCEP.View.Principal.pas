unit ConsultaCEP.View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    BtConsulta: TButton;
    Panel1: TPanel;
    CEP: TLabeledEdit;
    Panel2: TPanel;
    Label1: TLabel;
    lbl_CEP: TLabel;
    Label2: TLabel;
    lbl_Rua: TLabel;
    Label4: TLabel;
    lbl_Complemento: TLabel;
    Label3: TLabel;
    lbl_Bairro: TLabel;
    Label7: TLabel;
    lbl_Cidade: TLabel;
    Label9: TLabel;
    lbl_UF: TLabel;
    procedure BtConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CEPKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure Limpa_Dados;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.BtConsultaClick(Sender: TObject);
var
   HTTP     : THTTPClient;
   Response : IHTTPResponse;
   URL      : string;
   JsonObj  : TJSONObject;
   i : Integer;
begin
   if CEP.Text = EmptyStr  then
   begin
      ShowMessage('CEP não informado!');
      Exit;
   end;
   if (Length(CEP.Text) <> 8) or (not TryStrToInt(CEP.Text,i) )then
   begin
      ShowMessage('CEP inválido. Deve conter 8 dígitos numéricos!');
      Exit;
   end;
    HTTP := THTTPClient.Create;
   try
      URL := Format('http://localhost:9000/api/v1/cep/%s', [CEP.Text]);
      try
         Response := HTTP.Get(URL);
         Limpa_Dados;
         if Response.StatusCode = 200 then
         begin
            // Se a consulta for bem-sucedida, retorna o resultado
            JsonObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
            if Assigned(JsonObj) then
            begin
               if not JsonObj.GetValue<TJSONString>('cep').Value.IsEmpty then
                  lbl_CEP.Caption := JsonObj.GetValue<TJSONString>('cep').Value;
               if not JsonObj.GetValue<TJSONString>('logradouro').Value.IsEmpty then
                  lbl_Rua.Caption := JsonObj.GetValue<TJSONString>('logradouro').Value;
               if not JsonObj.GetValue<TJSONString>('complemento').Value.IsEmpty then
                  lbl_Complemento.Caption := JsonObj.GetValue<TJSONString>('complemento').Value;
               if not JsonObj.GetValue<TJSONString>('bairro').Value.IsEmpty then
                  lbl_Bairro.Caption := JsonObj.GetValue<TJSONString>('bairro').Value;
               if not JsonObj.GetValue<TJSONString>('localidade').Value.IsEmpty then
                  lbl_Cidade.Caption := JsonObj.GetValue<TJSONString>('localidade').Value;
               if not  JsonObj.GetValue<TJSONString>('uf').Value.IsEmpty then
                  lbl_UF.Caption := JsonObj.GetValue<TJSONString>('uf').Value;
            end
            else
            begin
               ShowMessage('Falha no retorno!');
            end;
         end
         else
         begin
            ShowMessage('CEP não encontrado');
         end;
      except
         begin
            ShowMessage('CEP não encontrado');
         end;
      end;
   finally
      HTTP.Free;
   end;
end;

procedure TFrmPrincipal.CEPKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
   begin
      BtConsultaClick(Sender);
   end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
   Limpa_Dados;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   CEP.SetFocus;
end;

procedure TFrmPrincipal.Limpa_Dados;
begin
   CEP.Text                := EmptyStr;
   lbl_CEP.Caption         := '...';
   lbl_Rua.Caption         := '...';
   lbl_Complemento.Caption := '...';
   lbl_Bairro.Caption      := '...';
   lbl_Cidade.Caption      := '...';
   lbl_UF.Caption          := '...';
end;

end.
