# Apple — UNES for iOS (legacy)

Apple was the **initial version of UNES for iOS**, a companion app for students at
UEFS (Universidade Estadual de Feira de Santana). It brought academic information
from the SAGRES student portal to a native iPhone app.

> **Development has moved to [Melon](https://github.com/ForceTower/Melon).**
> This repository preserves the original iOS implementation as a historical
> reference. For the current app, setup instructions, and contributions, use Melon.

## Current project

- [Melon repository](https://github.com/ForceTower/Melon) — the current UNES clients
  for Android and iOS, along with the marketing site.
- [Current iOS app](https://github.com/ForceTower/Melon/tree/main/apps/ios) — the
  native Swift and SwiftUI implementation.
- [iOS development documentation](https://github.com/ForceTower/Melon/blob/main/apps/ios/README.md)
  — architecture, build instructions, and tests.

## About this version

The original app included SAGRES login, class schedules, portal messages,
disciplines and grades, and course materials. It used Swift and UIKit, Combine for
reactive state, Core Data for local persistence, Arcadia for portal access, and
Firebase integrations for analytics, crash reporting, and messaging.

## Repository structure

| Path | Contents |
| --- | --- |
| `UNES.xcodeproj` | Original Xcode project |
| `UNES/Presentation` | Screens, view models, and navigation coordinators |
| `UNES/Domain` | Use cases and authentication models |
| `UNES/Data` | Core Data persistence, data processors, and portal synchronization |
| `UNES/Notification` | Notification handling |
