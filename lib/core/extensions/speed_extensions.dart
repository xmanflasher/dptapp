num? parseNullableSpeed(dynamic value) {
  if (value == "" || value == null) {
    return 0.0; // 當值為空或 null，返回 null
  }
  if (value is num) {
    return value; // 如果是數字，直接返回
  }
  return num.tryParse(value.toString()); // 嘗試解析為數字
}