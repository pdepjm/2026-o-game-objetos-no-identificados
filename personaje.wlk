import enemigos.*
import logicaJuego.*
object personaje {
  // Cambiar posicion
  var property position = game.center()
  var ultimaPosicion = position
  // Nombre de la imagen
  method image() = "personajeCaballero.png"
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
    if (elemento.className() == EnemigoComun) {
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
    }
  }

  method moverArriba(){
    if ( position.y() < game.height() - 1) position = position.up(1)
    
  }

  method moverAbajo(){
     if (position.y() > 0) position = position.down(1)
  }

  method moverIzquierda(){
     if (position.x() > 0) position = position.left(1)
  }

  method moverDerecha(){
     if (position.x() < game.width() - 1) position = position.right(1)
  }

}