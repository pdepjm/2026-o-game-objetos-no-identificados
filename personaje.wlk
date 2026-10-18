import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*


object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property danioActual = 25
  const inventario = []
  const municiones = [balaComun]

  
  method image() = "personaje.png"
  var vidaMaxima = 3
  var vidaActual = 3
  method vidaActual () = vidaActual
  method vidaMaxima () = vidaMaxima

  method municionActual() = municiones.first()

  method cambiarMunicion() {
    const actual = municiones.first()
    municiones.remove(actual)
    municiones.add(actual)
  }

  method adquirirMunicion(bala) {
    if (!municiones.contains(bala)) {
      municiones.add(bala)
      game.say(self, "Conseguí balas: " + bala.nombre())
    }
  }

  method perderVidaActual() {
    vidaActual = (vidaActual - 1).max(0)
    game.say(self, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
    if(vidaActual == 0){
      miJuego.terminarJuego()
    }
  }

  method recuperarVidaActual(cantidad){
    vidaActual = (vidaActual + cantidad).min(vidaMaxima)
    game.say(self, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
  }

  method aumentarVidaMaxima(cantidad){
    vidaMaxima = vidaMaxima + cantidad
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
      objetivo.recibirAtaque(self.municionActual())
    }
  }

  method mover(nuevaPosicion) {
    self.guardarPosicion()
    if (tablero.esTransitable(nuevaPosicion)) {
      position = nuevaPosicion
    }
  }

  method agregarObjeto(objeto){
    inventario.add(objeto)
  }

// reinicia los atributos del personaje a los valores iniciales
method reiniciar() {
    vidaMaxima = 3
    vidaActual = 3
    danioActual = 25
    inventario.clear()
  }

}


