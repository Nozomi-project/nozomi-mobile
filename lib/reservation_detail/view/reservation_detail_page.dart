import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/reservation_detail/reservation_detail.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/shared/shared.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:models/models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationDetailPage extends StatelessWidget {
  ReservationDetailPage(Reservation reservation, {super.key})
      : _cubit = ReservationDetailCubit(reservation)
          ..listenReservation()
          ..getReservationDetails();

  final ReservationDetailCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de reserva'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: _cubit,
                    child: const _ConfirmReservationCancelationAlertDialog(),
                  );
                },
              );
            },
            icon: const Icon(MdiIcons.cancel),
            color: AppColors.grey.shade700,
          )
        ],
      ),
      body: BlocProvider<ReservationDetailCubit>.value(
        value: _cubit,
        child: const _ReservationDetailView(),
      ),
    );
  }
}

class _ConfirmReservationCancelationAlertDialog extends StatelessWidget {
  const _ConfirmReservationCancelationAlertDialog();

  @override
  Widget build(BuildContext context) {
    return ConfirmationAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Estas seguro de\ncancelar tu reserva?',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta accion no se\npuede deshacer 👀',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      confirmButtonContent: const Text('Volver'),
      onConfirmPressed: () => Navigator.of(context).pop(),
      cancelButtonContent: const Text('Confirmar'),
      onCancelPressed: () async {
        Navigator.of(context).pop();
        await context.read<ReservationDetailCubit>().cancelReservation();
      },
    );
  }
}

class _ReservationDetailView extends StatelessWidget {
  const _ReservationDetailView();

  @override
  Widget build(BuildContext context) {
    final reservation = context.select<ReservationDetailCubit, Reservation>(
      (value) => value.state.reservation,
    );

    return BlocListener<ReservationDetailCubit, ReservationDetailState>(
      listenWhen: (previous, current) =>
          previous.reservation.status != current.reservation.status,
      listener: (context, state) {
        if (state.reservation.status == ReservationStatus.canceled) {
          showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tu reserva expiró o fue\ncancelada 👀',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          var count = 0;
                          Navigator.popUntil(context, (route) {
                            return count++ == 2;
                          });
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state.reservation.status == ReservationStatus.delivered) {
          showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tu reserva fué entregada! 🎉',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recoger en'),
              Text(
                reservation.establishmentName,
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    MdiIcons.mapMarkerOutline,
                    size: 24,
                  ),
                  Text(reservation.establishmentAddress),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueMalibu.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Reservado el'),
                        Text(
                          DateFormat('dd/MM/yyyy H:m')
                              .format(reservation.dateIssued!),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueMalibu.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Recoger hasta'),
                        Text(
                          DateFormat('dd/MM/yyyy H:m')
                              .format(reservation.expirationDate!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Recoge tu pedido con el QR de este ticket :)'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QrImage(
                  data: reservation.id,
                ),
              ),
              BlocBuilder<ReservationDetailCubit, ReservationDetailState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.completed) {
                    return DetailTable(reservation: reservation);
                  }

                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailTable extends StatelessWidget {
  const DetailTable({required this.reservation, super.key});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 24,
      columns: const [
        DataColumn(label: Text('Cant.')),
        DataColumn(label: Text('Producto')),
        DataColumn(label: Text('c/u')),
        DataColumn(label: Text('Subtotal')),
      ],
      rows: reservation.details.map((detail) {
        return DataRow(
          cells: [
            DataCell(Text(detail.quantity.toString())),
            DataCell(
              SizedBox(
                width: 100,
                child: Text(
                  detail.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DataCell(Text('Bs.${detail.unitPrice}')),
            DataCell(Text('Bs.${detail.subtotal}')),
          ],
        );
      }).toList()
        ..add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(
                Text(
                  'Bs.${reservation.total}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
