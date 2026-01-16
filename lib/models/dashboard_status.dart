class DashboardStats {
  final int totalAdmissions;
  final int totalDischarges;
  final double totalRevenue;
  final int totalBeds;
  final int occupiedBeds;

  DashboardStats({
    required this.totalAdmissions,
    required this.totalDischarges,
    required this.totalRevenue,
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalAdmissions: json['totalAdmissions'] ?? 0,
      totalDischarges: json['totalDischarges'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalBeds: json['totalBeds'] ?? 0,
      occupiedBeds: json['occupiedBeds'] ?? 0,
    );
  }
}
