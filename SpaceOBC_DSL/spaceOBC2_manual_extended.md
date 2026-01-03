# Manuale Tecnico del Sistema SpaceOBC2
## Documento di Specifica Operativa e Architetturale

---

## 1. Introduzione al Sistema

Il sistema SpaceOBC2 rappresenta una configurazione evoluta di computer di bordo spaziale, progettata specificamente per missioni che richiedono capacità avanzate di controllo propulsivo e gestione della sicurezza operativa. Questo sistema si distingue per l'integrazione di un servizio dedicato al controllo dei propulsori, elemento critico per manovre orbitali, correzioni di traiettoria e operazioni di assetto del veicolo spaziale.

L'architettura di SpaceOBC2 è stata concepita per operare in scenari dove la precisione del controllo e la rapidità di risposta sono requisiti fondamentali. La disponibilità di dieci unità di risorse computazionali, superiore rispetto alle configurazioni base, permette al sistema di gestire simultaneamente operazioni complesse che richiedono allocazioni di risorse significative, particolarmente per il controllo dei propulsori che necessita di tre unità di risorse, il valore più elevato tra tutti i task del sistema.

La filosofia progettuale di SpaceOBC2 enfatizza la ridondanza operativa attraverso l'implementazione di molteplici percorsi di attivazione per i task critici. Questa caratteristica è particolarmente evidente nella gestione del controllo propulsori e delle direttive di sicurezza, dove il sistema prevede percorsi alternativi di attivazione che aumentano significativamente la robustezza operativa. Il monitoraggio precoce, attivato già dopo due unità temporali dall'inizializzazione, fornisce una sorveglianza continua che permette al sistema di rilevare tempestivamente eventuali anomalie e attivare le appropriate contromisure.

---

## 2. Configurazione Globale e Parametri Operativi

Il sistema SpaceOBC2 opera all'interno di una finestra temporale identica a quella delle altre configurazioni della famiglia SpaceOBC, estendendosi dall'istante iniziale zero fino all'unità temporale trentatré. Questa standardizzazione della finestra operativa facilita il confronto tra le diverse configurazioni e permette una pianificazione coerente delle missioni che potrebbero richiedere la transizione tra diverse configurazioni di sistema.

La caratteristica distintiva di SpaceOBC2 dal punto di vista delle risorse computazionali è la disponibilità di dieci unità di elaborazione. Questo incremento rispetto alla configurazione base riflette la necessità di supportare operazioni più intensive, particolarmente quelle legate al controllo dei propulsori. La scelta di dieci risorse non è casuale ma rappresenta un equilibrio attentamente calibrato tra la capacità di eseguire task intensivi e la necessità di mantenere margini di sicurezza per situazioni impreviste o per l'esecuzione di task di emergenza.

L'allocazione delle risorse in SpaceOBC2 segue una strategia differenziata che riflette l'importanza relativa e l'intensità computazionale dei vari task. Il task di controllo propulsori, con la sua richiesta di tre risorse, rappresenta il picco di utilizzo, seguito dai task di inizializzazione, comunicazione, controllo, analisi e sicurezza che richiedono due risorse ciascuno. I task di sincronizzazione e monitoraggio, pur essendo critici, operano con una singola risorsa, riflettendo la loro natura più leggera dal punto di vista computazionale ma non meno importante dal punto di vista funzionale.

---

## 3. Architettura Modulare dei Servizi

L'architettura di SpaceOBC2 si articola in sei servizi principali, ciascuno con responsabilità ben definite che riflettono i domini funzionali critici per le operazioni spaziali con capacità propulsive.

Il CoreService mantiene il suo ruolo fondamentale di base operativa del sistema. Attraverso i task INIT_CORE e COMM_PROTO, questo servizio stabilisce le fondamenta su cui si costruisce l'intera operatività del sistema. L'inizializzazione core in SpaceOBC2 ha una durata di dieci unità temporali, leggermente inferiore rispetto ad altre configurazioni, riflettendo un'ottimizzazione del processo di avvio che permette di raggiungere più rapidamente lo stato operativo. La configurazione del protocollo di comunicazione, con la sua durata di dodici unità e l'allocazione di due risorse, garantisce l'establishment di canali di comunicazione robusti necessari per coordinare le operazioni propulsive con le stazioni di terra.

