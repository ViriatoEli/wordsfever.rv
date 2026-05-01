import 'dart:math';

class TabooCard {
  final String word;
  final List<String> forbidden;
  final String category;
  const TabooCard({required this.word, required this.forbidden, required this.category});
}

class ImpostorPair {
  final String topic;
  final String realWord;
  final String impostorWord;
  const ImpostorPair({required this.topic, required this.realWord, required this.impostorWord});
}

abstract class WordData {
  // ── Bomb categories ──────────────────────────────────────────────────────────
  static const Map<String, List<String>> bombCategories = {
    'Animali': [
      'cane', 'gatto', 'elefante', 'leone', 'tigre', 'scimmia', 'pappagallo',
      'delfino', 'serpente', 'orso', 'lupo', 'volpe', 'coccodrillo', 'giraffa',
      'zebra', 'pinguino', 'balena', 'squalo', 'tartaruga', 'farfalla', 'ape',
      'coniglio', 'mucca', 'cavallo', 'maiale', 'pecora', 'aquila', 'gufo',
      'pantera', 'leopardo', 'rinoceronte', 'ippopotamo', 'fenicottero',
    ],
    'Cibo': [
      'pizza', 'pasta', 'gelato', 'tiramisù', 'carbonara', 'risotto', 'lasagne',
      'gnocchi', 'bruschetta', 'focaccia', 'mozzarella', 'prosciutto', 'cannolo',
      'cappuccino', 'espresso', 'torta', 'panettone', 'polenta', 'piadina',
      'spaghetti', 'tagliatelle', 'arancino', 'supplì', 'mortadella', 'pesto',
      'calzone', 'cotoletta', 'tiella', 'ribollita', 'amatriciana',
    ],
    'Sport': [
      'calcio', 'basket', 'tennis', 'nuoto', 'ciclismo', 'boxe', 'pallavolo',
      'sci', 'atletica', 'golf', 'rugby', 'karatè', 'judo', 'scherma',
      'pallanuoto', 'maratona', 'ginnastica', 'canoa', 'arrampicata',
      'triathlon', 'tiro con l\'arco', 'equitazione', 'baseball', 'hockey',
      'pattinaggio', 'surf', 'windsurf', 'biathlon', 'slalom', 'bob',
    ],
    'Professioni': [
      'medico', 'pompiere', 'cuoco', 'pilota', 'insegnante', 'avvocato',
      'astronauta', 'attore', 'calciatore', 'poliziotto', 'dentista',
      'veterinario', 'architetto', 'fotografo', 'musicista', 'scrittore',
      'meccanico', 'elettricista', 'falegname', 'barbiere', 'infermiere',
      'ingegnere', 'mago', 'cuoco', 'pescatore', 'contadino', 'geometra',
      'farmacista', 'banchiere', 'sciatore',
    ],
    'Paesi': [
      'Italia', 'Francia', 'Spagna', 'Germania', 'Giappone', 'Cina', 'Brasile',
      'Argentina', 'Australia', 'India', 'Egitto', 'Messico', 'Canada',
      'Grecia', 'Turchia', 'Svezia', 'Polonia', 'Portogallo', 'Russia',
      'Olanda', 'Belgio', 'Svizzera', 'Austria', 'Norvegia', 'Danimarca',
      'Finlandia', 'Irlanda', 'Romania', 'Ungheria', 'Croazia',
    ],
    'Oggetti': [
      'telefono', 'chiave', 'forbici', 'matita', 'specchio', 'ombrello',
      'calzino', 'zaino', 'portafoglio', 'orologio', 'occhiali', 'candela',
      'compasso', 'righello', 'trapano', 'coltello', 'forchetta', 'bottiglia',
      'bicchiere', 'lampada', 'sedia', 'tavolo', 'finestra', 'porta',
      'chiodo', 'vite', 'martello', 'cacciavite', 'forbicine', 'bussola',
    ],
    'Film e TV': [
      'Titanic', 'Star Wars', 'Harry Potter', 'Il Re Leone', 'Frozen',
      'Avatar', 'Avengers', 'Batman', 'Spiderman', 'Il Padrino', 'Shrek',
      'Toy Story', 'Interstellar', 'Matrix', 'Inception', 'Forrest Gump',
      'Gladiatore', 'Joker', 'Up', 'Inside Out', 'Minions', 'Madagascar',
      'Nemo', 'Coco', 'Encanto', 'Ratatouille', 'Wall-E', 'Moana',
    ],
    'Musica': [
      'chitarra', 'pianoforte', 'batteria', 'violino', 'flauto', 'tromba',
      'sassofono', 'basso', 'tastiera', 'arpa', 'fisarmonica', 'ukulele',
      'oboe', 'clarinetto', 'mandolino', 'tuba', 'corno', 'tamburo',
      'maracas', 'xilofono', 'cetra', 'sitar', 'banjo', 'bouzouki',
      'clavicembalo', 'organo', 'sintetizzatore', 'triangolo',
    ],
  };

