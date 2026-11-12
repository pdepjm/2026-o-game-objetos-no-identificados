import wollok.game.*
import personaje.*
import sonidos.*


class Item {
    var property position = game.at(5, 10)

    method image()

    method esAtacable() = false

    method alColisionarConPersonaje(unPersonaje) {
        sonidos.sonidoObjeto()
        self.aplicarEfecto(unPersonaje)
        game.removeVisual(self)
    }

    method aplicarEfecto(unPersonaje)
}

//los objetos como armas y armaduras tienen rarezas: Comun, Raro, Epico
class PocionDeVida inherits Item {
    const cantidadDeRecuperacion = 1

    override method image() = "pocionDeVida.png"

    override method aplicarEfecto(unPersonaje) {
        unPersonaje.recuperarVidaActual(cantidadDeRecuperacion)
    }
}

//armadura añade mas vidas base
class Armadura inherits Item{
    const property rareza
    const proteccion
    override method image() = "armadura.png"

    override method aplicarEfecto(unPersonaje) {
        unPersonaje.agregarObjeto("Armadura " + rareza)
        unPersonaje.aumentarVidaMaxima(proteccion)
    }

}

class Arma inherits Item{
    const property rareza
    const danioDelArma
    const distanciaDelArma
    override method image() = "arma.png"

    override method aplicarEfecto(unPersonaje) {
        unPersonaje.agregarObjeto("Arma " + rareza)
        unPersonaje.danioActual(danioDelArma)
        unPersonaje.distanciaAtaque(distanciaDelArma)
    }
}

object baulDePremios{
    var premios = self.premiosIniciales()
    var entregado = false

    method premiosIniciales() = [
        new Armadura(rareza = "Comun", proteccion = 4), 
        new Arma(rareza = "Comun", danioDelArma = 50, distanciaDelArma = 4),
        new Arma(rareza = "Comun", danioDelArma = 35, distanciaDelArma = 16)
    ]

    // por ahora los objetos se otorgaran una vez por cada rareza, asi que no hay riesgo a que la lista este vacia cuando quiera otorgar un objeto
    method otorgarPremio(rareza){
    const premioDeLaSala = premios.filter({ premio => premio.rareza() == rareza }).anyOne()
    premios.remove(premioDeLaSala)
    return premioDeLaSala
    }

    // el baul entrega un solo premio por partida, aunque se reintente la sala
    method premiosDeLaSala(rareza) {
        if (entregado) return []
        entregado = true
        return [self.otorgarPremio(rareza)]
    }

    method reiniciarPremios() {
        premios = self.premiosIniciales()
        entregado = false
    }
}
class ItemMunicion inherits Item{
    const bala
    const property image

    override method aplicarEfecto(unPersonaje) {
        unPersonaje.adquirirMunicion(bala)
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

