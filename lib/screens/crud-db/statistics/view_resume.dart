import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cw2/database/db_functions.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:cw2/widgets/chartPie.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  int _valorNetoWidget = 0;
  String _fechaTextWidget = '';
  int _costumerQuantityWidget = 0;
  String _besHourWidget = '';
  Map<String, double> _datos = {'sin ventas': 0};
  String _bestProduct = 'Producto';
  static const double fontValue = 25;
  static const double fonSubtitle = 15;
  static const double sizeIcon = 50;
  static const double heigthCard = 100;
  static const double widthCard = 350;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buttonCaledar(),
          _valorNetoCard(),
          bestProductCard(),
          _horaPicoCostumerCard(),
          Container(
            color: const Color.fromARGB(100, 53, 66, 72),
            child: _chartPieCard(),
          )
        ],
      ),
    );
  }

  void _getValueText(
    List<DateTime?> values,
  ) async {
    //Obtenemos y formateamos la fecha
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null);
    String finalValueText = DateFormat('yyyy-M-d')
        .format(valueText!)
        .toString()
        .replaceAll('00:00:00.000', '');

    //Ejecutamos consulta previamente
    int idSearch = await getIdFechaSearch(finalValueText);
    int valorNetoUpdate = await getNetValue(idSearch);
    int costumerQuantityupdate = await getQuantityCostumers(idSearch);
    String bestHour = await getBestHour(idSearch);
    if (bestHour.isNotEmpty) {
      bestHour = '$bestHour - ${int.parse(bestHour) + 1}';
    }
    await getProductsSales(idSearch);

    //Actulizamos el estado de los datos con la consulta previa
    setState(() {
      _valorNetoWidget = valorNetoUpdate;
      _fechaTextWidget = finalValueText;
      _costumerQuantityWidget = costumerQuantityupdate;
      _besHourWidget = bestHour;
      _datos = pdtStadictsList.value;
      _bestProduct = productoMasVendido();
    });
  }

  //Obtenemos el producto mas vendido
  String productoMasVendido() {
    String productoMasVendido = '';
    double maxVentas = double.negativeInfinity;

    _datos.forEach((producto, ventas) {
      if (ventas > maxVentas) {
        maxVentas = ventas;
        productoMasVendido = producto;
      }
    });

    return productoMasVendido;
  }

  _buttonCaledar() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: 'Selecciona la fecha a consultar',
            icon: const Icon(Icons.calendar_month, color: Colors.amberAccent),
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                //Configacion calendario
                config: CalendarDatePicker2WithActionButtonsConfig(
                  calendarViewScrollPhysics:
                      const NeverScrollableScrollPhysics(),
                  dayTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  calendarType: CalendarDatePicker2Type.single,
                  selectedDayHighlightColor: Colors.amberAccent,
                  closeDialogOnCancelTapped: true,
                  firstDayOfWeek: 1,
                  weekdayLabelTextStyle: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  controlsTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  centerAlignModePicker: true,
                  customModePickerIcon: const SizedBox(),
                  selectedDayTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)
                      .copyWith(color: Colors.white),
                  dayTextStylePredicate: ({required date}) {
                    TextStyle? textStyle;
                    if (date.weekday == DateTime.saturday ||
                        date.weekday == DateTime.sunday) {
                      textStyle = TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w600);
                    }
                    return textStyle;
                  },
                  dayBuilder: ({
                    required date,
                    textStyle,
                    decoration,
                    isSelected,
                    isDisabled,
                    isToday,
                  }) {
                    Widget? dayWidget;
                    if (date.day % 3 == 0 && date.day % 9 != 0) {
                      dayWidget = Container(
                        decoration: decoration,
                        child: Center(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Text(
                                MaterialLocalizations.of(context)
                                    .formatDecimal(date.day),
                                style: textStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 27.5),
                                child: Container(
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isSelected == true
                                        ? Colors.pink
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return dayWidget;
                  },
                  yearBuilder: ({
                    required year,
                    decoration,
                    isCurrentYear,
                    isDisabled,
                    isSelected,
                    textStyle,
                  }) {
                    return Center(
                      child: Container(
                        decoration: decoration,
                        height: 36,
                        width: 72,
                        child: Center(
                          child: Semantics(
                            selected: isSelected,
                            button: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  year.toString(),
                                  style: textStyle,
                                ),
                                if (isCurrentYear == true)
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(left: 5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                dialogSize: const Size(500, 525),
                borderRadius: BorderRadius.circular(15),
                //Valor incial o por defecto
                value: [
                  DateTime.now(),
                ],
                dialogBackgroundColor: Colors.black26,
              );
              if (values != null) {
                _getValueText(
                  values,
                );
              }
            },
          ),
          Text(_fechaTextWidget, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  _valorNetoCard() {
    //Formateamos a la moneda local
    var formatear = NumberFormat.simpleCurrency(decimalDigits: 0);

    return SizedBox(
      height: heigthCard,
      width: widthCard,
      child: Card(
        color: const Color.fromARGB(100, 53, 66, 72),
        child: Row(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money_rounded,
                  color: Color.fromRGBO(76, 175, 80, 1),
                  size: sizeIcon,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ventas Netas',
                  style:
                      TextStyle(color: Colors.white60, fontSize: fonSubtitle),
                ),
                Text(
                  formatear.format(_valorNetoWidget),
                  style:
                      const TextStyle(color: Colors.white, fontSize: fontValue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bestProductCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: heigthCard,
          width: widthCard,
          child: Card(
            color: const Color.fromARGB(100, 53, 66, 72),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 235, 59, 1),
                      size: sizeIcon,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mejor Producto',
                      style: TextStyle(
                          color: Colors.white60, fontSize: fonSubtitle),
                    ),
                    Text(
                      _bestProduct,
                      style: const TextStyle(
                          color: Colors.white, fontSize: fontValue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _horaPicoCostumerCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: heigthCard,
          width: widthCard / 2,
          child: Card(
            color: const Color.fromARGB(100, 53, 66, 72),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      color: Color.fromRGBO(244, 67, 54, 1),
                      size: sizeIcon,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Clientes',
                      style: TextStyle(
                          color: Colors.white60, fontSize: fonSubtitle),
                    ),
                    Text(
                      ' $_costumerQuantityWidget',
                      style: const TextStyle(
                          color: Colors.white, fontSize: fontValue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: heigthCard,
          width: widthCard / 2,
          child: Card(
            color: const Color.fromARGB(100, 53, 66, 72),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.safety_check,
                      color: Color.fromRGBO(33, 150, 243, 1),
                      size: sizeIcon,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hora Pico',
                      style: TextStyle(
                          color: Colors.white60, fontSize: fonSubtitle),
                    ),
                    Text(
                      _besHourWidget,
                      style: const TextStyle(
                          color: Colors.white, fontSize: fontValue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _chartPieCard() {
    return SizedBox(
      width: widthCard,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Card(
          color: const Color.fromARGB(255, 30, 34, 33),
          child: ChartPieWidget(dataMap: _datos),
        ),
      ),
    );
  }
}