  // ── Taboo cards ──────────────────────────────────────────────────────────────
  static const List<TabooCard> tabooCards = [
    TabooCard(word: 'ELEFANTE', forbidden: ['grigio', 'grande', 'proboscide', 'Africa', 'zanna'], category: 'Animali'),
    TabooCard(word: 'GATTO', forbidden: ['miao', 'felino', 'baffi', 'zampe', 'ronfa'], category: 'Animali'),
    TabooCard(word: 'LEONE', forbidden: ['criniera', 'savana', 'predatore', 'ruggire', 're'], category: 'Animali'),
    TabooCard(word: 'DELFINO', forbidden: ['mare', 'intelligente', 'salto', 'mammifero', 'sorriso'], category: 'Animali'),
    TabooCard(word: 'PINGUINO', forbidden: ['ghiaccio', 'Antartide', 'nero', 'bianco', 'pesce'], category: 'Animali'),
    TabooCard(word: 'SERPENTE', forbidden: ['strisciare', 'veleno', 'lingua', 'squame', 'pelle'], category: 'Animali'),
    TabooCard(word: 'COCCODRILLO', forbidden: ['verde', 'denti', 'fiume', 'fauci', 'rettile'], category: 'Animali'),
    TabooCard(word: 'AQUILA', forbidden: ['volare', 'artigli', 'becco', 'nido', 'predatore'], category: 'Animali'),
    TabooCard(word: 'PIZZA', forbidden: ['mozzarella', 'pomodoro', 'Napoli', 'forno', 'rotonda'], category: 'Cibo'),
    TabooCard(word: 'GELATO', forbidden: ['freddo', 'cono', 'gusti', 'cremoso', 'estate'], category: 'Cibo'),
    TabooCard(word: 'TIRAMISÙ', forbidden: ['caffè', 'mascarpone', 'savoiardi', 'dolce', 'cacao'], category: 'Cibo'),
    TabooCard(word: 'CARBONARA', forbidden: ['pasta', 'uova', 'guanciale', 'pecorino', 'Roma'], category: 'Cibo'),
    TabooCard(word: 'TORTA', forbidden: ['compleanno', 'candele', 'dolce', 'forno', 'crema'], category: 'Cibo'),
    TabooCard(word: 'CAPPUCCINO', forbidden: ['caffè', 'schiuma', 'colazione', 'bar', 'latte'], category: 'Cibo'),
    TabooCard(word: 'CANNOLO', forbidden: ['Sicilia', 'ricotta', 'croccante', 'dolce', 'tubo'], category: 'Cibo'),
    TabooCard(word: 'CALCIO', forbidden: ['pallone', 'goal', 'stadio', 'squadra', 'portiere'], category: 'Sport'),
    TabooCard(word: 'NUOTO', forbidden: ['acqua', 'piscina', 'bracciata', 'vasca', 'stile'], category: 'Sport'),
    TabooCard(word: 'TENNIS', forbidden: ['racchetta', 'pallina', 'campo', 'rete', 'servizio'], category: 'Sport'),
    TabooCard(word: 'BOXE', forbidden: ['pugni', 'ring', 'guantoni', 'ko', 'arbitro'], category: 'Sport'),
    TabooCard(word: 'CICLISMO', forbidden: ['bici', 'pedalare', 'Tour', 'salita', 'giro'], category: 'Sport'),
    TabooCard(word: 'MEDICO', forbidden: ['ospedale', 'stetoscopio', 'malato', 'cura', 'dottore'], category: 'Professioni'),
    TabooCard(word: 'POMPIERE', forbidden: ['fuoco', 'idrante', 'scala', 'sirena', 'casco'], category: 'Professioni'),
    TabooCard(word: 'ASTRONAUTA', forbidden: ['spazio', 'tuta', 'luna', 'razzo', 'gravità'], category: 'Professioni'),
    TabooCard(word: 'CUOCO', forbidden: ['cucina', 'padella', 'ricetta', 'ristorante', 'chef'], category: 'Professioni'),
    TabooCard(word: 'PILOTA', forbidden: ['aereo', 'volare', 'cockpit', 'decollo', 'uniforme'], category: 'Professioni'),
    TabooCard(word: 'CHITARRA', forbidden: ['corde', 'musica', 'suonare', 'rock', 'strumento'], category: 'Musica'),
    TabooCard(word: 'PIANOFORTE', forbidden: ['tasti', 'bianco', 'nero', 'concerto', 'melodia'], category: 'Musica'),
    TabooCard(word: 'BATTERIA', forbidden: ['percussioni', 'ritmo', 'bacchette', 'tamburare', 'rock'], category: 'Musica'),
    TabooCard(word: 'VIOLINO', forbidden: ['arco', 'corde', 'classica', 'orchestra', 'suonare'], category: 'Musica'),
    TabooCard(word: 'SASSOFONO', forbidden: ['jazz', 'fiato', 'ottone', 'Blues', 'soffiare'], category: 'Musica'),
    TabooCard(word: 'ITALIA', forbidden: ['stivale', 'Roma', 'pizza', 'spaghetti', 'bandiera'], category: 'Paesi'),
    TabooCard(word: 'GIAPPONE', forbidden: ['Tokyo', 'sushi', 'samurai', 'anime', 'ciliegio'], category: 'Paesi'),
    TabooCard(word: 'BRASILE', forbidden: ['carnevale', 'samba', 'Amazzonia', 'calcio', 'tropicale'], category: 'Paesi'),
    TabooCard(word: 'EGITTO', forbidden: ['piramidi', 'faraone', 'Nilo', 'sfinge', 'mummia'], category: 'Paesi'),
    TabooCard(word: 'AUSTRALIA', forbidden: ['canguro', 'koala', 'Sidney', 'outback', 'corallo'], category: 'Paesi'),
    TabooCard(word: 'AEREO', forbidden: ['volare', 'passeggeri', 'pista', 'turbina', 'cielo'], category: 'Oggetti'),
    TabooCard(word: 'TELEFONO', forbidden: ['chiamare', 'schermo', 'app', 'batteria', 'internet'], category: 'Oggetti'),
    TabooCard(word: 'BICICLETTA', forbidden: ['ruote', 'pedali', 'sella', 'guidare', 'percorso'], category: 'Oggetti'),
    TabooCard(word: 'ROBOT', forbidden: ['macchina', 'programmazione', 'metallo', 'futuro', 'automa'], category: 'Oggetti'),
    TabooCard(word: 'OROLOGIO', forbidden: ['tempo', 'ore', 'minuti', 'lancette', 'ticchettio'], category: 'Oggetti'),
    TabooCard(word: 'SPECCHIO', forbidden: ['riflesso', 'vetro', 'immagine', 'guardarsi', 'lucido'], category: 'Oggetti'),
    TabooCard(word: 'OMBRELLO', forbidden: ['pioggia', 'aprire', 'manico', 'riparo', 'bagnato'], category: 'Oggetti'),
    TabooCard(word: 'TITANIC', forbidden: ['nave', 'iceberg', 'affondare', 'Jack', 'oceano'], category: 'Film e TV'),
    TabooCard(word: 'STAR WARS', forbidden: ['forza', 'Darth Vader', 'Jedi', 'spada laser', 'galassia'], category: 'Film e TV'),
    TabooCard(word: 'HARRY POTTER', forbidden: ['mago', 'Hogwarts', 'bacchetta', 'strega', 'occhiali'], category: 'Film e TV'),
    TabooCard(word: 'SHREK', forbidden: ['orco', 'palude', 'Fiona', 'asino', 'fiaba'], category: 'Film e TV'),
    TabooCard(word: 'MATRIX', forbidden: ['pillola', 'simulazione', 'Neo', 'macchine', 'hacker'], category: 'Film e TV'),
    TabooCard(word: 'MONTAGNA', forbidden: ['vetta', 'scalare', 'neve', 'alpinismo', 'roccia'], category: 'Natura'),
    TabooCard(word: 'VULCANO', forbidden: ['lava', 'eruzione', 'fumo', 'magma', 'esplosione'], category: 'Natura'),
    TabooCard(word: 'ARCOBALENO', forbidden: ['colori', 'pioggia', 'sole', 'curva', 'brillante'], category: 'Natura'),
    TabooCard(word: 'DESERTO', forbidden: ['sabbia', 'caldo', 'oasi', 'cammello', 'dune'], category: 'Natura'),
    TabooCard(word: 'TEMPORALE', forbidden: ['tuono', 'folgore', 'pioggia', 'vento', 'lampo'], category: 'Natura'),
    TabooCard(word: 'VAMPIRO', forbidden: ['sangue', 'morso', 'notte', 'castello', 'trasformazione'], category: 'Supereroi e Mostri'),
    TabooCard(word: 'FANTASMA', forbidden: ['spirito', 'paura', 'bianco', 'scomparire', 'urlo'], category: 'Supereroi e Mostri'),
    TabooCard(word: 'SPIDERMAN', forbidden: ['ragno', 'ragnatela', 'Peter', 'maschera', 'eroe'], category: 'Supereroi e Mostri'),
    TabooCard(word: 'SUPERMAN', forbidden: ['volare', 'mantello', 'forza', 'laser', 'Clark Kent'], category: 'Supereroi e Mostri'),
    TabooCard(word: 'BATMAN', forbidden: ['pipistrello', 'Gotham', 'ricco', 'tuta', 'oscuro'], category: 'Supereroi e Mostri'),
  ];

