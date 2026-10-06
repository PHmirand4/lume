/// Versão de apresentação (demonstração para a Flona).
///
/// Com `true`: o login por e-mail e senha fica desligado e, depois da abertura,
/// o app pede só nome e função; a sessão fica salva no aparelho e nada é
/// sincronizado com o servidor (os registros ficam no celular).
///
/// Para voltar ao login normal, troque para `false` — a tela de login
/// (`LoginScreen`) e a sincronização continuam no código, intactas.
const modoApresentacao = true;
