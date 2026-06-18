# Automatiser l’installation et la sécurisation de MariaDB
---
Auteur : Chavagnat Adrien </br>
Date : 18.06.2026 </br>
Module : 122 - Automatiser des procédures à l’aide de scripts </br>
---

## Table des matières

- [Automatiser l’installation et la sécurisation de MariaDB](#automatiser-linstallation-et-la-sécurisation-de-mariadb)
  - [Module : 122 - Automatiser des procédures à l’aide de scripts ](#module--122---automatiser-des-procédures-à-laide-de-scripts-)
  - [Table des matières](#table-des-matières)
  - [1. Introduction](#1-introduction)
  - [2. S’informer](#2-sinformer)
    - [2.1 Cahier des charges](#21-cahier-des-charges)
      - [2.1.1 Environnement de travail](#211-environnement-de-travail)
      - [2.1.2 Fonction principale du script](#212-fonction-principale-du-script)
      - [2.1.3 Contraintes importantes](#213-contraintes-importantes)
      - [2.1.4 Paramètres obligatoires](#214-paramètres-obligatoires)
      - [2.1.5 Création de la base de données](#215-création-de-la-base-de-données)
      - [2.1.6 Gestion du fichier log](#216-gestion-du-fichier-log)
      - [2.1.7 Tests obligatoires](#217-tests-obligatoires)
      - [2.1.8 Dépôt GitHub](#218-dépôt-github)
      - [2.1.6 README.md attendu](#216-readmemd-attendu)
    - [2.2 Analyse du besoin](#22-analyse-du-besoin)
  - [3. Planifier](#3-planifier)
    - [3.1 descriptions No Code du script](#31-descriptions-no-code-du-script)
    - [3.2 Éléments à produire](#32-éléments-à-produire)
  - [4. Décider](#4-décider)
    - [4.1 Choix techniques](#41-choix-techniques)
  - [5. Concevoir](#5-concevoir)
    - [5.1 Script](#51-script)
    - [5.2 Journalisation](#52-journalisation)
  - [6. Tester](#6-tester)
    - [6.1 Cas de tests](#61-cas-de-tests)
      - [Test 1 - Lancer le script sans paramètres](#test-1---lancer-le-script-sans-paramètres)
      - [test 2 - relecture du journal](#test-2---relecture-du-journal)
      - [test 3 - MariaDB est installé](#test-3---mariadb-est-installé)
      - [test 4 - Le service fonctionne](#test-4---le-service-fonctionne)
      - [test 5 - la base de donnée existe](#test-5---la-base-de-donnée-existe)
      - [test 6 - l'utilisateur existe](#test-6---lutilisateur-existe)
  - [7. Évaluer](#7-évaluer)
  - [8. Conclusion](#8-conclusion)


## 1. Introduction
Dans le cadre du module 122 « Automatiser des procédures à l’aide de scripts », ce projet a pour objectif de développer un script Bash permettant d'automatiser l'installation et la sécurisation de MariaDB sur un système Linux. </br>
L'automatisation de ces tâches permet de réduire les erreurs humaines, de gagner du temps lors des déploiements et de garantir une configuration cohérente entre plusieurs serveurs. Ce rapport présente l'analyse du besoin, les choix techniques effectués, la conception du script, les tests réalisés ainsi que l'évaluation du projet.

## 2. S’informer
<!-- Avant de concevoir la solution, il est nécessaire de comprendre les exigences du mandat et les contraintes techniques imposées. Cette phase consiste à analyser le cahier des charges, à identifier les fonctionnalités attendues et à déterminer les connaissances nécessaires concernant MariaDB, Linux et l'automatisation par script Bash. Cette étude permet de définir clairement les objectifs du projet et les moyens à mettre en œuvre pour les atteindre. -->

Cette phase permet de comprendre les exigences du mandat ainsi que les contraintes techniques imposées. Le cahier des charges étant suffisamment clair, il a été reporté telle que présenté durant la séquence de cours. Il m'a permis de déterminer les fonctionnalités attendues, les connaissances nécessaires ou, à défaut, quelles sont les informations à rechercher.  

### 2.1 Cahier des charges
#### 2.1.1 Environnement de travail
Le script doit être réalisé sur une machine virtuelle Linux VMware.

Distribution attendue :

Ubuntu Server ou Debian
Le script doit être écrit en :

Bash
Nom du script :

install_mariadb.sh

#### 2.1.2 Fonction principale du script
Le script doit automatiquement :

Mettre à jour la liste des paquets.

Installer MariaDB Server.

Démarrer le service MariaDB.

Activer MariaDB au démarrage du système.

Sécuriser MariaDB.

Créer une base de données.

Créer un utilisateur MariaDB.

Donner les droits nécessaires à cet utilisateur.

Écrire toutes les opérations dans un fichier de log.

Publier le projet dans un dépôt GitHub.

#### 2.1.3 Contraintes importantes
Le script doit être entièrement automatisé.

Cela signifie :

aucune question posée pendant l’exécution ;

aucune saisie clavier demandée à l’utilisateur ;

toutes les informations nécessaires doivent être passées en arguments du script.

#### 2.1.4 Paramètres obligatoires
Ton script doit recevoir les paramètres suivants :

| Paramètre	| Description | Exemple |
|------|------|------|
| $1 | Mot de passe root MariaDB | Root123! |
| $2 | Nom de la base de données à créer | app_interne |
| $3 | Nom de l’utilisateur MariaDB | app_user |
| $4 | Mot de passe de l’utilisateur MariaDB | User123! |
| $5 | Nom du fichier de log | install_mariadb.log |

**Exemple de lancement attendu**

sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"

**Sécurisation attendue**
Ton script doit appliquer au minimum les mesures suivantes :

- définir ou modifier le mot de passe root MariaDB ;
- supprimer les utilisateurs anonymes ;
- interdire la connexion root à distance ;
- supprimer la base de test ;
- recharger les privilèges MariaDB.

#### 2.1.5 Création de la base de données
Le script doit :

créer la base de données passée en paramètre ;

créer l’utilisateur passé en paramètre ;

attribuer les droits nécessaires à cet utilisateur sur cette base ;

recharger les privilèges.

#### 2.1.6 Gestion du fichier log
Le fichier log doit contenir :

les opérations réussies avec >> ;

les erreurs éventuelles avec 2>>.

Exemple attendu :

echo "Installation de MariaDB réussie" >> "$LOG"
apt install mariadb-server -y 2>> "$LOG"
Le log doit permettre de comprendre ce qui s’est passé pendant l’exécution.

#### 2.1.7 Tests obligatoires
Avant de remettre ton projet, tu dois tester :

lancement du script sans paramètres ;

lancement avec des paramètres corrects ;

vérification que MariaDB est installé ;

vérification que le service MariaDB fonctionne ;

vérification que la base de données existe ;

vérification que l’utilisateur existe ;

lecture du fichier log.

#### 2.1.8 Dépôt GitHub
Tu dois créer un nouveau dépôt GitHub dans ton compte.

Nom proposé :

module122-mariadb-automation
Le dépôt doit contenir :

module122-mariadb-automation/

```
├── README.md
├── install_mariadb.sh
├── rapport.md
├── logs/
│   └── install_mariadb.log
└── captures/
    └── preuves_tests.png
```

#### 2.1.6 README.md attendu
Ton fichier README.md doit contenir :

titre du projet ;

contexte professionnel ;

objectif du script ;

liste des paramètres ;

exemple d’exécution ;

description des actions réalisées ;

emplacement du fichier log ;

procédure de test ;

auteur.

Décrire le mandat et les informations nécessaires :

Qu’est-ce que MariaDB ?

Pourquoi automatiser l’installation ?

Quelles commandes Linux seront nécessaires ?

Quels risques faut-il prendre en compte ?

### 2.2 Analyse du besoin

<!-- Installer MariaDB manuellement sur chaque serveur prend du temps et peut provoquer des oublis de configuration. Ton responsable te demande donc de créer un script Bash entièrement automatisé capable de :

installer MariaDB ;

appliquer une sécurisation de base ;

créer une base de données ;

créer un utilisateur MariaDB dédié ;

enregistrer les opérations et les erreurs dans un fichier de log ; -->

L'installation de SGBD (abr. *Système de Gestion de Base de Données*) manuellement sur plusieurs serveurs prend du temps et peut provoquer des oublis de configuration. Pour uniformiser cette installation, l'automatisation par script permet :
- L'installation du logiciel
- La sécurisation du SGBD
- La création d'une base de données.
- La création du login, du mot de passe et l'utilisateur
- L'application des droits sur les utilisateurs créés


## 3. Planifier

cette partie définit le déroulement du script avant son développement. Elle permet d’identifier les différentes actions à automatiser, les contrôles à effectuer ainsi que les éléments nécessaires à la réalisation du mandat. </br> En décrivant le fonctionnement attendu sous forme d’étapes logiques, il est plus simple de concevoir un script fiable, structuré et conforme au cahier des charges.

### 3.1 descriptions No Code du script
Au démarrage du script, l'utilisateur passe les paramètres suivants en argument :
- `$1` — Mot de passe root MariaDB
- `$2` — Nom de la base de données à créer
- `$3` — Nom de l'utilisateur MariaDB
- `$4` — Mot de passe de l'utilisateur MariaDB
- `$5` — Nom du fichier de log

Avant l'exécution des étapes principales, le script effectue trois vérifications préalables :

- **Nombre de paramètres** : si les 5 arguments ne sont pas fournis, le script affiche l'usage correct et s'arrête.
- **Droits root** : si le script n'est pas exécuté avec `sudo`, il s'arrête immédiatement.
- **MariaDB déjà installé** : si la commande `mariadb` est déjà présente sur le système, le script journalise la détection et s'arrête sans rien modifier.

Une fois les vérifications passées :

1. Mettre à jour la liste des paquets 

2. Installer MariaDB Server en acceptant automatiquement les dépendances 

3. Mettre à jour les dépendances installées 

4. Démarrer le service MariaDB 

5. Activer MariaDB au démarrage du système 

6. Sécuriser MariaDB par des requêtes SQL directes :
   - Définir le mot de passe root
   - Supprimer les utilisateurs anonymes
   - Désactiver la connexion root à distance
   - Supprimer la base de données de test
   - Recharger les tables de privilèges

7. Créer la base de données passée en paramètre 

8. Créer l'utilisateur MariaDB avec son mot de passe v

9. Attribuer tous les droits à l'utilisateur sur la base de données, puis recharger les privilèges 

Après les 9 étapes :

- Redémarrer le service MariaDB 
- Afficher le statut du service dans la console 
- Afficher un message de fin récapitulatif avec le nom de la base, l'utilisateur et le fichier de log

À chaque étape, le journal de log est complété à l'aide des commandes de redirection `>>` pour la réussite et `2>>` pour les erreurs éventuelles, avec un horodatage et un niveau (`[OK]` ou `[ERREUR]`).
À la moindre erreur, le script appelle la fonction `quitter()` qui affiche le message d'erreur dans la console, le journalise, puis arrête l'exécution immédiatement.

### 3.2 Éléments à produire

Les éléments à produire sont :
- un script d'automatisation de l'installation de MariaDB
- les preuves de tests
- un README servant à :
  - présenter en général les objectifs et les fonctionnalités
  - guider l'installation et la configuration
  - créditer l'auteur/l'autrice du projet
- la copie d'un exemplaire de journal de log

## 4. Décider

Les besoins étant identifiés, il est alors nécessaire de choisir les méthodes de réalisation. Les choix sont justifiés afin de démontrer leurs pertinences par rapport au mandat

### 4.1 Choix techniques

<!-- Justifier tes choix :

pourquoi ces paramètres ?

pourquoi créer un log ?

pourquoi sécuriser MariaDB ?

pourquoi publier sur GitHub ? -->

Pour la conception du script, je décide de rester sur la distribution Debian 12 - Trixie. En effet, elle est similaire à Ubuntu Server et ces 2 distributions sont les plus répandues dans le monde de l'Open-source. Afin de simplifier l'adaptation du script à d'autres distributions, je décide de mettre les commandes spécifique à Debian dans des variables en haut du script. Elles pourront être modifiées au besoin.

La journalisation des étapes permet une installation silencieuse et, en cas d'erreur, de pouvoir analyser la situation hors du champ de production. 

La sécurisation de MariaDB se fait via le script `mysql_secure_installation` car celui-ci est fourni avec le SGBD.

Enfin, le projet sera déposer sur GitHub, une plateforme en ligne qui regroupe d'autres logiciels et scripts, afin de partager le projet ainsi que de le faire évoluer à l'aide de `branch`, de l'adapter à d'autres SGBD ou à d'autres distributions à l'aide de `fork`.

## 5. Concevoir

Cette phase transforme les besoins identifiés et les choix techniques en une solution concrète. Elle comprend la définition de la logique du script ainsi que les ajustements non prévus durant la phase de planification.

### 5.1 Script 
Cette version du script est une version sécurisée remplaçant les commandes sensibles par un affichage console de ce qu'est censé faire la commande.

```bash
#!/bin/bash
# *****************************************************************
# ========== Automatisation et sécurisation de MariaDB ==========
# description:
# VERSION DÉMONSTRATION — les commandes sensibles sont remplacées
# par des echo affichant ce que la commande aurait exécuté.
# Aucune modification n'est apportée au système.
# -----------------------------------------------------------------
# 2026-06-18 - V0.1
# Auteur : Chavagnat Adrien
# *****************************************************************

# --- Commandes spécifiques à Debian (adaptables à d'autres distributions) ---
PKG_UPDATE="apt update"
PKG_UPGRADE="apt upgrade -y"
PKG_INSTALL="apt install -y"
SERVICE_START="systemctl start"
SERVICE_ENABLE="systemctl enable"
SERVICE_RESTART="systemctl restart"
SERVICE_STATUS="systemctl status"
MARIADB_PKG="mariadb-server"
MARIADB_SERVICE="mariadb"

# --- Vérification du nombre de paramètres ---
if [ "$#" -ne 5 ]; then
    echo "Usage : sudo $0 <root_password> <db_name> <username> <user_password> <log_file>"
    echo "Exemple : sudo $0 \"Root123!\" \"app_interne\" \"app_user\" \"User123!\" \"install_mariadb.log\""
    exit 1
fi

# --- Paramètres ---
ROOT_PASSWORD="$1"
DB_NAME="$2"
DB_USER="$3"
DB_PASSWORD="$4"
LOG="$5"

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then
    echo "Erreur : ce script doit être exécuté en tant que root (sudo)."
    exit 1
fi

# --- Fonctions de journalisation ---
log_ok() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [OK]     $1" >> "$LOG"
}

log_err() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERREUR] $1" >> "$LOG"
}

quitter() {
    local message="$1"
    echo ""
    echo "ERREUR : $message"
    log_err "$message — Arrêt du script."
    exit 1
}

# --- Initialisation du fichier log ---
echo "=============================================" >> "$LOG"
echo " Début de l'installation — $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo "=============================================" >> "$LOG"

echo "=== [DEMO] Installation de MariaDB en cours... ==="
echo ""

# --- Vérification si MariaDB est déjà installé ---
if command -v mariadb >/dev/null 2>&1; then
    echo "MariaDB est déjà installé sur ce système. Arrêt du script."
    log_err "MariaDB est déjà installé — installation annulée."
    exit 0
fi

# --- Étape 1 : Mise à jour de la liste des paquets ---
echo "[1/9] Mise à jour de la liste des paquets..."
echo "  > COMMANDE : $PKG_UPDATE"
log_ok "Mise à jour de la liste des paquets réussie"

# --- Étape 2 : Installation de MariaDB Server ---
echo "[2/9] Installation de MariaDB Server..."
echo "  > COMMANDE : $PKG_INSTALL $MARIADB_PKG"
log_ok "Installation de MariaDB réussie"

# --- Étape 3 : Mise à jour des dépendances ---
echo "[3/9] Mise à jour des dépendances..."
echo "  > COMMANDE : $PKG_UPGRADE"
log_ok "Mise à jour des dépendances réussie"

# --- Étape 4 : Démarrage du service MariaDB ---
echo "[4/9] Démarrage du service MariaDB..."
echo "  > COMMANDE : $SERVICE_START $MARIADB_SERVICE"
log_ok "Service MariaDB démarré"

# --- Étape 5 : Activation de MariaDB au démarrage du système ---
echo "[5/9] Activation de MariaDB au démarrage..."
echo "  > COMMANDE : $SERVICE_ENABLE $MARIADB_SERVICE"
log_ok "MariaDB activé au démarrage du système"

# --- Étape 6 : Sécurisation de MariaDB ---
echo "[6/9] Sécurisation de MariaDB..."
echo "  > REQUÊTE SQL : ALTER USER 'root'@'localhost' IDENTIFIED BY '***';"
echo "  > REQUÊTE SQL : DELETE FROM mysql.user WHERE User='';"
echo "  > REQUÊTE SQL : DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
echo "  > REQUÊTE SQL : DROP DATABASE IF EXISTS test;"
echo "  > REQUÊTE SQL : DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
echo "  > REQUÊTE SQL : FLUSH PRIVILEGES;"
log_ok "Sécurisation réussie : mot de passe root défini, utilisateurs anonymes supprimés, connexion root distante désactivée, base test supprimée, privilèges rechargés"

# --- Étape 7 : Création de la base de données ---
echo "[7/9] Création de la base de données '$DB_NAME'..."
echo "  > REQUÊTE SQL : CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
log_ok "Base de données '$DB_NAME' créée"

# --- Étape 8 & 9 : Création de l'utilisateur ---
echo "[8/9] Création de l'utilisateur '$DB_USER'..."
echo "  > REQUÊTE SQL : CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '***';"
log_ok "Utilisateur '$DB_USER' créé"

# --- Étapes 10 & 11 : Attribution des droits et rechargement des privilèges ---
echo "[9/9] Attribution des droits à '$DB_USER' sur '$DB_NAME'..."
echo "  > REQUÊTE SQL : GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';"
echo "  > REQUÊTE SQL : FLUSH PRIVILEGES;"
log_ok "Droits accordés à '$DB_USER' sur la base '$DB_NAME' — Privilèges rechargés"

# --- Redémarrage de MariaDB ---
echo ""
echo "Redémarrage du service MariaDB..."
echo "  > COMMANDE : $SERVICE_RESTART $MARIADB_SERVICE"
log_ok "Service MariaDB redémarré"

# --- Affichage du statut ---
echo ""
echo "--- Statut du service MariaDB ---"
echo "  > COMMANDE : $SERVICE_STATUS $MARIADB_SERVICE --no-pager"
echo ""

# --- Fin du log ---
echo "=============================================" >> "$LOG"
echo " Installation terminée — $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo "=============================================" >> "$LOG"

# --- Message de fin ---
echo "============================================="
echo " [DEMO] Installation simulée avec succès !"
echo "  Base de données : $DB_NAME"
echo "  Utilisateur     : $DB_USER"
echo "  Fichier log     : $LOG"
echo "============================================="

```
### 5.2 Journalisation

```bash
#!/bin/bash
# *****************************************************************
# ========== Automatisation et sécurisation de MariaDB ==========
# description:
# ce script permet d'installer et de sécuriser MariaDB,
# de créer une base de données,
# de créer un login et un mot de passe,
# de créer un utilisateur associé au login,
# d'activer le service au démarrage et
# de journaliser les étapes
# -----------------------------------------------------------------
# 2026-06-18 - V0.1
# Auteur : Chavagnat Adrien
# *****************************************************************

# --- Commandes spécifiques à Debian (adaptables à d'autres distributions) ---
PKG_UPDATE="apt update"
PKG_UPGRADE="apt upgrade -y"
PKG_INSTALL="apt install -y"
SERVICE_START="systemctl start"
SERVICE_ENABLE="systemctl enable"
SERVICE_RESTART="systemctl restart"
SERVICE_STATUS="systemctl status"
MARIADB_PKG="mariadb-server"
MARIADB_SERVICE="mariadb"

# --- Vérification du nombre de paramètres ---
if [ "$#" -ne 5 ]; then
    echo "Usage : sudo $0 <root_password> <db_name> <username> <user_password> <log_file>"
    echo "Exemple : sudo $0 \"Root123!\" \"app_interne\" \"app_user\" \"User123!\" \"install_mariadb.log\""
    exit 1
fi

# --- Paramètres ---
ROOT_PASSWORD="$1"
DB_NAME="$2"
DB_USER="$3"
DB_PASSWORD="$4"
LOG="$5"

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then
    echo "Erreur : ce script doit être exécuté en tant que root (sudo)."
    exit 1
fi

# --- Fonctions de journalisation ---
log_ok() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [OK]     $1" >> "$LOG"
}

log_err() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERREUR] $1" >> "$LOG"
}

quitter() {
    local message="$1"
    echo ""
    echo "ERREUR : $message"
    log_err "$message — Arrêt du script."
    exit 1
}

# --- Initialisation du fichier log ---
echo "=============================================" >> "$LOG"
echo " Début de l'installation — $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo "=============================================" >> "$LOG"

echo "=== Installation de MariaDB en cours... ==="
echo ""

# --- Vérification si MariaDB est déjà installé ---
if command -v mariadb >/dev/null 2>&1; then
    echo "MariaDB est déjà installé sur ce système. Arrêt du script."
    log_err "MariaDB est déjà installé — installation annulée."
    exit 0
fi

# --- Étape 1 : Mise à jour de la liste des paquets ---
echo "[1/9] Mise à jour de la liste des paquets..."
$PKG_UPDATE >> "$LOG" 2>> "$LOG" || quitter "Échec de la mise à jour de la liste des paquets"
log_ok "Mise à jour de la liste des paquets réussie"

# --- Étape 2 : Installation de MariaDB Server ---
echo "[2/9] Installation de MariaDB Server..."
$PKG_INSTALL $MARIADB_PKG >> "$LOG" 2>> "$LOG" || quitter "Échec de l'installation de MariaDB"
log_ok "Installation de MariaDB réussie"

# --- Étape 3 : Mise à jour des dépendances ---
echo "[3/9] Mise à jour des dépendances..."
$PKG_UPGRADE >> "$LOG" 2>> "$LOG" || quitter "Échec de la mise à jour des dépendances"
log_ok "Mise à jour des dépendances réussie"

# --- Étape 4 : Démarrage du service MariaDB ---
echo "[4/9] Démarrage du service MariaDB..."
$SERVICE_START $MARIADB_SERVICE >> "$LOG" 2>> "$LOG" || quitter "Échec du démarrage du service MariaDB"
log_ok "Service MariaDB démarré"

# --- Étape 5 : Activation de MariaDB au démarrage du système ---
echo "[5/9] Activation de MariaDB au démarrage..."
$SERVICE_ENABLE $MARIADB_SERVICE >> "$LOG" 2>> "$LOG" || quitter "Échec de l'activation de MariaDB au démarrage"
log_ok "MariaDB activé au démarrage du système"

# --- Étape 6 : Sécurisation de MariaDB ---
echo "[6/9] Sécurisation de MariaDB..."
mysql -u root >> "$LOG" 2>> "$LOG" << EOF || quitter "Échec de la sécurisation de MariaDB"
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF
log_ok "Sécurisation réussie : mot de passe root défini, utilisateurs anonymes supprimés, connexion root distante désactivée, base test supprimée, privilèges rechargés"

# --- Étape 7 : Création de la base de données ---
echo "[7/9] Création de la base de données '$DB_NAME'..."
mysql -u root -p"$ROOT_PASSWORD" >> "$LOG" 2>> "$LOG" << EOF || quitter "Échec de la création de la base de données '$DB_NAME'"
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
EOF
log_ok "Base de données '$DB_NAME' créée"

# --- Étapes 8 & 9 : Création de l'utilisateur ---
echo "[8/9] Création de l'utilisateur '$DB_USER'..."
mysql -u root -p"$ROOT_PASSWORD" >> "$LOG" 2>> "$LOG" << EOF || quitter "Échec de la création de l'utilisateur '$DB_USER'"
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
EOF
log_ok "Utilisateur '$DB_USER' créé"

# --- Étapes 10 & 11 : Attribution des droits et rechargement des privilèges ---
echo "[9/9] Attribution des droits à '$DB_USER' sur '$DB_NAME'..."
mysql -u root -p"$ROOT_PASSWORD" >> "$LOG" 2>> "$LOG" << EOF || quitter "Échec de l'attribution des droits à '$DB_USER'"
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF
log_ok "Droits accordés à '$DB_USER' sur la base '$DB_NAME' — Privilèges rechargés"

# --- Étape 12 : Redémarrage de MariaDB ---
echo ""
echo "Redémarrage du service MariaDB..."
$SERVICE_RESTART $MARIADB_SERVICE >> "$LOG" 2>> "$LOG" || quitter "Échec du redémarrage de MariaDB"
log_ok "Service MariaDB redémarré"

# --- Étape 13 : Affichage du statut ---
echo ""
echo "--- Statut du service MariaDB ---"
$SERVICE_STATUS $MARIADB_SERVICE --no-pager
echo ""

# --- Fin du log ---
echo "=============================================" >> "$LOG"
echo " Installation terminée — $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo "=============================================" >> "$LOG"

# --- Étape 14 : Message de fin ---
echo "============================================="
echo " Installation terminée avec succès !"
echo "  Base de données : $DB_NAME"
echo "  Utilisateur     : $DB_USER"
echo "  Fichier log     : $LOG"
echo "============================================="

```

<!-- Inclure :

la logique du script ;

le code du script ;

les commandes importantes utilisées. -->

## 6. Tester

Les prochains tests déterminent la conformité du livrable par rapport aux exigences du cahier des charges. Les tests ont permis de valider le comportement du programme dans des conditions normales et en présence d'erreurs.

### 6.1 Cas de tests

#### Test 1 - Lancer le script sans paramètres

`sudo ./install_mariadb.sh`

#### test 2 - relecture du journal

`cat install_mariadb.log`

#### test 3 - MariaDB est installé

`mariadb --version`

#### test 4 - Le service fonctionne

`systemctl status mariadb`

#### test 5 - la base de donnée existe

`mariadb -u root -p -e "SHOW DATABASES;"`

#### test 6 - l'utilisateur existe

`mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"`
<!-- Décrire :

les tests réalisés ;

les erreurs rencontrées ;

les corrections effectuées ;

le contenu du log. -->

## 7. Évaluer


Ce projet démontre l’intérêt de l’automatisation dans l’administration système. Grâce au script développé, l’installation et la sécurisation de MariaDB peuvent être réalisées rapidement, de manière reproductible et sans intervention manuelle. La journalisation intégrée facilite le suivi des opérations et le dépannage en cas d’erreur. Cette solution permet ainsi de gagner du temps, de réduire les risques d’oubli lors de la configuration et d’assurer une meilleure cohérence entre les différents serveurs.

<!-- Répondre :

Qu’est-ce qui a bien fonctionné ?

Qu’est-ce qui a été difficile ?

Qu’as-tu appris ?

Que ferais-tu différemment la prochaine fois ? -->

## 8. Conclusion

Ce projet m'a énormément apporté dans le cadre du module. En effet, je connaissais la plupart des commandes nécessaires à effectuer 