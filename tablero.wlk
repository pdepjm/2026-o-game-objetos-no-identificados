import wollok.game.*
import paredes.*

object tablero {
  var paredesActuales = []

  method ultimoX() = game.width() - 1
  method ultimoY() = game.height() - 1

  method bordeInferior() = paredes.horizontal(0, self.ultimoX(), 0)
  method bordeSuperior() = paredes.horizontal(0, self.ultimoX(), self.ultimoY())
  method bordeIzquierdo() = paredes.vertical(0, 1, self.ultimoY() - 1)
  method bordeDerecho() = paredes.vertical(self.ultimoX(), 1, self.ultimoY() - 1)

  method borde() =
    self.bordeInferior() + self.bordeSuperior() +
    self.bordeIzquierdo() + self.bordeDerecho()

  method construir(listaDeParedes) {
    paredesActuales = listaDeParedes
    const todas = self.borde() + listaDeParedes

    todas.forEach({ pared => game.addVisual(pared) })
  }

  method paredesInternas() = paredesActuales

  method bloqueada(unaPosicion) =
    paredesActuales.any({ pared => pared.position() == unaPosicion })

  method esTransitable(unaPosicion) =
    self.dentroDeLimites(unaPosicion) && !self.bloqueada(unaPosicion)

  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, self.ultimoX() - 1) &&
    unaPosicion.y().between(1, self.ultimoY() - 1)
}

object lineaDeVision {
  const tolerancia = 0.2 // decide cuánto puede apartarse una pared de la recta que une al personaje con el enemigo y aun así tapar la vista.

  method despejada(origen, destino) =
    !tablero.paredesInternas().any({ pared => self.estaEnElCamino(pared.position(), origen, destino) })

  method estaEnElCamino(punto, origen, destino) =
    origen.distance(punto) + punto.distance(destino) <= origen.distance(destino) + tolerancia
}