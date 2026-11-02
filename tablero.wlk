import wollok.game.*
import paredes.*

object tablero {
  var paredesActuales = []

  method construir(listaDeParedes) {
    paredesActuales = listaDeParedes
    const todas = paredes.borde() + listaDeParedes

    todas.forEach({ pared =>
      game.addVisual(pared)
    })
  }

  method paredesInternas() = paredesActuales
  
  method bloqueada(unaPosicion) =
    paredesActuales.any({ pared =>
      pared.position() == unaPosicion
    })

  method esTransitable(unaPosicion) =
    self.dentroDeLimites(unaPosicion) && !self.bloqueada(unaPosicion)

  method dentroDeLimites(unaPosicion) =
    unaPosicion.x().between(1, game.width() - 2) &&
    unaPosicion.y().between(1, game.height() - 2)
}

object lineaDeVision {
  const tolerancia = 0.2 // decide cuánto puede apartarse una pared de la recta que une al personaje con el enemigo y aun así tapar la vista.

  method despejada(origen, destino) =
    !tablero.paredesInternas().any({ pared => self.estaEnElCamino(pared.position(), origen, destino) })

  method estaEnElCamino(punto, origen, destino) =
    origen.distance(punto) + punto.distance(destino) <= origen.distance(destino) + tolerancia
}