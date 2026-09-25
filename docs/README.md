# ReadTogether

Eine Ruby on Rails Webanwendung für kollaboratives Lesen im Schulalltag.

## Projektbeschreibung

ReadTogether ermöglicht es **Lehrpersonen** (*teacher*) und **Schüler/innen** (*student*), Bücher gemeinsam online zu lesen. Lehrpersonen erstellen Leseaufträge und geben schrittweise Seiten frei. Schüler/innen lesen den freigegebenen Abschnitt, erfassen ihren Lesefortschritt und verfassen Zusammenfassungen. Ein Aktivitätsprotokoll (PaperTrail) zeichnet alle relevanten Änderungen auf.

---

## Voraussetzungen

- Ruby (>= 3.3)
- Rails 8.1
- SQLite3
- Bundler

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## Benutzerrollen

| Rolle    | Beschreibung                                                   |
|----------|----------------------------------------------------------------|
| student  | Kann Leseaufträge lesen, Fortschritt speichern, Zusammenfassungen schreiben |
| teacher  | Kann Leseaufträge und Bücher erstellen/verwalten               |
| admin    | Vollzugriff, Benutzerverwaltung                                |

> Neue Benutzer wählen ihre Rolle beim Registrieren (Schüler/in oder Lehrperson). Admins werden über `/admin/users` von bestehenden Admins ernannt.

## Kernfunktionen

- **Bücher verwalten** – Lehrer/Admin erstellen Bücher mit Volltextinhalt
- **Leseaufträge** – Lehrperson legt `released_until` (freigegebene Seiten) fest und kann ihn jederzeit erhöhen
- **Online lesen** – Schüler/innen sehen nur den freigegebenen Textabschnitt
- **Lesefortschritt** – Schüler/innen speichern ihre aktuelle Seite
- **Zusammenfassungen** – Schüler/innen verfassen Zusammenfassungen für den freigegebenen Bereich
- **Aktivitätsfeed** – Alle Änderungen werden via PaperTrail protokolliert und im Dashboard angezeigt
- **Benutzerverwaltung** – Admin kann Rollen und Details aller Benutzer verwalten

## Tests ausführen

```bash
bin/rails test
```

Weitere Informationen zur Testabdeckung und geprüften Anforderungen: [docs/testing.md](docs/testing.md)

## Gems (Hauptabhängigkeiten)

| Gem        | Zweck                                 |
|------------|---------------------------------------|
| pundit     | Policy-basierte Berechtigungen        |
| paper_trail| Aktivitätsprotokoll / Audit-Log       |
| bcrypt     | Passwort-Hashing                      |
| bootstrap  | UI (via CDN)                          |
