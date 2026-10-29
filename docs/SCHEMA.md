# Data model

| Model | Responsibility |
| --- | --- |
| CardItem | One physical copy, including card identity, printing, language, condition, notes, and optional folder and deck assignments. |
| Deck | A named recipe with a variant, format, and entries. |
| DeckEntry | Card identity, Main/Extra/Side section, quantity, and cached details for offline display. |
| CollectionFolder | A named collection folder with its own identity. |

Three physical copies are three CardItems. A recipe can represent them with one DeckEntry of quantity three. Physical deck assignments remain separate from recipe quantities, so a copy assigned elsewhere is not counted as available.

SwiftData persists these models locally. Draft scans and cached card responses use JSON; images use a file cache; preferences use UserDefaults.

The showcase contains no database. Screenshot cards, text, prices, quantities, and IDs are synthetic demo content.
