#!/bin/bash

# ------------------------------
# Configuration
# ------------------------------
BACKUP_DIR="/Users/staillan/dev/compose/backup"  # Mettez ici un chemin absolu
TIMESTAMP=$(date +"%Y%m%d%H%M%S")      # Horodatage pour identifier chaque backup
LOG_FILE="$BACKUP_DIR/backup_log_$TIMESTAMP.log" # Fichier de log

# Crée le répertoire de sauvegarde s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# ------------------------------
# Fonction de sauvegarde
# ------------------------------
backup_volume() {
    local volume_name=$1
    local backup_file="$BACKUP_DIR/${volume_name}_backup_$TIMESTAMP.tar.gz"

    echo "🔄 Démarrage de la sauvegarde du volume: $volume_name" | tee -a "$LOG_FILE"

    podman volume inspect "$volume_name" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Erreur : Le volume $volume_name n'existe pas." | tee -a "$LOG_FILE"
        return 1
    fi

    # Sauvegarde du volume dans un fichier .tar.gz
    podman run --rm \
        --platform=linux/arm64 \
        -v "$volume_name:/data" \
        -v "$BACKUP_DIR:/backup:Z" \
        alpine sh -c \
        "tar czf /backup/${volume_name}_backup_$TIMESTAMP.tar.gz -C /data ."

    if [ $? -eq 0 ]; then
        echo "✅ Volume $volume_name sauvegardé avec succès : $backup_file" | tee -a "$LOG_FILE"
    else
        echo "❌ Échec de la sauvegarde du volume $volume_name." | tee -a "$LOG_FILE"
    fi
}

# ------------------------------
# Liste des volumes Podman
# ------------------------------
echo "📦 Récupération de la liste des volumes Podman..." | tee -a "$LOG_FILE"

VOLUMES=$(podman volume ls --format "{{.Name}}")
if [ -z "$VOLUMES" ]; then
    echo "❌ Aucun volume trouvé." | tee -a "$LOG_FILE"
    exit 1
fi

echo "🔍 Volumes détectés : $VOLUMES" | tee -a "$LOG_FILE"

# ------------------------------
# Boucle de sauvegarde des volumes
# ------------------------------
for volume in $VOLUMES; do
    backup_volume "$volume"
done

# ------------------------------
# Fin de la sauvegarde
# ------------------------------
echo "✅ Sauvegarde terminée. Les fichiers de sauvegarde se trouvent dans $BACKUP_DIR" | tee -a "$LOG_FILE"
