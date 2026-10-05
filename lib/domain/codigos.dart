/// Códigos estáveis dos vocabulários (seção 11). Os rótulos ficam na tabela
/// `lista_valor` e podem mudar; estes códigos não.
abstract final class StatusFoco {
  static const detectado = 'detectado';
  static const emControle = 'em_controle';
  static const controlado = 'controlado';
  static const rebrotou = 'rebrotou';
  static const erradicado = 'erradicado';
  static const descartado = 'descartado';

  static const todos = [detectado, emControle, rebrotou, controlado, erradicado, descartado];

  /// Focos em que a espécie ainda está (ou pode estar) presente.
  static const ativos = {detectado, emControle, rebrotou};
}

abstract final class TipoObservacao {
  static const deteccao = 'deteccao';
  static const revisita = 'revisita';
}

abstract final class Presenca {
  static const presente = 'presente';
  static const ausente = 'ausente';
}

abstract final class ResultadoRevisita {
  static const ausente = 'ausente';
  static const presenteReduzido = 'presente_reduzido';
  static const presenteIgual = 'presente_igual';
  static const presenteAumentou = 'presente_aumentou';
  static const rebrota = 'rebrota';
}

abstract final class MetodoManejo {
  static const quimicos = {'corte_herbicida', 'anelamento_herbicida', 'herbicida_foliar'};
}

abstract final class OrigemCoordenada {
  static const gpsAuto = 'gps_auto';
  static const gpsAjustado = 'gps_ajustado';
  static const estimada = 'estimada';
}

abstract final class SyncStatus {
  static const pendente = 'pendente';
  static const enviado = 'enviado';
  static const erro = 'erro';
}

abstract final class Perfil {
  static const campo = 'campo';
  static const gestor = 'gestor';
  static const admin = 'admin';

  static bool podeGerir(String perfil) => perfil == gestor || perfil == admin;
}

abstract final class Listas {
  static const formaVida = 'forma_vida';
  static const estagio = 'estagio';
  static const quantificacaoTipo = 'quantificacao_tipo';
  static const classeAbundancia = 'classe_abundancia';
  static const ambiente = 'ambiente';
  static const statusFoco = 'status_foco';
  static const metodoManejo = 'metodo_manejo';
  static const destinacao = 'destinacao';
  static const resultadoRevisita = 'resultado_revisita';
  static const origemCoordenada = 'origem_coordenada';
  static const condicaoTempo = 'condicao_tempo';
}

const especieOutra = 'outra';
