# Manuale di Sistema: SpaceOBC2
## Documento di Specifica e Configurazione

---

## 1. Introduzione

Il presente documento descrive la configurazione e l'architettura del sistema **SpaceOBC2**, un sistema di controllo per computer di bordo spaziale (On-Board Computer). Il sistema è progettato per gestire operazioni critiche attraverso una serie di servizi coordinati e task interdipendenti, con particolare enfasi sul controllo dei propulsori e sulla gestione della sicurezza operativa.

---

## 2. Parametri Globali del Sistema

Il sistema SpaceOBC2 è configurato con i seguenti parametri operativi fondamentali:

### 2.1 Identificazione
- **Nome Sistema**: SpaceOBC2
- **Identificativo**: Sistema di controllo con capacità avanzate di propulsione

### 2.2 Finestra Temporale di Esecuzione
- **Tempo di Inizio (h_start)**: 0 unità temporali
- **Tempo di Fine (h_end)**: 33 unità temporali
- **Durata Totale**: 33 unità temporali

### 2.3 Risorse Computazionali
- **Numero Massimo di Risorse (r_max)**: 10 unità

Il sistema dispone di 10 risorse computazionali, superiori rispetto a SpaceOBC1, permettendo un maggiore parallelismo nelle operazioni.

---

## 3. Architettura dei Servizi

Il sistema SpaceOBC2 è organizzato in **6 servizi principali**:

### 3.1 CoreService (Servizio 1)
**Funzione**: Gestione delle operazioni fondamentali del sistema

**Task Associati**:
- Task 1: INIT_CORE (Inizializzazione Core)
- Task 2: COMM_PROTO (Protocollo di Comunicazione)

Servizio fondamentale per l'inizializzazione e la configurazione dei protocolli di base.

### 3.2 ControlService (Servizio 2)
**Funzione**: Controllo ed esecuzione sincronizzata

**Task Associati**:
- Task 3: CTRL_EXEC (Esecuzione Controllo)
- Task 4: SYNC_PROC (Processo di Sincronizzazione)

Gestisce le operazioni di controllo in tempo reale con esecuzioni ripetute ad alta frequenza.

### 3.3 AnalysisService (Servizio 3)
**Funzione**: Analisi e verifica dei dati

**Task Associati**:
- Task 5: ANALYSIS_FULL (Analisi Completa)
- Task 6: VERIFY_QUICK (Verifica Rapida)

Responsabile dell'analisi approfondita e delle verifiche di integrità.

### 3.4 MonitorService (Servizio 4)
**Funzione**: Monitoraggio continuo del sistema

**Task Associati**:
- Task 7: MONITOR_SYS (Monitoraggio Sistema)

Fornisce capacità di monitoraggio continuo con possibilità di esecuzione multipla (fino a 3 istanze).

### 3.5 SafeService (Servizio 5)
**Funzione**: Gestione modalità sicura

**Task Associati**:
- Task 8: SAFE_DIR (Direttive di Sicurezza)

Gestisce le procedure di sicurezza e le direttive per la modalità safe del sistema.

### 3.6 ThrusterService (Servizio 6)
**Funzione**: Controllo propulsori

**Task Associati**:
- Task 9: THRUSTER_CTRL (Controllo Propulsori)

Servizio specializzato per il controllo dei propulsori, caratteristica distintiva di SpaceOBC2.

---

## 4. Specifiche dei Task

### 4.1 Task 1: INIT_CORE
**Inizializzazione del Core di Sistema**

- **Identificativo**: 1
- **Sigla**: initcor
- **Durata**: 10 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0 (esecuzione singola)
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Inizializzazione fondamentale del sistema con richiesta di 2 risorse per operazioni più intensive.

### 4.2 Task 2: COMM_PROTO
**Configurazione Protocollo di Comunicazione**

- **Identificativo**: 2
- **Sigla**: comprt
- **Durata**: 12 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Configura i protocolli di comunicazione con allocazione di 2 risorse.

### 4.3 Task 3: CTRL_EXEC
**Esecuzione Controllo**

- **Identificativo**: 3
- **Sigla**: ctlexe
- **Durata**: 3 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 2 ripetizioni
- **Ritardo Ripetizioni (rd)**: 4 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 2 istanze

Task di controllo ripetuto 2 volte ogni 4 unità temporali, con possibilità di 2 istanze simultanee.

### 4.4 Task 4: SYNC_PROC
**Processo di Sincronizzazione**

- **Identificativo**: 4
- **Sigla**: synprc
- **Durata**: 2 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 2 ripetizioni
- **Ritardo Ripetizioni (rd)**: 3 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 2 istanze

Sincronizzazione con intervalli di 3 unità temporali, permettendo 2 istanze parallele.

### 4.5 Task 5: ANALYSIS_FULL
**Analisi Completa del Sistema**

- **Identificativo**: 5
- **Sigla**: anlful
- **Durata**: 14 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Analisi approfondita dello stato del sistema con allocazione di 2 risorse.

