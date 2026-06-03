# MAJADIGI SUPER APP: MODULAR BACKEND ARCHITECTURE PLAN
*Academic Capstone Project Design - Kelompok C.9 & C.1 (Universitas Brawijaya & KOMINFO JATIM)*

---

## 1. Executive Summary & Problem Solving

This architectural plan outlines the backend system for the transformation of **Majadigi** from a monolithic application into a highly scalable, high-performance, and personalized **Super App**.

### Resolving the Monolith Problem (KOMINFO JATIM Topik C.1)
The primary limitations of the current monolithic Majadigi application are:
1. **Bloated Size & Memory Footprint**: Low-end user devices struggle with the massive storage/RAM requirements of 150+ services.
2. **Poor UX / Heavy Initial Loads**: Forcing citizens to load all services even when they only need one (e.g., checking vehicle tax).
3. **Hard to Scale / High Maintenance**: 400+ services cannot be maintained in a single monolithic structure without constant deployment friction.

### The Modular Monolith Solution
To resolve these issues while maintaining a single, simple, and low-cost deployment suitable for academic environments, we propose a **NestJS Modular Monolith** combined with **PostgreSQL Schema Isolation** and a **Dynamic Feature Loading Strategy**.

*   **Modular Monolith**: Code is divided into strictly decoupled modules (by government department / OPD).
*   **Database Schema Isolation**: A single PostgreSQL instance divided logically into schemas (`auth`, `bapenda`, `rsud`, `bansos`, `hoaks`, etc.). This simulates isolated department databases without the overhead of multiple database servers.
*   **Dynamic Feature Loading**: A specialized Gateway service configuration endpoint (`/gateway/features`) that tells the Flutter client which features are active, their resource paths, and dependencies, enabling the client to dynamically render and lazy-load components based on user persona or location.

---

## 2. Academic Program Role Mapping

This architecture is deliberately designed to provide specific research and implementation scope for each academic major involved in the Capstone project:

```mermaid
graph TD
    classDef TI fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
    classDef TEKKOM fill:#efebe9,stroke:#5d4037,stroke-width:2px;
    classDef TInfo fill:#e8f5e9,stroke:#388e3c,stroke-width:2px;
    classDef SI fill:#fff3e0,stroke:#f57c00,stroke-width:2px;
    classDef PTI fill:#fce4ec,stroke:#c2185b,stroke-width:2px;

    A[Majadigi Super App Backend] --> B(Teknik Informatika - IF)
    A --> C(Teknik Komputer - TEK-KOM)
    A --> D(Teknologi Informasi - TI)
    A --> E(Sistem Informasi - SI)
    A --> F(Pend. Teknologi Informasi - PTI)

    B1["Modular NestJS Architecture & Gateway<br/>JWT/RBAC Security Interceptors<br/>Dynamic Feature Config Endpoint"]:::TI
    B --> B1

    C1["Docker Containerization & Setup<br/>Resource Profiling (CPU/RAM/Network)<br/>Load Testing (k6/JMeter)"]:::TEKKOM
    C --> C1

    D1["OPD Service API Implementations<br/>Centralized Winston/Pino Logging<br/>Health Check & Diagnostics"]:::TInfo
    D --> D1

    E1["OPD Data Sharing & Schema Governance<br/>Persona-based Database Models<br/>Data Integrity Protocols"]:::SI
    E --> E1

    F1["Personalization API Evaluation<br/>Usability Analysis (A/B Test)<br/>User Adoption Studies"]:::PTI
    F --> F1
```

1.  **Teknik Informatika (IF)**:
    *   *Focus*: Software Architecture & Security.
    *   *Deliverables*: Core Modular Monolith skeleton in NestJS, API Gateway routing guards, JWT Auth with Role-Based Access Control (RBAC), and sandboxing simulation between modules.
2.  **Teknik Komputer (TEK-KOM)**:
    *   *Focus*: Performance & Infrastructure Optimization.
    *   *Deliverables*: Multi-stage Docker builds, container orchestration scripts, resource monitoring setup, and high-concurrency load testing (using k6) to analyze RAM and network footprint under heavy load.
3.  **Teknologi Informasi (TI)**:
    *   *Focus*: API Development & Monitoring.
    *   *Deliverables*: Complete RESTful endpoint implementations for OPD modules (Bapenda, RSUD, Bansos), central logging infrastructure (using Winston and Pino), and automated health checks.
