# QuizMaster – Interactive Real-Time Classroom Quiz Platform

QuizMaster is a Flutter application that provides an interactive, real-time quiz experience for classrooms.  
Teachers can create and host quizzes, while students join using a quiz code and receive instant feedback on their performance.

---

## Table of Contents

- [Objective](#objective)
- [Features](#features)
  - [Teacher Features](#teacher-features)
  - [Student Features](#student-features)
  - [Common Features](#common-features)
- [Screens Overview](#screens-overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [API Overview](#api-overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
  - [Running Tests](#running-tests)
- [Known Limitations & Future Work](#known-limitations--future-work)
- [Team Members](#team-members)

---

## Objective

The objective of QuizMaster is to create a real-time, interactive quiz platform that enhances classroom engagement and simplifies quiz creation.  
According to the project specification, the goals include:

- Simplifying quiz creation  
- Increasing student participation  
- Supporting real-time quiz participation  
- Providing performance analysis  
- Supporting responsive UI with dark/light themes  

---

## Features

### Teacher Features

- **Authentication**
  - Register & log in with email/password
  - Role-based routing (teacher dashboard)

- **Quiz Management**
  - Create multiple-choice and true/false questions
  - Assign points per question
  - View list of created quizzes
  - Auto-generated quiz join code for students

- **Quiz Control**
  - Open or close quizzes (access control)

- **Analytics**
  - View quiz statistics:
    - Total questions  
    - Total students  
    - Max score  
    - Min score  
    - Mean score  
  - View full per-student results  

---

### Student Features

- **Authentication**
  - Register & log in as a student

- **Join Quiz**
  - Enter quiz code to join an active quiz

- **Quiz Experience**
  - View quiz title and questions
  - Answer MCQ questions
  - Submit answers to backend

- **Results**
  - See score instantly after submission
  - "My Results" shows history of completed quizzes

---

### Common Features

- Responsive UI  
- Dark/Light theme support  
- Centralized navigation system  
- Input validation & error handling  
- Clean layering between UI and data models  

---

## Screens Overview

### Authentication Screens

- **LoginScreen**  
- **CreateAccountScreen**  
- **ForgotPasswordScreen** *(future enhancement)*  

### Student Screens

- **StudentHomeScreen**
  - Join quiz by code
  - View “My Results”
- **QuizPlayScreen**
  - Display real quiz data from backend
  - Submit answers and receive score

### Teacher Screens

- **TeacherHomeScreen** – List of created quizzes  
- **CreateQuizScreen** – Build new quizzes  
- **QuizDetails** – Statistics and full results display  

---

## Architecture

QuizMaster uses a clean, layered architecture with separation of concerns:

### 1. Data Layer (`lib/data/`)

- **Models:**  
  `user.dart`, `quiz.dart`, `question.dart`, `answer.dart`,  
  `attempt.dart`, `quiz_statistics.dart`

- **Data Sources:**  
  - `auth_data_source.dart`  
  - `quiz_data_sources.dart`  
  - `base_data_source.dart` (HTTP wrapper)

- **Repositories:**  
  - `AuthRepository`  
  - `QuizRepository`  

---

### 2. Presentation Layer (`lib/presentation/`)

- Screens for:
  - Login / Registration
  - Student & Teacher home screens
  - Quiz creation
  - Quiz playing
  - Quiz statistics

- Reusable widgets such as `TeacherQuizWidget`

---

### 3. Application Entry (`main.dart`)

- Initializes HttpClient, repositories, token storage
- Configures App Themes (Dark/Light)
- Sets initial route to Login screen

---

## Tech Stack

- **Framework:** Flutter  
- **Language:** Dart  
- **Platforms:** Android, iOS, Web  
- **Network:** Custom HTTP client wrapper (`HttpClient`)  
- **State Management:** Stateful widgets + dependency injection  
- **Storage:** In-memory token storage (upgradeable to secure storage)

---

## Project Structure

Quiz-Master/
├─ lib/
│ ├─ data/
│ │ ├─ models/
│ │ ├─ data_sources/
│ │ └─ data_repository/
│ ├─ presentation/
│ │ ├─ screens/
│ │ └─ widgets/
│ └─ main.dart
└─ test/

---

## API Overview

Below is the general backend structure used by the application.

### Authentication Endpoints

| Method | Endpoint           | Description |
|--------|---------------------|-------------|
| POST   | `/auth/register`    | Register new user |
| POST   | `/auth/login`       | Login and receive token |

### Teacher Endpoints

| Method | Endpoint                 | Description |
|--------|---------------------------|-------------|
| POST   | `/quizzes`                | Create quiz |
| GET    | `/quizzes`                | Get teacher quizzes |
| GET    | `/quizzes/:id/stats`      | View quiz statistics |
| GET    | `/quizzes/:id/attempts`   | Full student results |

### Student Endpoints

| Method | Endpoint                | Description |
|--------|--------------------------|-------------|
| POST   | `/quizzes/join`         | Join quiz by code |
| POST   | `/quizzes/:id/submit`   | Submit answers |
| GET    | `/quizzes/my-attempts`  | View past results |

---

## Getting Started

### Prerequisites

- Flutter SDK  
- Dart SDK  
- Running backend API  

Check your environment:

```bash
flutter doctor

Configuration
Set your API base URL in:
// base_data_source.dart
const String BASE_URL = 'https://quiz.alasmari.dev/api';

Running the App
Install dependencies:
flutter pub get

Run the app:
flutter run

Run in Chrome browser:
flutter run -d chrome

Running Tests
flutter test

Known Limitations & Future Work

Token is not persisted (user must log in again after restart)

Forgot password not fully implemented

Real-time features (WebSockets/Firebase) not integrated yet

Profile/settings pages incomplete

Limited automated test coverage

Team Members

Based on the official project documentation (Team 9):

Mohammed Maashi – 201959890
Student UI, Dark/Light Themes, UI Responsiveness

Mohammed Alajmi – 202065020
Teacher UI, Forms (Quiz Creation), Navigation

Basim Alasmari – 202154710
Backend Integration, Firebase, APIs

Saif Alzahrani – 202013720
Authentication System, Role Management, Profile Pages

Muhammad Alhosainy – 202167750
Testing (Unit, Widget, Integration), Documentation
