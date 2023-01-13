import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mikhuy/outstanding_reservations/cubit/outstanding_reservations_cubit.dart';
import 'package:mikhuy/reservation_detail/reservation_detail.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:models/models.dart';

class ReservationsList extends StatelessWidget {
  const ReservationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations =
        context.select<OutstandingReservationsCubit, List<Reservation>>(
      (value) => value.state.reservations,
    );

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final reservation = reservations[index];

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<bool>(
              builder: (context) => ReservationDetailPage(reservation),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reserva en',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        reservation.establishmentName,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reservation.productsCount} Productos por recoger',
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.flushOrange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '''Hasta ${DateFormat('dd/MM/yyyy H:m').format(reservation.expirationDate!)} hrs.''',
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Bs. ${reservation.total}',
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
