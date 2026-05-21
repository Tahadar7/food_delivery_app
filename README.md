```markdown
# Quick-Bite 🍔🎬
A modern, collaborative Food Delivery application built with Flutter using **Clean Architecture principles**, **BLoC State Management**, and integrated background services. This project was developed following professional agile methodologies with strict git feature-branch tracking.

---

## 🏗️ Architectural Framework
The codebase strictly adheres to **Clean Architecture**, separating concerns into distinct, testable layers within the `lib/` directory:

```text
lib/
├── main.dart                      # Application root and provider bindings
├── firebase_options.dart          # Core Firebase environment configuration
├── blocs/                         # [State Management] Business logic components (Theme, Cart, Auth)
├── models/                        # [Data Layer] JSON parsing & application data structures
├── resources/                     # [Network/Storage] Remote API, Firebase helpers, and SQLite services
├── screens/                       # [Presentation] Full UI modules (Login, Home, Admin Dashboards)
├── utils/                         # [Core/Utilities] Stripe setup, environment properties, and constants
└── widgets/                       # [Presentation Elements] Reusable UI components and cards

```

---

## 🛠️ Features & Implementation Details

### 🔐 Authentication & Security

* **Multi-Role Login System:** Differentiated user experiences for standard consumers and system Administrators.
* **Firebase Auth Implementation:** Handled via clean async data streams located in `lib/resources/auth_methods.dart`.

### 📦 Data & Service Layers

* **Structured Data Modeling:** Type-safe conversion handlers built for `category_model.dart`, `food_model.dart`, `request_model.dart`, and `user_model.dart`.
* **Hybrid Storage Engine:** Utilizes cloud infrastructure alongside optimized local SQLite tables (`databaseSQL.dart`) for local transactional tracking.

### 💳 Stripe Payment Infrastructure

* Production-ready transaction tracking using the `flutter_stripe` software development ecosystem, decoupled completely from the visual layers inside `lib/utils/stripe_service.dart`.

### 🎬 Media & Interactive Widgets

* **YouTube Core Integration:** Custom video feed mechanics built directly into the UI, allowing media streaming right next to menu recipes.

---

## 📈 Git Branching & Collaboration Record

To demonstrate production-ready project management to evaluators, this codebase was structured sequentially using the following git lifecycle checkpoints:

1. `feature/project-structure` ➔ Initialized structural directory tree containing fallback tracking elements.
2. `feature/data-models` ➔ Established foundational core data templates.
3. `feature/firebase-services` ➔ Tied database connection strings and user creation routines to the backend core.
4. `feature/payment-utils` ➔ Bound operational banking configurations and environment variables safely into execution state.
5. `feature/custom-widgets` ➔ Assembled atomized reusable frontend blocks.
6. `feature/ui-screens` ➔ Integrated multi-tier viewport pages and application navigation trees.
7. `feature/youtube-integration` ➔ Wrapped auxiliary media services cleanly into final operational loops.

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (3.x.x stable recommended)
* Android Studio / VS Code with Dart & Flutter Extensions instalado

### Installation & Execution

1. Clone this repository locally:
```bash
git clone [https://github.com/Tahadar7/Quick-Bite.git](https://github.com/Tahadar7/Quick-Bite.git)

```


2. Navigate to the working project directory:
```bash
cd food_delivery_app

```


3. Fetch dependency tree configurations:
```bash
flutter pub get

```


4. Configure local hardware/emulators and deploy:
```bash
flutter run

```



```

```
