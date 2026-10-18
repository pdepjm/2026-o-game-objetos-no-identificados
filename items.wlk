import personaje.*
class PocionDeVida{
    const cantidadDeRecuperacion = 1

    method alColisionarConPersonaje(){
        self.recuperarPersonaje()
    }

    //si agregamos mas personajes esto debe recuperar a PersonajeActual
    method recuperarPersonaje(){ 
        personaje.recuperarVidaActual(cantidadDeRecuperacion)
    }
}

//armadura añade mas vidas base
object armadura{
    const proteccion = 4

    method alColisionarConPersonaje(){
        personaje.aumentarVidaMaxima(proteccion)
    }
    
}

object armaMejorada{
    const danioDelArma = 50

    method alColisionarConPersonaje(){
        personaje.agregarObjeto("Arma Mejorada")
        self.mejorarDanioPersonaje()
    }

    method mejorarDanioPersonaje(){
        personaje.danioActual(danioDelArma)
    }

}

class ItemMunicion {
    var property position
    const bala
    const property image

    method esAtacable() = false

    method alColisionarConPersonaje() {
        personaje.adquirirMunicion(bala)
        game.removeVisual(self)
    }
}

object balaComun{
    method nombre() = "Común"
    method danioContra(enemigo, base) = enemigo.danioDeBalaComun(base)
}

object balaPlata{
  method nombre() = "Plata"
  method danioContra(enemigo, base) = enemigo.danioDeBalaPlata(base)
}

object balaCazaFantasmas{
  method nombre() = "Caza Fantasmas"
  method danioContra(enemigo, base) = enemigo.danioDeBalaCazaFantasmas(base)
}