Il ControlService in SpaceOBC2 gestisce le operazioni di controllo attraverso due task strettamente coordinati. Il task CTRL_EXEC è configurato per essere eseguito due volte con intervalli di quattro unità temporali, un pattern che fornisce controllo periodico con frequenza elevata. La possibilità di eseguire fino a due istanze simultanee di questo task riflette la necessità di gestire molteplici aspetti del controllo in parallelo. Il task SYNC_PROC, con le sue due ripetizioni ogni tre unità temporali, opera in stretta coordinazione con il controllo esecutivo, garantendo che tutti i sottosistemi mantengano una visione coerente dello stato del sistema anche durante le fasi dinamiche delle operazioni propulsive.

L'AnalysisService fornisce le capacità analitiche necessarie per valutare lo stato del sistema e validare i dati operativi. Il task ANALYSIS_FULL, con la sua durata sostanziale di quattordici unità temporali e l'allocazione di due risorse, esegue un'analisi approfondita che è particolarmente critica prima di operazioni propulsive. Il task VERIFY_QUICK, con una durata ottimizzata di cinque unità temporali, fornisce una validazione rapida che permette al sistema di procedere tempestivamente con le operazioni successive una volta confermata l'integrità dei dati e lo stato nominale del sistema.

Il MonitorService assume un'importanza particolare in SpaceOBC2 grazie alla sua attivazione precoce. Il task MONITOR_SYS inizia solo due unità temporali dopo l'avvio dell'inizializzazione core, molto prima rispetto ad altre configurazioni. Questa attivazione precoce è intenzionale e riflette la necessità di avere sorveglianza continua del sistema fin dalle prime fasi operative, particolarmente importante quando si gestiscono operazioni propulsive che potrebbero avere impatti significativi sullo stato del veicolo. La capacità di eseguire fino a tre istanze simultanee di questo task fornisce ridondanza nel monitoraggio, aumentando la probabilità di rilevare tempestivamente eventuali anomalie.

Il SafeService gestisce tutti gli aspetti relativi alla sicurezza operativa attraverso il task SAFE_DIR. Questo task, con una durata di otto unità temporali e l'allocazione di due risorse, può essere attivato attraverso due percorsi distinti: dal monitoraggio del sistema o dal controllo esecutivo. Questa duplice possibilità di attivazione garantisce che le procedure di sicurezza possano essere innescate sia in risposta a anomalie rilevate dal monitoraggio sia come parte di una sequenza pianificata di operazioni di controllo.

Il ThrusterService rappresenta l'elemento distintivo e più critico di SpaceOBC2. Questo servizio, attraverso il task THRUSTER_CTRL, gestisce tutte le operazioni relative al controllo dei propulsori del veicolo spaziale. La configurazione di questo task riflette la sua natura critica: richiede tre risorse computazionali, il massimo tra tutti i task del sistema, ha una durata breve di tre unità temporali per permettere risposte rapide, può essere ripetuto una volta con intervallo di tre unità, e permette l'esecuzione di due istanze simultanee per gestire potenzialmente molteplici gruppi di propulsori. Il task può essere attivato attraverso due percorsi: dalla verifica rapida, che rappresenta il percorso nominale dopo la validazione dello stato del sistema, o dal monitoraggio, che rappresenta un percorso alternativo basato sulla sorveglianza continua.

---

## 4. Descrizione Dettagliata dei Task Operativi

Il task INIT_CORE in SpaceOBC2 esegue l'inizializzazione fondamentale del sistema in dieci unità temporali, utilizzando due risorse computazionali. Questa durata ottimizzata rispetto ad altre configurazioni riflette un processo di avvio efficiente che permette di raggiungere rapidamente lo stato operativo necessario per le operazioni successive. Durante la sua esecuzione, INIT_CORE configura i componenti essenziali del sistema, inizializza le strutture dati fondamentali, verifica l'integrità dei sottosistemi critici e prepara l'ambiente per le operazioni di controllo e propulsione. L'allocazione di due risorse permette di parallelizzare alcune operazioni di inizializzazione, accelerando il processo complessivo.

Il task COMM_PROTO configura i protocolli di comunicazione in dodici unità temporali, utilizzando due risorse. Questo task è particolarmente critico in SpaceOBC2 perché le operazioni propulsive richiedono comunicazioni affidabili con le stazioni di terra per la conferma dei comandi e la trasmissione dei dati telemetrici. La configurazione include l'establishment dei canali di comunicazione primari e di backup, l'inizializzazione dei buffer di trasmissione e ricezione, la configurazione dei protocolli di error correction, e la verifica della connettività end-to-end.

