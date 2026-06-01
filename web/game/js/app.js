// app.js

const app = {
  state: {
    currentScreen: 'splash',
    currentMode: null,
    gameConfig: {},
    gameData: {},
    timer: null,
    score: 0
  },

  init: () => {
    // Show splash, then go home
    setTimeout(() => {
      app.nav.go('home');
      app.render.home();
    }, 2800);
    
    // Prevent default touch behaviors to make it feel like a real app
    document.addEventListener('touchmove', (e) => {
      if(e.target.closest('.mode-list') || e.target.closest('.setup-content')) return;
      e.preventDefault();
    }, { passive: false });
  },

  nav: {
    history: [],
    go: (screenId, params = {}) => {
      if(app.state.currentScreen !== screenId && app.state.currentScreen !== 'splash') {
        app.nav.history.push(app.state.currentScreen);
      }
      
      document.querySelectorAll('.screen').forEach(s => {
        s.classList.remove('active', 'slide-in-right', 'slide-out');
      });
      
      const newScreen = document.getElementById(`screen-${screenId}`);
      if(newScreen) {
        newScreen.classList.add('active');
        // Simple animation logic
        if(app.nav.history.length > 0 && screenId !== 'home') {
          newScreen.classList.add('slide-in-right');
          setTimeout(() => newScreen.classList.remove('slide-in-right'), 10);
        }
      }
      app.state.currentScreen = screenId;
    },
    back: () => {
      const prev = app.nav.history.pop() || 'home';
      app.nav.go(prev);
      app.nav.history.pop(); // prevent double stacking
    }
  },

  render: {
    home: () => {
      const list = document.querySelector('.mode-list');
      list.innerHTML = '';
      
      GAME_DATA.modes.forEach((mode, idx) => {
        const delay = idx * 100;
        list.innerHTML += `
          <div class="mode-card" style="animation: slideUpFade 0.4s ease ${delay}ms both" onclick="app.setup.open('${mode.id}')">
            <div class="mode-stripe" style="background: ${mode.color}; box-shadow: 0 0 10px ${mode.color}"></div>
            <div class="mode-card-inner">
              <div class="mode-emoji" style="background: ${mode.color}22; border: 1px solid ${mode.color}44">${mode.emoji}</div>
              <div class="mode-text">
                <div class="mode-title" style="color: ${mode.color}">${mode.name}</div>
                <div class="mode-sub">${mode.subtitle}</div>
                <div class="mode-desc">${mode.desc}</div>
              </div>
            </div>
          </div>
        `;
      });
    }
  },

  setup: {
    open: (modeId) => {
      const mode = GAME_DATA.modes.find(m => m.id === modeId);
      app.state.currentMode = mode;
      document.getElementById('setup-title').innerText = mode.name;
      
      const content = document.getElementById('setup-content');
      content.innerHTML = app.setup.getOptionsHtml(modeId);
      
      app.nav.go('setup');
    },
    
    getOptionsHtml: (modeId) => {
      // Return specific setup HTML based on mode
      if(modeId === 'indovina' || modeId === 'spiega') {
        return `
          <div class="setup-group">
            <div class="setup-label">Tempo per Round</div>
            <div class="setup-grid" id="opt-time">
              <div class="setup-opt active" onclick="app.setup.select(this, 'time', 30)">30 Secondi</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'time', 60)">60 Secondi</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'time', 90)">90 Secondi</div>
            </div>
          </div>
        `;
      }
      if(modeId === 'bomb') {
        return `
          <div class="setup-group">
            <div class="setup-label">Difficoltà (Tempo Nascosto)</div>
            <div class="setup-grid" id="opt-diff">
              <div class="setup-opt active" onclick="app.setup.select(this, 'diff', 'easy')">Facile (20-40s)</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'diff', 'hard')">Difficile (5-15s)</div>
            </div>
          </div>
        `;
      }
      if(modeId === 'impostor') {
        return `
          <div class="setup-group">
            <div class="setup-label">Numero Giocatori</div>
            <div class="setup-grid" id="opt-players">
              <div class="setup-opt active" onclick="app.setup.select(this, 'players', 4)">4 Giocatori</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'players', 5)">5 Giocatori</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'players', 6)">6 Giocatori</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'players', 8)">8 Giocatori</div>
            </div>
          </div>
        `;
      }
      if(modeId === 'beatdash') {
        // Init default config
        app.state.gameConfig.artist = 'Sfera Ebbasta';
        app.state.gameConfig.listenTime = 2.0;

        return `
          <div class="setup-group">
            <div class="setup-label">Artista (Artist Mode)</div>
            <input type="text" id="beatdash-artist-input" class="setup-input" placeholder="Es. Sfera Ebbasta" value="Sfera Ebbasta" onchange="app.state.gameConfig.artist = this.value" onkeyup="app.state.gameConfig.artist = this.value" />
          </div>
          <div class="setup-group">
            <div class="setup-label">Tempo di Ascolto</div>
            <div class="setup-grid" id="opt-listen-time">
              <div class="setup-opt" onclick="app.setup.select(this, 'listenTime', 0.5)">0.5s</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'listenTime', 1.0)">1.0s</div>
              <div class="setup-opt active" onclick="app.setup.select(this, 'listenTime', 2.0)">2.0s</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'listenTime', 3.0)">3.0s</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'listenTime', 5.0)">5.0s</div>
            </div>
          </div>
        `;
      }
      if(modeId === 'chisono') {
        return `
          <div class="setup-group">
            <div class="setup-label">Obiettivo Punti</div>
            <div class="setup-grid" id="opt-score">
              <div class="setup-opt" onclick="app.setup.select(this, 'target', 5)">5 Punti</div>
              <div class="setup-opt active" onclick="app.setup.select(this, 'target', 10)">10 Punti</div>
              <div class="setup-opt" onclick="app.setup.select(this, 'target', 20)">20 Punti</div>
            </div>
          </div>
        `;
      }
      return `<p class="muted">Nessuna impostazione necessaria per questa modalità.</p>`;
    },
    
    select: (el, key, value) => {
      const parent = el.parentElement;
      parent.querySelectorAll('.setup-opt').forEach(opt => opt.classList.remove('active'));
      el.classList.add('active');
      app.state.gameConfig[key] = value;
    }
  },

  game: {
    start: () => {
      app.nav.go('game');
      const mode = app.state.currentMode.id;
      app.state.score = 0;
      
      const gameContainer = document.getElementById('screen-game');
      
      if(mode === 'indovina') app.modes.indovina.init(gameContainer);
      else if(mode === 'bomb') app.modes.bomb.init(gameContainer);
      else if(mode === 'impostor') app.modes.impostor.init(gameContainer);
      else if(mode === 'spiega') app.modes.indovina.init(gameContainer); // reuse logic
      else if(mode === 'chisono') app.modes.chisono.init(gameContainer);
      else if(mode === 'beatdash') app.modes.beatdash.init(gameContainer);
    },
    end: (title, scoreText) => {
      clearInterval(app.state.timer);
      app.nav.go('results');
      document.getElementById('results-content').innerHTML = `
        <div class="res-title grad">${title}</div>
        <div class="res-score">${scoreText}</div>
        <div class="res-stats">Ottimo lavoro!</div>
      `;
    }
  },
  
  // Game Modes Implementations
  modes: {
    indovina: {
      init: (container) => {
        let time = app.state.gameConfig.time || 30;
        let words = [...GAME_DATA.categories.general, ...GAME_DATA.categories.animals].sort(() => 0.5 - Math.random());
        let currentWordIdx = 0;
        
        container.innerHTML = `
          <header class="game-header">
            <button class="btn-icon" onclick="app.nav.go('home'); clearInterval(app.state.timer)">×</button>
            <div class="game-timer" id="game-timer">${time}</div>
            <div class="game-score" id="game-score">0</div>
          </header>
          <div class="card-play" id="game-card">
            <div class="card-word" id="current-word">${words[0]}</div>
            <div class="card-desc">Metti il telefono sulla fronte!</div>
          </div>
          <div class="tilt-overlay tilt-up" id="tilt-up">CORRETTO!</div>
          <div class="tilt-overlay tilt-down" id="tilt-down">PASSO</div>
        `;
        
        const nextWord = (isCorrect) => {
          if(isCorrect) {
            app.state.score++;
            document.getElementById('game-score').innerText = app.state.score;
            document.getElementById('sfx-success').play().catch(()=>{});
            showTilt('up');
          } else {
            document.getElementById('sfx-fail').play().catch(()=>{});
            showTilt('down');
          }
          
          currentWordIdx++;
          if(currentWordIdx >= words.length) currentWordIdx = 0;
          document.getElementById('current-word').innerText = words[currentWordIdx];
        };
        
        const showTilt = (dir) => {
          const el = document.getElementById(`tilt-${dir}`);
          el.classList.add('show-tilt');
          setTimeout(() => el.classList.remove('show-tilt'), 500);
        };

        // Simulated tilt via click for web dev/testing
        document.getElementById('game-card').addEventListener('click', (e) => {
          const rect = e.target.closest('.card-play').getBoundingClientRect();
          const y = e.clientY - rect.top;
          if(y < rect.height / 2) nextWord(true); // top half = correct
          else nextWord(false); // bottom half = pass
        });

        // Device Orientation API (Real Tilt)
        if (window.DeviceOrientationEvent) {
          window.addEventListener('deviceorientation', function(event) {
            if(app.state.currentScreen !== 'game') return;
            const beta = event.beta; // -180 to 180
            // Assuming portrait holding:
            // Tilted down (screen to floor) ~ beta > 120 or beta < -120
            // Tilted up (screen to ceiling) ~ beta near 0
            if (beta < 30 && beta > -30) {
              if(!app.state.gameData.tilted) {
                app.state.gameData.tilted = true;
                nextWord(true);
                setTimeout(()=> app.state.gameData.tilted = false, 1000);
              }
            } else if (beta > 150 || beta < -150) {
               if(!app.state.gameData.tilted) {
                app.state.gameData.tilted = true;
                nextWord(false);
                setTimeout(()=> app.state.gameData.tilted = false, 1000);
              }
            }
          });
        }

        app.state.timer = setInterval(() => {
          time--;
          const timerEl = document.getElementById('game-timer');
          timerEl.innerText = time;
          if(time <= 5) timerEl.classList.add('timer-warn');
          if(time <= 0) {
            app.game.end('TEMPO SCADUTO!', app.state.score + ' Punti');
          }
        }, 1000);
      }
    },
    
    bomb: {
      init: (container) => {
        const isHard = app.state.gameConfig.diff === 'hard';
        const timeLimit = isHard ? Math.floor(Math.random()*10)+5 : Math.floor(Math.random()*20)+20;
        let time = timeLimit;
        
        const themes = GAME_DATA.categories.bomb_themes.sort(() => 0.5 - Math.random());
        
        container.innerHTML = `
          <header class="game-header">
             <button class="btn-icon" onclick="app.nav.go('home'); clearInterval(app.state.timer)">×</button>
          </header>
          <div class="flex-center" style="flex:1">
            <div class="bomb-visual" id="bomb-visual">💣</div>
            <div class="card-word" style="margin-top:40px; text-align:center">${themes[0]}</div>
            <p class="muted" style="text-align:center; margin-top:20px; padding: 0 20px;">Dì una parola in tema e tocca la bomba per passare il turno!</p>
          </div>
        `;
        
        const tickAudio = document.getElementById('sfx-tick');
        const explodeAudio = document.getElementById('sfx-explode');
        
        document.getElementById('bomb-visual').addEventListener('click', () => {
           // Pass turn feedback
           const bv = document.getElementById('bomb-visual');
           bv.style.transform = 'scale(0.9)';
           setTimeout(()=>bv.style.transform = '', 100);
        });

        app.state.timer = setInterval(() => {
          time--;
          tickAudio.play().catch(()=>{});
          
          if(time <= Math.min(5, timeLimit/3)) {
            document.getElementById('bomb-visual').classList.add('bomb-fast');
          }
          
          if(time <= 0) {
            clearInterval(app.state.timer);
            explodeAudio.play().catch(()=>{});
            document.getElementById('bomb-visual').innerText = '💥';
            document.getElementById('bomb-visual').style.background = 'transparent';
            document.getElementById('bomb-visual').style.boxShadow = 'none';
            document.getElementById('bomb-visual').style.fontSize = '8rem';
            document.getElementById('bomb-visual').classList.remove('bomb-fast');
            setTimeout(() => {
              app.game.end('BOOM!', 'Sei Eliminato');
            }, 2000);
          }
        }, 1000);
      }
    },
    
    impostor: {
      init: (container) => {
        const numPlayers = app.state.gameConfig.players || 4;
        let words = GAME_DATA.categories.general.sort(() => 0.5 - Math.random());
        const secretWord = words[0];
        const impostorIndex = Math.floor(Math.random() * numPlayers);
        
        let currentPlayer = 0;
        
        const renderPlayerTurn = () => {
          if (currentPlayer >= numPlayers) {
            // All players saw their role
            container.innerHTML = `
              <div class="flex-center" style="height:100%; padding: 20px; text-align:center;">
                <h2 class="res-title" style="color:var(--fire2)">TUTTI PRONTI</h2>
                <p class="res-stats" style="margin-bottom:30px;">Ora, a turno, dite una parola legata alla parola segreta.</p>
                <button class="btn-primary" onclick="app.nav.go('home')">FINE PARTITA</button>
              </div>
            `;
            return;
          }
          
          container.innerHTML = `
             <header class="game-header">
               <button class="btn-icon" onclick="app.nav.go('home')">×</button>
            </header>
            <div class="flex-center" style="flex:1; padding:20px; text-align:center;">
              <h2 style="margin-bottom:10px;">GIOCATORE ${currentPlayer + 1}</h2>
              <p class="muted" style="margin-bottom:40px;">Passa il telefono al Giocatore ${currentPlayer + 1}. Quando è pronto, premi per rivelare il ruolo.</p>
              <button class="btn-primary" id="btn-reveal">RIVELA RUOLO</button>
            </div>
          `;
          
          document.getElementById('btn-reveal').addEventListener('click', () => {
            const isImpostor = (currentPlayer === impostorIndex);
            container.innerHTML = `
              <div class="flex-center" style="flex:1; padding:20px; text-align:center; background: ${isImpostor ? 'rgba(124,28,255,0.1)' : 'var(--bg)'}">
                <h1 style="font-family:var(--fd); font-size:3rem; color: ${isImpostor ? '#7C1CFF' : '#FF4D1C'}">
                  ${isImpostor ? 'SEI L\'IMPOSTORE!' : 'SEI UN GIOCATORE'}
                </h1>
                <p style="font-size:1.5rem; margin-top:20px;">
                  ${isImpostor ? 'Cerca di nasconderti.' : `La parola è: <strong>${secretWord}</strong>`}
                </p>
                <button class="btn-primary" style="margin-top:50px;" id="btn-next">HO CAPITO (PASSA AL PROSSIMO)</button>
              </div>
            `;
            
            document.getElementById('btn-next').addEventListener('click', () => {
              currentPlayer++;
              renderPlayerTurn();
            });
          });
        };
        
        renderPlayerTurn();
      }
    },
    
    chisono: {
       init: (container) => {
         const chars = GAME_DATA.categories.characters.sort(() => 0.5 - Math.random());
         container.innerHTML = `
          <header class="game-header">
            <button class="btn-icon" onclick="app.nav.go('home')">×</button>
          </header>
          <div class="card-play" style="border-color:#00C896">
            <div style="font-size:4rem; margin-bottom:10px;">🌟</div>
            <div class="card-word" style="color:#00C896; font-size:3rem;">${chars[0]}</div>
            <div class="card-desc">Mettilo sulla fronte. Gli altri vedono il nome. Fai domande Sì/No!</div>
          </div>
          <div class="bottom-action" style="position:static; margin-top:auto;">
             <button class="btn-primary" style="background:#00C896" onclick="app.game.end('INDOVINATO!', 'Punto Assegnato')">HO INDOVINATO!</button>
          </div>
         `;
       }
    },
    
    beatdash: {
       init: (container) => {
         const artist = app.state.gameConfig.artist || 'Sfera Ebbasta';
         const listenTime = app.state.gameConfig.listenTime || 2.0;

         container.innerHTML = `
          <header class="game-header">
            <button class="btn-icon" onclick="app.nav.go('home'); if(app.modes.beatdash.audio) app.modes.beatdash.audio.pause(); clearTimeout(app.modes.beatdash.timeout);">×</button>
          </header>
          <div class="flex-center" style="flex:1; padding:20px; text-align:center;">
             <div class="mode-emoji" style="font-size:4rem; background:#FFB80022; width:120px; height:120px; border-radius:30px; margin-bottom:30px; animation: pulse 1s infinite alternate;">⏳</div>
             <h2 style="color:#FFB800; font-family:var(--fd); font-size:2rem;">Cerco brani di ${artist}...</h2>
          </div>
         `;

         // Fetch via JSONP to avoid CORS on Deezer
         const script = document.createElement('script');
         const cbName = 'deezerCb_' + Date.now();
         window[cbName] = function(data) {
           delete window[cbName];
           document.body.removeChild(script);
           app.modes.beatdash.startGame(container, data, listenTime);
         };
         script.src = `https://api.deezer.com/search?q=artist:"${encodeURIComponent(artist)}"&output=jsonp&callback=${cbName}&limit=50`;
         document.body.appendChild(script);
       },

       startGame: (container, data, listenTime) => {
         if(!data || !data.data || data.data.length === 0) {
           app.game.end('ERRORE', 'Nessun brano trovato per questo artista.');
           return;
         }

         // Filter tracks with preview and get unique titles
         const validTracks = [];
         const titles = new Set();
         data.data.forEach(t => {
           if(t.preview && !titles.has(t.title)) {
             titles.add(t.title);
             validTracks.push(t);
           }
         });

         if(validTracks.length < 4) {
           app.game.end('ERRORE', 'Non ci sono abbastanza brani per giocare.');
           return;
         }

         // Pick 10 random or max available
         validTracks.sort(() => 0.5 - Math.random());
         const playlist = validTracks.slice(0, 10);
         
         let currentTrackIdx = 0;
         let score = 0;
         let audio = null;
         let answerTimeStart = 0;

         const playRound = () => {
           if (currentTrackIdx >= playlist.length) {
              app.game.end('PARTITA FINITA', score + ' Punti');
              return;
           }

           const track = playlist[currentTrackIdx];
           
           // Generate 4 options
           const options = [track];
           const others = validTracks.filter(t => t.id !== track.id).sort(() => 0.5 - Math.random());
           for(let i = 0; i < 3 && i < others.length; i++) options.push(others[i]);
           options.sort(() => 0.5 - Math.random());

           container.innerHTML = `
             <header class="game-header">
               <button class="btn-icon" onclick="app.nav.go('home'); if(app.modes.beatdash.audio) app.modes.beatdash.audio.pause(); clearTimeout(app.modes.beatdash.timeout);">×</button>
               <div class="game-score" id="game-score">${score}</div>
             </header>
             <div class="flex-center" style="flex:1; padding:20px; width:100%; max-width:500px; margin:0 auto; padding-bottom:50px;">
                <div class="bd-progress">Brano ${currentTrackIdx + 1} di ${playlist.length}</div>
                <div class="mode-emoji" id="music-icon" style="font-size:4rem; background:#FFB80022; width:120px; height:120px; border-radius:30px; margin-bottom:20px; box-shadow: 0 0 20px rgba(255,184,0,0.4)">🎵</div>
                
                <h2 style="color:#FFB800; font-family:var(--fd); font-size:1.8rem; margin-bottom:5px;">Ascolta...</h2>
                <p class="muted" id="bd-status">L'audio si fermerà dopo ${listenTime}s</p>

                <div class="beatdash-answers" id="bd-answers">
                  ${options.map((opt, i) => `<button class="bd-ans-btn" id="ans-${i}" onclick="app.modes.beatdash.onAnswer(${opt.id === track.id}, ${i})">${opt.title}</button>`).join('')}
                </div>
                
                <button class="btn-primary" style="margin-top:30px; display:none; background:#FFB800" id="btn-next" onclick="app.modes.beatdash.nextRound()">PROSSIMA CANZONE</button>
             </div>
           `;

           app.modes.beatdash.currentTrack = track;
           
           if(audio) audio.pause();
           audio = new Audio(track.preview);
           app.modes.beatdash.audio = audio;
           app.modes.beatdash.answered = false;

           audio.play().catch(e => console.log('Audio play error:', e));
           document.getElementById('music-icon').style.animation = 'throb 0.5s infinite alternate';
           
           answerTimeStart = Date.now();
           app.modes.beatdash.answerTimeStart = answerTimeStart;

           // Stop audio after listenTime
           app.modes.beatdash.timeout = setTimeout(() => {
             if(audio) audio.pause();
             const icon = document.getElementById('music-icon');
             if(icon) icon.style.animation = 'none';
             const status = document.getElementById('bd-status');
             if(status && !app.modes.beatdash.answered) status.innerText = 'Audio interrotto. Qual è il brano?';
           }, listenTime * 1000);
         };

         app.modes.beatdash.onAnswer = (isCorrect, btnIdx) => {
           if(app.modes.beatdash.answered) return;
           app.modes.beatdash.answered = true;
           
           if(app.modes.beatdash.audio) app.modes.beatdash.audio.pause();
           clearTimeout(app.modes.beatdash.timeout);
           document.getElementById('music-icon').style.animation = 'none';
           
           const timeTaken = (Date.now() - app.modes.beatdash.answerTimeStart) / 1000;
           const btn = document.getElementById(`ans-${btnIdx}`);

           if(isCorrect) {
             btn.classList.add('correct');
             document.getElementById('sfx-success').play().catch(()=>{});
             // Calculate points: max 100, min 10 based on speed (12 seconds is min points)
             let pts = Math.floor(100 - (timeTaken * 7.5));
             if(pts < 10) pts = 10;
             if(pts > 100) pts = 100;
             
             score += pts;
             document.getElementById('game-score').innerText = score;
             document.getElementById('bd-status').innerText = `Esatto! +${pts} Punti (in ${timeTaken.toFixed(1)}s)`;
             document.getElementById('bd-status').style.color = '#34D399';
           } else {
             btn.classList.add('wrong');
             document.getElementById('sfx-fail').play().catch(()=>{});
             document.getElementById('bd-status').innerText = `Sbagliato! Era: ${app.modes.beatdash.currentTrack.title}`;
             document.getElementById('bd-status').style.color = '#FF1C4D';
             // Highlight correct answer
             document.querySelectorAll('.bd-ans-btn').forEach(b => {
               if(b.innerText === app.modes.beatdash.currentTrack.title) b.classList.add('correct');
             });
           }

           document.getElementById('btn-next').style.display = 'block';
         };

         app.modes.beatdash.nextRound = () => {
           currentTrackIdx++;
           playRound();
         };

         // start first round
         playRound();
       }
    }
  }
};

// Start
document.addEventListener('DOMContentLoaded', app.init);
