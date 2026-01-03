# Manuale Tecnico del Sistema SpaceOBC1
## Documento di Specifica Operativa e Architetturale

---

## 1. Introduzione al Sistema

Il sistema SpaceOBC1 rappresenta un'architettura software complessa progettata specificamente per la gestione e il controllo di un computer di bordo spaziale (On-Board Computer). Questo sistema è stato concepito per operare in un ambiente critico dove l'affidabilità, la precisione temporale e l'efficienza nell'utilizzo delle risorse computazionali sono requisiti fondamentali per il successo della missione.

L'architettura del sistema si basa su un modello di esecuzione distribuita che coordina molteplici servizi specializzati, ciascuno responsabile di specifiche funzionalità operative. Questi servizi orchestrano l'esecuzione di task interdipendenti che devono rispettare vincoli temporali rigorosi e relazioni di precedenza ben definite. La natura critica delle operazioni spaziali richiede che ogni componente del sistema sia progettato con particolare attenzione alla robustezza, alla ridondanza e alla capacità di gestire situazioni anomale.

Il presente documento fornisce una descrizione dettagliata e approfondita di tutti gli aspetti del sistema SpaceOBC1, dalla configurazione dei parametri globali alla specifica di ogni singolo task, dalle relazioni di dipendenza temporale alle strategie di allocazione delle risorse. L'obiettivo è fornire una comprensione completa del funzionamento del sistema, utile sia per gli sviluppatori che per gli operatori di missione.

---

## 2. Configurazione Globale e Parametri Operativi

Il sistema SpaceOBC1 opera all'interno di una finestra temporale ben definita che si estende dall'istante iniziale, identificato come tempo zero, fino all'unità temporale trentatré. Questa finestra operativa di trentatré unità temporali rappresenta il periodo durante il quale tutte le operazioni pianificate devono essere avviate, eseguite e completate. La scelta di questa specifica durata è strettamente correlata ai requisiti della missione spaziale e alle caratteristiche orbitali del veicolo, garantendo che tutte le operazioni critiche possano essere completate entro i vincoli imposti dalla dinamica orbitale e dalle finestre di comunicazione con le stazioni di terra.

Dal punto di vista delle risorse computazionali, il sistema dispone di un massimo di otto unità di elaborazione che possono essere allocate simultaneamente per l'esecuzione dei task. Questo parametro, definito come r_max e impostato a otto, rappresenta un vincolo fondamentale per la schedulazione delle operazioni. La disponibilità di otto risorse permette un significativo grado di parallelismo nell'esecuzione dei task, consentendo al sistema di sfruttare efficacemente le capacità di elaborazione del computer di bordo. Tuttavia, questo vincolo richiede anche un'attenta pianificazione per evitare situazioni di contesa delle risorse che potrebbero compromettere il completamento tempestivo delle operazioni critiche.

L'identificazione del sistema attraverso il nome "SpaceOBC1" non è meramente nominale, ma rappresenta una specifica istanza di configurazione all'interno di una possibile famiglia di sistemi di controllo di bordo. Questa denominazione permette di distinguere chiaramente questa particolare configurazione da altre varianti che potrebbero essere utilizzate in missioni diverse o in fasi operative differenti della stessa missione.

---

## 3. Architettura Modulare dei Servizi

L'architettura del sistema SpaceOBC1 si articola in sette servizi principali, ciascuno progettato per gestire un dominio funzionale specifico delle operazioni di bordo. Questa organizzazione modulare permette una chiara separazione delle responsabilità e facilita sia la manutenzione che l'evoluzione del sistema nel tempo.

Il CoreService rappresenta il fondamento dell'intera architettura operativa. Questo servizio, identificato con l'ID 1, ha la responsabilità critica di gestire le operazioni fondamentali del sistema attraverso due task essenziali: l'inizializzazione del core (INIT_CORE) e la configurazione del protocollo di comunicazione (COMM_PROTO). L'importanza di questo servizio non può essere sottovalutata, poiché praticamente tutte le altre operazioni del sistema dipendono direttamente o indirettamente dal corretto completamento delle sue funzioni. Il CoreService stabilisce le basi operative necessarie, configurando i componenti essenziali del sistema e preparando l'infrastruttura di comunicazione che permetterà lo scambio di informazioni tra i vari sottosistemi e con le stazioni di terra.

