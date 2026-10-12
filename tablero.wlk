import wollok.game.*

object tablero {
  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, game.width() - 2) &&
    unaPosicion.y().between(1, game.height() - 2)
}
