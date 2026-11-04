import wollok.mirror.*
import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*
import obstaculos.*
import velocidad.*
import personaje.*
import sonidos.*



object arsenal {
  const municiones = [balaComun]

  method actual() = municiones.first()

  method cambiar() {
    const actual = municiones.first()
    municiones.remove(actual)
    municiones.add(actual)
  }

  method adquirir(bala) {
    if(!municiones.contains(bala)) {
      municiones.add(bala)
      game.say(personaje, "Conseguí balas: " + bala.nombre())
    }
  }

  method reiniciar() {
    municiones.clear()
    municiones.add(balaComun)
  }
}

object combate {
  method encontrarObjetivoEn(posicion) =
    game.getObjectsIn(posicion).findOrElse(
      {elemento => elemento.esAtacable()}, {null})

  method atacarEn(posicion, municion) {
    const objetivo = self.encontrarObjetivoEn(posicion)
    if(objetivo != null) {
      sonidos.sonidoDisparo()
      objetivo.recibirAtaque(municion)
    }
  }
}

object vidaPersonaje {
  var vidaMaxima = 3
  var vidaActual = 3
  var maldiciones = 0

  method actual() = vidaActual
  method maxima() = vidaMaxima

  method perder(cantidad) {
    vidaActual = (vidaActual - self.danioPorGolpe(cantidad)).max(0)
  }

  method danioPorGolpe(cantidad) =
    if (maldiciones > 0) cantidad * 2 else cantidad

  method recuperar(cantidad) {
    vidaActual = (vidaActual + cantidad).min(vidaMaxima)
  }

  method aumentarMaxima(cantidad) {
    vidaMaxima = vidaMaxima + cantidad
  }

  method maldecir(segundos) {
    maldiciones = maldiciones + 1
  }

  method terminarMaldicion() {
    maldiciones = (maldiciones - 1).max(0)
  }

  method reiniciar() {
    vidaMaxima = 3
    vidaActual = 3
    maldiciones = 0
  }
}

object inventarioPersonaje {
  const inventario = []

  method agregar(objeto) {
    inventario.add(objeto)
  }

  method reiniciar() {
    inventario.clear()
  }
}