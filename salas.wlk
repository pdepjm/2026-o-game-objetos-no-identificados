import wollok.game.*
import enemigos.*
import personaje.*
import puerta.*
import logicaJuego.*
import temporizador.*
import obstaculos.*
import paredes.*
import items.*
import tablero.*

class Sala {
  const property tiempo
  const property fondo
  const property enemigosIniciales
  const property paredesInternas
  const property itemsIniciales
  const property obstaculosIniciales
  const property entrada
  var enemigosVivos = []
  var puerta = null
  var itemsDeLaSala = []
  
  method inicializarse() {
    temporizador.iniciar(self.tiempo())
    temporizador.iniciarPreparacion(5)
    
    game.boardGround(self.fondo())
    tablero.construir(self.paredesInternas())
    
    enemigosVivos = self.enemigosIniciales()
    
<<<<<<< HEAD
 enemigosVivos.forEach({ enemigo =>
  game.addVisual(enemigo)
  game.onCollideDo(
    enemigo,
    { elemento => enemigo.reaccionarAColision(elemento) }
  )
})
=======
    enemigosVivos.forEach(
      { enemigo =>
        game.addVisual(enemigo)
        game.onCollideDo(
          enemigo,
          { elemento => enemigo.reaccionarAColision(elemento) }
        )
      }
    )
>>>>>>> dff768b5d64d0d59583dec875ecd5360984ea8eb
    
    itemsDeLaSala = self.itemsIniciales()
    itemsDeLaSala.forEach({ item => game.addVisual(item) })
    
    self.obstaculosIniciales().forEach(
      { obstaculo => game.addVisual(obstaculo) }
    )
    
    puerta = new Puerta()
    game.addVisual(puerta)
    
    if (self.estaLimpia()) puerta.desbloquear()
    
    game.addVisual(personaje)
    personaje.position(self.entrada())
    
    if (personaje.vidaActual() == 1) self.aparecerPocionDeVida()
  }
  
  method enemigosVivos() = enemigosVivos
  
  method puerta() = puerta
  
  method estaLimpia() = enemigosVivos.isEmpty()
  
  method eliminarEnemigo(enemigo) {
    game.removeVisual(enemigo)
    
    enemigosVivos.remove(enemigo)
    
    if (self.estaLimpia()) puerta.desbloquear()
  }
  
  method itemsAgarrados() = itemsDeLaSala.all({ item => !game.hasVisual(item) })
  
  method puedeSalir() = self.estaLimpia() && self.itemsAgarrados()

  method posicionesParaPocion() = [
    game.at(2, 2),
    game.at(10, 2),
    game.at(2, 12),
    game.at(8, 16),
    game.at(10, 17)
  ]
  
  method aparecerPocionDeVida() {
    const libres = self.posicionesParaPocion().filter(
      { posicion => game.getObjectsIn(posicion).isEmpty() }
    )
    
    if (!libres.isEmpty()) game.addVisual(
        new PocionDeVida(position = libres.anyOne())
      )
  }
}