# Manuale di Sistema: SpaceOBC1
## Documento di Specifica e Configurazione

---

## 1. Introduzione

Il presente documento descrive la configurazione e l'architettura del sistema **SpaceOBC1**, un sistema di controllo per computer di bordo spaziale (On-Board Computer). Il sistema è progettato per gestire operazioni critiche attraverso una serie di servizi coordinati e task interdipendenti, garantendo l'esecuzione ordinata e temporizzata delle attività di bordo.

---

## 2. Parametri Globali del Sistema

Il sistema SpaceOBC1 è configurato con i seguenti parametri operativi fondamentali:

### 2.1 Identificazione
- **Nome Sistema**: SpaceOBC1
- **Identificativo**: Sistema di controllo principale per operazioni di bordo

### 2.2 Finestra Temporale di Esecuzione
- **Tempo di Inizio (h_start)**: 0 unità temporali
- **Tempo di Fine (h_end)**: 33 unità temporali
- **Durata Totale**: 33 unità temporali

La finestra temporale definisce l'intervallo durante il quale tutte le operazioni del sistema devono essere completate. Questo vincolo è critico per garantire la sincronizzazione con le operazioni orbitali e di missione.

### 2.3 Risorse Computazionali
- **Numero Massimo di Risorse (r_max)**: 8 unità

Questo parametro definisce il numero massimo di risorse computazionali disponibili simultaneamente per l'esecuzione dei task. Il sistema può eseguire fino a 8 task in parallelo, a condizione che le dipendenze temporali siano rispettate.

---

## 3. Architettura dei Servizi

Il sistema SpaceOBC1 è organizzato in **7 servizi principali**, ciascuno responsabile di specifiche funzionalità operative. Ogni servizio coordina uno o più task correlati.

### 3.1 CoreService (Servizio 1)
**Funzione**: Gestione delle operazioni fondamentali del sistema

**Task Associati**:
- Task 1: INIT_CORE (Inizializzazione Core)
- Task 2: COMM_PROTO (Protocollo di Comunicazione)

Questo servizio è responsabile dell'inizializzazione del sistema e della configurazione dei protocolli di comunicazione di base. È il servizio fondamentale da cui dipendono molte altre operazioni.

### 3.2 ControlSyncService (Servizio 2)
**Funzione**: Controllo ed esecuzione sincronizzata

**Task Associati**:
- Task 3: CTRL_EXEC (Esecuzione Controllo)
- Task 4: SYNC_PROC (Processo di Sincronizzazione)

Gestisce le operazioni di controllo in tempo reale e la sincronizzazione tra i vari sottosistemi del computer di bordo.

### 3.3 AnalysisService (Servizio 3)
**Funzione**: Analisi e verifica dei dati

**Task Associati**:
- Task 5: ANALYSIS_FULL (Analisi Completa)
- Task 6: VERIFY_QUICK (Verifica Rapida)

Responsabile dell'analisi approfondita dei dati di sistema e delle verifiche di integrità rapide per garantire il corretto funzionamento.

### 3.4 ProcessingService (Servizio 4)
**Funzione**: Elaborazione dati in pipeline

**Task Associati**:
- Task 7: PREPROCESS_SVC (Pre-elaborazione)
- Task 8: POSTPROCESS_SVC (Post-elaborazione)

Gestisce la pipeline di elaborazione dati, dalla fase di pre-processing alla fase di post-processing.

### 3.5 OrbitService (Servizio 5)
**Funzione**: Gestione operazioni orbitali

**Task Associati**:
- Task 9: ORBIT_CTRL (Controllo Orbitale)
- Task 10: ORBIT_MGMT (Gestione Orbitale)

Coordina tutte le operazioni relative al controllo e alla gestione dell'orbita del veicolo spaziale.

### 3.6 MonitorService (Servizio 6)
**Funzione**: Monitoraggio continuo del sistema

**Task Associati**:
- Task 11: MONITOR_SYS (Monitoraggio Sistema)

Fornisce capacità di monitoraggio continuo dello stato del sistema, con possibilità di esecuzione multipla (fino a 3 istanze simultanee).

### 3.7 SafeService (Servizio 7)
**Funzione**: Gestione modalità sicura

**Task Associati**:
- Task 12: SAFE_DIR (Direttive di Sicurezza)

Gestisce le procedure di sicurezza e le direttive per la modalità safe del sistema.

---

## 4. Specifiche dei Task

Il sistema comprende **12 task** con caratteristiche operative specifiche. Di seguito la descrizione dettagliata di ciascun task.