Il task CTRL_EXEC rappresenta il cuore del sistema di controllo in tempo reale. Con una durata di tre unità temporali, questo task esegue operazioni di controllo rapide ma intensive, utilizzando due risorse computazionali. La configurazione per due ripetizioni con intervalli di quattro unità temporali crea un pattern di esecuzione periodica che garantisce controllo continuo durante le fasi critiche delle operazioni. La possibilità di eseguire due istanze simultanee permette di gestire in parallelo diversi aspetti del controllo, come il controllo di assetto e il controllo termico, o di implementare strategie di controllo ridondanti per aumentare l'affidabilità.

Il task SYNC_PROC opera in stretta coordinazione con CTRL_EXEC, iniziando due unità temporali dopo ogni avvio del controllo esecutivo. Con una durata di due unità temporali e l'utilizzo di una singola risorsa, questo task esegue le operazioni di sincronizzazione necessarie per garantire che tutti i sottosistemi mantengano una visione coerente dello stato globale. Le due ripetizioni con intervalli di tre unità temporali, leggermente sfalsate rispetto alle ripetizioni di CTRL_EXEC, creano un pattern di sincronizzazione che copre efficacemente l'intera finestra operativa.

Il task ANALYSIS_FULL esegue un'analisi completa e approfondita dello stato del sistema in quattordici unità temporali, utilizzando due risorse. Questa analisi è particolarmente importante prima di operazioni propulsive, poiché verifica che tutti i sottosistemi siano in stato nominale, che i parametri operativi siano entro i limiti accettabili, e che non ci siano anomalie che potrebbero compromettere la sicurezza delle manovre. L'analisi include la valutazione dei dati telemetrici, la verifica dell'integrità dei sistemi di propulsione, l'analisi delle risorse disponibili (propellente, energia, capacità computazionale), e la validazione dei parametri di missione.

Il task VERIFY_QUICK fornisce una capacità di verifica rapida in cinque unità temporali, utilizzando due risorse. Questa durata ridotta rispetto ad altre configurazioni riflette l'ottimizzazione del processo di verifica per permettere una transizione più rapida alle operazioni successive. La verifica include controlli di integrità mirati, validazione dei risultati dell'analisi completa, e conferma che il sistema sia pronto per procedere con le operazioni pianificate, particolarmente quelle che coinvolgono i propulsori.

Il task MONITOR_SYS fornisce sorveglianza continua del sistema per tredici unità temporali, utilizzando una singola risorsa. L'attivazione precoce di questo task, solo due unità dopo l'avvio dell'inizializzazione, garantisce che il sistema sia sotto sorveglianza fin dalle prime fasi operative. La capacità di eseguire fino a tre istanze simultanee permette di implementare strategie di monitoraggio ridondante, dove diverse istanze possono concentrarsi su aspetti diversi del sistema o fornire conferma incrociata delle rilevazioni.

Il task SAFE_DIR gestisce l'implementazione delle direttive di sicurezza in otto unità temporali, utilizzando due risorse. Questo task può essere attivato in risposta a anomalie rilevate dal monitoraggio o come parte di una sequenza pianificata di operazioni. Durante la sua esecuzione, SAFE_DIR implementa le procedure necessarie per portare il sistema in uno stato sicuro, che potrebbe includere la disattivazione di sottosistemi non essenziali, la configurazione di modalità operative ridotte, o la preparazione per operazioni di emergenza.

Il task THRUSTER_CTRL rappresenta il componente più critico e distintivo di SpaceOBC2. Con una durata di tre unità temporali e l'utilizzo di tre risorse computazionali, questo task esegue tutte le operazioni necessarie per il controllo dei propulsori. La breve durata permette risposte rapide alle necessità di manovra, mentre l'elevata allocazione di risorse riflette l'intensità computazionale delle operazioni di controllo propulsivo, che includono calcoli di traiettoria in tempo reale, determinazione dei parametri di accensione, monitoraggio della performance dei propulsori, e implementazione di algoritmi di controllo feedback. La configurazione per una ripetizione con intervallo di tre unità temporali permette di eseguire manovre multiple o correzioni successive. La possibilità di due istanze simultanee permette di gestire gruppi di propulsori indipendenti o di implementare strategie di controllo ridondanti.

---

## 5. Sistema di Vincoli Temporali e Dipendenze

Il sistema di vincoli temporali in SpaceOBC2 implementa una rete complessa di dipendenze che riflette la natura critica delle operazioni propulsive e la necessità di coordinazione precisa tra i vari task.

