import wollok.game.*
import temporizador.*
import personaje.*
import velocidad.*

// Clase base: define lo que tienen en común todos los obstaculos.
// Cada tipo de obstaculo solo tiene que decir su imagen y su efecto.
class Obstaculo {
  var property position
  method danioAlPersonaje() = 1

  method image()

  method esAtacable() = false

  // lo llama personaje.reaccionarAColision() cuando el personaje pisa el obstaculo
  method alColisionarConPersonaje() {
    // primero se saca del tablero, asi desaparece al pisarlo
    game.removeVisual(self)
    self.aplicarEfecto()
  }

  // cada subclase define que le hace al juego
  method aplicarEfecto()
}

// Suma segundos al temporizador de la sala (efecto positivo)
class RelojDeArena inherits Obstaculo {
    // segundos que suma; lo define cada sala al crearlo
  const segundos
  override method image() = "relojDeArena.png"

  override method aplicarEfecto() {
    temporizador.sumarSegundos(segundos)
  }
}

// Resta segundos al temporizador de la sala (efecto negativo)
class RelojRoto inherits Obstaculo {
  const segundos  // segundos que resta; lo define cada sala al crearlo
  override method image() = "relojRoto.png"

  override method aplicarEfecto() {
    temporizador.restarSegundos(segundos)
  }
}

// Resta una vida al pisarlos (dano inmediato, sin duracion)
class Pinchos inherits Obstaculo {
  override method image() = "pinchos.png"

  override method aplicarEfecto() {
    personaje.perderVidaActual(self.danioAlPersonaje())
  }
}

// Durante unos segundos, el personaje recibe el doble de dano
class Maldicion inherits Obstaculo {
  // segundos que dura la maldicion; lo define cada sala al crearla
  const segundos

  override method image() = "maldicion.png"

  override method aplicarEfecto() {
    personaje.maldecir(segundos)
  }
}

// Ayudante para crear varios pinchos pegados, como hace paredes con las paredes
object trampas {
  // fila de pinchos en la altura y, desde la columna desdeX hasta hastaX
  method pinchosHorizontal(desdeX, hastaX, y) =
    (desdeX..hastaX).map({ x => new Pinchos(position = game.at(x, y)) })

  // columna de pinchos en la columna x, desde la altura desdeY hasta hastaY
  method pinchosVertical(x, desdeY, hastaY) =
    (desdeY..hastaY).map({ y => new Pinchos(position = game.at(x, y)) })
}

// Al pisarlo, el personaje se mueve mas lento durante unos segundos
class CharcoDeBarro inherits Obstaculo {
  // segundos que dura la lentitud; lo define cada sala al crearlo
  const segundos

  override method image() = "charcoDeBarro.png"

  override method aplicarEfecto() {
    controlDeVelocidad.ralentizar(segundos) 
  }
}

// Al pisarla, el personaje se mueve mas rapido durante unos segundos
class PistaDeVelocidad inherits Obstaculo {
  // segundos que dura la velocidad; lo define cada sala al crearla
  const segundos

  override method image() = "pistaDeVelocidad.png"

  override method aplicarEfecto() {
    controlDeVelocidad.acelerar(segundos) 
  }
}