### 4.1 Task 1: INIT_CORE
**Inizializzazione del Core di Sistema**

- **Identificativo**: 1
- **Sigla**: initcor
- **Durata**: 14 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0 (esecuzione singola)
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Questo task esegue l'inizializzazione fondamentale del sistema, configurando i componenti core necessari per le operazioni successive. È un task critico che deve completarsi prima di molte altre operazioni.

### 4.2 Task 2: COMM_PROTO
**Configurazione Protocollo di Comunicazione**

- **Identificativo**: 2
- **Sigla**: comprt
- **Durata**: 16 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Configura e inizializza i protocolli di comunicazione necessari per l'interfacciamento con i sottosistemi e le stazioni di terra.

### 4.3 Task 3: CTRL_EXEC
**Esecuzione Controllo**

- **Identificativo**: 3
- **Sigla**: ctlexe
- **Durata**: 3 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 3 ripetizioni
- **Ritardo Ripetizioni (rd)**: 8 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 1 istanza

Task di controllo ad alta frequenza che si ripete 3 volte con intervalli di 8 unità temporali. Gestisce operazioni di controllo critiche in tempo reale.

### 4.4 Task 4: SYNC_PROC
**Processo di Sincronizzazione**

- **Identificativo**: 4
- **Sigla**: synprc
- **Durata**: 2 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 3 ripetizioni
- **Ritardo Ripetizioni (rd)**: 8 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 1 istanza

Sincronizza i vari sottosistemi, eseguendosi in modo coordinato con il task di controllo (CTRL_EXEC).

### 4.5 Task 5: ANALYSIS_FULL
**Analisi Completa del Sistema**

- **Identificativo**: 5
- **Sigla**: anlful
- **Durata**: 14 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Esegue un'analisi approfondita e completa dello stato del sistema, dei dati acquisiti e delle performance operative.

### 4.6 Task 6: VERIFY_QUICK
**Verifica Rapida**

- **Identificativo**: 6
- **Sigla**: verqck
- **Durata**: 7 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Esegue verifiche rapide di integrità e validazione dei risultati dell'analisi completa. Questo task è un punto di diramazione critico nel flusso operativo.

### 4.7 Task 7: PREPROCESS_SVC
**Pre-elaborazione Dati**

- **Identificativo**: 7
- **Sigla**: presvc
- **Durata**: 13 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Esegue la fase di pre-elaborazione dei dati, preparandoli per il processing successivo.

### 4.8 Task 8: POSTPROCESS_SVC
**Post-elaborazione Dati**

- **Identificativo**: 8
- **Sigla**: pstsvc
- **Durata**: 12 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Completa la pipeline di elaborazione dati con operazioni di post-processing e finalizzazione.

### 4.9 Task 9: ORBIT_CTRL
**Controllo Orbitale**

- **Identificativo**: 9
- **Sigla**: orbctl
- **Durata**: 13 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Gestisce le operazioni di controllo dell'orbita, inclusi calcoli di traiettoria e manovre orbitali.

### 4.10 Task 10: ORBIT_MGMT
**Gestione Orbitale**

- **Identificativo**: 10
- **Sigla**: orbmgt
- **Durata**: 14 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Coordina la gestione complessiva delle operazioni orbitali, interfacciandosi con i sistemi di navigazione e propulsione.

### 4.11 Task 11: MONITOR_SYS
**Monitoraggio Sistema**

- **Identificativo**: 11
- **Sigla**: monsys
- **Durata**: 12 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 3 istanze

Task di monitoraggio che può essere eseguito fino a 3 volte in parallelo, fornendo capacità di sorveglianza ridondante del sistema.

### 4.12 Task 12: SAFE_DIR
**Direttive di Sicurezza**

- **Identificativo**: 12
- **Sigla**: safdir
- **Durata**: 12 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Gestisce l'implementazione delle direttive di sicurezza e le procedure di safe mode.

---

## 5. Vincoli di Precedenza e Dipendenze Temporali

Il sistema implementa una serie di **vincoli di precedenza start-to-start**, che definiscono le relazioni temporali tra i task. Questi vincoli garantiscono che i task vengano eseguiti nell'ordine corretto e con i ritardi appropriati.

### 5.1 Principio dei Vincoli Start-to-Start

Un vincolo start-to-start specifica che un task destinazione può iniziare solo dopo che sia trascorso un certo ritardo dall'inizio del task sorgente. Il parametro `wait_all: false` indica che non è necessario attendere il completamento del task sorgente, ma solo che sia trascorso il ritardo specificato dal suo avvio.

### 5.2 Catena di Inizializzazione Primaria

