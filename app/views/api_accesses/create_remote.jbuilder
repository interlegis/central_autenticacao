if @success
  json.success 'Usuário com chave criado com sucesso'
else
  json.error 'Não foi possível criar esse usuário'
end