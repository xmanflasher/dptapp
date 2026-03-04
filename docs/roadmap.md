# Roadmap: dptapp (Dragon Boat Performance & Training)

## Phase 1: Core Physics & Real-time Integration (Q1 2026)
- **Physics Engine Implementation**:
  - Develop the logic layer for Power (Watts), Work (Joules), and Impulse calculation.
  - Implement dynamic variable support for boat weight, wind speed/direction, and crew distribution.
- **Real-time Sensor HUD**:
  - Build a high-performance dashboard for live cadence and GPS data.
  - Integrate real-time "Performance Scoring" (comparing current output with theoretical max based on environment).
- **Consolidated Activity Model**:
  - Unify data schemas between local recordings (high precision) and external imports (Garmin/Strava).

## Phase 2: Scientific Training Management (Q2 2026)
- **Training Cycle System**:
  - Modules for defining Macro-cycles (e.g., season-long) and Micro-cycles (weekly schedules).
  - Target-based training: Set goals for specific cadence ranges or power output.
- **Adaptive Execution**:
  - Real-time feedback in the dashboard to signal if the user should increase or decrease intensity to meet the day's quality target.
  - Auto-adjustment of future schedules based on "Training Quality" scores.
- **Activity Replay**:
  - Scannable timeline for post-training analysis.
  - Sync chart movements with GPS map locations.

## Phase 3: Aesthetics, Globalization & Personalization (Q3 2026)
- **Elite Dragon Design System**:
  - Implement dynamic Light/Dark themes based on Bryton Active aesthetics.
  - Integrate high-visibility color zones for HR/Power metrics in the HUD.
- **Globalization (i18n)**:
  - Add multi-language support (EN, ZH-TW).
  - Localization of units (Metric/Imperial) and localized date/time representations.
- **User Settings & Config**:
  - Create a User Profile system (Weight, Age, Power Zones).
  - Persist app preferences (language, theme, units) locally.

## Phase 4: Advanced Simulation & AI (Q4 2026+)
- **Crew Distribution Simulation**:
  - Visual tool for CG (Center of Gravity) optimization.
- **Environmental Auto-sync**:
  - Live weather/tide integration for simulation accuracy.
- **Advanced Export & Sharing**:
  - PDF coaching reports and team-wide impulse comparisons.

---

### Immediate Next Steps (Executive Summary)
1. **[Core]** Define the unified `SimulationParams` and `Activity` entity models.
2. **[UI]** Prototype the "Live Dashboard" with real-time stream simulation.
3. **[Logic]** Implement the first version of the "Work/Power Calc" utility.