Il ControlSyncService, secondo servizio dell'architettura, si occupa della gestione del controllo in tempo reale e della sincronizzazione tra i vari componenti del sistema. Attraverso i suoi due task principali, CTRL_EXEC e SYNC_PROC, questo servizio garantisce che le operazioni di controllo vengano eseguite con la frequenza e la precisione richieste, e che tutti i sottosistemi mantengano una sincronizzazione temporale accurata. La natura ripetitiva di questi task riflette la necessità di un controllo continuo e di una sincronizzazione periodica durante l'intera finestra operativa.

L'AnalysisService rappresenta il terzo pilastro dell'architettura e si dedica all'analisi approfondita dei dati di sistema e alla verifica dell'integrità operativa. Questo servizio coordina due task complementari: ANALYSIS_FULL, che esegue un'analisi completa e dettagliata dello stato del sistema, e VERIFY_QUICK, che effettua verifiche rapide di validazione. La combinazione di un'analisi approfondita con verifiche rapide permette al sistema di mantenere un equilibrio ottimale tra completezza dell'analisi e tempestività nella rilevazione di eventuali anomalie.

Il ProcessingService gestisce l'intera pipeline di elaborazione dei dati attraverso due fasi distinte ma strettamente correlate. La fase di pre-elaborazione, gestita dal task PREPROCESS_SVC, prepara i dati per il processing successivo, applicando trasformazioni, filtraggio e normalizzazione. La fase di post-elaborazione, gestita da POSTPROCESS_SVC, completa il processo applicando ulteriori trasformazioni, aggregazioni e preparando i risultati finali per l'utilizzo da parte di altri sottosistemi o per la trasmissione a terra.

L'OrbitService assume una rilevanza particolare nel contesto delle operazioni spaziali, essendo responsabile di tutte le funzionalità relative al controllo e alla gestione dell'orbita del veicolo. Questo servizio coordina due task specializzati: ORBIT_CTRL, che si occupa del controllo attivo dell'orbita attraverso calcoli di traiettoria e pianificazione di eventuali manovre correttive, e ORBIT_MGMT, che gestisce gli aspetti più ampi della gestione orbitale, interfacciandosi con i sistemi di navigazione e propulsione.

Il MonitorService fornisce capacità di sorveglianza continua dello stato del sistema attraverso il task MONITOR_SYS. La caratteristica distintiva di questo servizio è la sua capacità di eseguire fino a tre istanze simultanee del task di monitoraggio, fornendo un livello di ridondanza che aumenta significativamente l'affidabilità del sistema nel rilevare e segnalare eventuali anomalie operative.

Infine, il SafeService gestisce tutti gli aspetti relativi alla sicurezza del sistema e alle procedure di safe mode attraverso il task SAFE_DIR. Questo servizio rappresenta l'ultima linea di difesa in situazioni critiche, implementando le direttive di sicurezza necessarie per proteggere il veicolo spaziale e garantire la continuità della missione anche in presenza di anomalie significative.

---

## 4. Descrizione Dettagliata dei Task Operativi

Il task INIT_CORE, identificato con l'ID 1 e la sigla "initcor", rappresenta il punto di partenza di tutte le operazioni del sistema. Con una durata di quattordici unità temporali, questo task esegue l'inizializzazione fondamentale del core del sistema, configurando tutti i componenti essenziali necessari per le operazioni successive. Durante la sua esecuzione, INIT_CORE prepara l'ambiente operativo, inizializza le strutture dati fondamentali, configura i parametri di sistema e verifica l'integrità dei componenti critici. Questo task richiede una singola unità di risorsa computazionale e può essere eseguito una sola volta, senza ripetizioni, data la natura one-time della sua funzione di inizializzazione.

Il task COMM_PROTO, con ID 2 e sigla "comprt", si occupa della configurazione e dell'inizializzazione dei protocolli di comunicazione. Con una durata di sedici unità temporali, leggermente superiore a quella dell'inizializzazione core, questo task stabilisce tutti i canali di comunicazione necessari, configura i protocolli di rete, inizializza i buffer di trasmissione e ricezione, e verifica la connettività con i vari sottosistemi e con le stazioni di terra. La sua esecuzione è fondamentale per garantire che il sistema possa scambiare informazioni in modo affidabile durante tutta la finestra operativa.