#### Vincolo 1: INIT_CORE → CTRL_EXEC
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 3 (CTRL_EXEC)
- **Ritardo**: 2 unità temporali
- **Descrizione**: Il controllo esecutivo può iniziare 2 unità temporali dopo l'avvio dell'inizializzazione core.

#### Vincolo 2: COMM_PROTO → CTRL_EXEC
- **Task Sorgente**: Task 2 (COMM_PROTO)
- **Task Destinazione**: Task 3 (CTRL_EXEC)
- **Ritardo**: 2 unità temporali
- **Descrizione**: Il controllo esecutivo dipende anche dal protocollo di comunicazione, con lo stesso ritardo di 2 unità.

#### Vincolo 3: INIT_CORE → ANALYSIS_FULL
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 5 (ANALYSIS_FULL)
- **Ritardo**: 4 unità temporali
- **Descrizione**: L'analisi completa può iniziare 4 unità temporali dopo l'inizializzazione core.

#### Vincolo 4: COMM_PROTO → ANALYSIS_FULL
- **Task Sorgente**: Task 2 (COMM_PROTO)
- **Task Destinazione**: Task 5 (ANALYSIS_FULL)
- **Ritardo**: 4 unità temporali
- **Descrizione**: L'analisi completa dipende anche dal protocollo di comunicazione.

### 5.3 Catena di Controllo e Sincronizzazione

#### Vincolo 5: CTRL_EXEC → SYNC_PROC
- **Task Sorgente**: Task 3 (CTRL_EXEC)
- **Task Destinazione**: Task 4 (SYNC_PROC)
- **Ritardo**: 2 unità temporali
- **Descrizione**: Il processo di sincronizzazione segue l'esecuzione del controllo con un ritardo di 2 unità.

### 5.4 Catena di Analisi e Verifica

#### Vincolo 6: ANALYSIS_FULL → VERIFY_QUICK
- **Task Sorgente**: Task 5 (ANALYSIS_FULL)
- **Task Destinazione**: Task 6 (VERIFY_QUICK)
- **Ritardo**: 8 unità temporali
- **Descrizione**: La verifica rapida può iniziare 8 unità temporali dopo l'avvio dell'analisi completa.

### 5.5 Punto di Diramazione: VERIFY_QUICK

Il task VERIFY_QUICK rappresenta un punto di diramazione critico nel flusso operativo, abilitando tre percorsi paralleli:

#### Vincolo 7: VERIFY_QUICK → PREPROCESS_SVC
- **Task Sorgente**: Task 6 (VERIFY_QUICK)
- **Task Destinazione**: Task 7 (PREPROCESS_SVC)
- **Ritardo**: 6 unità temporali
- **Descrizione**: La pre-elaborazione inizia 6 unità dopo la verifica.

#### Vincolo 8: VERIFY_QUICK → ORBIT_CTRL
- **Task Sorgente**: Task 6 (VERIFY_QUICK)
- **Task Destinazione**: Task 9 (ORBIT_CTRL)
- **Ritardo**: 6 unità temporali
- **Descrizione**: Il controllo orbitale può iniziare in parallelo alla pre-elaborazione.

#### Vincolo 9: VERIFY_QUICK → ORBIT_MGMT
- **Task Sorgente**: Task 6 (VERIFY_QUICK)
- **Task Destinazione**: Task 10 (ORBIT_MGMT)
- **Ritardo**: 6 unità temporali
- **Descrizione**: La gestione orbitale inizia anch'essa dopo la verifica.

### 5.6 Catena di Elaborazione

#### Vincolo 10: PREPROCESS_SVC → POSTPROCESS_SVC
- **Task Sorgente**: Task 7 (PREPROCESS_SVC)
- **Task Destinazione**: Task 8 (POSTPROCESS_SVC)
- **Ritardo**: 2 unità temporali
- **Descrizione**: La post-elaborazione segue la pre-elaborazione con un breve ritardo.

### 5.7 Attivazione Monitoraggio

#### Vincolo 11: INIT_CORE → MONITOR_SYS
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 11 (MONITOR_SYS)
- **Ritardo**: 10 unità temporali
- **Descrizione**: Il monitoraggio sistema inizia 10 unità temporali dopo l'inizializzazione core.

---

## 6. Flusso Operativo del Sistema

### 6.1 Fase di Inizializzazione (T=0 a T≈16)

Il sistema inizia con l'esecuzione parallela di:
- **INIT_CORE** (14 unità di durata)
- **COMM_PROTO** (16 unità di durata)

