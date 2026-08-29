#set document(
  title: "Carte des commandes de Saga",
  author: "Mickaël CANOUIL",
  date: auto
)

#let bg = rgb("#14100b")
#let panel = rgb("#211913")
#let panel2 = rgb("#2b211799")
#let accent = rgb("#e3974c")
#let accent-soft = rgb("#7a5836")
#let ink = rgb("#f3e7d8")
#let muted = rgb("#b59a7e")

#set page(paper: "a5", margin: 5mm, fill: bg)
#set text(
  lang: "fr",
  font: ("Avenir Next", "Helvetica Neue"),
  size: 10pt,
  fill: ink,
)
#set par(leading: 0.38em)

// ===== Reusable styling helpers =====
#let rule = line(length: 100%, stroke: 0.5pt + accent-soft)

#let star = super[\*]

// Espace fine insécable (U+202F) pour la typographie française.
#let nbs = "\u{202F}"
// Avant deux-points (et autres ponctuations doubles).
#let colon = [#nbs:]
// Guillemets français avec espaces fines insécables.
#let guill(body) = [«#nbs#body#nbs»]

#let fine(body) = text(size: 7pt, fill: muted, body)

#let badge = box(
  baseline: 2pt,
  stroke: accent,
  radius: 3pt,
  inset: (x: 3pt, y: 2pt),
  outset: (y: 1pt),
  text(fill: bg, size: 6.5pt, weight: "bold", baseline: -1pt)[✋],
)

#let cmd(name) = text(
  fill: accent,
  weight: "bold",
  font: ("Menlo", "DejaVu Sans Mono"),
  size: 9.5pt,
  name,
)

// Gesture note rendered on its own line.
#let gesture(note) = [#linebreak()#fine[Geste#colon #note]]

// Framed panel with section title and divider.
#let panel-box(body, inset: 8pt) = block(
  fill: panel2,
  radius: 8pt,
  inset: inset,
  width: 100%,
  stroke: 0.75pt + accent-soft,
  breakable: false,
  body,
)

#let section(title, body, inset: 6pt, mark: none) = panel-box(inset: inset)[
  #text(fill: accent, weight: "bold", size: 10pt, smallcaps(title))#if mark != none [ #mark]
  #v(2pt)
  #rule
  #v(2pt)
  #body
]

#let rows(items) = table(
  columns: (auto, 1fr),
  stroke: none,
  inset: (x: 0pt, y: 1pt),
  column-gutter: 8pt,
  align: (left + top, left + top),
  ..items.map(it => (
    [#cmd(it.at(0))#if it.len() > 2 and it.at(2) [ #badge]],
    text(size: 8pt, it.at(1)),
  )).flatten()
)

#let group(title, items, mark: none) = section(title, rows(items), mark: mark)

#let picture-size = 3.8cm

#let avatar = box(
  clip: true,
  radius: 50%,
  width: picture-size,
  height: picture-size,
  stroke: 2.5pt + accent,
  image(
    "saga-picture.png",
    width: picture-size,
    height: picture-size,
    fit: "cover",
    alt: "Photo portrait de Saga, un labrador retriever noir."
  )
)

// ===== Styled double border filling the whole page =====
#box(
  width: 100%,
  height: 100%,
  fill: panel,
  radius: 13pt,
  stroke: 2.5pt + accent,
  inset: 5pt,
)[
  #box(
    width: 100%,
    height: 100%,
    radius: 9pt,
    stroke: 0.75pt + accent-soft,
    inset: 10pt,
  )[
    // --- En-tête ---
    #grid(
      columns: (auto, 1fr),
      column-gutter: 14pt,
      align: (horizon, horizon),
      avatar,
      [
        #text(size: 27pt, weight: "bold", fill: accent)[Saga #text(size: 18pt)[#sym.mars 🇫🇷]]
        #v(-13.5pt)
        #text(size: 11.5pt)[Labrador Retriever noir]
        #v(2pt)
        #text(size: 10pt, fill: muted)[Né le 6 septembre 2021]
        #v(4pt)
        #text(size: 8.5pt, fill: muted)[Carte des commandes #h(4pt) (#badge #h(1pt) = _geste de la main_)]
      ],
    )

    // #v(0pt)

    // --- Repas & informations pratiques (en premier) ---
    #section("Repas & informations pratiques", [
      #table(
        columns: (auto, 1fr, auto, auto),
        stroke: none,
        inset: (x: 0pt, y: 2pt),
        column-gutter: 14pt,
        align: horizon,
        cmd("à table"), text(size: 9pt)[Autorisé à manger.],
        text(size: 9pt)[#text(weight: "bold")[Matin]#colon 2 verres#star],
        text(size: 9pt)[#text(weight: "bold")[Soir]#colon 2 verres#star],
      )
      #v(3pt)
      #fine[#star Verre#colon celui fourni avec la nourriture. #h(1fr) Poids#colon 39,8#nbs kg #h(8pt) Non stérilisé]
    ], inset: 11pt)

    // #v(0pt)

    // --- Commandes : grille 2 x 2 ---
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 9pt,
      row-gutter: 7pt,

      group("Obéissance de base", (
        ("assis", "S'assoit."),
        ("coucher", "Se couche."),
        ("debout", "Se tient debout sur ses quatre pattes."),
        ("reste", "Reste en place."),
        ("stop", "Arrête de marcher."),
        ("vas-y", [Libère Saga \ (autorisé à faire ce qu'il veut).]),
        ("au lit", "Va dans son panier/caisse."),
      )),

      group("Tours", (
        ("bonjour", [Donne la patte pour #guill[serrer].#gesture[main tendue.]]),
        ("touche", [Touche la paume avec son nez.#gesture[main à plat.]]),
        ("pan", [Se met sur le dos \ (#guill[fait le mort]).#gesture[main en pistolet.]]),
        ("rampe", [Rampe au sol.#gesture[paume au sol, glissée vers le maître.]]),
      ), mark: badge),

      group("Rappel & position", (
        ("viens", "Revient près du maître."),
        ("au pied", "Vient se placer aux pieds."),
        ("droite", "Se place à droite."),
        ("gauche", "Se place à gauche."),
        ("milieu", "Vient entre les jambes."),
      )),

      group("Déplacements · escaliers & rue", (
        ("monte", "Monte les escaliers."),
        ("descend", "Descend les escaliers."),
        ("trottoir", "Monte sur le trottoir."),
        ("traverse", [Autorisé à traverser la rue \ (#guill[descendre du trottoir]).]),
      )),

      grid.cell(colspan: 2,
        section("Objets & rapport", grid(
          columns: (1fr, 1fr),
          column-gutter: 9pt,
          rows((
            ("vas chercher", "Va récupérer un objet."),
            ("cherche", "Cherche quelque chose."),
            ("lâche", "Relâche ou laisse tomber ce qu'il tient."),
          )),
          rows((
            ("laisse", "Laisse en place, ne touche pas."),
            ("prends", "Prend quelque chose."),
          )),
        ))
      ),
    )

    #v(1fr)
  ]
]

#place(bottom+center, dy: 10pt)[
  #text(size: 7pt, fill: ink.darken(65%))[#sym.copyright #link("https://mickael.canouil.fr")[Mickaël CANOUIL] - #datetime.today().display()
  ]
]
