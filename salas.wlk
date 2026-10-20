import wollok.game.*
import enemigos.*
import personaje.*
import puerta.*
import logicaJuego.*
import generadorDeMonstruos.*
import temporizador.*
import obstaculos.*
import paredes.*
import items.*
import tablero.*


class Sala{
  var enemigosVivos = []
  // se crea en inicializarse(), asi cada vez que se entra la puerta arranca bloqueada
  var puerta = null

  method tiempoLimite()   // cada sala define sus segundos

  // cada sala define estos métodos
  method fondo()
  method crearEnemigos()
  method puntoDeEntrada()
  method salaSiguiente()

  // cada sala define sus paredes internas (por defecto, ninguna)
  method paredes() = []

  // cada sala define sus items del piso (por defecto, ninguno)
  method crearItems() = []

  // cada sala define sus obstaculos del piso (por defecto, ninguno)
  method crearObstaculos() = []
  
  // lugares donde puede aparecer la pocion de vida; una sala puede sobrescribirlo con override
  method posicionesParaPocion() = [
    game.at(2, 2),
    game.at(10, 2),
    game.at(2, 12),
    game.at(8, 16),
    game.at(10, 17)
  ]

  method inicializarse() {
    temporizador.iniciar(self.tiempoLimite()) // cada sala define su tiempo limite
    game.boardGround(self.fondo())

// las paredes van primero para que queden debajo de enemigos y personaje
    paredes.construir(self.paredes())

    enemigosVivos = self.crearEnemigos()
    enemigosVivos.forEach { enemigo =>
      game.addVisual(enemigo)
      game.onCollideDo(enemigo, { elemento => enemigo.reaccionarAColision(elemento) })
    }

    puerta = new Puerta(destino = self.salaSiguiente())
    game.addVisual(puerta)

    if (self.estaLimpia()) puerta.desbloquear()

    self.crearItems().forEach { item => game.addVisual(item) }
    self.crearObstaculos().forEach { obstaculo => game.addVisual(obstaculo) }

    game.addVisual(personaje)
    personaje.position(self.puntoDeEntrada())
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

method aparecerPocionDeVida() {
    const libres = self.posicionesParaPocion().filter({ posicion => game.getObjectsIn(posicion).isEmpty() })
    if (!libres.isEmpty()) game.addVisual(new PocionDeVida(position = libres.anyOne()))
  }

  

}

object sala1 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 40  // 40 segundos para limpiar la sala

  override method paredes() =
    paredes.horizontal(1, 6, 9) +
    paredes.horizontal(4, game.width() - 2, 14)

  override method crearEnemigos() = 
    generadorDeMonstruos.generarEnemigosEn([
      game.at(4, 5),
      game.at(8, 7),
      game.at(5, 12)
    ])

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 5, position = game.at(2, 18)),
    new RelojRoto(segundos = 4, position = game.at(9, 10)),
    new CharcoDeBarro(segundos = 5, position = game.at(6, 3)),
    new PistaDeVelocidad(segundos = 5, position = game.at(7, 10)),
    new CharcoDeBarro(segundos = 5, position = game.at(5, 16))
    
  ]+
    trampas.pinchosHorizontal(2, 4, 7) +
    trampas.pinchosVertical(9, 3, 5) +
    trampas.pinchosHorizontal(7, 9, 12) +
    trampas.pinchosHorizontal(3, 4, 17) +
    trampas.pinchosHorizontal(6, 7, 17)

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala2
}

object sala2 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 50 // segundos

override method paredes() =
    paredes.vertical(6, 2, 11) +
    paredes.horizontal(1, 5, 14)

  override method crearEnemigos() = 
    generadorDeMonstruos.generarEnemigosEn([
      game.at(3, 5),
      game.at(9, 5),
      game.at(5, 9),
      game.at(8, 13),
      game.at(2, 15)
    ])

   override method crearObstaculos() = [
    new RelojDeArena(segundos = 8, position = game.at(9, 9)),
    new RelojRoto(segundos = 6, position = game.at(3, 12)),
    new Maldicion(segundos = 6, position = game.at(8, 3)),
    new CharcoDeBarro(segundos = 6, position = game.at(2, 8)),
    new PistaDeVelocidad(segundos = 5, position = game.at(10, 10)),
    new Maldicion(segundos = 6, position = game.at(5, 16))
  ] +
    trampas.pinchosVertical(4, 6, 8) +
    trampas.pinchosHorizontal(7, 9, 7) +
    trampas.pinchosHorizontal(7, 8, 11) +
    trampas.pinchosVertical(4, 16, 18) +
    trampas.pinchosVertical(6, 16, 18)

  override method puntoDeEntrada() = game.at(5, 1)

  
  override method salaSiguiente() = sala3
}



// SALA 3: 2 comunes, 2 hombres lobo
object sala3 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 50

  override method paredes() =
    paredes.horizontal(1, 7, 8) +
    paredes.horizontal(4, 10, 13)

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(3, 5)),
    new EnemigoComun(position = game.at(9, 4)),
    new HombreLobo(position = game.at(8, 10)),
    new HombreLobo(position = game.at(2, 16))
  ]

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 5, position = game.at(2, 3)),
    new CharcoDeBarro(segundos = 5, position = game.at(9, 9)),
    new RelojRoto(segundos = 4, position = game.at(2, 11)),
    new PistaDeVelocidad(segundos = 5, position = game.at(8, 16))
  ] +
    trampas.pinchosHorizontal(1, 2, 13)

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala4
}


