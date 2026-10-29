default:
    @just --list

setup:
    lefthook install

check:
    python3 scripts/check_repository.py
    swiftc -typecheck Examples/ScannerCore/*.swift

test:
    swift test

preview:
    python3 -m http.server 8765 --bind 127.0.0.1
