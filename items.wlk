import personaje.*
class PocionDeVida{
    const cantidadDeRecuperacion = 1

    method alColisionarConPersonaje(){
        self.recuperarPersonaje()
    }

    //si agregamos mas personajes esto debe recuperar a PersonajeActual
    method recuperarPersonaje(){ 
        personaje.recuperarVidas(cantidadDeRecuperacion)
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
