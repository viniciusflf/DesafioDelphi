unit ConsultaCEP.View.Principal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    EdtCEP: TEdit;
    BtnConsultar: TButton;
    Layout3: TLayout;
    Label1: TLabel;
    lbl_CEP: TLabel;
    Label3: TLabel;
    lbl_Rua: TLabel;
    Label5: TLabel;
    lbl_Complemento: TLabel;
    Label7: TLabel;
    lbl_Bairro: TLabel;
    Label9: TLabel;
    lbl_Cidade: TLabel;
    Label11: TLabel;
    lbl_UF: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnConsultarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtCEPKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure Limpa_Dados;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.BtnConsultarClick(Sender: TObject);
var
   HTTP     : THTTPClient;
   Response : IHTTPResponse;
   URL      : string;
   JsonObj  : TJSONObject;
   i : Integer;
begin
   if EdtCEP.Text = EmptyStr  then
   begin
      ShowMessage('CEP não informado!');
      Exit;
   end;
   if (Length(EdtCEP.Text) <> 8) or (not TryStrToInt(EdtCEP.Text,i) )then
   begin
      ShowMessage('CEP inválido. Deve conter 8 dígitos numéricos!');
      Exit;
   end;
    HTTP := THTTPClient.Create;
   try
      URL := Format('http://localhost:9000/api/v1/cep/%s', [EdtCEP.Text]);
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
                  lbl_CEP.Text := JsonObj.GetValue<TJSONString>('cep').Value;
               if not JsonObj.GetValue<TJSONString>('logradouro').Value.IsEmpty then
                  lbl_Rua.Text := JsonObj.GetValue<TJSONString>('logradouro').Value;
               if not JsonObj.GetValue<TJSONString>('complemento').Value.IsEmpty then
                  lbl_Complemento.Text := JsonObj.GetValue<TJSONString>('complemento').Value;
               if not JsonObj.GetValue<TJSONString>('bairro').Value.IsEmpty then
                  lbl_Bairro.Text := JsonObj.GetValue<TJSONString>('bairro').Value;
               if not JsonObj.GetValue<TJSONString>('localidade').Value.IsEmpty then
                  lbl_Cidade.Text := JsonObj.GetValue<TJSONString>('localidade').Value;
               if not  JsonObj.GetValue<TJSONString>('uf').Value.IsEmpty then
                  lbl_UF.Text := JsonObj.GetValue<TJSONString>('uf').Value;
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

procedure TFrmPrincipal.EdtCEPKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if key = vkReturn then
   begin
      BtnConsultarClick(Sender);
   end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
   Limpa_Dados;
   {$IFDEF MSWINDOWS}
   Self.Position      := TFormPosition.ScreenCenter;
   Self.BorderIcons   := [TBorderIcon.biSystemMenu];
   Self.BorderStyle   := TFmxFormBorderStyle.Single;
   Self.Height        := 641;
   Self.Width         := 411;
   {$ENDIF}
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   EdtCEP.SetFocus;
end;

procedure TFrmPrincipal.Limpa_Dados;
begin
   EdtCEP.Text          := EmptyStr;
   lbl_CEP.Text         := '...';
   lbl_Rua.Text         := '...';
   lbl_Complemento.Text := '...';
   lbl_Bairro.Text      := '...';
   lbl_Cidade.Text      := '...';
   lbl_UF.Text          := '...';
end;

end.
