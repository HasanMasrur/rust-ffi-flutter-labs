use std::slice;

#[repr(C)]
pub struct CalcResult {
    pub value: f64,
    pub error_code: i32, // 0 = OK, 1 = divide by zero, 2 = empty input
}

impl CalcResult {
    fn ok(value: f64) -> Self {
        Self { value, error_code: 0 }
    }

    fn error(code: i32) -> Self {
        Self { value: 0.0, error_code: code }
    }
}

//
// 🔥 CORE LOGIC (multiple number)
//

fn sum(nums: &[f64]) -> CalcResult {
    if nums.is_empty() {
        return CalcResult::error(2);
    }
    CalcResult::ok(nums.iter().sum())
}

fn sub(nums: &[f64]) -> CalcResult {
    if nums.is_empty() {
        return CalcResult::error(2);
    }

    let first = nums[0];
    let rest_sum: f64 = nums[1..].iter().sum();

    CalcResult::ok(first - rest_sum)
}

fn mul(nums: &[f64]) -> CalcResult {
    if nums.is_empty() {
        return CalcResult::error(2);
    }

    let result = nums.iter().fold(1.0, |acc, x| acc * x);
    CalcResult::ok(result)
}

fn div(nums: &[f64]) -> CalcResult {
    if nums.is_empty() {
        return CalcResult::error(2);
    }

    let mut result = nums[0];

    for &num in &nums[1..] {
        if num == 0.0 {
            return CalcResult::error(1);
        }
        result /= num;
    }

    CalcResult::ok(result)
}

//
// 🔗 FFI FUNCTIONS (IMPORTANT)
//

#[unsafe(no_mangle)]
pub extern "C" fn calc_add(ptr: *const f64, len: usize) -> *mut CalcResult {
    let nums = unsafe { slice::from_raw_parts(ptr, len) };
    Box::into_raw(Box::new(sum(nums)))
}

#[unsafe(no_mangle)]
pub extern "C" fn calc_sub(ptr: *const f64, len: usize) -> *mut CalcResult {
    let nums = unsafe { slice::from_raw_parts(ptr, len) };
    Box::into_raw(Box::new(sub(nums)))
}

#[unsafe(no_mangle)]
pub extern "C" fn calc_mul(ptr: *const f64, len: usize) -> *mut CalcResult {
    let nums = unsafe { slice::from_raw_parts(ptr, len) };
    Box::into_raw(Box::new(mul(nums)))
}

#[unsafe(no_mangle)]
pub extern "C" fn calc_div(ptr: *const f64, len: usize) -> *mut CalcResult {
    let nums = unsafe { slice::from_raw_parts(ptr, len) };
    Box::into_raw(Box::new(div(nums)))
}

//
// 🧹 MEMORY FREE (VERY IMPORTANT)
//

#[unsafe(no_mangle)]
pub extern "C" fn free_result(ptr: *mut CalcResult) {
    if ptr.is_null() {
        return;
    }

    unsafe {
        Box::from_raw(ptr);
    }
}