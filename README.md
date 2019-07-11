# central_autenticacao
Central de Autenticação

Campos do openid connect:

name - retorna o nome completo do usuário

first_name - retorna apenas o primeiro nome

last_name - retorna apenas o último nome

cpf - retorna o cpf

phone - retorna o telefone

role - retorna o tipo de usuário

profile_image - retorna a imagem do perfil

Para as consultas são necessários os scopes openid, profile e email.

Esses campos podem ser reconfigurados alterando o arquivo config/initializers/doorkeeper_openid_connect.rb

Nos controllers:

* services_auth - configura todos os serviços de login externo google, facebook, interlegis e senado
* sessions - configura login por email e senha
* users - criação de usuário com senha e edição de todos os usuários
