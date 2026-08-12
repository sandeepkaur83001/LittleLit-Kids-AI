🎨 LittleLit Kids AI
LittleLit Kids AI is a high-quality, landscape-oriented creative platform for kids. It serves as an AI-driven studio for art, music, and storytelling, featuring a highly interactive user interface designed to inspire young creators through immersive character integration and responsive animations.

📱 Features & Core Screens
1. ✨ Immersive Onboarding
Visual Splash Screen: Features smooth logo scale animations with a branded starry background for a premium first impression.
Authentication Choice: A playful interface allowing users to choose between Google and Email sign-up paths with clear, kid-friendly typography.
Profile Setup: Integrated form to capture child nickname and age with built-in terms and conditions validation.

2. 🎮 Creative Studio Hub
Custom "Cover Flow" Carousel: A high-performance, manually sorted Z-index card system. The selected card always stays on top with a pulsing "pop" effect.
Landscape Navigation: Optimized horizontal scrolling with synchronized hit-testing, ensuring intuitive swiping across overlapping game cards.
Branded Categories: Quick access to Make Posters, Write Storybooks, Design Puzzles, and Create Songs using high-quality local assets.

3. 🖌️ Magic Art AI Studio
AI Prompting Interface: A dedicated workspace where kids can type or speak their imaginations.
Smart Voice Support: Integrated microphone UI for accessibility and ease of use.
Idea Discovery Chips: Interactive prompt suggestions like "A supergirl with wings" to spark creativity.

4. 📖 Storybook Creator
World Building: Step-by-step interface to select story themes (Fantasy, Mystery, Diary, etc.).
Visual Theme Cards: Custom-designed "Book Style" selection cards that mimic physical books with white "page" edge effects.

5. 🎵 Music Studio (Tune Selection)
Character Integration: Features the Duck Singer character performing live on a studio stage.
Record Selector: Interactive horizontal list of circular "record" cards for choosing classic and trending tunes.

6. 🌟 Portfolio ("My Stuff")
Achievement Tracking: A centralized hub to view created projects categorized by type (Book, Music, Art, etc.).
Weekly Contest Banner: High-visibility call-to-action for kids to enter competitions and win prizes.
Decorative Star Navigation: A unique circular category bar with star-themed dividers and multi-colored highlights.

7. 🎁 Rewards & Feedback
Achievement Center: A dedicated space for Stickers, Badges, and Weekly Winners.
Interactive Feedback: Redesigned feedback overlays using character assets to celebrate child creativity.

🛠️ Architecture & Tech Stack
The application leverages industry-standard Flutter best practices for a scalable and maintainable codebase:

Component | Library / Framework | Description
--- | --- | ---
Framework | Flutter SDK | Cross-platform UI toolkit optimized for landscape tablet and mobile views.
State Management | GetX | Lightweight and powerful solution for routing and dependency injection.
Networking | HTTP & ApiService | Unified client with automatic header management and Bearer Token support.
Animations | Flutter Animation Controller | Custom explicit animations for pulsing logos and Cover Flow depth effects.
Typography | Google Fonts | Integration of 'Comic Neue' for a playful, accessible reading experience.

🚀 How to Run the Applications
Prerequisites
Flutter SDK (Latest Stable)
Android Studio / VS Code with Flutter extension
JDK 17+
Running the App
Run the following command from the root directory:

```bash
flutter pub get
flutter run
```

📂 Project Structure
.
├── assets/images/       # High-quality local UI assets and character designs
├── lib/
│   ├── core/           # App-wide logic, theme definitions, and networking
│   │   ├── network/    # ApiService and Environment configurations
│   │   └── theme/      # AppColors and AppThemes
│   ├── widgets/        # Reusable UI components (Buttons, Inputs, Base Screens)
│   ├── features/       # Business modules (Game, Portfolio, Magic Art)
│   │   └── game/       # Main gameplay and discovery screens
│   ├── models/         # Data classes and response objects
│   └── main.dart       # App entry point with Landscape & Immersive mode setup
└── pubspec.yaml        # Project dependencies and asset declarations

🔒 Form Validation Logic
All user inputs in Profile Setup and AI Prompting have strict handling:
Email: Asserts non-empty state and matches standard pattern requirements.
Age/Nickname: Required fields that enable/disable action buttons based on completeness.

📡 API Layer Integration
The `ApiService` includes pre-architected static methods for `fetchGameCategories`, `generateMagicArt`, and `fetchPortfolio`. These methods are integrated into the UI logic with commented-out calls, allowing for seamless transition to live data once backend endpoints are available.
