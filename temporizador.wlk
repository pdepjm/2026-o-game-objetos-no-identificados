import wollok.game.*
import logicaJuego.*

object temporizador {
  var tiempoRestante = 0
  var activo = false
  var preparando = false
  var segundosDePreparacion = 0

   // durante la preparacion el aviso va en el centro, despues vuelve abajo
  method position() = if (preparando) game.center() else game.at(6, 0)
  method text() =
    if (preparando) "¡Prepárate! " + segundosDePreparacion
    else "tiempo: " + tiempoRestante
  method esAtacable() = false

  method preparando() = preparando

  // lo llama miJuego una sola vez, al iniciar la partida
  method iniciarPreparacion(segundos) {
    segundosDePreparacion = segundos
    preparando = true
  }

  // lo llama cada sala al entrar
  method iniciar(segundos) {
    tiempoRestante = segundos
    activo = true
  }

  method detener() {
    activo = false
  }

  // lo llama miJuego cada 1 segundo
  method pasarSegundo() {
    if (preparando) {
     segundosDePreparacion = segundosDePreparacion - 1
      if (segundosDePreparacion == 0) preparando = false
    } else if (activo && !miJuego.salaActual().estaLimpia()) {
      tiempoRestante = (tiempoRestante - 1).max(0)
      if (tiempoRestante == 0) miJuego.terminarJuego()
    }
  }
}