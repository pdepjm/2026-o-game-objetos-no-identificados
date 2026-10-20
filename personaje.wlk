import wollok.game.*
import logicaJuego.*
import tablero.*
import items.*
import obstaculos.*


object personaje {
  var property position = game.center()
  var ultimaPosicion = position
  var property danioActual = 25
  const inventario = []
  const municiones = [balaComun]
  
  method image() = "personaje.png"
  var vidaMaxima = 3
  var vidaActual = 3
  var maldiciones = 0  // cuantas maldiciones activas tiene (si pisa dos seguidas no se acumulan, el daño sigue siendo el doble)
  // efectos de velocidad activos (si pisa dos seguidos del mismo tipo no se acumulan)
  var lentitudes = 0
  var aceleraciones = 0
  // cuenta regresiva de latidos hasta el proximo paso
  var ticksParaMoverse = 0

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

  method perderVidaActual(cantidad) {
    vidaActual = (vidaActual - self.danioPorGolpe(cantidad)).max(0)
    game.say(self, "Ahora, mi cantidad de vidaActual es: " + vidaActual)
    if(vidaActual == 0){
      miJuego.terminarJuego()
    } else if (vidaActual == 1) {
      miJuego.salaActual().aparecerPocionDeVida()
    }
  }

  // daño que recibe por cada golpe: 1 normal, 2 si esta maldito
  method danioPorGolpe(cantidad) = if (maldiciones > 0) cantidad * 2 else cantidad

  // lo llama la Maldicion al ser pisada; dura la cantidad de segundos indicada
  method maldecir(segundos) {
    maldiciones = maldiciones + 1
    game.say(self, "¡Maldito! Recibo el doble de daño")
    game.schedule(segundos * 1000, { self.terminarMaldicion() })
  }

  method terminarMaldicion() {
    maldiciones = (maldiciones - 1).max(0)
    if (maldiciones == 0) game.say(self, "Se me pasó la maldición")
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
    if (miJuego.puedeJugar()) {
      self.guardarPosicion()
      if (tablero.esTransitable(nuevaPosicion)) {
        position = nuevaPosicion
      }
    }
  }

  // cada cuantos latidos (de 75 ms) da un paso: 2 normal, 1 rapido, 4 lento
  // si tiene los dos efectos a la vez, se cancelan y va a velocidad normal
  method ticksPorPaso() =
    if (lentitudes > 0 && aceleraciones == 0) 4
    else if (aceleraciones > 0 && lentitudes == 0) 1
    else 2

  // lo llama el CharcoDeBarro al ser pisado
  method ralentizar(segundos) {
    lentitudes = lentitudes + 1
    game.say(self, "¡Barro! Me muevo más lento")
    game.schedule(segundos * 1000, { self.terminarLentitud() })
  }

  method terminarLentitud() {
    lentitudes = (lentitudes - 1).max(0)
    if (lentitudes == 0) game.say(self, "Salí del barro")
  }

  // lo llama la PistaDeVelocidad al ser pisada
  method acelerar(segundos) {
    aceleraciones = aceleraciones + 1
    game.say(self, "¡Voy más rápido!")
    game.schedule(segundos * 1000, { self.terminarAceleracion() })
  }

  method terminarAceleracion() {
    aceleraciones = (aceleraciones - 1).max(0)
    if (aceleraciones == 0) game.say(self, "Se me pasó la velocidad")
  }

  method agregarObjeto(objeto){
    inventario.add(objeto)
  }

// reinicia los atributos del personaje a los valores iniciales
method reiniciar() {
    vidaMaxima = 3
    vidaActual = 3
    danioActual = 25
    maldiciones = 0
    lentitudes = 0
    aceleraciones = 0
    ticksParaMoverse = 0
    baulDePremios.reiniciarPremios()
    inventario.clear()
    municiones.clear()
    municiones.add(balaComun)
  }

}