4.  **Sistem Informasi (SI)**:
    *   *Focus*: Data Integration, Governance & Personas.
    *   *Deliverables*: Logical ERDs, schema definitions mapping across different government departments, inter-module data sharing protocols, and data protection/governance compliance.
5.  **Pendidikan Teknologi Informasi (PTI)**:
    *   *Focus*: Usability, Literacy & Adoption.
    *   *Deliverables*: Setting up dynamic localization API endpoints and custom telemetry tracking to evaluate how personalized layouts affect user task completion rates and digital literacy.

---

## 3. Technology Stack & Core Dependencies

To match your preferences, the proposed stack balances professional industry standards with academic ease-of-use:

*   **Runtime & Language**: Node.js (v20+) with TypeScript.
*   **Application Framework**: NestJS (v10+). Highly modular, uses Decorators for clean Routing/Guards, and provides outstanding Dependency Injection out of the box.
*   **Database**: PostgreSQL (v16+). Robust support for custom schemas and relational integrity.
*   **Object-Relational Mapping (ORM)**: Prisma or TypeORM. Supports multi-schema connections and clean data mapping.
*   **Containerization**: Docker & Docker Compose.
*   **Security & Auth**: Passport.js with JWT Strategy, bcrypt for password hashing, and Helmet for HTTP security headers.
*   **Rate Limiting**: `@nestjs/throttler` (protects endpoints against brute-force/DDoS).
*   **Central Logging**: `winston` + `morgan` (detailed API request profiling and storage-efficient local log rotation).
*   **Testing Suite**: Jest (for Unit & Integration tests) and **k6** (for Performance/Load testing).

---

## 4. Logical System Architecture

The following diagram illustrates how the **Integrated API Gateway** layer routes incoming client requests internally to strictly separated modules, and how they interact with the schema-isolated PostgreSQL database:

```mermaid
flowchart TD
    Client[Flutter Super App Client] -- HTTPS/REST --> Gateway[NestJS Core API Gateway Layer]

    subgraph NestJS Modular Monolith Runtime
        Gateway --> AuthGuard[Global JWT & RBAC Guard]
        Gateway --> Logger[Winston Central logging Interceptor]
        Gateway --> Throttler[Rate-limiting Guard]

        AuthGuard --> AuthMod[Auth & Profile Module]
        AuthGuard --> BapendaMod[Bapenda Tax Module]
        AuthGuard --> HealthMod[RSUD Health Module]
        AuthGuard --> SocialMod[SAPA Bansos Module]
        AuthGuard --> HoaxMod[Klinik Hoaks Module]
        AuthGuard --> GateMod[Gateway Config Module]
    end

    subgraph PostgreSQL Database Instance
        AuthMod --> SchemaAuth[(Schema: auth)]
        BapendaMod --> SchemaBapenda[(Schema: bapenda)]
        HealthMod --> SchemaHealth[(Schema: rsud)]
        SocialMod --> SchemaSocial[(Schema: bansos)]
        HoaxMod --> SchemaHoax[(Schema: hoaks)]
        GateMod --> SchemaAuth
    end

    classDef blue fill:#e3f2fd,stroke:#1e88e5,stroke-width:2px;
    classDef orange fill:#fff3e0,stroke:#fb8c00,stroke-width:2px;
    classDef green fill:#e8f5e9,stroke:#43a047,stroke-width:2px;
    
    class Client blue;
    class Gateway,AuthGuard,Logger,Throttler,AuthMod,BapendaMod,HealthMod,SocialMod,HoaxMod,GateMod orange;
    class SchemaAuth,SchemaBapenda,SchemaHealth,SchemaSocial,SchemaHoax green;
```

---

## 5. PostgreSQL Schema Isolation Design

To prevent untangled data access and maintain clean separation of concerns, each functional block operates inside a dedicated PostgreSQL schema. Below is the structural schema configuration:

### 1. Schema: `auth`
Tracks core user credentials, security sessions, and general demographics profile.
*   `users`: `id` (UUID), `email`, `password_hash`, `role` (Admin, RegisteredUser, Visitor), `created_at`
*   `profiles`: `id` (UUID), `user_id` (FK -> `users`), `nik` (National ID - Unique), `kk` (Family Card), `nama_lengkap`, `tempat_lahir`, `tanggal_lahir`, `jenis_kelamin`, `telepon`, `alamat_lengkap`
*   `favorites`: `id`, `user_id` (FK), `service_key` (String list of pinned services)

