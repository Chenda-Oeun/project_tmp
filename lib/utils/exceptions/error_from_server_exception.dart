import 'package:dio/dio.dart';


class ErrorFromServerException extends Error {
  final int? statusCode;
  final String? error;
  final String? message;
  final List<String>? messages;
  final Map<String, List<String>>? validation;
  final Map<String, dynamic>? data;

  ErrorFromServerException({
    required this.statusCode,
    this.error,
    this.message,
    this.messages,
    this.validation,
    this.data,
  });

  static ErrorFromServerException fromError(DioException exception) {
    String? error;
    String? message;
    List<String>? messages;
    Map<String, List<String>>? validation;
    Map<String, dynamic>? data;
    try {
      error = exception.response?.data['error'];
      data = exception.response?.data['data'];

      if (exception.response?.data['message'] is String) {
        message = exception.response?.data['message'];
        if (message != null) {
          ///TODO
          message = message;
          // message = T.r(message);
        }
      }
      if (exception.response?.data['message'] is Iterable) {
        messages = List<String>.from(exception.response?.data['message']);
      }
    } catch (_) {}
    try {
      if (exception.response?.data['validation'] is Map) {
        validation = Map<String, List<String>>.from(
            exception.response?.data['validation']);
      }
    } catch (_) {}
    return ErrorFromServerException(
      statusCode: exception.response?.statusCode,
      error: error,
      message: message,
      messages: messages,
      validation: validation,
      data: data,
    );
  }

  @override
  String toString() {
    if (message != null && ErrorDictionary.canResolve(message!)) {
      return ErrorDictionary.resolve(message!)!;
    }

    if (statusCode == 500 && error is String) {
      return error!;
    }
    if (message != null) return message!;

    if (messages != null && messages!.isNotEmpty) {
      return messages!.first;
    }
    if (statusCode != null) return statusCode.toString();
    return "Technical error!";
  }
}

class ErrorDictionary {
  static bool canResolve(String errorKey) {
    /// TODO
    return false;
    // return errorMessages.containsKey(errorKey);
  }

  static String? resolve(String errorKey) {
    print("Error Key::::");
    /// TODO
    return "Something went wrong!";
    // return errorMessages[errorKey]?.r;
  }

