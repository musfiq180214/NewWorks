# Flutter Base Setup

---

## 🔧 Technical Stack

| Component       | Technology             |
|-----------------|------------------------|
| UI Framework    | Flutter                |
| State Management| Riverpod               |
| Networking      | Dio                    |
| Architecture    | Clean Architecture     |

---

Run [dart run intl_utils:generate] for Language support.

Run [flutter pub run flutter_launcher_icons:main] to generate App icons.


## 🛠 Feature Generator Script

To streamline development and enforce consistent folder structure, a shell script is included to generate new feature modules.

### 🔧 Usage

```bash
./generate_feature.sh <feature_name>

🗂️ Example
./generate_feature.sh profile

This will generate:
lib/features/profile/
├── data/
│   └── profile_repository.dart
├── domain/
│   └── profile_model.dart
├── presentation/
│   └── profile_screen.dart
├── providers/
│   └── profile_provider.dart
├── widgets/

🚨 Notes
	•	Ensure the script has execution permission: chmod +x generate_feature.sh
	•	Use lowercase snake_case or camelCase naming for features.