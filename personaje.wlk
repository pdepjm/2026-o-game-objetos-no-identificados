import wollok.mirror.*
import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*
import obstaculos.*
import velocidad.*
import componentesPersonaje.*
import direcciones.*
import sonidos.*

object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property direccion = abajo
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
    miJuego.reaccionarAPerdidaDeVida()
  }

    // lo llama la Maldicion al ser pisada; dura la cantidad de segundos indicada
  method maldecir(segundos) {
    vidaPersonaje.maldecir()
    game.say(self, "¡Maldito! Recibo el doble de daño")
    game.schedule(segundos * 1000, { self.terminarMaldicion() })
  }

  method terminarMaldicion() {
    vidaPersonaje.terminarMaldicion()
    if (!vidaPersonaje.estaMaldito()) game.say(self, "Se me pasó la maldición")
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
    elemento.alColisionarConPersonaje(self)
  }

  method esAtacable() = false

  method modificarDistanciaAtaque(cantidad) {
    distanciaAtaque = (distanciaAtaque + cantidad).max(0)
  }

  method estaAlAlcance(posicion) = position.distance(posicion) <= distanciaAtaque
  method veDesdeAqui(posicion) = lineaDeVision.despejada(position, posicion)
  method puedeAtacarEn(posicion) =
  miJuego.puedeJugar() && self.estaAlAlcance(posicion) && self.veDesdeAqui(posicion)

  method atacarEn(posicion) {
    if (miJuego.puedeJugar() && self.puedeAtacarEn(posicion)) {
      combate.atacarEn(posicion, self.municionActual())
    }
  }

  method posicionesEnFrente() {
    var pos = position
    return (1..distanciaAtaque).map({ i =>
      pos = direccion.siguiente(pos)
      pos
    })
  }

  method objetivoEnFrente() =
    self.posicionesEnFrente()
      .map({ pos => combate.encontrarObjetivoEn(pos) })
      .findOrElse({ obj => obj != null }, { null })

  method atacar() {
    if (miJuego.puedeJugar()) {
      const objetivo = self.objetivoEnFrente()
      if (objetivo != null) {
        self.atacarEn(objetivo.position())
      } else {
        sonidos.sonidoDisparo()
      }
    }
  }

  method mover(unaDireccion) {
    if (miJuego.puedeJugar()) {
      direccion = unaDireccion
      self.guardarPosicion()
      controlDeVelocidad.mover(unaDireccion, self) 
    }
  }

  // da un paso de una casilla en esa direccion, si nada lo bloquea
  method avanzar(unaDireccion) {
    const destino = unaDireccion.siguiente(position)
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
    direccion = abajo
    danioActual = 25
    distanciaAtaque = distanciaAtaqueInicial
    controlDeVelocidad.reiniciar() 
    inventarioPersonaje.reiniciar()
    arsenal.reiniciar()
  }

}

