# module122-mariadb-automation

Script Bash d'installation et de sécurisation automatisée de MariaDB sur Debian/Ubuntu.

---

## Table des matières

- [Contexte professionnel](#contexte-professionnel)
- [Objectif](#objectif)
- [Prérequis](#prérequis)
- [Structure du projet](#structure-du-projet)
- [Paramètres](#paramètres)
- [Utilisation](#utilisation)
- [Actions réalisées par le script](#actions-réalisées-par-le-script)
- [Journalisation](#journalisation)
- [Version de démonstration](#version-de-démonstration)
- [Procédure de test](#procédure-de-test)
- [Auteur](#auteur)

---

## Contexte professionnel

Installer manuellement un SGBD sur plusieurs serveurs est une opération répétitive, sujette aux oublis de configuration et difficile à reproduire de manière identique. Dans le cadre du module 122 — *Automatiser des procédures à l'aide de scripts*, ce projet répond à ce besoin en fournissant un script Bash entièrement automatisé.

## Objectif

Le script `install_mariadb.sh` permet de :

- mettre à jour le système et installer MariaDB Server ;
- démarrer et activer le service au démarrage ;
- sécuriser l'instance (mot de passe root, suppression des comptes anonymes, désactivation de l'accès root distant, suppression de la base de test) ;
- créer une base de données et un utilisateur dédié avec les droits nécessaires ;
- journaliser chaque opération dans un fichier de log.

Aucune saisie clavier n'est demandée pendant l'exécution : toutes les informations sont passées en arguments.

## Prérequis

- Distribution : Debian 12+ ou Ubuntu Server 22.04+
- Droits : `sudo` / root
- Outils requis : `bash`, `apt`, `systemctl`, `mysql`

## Structure du projet

```
module122-mariadb-automation/
├── README.md
├── install_mariadb.sh          # Script principal
├── install_mariadb_secure.sh   # Version démonstration (sans exécution réelle)
├── rapport.md                  # Rapport de projet
├── logs/
│   └── install_mariadb.log     # Exemple de fichier de log
└── captures/
    └── preuves_tests.png       # Captures d'écran des tests
```

## Paramètres

Le script attend exactement 5 arguments dans l'ordre suivant :

| Position | Description                      | Exemple              |
|----------|----------------------------------|----------------------|
| `$1`     | Mot de passe root MariaDB        | `Root123!`           |
| `$2`     | Nom de la base de données        | `app_interne`        |
| `$3`     | Nom de l'utilisateur MariaDB     | `app_user`           |
| `$4`     | Mot de passe de l'utilisateur    | `User123!`           |
| `$5`     | Nom du fichier de log            | `install_mariadb.log`|

## Utilisation

Rendre le script exécutable, puis le lancer avec `sudo` :

```bash
chmod +x install_mariadb.sh
sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"
```

Si les 5 arguments ne sont pas fournis, le script affiche l'usage correct et s'arrête sans rien modifier.

## Actions réalisées par le script

Le script effectue d'abord trois vérifications préalables :

1. Le nombre d'arguments est bien égal à 5.
2. Le script est exécuté avec les droits root (`sudo`).
3. MariaDB n'est pas déjà installé sur le système.

Si toutes les vérifications sont passées, les étapes suivantes s'enchaînent :

| Étape  | Action                                                                 |
|--------|------------------------------------------------------------------------|
| [1/9]  | `apt update` — mise à jour de la liste des paquets                    |
| [2/9]  | `apt install mariadb-server -y` — installation de MariaDB             |
| [3/9]  | `apt upgrade -y` — mise à jour des dépendances                        |
| [4/9]  | `systemctl start mariadb` — démarrage du service                      |
| [5/9]  | `systemctl enable mariadb` — activation au démarrage                  |
| [6/9]  | Sécurisation SQL : mot de passe root, suppression anonymes/test/remote |
| [7/9]  | `CREATE DATABASE` — création de la base de données                    |
| [8/9]  | `CREATE USER` — création de l'utilisateur avec mot de passe           |
| [9/9]  | `GRANT ALL PRIVILEGES` + `FLUSH PRIVILEGES` — attribution des droits  |

Après les 9 étapes : redémarrage du service, affichage du statut, message de fin.

En cas d'erreur à n'importe quelle étape, le script journalise l'erreur et s'arrête immédiatement.

## Journalisation

Le fichier de log est créé à l'emplacement spécifié par `$5`. Chaque entrée est horodatée et classée par niveau :

```
=============================================
 Début de l'installation — 2026-06-18 14:32:01
=============================================
[2026-06-18 14:32:02] [OK]     Mise à jour de la liste des paquets réussie
[2026-06-18 14:32:15] [OK]     Installation de MariaDB réussie
[2026-06-18 14:32:18] [ERREUR] Échec du démarrage du service MariaDB — Arrêt du script.
```

- Les succès sont enregistrés avec `>>` et le niveau `[OK]`.
- Les erreurs sont enregistrées avec `2>>` et le niveau `[ERREUR]`.

Emplacement par défaut recommandé : `logs/install_mariadb.log`

## Version de démonstration

Le script `install_mariadb_secure.sh` est une version de démonstration : les commandes système (`apt`, `systemctl`) et les requêtes SQL sont remplacées par des `echo` affichant ce qui aurait été exécuté. Les mots de passe sont masqués par `***`. Aucune modification n'est apportée au système.

```bash
chmod +x install_mariadb_secure.sh
sudo ./install_mariadb_secure.sh "Root123!" "app_interne" "app_user" "User123!" "demo.log"
```

## Procédure de test

| # | Test                                      | Commande / vérification                                              | Résultat attendu                        |
|---|-------------------------------------------|----------------------------------------------------------------------|-----------------------------------------|
| 1 | Lancement sans paramètres                 | `sudo ./install_mariadb.sh`                                          | Affichage de l'usage, code retour 1     |
| 2 | Lancement avec paramètres corrects        | `sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"` | Installation complète, code retour 0 |
| 3 | MariaDB est installé                      | `mariadb --version`                                                  | Version de MariaDB affichée             |
| 4 | Le service MariaDB fonctionne             | `systemctl status mariadb`                                           | Statut `active (running)`               |
| 5 | La base de données existe                 | `mariadb -u root -p -e "SHOW DATABASES;"`                            | `app_interne` apparaît dans la liste    |
| 6 | L'utilisateur existe                      | `mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"`         | `app_user` apparaît dans la liste       |
| 7 | Lecture du fichier log                    | `cat install_mariadb.log`                                            | Toutes les étapes `[OK]` sont présentes |

## Auteur

**Chavagnat Adrien**
Module 122 — Automatiser des procédures à l'aide de scripts
Date : 18.06.2026
