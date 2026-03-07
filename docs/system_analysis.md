# System Analysis: dptapp (龍舟性能助手)

## 1. Project Overview (專案概述)
`dptapp` is a specialized performance tracking and analysis application, primarily focused on **Dragon Boat** training. It integrates real-time data from external sensors (GPS, Cadence) with advanced physical simulation parameters (wind, water, weight) to provide scientific training insights.

`dptapp` 是一款專門為**龍舟**訓練設計的性能追蹤與分析應用程式。它整合了來自外部傳感器（GPS、踏頻）的即時數據，並結合進階物理模擬參數（風阻、水阻、重量），提供科學化的訓練洞察。

## 2. Technical Stack (技術棧)
- **Framework**: Flutter (Dart)
- **State Management**: `flutter_bloc` (Handles real-time data streams and UI updates)
- **Local Persistence**: `Hive` (Fast NoSQL storage) / `SQLite` (For large activity logs)
- **Data Visualization**: `fl_chart` (Real-time dashboards)
- **Bluetooth**: `flutter_blue_plus` (Sensor data reception)
- **Navigation**: `go_router`

## 3. Feature Comparison & Gap Analysis (功能相容性與差距分析)

| Category (類別) | Garmin Connect Feature | dptapp Status (狀態) | Priority | Status (落實情況) |
| :--- | :--- | :--- | :--- | :--- |
| **Health (日常健康)** | Sleep / HRV / Body Battery | None (無) | Low | **[Not Implemented]** |
| **Activities (活動)** | GPS Maps & Routes | Implemented (Phase 3) | Done | **[Implemented]** |
| | Advanced Lap Analysis | Implemented (Phase 2) | Done | **[Implemented]** |
| | **Physical Simulation** | Implemented (Phase 4) | Done | **[Implemented]** |
| **Social (社交)** | Social Login (Google/LINE/FB) | Implemented (Phase 5) | Done | **[Implemented]** |
| | Leaderboards & Challenges | Implemented (Phase 3) | Done | **[Implemented]** |
| | Badges & Milestones | Partially Implemented | Mid | **[In Progress]** |
| **Training (訓練)** | **Feature-First Architecture** | **[Implemented] (Phase 6)** | High | **[Done]** |
| | Cycle System (Macro/Micro) | Framework Ready | Mid | **[In Progress]** |
| | **Coach Reports (CSV)** | Implemented (Phase 4) | Done | **[Implemented]** |
| **Equipment (設備)** | Real-time HUD (Cadence/Speed) | Implemented (Phase 1) | Done | **[Implemented]** |

---

## 4. UI Functional Specification (UI 元件功能界定)

### 4.1 Header & Navigation (頂部導覽)
- **Hamburger Menu (漢堡選單)**: **[Implemented]** Opens left `Drawer` for global settings and **Logout**.
  - **[已落實]** 開啟左側 `Drawer`。目前的 `Drawer` 承載全域導覽與**登出**按鈕。
- **Notification Bell (通知鈴鐺)**: **[Not Implemented]** Placeholder for future "Notification Center".
  - **[未落實]** 預留位，未來將連結「通知中心」。
- **User Avatar (使用者頭像)**: **[Implemented]** Displays profile picture. Click to Profile (TBD).
  - **[已落實]** 顯示頭像。點擊預計導向個人詳情（未落實）。

### 4.2 Home Dashboard (首頁儀表板)
- **Daily Stats (每日統計)**: **[Implemented]** Distance, Power, Calories, etc.
  - **[已落實]** 顯示距離、功率、卡路里等。
- **Custom Widget Sorting (自定義排序)**: **[Not Implemented]** Allow users to reorder or hide cards.
  - **[未落實]** 允許使用者自由移動或隱藏統計卡片。
- **Training Progress Card (訓練進度卡)**: **[Implemented]** Summary of current cycle progress.
  - **[已落實]** 顯示當前週期的進度摘要。

---

## 5. Operational Modules (營運模組分析)
- **Real-time HUD (實時儀表板)**: **[Implemented]** High-frequency data refresh and physics calculation.
- **Activity Playback (活動回放)**: **[Implemented]** Route visualization and TCX import.
- **Training Management (訓練管理)**:
    - **Feature-First Migration**: **[Implemented]** Entire codebase moved to modular feature capsules.
    - **Cycles (Macro/Meso)**: **[In Progress]** Supports Strength, Speed, etc.
    - **Smart Scheduling (Micro)**: **[Not Implemented]** AI-driven daily workout generation.
- **Social Interaction (社交互動)**:
  - **OAuth Login**: **[Implemented]** Integrated login flow.
  - **Leaderboards**: **[Implemented]** Global rankings.
- **Premium System (訂閱系統)**: **[Not Implemented]** Feature gating mechanism.

---

## 6. System Requirements (系統需求分析)
- **High Frequency Data**: Sensor data needs high-frequency polling and smooth interpolation.
  - **高頻數據處理**: 感測器需求高頻輪詢與平滑插值。
- **Physics Engine**: Logic layer for "Work" and "Power" considering dynamic environment variables.
  - **物理演算引擎**: 考慮動態環境變量的功與功率計算邏輯。
- **Universal Data Schema**: Unified model for both local recordings and imported TCX files.
  - **通用數據架構**: 統一的模型，兼顧本地紀錄與導入數據。

## 7. UI/UX Structure & Navigation (UI/UX 結構與導覽)
- **Footer Navigation**: Home | Cycle | Training | Community | Settings.
- **Header**: User Avatar and Notifications.
- **Sidebar**: Global settings and Device management.
- **Home Dashboard**: Customizable cards, defaulting to Training Cycle progress.

## 8. Globalization & Personalization (全球化與個人化)
- **i18n**: Support for Traditional Chinese (ZH-TW) and English (EN).
- **Theming**: Light and Dark modes with Elite Dragon design system.
- **Animations**: Cinematic login and micro-interactions (Hero transitions).
- **Physical Profile**: Height, weight, age for W/kg calculations.
  - **個人化設定**: 物理參數用於計算功重比 (W/kg)。
