import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/parking_spot_model.dart';
import '../../../presentation/blocs/map/map_bloc.dart';
import '../../../presentation/blocs/map/map_event.dart';
import '../../../presentation/blocs/map/map_state.dart';
import '../../widgets/custom_button.dart';

class ParkingManagementScreen extends StatelessWidget {
  const ParkingManagementScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Parking Spot"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newSpot = ParkingSpotModel(
                id: "", // سيُولّد لاحقًا
                name: nameController.text,
                address: addressController.text,
                pricePerHour: double.tryParse(priceController.text) ?? 0.0,
                latitude: 0.0,
                longitude: 0.0,
                isAvailable: true,
                createdAt: DateTime.now(),
              );
              context.read<MapBloc>().add(AddParkingSpot(parkingSpot: newSpot));
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<MapBloc>().add(FetchParkingSpots());

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Parking Spots')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapLoaded && state.parkingSpots.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.parkingSpots.length,
              itemBuilder: (context, index) {
                final spot = state.parkingSpots[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.local_parking),
                    title: Text(spot.name),
                    subtitle: Text("${spot.address}\n\$${spot.pricePerHour.toStringAsFixed(2)}"),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<MapBloc>().add(DeleteParkingSpot(parkingSpotId: spot.id));
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text("No parking spots available."));
        },
      ),
    );
  }
}
