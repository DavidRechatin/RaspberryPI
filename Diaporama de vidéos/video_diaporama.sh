#!/bin/sh

CLE_USB="/dev/sda1"  # chemin du p�riph�rique clef USB
MEDIA_PATH="/media/usb"  # chemin du dossier de montage de la clef USB
SERVICE="omxplayer"  # nom du player

clear
echo ====================
echo = Videos Diaporama =
echo ====================
echo Montage de la clef USB en cours...
sudo umount $MEDIA_PATH > /dev/null  # d�monte la clef USB (si elle est d�j� mont�e)
sudo mount -t vfat $CLE_USB $MEDIA_PATH  # monte la clef USB
sleep 5  # on se laisse du temps pour que le petit Raspberry traite la clef USB...
echo D�marrage du diaporama des m�dias...
setterm -cursor off

while true; do  # boucle infini
        if ps ax | grep -v grep | grep $SERVICE > /dev/null  # si le lecteur est en lecture
        then
        sleep 0.5;  # ne rien faire
else
        for entry in $MEDIA_PATH/*  # parcours la liste des fichiers m�dias
        do
                clear  # efface l'�cran
				#echo Chargement du media $entry...  # affichage message d'information
                omxplayer -o hdmi $entry > /dev/null  # d�mare la lecture du m�dia
        done
fi
done