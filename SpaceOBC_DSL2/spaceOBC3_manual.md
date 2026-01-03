# Manuale di Sistema: SpaceOBC3
## Documento di Specifica e Configurazione

---

## 1. Introduzione

Il presente documento descrive la configurazione e l'architettura del sistema **SpaceOBC3**, un sistema di controllo per computer di bordo spaziale (On-Board Computer). Il sistema è progettato per gestire operazioni critiche con particolare enfasi sulla gestione orbitale, l'elaborazione dati e il downlink delle informazioni verso le stazioni di terra.

---

## 2. Parametri Globali del Sistema

Il sistema SpaceOBC3 è configurato con i seguenti parametri operativi fondamentali:

### 2.1 Identificazione
- **Nome Sistema**: SpaceOBC3
- **Identificativo**: Sistema di controllo con capacità avanzate di gestione dati

### 2.2 Finestra Temporale di Esecuzione
- **Tempo di Inizio (h_start)**: 0 unità temporali
- **Tempo di Fine (h_end)**: 33 unità temporali
- **Durata Totale**: 33 unità temporali

### 2.3 Risorse Computazionali
- **Numero Massimo di Risorse (r_max)**: 12 unità

Il sistema dispone di 12 risorse computazionali, il numero più elevato tra i tre sistemi SpaceOBC, permettendo il massimo parallelismo nelle operazioni.

---

## 3. Architettura dei Servizi

Il sistema SpaceOBC3 è organizzato in **6 servizi principali**:

### 3.1 CoreService (Servizio 1)
**Funzione**: Gestione delle operazioni fondamentali del sistema

**Task Associati**:
- Task 1: INIT_CORE (Inizializzazione Core)
- Task 2: COMM_PROTO (Protocollo di Comunicazione)

Servizio fondamentale per l'inizializzazione e la configurazione dei protocolli di base.

### 3.2 ControlService (Servizio 2)
**Funzione**: Controllo esecutivo del sistema

**Task Associati**:
- Task 3: CTRL_EXEC (Esecuzione Controllo)

Gestisce le operazioni di controllo in tempo reale con esecuzioni ripetute.

### 3.3 OrbitService (Servizio 3)
**Funzione**: Gestione completa delle operazioni orbitali

**Task Associati**:
- Task 5: ORBIT_CTRL (Controllo Orbitale)
- Task 6: ORBIT_MGMT (Gestione Orbitale)

Servizio dedicato al controllo e alla gestione dell'orbita del veicolo spaziale.

### 3.4 ProcessingService (Servizio 4)
**Funzione**: Elaborazione dati in pipeline

**Task Associati**:
- Task 7: PREPROCESS_SVC (Pre-elaborazione)
- Task 8: POSTPROCESS_SVC (Post-elaborazione)

Gestisce l'intera pipeline di elaborazione dati.

### 3.5 MonitorService (Servizio 5)
**Funzione**: Monitoraggio e sincronizzazione

**Task Associati**:
- Task 4: SYNC_PROC (Processo di Sincronizzazione)
- Task 9: MONITOR_SYS (Monitoraggio Sistema)

Servizio che combina funzionalità di sincronizzazione e monitoraggio continuo.

### 3.6 DataService (Servizio 6)
**Funzione**: Gestione downlink dati

**Task Associati**:
- Task 10: DATA_DOWNLINK (Downlink Dati)

Servizio specializzato per la trasmissione dati verso le stazioni di terra, caratteristica distintiva di SpaceOBC3.

---

## 4. Specifiche dei Task

### 4.1 Task 1: INIT_CORE
**Inizializzazione del Core di Sistema**

- **Identificativo**: 1
- **Sigla**: initcor
- **Durata**: 14 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0 (esecuzione singola)
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Inizializzazione fondamentale del sistema con durata estesa.

### 4.2 Task 2: COMM_PROTO
**Configurazione Protocollo di Comunicazione**

- **Identificativo**: 2
- **Sigla**: comprt
- **Durata**: 16 unità temporali
- **Richiesta Risorse**: 3 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Configurazione protocolli con la massima allocazione di risorse (3 unità) per garantire comunicazioni robuste.

### 4.3 Task 3: CTRL_EXEC
**Esecuzione Controllo**

