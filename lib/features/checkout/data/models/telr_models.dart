/// Telr Create Session Request Model (v1)
class TelrCreateSessionRequest {
  final String transactionType;
  final String cartId;
  final TelrAmount amount;
  final TelrCustomer customer;
  final String description;

  const TelrCreateSessionRequest({
    this.transactionType = 'SALE',
    required this.cartId,
    required this.amount,
    required this.customer,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'cartId': cartId,
      'amount': amount.toJson(),
      'customer': customer.toJson(),
      'description': description,
    };
  }
}

/// Telr Amount Model
class TelrAmount {
  final String value;
  final String currency;

  const TelrAmount({required this.value, this.currency = 'AED'});

  Map<String, dynamic> toJson() {
    return {'value': value, 'currency': currency};
  }
}

/// Telr Customer Model
class TelrCustomer {
  final String email;
  final String? phone;
  final TelrCustomerName name;
  final TelrCustomerAddress? address;

  const TelrCustomer({
    required this.email,
    this.phone,
    required this.name,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (phone != null) 'phone': phone,
      'name': name.toJson(),
      if (address != null) 'address': address!.toJson(),
    };
  }
}

/// Telr Customer Name
class TelrCustomerName {
  final String forenames;
  final String surname;

  const TelrCustomerName({required this.forenames, required this.surname});

  Map<String, dynamic> toJson() {
    return {'forenames': forenames, 'surname': surname};
  }
}

/// Telr Customer Address
class TelrCustomerAddress {
  final String line1;
  final String? line2;
  final String city;
  final String? region;
  final String country;

  const TelrCustomerAddress({
    required this.line1,
    this.line2,
    required this.city,
    this.region,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      if (line2 != null) 'line2': line2,
      'city': city,
      if (region != null) 'region': region,
      'country': country,
    };
  }
}

/// Telr Return URLs
class TelrReturnUrls {
  final String authorised;
  final String declined;
  final String cancelled;

  const TelrReturnUrls({
    required this.authorised,
    required this.declined,
    required this.cancelled,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorised': authorised,
      'declined': declined,
      'cancelled': cancelled,
    };
  }
}

/// Telr Create Session Response
class TelrCreateSessionResponse {
  final TelrOrderResponse order;
  final String? error;
  final String? tokenUrl;
  final String? orderUrl;

  const TelrCreateSessionResponse({
    required this.order,
    this.error,
    this.tokenUrl,
    this.orderUrl,
  });

  factory TelrCreateSessionResponse.fromJson(Map<String, dynamic> json) {
    // Parse links if available
    String? tokenUrl;
    String? orderUrl;

    if (json.containsKey('_links')) {
      final links = json['_links'];
      if (links is Map) {
        if (links.containsKey('auth') && links['auth'] is Map) {
          tokenUrl = links['auth']['href']?.toString();
        }
        if (links.containsKey('self') && links['self'] is Map) {
          orderUrl = links['self']['href']?.toString();
        }
      }
    }

    return TelrCreateSessionResponse(
      order: TelrOrderResponse.fromJson(json['order'] ?? {}),
      error: json['error']?['message']?.toString(),
      tokenUrl: tokenUrl,
      orderUrl: orderUrl,
    );
  }
}

/// Telr Order Response
class TelrOrderResponse {
  final String? ref;
  final String? url;

  const TelrOrderResponse({this.ref, this.url});

  factory TelrOrderResponse.fromJson(Map<String, dynamic> json) {
    return TelrOrderResponse(
      ref: json['ref']?.toString(),
      url: json['url']?.toString(),
    );
  }
}

/// Telr Check Status Request
class TelrCheckStatusRequest {
  final String method;
  final String store;
  final String authkey;
  final TelrOrderRef order;

  const TelrCheckStatusRequest({
    this.method = 'check',
    required this.store,
    required this.authkey,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'store': store,
      'authkey': authkey,
      'order': order.toJson(),
    };
  }
}

/// Telr Order Reference
class TelrOrderRef {
  final String ref;

  const TelrOrderRef({required this.ref});

  Map<String, dynamic> toJson() {
    return {'ref': ref};
  }
}

/// Telr Check Status Response
class TelrCheckStatusResponse {
  final TelrOrderStatus order;
  final String? error;

  const TelrCheckStatusResponse({required this.order, this.error});

  factory TelrCheckStatusResponse.fromJson(Map<String, dynamic> json) {
    return TelrCheckStatusResponse(
      order: TelrOrderStatus.fromJson(json['order'] ?? {}),
      error: json['error']?['message']?.toString(),
    );
  }
}

/// Telr Order Status
class TelrOrderStatus {
  final String? ref;
  final String? cartid;
  final String? status; // A = Authorised, H = Hold, D = Declined, C = Cancelled
  final String? code;
  final String? message;
  final TelrTransaction? transaction;

  const TelrOrderStatus({
    this.ref,
    this.cartid,
    this.status,
    this.code,
    this.message,
    this.transaction,
  });

  factory TelrOrderStatus.fromJson(Map<String, dynamic> json) {
    return TelrOrderStatus(
      ref: json['ref']?.toString(),
      cartid: json['cartid']?.toString(),
      status: json['status']?.toString(),
      code: json['code']?.toString(),
      message: json['message']?.toString(),
      transaction: json['transaction'] != null
          ? TelrTransaction.fromJson(json['transaction'])
          : null,
    );
  }

  bool get isAuthorised => status == 'A';
  bool get isDeclined => status == 'D';
  bool get isCancelled => status == 'C';
}

/// Telr Transaction Details
class TelrTransaction {
  final String? ref;
  final String? type;
  final String? status;

  const TelrTransaction({this.ref, this.type, this.status});

  factory TelrTransaction.fromJson(Map<String, dynamic> json) {
    return TelrTransaction(
      ref: json['ref']?.toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
