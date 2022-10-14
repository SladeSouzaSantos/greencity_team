#Remote Add Account Use Case

#Caso de sucesso
1. Sistema valida os dados (X)
2. Sistema faz uma requisição para a URL da API de signup (X)
3. Sistema valida os dados recebidos da API (X)
4. Sistema entrega os dados da conta do usuário (X)

#Exceção - URL inválida
1. Sistema retorna uma mensagem de erro inesperado (X)

#Exceção - Dados inválida
1. Sistema retorna uma mensagem de erro inesperado (X)

#Exceção - Resposta inválida
1. Sistema retorna uma mensagem de erro inesperado ()

#Exceção - Falha no servidor
1. Sistema retorna uma mensagem de erro inesperado (X)

#Exceção - Email em uso
1. Sistema retorna uma mensagem de erro informando que o e-mail já está em uso (X)