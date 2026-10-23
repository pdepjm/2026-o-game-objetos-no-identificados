import wollok.game.*
import personaje.*

// cada velocidad sabe como mover al personaje en la direccion que le piden
object velocidadNormal {
  method mover(direccion) {
    personaje.avanzar(direccion)
  }
}

object velocidadRapida {
  method mover(direccion) {
    personaje.avanzar(direccion)
    personaje.avanzar(direccion)
  }
}

object velocidadLenta {
  // alterna: un intento avanza y el siguiente no
  var avanza = false

  method mover(direccion) {
    avanza = !avanza
    if (avanza) personaje.avanzar(direccion)
  }

  method reiniciar() {
    avanza = false
  }
}

object controlDeVelocidad {
  // pasos que le quedan a cada efecto (si pisa dos del mismo tipo, rige el que mas dure)
  var pasosDeLentitud = 0
  var pasosDeAceleracion = 0

  // si tiene lentitud y aceleracion a la vez, se cancelan y va a velocidad normal
  method velocidadActual() =
    if (pasosDeLentitud > 0 && pasosDeAceleracion == 0) velocidadLenta
    else if (pasosDeAceleracion > 0 && pasosDeLentitud == 0) velocidadRapida
    else velocidadNormal

  // el personaje pide mover y la velocidad vigente decide como
  method mover(direccion) {
    self.velocidadActual().mover(direccion)
    self.gastarEfectos()
  }

  method gastarEfectos() {
    if (pasosDeLentitud == 1) game.say(personaje, "Salí del barro")
    if (pasosDeAceleracion == 1) game.say(personaje, "Se me pasó la velocidad")
    pasosDeLentitud = (pasosDeLentitud - 1).max(0)
    pasosDeAceleracion = (pasosDeAceleracion - 1).max(0)
  }

  // lo llama el CharcoDeBarro al ser pisado; dura esa cantidad de pasos
  method ralentizar(pasos) {
    pasosDeLentitud = pasosDeLentitud.max(pasos)
    game.say(personaje, "¡Barro! Me muevo más lento")
  }

  // lo llama la PistaDeVelocidad al ser pisada; dura esa cantidad de pasos
  method acelerar(pasos) {
    pasosDeAceleracion = pasosDeAceleracion.max(pasos)
    game.say(personaje, "¡Voy más rápido!")
  }

  // lo llama personaje.reiniciar()
  method reiniciar() {
    pasosDeLentitud = 0
    pasosDeAceleracion = 0
    velocidadLenta.reiniciar()
  }
}