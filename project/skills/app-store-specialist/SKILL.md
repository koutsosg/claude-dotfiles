---
name: app-store-specialist
description: Use this skill when working on anything related to EAS builds, app store submissions, Apple App Store, Google Play Store, Expo application configuration, store guidelines, certificates, keystores, provisioning profiles, screenshots, metadata, ASO, TestFlight, internal testing tracks, eas.json configuration, app versioning, buildNumber, versionCode, EAS Submit, store rejection reasons, data safety, privacy policies, age ratings, or preparing a React Native / Expo app for production release.
---

# App Store Specialist

Expert knowledge for publishing Expo/React Native apps to Apple App Store and Google Play Store, from EAS build configuration to final submission.

## Project Context

- App: your React Native / Expo project directory
- Platform target: Android + iOS
- Build tool: EAS (Expo Application Services)
- See `references/eas-config.md` for build configuration patterns
- See `references/ios-store.md` for App Store requirements
- See `references/android-store.md` for Google Play requirements
- See `references/submission-checklist.md` for pre-submission checklist

## EAS Build Workflow

### 1. Setup
```bash
npm install -g eas-cli
eas login
eas build:configure   # generates eas.json
```

### 2. Build Profiles
Always maintain 3 profiles in `eas.json`:
- `development` — dev client, internal testing
- `preview` — APK/ad-hoc, stakeholder testing (no store)
- `production` — AAB/IPA, store submission

### 3. Build Commands
```bash
# Android
eas build --profile preview --platform android      # APK for testing
eas build --profile production --platform android   # AAB for Play Store

# iOS
eas build --profile production --platform ios       # IPA for App Store

# Both platforms
eas build --profile production --platform all
```

### 4. Submit
```bash
eas submit --platform android   # submits latest production build
eas submit --platform ios
```

## Versioning Rules

- `version` in app.json = semantic version shown to users (e.g. "1.2.0")
- `android.versionCode` = integer, must increment with every Play Store submission
- `ios.buildNumber` = string integer, must increment with every App Store submission
- Never reuse a versionCode/buildNumber — submissions will be rejected
- Automate via `eas.json` `autoIncrement` or CI scripts

## Credentials Management

- **Android**: EAS manages keystore automatically — use `"credentialsSource": "remote"`
- **iOS**: EAS manages certificates + provisioning profiles via Apple API key
- Never commit keystores or `.p8` files to git
- Store Apple API Key (Issuer ID + Key ID + .p8) in EAS secrets, not in code

## OTA Updates (expo-updates)

- Only JS/assets changes — no native module changes
- Use for hotfixes between store releases
- Requires `updates.url` configured in app.json
- Production channel must match `eas.json` production profile channel

## Common Rejection Reasons

### Apple
- Missing privacy policy URL
- Requesting permissions without clear usage description (NSCameraUsageDescription etc.)
- Placeholder content or broken functionality
- Login required without demo account provided
- UI too similar to Apple's own apps
- Crashes on reviewer's device (test on real device before submitting)

### Google
- Target API level below current requirement (must target latest - 1 at minimum)
- Missing data safety form
- Declared permissions not matching actual usage
- Deceptive metadata (title/description misleading)
- Sexual, violent, or dangerous content in screenshots

## Pre-Submission Checklist

Quick items:
- [ ] versionCode/buildNumber incremented
- [ ] All required screenshots uploaded (correct sizes)
- [ ] Privacy policy URL live and accessible
- [ ] All permission usage descriptions filled
- [ ] Tested on real device (not just simulator)
- [ ] No debug logs or dev menus visible
- [ ] App icon — no transparency, correct sizes
- [ ] Crash-free on cold start
