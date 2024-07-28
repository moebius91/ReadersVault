# ReadersVault

**Mit ReadersVault behältst Du den Überblick über Deine Bücher, Leseerlebnisse und findest immer das Richtige, wenn Du es brauchst.**

Hast Du schon wieder ein Buch doppelt gekauft oder hast Du es gleich im Laden liegen lassen, weil Du nicht wusstest, ob Du es schon besitzt? ReadersVault hilft Dir, Deinen Buchbestand immer Griffbereit zu haben, Deine Leseerlebnisse und Ergebnisse festzuhalten, und verschiedene Bücherlisten zu verwalten, wie Beispielsweise Bestands- und Wunschliste, sowie Listen für geliehene und verliehene Bücher.

Die App ermöglicht Dir detailierte Notizen, Gedanken und Zitate für jedes einzelne Buch festzuhalten und auch thematisch zu gruppieren. So hast Du immer Zugriff auf alle Notizen eines Buches oder eines Themas. Der Barcode-Scanner erlaubt es Dir Deine Bücher schnell und einfach mit einer online Datenbank abzugleichen. Dadurch fügst Du Deine Bücher der ReadersVault Bibliothek blitzschnell hinzu.

## Geplantes Design
Screenshots aus dem Simulator:

<p>
  <img src="./img/app_design_1.png" width="200">
  <img src="./img/app_design_2.png" width="200">
</p>


## Features
Die folgenden Features sind geplant und, sofern abgehakt, bereits implementiert.

- [x] ISBN-Suche
- [x] Bücherlisten (Bestand, Wunsch, Geliehen, Verliehen + eigene)
- [x] Buchnotizen
- [ ] Themensortierte, buchübergreifende Notizsammelbecken
- [x] Barcode-Scanner
- [x] Favoriten setzen


## Technischer Aufbau

#### Projektaufbau
Jede View erhält ihren eigenen Ordner, wo die View und SubViews, sowie das ViewModel enthalten sind. Die App benutzt die MVVM Architektur und benutzt Repositorys.

```
└── BookVault
    ├── Extensions
    │   └── String+Extension.swift
    ├── GoogleService-Info.plist
    ├── Models
    │   ├── ApiModel
    │   │   ├── ApiAuthorsResult.swift
    │   │   ├── ApiBook.swift
    │   │   ├── ApiBookResult.swift
    │   │   └── ApiTitlesResult.swift
    │   └── CoreData
    │       ├── BookVault.xcdatamodeld
    │       │   └── BookVault.xcdatamodel
    │       │       └── contents
    │       └── PersistentStore.swift
    ├── ReadersVaultApp.swift
    ├── Repositories
    │   ├── ApiRepository
    │   │   ├── ApiError.swift
    │   │   └── ApiRepository.swift
    │   └── ScannerRepository
    │       └── ScannerRepository.swift
    └── Views
        ├── AllBookListView
        │   └── AllBookListView.swift
        ├── BookDetailView
        │   ├── BookDetailSubViews
        │   │   └── BookDetailEditView.swift
        │   ├── BookDetailView.swift
        │   └── BookDetailViewModel.swift
        ├── BookListDetailView
        │   ├── BookListAddBookView
        │   │   ├── BookListAddBookView.swift
        │   │   └── BookListAddBookViewModel.swift
        │   ├── BookListDetailView.swift
        │   └── BookListDetailViewModel.swift
        ├── CommunityView
        │   └── CommunityView.swift
        ├── HomeView
        │   └── HomeView.swift
        ├── LibraryView
        │   ├── LibrarySubViews
        │   │   ├── HorizontalBookListView.swift
        │   │   └── VerticalBookListsView.swift
        │   ├── LibraryView.swift
        │   └── LibraryViewModel.swift
        ├── NavigatorView
        │   ├── Enums
        │   │   └── Tab.swift
        │   └── NavigatorView.swift
        ├── NewBookEditView
        │   ├── NewBookEditView.swift
        │   └── NewBookEditViewModel.swift
        ├── NoteDetailView
        │   └── NoteDetailView.swift
        ├── NotesBookSelectionView
        │   └── NotesBookSelectionView.swift
        ├── NotesEditView
        │   └── NotesEditView.swift
        ├── NotesListView
        │   ├── CategorySelectionView.swift
        │   ├── NotesListSubViews
        │   │   ├── CreateCategoryView.swift
        │   │   ├── CreateTagView.swift
        │   │   └── CustomSearchBar.swift
        │   ├── NotesListView.swift
        │   ├── NotesListViewModel.swift
        │   └── TagSelectionView.swift
        ├── SafariView
        │   └── SafariView.swift
        ├── ScannerView
        │   ├── DocumentScannerView.swift
        │   ├── RoundedRectLabel.swift
        │   ├── ScannerViewModel.swift
        │   └── TestScannerView.swift
        ├── SearchView
        │   ├── SearchView.swift
        │   ├── SearchViewModel.swift
        │   └── SearchViewSubViews
        │       ├── AuthorsResultView.swift
        │       ├── BooksResultView.swift
        │       ├── ScannerSearchBar.swift
        │       └── SingleBookResultView.swift
        └── SettingsView_deprecated
            └── SettingsView.swift
```

Eine kurze Beschreibung deiner Ordnerstruktur und Architektur (MVVM, Repositories?) um Außenstehenden zu helfen, sich in deinem Projekt zurecht zu finden.

#### Datenspeicherung
Es werden Daten über die einzelnen Bücher und Bücherlisten gespeichert, Lokal in CoreData und bei Anmeldung in der App in FireBase übertragen. Später werden Bewertungen und Kommentare, Gruppen für Bücher ebenfalls in FireBase gespeichert.

#### API Calls
Es wird die API von ISBNdb.com benutzt.

#### 3rd-Party Frameworks
Firebase


## Ausblick
Für die Zukunft sind die folgenden Features geplant:

- [ ] Bücherbewertungen Appintern
- [ ] Empfehlungen neuer Bücher nach Geschmack 
- [ ] Gruppen zum Austausch über Bücher/ Themen
- [ ] Schwarzesbrett für Bücher: Kauf- und Leihbörse

Es besteht ebenfalls die Möglichkeit eine Webapplikation bereitzustellen, damit die Benutzer auch über Desktopgeräte sich anmelden können und ihre Bibliothek und Buchnotizen immer griffbereit haben.

Außerdem ist geplant die App mit der Amazon Partnernet API auszustatten um Einnahmen über Empfehlungen zu generieren.

Auch besteht die Möglichkeit den Benutzern zu ermöglichen ihre Notizen zu Büchern zu veröffentlichen, damit Menschen sich ein Bild vom Inhalt des Buches machen können, bevor sie es kaufen. (Ähnlich dem Konzept von Blinkist.)