### 2. Schema: `bapenda`
Represents the Regional Revenue Agency (Bapenda) for vehicle tax checks (`info_pkb`) and NJKB searches.
*   `vehicles`: `id` (UUID), `nopol` (License Plate - e.g., N 1234 AB), `nik_pemilik` (Verifies against `auth.profiles.nik`), `merk`, `tipe`, `tahun`, `no_rangka`, `no_mesin`
*   `pkb_bills`: `id` (UUID), `vehicle_id` (FK), `pokok_pkb`, `denda_pkb`, `swdkllj`, `denda_swdkllj`, `status` (Unpaid, Paid), `due_date`
*   `pkb_payments`: `id`, `bill_id` (FK), `payment_method`, `va_number`, `amount_paid`, `paid_at`
*   `njkb_data`: `id`, `merk`, `tipe`, `tahun`, `nilai_njkb`, `bobot`

### 3. Schema: `rsud`
Hosts hospital data, room availability, dynamic outpatient queue scheduling, and surgery timelines.
*   `hospitals`: `id`, `nama_rs`, `alamat`, `tipe` (e.g., RSUD Haji, RSUD Daha Husada)
*   `room_availability`: `id`, `hospital_id` (FK), `kelas_kamar` (VIP, I, II, III, ICU), `kapasitas_total`, `kamar_tersedia`
*   `queues`: `id`, `hospital_id` (FK), `nik` (Patient NIK), `dokter_nama`, `spesialisasi`, `tanggal_kunjungan`, `nomor_antrian`, `status` (Waiting, Call, Done)
*   `surgeries`: `id`, `hospital_id` (FK), `dokter_nama`, `ruangan_operasi`, `jadwal_mulai`, `estimasi_durasi`, `status`

### 4. Schema: `bansos`
Manages the SAPA Bansos applications, eligibility verification, and beneficiary records.
*   `bansos_programs`: `id`, `nama_program` (e.g., PKH, BPNT, BLT), `deskripsi`, `persyaratan_json`, `periode`
*   `applications`: `id`, `program_id` (FK), `nik` (FK -> `auth.profiles.nik`), `nama_ibu_kandung`, `penghasilan_bulanan`, `jumlah_tanggungan`, `status` (Submitted, Verifying, Approved, Rejected), `submitted_at`
*   `documents`: `id`, `application_id` (FK), `document_type` (e.g., KTP, KK, Surat Miskin), `file_url`

### 5. Schema: `hoaks`
Manages Fact-Checking (Klinik Hoaks Jatim).
*   `hoax_articles`: `id`, `judul`, `konten`, `kategori`, `status_klarifikasi` (Fakta, Hoaks, Disinformasi), `url_sumber`, `published_at`
*   `hoax_reports`: `id`, `user_id` (FK or anonymous), `judul_laporan`, `deskripsi_kejadian`, `url_bukti`, `status_laporan` (Pending, Investigating, Clarified)

### 6. Schema: `gateway`
Serves system configuration parameters for dynamic feature loading.
*   `active_features`: `id`, `feature_key` (e.g., `bapenda`), `version`, `status` (Active, Maintenance, Inactive), `flutter_route`, `required_role` (RegisteredUser or Visitor), `last_updated`

---

## 6. Detailed Backend Module Specifications (NestJS)

To build a clean codebase, the NestJS project will follow a standard folder layout:

```
src/
├── main.ts                     # Entry point
├── app.module.ts               # Roots all sub-modules
├── gateway/                    # Dynamic Feature & Routing Gateway
│   ├── gateway.controller.ts
│   ├── gateway.service.ts
│   └── gateway.module.ts
├── modules/                    # Feature Core
│   ├── auth/                   # Authentication & Demographics
│   ├── bapenda/                # Bapenda Tax Service
│   ├── rsud/                   # Hospital Services
│   ├── bansos/                 # Social Assistance
│   └── hoaks/                  # Klinik Hoaks
```

Below is the concrete definition of each module:

