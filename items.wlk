import personaje.*
import wollok.game.*

//los objetos como armas y armaduras tienen rarezas: Comun, Raro, Epico
class PocionDeVida{
    var property position = game.at(5, 10)
    const cantidadDeRecuperacion = 1

    method image() = "pocionDeVida.png"
    method esAtacable() = false

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

    method esAtacable() = false

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

    method esAtacable() = false

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
    // al limpiar una sala especial, la siguiente otorgara un objeto de la lista
    // al crear una sala se usara override method crearItems() = [baulDePremios.otorgarPremio(rareza)]
    const premios = [
        new Armadura(rareza = "Comun", proteccion = 4), 
        new Arma(rareza = "Comun", danioDelArma = 50)
    ]

    // por ahora los objetos se otorgaran una vez por cada rareza, asi que no hay riesgo a que la lista este vacia cuando quiera otorgar un objeto
    method otorgarPremio(rareza){
    const premioDeLaSala = premios.filter({ premio => premio.rareza() == rareza }).anyOne()
    premios.remove(premioDeLaSala)
    return premioDeLaSala
    }
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
  method nombre() = "de Plata"
  method danioContra(enemigo, base) = enemigo.danioDeBalaPlata(base)
}

object balaCazaFantasmas{
  method nombre() = "Caza Fantasmas"
  method danioContra(enemigo, base) = enemigo.danioDeBalaCazaFantasmas(base)
}

