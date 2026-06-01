// data.js
const GAME_DATA = {
  modes: [
    {
      id: 'indovina',
      emoji: '🧠',
      name: 'Indovina la Parola',
      subtitle: 'Taboo-style • 2-8 giocatori',
      desc: 'Spiega la parola senza dirla né usare quelle vietate. Il team indovina e guadagna punti.',
      color: '#FF4D1C'
    },
    {
      id: 'bomb',
      emoji: '💣',
      name: 'Bomb Word',
      subtitle: 'Hot potato • 3-8 giocatori',
      desc: 'Il telefono è una bomba a orologeria. Dì una parola della categoria e passalo in fretta — o perdi una vita.',
      color: '#FF1C4D'
    },
    {
      id: 'impostor',
      emoji: '🕵️',
      name: "L'Impostore",
      subtitle: 'Social deduction • 4-10 giocatori',
      desc: 'Tutti ricevono la stessa parola tranne uno. Scopri chi mente prima che inganni il gruppo.',
      color: '#7C1CFF'
    },
    {
      id: 'beatdash',
      emoji: '🎵',
      name: 'Beat Dash',
      subtitle: 'Indovina il brano • 2-8 giocatori',
      desc: 'Ascolta un frammento audio. Indovina la canzone. Meno secondi ascolti, più punti guadagni.',
      color: '#FFB800'
    },
    {
      id: 'chisono',
      emoji: '🌟',
      name: 'Chi Sono?',
      subtitle: 'Solo domande Sì/No • 2-8 giocatori',
      desc: 'Un personaggio famoso sulla fronte. Solo domande Sì/No per scoprire chi sei.',
      color: '#00C896'
    },
    {
      id: 'spiega',
      emoji: '💬',
      name: 'Spiega la Parola',
      subtitle: 'Taboo a squadre • 4+ giocatori',
      desc: 'Due squadre si sfidano. Un giocatore spiega, la squadra indovina. Vince chi guadagna più punti.',
      color: '#1CBBFF'
    }
  ],
  
  categories: {
    general: [
      "Fuoco", "Tramonto", "Enigma", "Labirinto", "Galassia", "Fulmine", "Vittoria", "Caos", "Oceano", "Montagna",
      "Computer", "Telefono", "Pizza", "Chitarra", "Treno", "Aereo", "Cinema", "Orologio", "Specchio", "Libro",
      "Fantasma", "Castello", "Drago", "Spada", "Corona", "Pirata", "Tesoro", "Astronauta", "Navicella", "Alieno"
    ],
    animals: [
      "Leone", "Tigre", "Elefante", "Giraffa", "Scimmia", "Cane", "Gatto", "Topo", "Aquila", "Squalo",
      "Delfino", "Balena", "Pinguino", "Orso", "Lupo", "Volpe", "Cavallo", "Mucca", "Maiale", "Pecora"
    ],
    bomb_themes: [
      "Capitali Europee", "Animali a quattro zampe", "Cose che si trovano in bagno", "Cibi che si mangiano a colazione",
      "Marche di automobili", "Cose che volano", "Strumenti musicali", "Sport con la palla", "Colori", "Cose fredde"
    ],
    characters: [
      "Harry Potter", "Spider-Man", "Batman", "Superman", "Iron Man", "Darth Vader", "Luke Skywalker", "Mickey Mouse",
      "Homer Simpson", "Super Mario", "Geralt di Rivia", "James Bond", "Sherlock Holmes", "Dracula", "Frankenstein",
      "Taylor Swift", "Cristiano Ronaldo", "Lionel Messi", "Michael Jackson", "Madonna"
    ],
    songs: [
      "Shape of You", "Blinding Lights", "Levitating", "Flowers", "Bohemian Rhapsody", "Billie Jean", "Hotel California",
      "Smells Like Teen Spirit", "Sweet Child O' Mine", "Rolling in the Deep"
    ]
  }
};
