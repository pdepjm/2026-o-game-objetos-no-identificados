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
    const dañoDelArma = 50

    method alColisionarConPersonaje(){
        personaje.agregarObjeto("Arma Mejorada")
        self.mejorarDañoPersonaje()
    }

    method mejorarDañoPersonaje(){
        personaje.dañoActual(dañoDelArma)
    }

}
