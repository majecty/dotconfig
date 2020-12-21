#!/bin/sh

echo "Sync"
rsync -rauLvh --no-links --rsync-path="sudo rsync" jh-dns:/etc/letsencrypt/live/i.juhyung.dev/ /home/juhyung/keys/
echo "Sync DONE"
