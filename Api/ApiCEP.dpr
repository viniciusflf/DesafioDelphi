program ApiCEP;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Compression,
  Horse.Jhonson,
  Horse.HandleException,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient;

type

  // Interface para os provider de CEP
  ICEPProvider = interface
    function ConsultaCEP(const CEP: string): TJSONObject;
    function SetNext(const ANext: ICEPProvider): ICEPProvider;
  end;

  // Classe base abstrata para os provider de CEP
  TCEPProviderBase = class(TInterfacedObject, ICEPProvider)
  private
    FNext: ICEPProvider;
  public
    function ConsultaCEP(const CEP: string): TJSONObject; virtual; abstract;
    function SetNext(const ANext: ICEPProvider): ICEPProvider;
  end;

  // Provider VIACEP
  TProviderViaCEP = class(TCEPProviderBase)
  public
    function ConsultaCEP(const CEP: string): TJSONObject; override;
  end;

  // Provider APICEP
  TProviderAPICEP = class(TCEPProviderBase)
  public
    function ConsultaCEP(const CEP: string): TJSONObject; override;
  end;

  // Provider AwesomeAPI
  TProviderAwesomeAPI = class(TCEPProviderBase)
  public
    function ConsultaCEP(const CEP: string): TJSONObject; override;
  end;

{ TCEPProviderBase }

// Define o próximo provedor na cadeia de responsabilidade
function TCEPProviderBase.SetNext(const ANext: ICEPProvider): ICEPProvider;
begin
   FNext := ANext;
   Result := ANext;
end;

{ TProviderViaCEP }

// Consulta CEP usando a API do ViaCEP
function TProviderViaCEP.ConsultaCEP(const CEP: string): TJSONObject;
var
   HTTP     : THTTPClient;
   Response : IHTTPResponse;
   URL      : string;
   JsonObj  : TJSONObject;
   JsonObjResult : TJSONObject;
begin
   Result := nil;
   HTTP := THTTPClient.Create;
   try
      URL := Format('https://viacep.com.br/ws/%s/json/', [CEP]);
      try
         Response := HTTP.Get(URL);
         if Response.StatusCode = 200 then
         begin
            // Se a consulta for bem-sucedida, retorna o resultado
            JsonObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
            // retorna o resultado no mesmo padrão para aplicação cliente
            if Assigned(JsonObj) then
            begin
               // Cria o objeto de resultado e adiciona os pares
               JsonObjResult := TJSONObject.Create;
               JsonObjResult.AddPair('cep', JsonObj.GetValue<TJSONString>('cep').Value);
               JsonObjResult.AddPair('logradouro', JsonObj.GetValue<TJSONString>('logradouro').Value);
               JsonObjResult.AddPair('complemento', JsonObj.GetValue<TJSONString>('complemento').Value);
               JsonObjResult.AddPair('bairro', JsonObj.GetValue<TJSONString>('bairro').Value);
               JsonObjResult.AddPair('localidade', JsonObj.GetValue<TJSONString>('localidade').Value);
               JsonObjResult.AddPair('uf', JsonObj.GetValue<TJSONString>('uf').Value);
               Result := JsonObjResult;
            end;
         end;
      except
         begin
            if Assigned(FNext) then
            begin
               // Se falhar, passa para o próximo provedor
               Result := FNext.ConsultaCEP(CEP);
            end;
         end;
      end;
   finally
      HTTP.Free;
   end;
end;

{ TProviderAPICEP }

function FormatarCEP(const CEP: string): string;
var
  ApenasNumeros: string;
  I: Integer;
begin
  // Remove todos os caracteres que não são números
  ApenasNumeros := '';
  for I := 1 to Length(CEP) do
    if CharInSet(CEP[I], ['0'..'9']) then
      ApenasNumeros := ApenasNumeros + CEP[I];
  // Verifica se o comprimento do CEP é válido (8 dígitos)
  if Length(ApenasNumeros) = 8 then
    Result := Copy(ApenasNumeros, 1, 5) + '-' + Copy(ApenasNumeros, 6, 3)
  else
    raise Exception.Create('CEP inválido. O CEP deve conter 8 dígitos.');
end;

// Consulta CEP usando a API do APICEP
function TProviderAPICEP.ConsultaCEP(const CEP: string): TJSONObject;
var
   HTTP: THTTPClient;
   Response: IHTTPResponse;
   URL: string;
   JsonObj  : TJSONObject;
   JsonObjResult : TJSONObject;
begin
   Result := nil;
   HTTP := THTTPClient.Create;
   try
      URL := Format('https://apicep.com/api/v1/%s.json', [FormatarCEP(CEP)]);
      try
         Response := HTTP.Get(URL);
         if Response.StatusCode = 200 then
         begin
            // Se a consulta for bem-sucedida, retorna o resultado
            JsonObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
            // retorna o resultado no mesmo padrão para aplicação cliente
            if Assigned(JsonObj) then
            begin
               JsonObjResult := TJSONObject.Create;
               JsonObjResult.AddPair('cep', JsonObj.GetValue<TJSONString>('code').Value);
               JsonObjResult.AddPair('logradouro', JsonObj.GetValue<TJSONString>('address').Value);
               JsonObjResult.AddPair('complemento', TJSONNull.Create());
               JsonObjResult.AddPair('bairro', JsonObj.GetValue<TJSONString>('district').Value);
               JsonObjResult.AddPair('localidade', JsonObj.GetValue<TJSONString>('city').Value);
               JsonObjResult.AddPair('uf', JsonObj.GetValue<TJSONString>('state').Value);
               Result := JsonObjResult;
            end;
         end
         else
         begin
            if Assigned(FNext) then
            begin
               // Se falhar, passa para o próximo provedor
               Result := FNext.ConsultaCEP(CEP);
            end;
         end;
      except
         begin
            if Assigned(FNext) then
            begin
               // Se falhar, passa para o próximo provedor
               Result := FNext.ConsultaCEP(CEP);
            end;
         end;
      end;
   finally
      HTTP.Free;
   end;
