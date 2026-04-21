/// One parsed receipt position (maps to [AddBillItemRequest] on import).
class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  final String name;
  final num price;
  final num quantity;
}
