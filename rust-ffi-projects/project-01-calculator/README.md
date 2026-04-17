# Project-01-Calculator (Rust FFI for Android/Flutter)

This project is a high-performance Calculator library written in Rust, specifically designed to be used in Mobile apps (like Flutter) using **FFI (Foreign Function Interface)**.

---

## 🚀 1. Environment Setup | পরিবেশ সেটআপ

### 1.1 Install Rust | রাস্ট ইনস্টলেশন
If Rust is not installed, use the following command:
রাস্ট ইনস্টল করা না থাকলে নিচের কমান্ডটি ব্যবহার করুন:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 1.2 Setup Android Targets | অ্যান্ড্রয়েড টার্গেট সেটআপ
Add the architectures you want to support (Modern phones, Old phones, Emulators):
যে আর্কিটেকচারগুলোর জন্য লাইব্রেরি বানাতে চান সেগুলো যোগ করুন:
```bash
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
```

### 1.3 Install Cargo-NDK | Cargo-NDK ইনস্টল
This tool links Rust with the Android NDK for smooth compilation:
অ্যান্ড্রয়েড এনডিকে (NDK) এর সাথে রাস্টকে লিঙ্ক করার জন্য এই টুলটি প্রয়োজন:
```bash
cargo install cargo-ndk
```

---

## 🛠 2. Build Process for Android | অ্যান্ড্রয়েডের জন্য বিল্ড প্রসেস

To run Rust in Android, we must build a **Shared Library (`.so` file)**.
অ্যান্ড্রয়েডে রাস্ট চালানোর জন্য আমাদের **Shared Library (`.so` file)** তৈরি করতে হয়।

### 2.1 Cargo.toml Configuration | কনফিগারেশন
Ensure `crate-type = ["cdylib"]` is in your `Cargo.toml`:
`Cargo.toml` ফাইলে নিচের অপশনটি অবশ্যই থাকতে হবে:
```toml
[lib]
crate-type = ["cdylib"]
```

### 2.2 Release Build Command | রিলিজ বিল্ড কমান্ড
Run this command to build for all three architectures in release mode:
একসাথে ৩টি আর্কিটেকচারের জন্য বিল্ড করার কমান্ড:
```bash
cargo ndk -t aarch64-linux-android -t armv7-linux-androideabi -t x86_64-linux-android build --release
```
Output files (.so) location: `target/[target-name]/release/libproject_01_calculator.so`

---

## 🔍 3. Code Explanation | কোড ব্যাখ্যা (Part-by-Part)

### A. Data Structure | ডাটা স্ট্রাকচার
```rust
#[repr(C)]
pub struct CalcResult {
    pub value: f64,
    pub error_code: i32,
}
```
*   **English**: `#[repr(C)]` ensures the memory layout matches C-language standards, which is required for FFI. It stores the calculation result and an error code (0=OK, 1=Div/0, 2=Empty).
*   **Bengali**: `#[repr(C)]` রাস্টকে বলে এই স্ট্রাকচারের মেমোরি লেআউট যেন **C ল্যাঙ্গুয়েজের** মতো হয়। এটি ক্যালকুলেশন রেজাল্ট এবং এরর কোড ধারণ করে।

### B. Core Logic | কোর লজিক
Internal Rust functions like `sum`, `sub`, `mul`, and `div` perform the calculations on a slice of numbers (`&[f64]`).
সাধারণ রাস্ট ফাংশন যা ক্যালকুলেশন করে।

### C. FFI Layer (Exports) | এফএফআই লেয়ার
```rust
#[unsafe(no_mangle)]
pub extern "C" fn calc_add(ptr: *const f64, len: usize) -> *mut CalcResult {
    let nums = unsafe { slice::from_raw_parts(ptr, len) };
    Box::into_raw(Box::new(sum(nums)))
}
```
*   **English**: `#[unsafe(no_mangle)]` prevents Rust from renaming the function so other languages can find it. `Box::into_raw` moves the result to the heap and returns its pointer.
*   **Bengali**: `#[unsafe(no_mangle)]` ফাংশনের নাম ঠিক রাখে যাতে বাইরে থেকে খুঁজে পাওয়া যায়। `Box::into_raw` ডাটাকে হিপ মেমোরিতে রেখে তার এড্রেস বা পয়েন্টার বাইরে পাঠিয়ে দেয়।

### D. Memory Management | মেমোরি রিলিজ
```rust
#[unsafe(no_mangle)]
pub extern "C" fn free_result(ptr: *mut CalcResult) {
    if ptr.is_null() { return; }
    unsafe { Box::from_raw(ptr); }
}
```
*   **English**: Crucial function to prevent memory leaks. The caller (Flutter) must call this to free the memory allocated by Rust.
*   **Bengali**: মেমোরি লিক বন্ধ করার জন্য এটি অত্যন্ত গুরুত্বপূর্ণ। রাস্ট যেহেতু নিজে এফএফআই মেমোরি ডিলিট করে না, তাই কাজ শেষে এই ফাংশনটি কল করে মেমোরি খালি করতে হয়।

---

## 📱 Integration with Flutter
Copy the `.so` files to `android/app/src/main/jniLibs/` in your Flutter project organized by architecture folders:
`.so` ফাইলগুলো ফ্লাটার প্রোজেক্টের নিচের ফোল্ডারগুলোতে রাখুন:
- `jniLibs/arm64-v8a/` -> aarch64
- `jniLibs/armeabi-v7a/` -> armv7
- `jniLibs/x86_64/` -> x86_64