- **Identificativo**: 3
- **Sigla**: ctlexe
- **Durata**: 3 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 3 ripetizioni
- **Ritardo Ripetizioni (rd)**: 5 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 1 istanza

Task di controllo ripetuto 3 volte ogni 5 unità temporali.

### 4.4 Task 4: SYNC_PROC
**Processo di Sincronizzazione**

- **Identificativo**: 4
- **Sigla**: synprc
- **Durata**: 2 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 3 ripetizioni
- **Ritardo Ripetizioni (rd)**: 6 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 1 istanza

Sincronizzazione con intervalli di 6 unità temporali, ripetuta 3 volte.

### 4.5 Task 5: ORBIT_CTRL
**Controllo Orbitale**

- **Identificativo**: 5
- **Sigla**: orbctl
- **Durata**: 8 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Controllo attivo dell'orbita con calcoli di traiettoria e pianificazione manovre.

### 4.6 Task 6: ORBIT_MGMT
**Gestione Orbitale**

- **Identificativo**: 6
- **Sigla**: orbmgt
- **Durata**: 10 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Gestione complessiva delle operazioni orbitali.

### 4.7 Task 7: PREPROCESS_SVC
**Pre-elaborazione Dati**

- **Identificativo**: 7
- **Sigla**: presvc
- **Durata**: 9 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Fase di pre-elaborazione dei dati con durata ottimizzata.

### 4.8 Task 8: POSTPROCESS_SVC
**Post-elaborazione Dati**

- **Identificativo**: 8
- **Sigla**: pstsvc
- **Durata**: 11 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Completamento della pipeline di elaborazione dati.

### 4.9 Task 9: MONITOR_SYS
**Monitoraggio Sistema**

- **Identificativo**: 9
- **Sigla**: monsys
- **Durata**: 20 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Monitoraggio continuo con durata estesa (20 unità), la più lunga tra tutti i task.

### 4.10 Task 10: DATA_DOWNLINK
**Downlink Dati**

- **Identificativo**: 10
- **Sigla**: datadwn
- **Durata**: 5 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 1 ripetizione
- **Ritardo Ripetizioni (rd)**: 5 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 1 istanza

Task critico per la trasmissione dati verso terra, ripetuto una volta con intervallo di 5 unità.

---

## 5. Vincoli di Precedenza e Dipendenze Temporali

Il sistema implementa **13 vincoli di precedenza start-to-start**, con particolare attenzione all'uso del parametro **wait_all**:

### 5.1 Catena di Inizializzazione

#### Vincolo 1: INIT_CORE → CTRL_EXEC
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 3 (CTRL_EXEC)
- **Ritardo**: 2 unità temporali
- **Wait_all**: false
- **Descrizione**: Controllo può iniziare 2 unità dopo l'avvio dell'inizializzazione.

#### Vincolo 2: INIT_CORE → COMM_PROTO
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 2 (COMM_PROTO)
- **Ritardo**: 2 unità temporali
- **Wait_all**: true
- **Descrizione**: COMM_PROTO richiede il completamento di INIT_CORE.

#### Vincolo 3: INIT_CORE → MONITOR_SYS
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 9 (MONITOR_SYS)
- **Ritardo**: 4 unità temporali
- **Wait_all**: true
- **Descrizione**: Monitoraggio richiede completamento dell'inizializzazione.

#### Vincolo 4: INIT_CORE → ORBIT_CTRL
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 5 (ORBIT_CTRL)
- **Ritardo**: 5 unità temporali
- **Wait_all**: true
- **Descrizione**: Controllo orbitale richiede inizializzazione completa.

### 5.2 Catena di Controllo

#### Vincolo 5: COMM_PROTO → CTRL_EXEC
- **Task Sorgente**: Task 2 (COMM_PROTO)
- **Task Destinazione**: Task 3 (CTRL_EXEC)
- **Ritardo**: 2 unità temporali
- **Wait_all**: true
- **Descrizione**: Controllo richiede completamento delle comunicazioni.

#### Vincolo 6: CTRL_EXEC → SYNC_PROC
- **Task Sorgente**: Task 3 (CTRL_EXEC)
- **Task Destinazione**: Task 4 (SYNC_PROC)
- **Ritardo**: 2 unità temporali
- **Wait_all**: false
- **Descrizione**: Sincronizzazione coordinata con il controllo.