La catena di inizializzazione inizia con una relazione interessante tra INIT_CORE e COMM_PROTO, dove il protocollo di comunicazione può iniziare tre unità temporali dopo l'avvio dell'inizializzazione. Questo ritardo permette all'inizializzazione di progredire sufficientemente per preparare l'ambiente necessario alla configurazione delle comunicazioni. Parallelamente, il monitoraggio del sistema può iniziare molto precocemente, solo due unità dopo l'avvio dell'inizializzazione, garantendo sorveglianza fin dalle prime fasi operative.

La catena di controllo mostra una dipendenza sequenziale dove CTRL_EXEC dipende da COMM_PROTO con un ritardo di quattro unità temporali. Questo vincolo garantisce che i protocolli di comunicazione siano sufficientemente configurati prima che inizi il controllo esecutivo, permettendo al sistema di controllo di comunicare efficacemente con le stazioni di terra e con i vari sottosistemi. Il task SYNC_PROC segue CTRL_EXEC con un ritardo di due unità, creando un pattern di controllo seguito da sincronizzazione che si ripete durante l'intera finestra operativa.

La catena di analisi presenta una caratteristica interessante con due percorsi possibili per l'avvio di ANALYSIS_FULL. Il primo percorso parte direttamente da INIT_CORE con un ritardo di sei unità temporali, permettendo un avvio relativamente precoce dell'analisi. Il secondo percorso parte da SYNC_PROC con un ritardo di due unità, creando una dipendenza dalla sincronizzazione che garantisce che l'analisi operi su dati sincronizzati. Questa duplice possibilità aumenta la flessibilità operativa, permettendo al sistema di adattarsi a diverse situazioni operative.

La verifica rapida dipende dall'analisi completa con un ritardo di quattro unità temporali, un intervallo che permette all'analisi di progredire sufficientemente per generare risultati preliminari che possono essere verificati. Questo pattern di analisi seguita da verifica garantisce che il sistema proceda con le operazioni successive solo dopo aver confermato l'integrità dei dati e lo stato nominale.

Il controllo dei propulsori, elemento critico di SpaceOBC2, può essere attivato attraverso due percorsi distinti. Il percorso nominale parte dalla verifica rapida con un ritardo di tre unità temporali, rappresentando la sequenza standard dove il sistema completa l'analisi, verifica i risultati, e poi procede con le operazioni propulsive. Il percorso alternativo parte dal monitoraggio con un ritardo di otto unità temporali, rappresentando una possibilità di attivazione basata sulla sorveglianza continua del sistema. Questa duplice possibilità di attivazione aumenta significativamente la robustezza operativa, garantendo che il controllo propulsori possa essere attivato anche se il percorso nominale dovesse incontrare problemi.

La gestione della sicurezza presenta anch'essa due percorsi di attivazione. Il primo parte dal monitoraggio con un ritardo di sei unità temporali, rappresentando l'attivazione delle procedure di sicurezza in risposta a anomalie rilevate dalla sorveglianza continua. Il secondo percorso parte dal controllo esecutivo con un ritardo sostanziale di dodici unità temporali, rappresentando l'attivazione pianificata delle procedure di sicurezza come parte della sequenza operativa normale. Questa configurazione garantisce che le direttive di sicurezza possano essere implementate sia in modo reattivo che proattivo.

---

## 6. Dinamica Operativa e Flusso di Esecuzione

L'esecuzione di SpaceOBC2 inizia all'istante zero con l'avvio di INIT_CORE, che procede per dieci unità temporali utilizzando due risorse. Questo lascia otto risorse disponibili per altre operazioni che potrebbero essere necessarie durante la fase di inizializzazione.

All'istante due, avendo soddisfatto il vincolo di ritardo di due unità da INIT_CORE, può iniziare MONITOR_SYS. Questo avvio precoce del monitoraggio è una caratteristica distintiva di SpaceOBC2, garantendo sorveglianza continua fin dalle prime fasi operative. Il monitoraggio procederà per tredici unità temporali, fornendo copertura estesa durante le fasi critiche delle operazioni.

All'istante tre, avendo soddisfatto il vincolo di ritardo di tre unità da INIT_CORE, può iniziare COMM_PROTO. Questo task procede per dodici unità temporali utilizzando due risorse, configurando tutti i protocolli di comunicazione necessari per le operazioni successive.

All'istante sei, avendo soddisfatto il vincolo di ritardo di sei unità da INIT_CORE, potrebbe iniziare ANALYSIS_FULL attraverso il primo percorso di attivazione. Tuttavia, il sistema potrebbe anche attendere il percorso alternativo attraverso SYNC_PROC, a seconda della strategia operativa implementata.

