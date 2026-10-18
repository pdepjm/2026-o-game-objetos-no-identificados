import wollok.game.*
import personaje.*
import tablero.*
import logicaJuego.*


class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = self.vidaInicial()

  method image()

  method vidaInicial()

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method dentroDeLimites(unaPosicion) = tablero.esTransitable(unaPosicion)

  method perseguir() {
    const objetivo = personaje.position()
    var destino = position

    // Movimiento paso a paso buscando al jugador
    if (position.x() < objetivo.x()) destino = destino.right(1)
    else if (position.x() > objetivo.x()) destino = destino.left(1)

    if (position.y() < objetivo.y()) destino = destino.up(1)
    else if (position.y() > objetivo.y()) destino = destino.down(1)

    if (self.dentroDeLimites(destino)) {
      self.guardarPosicion()
      position = destino
    }
  }

  method reaccionarAColision(elemento) {
    self.retroceder()
  }

  method alColisionarConPersonaje() {
    personaje.perderVidaActual()
  }

  method recibirAtaque() {
    self.recibirDanio()

    if (self.estaMuerto()) {
      miJuego.eliminarEnemigo(self)
    }
  }

  method recibirDanio(){
    vida = vida - personaje.dañoActual()
  }

  method esAtacable() = true

  method estaMuerto() = vida <= 0
}

class EnemigoComun inherits Enemigo{
  override method vidaInicial() = 100

  override method image() = "enemigoComun.png"

}

class ClonMalvado inherits Enemigo{
  override method vidaInicial() = personaje.vidaActual() * personaje.dañoActual()

  override method image() = "clonMalvado.png"
}

