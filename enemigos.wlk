import wollok.game.*
import personaje.*
import tablero.*
import logicaJuego.*
import sonidos.*

class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = self.vidaInicial()
  
  method danioAlPersonaje() = 1
  
  method danioBase(base) = base 

  method danioReducido(base) = base / 2
  method danioAumentado(base) = base * 2
  
  method danioDeBalaComun(base) = self.danioBase(base)
  
  method danioDeBalaPlata(base) = self.danioBase(base)
  
  method danioDeBalaCazaFantasmas(base) = 0
  
  method vida() = vida
  
  method image()
  
  method vidaInicial()
  
  method retroceder() {
    position = ultimaPosicion
  }
  
  method guardarPosicion() {
    ultimaPosicion = position
  }
  
  method perseguir() {
    persecucion.perseguir(self, personaje.position())
  }
  
  method moverA(destino) {
    if (tablero.esTransitable(destino)) {
      self.guardarPosicion()
      position = destino
    }
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
  method perseguir(enemigo, objetivo) {
    enemigo.moverA(self.proximaPosicion(enemigo.position(), objetivo))
  }
  
  method proximaPosicion(actual, objetivo) = game.at(
    actual.x() + (objetivo.x() - actual.x()).min(1).max(-1),
    actual.y() + (objetivo.y() - actual.y()).min(1).max(-1)
  )
}

class EnemigoComun inherits Enemigo {
  override method vidaInicial() = 100
  
  override method danioDeBalaPlata(base) = self.danioReducido(base)
  
  override method image() = "enemigoComun.png"
}

class EnemigoRaro inherits EnemigoComun {
  override method vidaInicial() = 150
  
  override method image() = "enemigoRaro.png"
}

class ClonMalvado inherits Enemigo {
  override method vidaInicial() = personaje.vidaActual() * personaje.danioActual()
  
  override method image() = "clonMalvado.png"
  
  override method danioAlPersonaje() = personaje.danioActual()
  
  override method danioDeBalaComun(base) = self.danioReducido(base)
}

class HombreLobo inherits Enemigo {
  override method vidaInicial() = 150
  
  override method image() = "hombreLobo.png"
  
  override method danioDeBalaComun(base) = self.danioReducido(base)
  override method danioDeBalaPlata(base) = self.danioAumentado(base)
}

class Fantasma inherits Enemigo {
  override method vidaInicial() = 50
  
  override method image() = "fantasma.png"
  
  override method danioDeBalaComun(base) = 0
  
  override method danioDeBalaPlata(base) = 0
  
  override method danioDeBalaCazaFantasmas(base) = base
} //JEFES

class HombreLoboJefe inherits HombreLobo {
  override method vidaInicial() = 250
  
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