### 4.6 Task 6: VERIFY_QUICK
**Verifica Rapida**

- **Identificativo**: 6
- **Sigla**: verqck
- **Durata**: 5 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Verifica rapida con durata ridotta rispetto a SpaceOBC1 (5 vs 7 unità).

### 4.7 Task 7: MONITOR_SYS
**Monitoraggio Sistema**

- **Identificativo**: 7
- **Sigla**: monsys
- **Durata**: 13 unità temporali
- **Richiesta Risorse**: 1 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 3 istanze

Monitoraggio continuo con capacità di eseguire fino a 3 istanze simultanee.

### 4.8 Task 8: SAFE_DIR
**Direttive di Sicurezza**

- **Identificativo**: 8
- **Sigla**: safdir
- **Durata**: 8 unità temporali
- **Richiesta Risorse**: 2 unità
- **Conteggio Ripetizioni (rc)**: 0
- **Ritardo Ripetizioni (rd)**: 0
- **Massimo Concorrenza**: 1 istanza

Gestione delle direttive di sicurezza con allocazione di 2 risorse.

### 4.9 Task 9: THRUSTER_CTRL
**Controllo Propulsori**

- **Identificativo**: 9
- **Sigla**: thrctrl
- **Durata**: 3 unità temporali
- **Richiesta Risorse**: 3 unità
- **Conteggio Ripetizioni (rc)**: 1 ripetizione
- **Ritardo Ripetizioni (rd)**: 3 unità temporali tra ripetizioni
- **Massimo Concorrenza**: 2 istanze

Task critico per il controllo dei propulsori, richiede 3 risorse (il massimo tra tutti i task) e può essere ripetuto una volta con intervallo di 3 unità temporali.

---

## 5. Vincoli di Precedenza e Dipendenze Temporali

Il sistema implementa **11 vincoli di precedenza start-to-start**:

### 5.1 Catena di Inizializzazione

#### Vincolo 1: INIT_CORE → COMM_PROTO
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 2 (COMM_PROTO)
- **Ritardo**: 3 unità temporali
- **Descrizione**: Il protocollo di comunicazione inizia 3 unità dopo l'inizializzazione core.

#### Vincolo 2: INIT_CORE → MONITOR_SYS
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 7 (MONITOR_SYS)
- **Ritardo**: 2 unità temporali
- **Descrizione**: Il monitoraggio inizia precocemente, solo 2 unità dopo l'inizializzazione.

#### Vincolo 3: COMM_PROTO → CTRL_EXEC
- **Task Sorgente**: Task 2 (COMM_PROTO)
- **Task Destinazione**: Task 3 (CTRL_EXEC)
- **Ritardo**: 4 unità temporali
- **Descrizione**: Il controllo esecutivo dipende dal completamento della configurazione comunicazioni.

### 5.2 Catena di Controllo e Sincronizzazione

#### Vincolo 4: CTRL_EXEC → SYNC_PROC
- **Task Sorgente**: Task 3 (CTRL_EXEC)
- **Task Destinazione**: Task 4 (SYNC_PROC)
- **Ritardo**: 2 unità temporali
- **Descrizione**: Sincronizzazione coordinata con il controllo esecutivo.

#### Vincolo 5: SYNC_PROC → ANALYSIS_FULL
- **Task Sorgente**: Task 4 (SYNC_PROC)
- **Task Destinazione**: Task 5 (ANALYSIS_FULL)
- **Ritardo**: 2 unità temporali
- **Descrizione**: L'analisi completa inizia dopo la sincronizzazione.

### 5.3 Catena di Analisi

#### Vincolo 6: INIT_CORE → ANALYSIS_FULL
- **Task Sorgente**: Task 1 (INIT_CORE)
- **Task Destinazione**: Task 5 (ANALYSIS_FULL)
- **Ritardo**: 6 unità temporali
- **Descrizione**: Percorso alternativo per l'avvio dell'analisi.

#### Vincolo 7: ANALYSIS_FULL → VERIFY_QUICK
- **Task Sorgente**: Task 5 (ANALYSIS_FULL)
- **Task Destinazione**: Task 6 (VERIFY_QUICK)
- **Ritardo**: 4 unità temporali
- **Descrizione**: Verifica rapida dopo l'analisi completa.

### 5.4 Controllo Propulsori

#### Vincolo 8: VERIFY_QUICK → THRUSTER_CTRL
- **Task Sorgente**: Task 6 (VERIFY_QUICK)
- **Task Destinazione**: Task 9 (THRUSTER_CTRL)
- **Ritardo**: 3 unità temporali
- **Descrizione**: I propulsori vengono attivati dopo la verifica del sistema.

#### Vincolo 9: MONITOR_SYS → THRUSTER_CTRL
- **Task Sorgente**: Task 7 (MONITOR_SYS)
- **Task Destinazione**: Task 9 (THRUSTER_CTRL)
- **Ritardo**: 8 unità temporali
- **Descrizione**: Percorso alternativo per il controllo propulsori basato sul monitoraggio.

