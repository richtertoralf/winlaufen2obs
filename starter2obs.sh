#!/bin/bash

# ----------------------------------------------------------------------
# Plugin für OBS (LINUX-VERSION)
# Version vom 23.09.2020
# Autor: Toralf Richter
# getestet mit Ubuntu 20.04 Desktop (Linux)
#              Export aus Winlaufen Version 14.01 und 15 (Windows 10)
#              OBS 25.0.3 und 25.0.8 (Linux)
# ----------------------------------------------------------------------
# Weitere Infos findest du in der Datei readme.txt
# ----------------------------------------------------------------------


clear
# Ermitteln der Prozessnummer
ProgrammPID=$$
# und des Programmnamens
ProgrammName=$0
# und Abspeichern in starter2obsPID
echo ProgrammPID = $ProgrammPID > Konfiguration/starter2obsPID.txt
echo ProgrammName = $ProgrammName >> Konfiguration/starter2obsPID.txt
# um das Programm/Script extern, z.B. über PHP stoppen zu können.
# Sollte dieses Programm sehr oft benutzt werden, bietet es sich an,
# die systemctl Befehle des System-Managers Systemd zu nutzen
# und dieses Programm alternativ als Dienst auszuführen.
# z.B.: sudo systemctl restart starter2obs.service
# start, stop, restart, enable, disable, status , is-active, ...
echo Das Programm $ProgrammName mit der PID $ProgrammPID wird gestartet.
rm -f Textquellen/*.txt
echo Der Ordner /Textquellen wurde leergeräumt! Alte Dateien gelöscht.

# EinblendeZeit, AusblendeZeit und Zeitkorrektur einlesen
source Konfiguration/winlaufen2obs.conf
# Test, obs funktioniert ;-) 
echo Folgende Werte wurden aus der Konfigurationsdatei geladen:
echo EinblendeZeit = $EinblendeZeit Sekunden, AusblendeZeit = $AusblendeZeit Sekunden
echo Es erfolgt eine Korrektur der Wettkampfzeit um = $Zeitkorrektur Sekunden.
# Einlesen der Daten aus Startliste.csv und abspeichern in einem Array
# Achtung, sollte sich die Startliste nach dem Start dieses Programms
# ändern, muss dieses Programm neu gestartet werden!!
# Dies gilt auch für die Einblende- + Ausblendezeit sowie Zeitkorrektur.
typeset -i i=0
while read sportler[$i]
	do i=i+1
done < Startliste/Startliste.csv
anzsportler=${#sportler[*]} 

# Die folgende for-Schleife ist Spielerei und 
# zaubert nur paar paar Punkte in das Terminalfenster:
echo Startliste.csv laden:
for ((dot=0; dot<66; dot++)); do echo -n '.'; sleep 0.01; done
echo
# Ende der Spielerei

# Test obs geklappt hat:
echo Es wurden $anzsportler Datensätze eingelesen.
sleep 1
echo Erster Datensatz: ${sportler[0]}
sleep 1
echo zweiter Datensatz: ${sportler[1]}
echo zweitletzter Datensatz: ${sportler[ (( $anzsportler-2 )) ]}
sleep 1
echo vorletzter Datensatz: ${sportler[ (( $anzsportler-1 )) ]}
echo letzter Datensatz: ${sportler[$anzsportler]}
sleep 1
echo Es kann sein, das die letzten beiden Datensätze leer sind.
echo Im ersten Datensatz stehen die Bezeichnungen der Spalten.
# Bei den getesteten Startliste.csv-Dateien waren die zweitletzten
# Datensätze jeweils leer und der erste Datensatz enthält die
# Beschreibungen der Spalten. Das folgende Programm funktioniert
# unabhängig davon, da gezielt nach Datensätzen mit Startzeiten 
# gesucht wird.
echo -------------------------------------------------------------------
sleep 1
echo Sind die Werte in Ordnung? Wurde die richtige Startliste.csv geladen?
echo Prüfe auch nochmal die Ein- und Ausblendezeiten!
echo ...................................................................
echo Starte das Programm mit den obigen Daten:         [Enter]
read -p "Abbrechen und die Konfigurationsdatei bearbeiten: [a] + [Enter]" taste
if [[ "$taste" = a ]]
then exit
else clear; echo Programm läuft jetzt!
fi
echo Achtung: Wenn du dieses Terminalfenster schließt, wird das Programm beendet!

# Start der Endlosschleife
while true
do 

	# SystemZeit/Timestamp in Sekunden 
	SystemZeit=$(date +%s)
	# eventuelle Korrektur der WettkampfZeit
	WettkampfZeit=$(( $SystemZeit+$Zeitkorrektur ))
	# Einblende + AusblendeZeit wurden aus winlaufen2obs.conf eingelesen
	AnzeigeStartZeit=$(( $WettkampfZeit+$EinblendeZeit ))
	AnzeigeEndeZeit=$(( $WettkampfZeit+$EinblendeZeit+$AusblendeZeit ))
	# und jetzt wird der neu berechnete Timestamp formatiert
	AnzeigeStartZeit=$(date -d @$AnzeigeStartZeit +"%H:%M:%S")
	AnzeigeEndeZeit=$(date -d @$AnzeigeEndeZeit +"%H:%M:%S")
	# Die Zeiten sind jetzt so formatiert, 
	# das sie mit den Startzeiten in der Startliste.csv
	# verglichen werden können. Format z.B. 10:30:00 (10 Uhr 30 Minuten)
	# Test, obs klappt:
	# echo AnzeigeStartZeit: $AnzeigeStartZeit
	# echo AnzeigeEndeZeit: $AnzeigeEndeZeit
	# echo
	# read -p "Alles o.k. bis hierher? ... [Enter] für Weiter drücken:" taste
	
	for ((z=1; z<$anzsportler; z++)); do
		# Einblenden
		s=1
		while [[ ${sportler[$z]} =~ $AnzeigeStartZeit ]]
			# nur wenn es einen Starter zur aktuellen Wettkampfzeit
			# gibt, werden neue Datensätze für OBS geschrieben.
			do
			StarterDatensatz=${sportler[$z]}
			StarterVorname=$(echo $StarterDatensatz | cut -d, -f2)
			StarterName=$(echo $StarterDatensatz | cut -d, -f1)
			Starter="$StarterVorname"' '"$StarterName"
			echo $Starter > "Textquellen/Starter"$s"Name.txt"
			echo $StarterDatensatz | cut -d, -f3  > "Textquellen/Starter"$s"Verein.txt"
			echo $StarterDatensatz | cut -d, -f4  > "Textquellen/Starter"$s"Verband.txt"
			echo $StarterDatensatz | cut -d, -f5  > "Textquellen/Starter"$s"Startnummer.txt"
			echo $StarterDatensatz | cut -d, -f6  > "Textquellen/Starter"$s"Klasse.txt"
			echo $StarterDatensatz | cut -d, -f7  > "Textquellen/Starter"$s"Strecke.txt"
			echo $StarterDatensatz | cut -d, -f8  > "Textquellen/Starter"$s"Startzeit.txt"
			echo $StarterDatensatz | cut -d, -f9  > "Textquellen/Starter"$s"Jahrgang.txt"
			echo $StarterDatensatz | cut -d, -f10  > "Textquellen/Starter"$s"Geschlecht.txt"
			echo $StarterDatensatz | cut -d, -f11  > "Textquellen/Starter"$s"Nation.txt"
			Flagge=$(echo $StarterDatensatz | cut -d, -f11)
			if [ $Flagge ]
				then cp Bildquellen/$Flagge.png "Bildquellen/OBSFlagge"$s".png"
				else cp Bildquellen/FlaggTrans.png "Bildquellen/OBSFlagge"$s".png"
				# Die transparente Flagge wird eingefügt, wenn in der
				# Startliste keine Nation angegeben wurde.
				# Achtung, sollten in der Startliste andere Nationenkürzel
				# verwendet werden, als bei den Flaggen.png Dateien, dann 
				# gibt es im Terminal eine Fehlermeldung und es bleibt die
				# im vorherigen Datensatz augewählte Flagge stehen.
				# Damit die Flaggen in OBS an der gleichen Position angezeigt
				# werden, müssen sie die gleiche Größe haben. Da Flaggen
				# ein unterschiedliches Höhen-Seiten-Verhältnis haben,
				# sollte ein transparenter Rahmen zu jeder Flagge hinzugefügt
				# werden. (geht gut mit Gimp oder Irfanview)
			fi
			let z=$z+1; let s=$s+1
			# Gibt es mehrere Startnummern mit der selben Startzeit?
			# Dazu wird der Sportler-Zähler hochgesetzt und in der 
			# while-Schleife geprüft, ob der nächste Sportler die
			# gleiche Startzeit hat. wenn nein, wird die Schleife 
			# verlassen, wenn ja werden für den nächsten Sportler
			# ebenfalls Datensätze für OBS geschrieben. Mit dem 
			# Schleifenzähle $s erfolgt die Kennzeichnung der Datensätze.
			# ACHTUNG: Bei einem Massenstart mit 1000 Startern, werden 
			# dann auch 1000 mal diese ca. 10 Datensätze geschrieben!!!
		done
		# und jetzt Ausblenden
		s=1
		while [[ ${sportler[$z]} =~ $AnzeigeEndeZeit ]]
			# wenn es einen Starter zur aktuellen AnzeigeEndeZeit gibt,
			# werden die txt-Dateien für OBS auf "null" gesetzt.
			do
			echo > "Textquellen/Starter"$s"Name.txt"
			echo > "Textquellen/Starter"$s"Verein.txt"
			echo > "Textquellen/Starter"$s"Verband.txt"
			echo > "Textquellen/Starter"$s"Startnummer.txt"
			echo > "Textquellen/Starter"$s"Klasse.txt"
			echo > "Textquellen/Starter"$s"Strecke.txt"
			echo > "Textquellen/Starter"$s"Startzeit.txt"
			echo > "Textquellen/Starter"$s"Jahrgang.txt"
			echo > "Textquellen/Starter"$s"Geschlecht.txt"
			echo > "Textquellen/Starter"$s"Nation.txt"
			cp Bildquellen/FlaggTrans.png "Bildquellen/OBSFlagge"$s".png"
			let z=$z+1; let s=$s+1
		done
	done
	sleep 0.9 
	# ohne sleep sehr hohe CPU-Last!
	# Die Schleife muss aber mindestens 1x pro Sekunde durchlaufen werden,
	# sonst werden die Startzeiten nicht gefunden, deshalb 0,9 Sekunden.
	
done

# Programmende
