# 🚀 Rust FFI + Flutter — 20 Projects Mastery

A structured, production-focused journey to mastering **Rust FFI (Foreign Function Interface)** integrated with **Flutter**.

This repository contains 20 carefully designed projects that progressively build from **fundamentals → real-world systems → advanced architecture → low-level performance engineering**.

---

## 🎯 Objective

* Master Rust FFI in real-world scenarios
* Build high-performance native engines in Rust
* Integrate seamlessly with Flutter UI
* Learn memory safety, concurrency, and system design
* Develop production-ready engineering mindset

---

## 🧠 What This Covers

* Rust ↔ Flutter communication via FFI
* Memory management (CString, CStr, raw pointers)
* Threading & concurrency
* Panic-safe boundaries
* Zero-copy architecture
* Plugin systems & dynamic loading
* Async runtime fundamentals

---

## 🧱 Project Roadmap

### 🟢 Level 1 — Foundation (FFI Basics)

| #  | Project           | Key Learning                  |
| -- | ----------------- | ----------------------------- |
| 01 | [Calculator Engine (Rust)](rust-ffi-projects/project-01-calculator/README.md) / [UI (Flutter)](flutter-projects/project_01_calculator/README.md) | Error handling, FFI basics    |
| 02 | HTML Converter    | CString / CStr, encoding      |
| 03 | String Toolkit    | Multi-function bindings       |
| 04 | JSON Validator    | serde_json, error propagation |
| 05 | Unit Converter    | Enum mapping, API design      |

---

### ⚙️ Level 2 — Real Data & State

| #  | Project           | Key Learning         |
| -- | ----------------- | -------------------- |
| 06 | Notes Engine      | Vec, HashMap, state  |
| 07 | File Search       | File I/O, recursion  |
| 08 | System Monitor    | Threading, callbacks |
| 09 | Log Parser        | Regex, streaming     |
| 10 | Binary Serializer | bincode, performance |

---

### 🔥 Level 3 — Advanced Systems

| #  | Project            | Key Learning    |
| -- | ------------------ | --------------- |
| 11 | Streaming Engine   | Channels, async |
| 12 | Task Scheduler     | Thread pool     |
| 13 | Encrypted Storage  | Cryptography    |
| 14 | Image Engine       | Heavy compute   |
| 15 | Panic-safe Wrapper | catch_unwind    |

---

### 💀 Level 4 — Expert Mode

| #  | Project            | Key Learning           |
| -- | ------------------ | ---------------------- |
| 16 | Zero-Copy Pipeline | Unsafe, memory control |
| 17 | Search Engine      | Indexing, ranking      |
| 18 | Plugin System      | Dynamic loading        |
| 19 | P2P Transfer       | Networking             |
| 20 | Async Runtime      | Reactor pattern        |

---

## 📁 Repository Structure

```bash
.
├── rust-ffi-projects/
│   ├── project-01-calculator/
│   ├── project-02-html-converter/
│   └── ...
│
├── flutter-projects/
│   ├── project_01_calculator/
│   ├── project-02-html-ui/
│   └── ...
│
└── README.md
```

Each project is fully isolated and contains:

* Rust core engine
* Flutter UI
* Clear build/run instructions
* Learning notes

---

## ⚙️ How to Run

### 🦀 Rust (Core Engine)

```bash
cd [rust-ffi-projects/project-01-calculator](rust-ffi-projects/project-01-calculator/README.md)
cargo build --release
```

---

### 📱 Flutter (UI)

```bash
cd [flutter-projects/project_01_calculator](flutter-projects/project_01_calculator/README.md)
flutter pub get
flutter run
```

---

## 📅 20-Day Execution Plan

| Phase        | Days      | Focus                     |
| ------------ | --------- | ------------------------- |
| Foundation   | Day 1–3   | FFI basics, memory        |
| Intermediate | Day 4–8   | State, threading          |
| Advanced     | Day 9–15  | Concurrency, architecture |
| Expert       | Day 16–20 | Systems, performance      |

---

## 🧠 Engineering Focus

* Clean API design between Rust & Flutter
* Memory safety across FFI boundary
* Avoid unnecessary allocations
* Handle errors gracefully (no crashes)
* Build reusable abstractions

---

## ⚠️ Challenges

* Unsafe Rust usage
* Memory leaks across language boundary
* Thread synchronization
* ABI compatibility
* Debugging FFI issues

---

## 💬 Final Outcome

After completing this repository, you will be able to confidently say:

* Designed high-performance Rust engines
* Built Flutter apps backed by native systems
* Implemented zero-copy data pipelines
* Created panic-safe FFI boundaries
* Worked with async runtime internals

---

## 🚀 Why This Matters

This is not just a project collection.

This is a **deep systems engineering journey** combining:

* Low-level Rust
* High-level Flutter
* Real-world architecture thinking

---

## 👨‍💻 Author

**Hasan Masrur**
Software Engineer | Flutter | Rust | Backend Systems

---

## ⭐ Support

If you find this helpful, consider giving this repo a star ⭐
It helps others discover this work and supports the journey.

---