// SALA 4: 3 hombres lobo
object sala4 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 40

  override method crearEnemigos() = [
    new HombreLobo(position = game.at(3, 7)),
    new HombreLobo(position = game.at(8, 9)),
    new HombreLobo(position = game.at(5, 14))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala5
}

// SALA 5: sala abierta con 1 HombreLoboJefe
object sala5 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 45

  override method crearEnemigos() = [
    new HombreLoboJefe(position = game.at(5, 12))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala6
}

// SALA 6: sala con bala de plata. El item esta en el unico hueco de la pared, no se puede esquivar.
object sala6 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 30  // sin enemigos el reloj no corre

  override method paredes() =
    paredes.horizontal(1, 4, 10) +
    paredes.horizontal(6, 10, 10)

  override method crearEnemigos() = []

  override method crearItems() = [
    new ItemMunicion(bala = balaPlata, image = "itemPlata.png", position = game.at(5, 10))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala7
}


// SALA 7: 2 comunes, 2 hombres lobo
object sala7 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 50

  override method paredes() =
    paredes.vertical(4, 2, 10) +
    paredes.vertical(7, 9, 17)

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(2, 6)),
    new EnemigoComun(position = game.at(9, 5)),
    new HombreLobo(position = game.at(6, 13)),
    new HombreLobo(position = game.at(2, 15))
  ]

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 6, position = game.at(10, 3)),
    new RelojRoto(segundos = 5, position = game.at(2, 9)),
    new Maldicion(segundos = 6, position = game.at(9, 12)),
    new CharcoDeBarro(segundos = 5, position = game.at(5, 6))
  ] +
    trampas.pinchosVertical(10, 13, 16) +
    trampas.pinchosHorizontal(1, 2, 12)

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala8
}

// SALA 8: sala con objeto comun (sin paredes ni obstaculos)
object sala8 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 30  // sin enemigos el reloj no corre

  override method crearEnemigos() = []

  override method crearItems() = [baulDePremios.otorgarPremio("Comun")]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala9
}

// SALA 9: 3 comunes, 2 hombres lobo
object sala9 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 60

  override method paredes() =
    paredes.horizontal(1, 4, 7) +
    paredes.horizontal(7, 10, 12) +
    paredes.vertical(8, 14, 17)

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(3, 4)),
    new EnemigoComun(position = game.at(8, 4)),
    new EnemigoComun(position = game.at(6, 10)),
    new HombreLobo(position = game.at(2, 10)),
    new HombreLobo(position = game.at(9, 15))
  ]

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 6, position = game.at(10, 2)),
    new RelojRoto(segundos = 5, position = game.at(9, 9)),
    new Maldicion(segundos = 6, position = game.at(2, 14)),
    new CharcoDeBarro(segundos = 5, position = game.at(5, 15))
  ] 
    

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala10
}

// SALA 10: sala abierta con 2 comunes y 1 clon malvado
object sala10 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 45

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(3, 8)),
    new EnemigoComun(position = game.at(8, 8)),
    new ClonMalvado(position = game.at(5, 14))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala11
}

// SALA 11: sala que otorga la bala antifantasmas
object sala11 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 30  // sin enemigos el reloj no corre

  override method crearEnemigos() = []

  override method crearItems() = [
    new ItemMunicion(bala = balaCazaFantasmas, image = "itemCazaFantasmas.png", position = game.at(5, 10))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala12
}

// SALA 12: 4 fantasmas (solo mueren con balas cazafantasmas, tecla B para cambiar de bala)
object sala12 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 40

  override method crearEnemigos() =
    [game.at(3, 6), game.at(8, 7), game.at(2, 13), game.at(9, 14)].map({ posicion =>
      new Fantasma(position = posicion)
    })

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala13
}

// SALA 13: 2 comunes, 2 fantasmas
object sala13 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 55

  override method paredes() =
    paredes.horizontal(2, 10, 8) +
    paredes.horizontal(1, 9, 14)

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(3, 4)),
    new EnemigoComun(position = game.at(8, 11)),
    new Fantasma(position = game.at(6, 5)),
    new Fantasma(position = game.at(4, 16))
  ]

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 6, position = game.at(9, 3)),
    new CharcoDeBarro(segundos = 5, position = game.at(2, 6)),
    new RelojRoto(segundos = 5, position = game.at(5, 11)),
    new PistaDeVelocidad(segundos = 5, position = game.at(10, 16))
  ] +
    trampas.pinchosHorizontal(1, 1, 11)

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala14
}

// SALA 14: 2 comunes, 1 fantasma y 1 hombre lobo
object sala14 inherits Sala{
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 70

  override method paredes() =
    paredes.vertical(3, 2, 9) +
    paredes.vertical(8, 10, 17) +
    paredes.horizontal(4, 6, 13)

  override method crearEnemigos() = [
    new EnemigoComun(position = game.at(6, 4)),
    new EnemigoComun(position = game.at(2, 12)),
    new Fantasma(position = game.at(5, 10)),
    new HombreLobo(position = game.at(5, 16))
  ]

  override method crearObstaculos() = [
    new RelojDeArena(segundos = 8, position = game.at(1, 3)),
    new RelojRoto(segundos = 6, position = game.at(9, 8)),
    new Maldicion(segundos = 6, position = game.at(6, 7)),
    new CharcoDeBarro(segundos = 6, position = game.at(2, 16))
  ] +
    trampas.pinchosVertical(10, 13, 16)

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala15
}

// SALA 15: sala final, al cruzar la puerta se gana el juego
object sala15 inherits Sala{
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 30

  override method crearEnemigos() = []

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = finDelJuego
}
