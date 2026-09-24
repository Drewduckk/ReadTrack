# ReadTogether – Testdokumentation

## Testbefehl

```bash
bin/rails test
```

## Übersicht

Die Testsuite deckt alle vier Projektaufgaben ab und sichert die wichtigsten Domänenregeln sowie Multi-User-Funktionen ab.

---

## Testdaten (Fixtures)

Die Fixtures befinden sich in `test/fixtures/` und bilden folgende Rollen und Situationen ab:

| Fixture-Name      | Rolle    | Beschreibung                                      |
|-------------------|----------|---------------------------------------------------|
| `teacher`         | teacher  | Frau Meyer – erstellt Leseauftrag `:one`          |
| `other_teacher`   | teacher  | Herr Schmidt – hat keinen Zugriff auf `:one`      |
| `student_one`     | student  | Max Muster – hat Fortschritt und Zusammenfassung  |
| `student_two`     | student  | Anna Beispiel – separate Zusammenfassung          |
| `admin`           | admin    | Vollzugriff auf alle Ressourcen                   |

---

## Geprüfte Anforderungen & Ergebnisse

### Task 1: Benutzerrollen und Berechtigungen

| Test | Klasse | Ergebnis |
|------|--------|----------|
| Admin kann Benutzer verwalten, andere nicht | `UserPolicyTest` | ✅ Bestanden |
| Nur Lehrer/Admin dürfen Leseaufträge erstellen | `ReadingAssignmentPolicyTest` | ✅ Bestanden |
| Nur Lehrperson des Auftrags darf aktualisieren | `ReadingAssignmentPolicyTest` | ✅ Bestanden |
| Schüler dürfen keine Zusammenfassungen fremder Schüler bearbeiten | `SummaryPolicyTest` | ✅ Bestanden |
| Lehrperson darf Zusammenfassung sehen, aber nicht bearbeiten | `SummaryPolicyTest` | ✅ Bestanden |
| Nur eigener Lesefortschritt kann aktualisiert werden | `ReadingProgressPolicyTest` | ✅ Bestanden |
| Rolle wird beim Signup korrekt gesetzt | `RegistrationsControllerTest` | ✅ Bestanden |
| User-Rollen-Enum (student/teacher/admin) | `UserTest` | ✅ Bestanden |

### Task 2: Kernfunktion

| Test | Klasse | Ergebnis |
|------|--------|----------|
| Leseauftrag gültig speichern | `ReadingAssignmentTest` | ✅ Bestanden |
| Ungültiger released_until (≤ 0) wird abgelehnt | `ReadingAssignmentTest` | ✅ Bestanden |
| Lehrer kann Leseauftrag erstellen | `ReadingAssignmentsControllerTest` | ✅ Bestanden |
| Schüler kann keinen Leseauftrag erstellen | `ReadingAssignmentsControllerTest` | ✅ Bestanden |
| Nur eigener Lehrer kann Auftrag aktualisieren | `ReadingAssignmentsControllerTest` | ✅ Bestanden |
| Schüler kann Leseseite aufrufen | `ReadingAssignmentsControllerTest` | ✅ Bestanden |
| Zusammenfassung im freigegebenen Bereich speichern | `SummaryTest` + `SummariesControllerTest` | ✅ Bestanden |
| Zusammenfassung über released_until abgelehnt | `SummaryTest` + `SummariesControllerTest` | ✅ Bestanden |
| Schüler kann eigene Zusammenfassung bearbeiten | `SummariesControllerTest` | ✅ Bestanden |
| Schüler kann fremde Zusammenfassung NICHT bearbeiten | `SummariesControllerTest` | ✅ Bestanden |
| Book#content_until beschränkt Inhalt auf freigegebene Seiten | `BookTest` | ✅ Bestanden |
| Lesefortschritt wird gespeichert (gültig / ungültig) | `ReadingProgressTest` | ✅ Bestanden |

### Task 3: Aktivitätsprotokoll

| Test | Klasse | Ergebnis |
|------|--------|----------|
| Leseauftrag-Änderung wird von PaperTrail aufgezeichnet | `ReadingAssignmentTest` | ✅ Bestanden |
| Zusammenfassung-Erstellung und -Update aufgezeichnet | `SummaryTest` | ✅ Bestanden |
| Lesefortschritt-Erstellung aufgezeichnet | `ReadingProgressTest` | ✅ Bestanden |

### Task 4: Testing (diese Dokumentation)

Alle 71 Tests bestehen fehlerfrei (`0 failures, 0 errors, 0 skips`).

---

## Konflikt- und Transaktionsabsicherung

Die Testfälle in `ReadingAssignmentsControllerTest` und `SummariesControllerTest` prüfen, dass:

- Nur der eigene Lehrer einen `released_until`-Wert ändern kann (Locking + Transaktion in `ReadingAssignmentsController#update`).
- Beim Erstellen einer Zusammenfassung die `reading_assignment`-Zeile gesperrt wird (Transaktion in `SummariesController#create`), um Race Conditions bei gleichzeitigem Schreiben zu vermeiden.

---

## Aussagekraft – Fehlernachweis

Um die Aussagekraft der Tests zu prüfen, wurde temporär in `SummaryPolicy#create?` die Berechtigung für Schüler entfernt:

```ruby
# Temporäre Änderung (dann wieder rückgängig gemacht):
def create?
  user&.admin?  # student entfernt
end
```

Folgende Tests schlugen erwartungsgemäss fehl:
- `SummaryPolicyTest#students and admins can create summaries`
- `SummariesControllerTest#student can create summary within released_until`

Nach Rückgängigmachen der Änderung besteht die gesamte Suite wieder.

---

## Nachtrag: Code-Review-Befunde und Fixes

Im Rahmen eines Code-Reviews wurden zwei Probleme gefunden und behoben:

### 1. Mass-Assignment-Lücke bei der Registrierung (kritisch)

`RegistrationsController#create` erlaubte ursprünglich `:role` als mass-assignbaren Parameter. Da das Formular nur "Student"/"Teacher" im Dropdown anzeigte, wurde serverseitig aber jeder übermittelte Wert akzeptiert — ein manipulierter Request mit `role=admin` hätte einen Administrator-Account erzeugt und damit die gesamte Policy-basierte Autorisierung ausgehebelt.

**Fix:** `:role` wurde aus `user_params` entfernt und wird stattdessen über eine explizite Allowlist (`student`/`teacher`) gesetzt; jeder andere Wert fällt sicher auf `student` zurück.

**Neue Tests:** `RegistrationsControllerTest#cannot self-register as admin via role param`, `#unknown role value falls back to student`.

### 2. Aktivitätsprotokoll war nicht rollenbasiert gefiltert

`DashboardController#index` zeigte allen Benutzern denselben, ungefilterten `PaperTrail::Version`-Feed — Schüler sahen auch Aktivitäten fremder Schüler und Lehrpersonen.

**Fix:** `scoped_activities` filtert jetzt nach Rolle: Admin sieht alles, Lehrperson nur Aktivität zu eigenen Leseaufträgen (inkl. zugehöriger Zusammenfassungen/Fortschritte), Schüler nur eigene Zusammenfassungen/Fortschritte.

**Neue Tests:** `DashboardControllerTest#student only sees own activity...`, `#teacher only sees activity for their own reading assignments`.
