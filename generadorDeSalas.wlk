
import wollok.game.*
import salas.*
import enemigos.*
import generadorDeMonstruos.*
import paredes.*
import obstaculos.*
import items.*
import puzzle.*

object generadorDeSalas {

  method salas() = [
    { self.sala1() },
    { self.sala2() },
    { self.sala3() },
    { self.sala4() },
    { self.sala5() },
    { self.sala6() },
    { self.sala7() },
    { self.sala8() },
    { self.sala9() }
  ]

  method cantidadDeSalas() = self.salas().size()

  method generarSala(numero) =
    self.salas().get(numero - 1).apply()

  method crearSala(tiempo, fondo, enemigos, paredes, items, obstaculos) =
    new Sala(tiempo = tiempo, fondo = fondo, enemigosIniciales = enemigos,
      paredesInternas = paredes,
      itemsIniciales = items,
      obstaculosIniciales = obstaculos,
      entrada = game.at(5, 1)
    )

  // NIVEL 1: tres enemigos comunes.
  method sala1() =
    self.crearSala(40, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([game.at(4, 5),game.at(8, 7),
        game.at(5, 12)]),
      paredes.horizontal(1, 6, 9) +
        paredes.horizontal(4, game.width() - 2, 14),
      [],
      [
        new RelojDeArena(segundos = 5, position = game.at(2, 18)),
        new RelojRoto(segundos = 4, position = game.at(9, 10)),
        new CharcoDeBarro(segundos = 5, position = game.at(6, 3)),
        new PistaDeVelocidad(segundos = 5, position = game.at(7, 10)),
        new CharcoDeBarro(segundos = 5, position = game.at(5, 16))
      ] +
        trampas.pinchosHorizontal(2, 4, 7) +
        trampas.pinchosVertical(9, 3, 5) +
        trampas.pinchosHorizontal(7, 9, 12) +
        trampas.pinchosHorizontal(3, 4, 17) +
        trampas.pinchosHorizontal(6, 7, 17)
    )

  // NIVEL 2: dos enemigos raros y un hechicero. Da la munición de plata.
  method sala2() =
    self.crearSala(60, "sala2.png",
      generadorDeMonstruos.rarosEn([game.at(3, 6), game.at(8, 6)]) +
        generadorDeMonstruos.hechicerosEn([game.at(5, 14)]),
      paredes.horizontal(1, 3, 10) + paredes.horizontal(7, 9, 10),
      [
        new ItemMunicion(bala = balaPlata, image = "itemPlata.png", position = game.at(5, 3))
      ],
      [
        new RelojDeArena(segundos = 6, position = game.at(9, 3)),
        new CharcoDeBarro(segundos = 5, position = game.at(2, 8)),
        new Maldicion(segundos = 6, position = game.at(5, 11)),
        new RelojRoto(segundos = 5, position = game.at(9, 15))
      ]
    )

  // NIVEL 3: dos comunes, un hombre lobo y un hechicero.
  method sala3() =
    self.crearSala(65, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([game.at(3, 5), game.at(8, 5)]) +
        generadorDeMonstruos.lobosEn([game.at(2, 13)]) +
        generadorDeMonstruos.hechicerosEn([game.at(8, 15)]),
      paredes.vertical(5, 5, 9) + paredes.horizontal(6, 9, 11),
      [],
      [
        new RelojDeArena(segundos = 6, position = game.at(2, 3)),
        new PistaDeVelocidad(segundos = 5, position = game.at(9, 8)),
        new CharcoDeBarro(segundos = 5, position = game.at(4, 12)),
        new Maldicion(segundos = 6, position = game.at(3, 16))
      ]
    )

