import 'package:flutter/material.dart';
import '../models/bed.dart';
import '../services/bed_service.dart';

class BedListScreen extends StatefulWidget {
  const BedListScreen({super.key});

  @override
  State<BedListScreen> createState() => _BedListScreenState();
}

class _BedListScreenState extends State<BedListScreen> {
  final BedService _bedService = BedService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Beds')),
      body: FutureBuilder<List<Bed>>(
        future: _bedService.getAllBeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No beds found.'));
          }

          final beds = snapshot.data!;
          return ListView.builder(
            itemCount: beds.length,
            itemBuilder: (context, index) {
              final bed = beds[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: bed.occupied ? Colors.redAccent : Colors.green,
                    child: Icon(
                      bed.occupied ? Icons.bed : Icons.bed_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Ward: ${bed.ward}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🛏️ Bed Number: ${bed.bedNumber}', style: const TextStyle(fontSize: 14)),
                        Text('💰 Fee/Day: ₹${bed.feePerDay.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
                        Text(
                          '📌 Status: ${bed.occupied ? 'Occupied' : 'Available'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: bed.occupied ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete this bed?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await _bedService.deleteBed(bed.id!);
                        setState(() {});
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Bed screen (you can replace with the actual screen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BedListScreen(), // Replace with AddBedScreen()
            ),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