All'istante sette, quattro unità dopo l'avvio di COMM_PROTO (istante tre), può iniziare CTRL_EXEC per la sua prima esecuzione. Questo task procede per tre unità temporali utilizzando due risorse, eseguendo operazioni di controllo critiche.

All'istante nove, due unità dopo l'avvio della prima esecuzione di CTRL_EXEC, può iniziare SYNC_PROC per la sua prima esecuzione. Questo task procede per due unità temporali, sincronizzando i vari sottosistemi.

All'istante undici, quattro unità dopo la prima esecuzione di CTRL_EXEC (istante sette), può iniziare la seconda esecuzione di CTRL_EXEC. Questo crea un pattern di controllo periodico che continua durante la finestra operativa.

All'istante undici, due unità dopo l'avvio di SYNC_PROC (istante nove), potrebbe iniziare ANALYSIS_FULL attraverso il secondo percorso di attivazione. Questo percorso garantisce che l'analisi operi su dati sincronizzati.

Assumendo che ANALYSIS_FULL inizi all'istante undici, quattro unità dopo il suo avvio (istante quindici) può iniziare VERIFY_QUICK. Questo task procede per cinque unità temporali, completando la sua esecuzione intorno all'istante venti.

All'istante diciotto, tre unità dopo l'avvio di VERIFY_QUICK (istante quindici), può iniziare THRUSTER_CTRL per la sua prima esecuzione. Questo momento rappresenta un punto critico nell'operazione del sistema, dove il controllo dei propulsori viene attivato dopo aver confermato che il sistema è in stato nominale. Il task procede per tre unità temporali utilizzando tre risorse, il massimo tra tutti i task.

All'istante otto, sei unità dopo l'avvio di MONITOR_SYS (istante due), può iniziare SAFE_DIR attraverso il primo percorso di attivazione. Alternativamente, all'istante diciannove, dodici unità dopo l'avvio della prima esecuzione di CTRL_EXEC (istante sette), può iniziare SAFE_DIR attraverso il secondo percorso.

All'istante dieci, otto unità dopo l'avvio di MONITOR_SYS (istante due), potrebbe iniziare THRUSTER_CTRL attraverso il percorso alternativo, se necessario per operazioni propulsive precoci.

La seconda esecuzione di THRUSTER_CTRL può iniziare tre unità dopo la prima esecuzione, permettendo manovre multiple o correzioni successive. La possibilità di eseguire due istanze simultanee permette di gestire operazioni propulsive complesse che coinvolgono molteplici gruppi di propulsori.

Verso la fine della finestra operativa, i vari task completano le loro esecuzioni, con il sistema che garantisce che tutte le operazioni critiche siano completate entro le trentatré unità temporali disponibili.

---

## 7. Considerazioni Finali

Il sistema SpaceOBC2 rappresenta una configurazione sofisticata progettata specificamente per missioni che richiedono capacità propulsive avanzate. L'integrazione del ThrusterService come componente distintivo riflette l'importanza del controllo propulsivo per manovre orbitali, correzioni di traiettoria e operazioni di assetto. La disponibilità di dieci risorse computazionali fornisce la capacità necessaria per gestire le operazioni intensive del controllo propulsori, che richiede tre risorse, il massimo tra tutti i task del sistema.

L'architettura di SpaceOBC2 enfatizza la robustezza attraverso molteplici percorsi di attivazione per i task critici. Il controllo propulsori può essere attivato sia dalla verifica rapida che dal monitoraggio, garantendo flessibilità operativa. Similmente, le direttive di sicurezza possono essere attivate sia dal monitoraggio che dal controllo esecutivo, permettendo risposte sia reattive che proattive a situazioni critiche.

Il monitoraggio precoce, attivato solo due unità dopo l'inizializzazione, fornisce sorveglianza continua fin dalle prime fasi operative, particolarmente importante quando si gestiscono operazioni propulsive che potrebbero avere impatti significativi sullo stato del veicolo. La capacità di eseguire fino a tre istanze simultanee del monitoraggio aumenta la ridondanza e l'affidabilità del sistema di sorveglianza.

La configurazione dei task ripetitivi, con CTRL_EXEC ripetuto due volte ogni quattro unità, SYNC_PROC ripetuto due volte ogni tre unità, e THRUSTER_CTRL ripetuto una volta ogni tre unità, crea un pattern di esecuzione che garantisce controllo, sincronizzazione e capacità propulsiva continui durante l'intera finestra operativa.
