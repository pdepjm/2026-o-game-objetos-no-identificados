
object enemigoComun {
    // Cambiar posicion
  var property position = game.center()
  // Nombre de la imagen
  method image() = "enemigoComun.png"


  method perseguir() {
    const objetivo = personaje.position()

    if (position.x() < objetivo.x()) position = position.right(1)
    if (position.x() > objetivo.x()) position = position.left(1)
    if (position.y() < objetivo.y()) position = position.up(1)
    if (position.y() > objetivo.y()) position = position.down(1)
  }
}