import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'establishment_list_state.dart';

class EstablishmentListCubit extends Cubit<EstablishmentListState> {
  EstablishmentListCubit() : super(const EstablishmentListState());

  StreamSubscription<QuerySnapshot<Establishment>>? _establishmentsSub;
  List<StreamSubscription<QuerySnapshot<Product>>>? _productSubs;
  final Location _location = Location();
  final _establishmentsRef = FirebaseFirestore.instance
      .collection('establishment')
      .withConverter<Establishment>(
        fromFirestore: (snapshots, _) => Establishment.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (establishments, _) => establishments.toJson(),
      );

  Future<void> verifyLocationPermission() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }

    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      final locationData = await _location.getLocation();
      emit(
        state.copyWith(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ),
      );
    }
  }

  Future<void> getEstablisments() async {
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));
    try {
      await _establishmentsSub?.cancel();
      _productSubs?.forEach((element) async {
        await element.cancel();
      });
      _productSubs = [];

      _establishmentsSub = _establishmentsRef.snapshots().listen(
        (event) async {
          final establishmentsTemp = event.docs.map((e) => e.data()).toList();
          final establishments = <Establishment>[];

          for (final establishment in establishmentsTemp) {
            var products = <Product>[];
            final productsRef = _getProductsReference(establishment.id);
            final productsSub = productsRef.snapshots().listen((event) {
              products = event.docs
                  .map((e) => e.data())
                  .where((element) => element.stock > 0)
                  .toList();

              final mustAdd = products.isNotEmpty &&
                  !establishments
                      .any((element) => element.id == establishment.id);

              final mustUpdate = products.isNotEmpty &&
                  establishments
                      .any((element) => element.id == establishment.id);

              if (mustAdd) {
                establishments.add(
                  establishment.copyWith(products: products),
                );

                emit(
                  state.copyWith(
                    establishments: establishments,
                    requestStatus: RequestStatus.completed,
                  ),
                );
              } else if (mustUpdate) {
                final establishmentsUpdated = establishments
                    .where((element) => element.id != establishment.id)
                    .toList()
                  ..add(establishment.copyWith(products: products));

                establishments
                  ..clear()
                  ..addAll(establishmentsUpdated);

                emit(
                  state.copyWith(
                    establishments: establishmentsUpdated,
                    requestStatus: RequestStatus.completed,
                  ),
                );
              }
            });

            _productSubs?.add(productsSub);
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }

  CollectionReference<Product> _getProductsReference(
    String establishmentId,
  ) {
    return _establishmentsRef
        .doc(establishmentId)
        .collection('product')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) =>
              Product.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (product, _) => product.toJson(),
        );
  }

  Future<void> searchEstablishments(String criteria) async {
    if (criteria.isEmpty) return;
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));

    try {
      await _establishmentsSub?.cancel();
      _productSubs?.forEach((element) async {
        await element.cancel();
      });
      _productSubs?.clear();

      _establishmentsRef.snapshots().listen(
        (event) async {
          final establishmentsTemp = event.docs.map((e) => e.data()).toList();
          final establishments = <Establishment>[];

          for (final establishment in establishmentsTemp) {
            var products = <Product>[];
            final productsRef = _getProductsReference(establishment.id);
            _productSubs?.add(
              productsRef.snapshots().listen((event) {
                products = event.docs
                    .map((e) => e.data())
                    .where((element) => element.stock > 0)
                    .toList();
              }),
            );

            if (products.isEmpty) continue;

            if (establishment.name
                    .toLowerCase()
                    .contains(criteria.toLowerCase()) ||
                products.any(
                  (element) =>
                      element.name
                          .toLowerCase()
                          .contains(criteria.toLowerCase()) &&
                      element.stock > 0,
                )) {
              establishments.add(establishment.copyWith(products: products));
            }
          }

          emit(
            state.copyWith(
              establishments: establishments,
              requestStatus: RequestStatus.completed,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }
}
