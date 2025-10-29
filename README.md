# Projet ETL – Data Warehouse (Apache Hop + SQLite)

##  Objectif du projet
Concevoir un **entrepôt de données** (Data Warehouse) et mettre en place les **processus ETL** pour
une application de ventes de prestations informatiques. Les données brutes (clients, prestations, ventes,
géographie, dates) sont intégrées dans un **modèle en étoile** via des **pipelines Apache Hop** et chargées
dans une base **SQLite**.

---

##  Contenu du dépôt

Ce dépôt regroupe l’ensemble du projet ETL (Extraction, Transformation, Loading) réalisé avec **Apache Hop**.


### Structure du projet

```
etl-datawarehouse/
├─ hop/                       
│  ├─ load_dim_client.hpl
│  ├─ load_dim_geo.hpl
│  ├─ load_dim_prestation.hpl
│  ├─ load_dim_temps.hpl
│  ├─ load_fact_ventes.hpl
│  ├─ metadata/
│  └─ project-config.json
├─ sql/
│  └─ create_dw.sql          
├─ data/
│  ├─ sample/                
│  │  ├─ dates_sample.csv
│  │  ├─ geography_sample.csv
│  │  └─ prestations_sample.csv
│  └─ README.md              # d’où viennent les données complètes 
├─ env/
│  └─ tp_env_etl.example.json 
│    
├─ docs/
│  ├─ Modélisation.pdf             # schéma étoile
│  └─ screenshots/           # captures
├─ outputs/                  # ignoré (résultats/erreurs)
├─ .gitignore
├─ LICENSE
└─ README.md
```


---

##  Variables d’environnement (Hop)

Fichier d’exemple : `env/tp_env_etl.example.json`

| Variable           | Description                                   | Exemple                         |
|-------------------|-----------------------------------------------|---------------------------------|
| `data_dir`        | Dossier des données                            | `${PROJECT_HOME}/data`          |
| `output_dir`      | Dossier de sortie des erreurs                  | `${PROJECT_HOME}/outputs`       |
| `dw_db`           | Chemin du DW SQLite                            | `${data_dir}/dw_etl_combo.db`   |
| `dates_file`      | CSV des dates                                  | `${data_dir}/dates.csv`         |
| `geo_file`        | CSV des géographies                            | `${data_dir}/geography.csv`     |
| `prestations_file`| CSV des prestations                             | `${data_dir}/prestations.csv`   |

**Connexions Hop :**
- `OP_SQLite` → base opérationnelle (`operational_data.db`)
- `DW_SQLite` → entrepôt de données (`dw_etl_combo.db`)


> Chaque pipeline se base sur les variables d’environnement définies dans Hop.  
> Les sorties d’erreurs sont exportées dans le dossier `OUTPUTS/`.

---

## Pipelines ETL – Visualisation

| Étape | Capture | Description |
|-------|----------|-------------|
| Dimension Temps | ![load_dim_temps](docs/screenshots/load_dim_temps.png) | Construction de la dimension temporelle |
| Dimension Géographique | ![load_dim_geo](docs/screenshots/load_dim_geo.png) | Nettoyage et chargement des données géographiques |
| Dimension Prestations | ![load_dim_prestation](docs/screenshots/load_dim_prestation.png) | Normalisation et validation des prestations |
| Dimension Clients | ![load_dim_client](docs/screenshots/load_dim_client.png) | Validation, nettoyage et historisation SCD |
| Faits Ventes | ![load_fact_ventes](docs/screenshots/load_fact_ventes.png) | Intégration finale avec jointures et calculs dérivés |

---

## 👤 Auteur

Projet réalisé par **COMBO El-Fahad** – Université de Caen (2025).  
Contact : `el-fahad.combo@etu.unicaen.fr`

---

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier `LICENSE`.

