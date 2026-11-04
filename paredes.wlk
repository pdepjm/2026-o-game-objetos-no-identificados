import wollok.game.*

class Pared {
  const property position
  const property image

  method esAtacable() = false
  method alColisionarConPersonaje() {}
}

object paredes {
  const imagenHorizontal = "paredHorizontal.png"
  const imagenVertical = "paredVertical.png"

    method horizontal(desdeX, hastaX, y) =
    (desdeX..hastaX).map({ x => self.paredEn(game.at(x, y), imagenHorizontal) })

  method vertical(x, desdeY, hastaY) =
    (desdeY..hastaY).map({ y => self.paredEn(game.at(x, y), imagenVertical) })

  method paredEn(posicion, imagen) = new Pared(position = posicion, image = imagen)
  
  method ultimoX() = game.width() - 1

  method ultimoY() = game.height() - 1

  method bordeSuperior() =
    self.horizontal(0, self.ultimoX(), 0)

  method bordeInferior() =
    self.horizontal(0, self.ultimoX(), self.ultimoY())

  method bordeIzquierdo() =
    self.vertical(0, 1, self.ultimoY() - 1)

  method bordeDerecho() =
    self.vertical(self.ultimoX(), 1, self.ultimoY() - 1)

  method borde() {
    return self.bordeSuperior() +
           self.bordeInferior() +
           self.bordeIzquierdo() +
           self.bordeDerecho()
  }
}