import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MiAppFitness());
}

class MiAppFitness extends StatelessWidget {
  const MiAppFitness({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEDF FIT',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F0EB),
      ),
      home: const PantallaFitness(),
    );
  }
}

class Deporte {
  final String nombre;
  final IconData icono;
  final double met;
  final double factorVelocidad;

  Deporte(this.nombre, this.icono, this.met, this.factorVelocidad);
}

class PantallaFitness extends StatefulWidget {
  const PantallaFitness({super.key});

  @override
  State<PantallaFitness> createState() => _PantallaFitnessState();
}

class _PantallaFitnessState extends State<PantallaFitness> {
  final Color azulMarino = const Color(0xFF1B2A3A);
  final Color dorado = const Color(0xFFC59B27);
  final Color tarjetaCrema = const Color(0xFFEBE3D8);
  final Color textoOscuro = const Color(0xFF1B2A3A);

  final List<Deporte> deportes = [
    Deporte('Caminar', Icons.directions_walk, 3.5, 4.5),
    Deporte('Correr', Icons.directions_run, 9.8, 10.0),
    Deporte('Ciclismo', Icons.directions_bike, 7.5, 20.0),
    Deporte('Natación', Icons.pool, 8.0, 3.0),
    Deporte('Mar Abierto', Icons.water, 9.0, 2.5),
    Deporte('Escalar', Icons.terrain, 8.0, 2.0),
    Deporte('Senderismo', Icons.hiking, 6.0, 4.0),
    Deporte('Triatlón', Icons.fitness_center, 11.5, 15.0),
    Deporte('Remo', Icons.rowing, 7.0, 8.0),
  ];

  late Deporte deporteSeleccionado;
  
  double pesoUsuarioKg = 70.0;
  int pasos = 0;
  double calorias = 0.0;
  double distanciaKm = 0.0;
  
  Timer? _timer;
  int segundosTranscurridos = 0;
  bool entrenando = false;

  @override
  void initState() {
    super.initState();
    deporteSeleccionado = deportes[0];
  }

  void _actualizarEntrenamiento() {
    if (!entrenando) return;
    setState(() {
      segundosTranscurridos++;
      double caloriasPorMinuto = (deporteSeleccionado.met * 3.5 * pesoUsuarioKg) / 200;
      calorias += caloriasPorMinuto / 60;
      distanciaKm += (deporteSeleccionado.factorVelocidad / 3600);

      if (['Caminar', 'Correr', 'Senderismo', 'Escalar'].contains(deporteSeleccionado.nombre)) {
        pasos += 2; 
      }
    });
  }

  void _alternarEntrenamiento() {
    setState(() { entrenando = !entrenando; });
    if (entrenando) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _actualizarEntrenamiento();
      });
    } else {
      _timer?.cancel();
    }
  }

  void _reiniciar() {
    _timer?.cancel();
    setState(() {
      pasos = 0; calorias = 0.0; distanciaKm = 0.0; segundosTranscurridos = 0; entrenando = false;
    });
  }

  String _formatearTiempo(int segundosTotales) {
    int minutos = segundosTotales ~/ 60;
    int segundos = segundosTotales % 60;
    String minStr = minutos < 10 ? '0$minutos' : '$minutos';
    String segStr = segundos < 10 ? '0$segundos' : '$segundos';
    return "$minStr:$segStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulMarino,
        elevation: 4,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LOGO A UN LADO (IZQUIERDA)
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: tarjetaCrema,
                shape: BoxShape.circle,
                border: Border.all(color: dorado, width: 1.5),
              ),
              child: Center(
                child: Text(
                  'Df',
                  style: TextStyle(
                    color: azulMarino,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            
            // TITULO CENTRADO
            Text(
              'DEDF FIT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: tarjetaCrema,
                fontSize: 20,
              ),
            ),
            
            const SizedBox(width: 38), // Espaciador para equilibrar el título
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // SELECTOR DE DEPORTE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: tarjetaCrema,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: dorado, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Deporte>(
                  value: deporteSeleccionado,
                  dropdownColor: tarjetaCrema,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: dorado),
                  onChanged: entrenando ? null : (Deporte? nuevoDeporte) {
                    if (nuevoDeporte != null) setState(() { deporteSeleccionado = nuevoDeporte; });
                  },
                  items: deportes.map((Deporte deporte) {
                    return DropdownMenuItem<Deporte>(
                      value: deporte,
                      child: Row(
                        children: [
                          Icon(deporte.icono, color: azulMarino),
                          const SizedBox(width: 15),
                          Text(deporte.nombre, style: TextStyle(color: textoOscuro, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // DIBUJO/ICONO DEL DEPORTE SELECCIONADO (EN GRANDE AL CENTRO)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: tarjetaCrema,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dorado, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      deporteSeleccionado.icono,
                      size: 110,
                      color: azulMarino,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      deporteSeleccionado.nombre.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: azulMarino,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // MÉTRICAS
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _crearTarjetaMetrica('Calorías', '${calorias.toStringAsFixed(1)} kcal', Icons.local_fire_department, dorado),
                _crearTarjetaMetrica('Distancia', '${distanciaKm.toStringAsFixed(2)} km', Icons.map, azulMarino),
                _crearTarjetaMetrica('Pasos', '$pasos', Icons.directions_walk, azulMarino),
                _crearTarjetaMetrica('Tiempo', _formatearTiempo(segundosTranscurridos), Icons.timer, dorado),
              ],
            ),
            const SizedBox(height: 20),

            // BOTONES DE CONTROL
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _alternarEntrenamiento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: entrenando ? const Color(0xFFA12C2C) : azulMarino,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: dorado, width: 1.5),
                      ),
                    ),
                    child: Text(
                      entrenando ? 'PAUSAR' : 'INICIAR',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tarjetaCrema, letterSpacing: 1.5),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: _reiniciar,
                  icon: Icon(Icons.refresh, color: azulMarino),
                  style: IconButton.styleFrom(
                    backgroundColor: tarjetaCrema,
                    padding: const EdgeInsets.all(18),
                    side: BorderSide(color: dorado, width: 1.5),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTarjetaMetrica(String titulo, String valor, IconData icono, Color colorIcono) {
    return Container(
      width: 135,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tarjetaCrema,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: dorado.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icono, color: colorIcono, size: 22),
          const SizedBox(height: 4),
          Text(valor, style: TextStyle(color: textoOscuro, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(titulo, style: TextStyle(color: azulMarino.withValues(alpha: 0.7), fontSize: 10)),
        ],
      ),
    );
  }
}
