
object personaje {
  // Cambiar posicion
  var property position = game.center()
  // Nombre de la imagen
  method image() = "personaje.png"
  var vidas = 3


  method perderVidas {
    vidas - 1
    game.say(self, "Ahora, mi cantidad de vidas es: " + vidas)
  }

method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }
}

}


// assets personaje.png