### 1. `GatewayModule`
Enables the **Dynamic Feature Loading** strategy. Instead of hardcoding which service is available in Flutter, the client fetches configurations dynamically.
*   **Controller Endpoint**: `GET /gateway/features`
*   **Response Payload**:
    ```json
    {
      "active_features": [
        {
          "key": "bapenda",
          "name": "Bapenda Jatim (PKB & NJKB)",
          "active": true,
          "route": "/bapenda",
          "requires_auth": true,
          "icon_url": "https://cdn.majadigi.go.id/icons/bapenda.png"
        },
        {
          "key": "rsud_daha_husada",
          "name": "RSUD Daha Husada",
          "active": true,
          "route": "/rsud/daha",
          "requires_auth": false,
          "icon_url": "https://cdn.majadigi.go.id/icons/rsud.png"
        },
        {
          "key": "sapa_bansos",
          "name": "SAPA Bansos",
          "active": false,
          "route": "/bansos",
          "requires_auth": true,
          "icon_url": "https://cdn.majadigi.go.id/icons/bansos.png"
        }
      ]
    }
    ```
*   **Flutter Integration Benefit**: If a service undergoes backend maintenance, setting `"active": false` instantly disables or greys out the feature in Flutter without requiring a play store rebuild. This completely resolves the Monolith deployment gridlock!

### 2. `AuthModule` & `ProfileModule`
Provides identity validation and demographics profile retrieval.
*   `POST /auth/register` - Creates user account.
*   `POST /auth/login` - Validates credentials, returns JWT token containing NIK and roles.
*   `GET /profile/me` - Returns complete demographic data (KTP/KK mapping) extracted from the `auth.profiles` table.
*   `PATCH /profile/favorites` - Updates user's personalized quick-access shortcut list.

### 3. `BapendaModule`
Provides tax information and online payment generation.
*   `GET /bapenda/pkb/check?nopol=N1234AB` - Queries `bapenda.vehicles` and outstanding `bapenda.pkb_bills`. Returns active payment components (PKB, Jasa Raharja/SWDKLLJ, etc.).
*   `POST /bapenda/pkb/pay` - Initiates online tax payment, creates record in `bapenda.pkb_payments`, and returns Mock Virtual Account.
*   `GET /bapenda/njkb` - Searches public vehicle price indices for NJKB calculations.

### 4. `RsudModule`
Fulfills hospital services requirements.
*   `GET /rsud/hospitals` - Lists Jatim provincial hospitals.
*   `GET /rsud/:hospitalId/rooms` - Returns real-time room availability counts (`rsud.room_availability`).
*   `POST /rsud/:hospitalId/queue` - Registers patient queue. Generates a dynamic queue number based on current count.
*   `GET /rsud/:hospitalId/surgeries` - Shows active and scheduled surgery calendars.

### 5. `BansosModule`
Manages social welfare requests.
*   `GET /bansos/programs` - Lists active Jatim social programs.
*   `POST /bansos/apply` - Submits a multi-step eligibility application (`bansos.applications`). Takes economic data and KK details.
*   `GET /bansos/status` - Checks application tracking status (Submitted -> Verifying -> Approved).

### 6. `HoaksModule`
Hosts the Klinik Hoaks facts and community reporting.
*   `GET /hoaks/articles` - Returns public fact-checking news feed.
*   `POST /hoaks/report` - Allows citizens to submit news links/screenshots for review.

---

## 7. Cross-Cutting Concerns & Security Design

To secure the modular boundary and satisfy the **Teknik Informatika** and **Teknologi Informasi** requirements, we implement clean filters and pipeline guards:

### 1. Global API Gateway Middleware & Security
*   **Helmet.js**: Injected globally in `main.ts` to add HTTP security headers (prevents XSS, Clickjacking).
*   **CORS**: Configured exclusively for the Flutter mobile application domain.
*   **Global Throttling (Rate Limiting)**:
    ```typescript
    ThrottlerModule.forRoot([{
      ttl: 60000, // 1 minute
      limit: 100,  // max 100 requests per IP
    }])
    ```

### 2. Authorization & Sandboxing between Modules
Even though it is a modular monolith (all modules run in the same process), we simulate *Sandboxing* via **Logical Decoupling**:
*   **No Cross-Entity Imports**: `BapendaModule` must **never** directly import `AuthModule` entities or repositories.
*   **Communication Interface**: If Bapenda needs to verify if a user's NIK exists, it must do so through a defined service interface (e.g., `ProfileService.verifyNik(nik: string)`) rather than direct database querying on the `auth` schema.
*   **JWT Propagation**: Every request must carry `Authorization: Bearer <JWT>`. The Gateway decodes the JWT and populates `req.user` with NIK and roles. Modules only have access to `req.user` metadata for logical access validation.

