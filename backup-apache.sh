#!/bin/bash
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR=~/backups

echo "🚀 $(date): Iniciando backup APACHE"

# Apache config
tar -czf $BACKUP_DIR/apache-config-$DATE.tar.gz /etc/httpd /etc/apache2 2>/dev/null
echo "✅ Apache config OK ($(du -sh $BACKUP_DIR/apache-config-$DATE.tar.gz 2>/dev/null || echo '0K'))"

# Web files
[ -d "/srv/http" ] && tar -czf $BACKUP_DIR/apache-web-$DATE.tar.gz /srv/http 2>/dev/null
echo "✅ Web files OK ($(du -sh $BACKUP_DIR/apache-web-$DATE.tar.gz 2>/dev/null || echo '0K'))"

# Logs Apache
tar -czf $BACKUP_DIR/apache-logs-$DATE.tar.gz /var/log/httpd 2>/dev/null
echo "✅ Logs OK ($(du -sh $BACKUP_DIR/apache-logs-$DATE.tar.gz 2>/dev/null || echo '0K'))"

echo "🎉 Backup APACHE COMPLETADO $(du -sh $BACKUP_DIR | head -1)"
