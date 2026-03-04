# System Design: dptapp (Refined for Dragon Boat)

## 1. System Architecture Diagram
The architecture is optimized for low-latency data streaming and real-time physical calculations.

```mermaid
graph TD
    UI[Presentation: Real-time Dashboard] --> BLoC[BLoC: Stream Manager]
    UI --> ThemeCubit[ThemeCubit: Dark/Light Switch]
    UI --> SettingsCubit[SettingsCubit: User Config]
    
    BLoC --> Engine[Logic: Physics Engine - Power/Work Calc]
    Engine --> Domain[Domain: Activity & Simulation Entities]
    
    BLoC --> CycleGen[Logic: Cycle/Workout Generator Engine]
    CycleGen -.-> UserConfig
    
    UI --> ExportService[Service: CSV Export]
    
    subgraph "Data Acquisition"
        Sensors[GPS / Cadence Sensors] -- Bluetooth --> BLoC
        Import[Garmin/Strava File] --> DataLayer[Data: Activity Repo]
    end
    
    subgraph "Authentication & User"
        AuthUI[Login Screen] --> AuthLayer[Auth Repo: Google/LINE/FB OAuth]
        AuthLayer --> UserProfile[User Profile: Avatar, Name]
    end
    
    subgraph "Storage"
        DataLayer --> Hive[Hive: Activity History]
        SettingsCubit --> Hive[Hive: User Config]
        BLoC --> Hive
    end
    
    Engine -.-> Params[Simulation Parameters: Wind/Water/Weight]
```

## 2. Real-time Training Feedback Flow
This sequence shows how sensor data is combined with user-defined parameters for real-time coaching.

```mermaid
sequenceDiagram
    participant S as Sensors (GPS/Cadence)
    participant B as BLoC / StreamManager
    participant E as Physics Engine
    participant P as Simulation Params
    participant D as Real-time Dashboard (UI)
    participant T as Theme/Settings

    T->>D: Apply Elite Dragon Theme (Color Zones)
    S->>B: Raw Data Packet (Stream)
    B->>P: Fetch Current Simulation Params
    P-->>B: {Wind, BoatWeight, CrewWeight}
    B->>E: Calculate Metrics(RawData, Params)
    E-->>B: {Power, Work, Impulse}
    B->>D: Update UI State (Live Metrics)
    D-->>D: Color Code based on HR/Power Zones
```

## 3. Data Consolidation: Import & Playback
```mermaid
graph LR
    Import[Imported File] --> UnifiedModel[Unified Activity Model]
    Internal[Recorded Activity] --> UnifiedModel
    UnifiedModel --> Summary[History View]
    UnifiedModel --> Playback[Replay View / Chart Analysis]
```

## 4. Key Entities for Simulation & Personalization
```mermaid
classDiagram
    class TrainingCycle {
        +List disciplines
        +String cycleName
        +String phaseType
        +List workouts
        +double progress
    }
    class Workout {
        +String phase
        +List laps
    }
    class Activity {
        +String title
        +DateTime date
        +List dataPoints
        +SimulationParams appliedParams
    }
    class SimulationParams {
        +double windResistance
        +double waterResistance
        +double boatWeight
        +double crewTotalWeight
        +List crewDistribution
    }
    class UserConfig {
        +String uid
        +String displayName
        +String avatarUrl
        +String language
        +String themeMode
        +bool useMetric
        +double userWeight
        +Map hrZones
        +Map powerZones
    }
    TrainingCycle "1" *-- "*" Workout
    Workout "1" *-- "*" Activity
    Activity "1" *-- "1" SimulationParams
    UserConfig "1" -- "1" ThemeCubit
```

## 5. Design Patterns Added
- **Strategy Pattern (Calculation)**: Different physics models for different boat types or environmental conditions can be swapped dynamically.
- **Observer Pattern (Streams)**: UI widgets subscribe to the BLoC data streams for millisecond-level updates.
- **State Pattern (Theme)**: `ThemeCubit` manages the application's appearance state globally.
- **Command Pattern (Playback)**: Encapsulates activity data into "seekable" commands for rewind/play functionality.
