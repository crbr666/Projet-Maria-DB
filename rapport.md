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

**Resultat des tests**
*sans paramètres*
```
achav@debian:~$ ./install_mariadb.sh
Usage : sudo ./install_mariadb.sh <root_password> <db_name> <username> <user_password> <log_file>
Exemple : sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"
```

*avec paramètres*
```
achav@debian:~$ sudo ./install_mariadb.sh "Root123!" "app_interne" "app_user" "User123!" "install_mariadb.log"
[sudo] Mot de passe de achav :
=== Installation de MariaDB en cours... ===

[1/9] Mise à jour de la liste des paquets...
[2/9] Installation de MariaDB Server...
[3/9] Mise à jour des dépendances...
[4/9] Démarrage du service MariaDB...
[5/9] Activation de MariaDB au démarrage...
[6/9] Sécurisation de MariaDB...
[7/9] Création de la base de données 'app_interne'...
[8/9] Création de l'utilisateur 'app_user'...
[9/9] Attribution des droits à 'app_user' sur 'app_interne'...

Redémarrage du service MariaDB...

--- Statut du service MariaDB ---
● mariadb.service - MariaDB 11.8.6 database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; preset: enabled)
     Active: active (running) since Fri 2026-06-19 13:56:44 CEST; 34ms ago
 Invocation: 908bfa22d40f42819bc51e9da243b220
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
    Process: 6020 ExecStartPre=/bin/sh -c [ ! -e /usr/bin/galera_recovery ] && VAR= ||   VAR=`/usr/bin/galera_recovery`; [ $? -eq 0 ]   && echo _WSREP_START_POSITION=$VAR > /run/mysqld/wsrep-start-position || exit 1 (code=exited, status=0/SUCCESS)
    Process: 6087 ExecStartPost=/bin/rm -f /run/mysqld/wsrep-start-position /run/mysqld/wsrep-new-cluster (code=exited, status=0/SUCCESS)
    Process: 6089 ExecStartPost=/etc/mysql/debian-start (code=exited, status=0/SUCCESS)
   Main PID: 6074 (mariadbd)
     Status: "Taking your SQL requests now..."
      Tasks: 19 (limit: 30483)
     Memory: 125M (peak: 126.3M)
        CPU: 678ms
     CGroup: /system.slice/mariadb.service
             ├─6074 /usr/sbin/mariadbd
             ├─6090 /bin/bash /etc/mysql/debian-start
             ├─6093 /usr/bin/mariadb-upgrade --defaults-extra-f…
             ├─6095 grep -E -v "^(1|@had|ERROR (1051|1054|1060|…
             ├─6096 logger -p daemon warn -i -t/etc/mysql/debia…
             ├─6099 sh -c -- "'/usr/bin/mariadb' --defaults-fil…
             └─6100 /usr/bin/mariadb --defaults-file=/tmp/mysql…

jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …d.
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …d.
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …ol
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …43
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …'.
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …ts
jun 19 13:56:43 debian mariadbd[6074]: 2026-06-19 13:56:43 0 …s.
jun 19 13:56:43 debian mariadbd[6074]: Version: '11.8.6-Maria…er
jun 19 13:56:44 debian systemd[1]: Started mariadb.service -…er.
jun 19 13:56:44 debian /etc/mysql/debian-start[6091]: Upgradin….
Hint: Some lines were ellipsized, use -l to show in full.

=============================================
 Installation terminée avec succès !
  Base de données : app_interne
  Utilisateur     : app_user
  Fichier log     : install_mariadb.log
=============================================
```
#### test 2 - relecture du journal

`cat install_mariadb.log`

**Resultat des tests**

