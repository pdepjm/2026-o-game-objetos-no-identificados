
import wollok.game.*
import personaje.*

class PantallaFinal {
  const property image
  const property position = game.at(1, 7)

  method esAtacable() = false
  method alColisionarConPersonaje() {}
}

object victoria {
  const pantalla = new PantallaFinal(image = "pantalla_victoria.png")

  method ejecutar() {
    game.addVisual(pantalla)
  }
}

object derrota {
  const pantalla = new PantallaFinal(image = "pantalla_derrota.png")

  method ejecutar() {
    game.addVisual(pantalla)
  }
}