## Getting Started

This project is a Flutter application that allows users to study the Bible with the help of AI. It uses Firebase for authentication and Firestore to save user studies. The Bible text is fetched from the Bible4U API.

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Firebase CLI: `npm install -g firebase-tools`
- An OpenAI API key: [https://platform.openai.com/](https://platform.openai.com/)

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your_username/bible_study_app.git
   cd bible_study_app
   ```

2. **Configure Firebase:**
   - Run `flutterfire configure` and follow the instructions to connect your Firebase project.
   - This will generate the `lib/firebase_options.dart` file.

3. **Set up environment variables:**
   - Create a `.env` file in the root of the project.
   - Add your OpenAI API key to the `.env` file:
     ```
     OPENAI_API_KEY=your_openai_api_key
     ```

4. **Install dependencies:**
   ```bash
   flutter pub get
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

### Firestore Rules

To secure the user studies, add the following rules to your Firestore database:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /studies/{studyId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

### Features

- **Authentication:** Login and create an account with email and password.
- **Bible Navigation:** Browse books and chapters of the Bible.
- **AI Study:** Get historical context, practical application, and cross-references for any verse.
- **Study Library:** Save and view your studies.
- **WebView:** Open links found in studies.
