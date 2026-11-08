import wollok.game.*

object arriba {
  method siguiente(posicion) = posicion.up(1)
  method opuesta() = abajo
}

object abajo {
  method siguiente(posicion) = posicion.down(1)
  method opuesta() = arriba
}

object izquierda {
  method siguiente(posicion) = posicion.left(1)
  method opuesta() = derecha
}

object derecha {
  method siguiente(posicion) = posicion.right(1)
  method opuesta() = izquierda
}

