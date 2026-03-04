# System Analysis: dptapp (Refined for Dragon Boat)

## 1. Project Overview
`dptapp` is a specialized performance tracking and analysis application, primarily focused on **Dragon Boat** training. It integrates real-time data from external sensors (GPS, Cadence) with advanced physical simulation parameters (wind, water, weight) to provide scientific training insights.

## 2. Technical Stack
- **Framework**: Flutter (Dart)
- **State Management**: `flutter_bloc` (Handles real-time data streams and UI updates)
- **Local Persistence**: `Hive` (Storage for historical activities and training schedules)
- **Data Visualization**: `fl_chart` (Used for real-time dashboards and activity playback)
- **Bluetooth**: `flutter_blue_plus` (Crucial for real-time sensor data reception)
- **Navigation**: `go_router`

## 3. Specialized Domain: Dragon Boat Performance
The core value proposition is the transformation of raw sensor data into actionable sport-scientific metrics:
- **Simulation Parameters**:
  - **Environment**: Wind resistance (head/tail/cross), Water resistance (temperature, depth).
  - **Equipment/Logistics**: Boat weight, Crew total weight, Crew weight distribution (Center of Gravity).
- **Derived Metrics**:
  - **Work (Joules)**: Calculated based on force applied over distance.
  - **Power (Watts)**: Instantaneous effort output.
  - **Impulse (N·s)**: The total "charge" of a stroke, indicating training quality per stroke.

## 4. Operational Modules
- **Real-time Dashboard (HUD)**:
  - Low-latency visualization of cadence and speed.
  - Instant calculations of Power/Work based on current environment settings.
- **Activity Playback & GPS Mapping (Phase 3)**:
  - **Route Map Visualization**: Integration of `flutter_map` to visualize GPS tracks from TCX files.
  - **Track Analysis**: Synchronized display of start/end points and historical routes.
- **Scientific Training Management (Domain Setup)**:
  - **Multi-Discipline Support**: Generic foundation allowing users to create and mix cycles across different sports (e.g., Dragon Boat, Triathlon, Crossfit).
  - **Training Cycles (Macro/Meso)**: Automated Long/Mid-term progression logic based on sports science standard sequencing: `Strength` -> `Mid-race Speed` -> `Specific Conversion` -> `Specific Simulation (Tapering)`.
  - **Physical Testing Metrics**: Specific benchmarking capabilities tied to each cycle phase (e.g., Powerlifting for Strength, Ergometer tests for Conversion).
  - **Smart Schedule Generation (Micro)**: Algorithms that auto-generate weekly/daily workouts (Laps) based on personal performance records, discipline priority, and user preferences.
  - **Interactive Training Execution**: UI acting like "music lyrics" for upcoming workout steps, with auto/manual lap timestamps and audio/haptic phase alerts.
- **Community & Social Interaction (Phase 3)**:
  - **Social Authentication**: Seamless onboarding with Google, LINE, and Facebook OAuth providers.
  - **User Profile Management**: Minimalist profile containing Avatar (display picture), Display Name, and basic biometrics (Weight/Age for power calculations).
  - **Leaderboards & Challenges**: Global user rankings for various distances (e.g., 500m) and time-limited team challenges.

## 5. Advanced Physical Simulation (Phase 4)
- **Interactive "What-If" Analysis**: 
  - Real-time adjustment of environmental factors (Wind, Water resistance, Weight) for post-activity analysis.
  - Reactive recalculation of Power, Work, and Impulse.
- **Crew Designer**:
  - Visual seat-by-seat weight distribution tool for boat balance simulation.
  - CG (Center of Gravity) impact estimation based on crew positioning.
- **Professional Reporting**:
  - **Export Service**: Generation of CSV coaching reports containing detailed simulation metrics.

## 6. System Requirements Analysis
- **High Frequency Data**: Sensor data (especially cadence) needs high-frequency polling and smooth interpolation for real-time rendering.
- **Physics Engine**: A logic layer for calculating "Work" and "Power" that takes dynamic environmental variables into account.
- **Universal Data Schema**: A unified model that can represent both high-fidelity locally recorded data and lower-fidelity imported data for consistent analysis.

## 7. UI/UX Structure & Navigation (Updated)
- **Footer Navigation**: Home | Cycle (Activities nested inside) | Training | Community | Settings.
- **Header**: Includes User Avatar and Notifications.
- **Sidebar Box**: Relegated to global settings and device management, unified with the global aesthetic.
- **Home Dashboard**: Customizable widgets, defaulting to current Training Cycle progress.

## 8. Globalization & Personalization
- **Internationalization (i18n)**: 
  - Dual language support: **English (EN)** and **Traditional Chinese (ZH-TW)**.
  - Localization of units (Metric vs. Imperial) and date formats.
- **Theme Support**:
  - **Dynamic Theming**: Support for Light and Dark modes.
  - **Elite Dragon Design System**: Inspired by Bryton Active, using high-contrast vivid color zones for performance monitoring.
- **User Personalization**:
  - **Physical Profile**: Height, weight, age, and gender for accurate calorie and power-to-weight ratio (W/kg) calculations.
  - **Training Zones**: User-definable HR and Power zones with dynamic UI color feedback.
