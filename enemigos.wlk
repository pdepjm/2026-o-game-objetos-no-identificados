import wollok.game.*
import personaje.*
import tablero.*
import logicaJuego.*


class Enemigo {
  var property position
  var ultimaPosicion = position
  var vida = self.vidaInicial()
  method danioAlPersonaje() = 1

  method danioBase(base) = base
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

  method alColisionarConPersonaje() {
    personaje.perderVidaActual(self.danioAlPersonaje())
  }

  method recibirAtaque(bala) {
    self.recibirDanio(bala)

    if (self.estaMuerto()) {
      miJuego.eliminarEnemigo(self)
    }
  }


  method recibirDanio(bala){
    vida = vida - bala.danioContra(self, personaje.danioActual())
  }

  method esAtacable() = true

  method estaMuerto() = vida <= 0
}

object persecucion {
  method perseguir(enemigo, objetivo) {
    const destino = self.proximaPosicion(enemigo.position(), objetivo)
    enemigo.moverA(destino)
  }
  method proximaPosicion(posicionActual, objetivo) {
    var destino = posicionActual
    if (posicionActual.x() < objetivo.x()) destino = destino.right(1)
    else if (posicionActual.x() > objetivo.x()) destino = destino.left(1)

    if (posicionActual.y() < objetivo.y()) destino = destino.up(1)
    else if (posicionActual.y() > objetivo.y()) destino = destino.down(1)

    return destino
  }
}

class EnemigoComun inherits Enemigo{
  override method vidaInicial() = 100

  override method danioDeBalaPlata(base) = base / 2
  
  override method image() = "enemigoComun.png"

}

class EnemigoRaro inherits EnemigoComun{
  override method vidaInicial() = 150

  override method image() = "enemigoRaro.png"
}

class ClonMalvado inherits Enemigo{
  override method vidaInicial() = personaje.vidaActual() * personaje.danioActual()

  override method image() = "clonMalvado.png"

  override method danioAlPersonaje() = personaje.danioActual()

  override method danioDeBalaComun(base) = base / 2
}

class HombreLobo inherits Enemigo {
  override method vidaInicial() = 150

  override method image() = "hombreLobo.png"

  override method danioDeBalaComun(base) = base / 2

  override method danioDeBalaPlata(base) = base * 2
}

class Fantasma inherits Enemigo {
  override method vidaInicial() = 50

  override method image() = "fantasma.png"

  override method danioDeBalaComun(base) = 0

  override method danioDeBalaPlata(base) = 0

  override method danioDeBalaCazaFantasmas(base) = base
}


//JEFES

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
  
}