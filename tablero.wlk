import wollok.game.*
import paredes.*

object tablero {

  method esTransitable(unaPosicion) =
    self.dentroDeLimites(unaPosicion) && !paredes.bloquea(unaPosicion)

  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, game.width() - 2) &&
    unaPosicion.y().between(1, game.height() - 2)
}
