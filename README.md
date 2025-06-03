# Enviro Watch

**Enviro Watch** ist ein umfassendes IoT-Projekt zur Überwachung von Umweltparametern wie Temperatur, Luftfeuchtigkeit, Luftdruck und Luftqualität. Es kombiniert ESP-basierte Geräte, Sensoren (BME-280 und MQ-135), Firebase als Backend und eine Flutter-App zur Visualisierung und Interpretierung der Daten.

---

## **Projektübersicht**

### **Funktionen:**
- **Datenaufnahme:** Erfassung von Umweltparametern über zwei Messgeräte.
- **Anzeige:** 
  - Waveshare-Display zur Darstellung wichtiger Messwerte.
  - LED-basierte Anzeige für Echtzeit-Reaktionen.
- **Visualisierung:** Graphische Darstellung der Messwerte in einer Flutter-App.
- **Cloud-Speicherung:** Firebase zur Speicherung und Verwaltung der Umweltdaten.

### **Hardware-Komponenten:**
- 2 ESP-Messgeräte mit:
  - BME-280 Sensor (Temperatur, Luftfeuchtigkeit, Luftdruck)
  - MQ-135 Sensor (Luftqualität)
- 1 ESP-Gerät mit Waveshare-Display
- 1 ESP-Gerät zur LED-basierten Anzeige

---

## **Projektstruktur**
Die Dateien sind in folgende Verzeichnisse gegliedert:
- **`app/`**: Flutter-App-Code
  - Enthält die Haupt- und Seitenlogik der App.
- **`hardware/`**: Hardware-Dokumentation
  - Fritzing-Skizzen, Schaltpläne und Fotos der Geräte.
- **`backend/`**: Firebase-Konfiguration und Dokumentation.

---

## **Installation**

### **Voraussetzungen**
- Flutter SDK
- Firebase-Konto
- ESP-Programmierumgebung (z. B. Arduino IDE oder PlatformIO)

### **Schritte**
1. **Hardware aufbauen:** 
   - Fritzing-Skizze und Schaltpläne aus dem Ordner `hardware/schematics/` verwenden.
2. **Backend einrichten:**
   - Firebase-Projekt erstellen und Konfiguration aus `backend/firebase/` importieren.
3. **App starten:**
   - Flutter-App mit `flutter run` ausführen.

---

## **Vorschau**

### **Hardware-Fotos**
![Messgerät 1](hardware/photos/device_1.jpg)
![Setup Übersicht](hardware/photos/setup_overview.jpg)

### **App Screenshots**
_Bitte hier App-Screenshots hinzufügen._

---

## **Autoren**
Projekt erstellt von [Dein Name].

---

## **Lizenz**
Dieses Projekt steht unter der MIT-Lizenz. Details siehe `LICENSE`.
