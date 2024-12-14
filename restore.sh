#!/bin/bash

# ------------------------------
# Configuration
# ------------------------------
BACKUP_DIR="/Users/staillan/dev/compose/backup"  # Répertoire de stockage des sauvegardes
TIMESTAMP=$1                          # Horodatage fourni en argument
LOG_FILE="$BACKUP_DIR/restore_log_$TIMESTAMP.log" # Fichier de log

# ------------------------------
# Validation des paramètres
# ------------------------------
if [ -z "$TIMESTAMP" ]; then
    echo "❌ Erreur : Veuillez fournir un TIMESTAMP pour la restauration."
    echo "Utilisation : ./restore_podman_volumes.sh <TIMESTAMP>"
    exit 1
fi

# Vérifiez que le répertoire de sauvegarde existe
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Erreur : Le répertoire de sauvegarde $BACKUP_DIR n'existe pas."
    exit 1
fi

echo "📦 Démarrage de la restauration des volumes à partir des fichiers de sauvegarde avec le TIMESTAMP : $TIMESTAMP" | tee -a "$LOG_FILE"

# ------------------------------
# Fonction de restauration
# ------------------------------
restore_volume() {
    local volume_name=$1
    local backup_file="$BACKUP_DIR/${volume_name}_backup_${TIMESTAMP}.tar.gz"

    echo "🔄 Restauration du volume: $volume_name à partir de $backup_file" | tee -a "$LOG_FILE"

    # Vérifiez que le fichier de sauvegarde existe
    if [ ! -f "$backup_file" ]; then
        echo "❌ Erreur : Le fichier de sauvegarde $backup_file n'existe pas." | tee -a "$LOG_FILE"
        return 1
    fi

    # Crée le volume Podman s'il n'existe pas déjà
    if ! podman volume inspect "$volume_name" &> /dev/null; then
        echo "📦 Le volume $volume_name n'existe pas, création du volume..." | tee -a "$LOG_FILE"
        podman volume create "$volume_name"
    else
        echo "📦 Le volume $volume_name existe déjà, les fichiers seront écrasés." | tee -a "$LOG_FILE"
    fi

    # Restaure le contenu de l'archive dans le volume
    podman run --rm \
        --platform=linux/arm64 \
        -v "$volume_name:/data" \
        -v "$BACKUP_DIR:/backup:Z" \
        alpine sh -c \
        "tar xzf /backup/${volume_name}_backup_${TIMESTAMP}.tar.gz -C /data"

    if [ $? -eq 0 ]; then
        echo "✅ Volume $volume_name restauré avec succès à partir de $backup_file" | tee -a "$LOG_FILE"
    else
        echo "❌ Échec de la restauration du volume $volume_name." | tee -a "$LOG_FILE"
    fi
}

# ------------------------------
# Liste des fichiers de sauvegarde
# ------------------------------
echo "📦 Recherche des fichiers de sauvegarde avec le TIMESTAMP : $TIMESTAMP" | tee -a "$LOG_FILE"

BACKUP_FILES=$(find "$BACKUP_DIR" -type f -name "*_backup_${TIMESTAMP}.tar.gz")
if [ -z "$BACKUP_FILES" ]; then
    echo "❌ Aucun fichier de sauvegarde trouvé pour le TIMESTAMP $TIMESTAMP." | tee -a "$LOG_FILE"
    exit 1
fi

echo "🔍 Fichiers de sauvegarde trouvés : " | tee -a "$LOG_FILE"
echo "$BACKUP_FILES" | tee -a "$LOG_FILE"

# ------------------------------
# Boucle de restauration des volumes
# ------------------------------
for backup_file in $BACKUP_FILES; do
    volume_name=$(basename "$backup_file" | sed -E "s/_backup_${TIMESTAMP}\.tar\.gz//")
    restore_volume "$volume_name"
done

# ------------------------------
# Fin de la restauration
# ------------------------------
echo "✅ Restauration terminée. Consultez le fichier de log $LOG_FILE pour les détails." | tee -a "$LOG_FILE"
