import wollok.mirror.*
import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*
import obstaculos.*
import velocidad.*
import componentesPersonaje.*

object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property danioActual = 25
  const distanciaAtaqueInicial = 4
  var property distanciaAtaque = distanciaAtaqueInicial
  
  method image() = "personaje.png"

  method vidaActual() = vidaPersonaje.actual()
  method vidaMaxima() = vidaPersonaje.maxima()

  method municionActual() = arsenal.actual()

  method cambiarMunicion() {
    arsenal.cambiar()
  }

  method adquirirMunicion(bala) {
    arsenal.adquirir(bala)
  }

  method perderVidaActual(cantidad) {
    vidaPersonaje.perder(cantidad)
  }

  // lo llama la Maldicion al ser pisada; dura la cantidad de segundos indicada
  method maldecir(segundos) {
    vidaPersonaje.maldecir(segundos)
  }

  method terminarMaldicion() {
    vidaPersonaje.terminarMaldicion()
  }

  method recuperarVidaActual(cantidad){
    vidaPersonaje.recuperar(cantidad)
  }

  method aumentarVidaMaxima(cantidad){
    vidaPersonaje.aumentarMaxima(cantidad)
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

  method modificarDistanciaAtaque(cantidad) {
    distanciaAtaque = (distanciaAtaque + cantidad).max(0)
  }

  method puedeAtacarEn(posicion) = position.distance(posicion) <= distanciaAtaque

  method atacarEn(posicion) {
    if (self.puedeAtacarEn(posicion)) {
      combate.atacarEn(posicion, self.municionActual())
    }
  }

  method mover(nuevaPosicion) {
    if (miJuego.puedeJugar()) {
      self.guardarPosicion()
      controlDeVelocidad.mover(self.direccionHacia(nuevaPosicion)) 
    }
  }

  // diferencia entre donde estoy y el destino
  method direccionHacia(destino) = game.at(destino.x() - position.x(), destino.y() - position.y())

  // da un paso de una casilla en esa direccion, si nada lo bloquea
  method avanzar(direccion) {
    const destino = game.at(position.x() + direccion.x(), position.y() + direccion.y())
    if (tablero.esTransitable(destino)) {
      position = destino
    }
  }

  method agregarObjeto(objeto){
    inventarioPersonaje.agregar(objeto)
  }

// reinicia los atributos del personaje a los valores iniciales
  method reiniciar() {
    vidaPersonaje.reiniciar()
    danioActual = 25
    distanciaAtaque = distanciaAtaqueInicial
    controlDeVelocidad.reiniciar() 
    inventarioPersonaje.reiniciar()
    arsenal.reiniciar()
  }

}

