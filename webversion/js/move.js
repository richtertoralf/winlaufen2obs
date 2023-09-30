

// Objekte auswählen
var objekte = document.querySelectorAll('.movable');
var offsetX, offsetY;
var dragging = false;
var selectedObjekt = null;
var koordinatenAnzeige = null;

// Mausklick-Ereignis für jedes Objekt hinzufügen
objekte.forEach(function(objekt) {
    objekt.addEventListener('mousedown', startDragging);
});

// Funktion zum Starten des Ziehvorgangs
function startDragging(e) {
    dragging = true;
    selectedObjekt = e.target;
    // Berechne die Verschiebung des Mausklicks innerhalb des ausgewählten Objekts
    offsetX = e.clientX - selectedObjekt.getBoundingClientRect().left;
    offsetY = e.clientY - selectedObjekt.getBoundingClientRect().top;
    // Erstelle das Koordinaten-Anzeige-Element
    koordinatenAnzeige = document.createElement('div');
    koordinatenAnzeige.className = 'koordinaten-anzeige';
    document.body.appendChild(koordinatenAnzeige);
    // Füge Mausbewegungs- und Mausklick-Freigabe-Ereignisse hinzu
    document.addEventListener('mousemove', dragObject);
    document.addEventListener('mouseup', stopDragging);
}

// Funktion zum Verschieben des ausgewählten Objekts
function dragObject(e) {
    if (dragging && selectedObjekt) {
        // Berechne die neue Position des ausgewählten Objekts basierend auf der Mausbewegung und der Verschiebung des Mausklicks
        var x = e.clientX - offsetX;
        var y = e.clientY - offsetY;
        
        // Runde die x-Position auf das nächste Rasterintervall (z.B., 10 Pixel)
        x = Math.round(x / 10) * 10;
        // Runde die y-Position auf das nächste Rasterintervall
        y = Math.round(y / 10) * 10;

        // Setze die neue Position des ausgewählten Objekts
        selectedObjekt.style.left = x + 'px';
        selectedObjekt.style.top = y + 'px';

        // Aktualisiere die Koordinaten-Anzeige
        koordinatenAnzeige.textContent = 'X: ' + x + 'px, Y: ' + y + 'px';
    }
}


// Funktion zum Beenden des Ziehvorgangs
function stopDragging() {
    dragging = false;
    selectedObjekt = null;
    // Entferne das Koordinaten-Anzeige-Element
    if (koordinatenAnzeige) {
        document.body.removeChild(koordinatenAnzeige);
    }
    // Entferne Mausbewegungs- und Mausklick-Freigabe-Ereignisse
    document.removeEventListener('mousemove', dragObject);
    document.removeEventListener('mouseup', stopDragging);
}
