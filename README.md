# \[ 👷‍ ⛏ 🚧 Work in progress 👷 🔧 🚧 \] iUNES

Este é o UNES para iOS.
Depois de infinitos emails, pessoas pedindo pessoalmente e até um aviãozinho pedindo isso, finalmente decidi atender às requisições (apesar de que não vou conseguir postar na App Store quando terminar, ou talvez eu vá, não sei)

O projeto está em fase de decisões e definições iniciais e ainda não está pronto para receber pull requests em itens que envolvam a arquitetura do aplicativo. Uma vez que todos os elementos base já estiverem definidos e com um roadmap bem definido, as contribuições serão muito bem vindas.

## Algumas escolhas
Algumas coisas já estão sendo pensadas e se você quiser contribuir com algo para ser adicionado na stack durante a fase de planejamento basta abrir uma issue e iremos conversar :)

- Redux, Redux-Sauce, Sagas
- Realm para salvar os dados [AsyncStorage em poucos casos]
- React Native Navigation
- O crawler do SAGRES apesar de estar no projeto será exportado para uma lib à parte (Aceito sugestões de nomes), deixando assim o projeto mais modularizado e disponibilizando o pacote para a comunidade
- As telas do aplicativo iOS não necessáriamente serão iguais à do nativo Android, já que cada plataforma fica mais normal com seus respectivos itens nativos.
- O foco desse projeto é o perfeito funcionamento no iOS, se a view fica feia no android mas ótima para iOS ela é aceita, mas a recíproca não é verdadeira.

## Tarefas
No momento eu estou transferindo o crawler de kotlin/java para javascript.
- [X] Login (a parte mais difícil)
- [X] Mensagens
- [ ] Horários
- [ ] Calendário
- [ ] Disciplinas
- [ ] Notas
- [ ] Download de Materiais

Se você se sentir confortável para desenvolver alguma tela (com seu proprio design) para alguma das tarefas que o crawler já está funcionando (como o fluxo de login e lista de mensagens) pode ficar à vontade, basta mandar o pull request :)