import wollok.mirror.*
import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*
import obstaculos.*
import velocidad.*


object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property danioActual = 25
  
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

  method atacarEn(posicion) {
    combate.atacarEn(posicion, self.municionActual())
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
    controlDeVelocidad.reiniciar() 
    inventarioPersonaje.reiniciar()
    arsenal.reiniciar()
  }

}

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

    game.say(personaje, "Ahora, mi cantidad de vidaActual es: " + vidaActual)

    if (vidaActual == 0) {
      miJuego.terminarJuego()
    } else if (vidaActual == 1) {
      miJuego.salaActual().aparecerPocionDeVida()
    }
  }

  method danioPorGolpe(cantidad) =
    if (maldiciones > 0) cantidad * 2 else cantidad

  method recuperar(cantidad) {
    vidaActual = (vidaActual + cantidad).min(vidaMaxima)
    game.say(personaje, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
  }

  method aumentarMaxima(cantidad) {
    vidaMaxima = vidaMaxima + cantidad
  }

  method maldecir(segundos) {
    maldiciones = maldiciones + 1
    game.say(personaje, "¡Maldito! Recibo el doble de daño")
    game.schedule(segundos * 1000, { self.terminarMaldicion() })
  }

  method terminarMaldicion() {
    maldiciones = (maldiciones - 1).max(0)
    if (maldiciones == 0) {
      game.say(personaje, "Se me pasó la maldición")
    }
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
