import wollok.game.*
import logicaJuego.*

class Puerta {
  var property position = game.at(5, 18)
  var desbloqueada = false

  method desbloqueada() = desbloqueada

  method image() = "puerta.png"

  method esAtacable() = false

  method desbloquear() {
    desbloqueada = true
  }

  method alColisionarConPersonaje(unPersonaje) {
    if (desbloqueada && miJuego.salaActual().itemsAgarrados()) miJuego.avanzarSala()
  }
}
