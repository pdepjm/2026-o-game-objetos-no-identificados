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
  var internas = []

  // lo llama cada sala al entrar: registra las paredes internas y las dibuja junto con el borde
  method construir(lista) {
    internas = lista
    const todas = self.borde() + lista
    todas.forEach { p => game.addVisual(p) }
  }

  method bloquea(unaPosicion) =
    internas.any({ pared => pared.position() == unaPosicion })

  method horizontal(desdeX, hastaX, y) =
    (desdeX..hastaX).map({ x => new ParedHorizontal(position = game.at(x, y)) })

  method vertical(x, desdeY, hastaY) =
    (desdeY..hastaY).map({ y => new ParedVertical(position = game.at(x, y)) })

  // marco del tablero (decorativo, el limite real lo da tablero.dentroDeLimites)
  method borde() {
    const ultimoX = game.width() - 1
    const ultimoY = game.height() - 1
    return self.horizontal(0, ultimoX, 0) +
           self.horizontal(0, ultimoX, ultimoY) +
           self.vertical(0, 1, ultimoY - 1) +
           self.vertical(ultimoX, 1, ultimoY - 1)
  }
}