  // static Map<String, I18n<String>> errorMessages = {
  //   'USER_NOT_FOUND': I18n(
  //     en: 'Incorrect username',
  //     zh: '未找到用户',
  //     vi: 'Không tìm thấy người dùng',
  //     km: 'រកមិនឃើញអ្នកប្រើ',
  //   ),
  //   'INCORRECT_PASSWORD': I18n(
  //     en: 'Incorrect password',
  //     zh: '密码错误',
  //     vi: 'Mật khẩu không chính xác',
  //     km: 'លេខសម្ងាត់មិនត្រឹមត្រូវ',
  //   ),
  //   'REFUND_EXCEED_QTY': I18n(
  //     en: 'Refund quantity exceeds available amount',
  //     zh: '退款数量超过可用数量',
  //     vi: 'Số lượng hoàn trả vượt quá số lượng có sẵn',
  //     km: 'បរិមាណសងប្រាក់លើសចំនួនដែលអាចប្រើបាន',
  //   ),
  //   'PRODUCT_NOT_FOUND': I18n(
  //     en: 'Product not found',
  //     zh: '未找到产品',
  //     vi: 'Không tìm thấy sản phẩm',
  //     km: 'រកមិនឃើញផលិតផល',
  //   ),
  //   'ORDER_NOT_FOUND': I18n(
  //     en: 'Order not found',
  //     zh: '未找到订单',
  //     vi: 'Không tìm thấy đơn hàng',
  //     km: 'រកមិនឃើញការបញ្ជាទិញ',
  //   ),
  //   'INVALID_ACTION': I18n(
  //     en: 'Invalid action',
  //     zh: '无效操作',
  //     vi: 'Hành động không hợp lệ',
  //     km: 'សកម្មភាពមិនត្រឹមត្រូវ',
  //   ),
  //   'CATEGORY_NOT_FOUND': I18n(
  //     en: 'Category not found',
  //     zh: '未找到类别',
  //     vi: 'Không tìm thấy danh mục',
  //     km: 'រកមិនឃើញប្រភេទ',
  //   ),
  //   'CUSTOMER_NOT_FOUND': I18n(
  //     en: 'Customer not found',
  //     zh: '未找到客户',
  //     vi: 'Không tìm thấy khách hàng',
  //     km: 'រកមិនឃើញអតិថិជន',
  //   ),
  //   'ATTACHMENT_NOT_FOUND': I18n(
  //     en: 'Attachment not found',
  //     zh: '未找到附件',
  //     vi: 'Không tìm thấy tệp đính kèm',
  //     km: 'រកមិនឃើញឯកសារភ្ជាប់',
  //   ),
  //   'STOCK_NOT_AVAILABLE': I18n(
  //     en: 'Stock not available',
  //     zh: '库存不可用',
  //     vi: 'Hàng tồn kho không có sẵn',
  //     km: 'ស្តុកមិនមាន',
  //   ),
  //   'INVALID_PAYMENT_METHOD': I18n(
  //     en: 'Invalid payment method',
  //     zh: '无效的付款方式',
  //     vi: 'Phương thức thanh toán không hợp lệ',
  //     km: 'វិធីបង់ប្រាក់មិនត្រឹមត្រូវ!',
  //   ),
  //   'FAILED_TO_CREATE_PAYMENT_RECORD': I18n(
  //     en: 'Failed to create payment record',
  //     zh: '创建付款记录失败',
  //     vi: 'Tạo hồ sơ thanh toán thất bại',
  //     km: 'បរាជ័យក្នុងការបង្កើតកំណត់ត្រាការទូទាត់',
  //   ),
  //   'INVALID_REFRESH_TOKEN': I18n(
  //     en: 'Invalid refresh token',
  //     zh: '刷新令牌无效',
  //     vi: 'Refresh token không hợp lệ',
  //     km: 'អត្តសញ្ញាណមិនត្រឹមត្រូវ',
  //   ),
  //   'SETTING_NOT_FOUND': I18n(
  //     en: 'Setting not found',
  //     zh: '未找到设置',
  //     vi: 'Không tìm thấy cài đặt',
  //     km: 'រកមិនឃើញការកំណត់',
  //   ),
  //   'LOCK_SCREEN_PIN_CODE_IS_ALREADY_SET': I18n(
  //     en: 'Lock screen PIN code is already set',
  //     zh: '锁屏PIN码已设置',
  //     vi: 'Mã PIN màn hình khóa đã được đặt',
  //     km: 'លេខសម្ងាត់ត្រូវបានកំណត់រួចហើយ',
  //   ),
  //   'INVALID_KEY': I18n(
  //     en: 'Invalid key',
  //     zh: '无效的密钥',
  //     vi: 'Khóa không hợp lệ',
  //     km: 'សោមិនត្រឹមត្រូវ',
  //   ),
  //   'TOO_MANY_REQUEST': I18n(
  //     en: 'Too many requests',
  //     zh: '请求过多',
  //     vi: 'Quá nhiều yêu cầu',
  //     km: 'សំណើច្រើនពេក សូមរង់ចាំ និងព្យាយាមម្តងទៀត',
  //   ),
  //   'ORDER_NOT_PENDING': I18n(
  //     en: 'Order is not pending',
  //     zh: '订单不是待处理状态',
  //     vi: 'Đơn hàng không ở trạng thái chờ',
  //     km: 'ការកម្មង់មិននៅក្នុងស្ថានភាពកំពុងរង់ចាំ',
  //   ),
  //   'PAYMENT_AMOUNT_NOT_MATCH': I18n(
  //     en: 'Payment amount does not match',
  //     zh: '付款金额不匹配',
  //     vi: 'Số tiền thanh toán không khớp',
  //     km: 'ចំនួនទឹកប្រាក់បង់មិនត្រឹមត្រូវ',
  //   ),
  //   'FAILED_TO_GENERATE_QR': I18n(
  //     en: 'Failed to generate QR code',
  //     zh: '生成二维码失败',
  //     vi: 'Tạo mã QR thất bại',
  //     km: 'បរាជ័យក្នុងការបង្កើតកូដ QR',
  //   ),
  //   'INVALID_QR_CODE': I18n(
  //       en: 'Invalid QR code',
  //       zh: '二维码无效',
  //       zhTw: '二維碼無效',
  //       km: 'កូដ QR មិនត្រឹមត្រូវ',
  //       vi: 'Mã QR không hợp lệ'),
  //   "INTERNAL_SERVER_ERROR": I18n(
  //       en: 'Internal server error',
  //       zh: '服务器内部错误',
  //       zhTw: '伺服器內部錯誤',
  //       km: 'កំហុសក្នុងម៉ាស៊ីន​មេ',
  //       vi: 'Lỗi máy chủ nội bộ'),
  //   "INCORRECT_QR_VERIFICATION_CODE": I18n(
  //       en: 'Incorrect QR verification code',
  //       zh: '二维码验证码不正确',
  //       zhTw: 'QR 驗證碼不正確',
  //       km: 'លេខកូដផ្ទៀងផ្ទាត់ QR មិនត្រឹមត្រូវ',
  //       vi: 'Mã xác minh QR không đúng'),
  //   "CURRENCY_MISMATCH": I18n(
  //       en: 'Currency mismatch',
  //       zh: '货币不匹配',
  //       zhTw: '貨幣不相符',
  //       km: 'រូបិយវត្ថុមិនត្រូវគ្នា',
  //       vi: 'Không khớp loại tiền tệ'),
  //   "MERCHANT_IS_LOCKED": I18n(
  //       en: 'Merchant account is locked',
  //       zh: '商家账户已被锁定',
  //       zhTw: '商家帳戶已被鎖定',
  //       km: 'គណនីអ្នកជ្រើសរើសត្រូវបានបិទ',
  //       vi: 'Tài khoản người bán đã bị khóa'),
  //   "NOT_ENOUGH_BALANCE": I18n(
  //       en: 'Not enough balance',
  //       zh: '余额不足',
  //       zhTw: '餘額不足',
  //       km: 'ប្រាក់មិនគ្រប់គ្រាន់',
  //       vi: 'Số dư không đủ'),
  //   "TRANSACTION_MINIMUM_LIMIT": I18n(
  //       en: 'Below the minimum transaction limit',
  //       zh: '低于最低交易限额',
  //       zhTw: '低於最低交易限額',
  //       km: 'ក្រោមកម្រិតអប្បបរមានៃប្រតិបត្តិការ',
  //       vi: 'Thấp hơn giới hạn giao dịch tối thiểu'),
  //   "TRANSACTION_MAXIMUM_LIMIT": I18n(
  //       en: 'Exceeded the maximum transaction limit',
  //       zh: '超过最高交易限额',
  //       zhTw: '超過最高交易限額',
  //       km: 'លើសកម្រិតអតិបរមានៃប្រតិបត្តិការ',
  //       vi: 'Vượt quá giới hạn giao dịch tối đa'),
  //   "TRANSACTION_REACHED_DAILY_LIMIT": I18n(
  //       en: 'Daily transaction limit reached',
  //       zh: '已达到每日交易限额',
  //       zhTw: '已達到每日交易限額',
  //       km: 'បានឈានដល់កម្រិតប្រតិបត្តិការប្រចាំថ្ងៃ',
  //       vi: 'Đã đạt giới hạn giao dịch hằng ngày'),
  //   "BANK_DAILY_MAXIMUM_LIMIT": I18n(
  //       en: 'Reached the bank’s daily maximum limit',
  //       zh: '已达到银行每日最高限额',
  //       zhTw: '已達到銀行每日最高限額',
  //       km: 'បានឈានដល់កម្រិតអតិបរមាប្រចាំថ្ងៃរបស់ធនាគារ',
  //       vi: 'Đã đạt giới hạn tối đa hằng ngày của ngân hàng'),
  //   "UNEXPECTED_ERROR": I18n(
  //       en: 'Technical Error',
  //       zh: '技术错误',
  //       zhTw: '技術錯誤',
  //       km: 'កំហុសបច្ចេកទេស',
  //       vi: 'Lỗi kỹ thuật'),
  //   'PIN_CODE_NOT_MATCH': I18n(
  //     en: 'PIN code does not match',
  //     zh: 'PIN码不匹配',
  //     vi: 'Mã PIN không khớp',
  //     km: 'លេខសម្ងាត់ទូទាត់មិនត្រឹមត្រូួវ',
  //   ),
  //   'REFUND_AMOUNT_NOT_MATCH': I18n(
  //     en: 'Refund amount does not match.',
  //     zh: '退款金额不符。',
  //     zhTw: '退款金額不符。',
  //     km: 'ចំនួនទឹកប្រាក់បង្វិលសងមិនត្រូវគ្នា',
  //     vi: 'Số tiền hoàn lại không khớp.',
  //   )
  // };
}
