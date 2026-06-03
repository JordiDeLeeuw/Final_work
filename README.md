# FINAL WORK - JIDLI

## Over het project
JIDLI is een interactief, fysiek-digitaal K-pop album concept. Door middel van een object, app en NFC-fotokaarten kunnen gebruikers de persoonlijke verhalen en liedjes van de idols (Jiroh, Depimi en Lebang) ontgrendelen en ontdekken.

## Tech Stack
* **Taal:** Swift (SwiftUI)
* **Architectuur:** MVVM (Model-View-ViewModel)
* **Database:** Firebase / Firestore
* **Hardware integratie:** NFC tags, iPad, iPhone, 3D-geprinte behuizing.

## Hoe run je dit project?
1. Open `JIDLI APP.xcodeproj` in Xcode.
2. Creëer de benodigde Shortcuts op de iPhone (zie hiervoor de aparte `SHORTCUTS_SETUP.md` documentatie).
3. Verbind de iPad met de Mac en installeer de app door in Xcode op 'Run' te drukken (Cmd + R).
4. Let op: Het project maakt gebruik van Firebase. Zorg dat het `GoogleService-Info.plist` bestand aanwezig is in de hoofdmap van de code. 

## Maker
* **Naam:** Jordi De Leeuw
* **Opleiding:** Multimedia and Creative Technology (Erasmushogeschool Brussel)

## sources - models
[Codable: How to simplify converting JSON data to Swift objects and vice versa](https://www.swiftyplace.com/blog/codable-how-to-simplify-converting-json-data-to-swift-objects-and-vice-versa?utm_source=organic)
 - used as reference for Codable, CodingKeys, Equatable and Identifiable in StoryPageItem.swift
 - also used as reference for Codable model structure in JidliItem.swift

## sources - utils
[Swift Code Explained: Implementing Safe Array Subscription](https://huypham85.medium.com/swift-code-explained-implementing-safe-array-subscription-96904d0c9728)
  - used as reference for the safe subscript extension in Utils.swift
  - used to prevent index out of range crashes when accessing story pages with [safe:]

## sources - views
[GeometryReader in SwiftUI: From Basics to Advanced Techniques](https://www.devtechie.com/blog/geometryreader-in-swiftui-from-basics-to-advanced-techniques?utm_source=organic)
  - used as reference for GeometryReader in StoryView.swift
  - used as reference for GeometryReader in DashboardView.swift

[3 ways to share state in SwiftUI that you NEED to know](https://dev.to/amodrono/3-ways-to-share-state-in-swiftui-that-you-need-to-know-1ink?utm_source=organic)
  - used as reference for shared SwiftUI state in ContentView.swift and DashboardView.swift
  - used as reference for @EnvironmentObject, @State and @Binding

[A Clean Navigation Pattern in SwiftUI Using Enum-Based Routing](https://medium.com/%40anandhakrishnan0602/a-clean-navigation-pattern-in-swiftui-using-enum-based-routing-7712f404a0d9)
  - used as reference for the route-based navigation in ContentView.swift
  - used for switching between .title, .foreword, .dashboard and .story using viewModel.route

[Passing methods as SwiftUI view actions](https://www.swiftbysundell.com/tips/passing-methods-as-swiftui-view-actions/?utm_source=organic)
  - used as reference for passing actions between views with closures
  - used for actions such as onNext, onBack, onNavigateBack, onStartStory and onToggleAudio

## sources - db
 [SwiftUI: Fetching Data from Firestore in Real Time](https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/?utm_source=organic)
  - used as reference for connecting a SwiftUI app to Firestore
  - used as reference for fetching Firestore data and updating the app when the database changes

[Get realtime updates with Cloud Firestore](https://firebase.google.com/docs/firestore/query-data/listen?utm_source=organic)
  - used as reference for addSnapshotListener in AppViewModel.swift
  - used in listenToItemsCollection() to listen for changes in the items collection
  - used so the app updates when an NFC scan changes a document from locked to unlocked

## sources - apple shortcuts

[JSON gebruiken in Opdrachten op de iPhone en iPad](https://support.apple.com/nl-be/guide/shortcuts/apd0f2e057df/9.0/ios/26)
 - used as reference for using JSON/text data inside Apple Shortcuts
 - used in `SHORTCUTS_SETUP.md` for the text body that updates the Firestore document status

[Method: projects.databases.documents.patch](https://firebase.google.com/docs/firestore/reference/rest/v1beta1/projects.databases.documents/patch?utm_source=organic&rep_location=global)
 - used as reference for updating a Firestore document through the REST API
 - used in `SHORTCUTS_SETUP.md` for the PATCH request sent by the NFC automation
 - used to update the `status` field of a document in the `items` collection from `locked` to `unlocked`

## ai prompts
 - “Can you help me restructure my existing SwiftUI files into a clearer MVVM structure, without changing the visual design or core functionality?”
 - used for organising the project files into Models, Views, ViewModels and Utils

 - “How can I make sure my iPad SwiftUI app runs in landscape orientation, and where should this setting be configured?”
 - used for checking where landscape orientation should be configured in the Xcode project

 - “Can you help me think through how to keep track of which idol audio is currently playing, so only one card appears active at a time?”
 - used for reasoning through the playingIdol state in DashboardView.swift
