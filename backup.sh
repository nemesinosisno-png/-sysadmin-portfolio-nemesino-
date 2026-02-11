#!/bin/bash
LOGFILE="/home/nemesino/backup.log"
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR="/home/nemesino/backups"

# Crea log SIEMPRE
touch "$LOGFILE"
echo "$(date): 🚀 Iniciando backup" | tee -a "$LOGFILE"

mkdir -p "$BACKUP_DIR"

# Nginx config (SIN sudo redirection)
sudo tar czf "$BACKUP_DIR/nginx-config-$DATE.tar.gz" /etc/nginx/
if [ $? -eq 0 ]; then
    echo "$(date): ✅ Nginx config OK ($(du -sh "$BACKUP_DIR/nginx-config-$DATE.tar.gz"))" | tee -a "$LOGFILE"
else
    echo "$(date): ❌ Nginx config FALLO" | tee -a "$LOGFILE"
fi

# Web files
sudo tar czf "$BACKUP_DIR/web-files-$DATE.tar.gz" /var/www/
if [ $? -eq 0 ]; then
    echo "$(date): ✅ Web files OK ($(du -sh "$BACKUP_DIR/web-files-$DATE.tar.gz"))" | tee -a "$LOGFILE"
else
    echo "$(date): ❌ Web files FALLO" | tee -a "$LOGFILE"
fi

# Docker container
docker export mi-nginx > "$BACKUP_DIR/nginx-container-$DATE.tar" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "$(date): ✅ Docker container OK ($(du -sh "$BACKUP_DIR/nginx-container-$DATE.tar"))" | tee -a "$LOGFILE"
else
    echo "$(date): ⚠️ Docker container sin cambios" | tee -a "$LOGFILE"
fi

# Limpieza
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete 2>/dev/null
find "$BACKUP_DIR" -name "*.tar" -mtime +7 -delete 2>/dev/null

echo "$(date): 🎉 Backup COMPLETADO. Total: $(du -sh "$BACKUP_DIR")" | tee -a "$LOGFILE"
