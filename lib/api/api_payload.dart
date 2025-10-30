import 'dart:convert';


class ApiPayload {
  static ApiPayload inst = ApiPayload();



  Map<String, dynamic> stockTransferPaylod({
    required String skuId,
    required String outletFrom,
    required String outletTo,
    required int quantity,
  }) {
    return {
      "skuId": skuId,
      "outletFrom": outletFrom,
      "outletTo": outletTo,
      "quantity": quantity,
    };
  }

  Map<String, dynamic> aiChatPayload({
    required String query,
    required String sessionId,
  }) {
    return {
      "query": query,
      "sellerId": sessionId,
      "preferences": {
        "responseLength": "brief",
        "includeExamples": true,
        "language": "en",
      },
    };
  }

  Map<String, dynamic> createPurchaseOrderParam({
    required List<String> poIds,
    required String type,
  }) {
    return {"poIds": poIds, "type": type};
  }
}


