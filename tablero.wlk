import wollok.game.*
import paredes.*

object tablero {
  var paredesActuales = []

  method construir(listaDeParedes) {
    paredesActuales = listaDeParedes
    const todas = paredes.borde() + listaDeParedes

    todas.forEach({ pared =>
      game.addVisual(pared)
    })
  }

  method bloqueada(unaPosicion) =
    paredesActuales.any({ pared =>
      pared.position() == unaPosicion
    })

  method esTransitable(unaPosicion) =
    self.dentroDeLimites(unaPosicion) && !self.bloqueada(unaPosicion)

  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, game.width() - 2) &&
    unaPosicion.y().between(1, game.height() - 2)
}