### 3. Centralized Audit Logging
For monitoring and auditing purposes (**Teknologi Informasi**):
*   Every incoming request is intercepted by a custom global logging interceptor.
*   Uses **Winston** to write logs into structured JSON formats.
*   Logs are categorized: `info.log` for access routes, `error.log` for HTTP 500 crashes, and `audit.log` to track sensitive data actions (e.g., making Bapenda PKB payments or submitting Bansos).
*   Log structure example:
    ```json
    {
      "timestamp": "2026-05-30T13:00:00Z",
      "level": "info",
      "path": "/bapenda/pkb/pay",
      "method": "POST",
      "nik": "3573xxxxxxxxxxxx",
      "ip": "192.168.1.50",
      "duration_ms": 42
    }
    ```

---

## 8. Infrastructure, Deployment & Performance Plan

Designed specifically for **Teknik Komputer** and **Teknologi Informasi** research:

### 1. Multi-Stage Docker Build
To ensure the container size is minimized (satisfying **resource management optimization**):

```dockerfile
# --- Stage 1: Build Source ---
FROM node:20-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm prune --production

# --- Stage 2: Minimal Runtime ---
FROM node:20-alpine AS runner
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main"]
```
*   **Why Stage 2 works**: By throwing away compiler assets, the final Docker image size shrinks from **~850MB to <180MB**, matching the constraint of resource-efficient cloud deployments.

### 2. Docker Compose Infrastructure
Orchestrates the entire local system in a isolated networking bridge:

```yaml
version: '3.8'

services:
  majadigi-postgres:
    image: postgres:16-alpine
    container_name: majadigi_db
    restart: always
    environment:
      POSTGRES_DB: majadigi
      POSTGRES_USER: dev_user
      POSTGRES_PASSWORD: securepassword
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init-schemas.sql:/docker-entrypoint-initdb.d/init-schemas.sql
    networks:
      - majadigi-network

  majadigi-backend:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: majadigi_api
    restart: always
    environment:
      NODE_ENV: production
      DATABASE_URL: postgresql://dev_user:securepassword@majadigi-postgres:5432/majadigi?schema=public
      JWT_SECRET: capstoneC9superappkey
      PORT: 3000
    ports:
      - "3000:3000"
    depends_on:
      - majadigi-postgres
    networks:
      - majadigi-network

volumes:
  pgdata:

networks:
  majadigi-network:
    driver: bridge
```

### 3. Load & Performance Testing (k6 Concept)
To evaluate the modular monolith under high load, **Teknik Komputer** students can run this automated `k6` script:

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 50 },  // Ramp-up to 50 concurrent users
    { duration: '1m', target: 50 },   // Maintain 50 users
    { duration: '30s', target: 0 },    // Cool down
  ],
};

export default function () {
  // Test Bapenda Jatim PKB Query Endpoint
  const url = 'http://localhost:3000/bapenda/pkb/check?nopol=N1234AB';
  const params = {
    headers: {
      'Authorization': 'Bearer test-mock-token',
    },
  };
  const res = http.get(url, params);
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 150ms': (r) => r.timings.duration < 150,
  });
  
  sleep(1);
}
```

---

## 9. Next Steps for Implementation

To bring this plan to life, your academic group can follow this clean implementation timeline:

```
[Phase 1: Foundation] -> [Phase 2: DB Schema Isolation] -> [Phase 3: Module Coding] -> [Phase 4: Flutter API Hooks] -> [Phase 5: Load Testing & Optimization]
```

1.  **Phase 1 (Foundation)**: Initialize NestJS with TS, set up Docker Compose, and configure Winston Logging.
2.  **Phase 2 (Database Setup)**: Write `init-schemas.sql` to generate schemas (`auth`, `bapenda`, etc.), and wire Prisma/TypeORM.
3.  **Phase 3 (Core API Development)**: Implement `GatewayModule`, `AuthModule`, and subsequently the individual OPD services one by one.
4.  **Phase 4 (Flutter Connection)**: Add `http` or `dio` packages in `pubspec.yaml` of `@capstoneproject-repo`, replacing the current statics/mockups with actual HTTP client fetching.
5.  **Phase 5 (Performance Tuning)**: Run the Docker configurations, execute the `k6` performance scenarios, and document memory/latency profiles.
