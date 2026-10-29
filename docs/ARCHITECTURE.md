# Architektur

## Präsentations-Repository
GitHub rendert README und Dokumentation. PNG-Screenshots liegen unter `assets/screenshots/`; eigenständig gestaltete Demo-Karten unter `assets/demo-cards/`. Das Swift-Package enthält ausgewählte, von Kamera, Netzwerk und SwiftData unabhängige Kernlogik. Es ist keine startfähige iOS-App.

## Gezeigte App
Native iOS-App für iOS 17+: SwiftUI, SwiftData, AVFoundation, Vision und URLSession. Feature-Bereiche: Scanner, Sammlung, Decks, Suche und Einstellungen. Geschäftslogik und Modelle liegen getrennt von den Views im Core-Bereich.

Ein Kamerabild wird auf die Lesezone begrenzt, per Vision erkannt und über mehrere unterschiedliche Bilder bestätigt. Ein bestätigter Treffer wird erst als Entwurf gesammelt. Erst der ausdrückliche Transfer verändert Sammlung oder Deck.

SwiftData speichert physische Karten, Decks, Deckeinträge und Ordner lokal. API-Antworten und Bilder werden getrennt zwischengespeichert. Ein Export erzeugt JSON-Sicherungen, XML zur Analyse oder YDK-Deckrezepte.

## Screenshot-Verfahren
Eine temporäre Kopie des privaten Projekts wird mit isolierten Demo-Daten und eigenen Bilddateien gestartet. Die ursprünglichen UI-Komponenten werden verwendet. Keine persönlichen Daten und keine historischen App-Dateien werden in dieses Repository kopiert. Das vollständige temporäre Projekt ist kein Bestandteil des Portfolios.

## Qualität
`just check` prüft Dokumentationslinks und Veröffentlichungsgrenzen; `just test` führt die Swift-Tests aus. Lefthook wiederholt die passenden Prüfungen vor Commit und Push. GitHub Actions führt beide Gates auf macOS aus.

Die Swift-Buildprodukte liegen unter dem temporären Systemverzeichnis. Das hält generierte Compiler-Dateien außerhalb von iCloud-Projektordnern und vermeidet Dateisynchronisierung während des Builds.