```
achav@debian:~$ cat install_mariadb.log
=============================================
 Début de l'installation — 2026-06-19 13:55:56
=============================================

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Atteint : 1 http://deb.debian.org/debian trixie InRelease
Atteint : 2 http://security.debian.org/debian-security trixie-security InRelease
Atteint : 3 http://deb.debian.org/debian trixie-updates InRelease
Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Tous les paquets sont à jour.
[2026-06-19 13:56:09] [OK]     Mise à jour de la liste des paquets réussie

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Installation de :
  mariadb-server

Installation de dépendances :
  galera-4                 libterm-readkey-perl
  gawk                     liburing2
  libaio1t64               mariadb-client
  libcgi-fast-perl         mariadb-client-core
  libcgi-pm-perl           mariadb-common
  libconfig-inifiles-perl  mariadb-plugin-provider-bzip2
  libdbd-mariadb-perl      mariadb-plugin-provider-lz4
  libdbi-perl              mariadb-plugin-provider-lzma
  libfcgi-bin              mariadb-plugin-provider-lzo
  libfcgi-perl             mariadb-plugin-provider-snappy
  libfcgi0t64              mariadb-server-core
  libhtml-template-perl    mysql-common
  libmariadb3              pv
  libpcre2-posix3          rsync
  libsigsegv2              socat

Paquets suggérés :
  gawk-doc               libipc-sharedcache-perl  doc-base
  libmldbm-perl          mailx                    python3-braceexpand
  libnet-daemon-perl     mariadb-test
  libsql-statement-perl  netcat-openbsd

Sommaire :
  Mise à niveau de : 0. Installation de : 31Supprimé : 0. Non mis à jour : 0
Taille du téléchargement : 20.4 MB
  Espace nécessaire : 201 MB / 13.5 GB disponible

Réception de : 1 http://security.debian.org/debian-security trixie-security/main amd64 libdbi-perl amd64 1.647-1+deb13u1 [861 kB]
Réception de : 2 http://deb.debian.org/debian trixie/main amd64 galera-4 amd64 26.4.23-0+deb13u1 [916 kB]
Réception de : 3 http://deb.debian.org/debian trixie/main amd64 libsigsegv2 amd64 2.14-1+b2 [34.4 kB]
Réception de : 4 http://deb.debian.org/debian trixie/main amd64 gawk amd64 1:5.2.1-2+b1 [674 kB]
Réception de : 5 http://security.debian.org/debian-security trixie-security/main amd64 rsync amd64 3.4.1+ds1-5+deb13u3 [433 kB]
Réception de : 6 http://deb.debian.org/debian trixie/main amd64 mysql-common all 5.8+1.1.1 [6’784 B]
Réception de : 7 http://deb.debian.org/debian trixie/main amd64 mariadb-common all 1:11.8.6-0+deb13u1 [29.5 kB]
Réception de : 8 http://deb.debian.org/debian trixie/main amd64 libconfig-inifiles-perl all 3.000003-3 [44.8 kB]
Réception de : 9 http://deb.debian.org/debian trixie/main amd64 libmariadb3 amd64 1:11.8.6-0+deb13u1 [187 kB]
Réception de : 10 http://deb.debian.org/debian trixie/main amd64 mariadb-client-core amd64 1:11.8.6-0+deb13u1 [919 kB]
Réception de : 11 http://deb.debian.org/debian trixie/main amd64 libpcre2-posix3 amd64 10.46-1~deb13u1 [63.9 kB]
Réception de : 12 http://deb.debian.org/debian trixie/main amd64 mariadb-client amd64 1:11.8.6-0+deb13u1 [3’164 kB]
Réception de : 13 http://deb.debian.org/debian trixie/main amd64 libaio1t64 amd64 0.3.113-8+b1 [14.9 kB]
Réception de : 14 http://deb.debian.org/debian trixie/main amd64 liburing2 amd64 2.9-1 [26.4 kB]
Réception de : 15 http://deb.debian.org/debian trixie/main amd64 mariadb-server-core amd64 1:11.8.6-0+deb13u1 [7’933 kB]
Réception de : 16 http://deb.debian.org/debian trixie/main amd64 socat amd64 1.8.0.3-1 [423 kB]
Réception de : 17 http://deb.debian.org/debian trixie/main amd64 mariadb-server amd64 1:11.8.6-0+deb13u1 [3’907 kB]
Réception de : 18 http://deb.debian.org/debian trixie/main amd64 libcgi-pm-perl all 4.68-1 [217 kB]
Réception de : 19 http://deb.debian.org/debian trixie/main amd64 libfcgi0t64 amd64 2.4.5-0.1 [25.4 kB]
Réception de : 20 http://deb.debian.org/debian trixie/main amd64 libfcgi-perl amd64 0.82+ds-3+b2 [25.3 kB]
Réception de : 21 http://deb.debian.org/debian trixie/main amd64 libcgi-fast-perl all 1:2.17-1 [11.8 kB]
Réception de : 22 http://deb.debian.org/debian trixie/main amd64 libdbd-mariadb-perl amd64 1.22-1+b4 [93.6 kB]
Réception de : 23 http://deb.debian.org/debian trixie/main amd64 libfcgi-bin amd64 2.4.5-0.1 [12.4 kB]
Réception de : 24 http://deb.debian.org/debian trixie/main amd64 libhtml-template-perl all 2.97-2 [66.5 kB]
Réception de : 25 http://deb.debian.org/debian trixie/main amd64 libterm-readkey-perl amd64 2.38-2+b4 [24.6 kB]
Réception de : 26 http://deb.debian.org/debian trixie/main amd64 mariadb-plugin-provider-bzip2 amd64 1:11.8.6-0+deb13u1 [30.1 kB]
Réception de : 27 http://deb.debian.org/debian trixie/main amd64 mariadb-plugin-provider-lz4 amd64 1:11.8.6-0+deb13u1 [30.0 kB]
Réception de : 28 http://deb.debian.org/debian trixie/main amd64 mariadb-plugin-provider-lzma amd64 1:11.8.6-0+deb13u1 [30.0 kB]
Réception de : 29 http://deb.debian.org/debian trixie/main amd64 mariadb-plugin-provider-lzo amd64 1:11.8.6-0+deb13u1 [30.0 kB]
Réception de : 30 http://deb.debian.org/debian trixie/main amd64 mariadb-plugin-provider-snappy amd64 1:11.8.6-0+deb13u1 [30.0 kB]
Réception de : 31 http://deb.debian.org/debian trixie/main amd64 pv amd64 1.9.31-1 [106 kB]
Préconfiguration des paquets...
20.4 Mo réceptionnés en 15s (1’397 ko/s)
Sélection du paquet galera-4 précédemment désélectionné.
(Lecture de la base de données... 139393 fichiers et répertoires déjà installés.)
Préparation du dépaquetage de .../galera-4_26.4.23-0+deb13u1_amd64.deb ...
Dépaquetage de galera-4 (26.4.23-0+deb13u1) ...
Sélection du paquet libsigsegv2:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../libsigsegv2_2.14-1+b2_amd64.deb ...
Dépaquetage de libsigsegv2:amd64 (2.14-1+b2) ...
Paramétrage de libsigsegv2:amd64 (2.14-1+b2) ...
Sélection du paquet gawk précédemment désélectionné.
(Lecture de la base de données... 139412 fichiers et répertoires déjà installés.)
Préparation du dépaquetage de .../00-gawk_1%3a5.2.1-2+b1_amd64.deb ...
Dépaquetage de gawk (1:5.2.1-2+b1) ...
Sélection du paquet mysql-common précédemment désélectionné.
Préparation du dépaquetage de .../01-mysql-common_5.8+1.1.1_all.deb ...
Dépaquetage de mysql-common (5.8+1.1.1) ...
Sélection du paquet mariadb-common précédemment désélectionné.
Préparation du dépaquetage de .../02-mariadb-common_1%3a11.8.6-0+deb13u1_all.deb ...
Dépaquetage de mariadb-common (1:11.8.6-0+deb13u1) ...
Sélection du paquet libdbi-perl:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../03-libdbi-perl_1.647-1+deb13u1_amd64.deb ...
Dépaquetage de libdbi-perl:amd64 (1.647-1+deb13u1) ...
Sélection du paquet libconfig-inifiles-perl précédemment désélectionné.
Préparation du dépaquetage de .../04-libconfig-inifiles-perl_3.000003-3_all.deb ...
Dépaquetage de libconfig-inifiles-perl (3.000003-3) ...
Sélection du paquet libmariadb3:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../05-libmariadb3_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de libmariadb3:amd64 (1:11.8.6-0+deb13u1) ...
Sélection du paquet mariadb-client-core précédemment désélectionné.
Préparation du dépaquetage de .../06-mariadb-client-core_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-client-core (1:11.8.6-0+deb13u1) ...
Sélection du paquet libpcre2-posix3:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../07-libpcre2-posix3_10.46-1~deb13u1_amd64.deb ...
Dépaquetage de libpcre2-posix3:amd64 (10.46-1~deb13u1) ...
Sélection du paquet mariadb-client précédemment désélectionné.
Préparation du dépaquetage de .../08-mariadb-client_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-client (1:11.8.6-0+deb13u1) ...
Sélection du paquet libaio1t64:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../09-libaio1t64_0.3.113-8+b1_amd64.deb ...
Dépaquetage de libaio1t64:amd64 (0.3.113-8+b1) ...
Sélection du paquet liburing2:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../10-liburing2_2.9-1_amd64.deb ...
Dépaquetage de liburing2:amd64 (2.9-1) ...
Sélection du paquet mariadb-server-core précédemment désélectionné.
Préparation du dépaquetage de .../11-mariadb-server-core_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-server-core (1:11.8.6-0+deb13u1) ...
Sélection du paquet rsync précédemment désélectionné.
Préparation du dépaquetage de .../12-rsync_3.4.1+ds1-5+deb13u3_amd64.deb ...
Dépaquetage de rsync (3.4.1+ds1-5+deb13u3) ...
Sélection du paquet socat précédemment désélectionné.
Préparation du dépaquetage de .../13-socat_1.8.0.3-1_amd64.deb ...
Dépaquetage de socat (1.8.0.3-1) ...
Paramétrage de mysql-common (5.8+1.1.1) ...
update-alternatives: utilisation de « /etc/mysql/my.cnf.fallback » pour fournir « /etc/mysql/my.cnf » (my.cnf) en mode automatique
Paramétrage de mariadb-common (1:11.8.6-0+deb13u1) ...
update-alternatives: utilisation de « /etc/mysql/mariadb.cnf » pour fournir « /etc/mysql/my.cnf » (my.cnf) en mode automatique
Sélection du paquet mariadb-server précédemment désélectionné.
(Lecture de la base de données... 140091 fichiers et répertoires déjà installés.)
Préparation du dépaquetage de .../00-mariadb-server_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-server (1:11.8.6-0+deb13u1) ...
Sélection du paquet libcgi-pm-perl précédemment désélectionné.
Préparation du dépaquetage de .../01-libcgi-pm-perl_4.68-1_all.deb ...
Dépaquetage de libcgi-pm-perl (4.68-1) ...
Sélection du paquet libfcgi0t64:amd64 précédemment désélectionné.
Préparation du dépaquetage de .../02-libfcgi0t64_2.4.5-0.1_amd64.deb ...
Dépaquetage de libfcgi0t64:amd64 (2.4.5-0.1) ...
Sélection du paquet libfcgi-perl précédemment désélectionné.
Préparation du dépaquetage de .../03-libfcgi-perl_0.82+ds-3+b2_amd64.deb ...
Dépaquetage de libfcgi-perl (0.82+ds-3+b2) ...
Sélection du paquet libcgi-fast-perl précédemment désélectionné.
Préparation du dépaquetage de .../04-libcgi-fast-perl_1%3a2.17-1_all.deb ...
Dépaquetage de libcgi-fast-perl (1:2.17-1) ...
Sélection du paquet libdbd-mariadb-perl précédemment désélectionné.
Préparation du dépaquetage de .../05-libdbd-mariadb-perl_1.22-1+b4_amd64.deb ...
Dépaquetage de libdbd-mariadb-perl (1.22-1+b4) ...
Sélection du paquet libfcgi-bin précédemment désélectionné.
Préparation du dépaquetage de .../06-libfcgi-bin_2.4.5-0.1_amd64.deb ...
Dépaquetage de libfcgi-bin (2.4.5-0.1) ...
Sélection du paquet libhtml-template-perl précédemment désélectionné.
Préparation du dépaquetage de .../07-libhtml-template-perl_2.97-2_all.deb ...
Dépaquetage de libhtml-template-perl (2.97-2) ...
Sélection du paquet libterm-readkey-perl précédemment désélectionné.
Préparation du dépaquetage de .../08-libterm-readkey-perl_2.38-2+b4_amd64.deb ...
Dépaquetage de libterm-readkey-perl (2.38-2+b4) ...
Sélection du paquet mariadb-plugin-provider-bzip2 précédemment désélectionné.
Préparation du dépaquetage de .../09-mariadb-plugin-provider-bzip2_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-plugin-provider-bzip2 (1:11.8.6-0+deb13u1) ...
Sélection du paquet mariadb-plugin-provider-lz4 précédemment désélectionné.
Préparation du dépaquetage de .../10-mariadb-plugin-provider-lz4_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-plugin-provider-lz4 (1:11.8.6-0+deb13u1) ...
Sélection du paquet mariadb-plugin-provider-lzma précédemment désélectionné.
Préparation du dépaquetage de .../11-mariadb-plugin-provider-lzma_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-plugin-provider-lzma (1:11.8.6-0+deb13u1) ...
Sélection du paquet mariadb-plugin-provider-lzo précédemment désélectionné.
Préparation du dépaquetage de .../12-mariadb-plugin-provider-lzo_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-plugin-provider-lzo (1:11.8.6-0+deb13u1) ...
Sélection du paquet mariadb-plugin-provider-snappy précédemment désélectionné.
Préparation du dépaquetage de .../13-mariadb-plugin-provider-snappy_1%3a11.8.6-0+deb13u1_amd64.deb ...
Dépaquetage de mariadb-plugin-provider-snappy (1:11.8.6-0+deb13u1) ...
Sélection du paquet pv précédemment désélectionné.
Préparation du dépaquetage de .../14-pv_1.9.31-1_amd64.deb ...
Dépaquetage de pv (1.9.31-1) ...
Paramétrage de libconfig-inifiles-perl (3.000003-3) ...
Paramétrage de galera-4 (26.4.23-0+deb13u1) ...
Paramétrage de gawk (1:5.2.1-2+b1) ...
Paramétrage de libfcgi0t64:amd64 (2.4.5-0.1) ...
Paramétrage de libcgi-pm-perl (4.68-1) ...
Paramétrage de libfcgi-bin (2.4.5-0.1) ...
Paramétrage de libhtml-template-perl (2.97-2) ...
Paramétrage de socat (1.8.0.3-1) ...
Paramétrage de libmariadb3:amd64 (1:11.8.6-0+deb13u1) ...
Paramétrage de libpcre2-posix3:amd64 (10.46-1~deb13u1) ...
Paramétrage de libaio1t64:amd64 (0.3.113-8+b1) ...
Paramétrage de pv (1.9.31-1) ...
Paramétrage de libfcgi-perl (0.82+ds-3+b2) ...
Paramétrage de libterm-readkey-perl (2.38-2+b4) ...
Paramétrage de liburing2:amd64 (2.9-1) ...
Paramétrage de libdbi-perl:amd64 (1.647-1+deb13u1) ...
Paramétrage de rsync (3.4.1+ds1-5+deb13u3) ...
rsync.service is a disabled or a static unit, not starting it.
Paramétrage de libcgi-fast-perl (1:2.17-1) ...
Paramétrage de mariadb-client-core (1:11.8.6-0+deb13u1) ...
Paramétrage de libdbd-mariadb-perl (1.22-1+b4) ...
Paramétrage de mariadb-server-core (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-client (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-plugin-provider-lz4 (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-plugin-provider-snappy (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-server (1:11.8.6-0+deb13u1) ...
Created symlink '/etc/systemd/system/multi-user.target.wants/mariadb.service' → '/usr/lib/systemd/system/mariadb.service'.
Paramétrage de mariadb-plugin-provider-bzip2 (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-plugin-provider-lzma (1:11.8.6-0+deb13u1) ...
Paramétrage de mariadb-plugin-provider-lzo (1:11.8.6-0+deb13u1) ...
Traitement des actions différées (« triggers ») pour man-db (2.13.1-1) ...
Traitement des actions différées (« triggers ») pour libc-bin (2.41-12+deb13u3) ...
Traitement des actions différées (« triggers ») pour mariadb-server (1:11.8.6-0+deb13u1) ...
[2026-06-19 13:56:40] [OK]     Installation de MariaDB réussie

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Lecture des listes de paquets…
Construction de l'arbre des dépendances…
Lecture des informations d'état…
Calcul de la mise à jour…
Sommaire :
  Mise à niveau de : 0. Installation de : 0Supprimé : 0. Non mis à jour : 0
[2026-06-19 13:56:41] [OK]     Mise à jour des dépendances réussie
[2026-06-19 13:56:41] [OK]     Service MariaDB démarré
Synchronizing state of mariadb.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable mariadb
[2026-06-19 13:56:42] [OK]     MariaDB activé au démarrage du système
[2026-06-19 13:56:42] [OK]     Sécurisation réussie : mot de passe root défini, utilisateurs anonymes supprimés, connexion root distante désactivée, base test supprimée, privilèges rechargés
[2026-06-19 13:56:42] [OK]     Base de données 'app_interne' créée
[2026-06-19 13:56:42] [OK]     Utilisateur 'app_user' créé
[2026-06-19 13:56:42] [OK]     Droits accordés à 'app_user' sur la base 'app_interne' — Privilèges rechargés
[2026-06-19 13:56:44] [OK]     Service MariaDB redémarré
=============================================
 Installation terminée — 2026-06-19 13:56:44
=============================================
```

