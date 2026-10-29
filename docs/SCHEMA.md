# Datenmodell und Demo-Daten

Das Präsentations-Repository selbst benötigt keine Datenbank und enthält keine Datenbankdateien.

## Datenmodell der privaten App
| Typ | Aufgabe |
| --- | --- |
| CardItem | Ein physisches Exemplar mit Karten-ID, Auflage, Sprache, Zustand, Notizen sowie optionaler Ordner- und Deckzuordnung. |
| Deck | Rezept mit Name, Variante, Format und Einträgen. |
| DeckEntry | Karten-ID, Main-/Extra-/Side-Bereich und Menge; Kartentext und Regelreferenzen werden für die Offline-Anzeige mitgespeichert. |
| CollectionFolder | Benannter Sammlungsordner mit eigener Identität. |

Drei physische Exemplare sind drei CardItems. Ein Rezept kann dagegen einen DeckEntry mit Menge drei enthalten. Eine exklusive Deckzuordnung eines physischen Exemplars wird getrennt vom Rezept geführt.

## Weitere Speicher
- Scan-Entwürfe: separate lokale JSON-Datei.
- Kartendaten: zeitlich begrenzter JSON-Cache.
- Bilder: lokaler Dateicache.
- Design-, Ton- und Haptikpräferenzen: UserDefaults.

## Veröffentlichte Demo
Namen, Texte, Preise, Besitzmengen und Decks in den Screenshots sind erfunden. Demo-IDs sind ausschließlich synthetische Testdaten und keine überprüften Spielkarten-IDs. Grafiken sind eigenständige geometrische Entwürfe. Es werden keine API-Abfragen für die Demo-Karten benötigt.
