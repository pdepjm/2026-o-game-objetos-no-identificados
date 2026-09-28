import enemigos.*
import logicaJuego.*
object personaje {
  // Cambiar posicion
  var property position = game.center()
  var ultimaPosicion = position
  // Nombre de la imagen
  method image() = "personaje.png"
  var vidas = 3


  method perderVidas() {
    vidas = (vidas - 1).max(0)
    game.say(self, "Ahora, mi cantidad de vidas es: " + vidas)
    if(vidas == 0){
      miJuego.terminarJuego()
    }
  }

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method reaccionarAColision(elemento) {
    if (elemento.className() == "EnemigoComun") {
      self.perderVidas()
    } 
    else 
    {
      self.retroceder()
    }
  }

  method atacarEn(posicion) {
    const elementos = game.getObjectsIn(posicion)
    const enemigo = elementos.findOrElse({ elemento => elemento.esAtacable()}, {null})
    if (enemigo != null) {
      enemigo.recibirDanio()
      if(enemigo.estaMuerto()){
        miJuego.eliminarEnemigo(enemigo)
      }
    }
  }

  method mover(nuevaPosicion) {
    self.guardarPosicion()
    // Limita el movimiento dentro de la grilla visible
    if (nuevaPosicion.x().between(1, game.width() - 2) && 
        nuevaPosicion.y().between(1, game.height() - 2)) {
      position = nuevaPosicion
    }
  }

  method recibirDano(cantidad) {
    vidas = (vidas - cantidad).max(0)
    game.say(self, "¡Ouch! Vida: " + vidas)
    if (vidas == 0) {
      game.say(self, "¡Has sido derrotado!")
      miJuego.terminarJuego()
    }
  }

}


