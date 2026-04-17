import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Match the Rust struct
final class CalcResult extends Struct {
  @Double()
  external double value;
  @Int32()
  external int errorCode;
}

// Function signatures
typedef CalcFuncRaw =
    Pointer<CalcResult> Function(Pointer<Double> ptr, Size len);
typedef CalcFunc = Pointer<CalcResult> Function(Pointer<Double> ptr, int len);

typedef FreeResultRaw = Void Function(Pointer<CalcResult> ptr);
typedef FreeResult = void Function(Pointer<CalcResult> ptr);

class RustCalculator {
  static final DynamicLibrary _lib = _loadLibrary();

  static DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libproject_01_calculator.so');
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return DynamicLibrary.process();
    }
    throw UnsupportedError('Platform not supported');
  }

  // Bindings
  static final CalcFunc _calcAdd = _lib
      .lookup<NativeFunction<CalcFuncRaw>>('calc_add')
      .asFunction();
  static final CalcFunc _calcSub = _lib
      .lookup<NativeFunction<CalcFuncRaw>>('calc_sub')
      .asFunction();
  static final CalcFunc _calcMul = _lib
      .lookup<NativeFunction<CalcFuncRaw>>('calc_mul')
      .asFunction();
  static final CalcFunc _calcDiv = _lib
      .lookup<NativeFunction<CalcFuncRaw>>('calc_div')
      .asFunction();
  static final FreeResult _freeResult = _lib
      .lookup<NativeFunction<FreeResultRaw>>('free_result')
      .asFunction();

  static double add(List<double> nums) => _calculate(_calcAdd, nums);
  static double subtract(List<double> nums) => _calculate(_calcSub, nums);
  static double multiply(List<double> nums) => _calculate(_calcMul, nums);
  static double divide(List<double> nums) => _calculate(_calcDiv, nums);

  static double _calculate(CalcFunc func, List<double> nums) {
    if (nums.isEmpty) throw Exception("Input numbers cannot be empty");

    final pointer = calloc<Double>(nums.length);

    for (var i = 0; i < nums.length; i++) {
      pointer[i] = nums[i];
    }

    final resultPtr = func(pointer, nums.length);
    final result = resultPtr.ref;

    final value = result.value;
    final err = result.errorCode;

    // Free memory
    calloc.free(pointer);
    _freeResult(resultPtr);

    if (err == 1) throw Exception("Division by zero");
    if (err == 2) throw Exception("Empty input");
    if (err != 0) throw Exception("Unknown error: $err");

    return value;
  }
}