#### test 3 - MariaDB est installé

`mariadb --version`

**Resultat des tests**

```
achav@debian:~$ mariadb --version
mariadb from 11.8.6-MariaDB, client 15.2 for debian-linux-gnu (x86_64) using  EditLine wrapper
```
#### test 4 - Le service fonctionne

`systemctl status mariadb`

**Resultat des tests**

```
achav@debian:~$ systemctl status mariadb
● mariadb.service - MariaDB 11.8.6 database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; e>
     Active: active (running) since Fri 2026-06-19 13:56:44 CES>
 Invocation: 908bfa22d40f42819bc51e9da243b220
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
    Process: 6020 ExecStartPre=/bin/sh -c [ ! -e /usr/bin/galer>
    Process: 6087 ExecStartPost=/bin/rm -f /run/mysqld/wsrep-st>
    Process: 6089 ExecStartPost=/etc/mysql/debian-start (code=e>
   Main PID: 6074 (mariadbd)
     Status: "Taking your SQL requests now..."
      Tasks: 10 (limit: 30483)
     Memory: 123.2M (peak: 128.3M)
        CPU: 815ms
     CGroup: /system.slice/mariadb.service
             └─6074 /usr/sbin/mariadbd
```

#### test 5 - la base de donnée existe

`mariadb -u root -p -e "SHOW DATABASES;"`