#### Vincolo 7: CTRL_EXEC → PREPROCESS_SVC
- **Task Sorgente**: Task 3 (CTRL_EXEC)
- **Task Destinazione**: Task 7 (PREPROCESS_SVC)
- **Ritardo**: 4 unità temporali
- **Wait_all**: false
- **Descrizione**: Pre-elaborazione inizia dopo il controllo.

### 5.3 Catena Orbitale

#### Vincolo 8: ORBIT_CTRL → ORBIT_MGMT
- **Task Sorgente**: Task 5 (ORBIT_CTRL)
- **Task Destinazione**: Task 6 (ORBIT_MGMT)
- **Ritardo**: 2 unità temporali
- **Wait_all**: true
- **Descrizione**: Gestione orbitale richiede completamento del controllo orbitale.

#### Vincolo 9: MONITOR_SYS → ORBIT_MGMT
- **Task Sorgente**: Task 9 (MONITOR_SYS)
- **Task Destinazione**: Task 6 (ORBIT_MGMT)
- **Ritardo**: 6 unità temporali
- **Wait_all**: true
- **Descrizione**: Percorso alternativo per gestione orbitale dal monitoraggio.

#### Vincolo 10: ORBIT_MGMT → PREPROCESS_SVC
- **Task Sorgente**: Task 6 (ORBIT_MGMT)
- **Task Destinazione**: Task 7 (PREPROCESS_SVC)
- **Ritardo**: 3 unità temporali
- **Wait_all**: true
- **Descrizione**: Pre-elaborazione richiede completamento gestione orbitale.

### 5.4 Pipeline di Elaborazione

#### Vincolo 11: PREPROCESS_SVC → POSTPROCESS_SVC
- **Task Sorgente**: Task 7 (PREPROCESS_SVC)
- **Task Destinazione**: Task 8 (POSTPROCESS_SVC)
- **Ritardo**: 1 unità temporale
- **Wait_all**: true
- **Descrizione**: Post-elaborazione richiede completamento pre-elaborazione.

### 5.5 Downlink Dati

#### Vincolo 12: POSTPROCESS_SVC → DATA_DOWNLINK
- **Task Sorgente**: Task 8 (POSTPROCESS_SVC)
- **Task Destinazione**: Task 10 (DATA_DOWNLINK)
- **Ritardo**: 2 unità temporali
- **Wait_all**: true
- **Descrizione**: Downlink richiede completamento elaborazione dati.

#### Vincolo 13: COMM_PROTO → DATA_DOWNLINK
- **Task Sorgente**: Task 2 (COMM_PROTO)
- **Task Destinazione**: Task 10 (DATA_DOWNLINK)
- **Ritardo**: 8 unità temporali
- **Wait_all**: true
- **Descrizione**: Downlink richiede protocolli di comunicazione attivi.

#### Vincolo 14: MONITOR_SYS → DATA_DOWNLINK
- **Task Sorgente**: Task 9 (MONITOR_SYS)
- **Task Destinazione**: Task 10 (DATA_DOWNLINK)
- **Ritardo**: 12 unità temporali
- **Wait_all**: true
- **Descrizione**: Downlink coordinato con il monitoraggio.

---

## 6. Flusso Operativo del Sistema

### 6.1 Fase di Inizializzazione (T=0 a T≈16)

Il sistema inizia con INIT_CORE (14 unità, 2 risorse). Dopo 2 unità può iniziare CTRL_EXEC (wait_all=false), ma COMM_PROTO deve attendere il completamento di INIT_CORE più 2 unità (wait_all=true).

### 6.2 Fase di Controllo (T≈2 a T≈17)

CTRL_EXEC inizia presto e si ripete 3 volte ogni 5 unità. SYNC_PROC segue 2 unità dopo ogni avvio di CTRL_EXEC, ripetendosi 3 volte ogni 6 unità.

### 6.3 Fase di Monitoraggio (T≈18 in poi)

MONITOR_SYS inizia 4 unità dopo il completamento di INIT_CORE (wait_all=true) e dura 20 unità, fornendo copertura estesa.