Il task CTRL_EXEC, identificato con l'ID 3 e la sigla "ctlexe", rappresenta un componente critico per il controllo in tempo reale del sistema. A differenza dei task di inizializzazione, CTRL_EXEC ha una durata molto breve di sole tre unità temporali, ma è configurato per essere eseguito ripetutamente tre volte con un intervallo di otto unità temporali tra ogni ripetizione. Questa configurazione riflette la necessità di eseguire operazioni di controllo periodiche durante l'intera finestra operativa, garantendo che il sistema mantenga costantemente sotto controllo i parametri critici e possa reagire tempestivamente a eventuali deviazioni dai valori nominali.

Il task SYNC_PROC, con ID 4 e sigla "synprc", lavora in stretta coordinazione con CTRL_EXEC per garantire la sincronizzazione tra i vari sottosistemi. Con una durata ancora più breve di sole due unità temporali, questo task è anch'esso configurato per essere eseguito tre volte con intervalli di otto unità temporali. La sua funzione principale è quella di assicurare che tutti i componenti del sistema mantengano una visione coerente dello stato globale e che le operazioni distribuite vengano coordinate efficacemente.

Il task ANALYSIS_FULL, identificato con l'ID 5 e la sigla "anlful", esegue un'analisi completa e approfondita dello stato del sistema. Con una durata di quattordici unità temporali, questo task ha il tempo necessario per esaminare in dettaglio tutti gli aspetti operativi, analizzare i dati acquisiti, verificare le performance dei vari sottosistemi e identificare eventuali anomalie o deviazioni dai parametri nominali. L'analisi completa fornisce una visione olistica dello stato del sistema, essenziale per prendere decisioni informate sulle operazioni successive.

Il task VERIFY_QUICK, con ID 6 e sigla "verqck", complementa l'analisi completa fornendo capacità di verifica rapida. Con una durata di sette unità temporali, questo task esegue controlli di integrità mirati e validazioni dei risultati dell'analisi, permettendo al sistema di procedere rapidamente con le operazioni successive una volta confermata la validità dei dati e lo stato nominale del sistema. VERIFY_QUICK rappresenta anche un punto di diramazione critico nel flusso operativo, poiché il suo completamento abilita l'avvio di molteplici operazioni parallele.

I task PREPROCESS_SVC e POSTPROCESS_SVC, con ID 7 e 8 rispettivamente, formano una pipeline di elaborazione dati. PREPROCESS_SVC, con una durata di tredici unità temporali, esegue tutte le operazioni di preparazione dei dati, inclusi filtraggio, normalizzazione, trasformazione e validazione preliminare. POSTPROCESS_SVC, con una durata di dodici unità temporali, completa il processo di elaborazione applicando trasformazioni finali, aggregazioni, calcoli derivati e preparando i risultati nel formato richiesto per l'utilizzo successivo o per la trasmissione.

I task ORBIT_CTRL e ORBIT_MGMT, identificati con ID 9 e 10, gestiscono rispettivamente il controllo e la gestione delle operazioni orbitali. ORBIT_CTRL, con una durata di tredici unità temporali, si concentra sugli aspetti di controllo attivo, eseguendo calcoli di traiettoria, determinando eventuali correzioni orbitali necessarie e pianificando le manovre. ORBIT_MGMT, con una durata di quattordici unità temporali, coordina gli aspetti più ampi della gestione orbitale, interfacciandosi con i sistemi di navigazione, gestendo le risorse di propellente e ottimizzando la strategia orbitale complessiva.

Il task MONITOR_SYS, con ID 11 e sigla "monsys", fornisce capacità di monitoraggio continuo del sistema. Con una durata di dodici unità temporali e la capacità di essere eseguito fino a tre volte in parallelo, questo task rappresenta un elemento chiave per la robustezza del sistema. La possibilità di eseguire istanze multiple simultaneamente permette di implementare strategie di monitoraggio ridondante, aumentando significativamente la probabilità di rilevare tempestivamente eventuali anomalie.

Infine, il task SAFE_DIR, identificato con l'ID 12 e la sigla "safdir", gestisce l'implementazione delle direttive di sicurezza e le procedure di safe mode. Con una durata di dodici unità temporali, questo task può essere attivato quando necessario per gestire situazioni critiche, implementando le procedure di salvaguardia necessarie per proteggere il veicolo spaziale e garantire la continuità della missione anche in presenza di condizioni anomale.

