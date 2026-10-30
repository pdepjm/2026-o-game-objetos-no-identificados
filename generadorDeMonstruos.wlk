import wollok.game.*
import enemigos.*

object generadorDeMonstruos {
  method generarEnemigosEn(posiciones) =
    posiciones.map({ posicion =>
      new EnemigoComun(position = posicion)
    })

  method lobosEn(posiciones) =
    posiciones.map({ posicion =>
      new HombreLobo(position = posicion)
    })

  method fantasmasEn(posiciones) =
    posiciones.map({ posicion =>
      new Fantasma(position = posicion)
    })

  method clonesEn(posiciones) =
    posiciones.map({ posicion =>
      new ClonMalvado(position = posicion)
    })

  method jefeEn(posicion) =
    [new HombreLoboJefe(position = posicion)]
}