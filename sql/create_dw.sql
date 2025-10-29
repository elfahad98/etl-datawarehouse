PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- ====== Dim ======
CREATE TABLE IF NOT EXISTS dim_temps (
  datetime_key     TEXT PRIMARY KEY,
  date_only        TEXT NOT NULL,
  annee            INTEGER NOT NULL,
  trimestre        INTEGER NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
  mois             INTEGER NOT NULL CHECK (mois BETWEEN 1 AND 12),
  jour             INTEGER NOT NULL CHECK (jour BETWEEN 1 AND 31),
  heure            INTEGER NOT NULL CHECK (heure BETWEEN 0 AND 23),
  minute           INTEGER NOT NULL CHECK (minute BETWEEN 0 AND 59),
  jour_semaine     INTEGER,
  est_weekend      INTEGER NOT NULL DEFAULT 0 CHECK (est_weekend IN (0,1)),
  est_dejeuner_fin INTEGER NOT NULL DEFAULT 0 CHECK (est_dejeuner_fin IN (0,1)));

CREATE TABLE IF NOT EXISTS dim_prestation (
  code_prestation  TEXT PRIMARY KEY,
  libelle          TEXT NOT NULL,
  categorie        TEXT NOT NULL CHECK (categorie IN ('Depannage','Installation')));

CREATE TABLE IF NOT EXISTS dim_geo_intervention (
  geo_intervention_sk INTEGER PRIMARY KEY AUTOINCREMENT,
  code_postal         TEXT NOT NULL,
  ville               TEXT NOT NULL,
  departement         TEXT,
  region              TEXT,
  UNIQUE (code_postal, ville));

CREATE TABLE IF NOT EXISTS dim_client (
  client_sk       INTEGER PRIMARY KEY AUTOINCREMENT,
  num_client      INTEGER NOT NULL,
  nom             TEXT NOT NULL,
  prenom          TEXT NOT NULL,
  adresse         TEXT NOT NULL,
  code_postal     TEXT NOT NULL,
  ville           TEXT NOT NULL,
  departement     TEXT,
  region          TEXT,
  -- SCD2 : pour le chargement initial on laisse NULL
  effective_from  TEXT,            
  effective_to    TEXT,
  is_current      INTEGER NOT NULL DEFAULT 1 CHECK (is_current IN (0,1)),
  -- Traçabilité ETL
  src_system      TEXT,
  etl_batch_id    TEXT,
  etl_load_ts     TEXT DEFAULT (datetime('now')),
  UNIQUE (num_client, effective_from));


CREATE INDEX IF NOT EXISTS ix_dim_client_nat_current
  ON dim_client(num_client) WHERE is_current = 1;

-- ====== Fait ======
CREATE TABLE IF NOT EXISTS fact_ventes (
  vente_sk            INTEGER PRIMARY KEY AUTOINCREMENT,
  datetime_debut_key  TEXT    NOT NULL REFERENCES dim_temps(datetime_key),
  datetime_fin_key    TEXT    NOT NULL REFERENCES dim_temps(datetime_key),
  client_sk           INTEGER NOT NULL REFERENCES dim_client(client_sk),
  code_prestation     TEXT    NOT NULL REFERENCES dim_prestation(code_prestation),
  geo_intervention_sk INTEGER NOT NULL REFERENCES dim_geo_intervention(geo_intervention_sk),
  prix                REAL    NOT NULL CHECK (prix >= 0),
  duree_minutes       INTEGER NOT NULL CHECK (duree_minutes >= 0),
  src_system          TEXT,
  src_table           TEXT,
  src_rowid           TEXT,
  etl_batch_id        TEXT,
  load_ts             TEXT DEFAULT (datetime('now')),
  CHECK (datetime_fin_key >= datetime_debut_key)
);

-- ====== Index de perf ======
CREATE INDEX IF NOT EXISTS ix_fact_tstart ON fact_ventes(datetime_debut_key);
CREATE INDEX IF NOT EXISTS ix_fact_tend   ON fact_ventes(datetime_fin_key);
CREATE INDEX IF NOT EXISTS ix_fact_client ON fact_ventes(client_sk);
CREATE INDEX IF NOT EXISTS ix_fact_prest  ON fact_ventes(code_prestation);
CREATE INDEX IF NOT EXISTS ix_fact_geo    ON fact_ventes(geo_intervention_sk);

COMMIT;

