<Cabbage>
form caption("Untitled") size(600, 300), guiMode("queue") pluginId("def1")
rslider bounds(350, 100, 100, 100), channel("gain"), range(0, 6, 0, 1, 0.01), text("Gain"), trackerColour("yellow"), textColour("black")
rslider bounds(50, 100, 100, 100), channel("freq"), range(100, 1000, 200, 1, 0.01), text("Frequency"), trackerColour("blue"), textColour("black")
rslider bounds(150, 100, 100, 100), channel("rhythm"), range(0.5, 2.0, 1.0, 1, 0.01), text("Rhythm"), trackerColour("green"), textColour("black")
rslider bounds(250, 100, 100, 100), channel("resize"), range(1, 3, 1, 1, 0.01), text("Resize"), trackerColour("red"), textColour("black")
rslider bounds(450, 100, 100, 100), channel("rot"), range(0, 0.1, 0.01, 1, 0.01), text("Rotation"), trackerColour("orange"), textColour("black")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d ; Opzioni per Csound: no output audio (-n), no display (-d), nessun dispositivo MIDI (-+rtmidi=NULL), no messaggi MIDI (-M0), nessuna uscita su console (-m0d)
</CsOptions>

<CsInstruments>
; Inizializzazione delle variabili globali.
ksmps = 32 ; Numero di campioni per ciclo di controllo
nchnls = 2 ; Numero di canali audio (stereo)
0dbfs = 1 ; Valore massimo per l'audio



instr 1 ; Inizio dello strumento 1

    giPiGreco = 4 * taninv(1.0) ; Calcola il valore di Pi greco

    iAngoli[] genarray 0 , 2 * giPiGreco, giPiGreco / 6 ; Divisione della circonferenza in 12 parti uguali

    iCosArr[] = cos(iAngoli) ; Calcola i coseni per ogni angolo
    iSinArr[] = sin(iAngoli) ; Calcola i seni per ogni angolo

    iSerie[] fillarray 1, 4, 6, 6, 8, 5, 7, 10, 12, 9, 11, 2, 12, 3 ; Definisce gli orientamenti dei segmenti per ciascun angolo

    iP0x[] = iCosArr ; Coordinate X basate sui coseni
    iP0y[] = iSinArr ; Coordinate Y basate sui seni

    giPx[] init 15 ; Inizializzazione delle coordinate X (array di 15 valori)
    giPy[] init 15 ; Inizializzazione delle coordinate Y (array di 15 valori)
    giPxRotate[] init 15; inizializzo l'array x per la rotazione
    giPyRotate[] init 15; inizializzo l'array y per la rotazione

    giPx[0] = 0 ; Prima coordinata X impostata a 0
    giPy[0] = 0 ; Prima coordinata Y impostata a 0

    iCount = 0 ; Inizializza il contatore

    while iCount < lenarray(giPx) - 1 do ; Ciclo per calcolare le altre coordinate
        iCount = iCount + 1 ; Incrementa il contatore
        giPx[iCount] = (giPx[iCount - 1] + iP0x[iSerie[iCount - 1]]) ; Calcola la nuova coordinata X
        giPy[iCount] = (giPy[iCount - 1] + iP0y[iSerie[iCount - 1]]) ; Calcola la nuova coordinata Y
    od

iFreq chnget "freq"    ; Ottiene il valore dello slider "Frequency"
iRhythm chnget "rhythm" ; Ottiene il valore dello slider "Rhythm"
iResize chnget "resize"   ; Ottiene il valore dello slider "Tempo"
iGaing chnget "gain" 
kRot chnget "rot" 

endin ; Fine dello strumento 1

instr 2 ; Inizio dello strumento 2

    ktrig metro 1 ; Metronomo a 1 Hz, genera trigger ogni secondo
    schedkwhen ktrig, 0, 0, 3, 0, 0.001 ; Programma lo strumento 3 quando viene ricevuto il trigger
    gkRotateTest phasor cabbageGetValue:k("rot"); test di rotazione abbastanza lento
    
endin ; Fine dello strumento 2

