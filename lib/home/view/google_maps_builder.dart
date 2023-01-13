import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:mikhuy/establishment_detail/view/establishment_detail_page.dart';
import 'package:mikhuy/home/cubit/establishment_list_cubit.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:models/establishment.dart';

class GoogleMapsBuilder extends StatelessWidget {
  const GoogleMapsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstablishmentListCubit, EstablishmentListState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.failed) {
          return const Center(
            child: Text('Ups! ha ocurrido un error inesperado'),
          );
        }

        if (state.requestStatus == RequestStatus.completed) {
          return const _GoogleMapsView();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _GoogleMapsView extends StatefulWidget {
  const _GoogleMapsView();

  @override
  State<_GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<_GoogleMapsView> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final cameraPosition = CameraPosition(
      target: LatLng(
        context.select<EstablishmentListCubit, double>(
          (value) => value.state.latitude,
        ),
        context.select<EstablishmentListCubit, double>(
          (value) => value.state.longitude,
        ),
      ),
      zoom: 13,
    );

    final establishments =
        context.watch<EstablishmentListCubit>().state.establishments;

    return BlocListener<EstablishmentListCubit, EstablishmentListState>(
      listener: (context, state) async {
        final controller = await _controller.future;
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      },
      child: FutureBuilder(
        future: _getmarkers(establishments),
        builder: (context, AsyncSnapshot<Set<Marker>> snapshot) {
          if (snapshot.hasData) {
            final markers = snapshot.data!;
            return GoogleMap(
              markers: markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: cameraPosition,
              myLocationEnabled: true,
              padding: const EdgeInsets.only(top: 150),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Set<Marker>> _getmarkers(List<Establishment> establishments) async {
    final markers = <Marker>{};
    for (final e in establishments) {
      await markers.addLabelMarker(
        LabelMarker(
          label: e.name.length > 21 ? e.name.substring(0, 22) : e.name,
          markerId: MarkerId(e.id),
          position: LatLng(e.latitude, e.longitude),
          backgroundColor: AppColors.flushOrange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => EstablishmentDetailPage(e),
              ),
            );
          },
        ),
      );
    }

    return markers;
  }
}
