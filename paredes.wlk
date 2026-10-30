import wollok.game.*

class Pared {
  var property position

  method image()
  method esAtacable() = false

  // el bloqueo lo resuelve paredes.bloquea() antes de moverse
  method alColisionarConPersonaje() {}
}

class ParedHorizontal inherits Pared {
  override method image() = "paredHorizontal.png"
}

class ParedVertical inherits Pared {
  override method image() = "paredVertical.png"
}

object paredes {

  method horizontal(desdeX, hastaX, y) =
  (desdeX..hastaX).map({ x =>
    new ParedHorizontal(position = game.at(x, y))
  })

  method vertical(x, desdeY, hastaY) =
    (desdeY..hastaY).map({ y =>
    new ParedVertical(position = game.at(x, y))
  })
  
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