instr 3 ; Inizio dello strumento 3

    giCountFreq = 0 ; Contatore per scorrere le frequenze basate su giPy
    giDur =  cabbageGetValue:i("rhythm") ; Durata dello strumento 4 in secondi
    iResizeFreqAndTime = cabbageGetValue:i("resize") ; Variabile per espansione coordinata tempo-frequenza
    giEspasioneFreq = 100 * iResizeFreqAndTime ; Fattore di espansione per la frequenza
    iEspasioneTime = 1 * iResizeFreqAndTime ; Fattore di espansione per il tempo
    
 
    ;ROTAZIONE
    ;rotazione da 0 a 360 gradi
    iRotate = 360 * i(gkRotateTest) ;se moltiplichiamo per RotateTest fa girare automaticamente la figura
    
    ithetarot = iRotate * giPiGreco / 180;angolo di rotazione;
    print iRotate
    
    iPuntoDiRotazione = 14; da 0 a 14
    
    giCntRotate = 0 ; Inizializza il contatore per leggere giPxsort
    while giCntRotate < lenarray(giPx) do ; Ciclo per ruotare tutti i punti
  
        giPxRotate[giCntRotate] = (giPx[giCntRotate]-giPx[iPuntoDiRotazione]) * cos(ithetarot) - (giPy[giCntRotate]-giPy[iPuntoDiRotazione]) * sin(ithetarot) + giPx[0]; // Calcolo della nuova coordinata x'
        giPyRotate[giCntRotate] = (giPx[giCntRotate]-giPx[iPuntoDiRotazione]) * sin(ithetarot) + (giPy[giCntRotate]-giPy[iPuntoDiRotazione]) * cos(ithetarot) + giPy[0]; // Calcolo della nuova coordinata y'
            
        giCntRotate = giCntRotate + 1 ; Incrementa il contatore
    
    od
    ;FINE ROTAZIONE
    
    
    ;ORDINA PUNTI DELLA X PER NON AVERE TEMPI NEGATIVI
    giPxRotate = sorta(giPxRotate) ; Ordina le coordinate X
    giPxsort[] = giPxRotate + abs(giPxRotate[0]) ; Offset delle coordinate per evitare valori negativi
    printarray giPxsort    ; Stampa l'array ordinato dopo la rotazione delle coordinate X
    ;FINE ORDINE
    
    printarray giPyRotate  ; Stampa l'array dopo la rotazione delle coordinate Y

    ;CHIAMA TANTE VOLTE LO STRUMENTO 4 QUANTI SONO I PUNTI
    giCnt = 0 ; Inizializza il contatore per leggere giPxsort
    while giCnt < lenarray(giPxsort) do ; Ciclo per programmare lo strumento 4 ai tempi specificati
        schedule 4, giPxsort[giCnt] * iEspasioneTime, giDur ; Programma lo strumento 4 al tempo giPxsort[giCnt]
        giCnt = giCnt + 1 ; Incrementa il contatore
    od
    ;FINE DELLA CHIAMATA

endin ; Fine dello strumento 3

instr 4 ; Inizio dello strumento 4

    giFreqY = giPyRotate[giCountFreq] ; Legge il valore corrente di giPy per la frequenza

    giFreqFond = cabbageGetValue:i("freq") ; Frequenza fondamentale
    iFreqTot = giFreqFond + giFreqY * giEspasioneFreq ; Calcola la frequenza totale

    aSig oscili 0.01, iFreqTot    ; Genera un'onda sinusoidale con la frequenza calcolata

    aEnv linseg 0, giDur/2, 1, giDur/2, 0 ; Genera un inviluppo lineare per il segnale

    aOut = aSig * cabbageGetValue:i("gain")* aEnv ; Modula il segnale con l'inviluppo
    aL, aR pan2 aOut, rnd(1) ; Panning del segnale su due canali audio

    outs aL, aR ; Uscita del segnale stereo

    giCountFreq = giCountFreq + 1 ; Incrementa il contatore per le frequenze

endin ; Fine dello strumento 4

</CsInstruments>

<CsScore>
f0 z ; Csound resta in esecuzione indefinitamente
i1 0 [60*60*24*7] ; Avvia lo strumento 1 per una settimana
i2 0 [60*60*24*7] ; Avvia lo strumento 2 per una settimana
</CsScore>

</CsoundSynthesizer>

