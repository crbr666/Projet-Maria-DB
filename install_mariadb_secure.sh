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
