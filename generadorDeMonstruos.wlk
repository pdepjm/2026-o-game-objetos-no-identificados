import wollok.game.*
import enemigos.*

object generadorDeMonstruos {
  method generarEnemigosEn(posiciones) =
    posiciones.map({ posicion =>
      new EnemigoComun(position = posicion)
    })
}