### 6.4 Fase Orbitale

ORBIT_CTRL inizia 5 unità dopo il completamento di INIT_CORE. ORBIT_MGMT può essere attivato da due percorsi:
- 2 unità dopo il completamento di ORBIT_CTRL
- 6 unità dopo il completamento di MONITOR_SYS

### 6.5 Pipeline di Elaborazione

PREPROCESS_SVC può iniziare da due percorsi:
- 4 unità dopo l'avvio di CTRL_EXEC
- 3 unità dopo il completamento di ORBIT_MGMT

POSTPROCESS_SVC inizia 1 unità dopo il completamento di PREPROCESS_SVC.

### 6.6 Downlink Dati

DATA_DOWNLINK ha tre vincoli di precedenza che devono essere tutti soddisfatti:
- 2 unità dopo il completamento di POSTPROCESS_SVC
- 8 unità dopo il completamento di COMM_PROTO
- 12 unità dopo il completamento di MONITOR_SYS

Questo task si ripete una volta con intervallo di 5 unità.

---

## 7. Caratteristiche Tecniche

### 7.1 Gestione delle Risorse

Il sistema dispone di 12 risorse computazionali. I task richiedono da 1 a 3 risorse:
- **3 risorse**: COMM_PROTO (configurazione comunicazioni robusta)
- **2 risorse**: INIT_CORE, ORBIT_CTRL, ORBIT_MGMT, POSTPROCESS_SVC, DATA_DOWNLINK
- **1 risorsa**: CTRL_EXEC, SYNC_PROC, PREPROCESS_SVC, MONITOR_SYS

### 7.2 Task Ripetitivi

Tre task sono configurati per esecuzioni ripetute:
- **CTRL_EXEC**: 3 ripetizioni ogni 5 unità temporali
- **SYNC_PROC**: 3 ripetizioni ogni 6 unità temporali
- **DATA_DOWNLINK**: 1 ripetizione ogni 5 unità temporali

### 7.3 Uso di wait_all

SpaceOBC3 fa uso estensivo del parametro wait_all=true (10 vincoli su 13), richiedendo il completamento effettivo dei task sorgente. Questo garantisce maggiore robustezza ma riduce il parallelismo.

---

## 8. Considerazioni Operative

### 8.1 Criticità

I task più critici sono:
1. **INIT_CORE** - Fondamentale, molti task richiedono il suo completamento
2. **COMM_PROTO** - Richiede 3 risorse, critico per downlink
3. **DATA_DOWNLINK** - Dipende da molteplici task completati
4. **MONITOR_SYS** - Durata estesa (20 unità), influenza altri task

### 8.2 Differenze rispetto a SpaceOBC1 e SpaceOBC2

SpaceOBC3 presenta caratteristiche distintive:
- Massime risorse disponibili (12)
- Presenza del DataService per downlink
- Uso estensivo di wait_all=true (maggiore robustezza)
- MONITOR_SYS con durata molto estesa (20 unità)
- Molteplici percorsi di dipendenza per task critici
- Enfasi sulla gestione orbitale e trasmissione dati

### 8.3 Robustezza

Il sistema implementa:
- Vincoli wait_all per garantire completamento task critici
- Molteplici percorsi per ORBIT_MGMT, PREPROCESS_SVC, DATA_DOWNLINK
- Monitoraggio esteso che copre gran parte della finestra operativa
- Downlink con tre vincoli di precedenza per massima affidabilità

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
- **wait_all**: Flag che indica se attendere il completamento del task sorgente (true) o solo il ritardo dall'avvio (false)

---

## 10. Conclusioni

Il sistema SpaceOBC3 rappresenta la configurazione più avanzata tra i tre sistemi, con 12 risorse computazionali e un'architettura orientata alla gestione dati e al downlink verso terra. L'uso estensivo di vincoli wait_all=true garantisce maggiore robustezza a scapito del parallelismo. La presenza del DataService e le molteplici dipendenze per il downlink riflettono l'importanza della trasmissione affidabile dei dati verso le stazioni di terra. Il monitoraggio esteso (20 unità) e i molteplici percorsi di attivazione per task critici aumentano significativamente l'affidabilità operativa del sistema.
