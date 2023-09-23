// Lade die CSV-Datei mit einem XMLHttpRequest
var xhr = new XMLHttpRequest();
xhr.open('GET', 'csv/Test_StartlisteEinzelstart.csv', true);
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        var csvData = xhr.responseText;
        processData(csvData);
    }
};
xhr.send();

function processData(csvData) {
    const lines = csvData.split('\n');

    // Funktion zur Aktualisierung der Anzeige
    function updateAnzeige() {
        const jetzt = new Date(); // Aktualisiere die aktuelle Zeit bei jedem Aufruf
        const aktuelleZeit = jetzt.getHours() * 3600 + jetzt.getMinutes() * 60 + jetzt.getSeconds();

        // Durchlaufe die Zeilen der CSV-Datei und finde die passende Zeile basierend auf der Uhrzeit
        let gefundenerDatensatz = null;
        for (let i = 1; i < lines.length; i++) { // Starte bei 1, um die Header-Zeile zu überspringen
            const row = lines[i].split(',');

            if (row.length >= 8) { // Überprüfe, ob die Zeile mindestens 8 Elemente hat
                const startzeit = row[7].split(':');
                if (startzeit.length === 3) { // Überprüfe, ob die Startzeit im richtigen Format ist
                    const startzeitInSeconds = parseInt(startzeit[0]) * 3600 + parseInt(startzeit[1]) * 60 + parseInt(startzeit[2]);

                    // Ändere die Bedingung für die Anzeige
                    if (aktuelleZeit >= startzeitInSeconds - 10 && aktuelleZeit < startzeitInSeconds) {
                        gefundenerDatensatz = row;
                        break; // Beende die Schleife, wenn der Datensatz gefunden wurde
                    }
                }
            }
        }

        // Aktualisiere die HTML-Elemente mit den gefundenen Daten
        if (gefundenerDatensatz) {
            document.getElementById('stNr').textContent = gefundenerDatensatz[4];
            document.getElementById('startzeit').textContent = gefundenerDatensatz[7];
            document.getElementById('vorname').textContent = gefundenerDatensatz[1];
            document.getElementById('name').textContent = gefundenerDatensatz[0];
            document.getElementById('verein').textContent = gefundenerDatensatz[2];
            document.getElementById('nation').textContent = gefundenerDatensatz[10];
        }
    }

    // Rufe die Funktion zur Aktualisierung der Anzeige alle 5 Sekunden auf
    setInterval(updateAnzeige, 5000);

    // Initialisiere die Anzeige
    updateAnzeige();

}
