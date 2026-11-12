
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
    { self.sala9() },
    { self.sala10() },
    { self.sala11() },
    { self.sala12() },
    { self.sala13() },
    { self.sala14() },
    { self.sala15() },
    { self.sala16() },
    { self.sala17() },
    { self.sala18() }
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

  // NIVEL 2: cinco enemigos comunes.
  method sala2() =
    self.crearSala(50, "sala2.png",
      generadorDeMonstruos.generarEnemigosEn([
        game.at(3, 5),
        game.at(9, 5),
        game.at(5, 9),
        game.at(8, 13),
        game.at(2, 15)
      ]),
      paredes.vertical(6, 2, 11) +
        paredes.horizontal(1, 5, 14),
      [],
      [
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
    )

  // NIVEL 3: dos comunes y dos hombres lobo.
  method sala3() =
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

  // NIVEL 4: 2 hombres lobo.
  method sala4() =
    self.crearSala(40, "sala2.png", generadorDeMonstruos.lobosEn([
        game.at(8, 9),
        game.at(5, 14)
      ]), [], [], [])

  // NIVEL 5: un HombreLoboJefe
  method sala5() =
    self.crearSala(45, "sala1.png", generadorDeMonstruos.jefeEn(game.at(5, 12)), [], [], [])

  // NIVEL 6: recompensa de munición de plata.
  method sala6() =
    self.crearSala(30, "sala2.png", [], [],
      [
        new ItemMunicion(
          bala = balaPlata,
          image = "itemPlata.png",
          position = game.at(5, 10)
        )
      ], [])

  // NIVEL 7: dos comunes y dos hombres lobo.
  method sala7() =
    self.crearSala(55, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([game.at(2, 6)]) +
        generadorDeMonstruos.rarosEn([game.at(9, 5)]) +
        generadorDeMonstruos.lobosEn([
          game.at(6, 13),
          game.at(2, 15)
        ]),
      paredes.vertical(4, 2, 10) + paredes.vertical(7, 9, 17), [],
      [
        new RelojDeArena(segundos = 6, position = game.at(10, 3)),
        new RelojRoto(segundos = 5, position = game.at(2, 9)),
        new Maldicion(segundos = 6, position = game.at(9, 12)),
        new CharcoDeBarro(segundos = 5, position = game.at(5, 6))
      ] +
        trampas.pinchosVertical(10, 13, 16) +
        trampas.pinchosHorizontal(1, 2, 12)
    )

  // NIVEL 8: dos enemigos raros y un hechicero que los potencia.
  method sala8() =
    self.crearSala(60, "sala2.png",
      generadorDeMonstruos.rarosEn([game.at(3, 6), game.at(8, 6)]) +
        generadorDeMonstruos.hechicerosEn([game.at(5, 14)]),
      paredes.horizontal(1, 3, 10) + paredes.horizontal(7, 9, 10),
      [],
      [
        new RelojDeArena(segundos = 6, position = game.at(9, 3)),
        new CharcoDeBarro(segundos = 5, position = game.at(2, 8)),
        new Maldicion(segundos = 6, position = game.at(5, 11)),
        new RelojRoto(segundos = 5, position = game.at(9, 15))
      ]
    )

  // NIVEL 9: baúl de premios.
  method sala9() =
    self.crearSala(30, "sala2.png", [], [], [baulDePremios.otorgarPremio("Comun")], [])

    // NIVEL 10: dos comunes, un raro y dos hombres lobo.
  method sala10() =
    self.crearSala(65, "sala1.png",
      generadorDeMonstruos.generarEnemigosEn([
        game.at(3, 4),
        game.at(8, 4)
      ]) +
        generadorDeMonstruos.rarosEn([game.at(6, 10)]) +
        generadorDeMonstruos.lobosEn([
          game.at(2, 10),
          game.at(9, 15)
        ]),
      paredes.horizontal(1, 4, 7) +
        paredes.horizontal(7, 10, 12) +
        paredes.vertical(8, 14, 17),
      [],
      [
        new RelojDeArena(segundos = 6, position = game.at(10, 2)),
        new RelojRoto(segundos = 5, position = game.at(9, 9)),
        new Maldicion(segundos = 6, position = game.at(2, 14)),
        new CharcoDeBarro(segundos = 5, position = game.at(5, 15))
      ]
    )

  // NIVEL 11: dos enemigos comunes, un hombre lobo y un hechicero.
  method sala11() =
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

  // NIVEL 12: dos comunes y un clon malvado.
  method sala12() =
    self.crearSala(45, "sala2.png",
      generadorDeMonstruos.generarEnemigosEn([
        game.at(3, 8),
        game.at(8, 8)
      ]) +
        generadorDeMonstruos.clonesEn([
          game.at(5, 14)
        ]), [], [], [])

  // NIVEL 13: recompensa de munición cazafantasmas.
  method sala13() =
    self.crearSala(30, "sala1.png", [], [],
      [
        new ItemMunicion(
          bala = balaCazaFantasmas,
          image = "itemCazaFantasmas.png",
          position = game.at(5, 10)
        )
      ],  [])

    // NIVEL 14: tres fantasmas y un espectro.
  method sala14() =
    self.crearSala(50, "sala2.png",
      generadorDeMonstruos.fantasmasEn([
        game.at(3, 6),
        game.at(8, 7),
        game.at(2, 13)
      ]) +
        generadorDeMonstruos.espectrosEn([game.at(9, 14)]),
      [], [], [])

  // NIVEL 15: un espectro y cuatro fantasmas.
  method sala15() =
    self.crearSala(75, "sala2.png",
      generadorDeMonstruos.fantasmasEn([
        game.at(2, 6),
        game.at(9, 6),
        game.at(3, 12),
        game.at(8, 12)
      ]) +
        generadorDeMonstruos.espectrosEn([game.at(5, 15)]),
      [], [], [])

  // NIVEL 16: dos comunes y dos fantasmas.
  method sala16() =
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
      [],
      [
        new RelojDeArena(segundos = 6, position = game.at(9, 3)),
        new CharcoDeBarro(segundos = 5, position = game.at(2, 6)),
        new RelojRoto(segundos = 5, position = game.at(5, 11)),
        new PistaDeVelocidad(segundos = 5, position = game.at(10, 16))
      ] + trampas.pinchosHorizontal(1, 1, 11))

  // NIVEL 17: dos comunes, un fantasma y un hombre lobo.
  method sala17() =
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

  
    // NIVEL 18: encuentro final contra el jefe + puzzle de laberinto de runas. El puzzle se resuelve pisando las runas en el orden correcto.
  method sala18() =
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