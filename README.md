# Challenge do Milenio Capital

## Querido diário

- Fazer isso rodar foi levemente irritante.

- Pra mim, o ideal de um "coding challenge" é que esteja tudo pronto pra rodar.

- O teste não está testando se a minha API vai aceitar só json ou outra coisa.

- Não é óbvio o que essa coisa aqui está tentando fazer por causa da repetição de linhas, mas se o negocinho já estiver rodando, ele vai matar ele e deletar a minha imagem, então alterei o teste porque essa parte estava me atrapalhando e eu tenho certeza também vai atrapalhar outras pessoas.

```
if !Process.find_executable("docker-compose").nil?
  abort unless Process.run("docker-compose", ["-f=docker-compose.yml", "up", "-d"], **STDIO).success?
  at_exit { Process.run("docker-compose", ["down"], **STDIO) }
elsif !Process.find_executable("docker").nil?
  abort unless Process.run("docker", ["compose", "-f=docker-compose.yml", "up", "-d"], **STDIO).success?
  at_exit { Process.run("docker", ["compose", "down"], **STDIO) }
else
  abort("It seems that docker compose is not installed.")
end
```

- Não entendi se o pragrama é pra ser ser um cliente de graphql ou se eu posso baixar a resposta em json e usar ela mesma, então eu fiz isso.

- Qual função ele está usando pra calcular a "popularidade da dimensão"? The devil is in the details. Vou intuir que o que estava na descrição foi um erro (errar é humano, não é mesmo) e a média se refere ao contexto daquele plano de viagem. Se funcionar, funcionou, se não funcionar eu não perco meu tempo porque não preciso disso.

- Considerei usar sqlite pra fazer um banco de dados. Achei overkill e não fiz. No mundo real ele deveria aceitar uma conexão com um banco de dados ou ORM ou qualquer coisa assim, só que o Rick também não existe, então tanto faz se tem persistência ou não.

- Não tenho familiaridade nenhuma com Crystal , nem com o ecossistema, nem com as comunidades.

- O plano de viagem deve otimizar a si mesmo??? Ou será que otimizar um plano deve ser uma ação do Planejador de Viagem? Os dois approaches dão o mesmo resultado. Pra mim o certo é que o Planejador leia um plano de viagem e crie um novo plano de viagem otimizado a partir dele, sendo o plano de viagem uma entidade burrinha, sem comportamento próprio. Um plano otimizado é uma entidade cuja duração está limitada àquela verificação do teste.

- Sem "teste unitário" nenhum porque como você vai testar uma coisa que você não sabe o que é pra fazer????????