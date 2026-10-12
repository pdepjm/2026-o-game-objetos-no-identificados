import wollok.game.*
import personaje.*
import tablero.*
import logicaJuego.*


class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = 100

  method image() = "enemigoComun.png"

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method dentroDeLimites(unaPosicion) =
    tablero.dentroDeLimites(unaPosicion)

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
    personaje.perderVidas()
  }

  method recibirAtaque() {
    self.recibirDanio()

    if (self.estaMuerto()) {
      miJuego.eliminarEnemigo(self)
    }
  }

  method recibirDanio(){
    vida = vida-25
  }

  method esAtacable() = true

  method estaMuerto() = vida <= 0
}
