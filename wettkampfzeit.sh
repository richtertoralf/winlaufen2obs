#!/bin/bash

# ----------------------------------------------------------------------
# Plugin für OBS
# Version vom 23.09.2020
# Autor: Toralf Richter
# getestet mit Ubuntu 20.04 Desktop (Linux)
#              Export aus Winlaufen Version 14.01 und 15 (Windows 10)
#              OBS 25.0.3 und 25.0.8 (Linux)
# ----------------------------------------------------------------------
# Dieses Script stellt die aktuelle Wettkampfzeit in einer txt-Datei
# zur Verfügung. Damit kann diese Zeit in OBS als Textquelle
# eingeblendet werden.
# Die Zeit wird im Format 00:00:00, also Stunden, Minuten und Sekunden
# zur Verfügung gestellt.
# Zur Konfiguration steht die Datei winlaufen2obs.conf zur Verfügung. 
# Dort kannst du in Ausnahmefällen auch eine Anpassung
# der Wettkampfzeit vornehmen.
#-----------------------------------------------------------------------

# Jetzt kommt das Programm:
clear
# Ermitteln der Prozessnummer
ProgrammPID=$$
# und des Programmnamens
ProgrammName=$0
# und Abspeichern in wettkampfzeitPID
echo ProgrammPID = $ProgrammPID > Konfiguration/wettkampfzeitPID.txt
echo ProgrammName = $ProgrammName >> Konfiguration/wettkampfzeitPID.txt
# um das Programm/Script extern, z.B. über PHP stoppen zu können.
echo Das Programm $ProgrammName mit der PID $ProgrammPID wird gestartet.
echo

# Wettkampfzeitkorrektur aus conf-Datei einlesen
source Konfiguration/winlaufen2obs.conf
# Test, obs funktioniert ;-) 
echo Es erfolgt eine Korrektur der Wettkampfzeit um = $Zeitkorrektur Sekunden.
echo
echo Die jeweils aktuelle Zeit findest du im Ordner Textquellen.
echo Der Name der Datei, die du in OBS einbindest lautet: WettkampfZeit.txt
echo
echo Achtung: Wenn du dieses Terminalfenster schließt, wird das Programm beendet!



# Start der Endlosschleife
while true
do 

	# SystemZeit/Timestamp in Sekunden 
	SystemZeit=$(date +%s)
	WettkampfZeit=$(( $SystemZeit+$Zeitkorrektur ))
	# Die Zeitkoorektur wird oben aus winlaufenVorabZeit.conf eingelesen
	# und jetzt wird der neu berechnete Timestamp formatiert
	WettkampfZeit=$(date -d @$WettkampfZeit +"%H:%M:%S")
	# Die WettkampfZeit ist jetzt die Systemzeit + die Zeitkorrektur und
	# so formatiert, damit sie im Format z.B. 10:30:00 also 
	# 10 Uhr 30 Minuten und 00 Sekunden ausgebeben werden kann.

	echo $WettkampfZeit > Textquellen/WettkampfZeit.txt
	
	sleep 0.9
	
done

# Programmende
