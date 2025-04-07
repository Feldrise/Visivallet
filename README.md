# 📱 Visivallet

Visivallet est un projet Flutter conçu pour expérimenter l'utilisation de différentes sources de données (locales ou distantes) tout en garantissant la sécurité des types et en manipulant un seul modèle de données. Ce projet vise à démontrer comment structurer une application Flutter moderne et robuste.

---

## 🏗️ Architecture du Projet

L'architecture de Visivallet repose sur les principes suivants :

### 1. **Sources de Données**

- **Données Locales** : Utilisation de solutions comme SQLite ou des fichiers JSON pour stocker les données localement.
- **Données Distantes** : Intégration avec des API REST ou WebSocket pour récupérer les données en temps réel.

### 2. **Modèle Unique**

- Toutes les données, qu'elles proviennent de sources locales ou distantes, sont manipulées à travers un **modèle unique**. Cela garantit une cohérence dans l'application et simplifie la gestion des données.

### 3. **Type Safety**

- Le projet utilise des outils comme `freezed` et `json_serializable` pour générer des modèles immuables et typesafe. Cela réduit les erreurs liées aux types et améliore la maintenabilité.

### 4. **Gestion des États**

- Utilisation de **Riverpod** pour gérer les états de manière réactive et efficace.

---

## 📂 Structure des Dossiers

Voici un aperçu de la structure des dossiers du projet :

```
visivallet/
├── lib/
│   ├── core/                # Constantes, utilitaires et configuration globale
│   │   └── provider.dart    # Providers Riverpod
│   ├── features/            # Fonctionnalités principales de l'application
│   │   └── [feature]/       # Dossier par fonctionnalité
│   │       ├── database/    # Gestion de la base de données pour cette fonctionnalité
│   │       │   ├── data_sources/ # Sources de données spécifiques
│   │       │   ├── tables/  # Définition des tables
│   │       │   └── repositories/ # Couche d'accès aux données
│   │       └── models/      # Modèles de données typesafe pour cette fonctionnalité
│   ├── widgets/             # Widgets réutilisables
│   └── main.dart            # Point d'entrée de l'application
├── ios/                     # Configuration iOS
├── android/                 # Configuration Android
├── macos/                   # Configuration macOS
├── windows/                 # Configuration Windows
├── web/                     # Configuration Web
└── README.md                # Documentation du projet
```

---

## 🎯 Objectifs

- **Expérimentation** : Tester différentes approches pour intégrer des sources de données dans Flutter.
- **Robustesse** : Garantir la sécurité des types et la cohérence des données.
- **Réutilisabilité** : Créer des composants et des modèles facilement réutilisables.

---

## 🚀 Comment Lancer le Projet

1. Clonez le dépôt :

   ```bash
   git clone <url-du-repo>
   cd visivallet
   ```

2. Installez les dépendances :

   ```bash
   flutter pub get
   ```

3. Lancez l'application :
   ```bash
   flutter run
   ```

---

## 🛠️ Technologies Utilisées

- **Flutter** : Framework principal.
- **Freezed** : Génération de modèles immuables.
- **JsonSerializable** : Sérialisation JSON.
- **Riverpod** : Gestion des états.

---

## 📖 Documentation

Pour plus de détails, consultez la [documentation Flutter](https://flutter.dev/docs).

---

## 🧑‍💻 Contributeurs

- **Auteur** : Victor
- Contributions bienvenues ! Ouvrez une issue ou soumettez une pull request.

---

## 📜 Licence

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus d'informations.
