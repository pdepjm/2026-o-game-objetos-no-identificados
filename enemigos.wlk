import wollok.game.*
import personaje.*
import tablero.*
import logicaJuego.*
import sonidos.*

class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = self.vidaInicial()
  const velocidadBase = 700
  var tiempoAcumulado = 0
  
  method danioAlPersonaje() = 1
  
  method danioBase(base) = base 

  method danioReducido(base) = base / 2
  method danioAumentado(base) = base * 2
  
  method danioDeBalaComun(base) = self.danioBase(base)
  
  method danioDeBalaPlata(base) = self.danioBase(base)
  
  method danioDeBalaCazaFantasmas(base) = 0
  
  method vida() = vida
  method velocidad() = velocidadBase

  method image()
  
  method vidaInicial()
  
  method comportamiento()

  method retroceder() {
    position = ultimaPosicion
  }
  
  method guardarPosicion() {
    ultimaPosicion = position
  }
  
  method pasarTiempo(milisegundos) {
    tiempoAcumulado += milisegundos
    if (tiempoAcumulado >= self.velocidad()) {
      tiempoAcumulado -= self.velocidad()
      self.moverse()
    }
  }
  
  method moverse() {
    self.comportamiento().mover(self)
  }
  
  

  
  method moverA(destino) {
    if (tablero.esTransitable(destino)) self.desplazarA(destino)
  }

  method flotarA(destino) {
    if (tablero.dentroDeLimites(destino)) self.desplazarA(destino)
  }
  method desplazarA(destino) {
    self.guardarPosicion()
    position = destino
  }

  method reaccionarAColision(elemento) {
    self.retroceder()
  }
  
  method alColisionarConPersonaje(unPersonaje) {
    unPersonaje.perderVidaActual(self.danioAlPersonaje())
  }
  
  method alColisionarConPersonaje() {
    self.alColisionarConPersonaje(personaje)
  }
  
  method recibirAtaque(bala) {
    self.recibirDanio(bala)
    
    if (self.estaMuerto()) miJuego.eliminarEnemigo(self)
    else sonidos.danioEnemigo()
  }
  
  method recibirDanio(bala) {
    vida -= bala.danioContra(self, personaje.danioActual())
  }
  
  method esAtacable() = true
  
  method estaMuerto() = vida <= 0
}

object persecucion {
  method mover(enemigo) {
    enemigo.moverA(self.proximaPosicion(enemigo.position(), personaje.position()))
  }
  
  method proximaPosicion(actual, objetivo) = game.at(
    actual.x() + (objetivo.x() - actual.x()).min(1).max(-1),
    actual.y() + (objetivo.y() - actual.y()).min(1).max(-1)
  )
}

object persecucionEterea {
  method mover(enemigo) {
    enemigo.flotarA(persecucion.proximaPosicion(enemigo.position(), personaje.position()))
  }
}

class ConDescanso {
  const comportamientoBase
  var descansando = false
  
  method mover(enemigo) {
    if (!descansando) comportamientoBase.mover(enemigo)
    descansando = !descansando
  }
}

// persigue y, si despues del paso el personaje esta cerca, da un segundo paso en el mismo turno
object persecucionConArremetida {
  method mover(enemigo) {
    persecucion.mover(enemigo)
    if (self.personajeCerca(enemigo)) persecucion.mover(enemigo)
  }
  
  method personajeCerca(enemigo) = enemigo.position().distance(personaje.position()) <= 3
}

class EnemigoComun inherits Enemigo {
  override method vidaInicial() = 100

  override method comportamiento() = persecucion

  
  override method danioDeBalaPlata(base) = self.danioReducido(base)
  
  override method image() = "enemigoComun.png"
}

class EnemigoRaro inherits EnemigoComun {
  override method vidaInicial() = 150

  const comportamiento = new ConDescanso(comportamientoBase = persecucion)

  override method comportamiento() = comportamiento
  override method image() = "enemigoRaro.png"
}

class ClonMalvado inherits Enemigo {
  override method vidaInicial() = personaje.vidaActual() * personaje.danioActual()
  override method comportamiento() = persecucion

  override method image() = "clonMalvado.png"
  
  override method danioAlPersonaje() = super() + 1
  
  override method danioDeBalaComun(base) = self.danioReducido(base)
}

class HombreLobo inherits Enemigo {
  override method vidaInicial() = 150
  
  override method comportamiento() = persecucion

  override method image() = "hombreLobo.png"
  
  override method danioDeBalaComun(base) = self.danioReducido(base)
  override method danioDeBalaPlata(base) = self.danioAumentado(base)
}

class Fantasma inherits Enemigo {
  override method vidaInicial() = 50
  
  override method comportamiento() = persecucionEterea

  override method image() = "fantasma.png"
  
  override method danioDeBalaComun(base) = 0
  
  override method danioDeBalaPlata(base) = 0
  
  override method danioDeBalaCazaFantasmas(base) = base

} //JEFES

class HombreLoboJefe inherits HombreLobo {
  override method vidaInicial() = 250
  
  override method comportamiento() = persecucionConArremetida


  override method danioAlPersonaje() {
    if (vida <= 125) {
      return 3
    } else {
      return 2
    }
  }
  
  override method image() = "hombreLoboJefe.png"
}

class Espectro inherits Fantasma {
  override method vidaInicial() = 150
  
  override method danioAlPersonaje() = 3
  
  override method image() = "espectro.png"
  override method danioDeBalaCazaFantasmas(base) = super(base)*2
}