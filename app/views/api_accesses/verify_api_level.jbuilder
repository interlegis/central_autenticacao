if @api.present?
  json.api do
    json.id @api.id
    json.level @api.api_accesses_level.id
    json.cpf @api.user.cpf
  end
else
  json.error 'Chave inválida'
end