**Resultat des tests**

```
achav@debian:~$ mariadb -u root -p -e "SHOW DATABASES;"
Enter password:
+--------------------+
| Database           |
+--------------------+
| app_interne        |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```
#### test 6 - l'utilisateur existe

`mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"`

**Resultat des tests**
```
achav@debian:~$ mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"
Enter password:
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| app_user    | localhost |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
+-------------+-----------+
```

<!-- Décrire :

les tests réalisés ;

les erreurs rencontrées ;

les corrections effectuées ;

le contenu du log. -->

## 7. Évaluer


Ce projet démontre l’intérêt de l’automatisation dans l’administration système. Grâce au script développé, l’installation et la sécurisation de MariaDB peuvent être réalisées rapidement, de manière reproductible et sans intervention manuelle. La journalisation intégrée facilite le suivi des opérations et le dépannage en cas d’erreur. Cette solution permet ainsi de gagner du temps, de réduire les risques d’oubli lors de la configuration et d’assurer une meilleure cohérence entre les différents serveurs.

J'ai pu rapidement scripter le projet grâce à mon pseudo code, qui était limpide. Cela aide beaucoup à poser le cadre y compris lorsqu'on travaille avec une IA.

J'ai appris à utiliser des commandes sous forme de script que je n'exécutais jusque-la que séparément.

<!-- Répondre :

Qu’est-ce qui a bien fonctionné ?

Qu’est-ce qui a été difficile ?

Qu’as-tu appris ?

Que ferais-tu différemment la prochaine fois ? -->

## 8. Conclusion

Ce projet m'a énormément apporté dans le cadre du module. En effet, je connaissais la plupart des commandes nécessaires à effectuer, mais je n'avais pas encore scripté en bash.

En effet, mon entreprise formatrice utilisant beaucoup plus Powershell, c'est ce langage que j'ai choisi en priorité dans ce cours.

Je me rends compte que la logique reste totalement la même, seul le nom des commandes changent. Aussi, je n'ai pas été dépaysé durant la réalisation de ce projet.

Je compte bien utiliser ces nouvelles connaissances dans mon infrastructure personnelle. J'ai Proxmox comme hyperviseur (dérivé de Debian) et plusieurs VM et LXC sous Linux.

Un de mes prochains projet sera de créer un script pour installer Docker sur Debian. En effet, il faut effectuer plusieurs tâches en amont de l'installation et celle-ci conviennent parfaitement pour un script (ajouter le gestionnaire de paquet Docker, chercher et installer les dépendances, ...)