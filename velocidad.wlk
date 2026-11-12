import wollok.game.*
import personaje.*

// cada velocidad sabe como mover al personaje en la direccion que le piden
object velocidadNormal {
  method mover(direccion, unPersonaje) {
    unPersonaje.avanzar(direccion)
  }
}

object velocidadRapida {
  method mover(direccion, unPersonaje) {
    unPersonaje.avanzar(direccion)
    unPersonaje.avanzar(direccion)
  }
}

object velocidadLenta {
  // alterna: un intento avanza y el siguiente no
  var avanza = false

  method mover(direccion, unPersonaje) {
    avanza = !avanza
    if (avanza) unPersonaje.avanzar(direccion)
  }

  method reiniciar() {
    avanza = false
  }
}

object controlDeVelocidad {
  // pasos que le quedan a cada efecto (si pisa dos del mismo tipo, rige el que mas dure)
  var velocidadActual = velocidadNormal
  var pasosRestantes = 0

  // el personaje pide mover y la velocidad vigente decide como
  method mover(direccion, unPersonaje) {
    velocidadActual.mover(direccion, unPersonaje)
    self.gastarEfecto(unPersonaje)
  }

  method gastarEfecto(unPersonaje) {
    if (pasosRestantes > 0) {
      pasosRestantes = pasosRestantes - 1
      if (pasosRestantes == 0) {
        velocidadActual = velocidadNormal
      }
    }
  }

  // Al pisar el charco de barro, cambiamos el estado directamente
  method ralentizar(pasos, unPersonaje) {
    velocidadActual = velocidadLenta
    pasosRestantes = pasos
    game.say(unPersonaje, "¡Barro! Me muevo más lento")
  }

  // Al pisar la pista de velocidad, cambiamos el estado directamente
  method acelerar(pasos, unPersonaje) {
    velocidadActual = velocidadRapida
    pasosRestantes = pasos
    game.say(unPersonaje, "¡Voy más rápido!")
  }

  // lo llama personaje.reiniciar()
  method reiniciar() {
    velocidadActual = velocidadNormal
    pasosRestantes = 0
    velocidadLenta.reiniciar()
  }
}