#!/usr/bin/env python3
"""Offline checks for links, image integrity and this showcase's publication scope."""

import re
import struct
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]
SKIP = {'.git', '.build', '.swiftpm', '__pycache__'}
errors = []
files = [p for p in ROOT.rglob('*') if p.is_file() and not SKIP.intersection(p.relative_to(ROOT).parts)]
required = ['README.md', 'NOTICE.md', 'Package.swift', 'AGENTS.md', 'justfile', 'lefthook.yml',
            'docs/PRD.md', 'docs/ARCHITECTURE.md', 'docs/SCHEMA.md', 'docs/TASKS.md',
            'docs/SCREENSHOTS.md', 'assets/hero.svg', '.github/workflows/check.yml']
required += [f'assets/screenshots/{name}.png' for name in
             ['01-collection', '02-deck', '03-card-detail', '04-missing-cards', '05-scan-detail']]
for name in required:
    if not (ROOT / name).is_file():
        errors.append('Missing required file: ' + name)

def check_link(origin, value):
    value = unquote(value.split('#', 1)[0])
    if not value or re.match(r'^[a-z]+:', value):
        return
    target = (origin.parent / value).resolve()
    if not target.is_relative_to(ROOT) or not target.exists():
        errors.append(f'{origin.relative_to(ROOT)}: broken or external local link {value}')

token = re.compile(r'gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|-----BEGIN [A-Z ]*PRIVATE KEY-----')
private_path = re.compile(r'/(?:Users|Volumes|private/tmp)/')
for path in files:
    rel = path.relative_to(ROOT)
    if path.name in {'FeliCard.png', 'HallakasAppIcon.png', 'HallakasBrand.png'}:
        errors.append(f'Private application asset: {rel}')
    if path.suffix.lower() in {'.sqlite', '.store', '.ipa', '.p12', '.p8', '.key', '.pbxproj'} or path.name.startswith('.env'):
        errors.append(f'Out-of-scope file: {rel}')
    if path.stat().st_size > 8_000_000:
        errors.append(f'Oversized portfolio file: {rel}')
    if path.suffix == '.png':
        data = path.read_bytes()
        if data[:8] != b'\x89PNG\r\n\x1a\n':
            errors.append(f'Invalid PNG signature: {rel}')
        elif 'screenshots' in rel.parts:
            width, height = struct.unpack('>II', data[16:24])
            if width < 600 or height < 1000 or height <= width:
                errors.append(f'Unexpected screenshot dimensions: {rel}')
        continue
    try:
        text = path.read_text(encoding='utf-8')
    except UnicodeDecodeError:
        errors.append(f'Unexpected binary outside original artwork/screenshots: {rel}')
        continue
    if not text.endswith('\n') or any(line.rstrip() != line for line in text.splitlines()):
        errors.append(f'Whitespace or missing final newline: {rel}')
    if token.search(text) or private_path.search(text):
        errors.append(f'Possible credential or machine-local path: {rel}')
    if path.suffix == '.md':
        for value in re.findall(r'!?\[[^\]]*\]\(([^\s)]+)(?:\s+[^)]*)?\)', text):
            check_link(path, value)
        for value in re.findall(r'(?:src|href)="([^"]+)"', text):
            check_link(path, value)
    if path.suffix == '.swift':
        if 'https://images.ygoprodeck.com/' in text or 'This legendary dragon' in text:
            errors.append(f'Original game fixture found: {rel}')
    if path.suffix == '.svg':
        try:
            root = ET.fromstring(text)
            if any(node.tag.rsplit('}', 1)[-1] in {'script', 'foreignObject'} for node in root.iter()):
                errors.append(f'Unsupported SVG content: {rel}')
        except ET.ParseError:
            errors.append(f'Invalid SVG: {rel}')

if errors:
    print('\n'.join(errors), file=sys.stderr)
    sys.exit(1)
print(f'Checked {len(files)} files: links, publication scope and image structure are valid.')
