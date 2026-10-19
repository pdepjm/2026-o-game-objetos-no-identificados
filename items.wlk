import personaje.*

//los objetos como armas y armaduras tienen rarezas: Comun, Raro, Epico
class PocionDeVida{
    const cantidadDeRecuperacion = 1

    method alColisionarConPersonaje(){
        self.recuperarPersonaje()
        game.removeVisual(self)
    }

    //si agregamos mas personajes esto debe recuperar a PersonajeActual
    method recuperarPersonaje(){ 
        personaje.recuperarVidaActual(cantidadDeRecuperacion)
    }
}

//armadura añade mas vidas base
class Armadura{
    var property position = game.at(5, 10)
    const property rareza
    const proteccion
    const property image = "armadura.png"

    
    

    method alColisionarConPersonaje(){
        personaje.agregarObjeto("Armadura " + rareza)
        personaje.aumentarVidaMaxima(proteccion)
        game.removeVisual(self)
    }

}

class Arma{
    var property position = game.at(5, 10)
    const property rareza
    const danioDelArma
    const property image = "arma.png"

    method alColisionarConPersonaje(){
        personaje.agregarObjeto("Arma " + rareza)
        self.mejorarDanioPersonaje()
        game.removeVisual(self)
    }

    method mejorarDanioPersonaje(){
        personaje.danioActual(danioDelArma)
    }

}

object baulDePremios{
    // al limpiar una sala otorgara un objeto de la lista
    // al crear una sala se usara override method crearItems() = [baulDePremios.otorgarPremio()]
    const premiosComunes = [new Armadura(rareza = "Comun", proteccion = 4), new Arma(rareza = "Comun", danioDelArma = 50)]
    const premiosRaros = []
    const premiosEpicos = []

    method otorgarPremio() = premiosComunes.anyOne()
    method otorgarPremioRaro() = premiosRaros.anyOne()
    method otorgarPremioEpico() = premiosEpicos.anyOne()
}

class ItemMunicion{
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

