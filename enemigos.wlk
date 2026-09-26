import personaje.*
class EnemigoComun {
  var property position
  var ultimaPosicion = position
  var vida = 100

  // Nombre de la imagen
  method image() = "enemigoComun.png"

  method retroceder() {
    position = ultimaPosicion
  }

  method guardarPosicion() {
    ultimaPosicion = position
  }

  method perseguir() {
    self.guardarPosicion()

    const objetivo = personaje.position()

    if (position.x() < objetivo.x()) position = position.right(1)
    if (position.x() > objetivo.x()) position = position.left(1)
    if (position.y() < objetivo.y()) position = position.up(1)
    if (position.y() > objetivo.y()) position = position.down(1)
  }

  method reaccionarAColision(elemento) {
    self.retroceder()
  }

  method recibirDanio(){
    vida = vida-25
  }

  method esAtacable() = true
}
