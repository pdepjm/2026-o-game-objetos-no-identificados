
object personaje {
  // Cambiar posicion
  var property position = game.center()
  var ultimaPosicion = position
  // Nombre de la imagen
  method image() = "personaje.png"
  var vidas = 3


  method perderVidas {
    vidas = vidas - 1
    game.say(self, "Ahora, mi cantidad de vidas es: " + vidas)
  }

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method reaccionarAColision(elemento) {
    if (elemento is EnemigoComun) {
    self.perderVidas()
    } else {
    self.retroceder()
    }
  }
}


// assets personaje.png
