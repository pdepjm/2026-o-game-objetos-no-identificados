import wollok.game.*
import logicaJuego.*
import tablero.*

object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property dañoActual = 25
  const inventario = []
  
  method image() = "personaje.png"
  var vidaMaxima = 3
  var vidaActual = 3
  method vidaActual () = vidaActual
  method vidaMaxima () = vidaMaxima

  method perderVidaActual() {
    vidaActual = (vidaActual - 1).max(0)
    game.say(self, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
    if(vidaActual == 0){
      miJuego.terminarJuego()
    }
  }

  method recuperarVidaActual(cantidad){
    vidaActual = (vidaActual + cantidad).max(vidaMaxima)
    game.say(self, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
  }

  method aumentarVidaMaxima(cantidad){
    vidaMaxima = cantidad
  }

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  // cada elemento sabe que le pasa al personaje cuando lo toca (enemigo, puerta, etc.)
  method reaccionarAColision(elemento) {
    elemento.alColisionarConPersonaje()
  }

  method esAtacable() = false

  method encontrarObjetivoEn(posicion) {
  return game.getObjectsIn(posicion).findOrElse(
    { elemento => elemento.esAtacable() },
    { null }
  )
  }

  method atacarEn(posicion) {
    const objetivo = self.encontrarObjetivoEn(posicion)
    if (objetivo != null) {
      objetivo.recibirAtaque()
    }
  }

  method mover(nuevaPosicion) {
    self.guardarPosicion()
    // Limita el movimiento dentro de la grilla visible
    if (tablero.dentroDeLimites(nuevaPosicion)) {
      position = nuevaPosicion
    }
  }

  method agregarObjeto(objeto){
    inventario.add(objeto)
  }

}


