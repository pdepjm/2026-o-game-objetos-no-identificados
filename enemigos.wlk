import personaje.*
class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = 100

  // Nombre de la imagen
  method image() = "enemigoComun.png"

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, game.width() - 2) &&
    unaPosicion.y().between(1, game.height() - 2)

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

  method recibirDanio(){
    vida = vida-25
  }

  method esAtacable() = true

  method estaMuerto() = vida <= 0
}
