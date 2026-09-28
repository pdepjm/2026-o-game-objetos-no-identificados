
object sala1 inherits sala {
  method fondo() = "sala1.png"
  // posicion provisional
  method enemigos() = [
    new EnemigoComun(position = game.at(1, 2)),
    new EnemigoComun(position = game.at(3, 4)),
    new EnemigoComun(position = game.at(5, 6))
  ]
  method puntoDeEntrada() = game.at(1, 1)
}

object sala2 inherits sala {
  method fondo() = "sala2.png"
  // posicion provisional
  method enemigos() = [
    new EnemigoComun(position = game.at(1, 2)),
    new EnemigoComun(position = game.at(3, 4)),
    new EnemigoComun(position = game.at(5, 6)),
    new EnemigoComun(position = game.at(7, 8)),
    new EnemigoComun(position = game.at(9, 10))
  ]
  method puntoDeEntrada() = game.at(1, 1)
}
