<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1

opcode arrrot, i[], i[]i ;rotate array
    iarr[], ishift xin      
    isize = lenarray(iarr)
    iout[] init isize
    icount = 0
        until icount >= isize do
            iout[icount] = iarr[wrap(icount+ishift,0,(isize))]       
            icount += 1
        od
    xout iout
endop

instr 1

iPiGreco = 4 * taninv(1.0);calcola il pigreco

iAngoli[] genarray 0 , 2 * iPiGreco, iPiGreco / 6;divisione della circonferenza in 12 parti 

iCosArr[] = cos(iAngoli)
iSinArr[] = sin(iAngoli)

iSerie[] fillarray 1, 4, 6, 6, 8, 5, 7, 10, 12, 9, 11, 2, 12, 3;orientamenti dei segmenti che devono prendere gli angoli
iSerie2[] arrrot iSerie, 0

;printarray iSinArr


iP0x[] = iCosArr;tutte le coordinate dei coseni
iP0y[] = iSinArr;tutte le coordinate dei seni

giPx[] init 15;inizializzazione delle coordinate x
giPy[] init 15;inizializzazione delle coordinate y

giPx[0] = 0
giPy[0] = 0


iCount = 0

while iCount < lenarray(giPx) - 1 do
 
 iCount = iCount + 1
 
 giPx[iCount] = (giPx[iCount - 1] + iP0x[iSerie2[iCount - 1]]) 
 giPy[iCount] = (giPy[iCount - 1] + iP0y[iSerie2[iCount - 1]])

 od

giPx = sorta(giPx)
giPxsort[] = giPx + abs(giPx[0]) 
printarray giPxsort

endin

instr 2

;chiama lo strumento 3 che legge i tempi per ogni componente sinusoidale dato da giPx
ktrig metro 1
schedkwhen ktrig, 0, 0, 3, 0, 5

endin


instr 3
giCountFreq = 0; counter utilizzato per leggere l'array giPy nello strumento 4

giDur = 3;DURATA STRUMENTO 4

iResizeFreqAndTime = 1; da utilizzare se vuoi fare un espansione coordinata tempo frequenza
giEspasioneFreq = 100 * iResizeFreqAndTime; espasione frequenza
iEspasioneTime = 1 * iResizeFreqAndTime; espansione dei tempi


giCnt = 0 ;counter per il ciclo di lettura degli indirizzi dell'array giPxsort, che legge i tempi

while giCnt < lenarray(giPxsort) do
schedule 4, giPxsort[giCnt] * iEspasioneTime, giDur;chiama lo strumento 4 al tempo giPxsort[giCnt] * iResizeTime
                                                ;con durata giDur ogni evento
giCnt = giCnt + 1;aggiornamento del counter per il ciclo di lettura
od

endin


;nello strumento 4 ogni coordinata delle giPy sarà scelta sulla base delle coordinate giPx così ad ogni tempo sarà 
;assegnata la giusta frequenza
instr 4

giFreqY = giPy[giCountFreq];lettura delle coordinate giPy per le frequenze

giFreqFond = 200 
iFreqTot = giFreqFond + giFreqY * giEspasioneFreq ;frequenza fondamentale + la distanza in frequenza per ogni punto

aSig oscili 0.1, iFreqTot
aEnv linseg 0, giDur/2, 1, giDur/2, 0

aOut = aSig * aEnv
aL, aR pan2 aOut, rnd(1)

outs aL, aR

giCountFreq = giCountFreq + 1;aggiorna il counter per le frequenze

endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
i2 0 [60*60*24*7]
</CsScore>
</CsoundSynthesizer>
