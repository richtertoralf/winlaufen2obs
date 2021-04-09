# winlaufen2obs
Das Skript wettkampfzeit.sh liefert eine formatierte Uhrzeit und speichert diese als Text in einer Textdatei.
Das Skript starter2obs.sh liest aus einer csv-Datei jeweils zur aktuellen Startzeit die Daten der gemeldeten Starter und gibt diese Daten als Textdateien aus.
Diese Textdateien können dann in OBS als Textquelle eingebunden werden.  
In der aktuellen Version werden auch die Nationaflaggen der Teilnehmer eingeblendet.
Achtung. OBS benötigt scheinbar größere Resourcen beim Nachladen der Texte. Gerade bei Sprintwettbewerben mit z.B. je sechs Startern je Head, gibt es sichtbare Verzögerungen bei der Anzeige, wenn z.B. für jeden Starter der Name, Vorname, Verein, Geburtsjahr, FIS-Punkte, Nation und Flagge angezeigt werden sollen.  
Beim Einblenden der Wettkampfzeit mit Zehntelsekunden, OBS muss also mindestens 10 mal je Sekunde die entsprechende Textdatei öffnen, auslesen und wieder schließen, werden ebenfalls größere Resourcen benötigt. Deshalb gibt es nur eine Sekundenanzeige.  
## Beispiel
![Screenshot](Screenshot_texteinblendung.png)
## Prinzipskizze
![UML](Start2OBS.png)