end;

{ TProviderAwesomeAPI }

// Consulta CEP usando a API do AwesomeAPI
function TProviderAwesomeAPI.ConsultaCEP(const CEP: string): TJSONObject;
var
   HTTP: THTTPClient;
   Response: IHTTPResponse;
   URL: string;
   JsonObj  : TJSONObject;
   JsonObjResult : TJSONObject;
begin
   Result := nil;
   HTTP := THTTPClient.Create;
   try
      URL := Format('https://cep.awesomeapi.com.br/json/%s', [CEP]);
      try
         Response := HTTP.Get(URL);
         if Response.StatusCode = 200 then
         begin
            // Se a consulta for bem-sucedida, retorna o resultado
            JsonObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
            // retorna o resultado no mesmo padrão para aplicação cliente
            if Assigned(JsonObj) then
            begin
               JsonObjResult := TJSONObject.Create;
               JsonObjResult.AddPair('cep', JsonObj.GetValue('cep').Value);
               JsonObjResult.AddPair('logradouro', JsonObj.GetValue('address').Value);
               JsonObjResult.AddPair('complemento', TJSONNull.Create());
               JsonObjResult.AddPair('bairro', JsonObj.GetValue<TJSONString>('district').Value);
               JsonObjResult.AddPair('localidade', JsonObj.GetValue<TJSONString>('city').Value);
               JsonObjResult.AddPair('uf', JsonObj.GetValue<TJSONString>('state').Value);
               Result := JsonObjResult;
            end;
         end;
         // Se a consulta for bem-sucedida, retorna o resultado
      except
         begin
            Result := nil;
         end;
      end;
   finally
      HTTP.Free;
   end;
end;

// Format Json de Result
function ResponseStatus(vMensagem : String; vStatus : Integer ): string;
begin
   Result := '{' + #13+
             ' "status": '    + vStatus.ToString + ',' + #13+
             ' "message": "'  + vMensagem        + '"' + #13+
             '}';
end;

// Manipulador de requisições para a rota de CEP
procedure CEPRequest(Req: THorseRequest; Res: THorseResponse);
var
   CEP: string;
   Provider: ICEPProvider;
   Result: TJSONObject;
   i : Integer;
begin
   // Obtém o CEP informado na requisição
   CEP := Req.Params['cep'];
   // Valida se o CEP foi informado corretamente
   if CEP.IsEmpty then
   begin
      Res.Status(THTTPStatus.Unauthorized).Send(ResponseStatus('CEP não informado.',401));
      Exit;
   end;
   // Verifica se o CEP contém apenas números e tem 8 caracteres
   if (Length(CEP) <> 8) or (not TryStrToInt(CEP,i) )then
   begin
      Res.Status(THTTPStatus.Unauthorized).Send(ResponseStatus('CEP inválido. Deve conter 8 dígitos numéricos.',401));
      Exit;
   end;
   // Cria a cadeia de responsabilidade dos provedores
   Provider := TProviderViaCEP.Create;
   Provider.SetNext(TProviderAPICEP.Create).SetNext(TProviderAwesomeAPI.Create);
   try
      // Realiza a consulta do CEP
      Result := Provider.ConsultaCEP(CEP);
      if Assigned(Result) then
      begin
         // Se encontrou o CEP, retorna o resultado
         Res.ContentType('application/json').Status(THTTPStatus.OK).Send(Result.ToJSON);
      end
      else
      begin
         // Se não encontrou, retorna erro 404
         Res.Status(THTTPStatus.NotFound).Send(ResponseStatus('CEP não encontrado',404));
      end;
   except on E: Exception do
      begin
         // Se ocorreu algum erro, retorna erro 500
         Res.Status(THTTPStatus.InternalServerError).Send(ResponseStatus(Format('"Erro interno do servidor: %s"', [E.Message]),500));
      end;
   end;
end;

begin
   {$IFDEF MSWINDOWS}
   IsConsole := False;
   ReportMemoryLeaksOnShutdown := True;
   {$ENDIF}
   try
      THorse
        .Use(Compression())
        .Use(Jhonson)
        .Group
        .Prefix('/api/v1')
        .Get('/',
             procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
             begin
                Res.ContentType('application/json').Send(ResponseStatus('Api de consulta de CEP online',200)).Status(THTTPStatus.OK);
             end)
        .Get('/cep/:cep', CEPRequest);
      THorse.MaxConnections := 1000;
      THorse.Listen(9000,
        procedure
        begin
          Writeln(Format('Api rodado na porta %s:%d', [THorse.Host, THorse.Port]));
          Readln;
        end);
   except
     on E: Exception do
      begin
         Writeln(E.ClassName, ': ', E.Message);
      end;
   end;
end.
