import wollok.game.*

object temporizador {
  var tiempoRestante = 0
  var segundosDePreparacion = 0

  // durante la preparacion el aviso va en el centro, despues vuelve abajo
  method position() = if (self.preparando()) game.center() else game.at(6, 0)

  method text() =
    if (self.preparando()) "¡Prepárate! " + segundosDePreparacion
    else "tiempo: " + tiempoRestante

  method esAtacable() = false

  method tiempoRestante() = tiempoRestante
  method preparando() = segundosDePreparacion > 0
  method seAcabo() = tiempoRestante == 0

  // lo llama cada sala al entrar
  method iniciar(segundos) {
    tiempoRestante = segundos
  }

  // lo llama cada sala al entrar, para dar tiempo a mirar el mapa
  method iniciarPreparacion(segundos) {
    segundosDePreparacion = segundos
  }

  method pasarSegundoDePreparacion() {
    segundosDePreparacion = (segundosDePreparacion - 1).max(0)
  }

  method descontarSegundo() {
    tiempoRestante = (tiempoRestante - 1).max(0)
  }

  // lo llaman los obstaculos al ser pisados
  method sumarSegundos(segundos) {
    tiempoRestante = tiempoRestante + segundos
  }

  method restarSegundos(segundos) {
    tiempoRestante = (tiempoRestante - segundos).max(0)
  }
}