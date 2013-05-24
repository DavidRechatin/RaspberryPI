#!/bin/sh

CLE_USB="/dev/sda1"  # chemin du périphérique clef USB
MEDIA_PATH="/media/usb"  # chemin du dossier de montage de la clef USB
SERVICE="omxplayer"  # nom du player

clear
echo ====================
echo = Videos Diaporama =
echo ====================
echo Montage de la clef USB en cours...
sudo umount $MEDIA_PATH > /dev/null  # démonte la clef USB (si elle est déjà montée)
sudo mount -t vfat $CLE_USB $MEDIA_PATH  # monte la clef USB
sleep 5  # on se laisse du temps pour que le petit Raspberry traite la clef USB...
echo Démarrage du diaporama des médias...
setterm -cursor off

while true; do  # boucle infini
        if ps ax | grep -v grep | grep $SERVICE > /dev/null  # si le lecteur est en lecture
        then
        sleep 0.5;  # ne rien faire
else
        for entry in $MEDIA_PATH/*  # parcours la liste des fichiers médias
        do
                clear  # efface l'écran
				#echo Chargement du media $entry...  # affichage message d'information
                omxplayer -o hdmi $entry > /dev/null  # démare la lecture du média
        done
fi
done