---

## 5. Sistema di Vincoli Temporali e Dipendenze

Il sistema SpaceOBC1 implementa un sofisticato sistema di vincoli temporali basato sul concetto di precedenza start-to-start. Questo tipo di vincolo specifica che un task destinazione può iniziare la sua esecuzione solo dopo che sia trascorso un determinato ritardo dall'inizio dell'esecuzione del task sorgente. È importante notare che questi vincoli non richiedono il completamento del task sorgente, ma solo che sia trascorso il tempo specificato dal suo avvio. Questa caratteristica permette un maggiore grado di parallelismo nell'esecuzione, ottimizzando l'utilizzo delle risorse disponibili.

La catena di dipendenze inizia con i due task fondamentali di inizializzazione: INIT_CORE e COMM_PROTO. Entrambi questi task fungono da sorgenti per molteplici vincoli, riflettendo la loro natura critica per l'avvio del sistema. Il task CTRL_EXEC dipende sia da INIT_CORE che da COMM_PROTO, con un ritardo di due unità temporali da ciascuno. Questo significa che il controllo esecutivo può iniziare solo dopo che siano trascorse due unità temporali dall'avvio di entrambi i task di inizializzazione, garantendo che il sistema abbia avuto il tempo di configurare sia i componenti core che i protocolli di comunicazione necessari.

Similmente, il task ANALYSIS_FULL dipende anch'esso da entrambi i task di inizializzazione, ma con un ritardo maggiore di quattro unità temporali. Questo ritardo più lungo riflette il fatto che l'analisi completa richiede che il sistema abbia raggiunto un livello di inizializzazione più avanzato prima di poter iniziare le sue operazioni di analisi approfondita.

La relazione tra CTRL_EXEC e SYNC_PROC illustra la coordinazione necessaria tra controllo e sincronizzazione. Il task SYNC_PROC può iniziare due unità temporali dopo l'avvio di CTRL_EXEC, permettendo al processo di sincronizzazione di operare in modo coordinato con le operazioni di controllo.

La catena di analisi e verifica mostra una dipendenza sequenziale dove VERIFY_QUICK può iniziare otto unità temporali dopo l'avvio di ANALYSIS_FULL. Questo ritardo sostanziale permette all'analisi completa di progredire significativamente prima che inizi la fase di verifica rapida, garantendo che ci siano dati sufficienti da verificare.

Il task VERIFY_QUICK rappresenta un punto di diramazione particolarmente interessante nell'architettura del sistema. Dal suo avvio dipendono tre task diversi, tutti con lo stesso ritardo di sei unità temporali: PREPROCESS_SVC, ORBIT_CTRL e ORBIT_MGMT. Questa configurazione permette l'avvio simultaneo di tre percorsi operativi paralleli una volta che la verifica rapida ha confermato la validità dei dati e lo stato nominale del sistema. Questa parallelizzazione è essenziale per massimizzare l'efficienza del sistema e garantire che tutte le operazioni critiche possano essere completate entro la finestra temporale disponibile.

La pipeline di elaborazione dati mostra una dipendenza sequenziale chiara, dove POSTPROCESS_SVC può iniziare solo due unità temporali dopo l'avvio di PREPROCESS_SVC, garantendo che la fase di post-elaborazione operi sui dati già preparati dalla fase di pre-elaborazione.

Infine, il task MONITOR_SYS ha una dipendenza diretta da INIT_CORE con un ritardo di dieci unità temporali. Questo ritardo relativamente lungo permette al sistema di completare le fasi iniziali di inizializzazione e configurazione prima che inizi il monitoraggio continuo, garantendo che ci sia effettivamente qualcosa di significativo da monitorare.

---

## 6. Dinamica Operativa e Flusso di Esecuzione

L'esecuzione del sistema SpaceOBC1 segue una dinamica complessa che può essere compresa analizzando il flusso temporale delle operazioni. All'istante iniziale, il sistema avvia simultaneamente i due task fondamentali: INIT_CORE e COMM_PROTO. Questi task procedono in parallelo, utilizzando ciascuno una singola unità di risorsa computazionale, lasciando ancora sei risorse disponibili per altre operazioni.

