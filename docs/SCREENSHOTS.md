# Screenshots und Bildherkunft

## Was gezeigt wird

Die Screenshots wurden am 29. Oktober 2026 mit einem getrennten iPhone-17-Pro-Simulator aufgenommen. Sie zeigen die vorhandenen SwiftUI-Ansichten einer temporären Demo-Kopie der privaten Anwendung.

| Datei | Ansicht |
| --- | --- |
| [Sammlung](../assets/screenshots/01-collection.png) | Gruppierte Karten und Sammlungsübersicht. |
| [Deck](../assets/screenshots/02-deck.png) | Rezept, Bereiche und Bestandsanzeige. |
| [Kartendetails](../assets/screenshots/03-card-detail.png) | Lesbarer Text und Werte einer erfundenen Karte. |
| [Fehlende Karten](../assets/screenshots/04-missing-cards.png) | Bedarfsliste auf Basis physischer Verfügbarkeit. |
| [Scan-Entwurf](../assets/screenshots/05-scan-detail.png) | Detailansicht einer noch nicht übernommenen Karte. |

## Anpassungen ausschließlich für die Aufnahme

- Getrennte In-Memory-Datenbank; kein Zugriff auf die echte Sammlung.
- Erfundenes Demo-Deck sowie erfundene Karten, Werte, Texte und Preisreferenzen.
- Originale geometrische Demo-Grafiken aus [assets/demo-cards](../assets/demo-cards).
- Eigenständiges Scanner-Signet statt des privaten App-Brandings.
- Lokale Bildauflösung für die Demo-Karten; keine Abfragen nach echten Karten.
- Ein vorab gefüllter Scan-Stapel demonstriert den Entwurfsablauf. Das ist keine Aufnahme einer echten Kameraerkennung.

Die Screenshots wurden automatisiert mit XCTest aus der laufenden App aufgenommen. Die UI wurde für das Portfolio nicht als HTML nachgebaut. Der vollständige Aufnahme-Build und seine Projektdateien sind kein Bestandteil dieses Repositorys.

## Originalgrafiken

Die sechs Demo-Kartenbilder, das Scanner-Signet und der SVG-Titelbanner wurden für dieses Portfolio aus eigenen geometrischen Formen und Text erstellt. Sie enthalten keine offiziellen Kartenrahmen, Illustrationen oder übernommenen Spieltexte. Die Originale liegen unter [assets](../assets).

## Codeauszüge

- `ScanRecognition.swift`: von UI, Kamera und Netzwerk unabhängige Erkennungs- und Bestätigungslogik.
- `PrintingCode.swift`: Normalisierung und Prüfung von Auflagencodes; die vom vollständigen Kartendatenmodell abhängige Lookup-Struktur wurde weggelassen.
- `DeckInventory.swift`: unveränderte Bestandsberechnung mit den dafür erforderlichen kleinen Werttypen aus separaten App-Dateien zusammengeführt.

Diese Auszüge dienen der nachvollziehbaren technischen Begutachtung und führen keine privaten Sammlungsdaten mit.
