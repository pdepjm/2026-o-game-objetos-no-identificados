import wollok.game.*

class Pared {
  const property position
  const property image

  method esAtacable() = false
  method alColisionarConPersonaje(unPersonaje) {}
}

object paredes {
  const imagenHorizontal = "paredHorizontal.png"
  const imagenVertical = "paredVertical.png"

  method horizontal(desdeX, hastaX, y) =
    (desdeX..hastaX).map({ x => self.paredEn(game.at(x, y), imagenHorizontal) })

  method vertical(x, desdeY, hastaY) =
    (desdeY..hastaY).map({ y => self.paredEn(game.at(x, y), imagenVertical) })

  method paredEn(posicion, imagen) = new Pared(position = posicion, image = imagen)
  
}