Dopo due unità temporali dall'inizio, il sistema è pronto per avviare il task CTRL_EXEC, avendo soddisfatto i vincoli di ritardo da entrambi i task di inizializzazione. CTRL_EXEC inizia la sua prima esecuzione, che durerà tre unità temporali. Due unità temporali dopo l'avvio di CTRL_EXEC, quindi all'istante quattro dall'inizio del sistema, può iniziare SYNC_PROC per la sua prima esecuzione.

Sempre all'istante quattro, avendo soddisfatto i vincoli di ritardo di quattro unità temporali da entrambi i task di inizializzazione, può iniziare anche ANALYSIS_FULL. Questo task, con la sua durata significativa di quattordici unità temporali, procederà in parallelo con le ripetizioni successive di CTRL_EXEC e SYNC_PROC.

Le ripetizioni di CTRL_EXEC e SYNC_PROC seguono un pattern regolare. CTRL_EXEC si ripete all'istante dieci (2 + 8) e all'istante diciotto (2 + 16), mentre SYNC_PROC si ripete agli istanti dodici (4 + 8) e venti (4 + 16). Questo pattern di esecuzione periodica garantisce che il controllo e la sincronizzazione vengano mantenuti durante tutta la finestra operativa.

All'istante dieci dall'inizio, avendo soddisfatto il vincolo di ritardo di dieci unità temporali da INIT_CORE, può iniziare il task MONITOR_SYS. Data la sua capacità di eseguire fino a tre istanze in parallelo e la sua durata di dodici unità temporali, il monitoraggio può essere configurato per fornire copertura continua o ridondante secondo le necessità operative.

Otto unità temporali dopo l'avvio di ANALYSIS_FULL, quindi all'istante dodici, può iniziare VERIFY_QUICK. Questo task, con la sua durata di sette unità temporali, completerà la sua esecuzione intorno all'istante diciannove, momento in cui avrà verificato i risultati dell'analisi e validato lo stato del sistema.

Sei unità temporali dopo l'avvio di VERIFY_QUICK, quindi all'istante diciotto, il sistema può avviare simultaneamente tre percorsi operativi paralleli. PREPROCESS_SVC inizia la pipeline di elaborazione dati, ORBIT_CTRL avvia le operazioni di controllo orbitale, e ORBIT_MGMT inizia la gestione orbitale. Questa parallelizzazione massiva rappresenta un momento critico nell'esecuzione del sistema, dove molteplici operazioni complesse procedono simultaneamente.

Due unità temporali dopo l'avvio di PREPROCESS_SVC, quindi all'istante venti, può iniziare POSTPROCESS_SVC, completando la pipeline di elaborazione dati. A questo punto, il sistema sta operando con un alto grado di parallelismo, con molteplici task in esecuzione simultanea.

Verso la fine della finestra operativa, i vari task completano le loro esecuzioni. POSTPROCESS_SVC, essendo uno degli ultimi task nella catena di dipendenze, completerà la sua esecuzione intorno all'istante trentadue, poco prima della fine della finestra operativa di trentatré unità temporali.

Il task SAFE_DIR, non avendo vincoli di precedenza espliciti, può essere attivato in qualsiasi momento durante la finestra operativa secondo le necessità. Questa flessibilità è intenzionale, permettendo al sistema di rispondere rapidamente a situazioni critiche che potrebbero richiedere l'attivazione delle procedure di sicurezza.

---

## 7. Considerazioni Finali

Il sistema SpaceOBC1 rappresenta un esempio sofisticato di architettura software per applicazioni spaziali critiche. La sua progettazione riflette una profonda comprensione dei requisiti operativi, dei vincoli temporali e delle necessità di robustezza tipiche delle missioni spaziali. L'equilibrio tra parallelismo e dipendenze sequenziali, la gestione attenta delle risorse computazionali, e la presenza di meccanismi di monitoraggio e sicurezza dimostrano un approccio maturo alla progettazione di sistemi critici.

La modularità dell'architettura, con la sua chiara separazione in servizi specializzati, facilita non solo la comprensione del sistema ma anche la sua manutenzione ed evoluzione futura. La possibilità di modificare o estendere singoli servizi senza impattare l'intera architettura rappresenta un vantaggio significativo per l'adattamento del sistema a requisiti di missione mutevoli o all'integrazione di nuove funzionalità.