  // NIVEL 4: dos comunes y dos hombres lobo.
  method sala4() =
    self.crearSala(50, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([game.at(3, 5), game.at(9, 4)]) +
        generadorDeMonstruos.lobosEn([
          game.at(8, 10),
          game.at(2, 16)
        ]),
      paredes.horizontal(1, 7, 8) + paredes.horizontal(4, 10, 13), [],
      [
        new RelojDeArena(segundos = 5, position = game.at(2, 3)),
        new CharcoDeBarro(segundos = 5, position = game.at(9, 9)),
        new RelojRoto(segundos = 4, position = game.at(2, 11)),
        new PistaDeVelocidad(segundos = 5, position = game.at(8, 16))
      ] +
        trampas.pinchosHorizontal(1, 2, 13)
    )

  // NIVEL 5: baúl de premios (sala intermedia).
  method sala5() =
    self.crearSala(30, "sala2.png", [], [], baulDePremios.premiosDeLaSala("Comun"), [])

  // NIVEL 6: dos comunes y dos fantasmas. Da la munición cazafantasmas.
  method sala6() =
    self.crearSala(55, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([
        game.at(3, 4),
        game.at(8, 11)
      ]) +
        generadorDeMonstruos.fantasmasEn([
          game.at(6, 5),
          game.at(4, 16)
        ]),
      paredes.horizontal(2, 10, 8) +
        paredes.horizontal(1, 9, 14),
      [
        new ItemMunicion(bala = balaCazaFantasmas, image = "itemCazaFantasmas.png", position = game.at(5, 3))
      ],
      [
        new RelojDeArena(segundos = 6, position = game.at(9, 3)),
        new CharcoDeBarro(segundos = 5, position = game.at(2, 6)),
        new RelojRoto(segundos = 5, position = game.at(5, 11)),
        new PistaDeVelocidad(segundos = 5, position = game.at(10, 16))
      ] + trampas.pinchosHorizontal(1, 1, 11))

  // NIVEL 7: dos comunes, un fantasma y un hombre lobo.
  method sala7() =
    self.crearSala(70, "sala2.png",
      generadorDeMonstruos.generarEnemigosEn([
        game.at(6, 4),
        game.at(2, 12)
      ]) +
        generadorDeMonstruos.fantasmasEn([
          game.at(5, 10)
        ]) +
        generadorDeMonstruos.lobosEn([
          game.at(5, 16)
        ]),
        paredes.vertical(3, 2, 9) +
        paredes.vertical(8, 10, 17) +
        paredes.horizontal(4, 6, 13),
      [],
      [
        new RelojDeArena(segundos = 8, position = game.at(1, 3)),
        new RelojRoto(segundos = 6, position = game.at(9, 8)),
        new Maldicion(segundos = 6, position = game.at(6, 7)),
        new CharcoDeBarro(segundos = 6, position = game.at(2, 16))
      ] + trampas.pinchosVertical(10, 13, 16))

  // NIVEL 8: un espectro y cuatro fantasmas.
  method sala8() =
    self.crearSala(75, "sala2.png",
      generadorDeMonstruos.fantasmasEn([
        game.at(2, 6),
        game.at(9, 6),
        game.at(3, 12),
        game.at(8, 12)
      ]) +
        generadorDeMonstruos.espectrosEn([game.at(5, 15)]),
      // las paredes no frenan a los fantasmas: los fantasmas las atraviesan, el personaje no
      paredes.horizontal(1, 8, 9) + paredes.vertical(5, 11, 13),
      [], [])

    // NIVEL 9: encuentro final contra el jefe + puzzle de laberinto de runas. El puzzle se resuelve pisando las runas en el orden correcto.
  method sala9() =
    self.crearSala(110, "sala15.png",                          
      generadorDeMonstruos.jefeEn(game.at(5, 9)),
      paredes.horizontal(3, 5, 5) +                           
        paredes.horizontal(6, 8, 12) +
        paredes.horizontal(2, 3, 15) +
        paredes.vertical(8, 2, 4) +                          
        paredes.vertical(3, 8, 11),
      puzzleFinal.crearRunas(),
      [puzzleFinal.pista()])
}