### 5.5 Gestione Sicurezza

#### Vincolo 10: MONITOR_SYS → SAFE_DIR
- **Task Sorgente**: Task 7 (MONITOR_SYS)
- **Task Destinazione**: Task 8 (SAFE_DIR)
- **Ritardo**: 6 unità temporali
- **Descrizione**: Le direttive di sicurezza dipendono dal monitoraggio.

#### Vincolo 11: CTRL_EXEC → SAFE_DIR
- **Task Sorgente**: Task 3 (CTRL_EXEC)
- **Task Destinazione**: Task 8 (SAFE_DIR)
- **Ritardo**: 12 unità temporali
- **Descrizione**: Percorso alternativo per l'attivazione della sicurezza.

---

## 6. Flusso Operativo del Sistema

### 6.1 Fase di Inizializzazione (T=0 a T≈12)

Il sistema inizia con INIT_CORE (10 unità di durata, 2 risorse). Dopo 2 unità inizia MONITOR_SYS, e dopo 3 unità inizia COMM_PROTO (12 unità di durata, 2 risorse).

### 6.2 Fase di Controllo (T≈7 a T≈15)

Dopo 4 unità dall'avvio di COMM_PROTO, inizia CTRL_EXEC (3 unità, ripetuto 2 volte ogni 4 unità). SYNC_PROC segue 2 unità dopo CTRL_EXEC (2 unità, ripetuto 2 volte ogni 3 unità).

### 6.3 Fase di Analisi (T≈6 o T≈11 in poi)

ANALYSIS_FULL può iniziare da due percorsi:
- 6 unità dopo INIT_CORE
- 2 unità dopo SYNC_PROC

VERIFY_QUICK inizia 4 unità dopo ANALYSIS_FULL.

### 6.4 Fase di Propulsione

THRUSTER_CTRL può essere attivato da due percorsi:
- 3 unità dopo VERIFY_QUICK
- 8 unità dopo MONITOR_SYS

Questo task critico richiede 3 risorse e può essere ripetuto una volta.

### 6.5 Gestione Sicurezza

SAFE_DIR può essere attivato da:
- 6 unità dopo MONITOR_SYS
- 12 unità dopo CTRL_EXEC

---

## 7. Caratteristiche Tecniche

### 7.1 Gestione delle Risorse

Il sistema dispone di 10 risorse computazionali. I task richiedono da 1 a 3 risorse:
- **3 risorse**: THRUSTER_CTRL (task più intensivo)
- **2 risorse**: INIT_CORE, COMM_PROTO, CTRL_EXEC, ANALYSIS_FULL, VERIFY_QUICK, SAFE_DIR
- **1 risorsa**: SYNC_PROC, MONITOR_SYS

### 7.2 Task Ripetitivi

Tre task sono configurati per esecuzioni ripetute:
- **CTRL_EXEC**: 2 ripetizioni ogni 4 unità temporali
- **SYNC_PROC**: 2 ripetizioni ogni 3 unità temporali
- **THRUSTER_CTRL**: 1 ripetizione ogni 3 unità temporali

### 7.3 Concorrenza

Alcuni task permettono esecuzioni multiple simultanee:
- **CTRL_EXEC**: fino a 2 istanze
- **SYNC_PROC**: fino a 2 istanze
- **MONITOR_SYS**: fino a 3 istanze
- **THRUSTER_CTRL**: fino a 2 istanze

---

## 8. Considerazioni Operative

### 8.1 Criticità

I task più critici sono:
1. **INIT_CORE** - Fondamentale per l'avvio
2. **THRUSTER_CTRL** - Controllo propulsione (richiede 3 risorse)
3. **MONITOR_SYS** - Avvio precoce per sorveglianza continua

### 8.2 Differenze rispetto a SpaceOBC1

SpaceOBC2 presenta caratteristiche distintive:
- Maggiori risorse disponibili (10 vs 8)
- Presenza del ThrusterService per controllo propulsori
- Task con richieste di risorse più elevate
- Intervalli di ripetizione più brevi per controllo e sincronizzazione
- Monitoraggio attivato più precocemente (2 vs 10 unità)

### 8.3 Robustezza

Il sistema implementa molteplici percorsi per task critici:
- ANALYSIS_FULL può essere attivato da due sorgenti
- THRUSTER_CTRL ha due percorsi di attivazione
- SAFE_DIR può essere attivato da monitoraggio o controllo

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

Il sistema SpaceOBC2 rappresenta un'evoluzione rispetto a SpaceOBC1, con maggiore capacità computazionale e l'aggiunta del controllo propulsori. La configurazione con 10 risorse e task che richiedono fino a 3 risorse riflette operazioni più intensive, particolarmente per il controllo dei propulsori. La presenza di molteplici percorsi di attivazione per task critici aumenta la robustezza e la flessibilità operativa del sistema.
