# Architecture

## Application

The private app targets iOS 17+ and uses SwiftUI, SwiftData, AVFoundation, Vision, and URLSession. Its main areas are scanning, collection, decks, search, and settings.

Camera observations pass through OCR parsing, confirmation across distinct frames, and duplicate suppression. Accepted cards enter a draft batch; an explicit transfer saves them to the collection or a deck.

SwiftData stores physical copies, folders, and deck recipes. Scan drafts use a separate JSON file. Card responses and images have independent caches.

Themes share the same views and palette system. Millennium adds purple surfaces, gold frames, and a collection gallery; Branded uses crimson and pale blue accents with list layouts.

## Showcase

The Swift package contains small extracts without camera, network, or SwiftData dependencies. Screenshots come from a separate demo copy using fictional data and original artwork. English labels and a simulated scanner preview are presentation-only adjustments.

`just check` verifies sources, links, and publication boundaries; `just test` runs the Swift tests. Lefthook and GitHub Actions repeat these checks. Generated Swift build files stay in the system temporary directory to avoid synchronization conflicts.
