# 🎓 CV Genius - Professional Resume Builder

**CV Genius** is a professional Flutter application designed to help users create, manage, and export professional resumes (CVs) with ease. Built with a modern UI and a robust backend, it streamlines the job application process by generating print-ready PDF documents.

---

## 📌 Project Description

CV Genius helps users bridge the gap between their experiences and a professional presentation. Users can input their personal info, education, and work history to instantly generate a high-quality PDF. The app is built with a clean architecture to ensure scalability and ease of maintenance.

---

## 🏗 Architecture & State Management

The project uses **Provider** for state management and follows a structured folder pattern to separate business logic from the UI.

* **Providers:** Handles the state of the CV data and app language.
* **Models:** Defines the structure for user data and CV sections.
* **Screens (Views):** Displays the UI for the editor, preview, and authentication.
* **Services:** Dedicated logic for PDF generation and file handling.
* **Firebase (Backend):** Manages user authentication and cloud storage.

---

# 🚀 Key Features

Multi-Step Forms: Organized data entry via simple_form_screen and smart_form_screen.

Template Variety: Users can choose their preferred style in template_selection_screen.

Live Preview: High-fidelity resume preview in final_preview_screen.

Dual PDF Engines: Comprehensive PDF generation logic using dedicated services (pdf_service & simple_pdf_service).

Multi-language Support: Full localization for Arabic and English with RTL/LTR support.

Cloud Sync: Secure data storage and real-time sync using Firebase Firestore.

.
# **🛠 Technologies Used**

Framework: Flutter & Dart

Backend: Firebase (Auth, Firestore, Storage)

State Management: Provider

PDF Core: pdf & printing libraries

Utilities: image_picker, share_plus, intl, arabic_reshaper

# 👨‍💻 Installation & Run

## Clone the repo:

Bash
git clone [https://github.com/yourusername/cv_genius.git](https://github.com/yourusername/cv_genius.git)
Install dependencies:
flutter pub get

Generate App Icons:
flutter pub run flutter_launcher_icons

Run the app:
flutter run

## 📁 Project Structure

```text
lib/
├── models/
│   └── user_model.dart
├── providers/
│   ├── cv_provider.dart
│   └── language_provider.dart
├── screens/
│   ├── final_preview_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── simple_form_screen.dart
│   ├── smart_form_screen.dart
│   ├── splash_screen.dart
│   └── template_selection_screen.dart
├── services/
│   ├── pdf_service.dart
│   └── simple_pdf_service.dart
├── firebase_options.dart
└── main.dart