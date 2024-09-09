# Projeto de Consulta de CEP - Delphi

### Introdução
Este projeto implementa um sistema resiliente de consulta de CEP via API, utilizando múltiplos serviços de consulta de CEP com a técnica de **Failover**. Desenvolvido em Delphi, o sistema segue o padrão arquitetural MVC (Model-View-Controller) e utiliza o framework HORSE para criar uma API RESTful robusta.

### API Públicas Utilizadas

- **ViaCEP** (https://viacep.com.br/)
- **Apicep** (https://apicep.com/api-de-consulta/)
- **AwesomeAPI** (https://docs.awesomeapi.com.br/api-cep)


### Arquitetura MVC (Model-View-Controller)

MVC é um padrão de arquitetura de software que separa a aplicação em três componentes principais:

- **Model (Modelo)**: Contém a lógica de negócios e manipulação de dados. Ele representa os dados da aplicação e as regras de como os dados podem ser manipulados e alterados.

- **View (Visão)**: Responsável pela apresentação dos dados ao usuário. A view é a interface com o usuário, geralmente na forma de elementos visuais como formulários, botões e campos de texto.

- **Controller (Controlador)**: Atende a entrada do usuário, processa as ações do usuário e atualiza o modelo e a visão. Ele interpreta as entradas do usuário (como cliques ou envio de formulários) e decide quais operações realizar.

O objetivo do MVC é separar as preocupações, o que facilita a manutenção, escalabilidade e modularização da aplicação.


### Técnica de Failover

O failover é o processo pelo qual o sistema automaticamente muda para um serviço de backup se o principal estiver indisponível. Neste projeto, o ViaCEP é o serviço principal, e Apicep e AwesomeAPI são backups. Se o ViaCEP estiver offline, o sistema consulta automaticamente as outras APIs, garantindo a continuidade do serviço. Isso assegura alta disponibilidade, utilizando a técnica de Failover, para manter o funcionamento da consulta de CEPs mesmo em caso de falha de um dos provedores.


### Lógica de Failover Implementada

Aqui está o fluxo básico de failover implementado no código:

-  O sistema tenta primeiro consultar o ViaCEP.
-  Se o ViaCEP falhar, o sistema faz o failover para o Apicep.
-  Se o Apicep também falhar, ele tenta a AwesomeAPI.


### Tecnologias Utilizadas

- **Delphi**: Linguagem de programação para construir a aplicação.
- **Horse**: Framework minimalista e eficiente para construir APIs RESTful.
- **TNetHTTPClient**: Componente nativo de Delphi para fazer requisições HTTP.
- **Boss**: Gerenciador de pacotes para Delphi, utilizado para instalar as dependências do projeto.

### Requisitos
Para rodar este projeto, você precisará dos seguintes softwares e bibliotecas:

### Ambiente de Desenvolvimento
- **Delphi** com suporte ao **FireMonkey** e **VCL**)
- **Boss** (gerenciador de pacotes Delphi) - [`Instalação do Boss`](https://github.com/HashLoad/boss) 



## **Passos para Instalação**

1. **Clone o repositório do projeto**:

   ```bash
   git clone https://github.com/viniciusflf/DesafioDelphi.git
   ```
   
2. **Instale as dependências com o Boss**:

   ```bash
   boss update
   ```


3. **Abra o projeto no Delphi**:

- Abra o arquivo ConsultaCepAPI.dpr na IDE Delphi.

4. Compile e execute o projeto:

- Compile o projeto e execute a API localmente.


### Execução
A API será inicializada localmente na porta 9000 por padrão. Ela oferece um endpoint para consultar informações de endereço baseado em um CEP.

### Comando para Iniciar o Servidor
Ao compilar e executar o projeto na IDE Delphi, o servidor da API será inicializado automaticamente.

### Endpoints Disponíveis
- **GET** /api/v1/cep/{cep}: Recebe o CEP como parâmetro e retorna as informações de endereço. O CEP deve ser passado no formato correto (8 dígitos).

---

### Exemplo de Uso da API
Com a API em execução, você pode fazer requisições para consultar um CEP. Abaixo segue um exemplo utilizando o curl.

### Consultar um CEP Válido
   ```bash
   http://localhost:9000/api/v1/cep/01001000
   ```


### Resposta (Sucesso):
   ```bash
{
  "cep": "01001-000",
  "logradouro": "Praça da Sé",
  "complemento": "lado ímpar",
  "bairro": "Sé",
  "localidade": "São Paulo",
  "uf": "SP"
}
   ```


### Consultar um CEP Inválido
   ```bash
   http://localhost:9000/cep/0000000
   ```

### Resposta (Erro):
   ```bash
{
  "status": 400,
  "message": "CEP inválido. Deve conter 8 dígitos numéricos."
}
   ```


### Conclusão
Este projeto demonstra uma implementação prática de failover em Delphi usando APIs externas. Ele foi desenvolvido para garantir que os serviços continuem operando, mesmo quando APIs externas estão fora do ar. O failover garante