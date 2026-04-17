# Flutter FFI Calculator (Integration with Rust)

This project demonstrates how to integrate a high-performance Rust library into a Flutter application using **FFI (Foreign Function Interface)**.

---

## 🏗 1. Binary Setup | বাইনারি সেটআপ

For FFI to work, you must place the compiled `.so` files into the correct Android directory structure.
FFI-এর জন্য প্রথমে আপনাকে রাস্ট থেকে তৈরি করা `.so` ফাইলগুলো নির্দিষ্ট ফোল্ডারে রাখতে হবে।

### 📂 Folder Structure (Android)
অ্যান্ড্রয়েডে বাইনারি ফাইলগুলো নিচের পাথে থাকতে হবে:
```text
android/app/src/main/jniLibs/
  ├── arm64-v8a/
  │   └── libproject_01_calculator.so (for modern 64-bit phones)
  ├── armeabi-v7a/
  │   └── libproject_01_calculator.so (for older 32-bit phones)
  └── x86_64/
      └── libproject_01_calculator.so (for emulators)
```

---

## 🔗 2. How it Works | যেভাবে এটি কাজ করে

There are 3 main steps in communication between Rust and Flutter:
রাস্ট এবং ফ্লাটারের মধ্যে যোগাযোগের ৩টি ধাপ আছে:

### Step A: Loading the Library | লাইব্রেরি লোড করা
In `rust_calculator.dart`, we load the shared object file:
`rust_calculator.dart` ফাইলে ডাইনামিক লাইব্রেরি লোড করা হয়:
```dart
DynamicLibrary.open('libproject_01_calculator.so');
```
*   **English**: Dart finds the pre-compiled native library from the `jniLibs` folder at runtime.
*   **Bengali**: রানটাইমে ফ্লাটার তার `jniLibs` ফোল্ডার থেকে এই লাইব্রেরিটি খুঁজে বের করে এবং অ্যাপে লোড করে।

### Step B: Function Mapping | ফাংশন ম্যাপিং
We map the pointers from Rust addresses to Dart callables:
রাস্টের ফাংশনকে ডার্টে ব্যবহারযোগ্য করার জন্য ম্যাপিং প্রয়োজন:
```dart
_lib.lookup<NativeFunction<CalcFuncRaw>>('calc_add').asFunction();
```
*   **English**: We search for the function signature inside the binary and convert it into a callable Dart function.
*   **Bengali**: আমরা বাইনারি ফাইলের ভেতর থেকে নির্দিষ্ট ফাংশনের নাম খুঁজে বের করি এবং সেটিকে ডার্টের সাধারণ ফাংশনে রূপান্তর করি।

### Step C: The Memory Bridge | মেমোরি ব্রিজ
Since Dart and Rust have isolated memory heaps, we use Native Pointers:
যেহেতু ডার্ট এবং রাস্টের মেমোরি আলাদা, তাই আমরা `Pointer` ব্যবহার করি। 
*   **Allocation**: Using `calloc<Double>(nums.length)`, data is placed into native memory that both languages can access.
*   **Cleanup**: Once calculation is done, we explicitly call `_freeResult` to release high-level memory assigned by Rust.
*   **Bengali**: `calloc` ব্যবহার করে ডাটা শেয়ার্ড মেমোরিতে রাখা হয় এবং কাজ শেষে `_freeResult` ফাংশন দিয়ে মেমোরি রিলিজ করা হয়।

---

## 🛠 3. Integration Workflow | কাজের ধাপসমূহ

1.  **Input Collection**: Flutter collects numbers as a `List<double>`.
2.  **Native Pointer**: Dart allocates native memory and copies the list into it.
3.  **Rust Execution**: The library computes the result using Rust's high-performance engine for the whole array.
4.  **Result Parsing**: Dart reads the `CalcResult` struct, extracts the value, and displays it.
5.  **Memory Drop**: Both the input array and the result struct are freed from memory to prevent leaks.

---

## 🚀 Key UI Features
- **Glassmorphism Design**: Frosted glass effects using `BackdropFilter`.
- **Haptic Feedback**: Tactile response on button taps.
- **Multi-operand Logic**: Supports long expressions via array processing in Rust.
- **Premium Background**: AI-generated sleek atmospheric background image.