Questi due task fondamentali preparano il sistema per tutte le operazioni successive.

### 6.2 Fase di Controllo Primario (T≈2 a T≈13)

Dopo 2 unità dall'inizio:
- **CTRL_EXEC** inizia (3 unità di durata, ripetuto 3 volte ogni 8 unità)
- Seguito da **SYNC_PROC** (2 unità di durata, ripetuto 3 volte ogni 8 unità)

### 6.3 Fase di Analisi (T≈4 a T≈25)

Dopo 4 unità dall'inizio:
- **ANALYSIS_FULL** inizia (14 unità di durata)
- Dopo 8 unità dall'inizio dell'analisi: **VERIFY_QUICK** (7 unità di durata)

### 6.4 Fase di Operazioni Parallele (T≈17 in poi)

Dopo la verifica rapida, il sistema si dirama in tre percorsi paralleli:

**Percorso 1 - Elaborazione Dati:**
- PREPROCESS_SVC (13 unità)
- POSTPROCESS_SVC (12 unità)

**Percorso 2 - Controllo Orbitale:**
- ORBIT_CTRL (13 unità)

**Percorso 3 - Gestione Orbitale:**
- ORBIT_MGMT (14 unità)

### 6.5 Monitoraggio Continuo (T≈10 in poi)

- **MONITOR_SYS** inizia 10 unità dopo l'inizializzazione e può essere eseguito fino a 3 volte in parallelo.

### 6.6 Servizio di Sicurezza

- **SAFE_DIR** non ha vincoli di precedenza espliciti e può essere attivato quando necessario per gestire situazioni di emergenza.

---

## 7. Caratteristiche Tecniche

### 7.1 Gestione delle Risorse

Il sistema dispone di 8 risorse computazionali massime. La maggior parte dei task richiede 1 risorsa, permettendo un alto grado di parallelismo. Il task MONITOR_SYS può utilizzare fino a 3 risorse simultaneamente per garantire ridondanza.

### 7.2 Task Ripetitivi

Due task sono configurati per esecuzioni ripetute:
- **CTRL_EXEC**: 3 ripetizioni ogni 8 unità temporali
- **SYNC_PROC**: 3 ripetizioni ogni 8 unità temporali

Questo pattern garantisce controllo e sincronizzazione periodici durante l'intera finestra operativa.

### 7.3 Vincoli Temporali Globali

Tutte le operazioni devono completarsi entro 33 unità temporali dall'inizio. Questo vincolo richiede un'attenta pianificazione e schedulazione per garantire che tutti i task critici vengano completati in tempo.

---

## 8. Considerazioni Operative

### 8.1 Criticità

I task più critici per l'avvio del sistema sono:
1. **INIT_CORE** - Fondamentale per tutte le operazioni
2. **COMM_PROTO** - Necessario per le comunicazioni
3. **VERIFY_QUICK** - Punto di diramazione per operazioni parallele

### 8.2 Parallelismo

Il sistema è progettato per sfruttare il parallelismo in diverse fasi:
- Inizializzazione parallela (INIT_CORE e COMM_PROTO)
- Operazioni parallele post-verifica (elaborazione, controllo orbitale, gestione orbitale)
- Monitoraggio ridondante (fino a 3 istanze di MONITOR_SYS)

### 8.3 Robustezza

La presenza del SafeService e la capacità di monitoraggio multiplo garantiscono robustezza operativa e capacità di gestione di situazioni anomale.

---

## 9. Glossario dei Termini

- **h_start/h_end**: Inizio e fine della finestra temporale operativa
- **r_max**: Numero massimo di risorse computazionali disponibili
- **dur**: Durata di esecuzione di un task
- **res_q**: Quantità di risorse richieste da un task
- **rc**: Conteggio delle ripetizioni di un task
- **rd**: Ritardo tra le ripetizioni di un task
- **max_c**: Numero massimo di istanze concorrenti di un task
- **start_constraints**: Vincoli di precedenza start-to-start tra task
- **wait_all**: Flag che indica se attendere il completamento del task sorgente

---

## 10. Conclusioni

Il sistema SpaceOBC1 rappresenta un'architettura complessa e ben strutturata per la gestione di operazioni di bordo spaziali. La combinazione di servizi specializzati, task ben definiti e vincoli temporali precisi garantisce un'esecuzione coordinata e affidabile delle operazioni critiche entro i vincoli temporali e di risorse disponibili.

La modularità del design permette manutenibilità e possibili estensioni future, mentre i meccanismi di monitoraggio e sicurezza garantiscono robustezza operativa in ambiente spaziale.