  // ── Impostor pairs ───────────────────────────────────────────────────────────
  static const List<ImpostorPair> impostorPairs = [
    ImpostorPair(topic: 'Animali domestici', realWord: 'GATTO', impostorWord: 'CANE'),
    ImpostorPair(topic: 'Grandi felini', realWord: 'LEONE', impostorWord: 'TIGRE'),
    ImpostorPair(topic: 'Sport di squadra', realWord: 'CALCIO', impostorWord: 'RUGBY'),
    ImpostorPair(topic: 'Sport con la racchetta', realWord: 'TENNIS', impostorWord: 'PING PONG'),
    ImpostorPair(topic: 'Dolci italiani', realWord: 'TIRAMISÙ', impostorWord: 'PANNA COTTA'),
    ImpostorPair(topic: 'Paste italiane', realWord: 'CARBONARA', impostorWord: 'AMATRICIANA'),
    ImpostorPair(topic: 'Strumenti a corde', realWord: 'CHITARRA', impostorWord: 'VIOLINO'),
    ImpostorPair(topic: 'Auto sportive italiane', realWord: 'FERRARI', impostorWord: 'LAMBORGHINI'),
    ImpostorPair(topic: 'Social media', realWord: 'INSTAGRAM', impostorWord: 'TIKTOK'),
    ImpostorPair(topic: 'App di messaggistica', realWord: 'WHATSAPP', impostorWord: 'TELEGRAM'),
    ImpostorPair(topic: 'Drink mattutino', realWord: 'CAFFÈ', impostorWord: 'TÈ'),
    ImpostorPair(topic: 'Condimenti dolci', realWord: 'NUTELLA', impostorWord: 'MARMELLATA'),
    ImpostorPair(topic: 'Pianeti rossi e grandi', realWord: 'MARTE', impostorWord: 'GIOVE'),
    ImpostorPair(topic: 'Mezzi di trasporto su rotaia', realWord: 'TRENO', impostorWord: 'METRO'),
    ImpostorPair(topic: 'Supereroi Marvel', realWord: 'SPIDERMAN', impostorWord: 'IRON MAN'),
    ImpostorPair(topic: 'Stagioni calde', realWord: 'ESTATE', impostorWord: 'PRIMAVERA'),
    ImpostorPair(topic: 'Professioni mediche', realWord: 'MEDICO', impostorWord: 'INFERMIERE'),
    ImpostorPair(topic: 'Grandi montagne', realWord: 'EVEREST', impostorWord: 'K2'),
    ImpostorPair(topic: 'Paesi asiatici', realWord: 'GIAPPONE', impostorWord: 'CINA'),
    ImpostorPair(topic: 'Strumenti a percussione', realWord: 'BATTERIA', impostorWord: 'TAMBURO'),
    ImpostorPair(topic: 'Frutti esotici', realWord: 'MANGO', impostorWord: 'PAPAYA'),
    ImpostorPair(topic: 'Bevande alcoliche', realWord: 'BIRRA', impostorWord: 'VINO'),
    ImpostorPair(topic: 'Pani italiani', realWord: 'PIZZA', impostorWord: 'FOCACCIA'),
    ImpostorPair(topic: 'Colori primari caldi', realWord: 'ROSSO', impostorWord: 'ARANCIONE'),
    ImpostorPair(topic: 'Grandi felini africani', realWord: 'GHEPARDO', impostorWord: 'LEOPARDO'),
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────────
  static List<String> get categoryNames => bombCategories.keys.toList();

  static List<String> getCategoryWords(String category) {
    return List<String>.from(bombCategories[category] ?? [])..shuffle();
  }

  static List<TabooCard> getTabooCards({String? category, int? limit}) {
    final all = category == null
        ? List<TabooCard>.from(tabooCards)
        : tabooCards.where((c) => c.category == category).toList();
    all.shuffle();
    if (limit != null && all.length > limit) return all.sublist(0, limit);
    return all;
  }

  static ImpostorPair getRandomImpostorPair([Random? rng]) {
    final r = rng ?? Random();
    return impostorPairs[r.nextInt(impostorPairs.length)];
  }
}
