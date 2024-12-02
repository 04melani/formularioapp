import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        hintColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.orange[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.purple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.purple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.purple),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.purple[900]),
          labelLarge: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.orangeAccent,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaNacimientoController = TextEditingController();

  String? _cedula, _nombres, _apellidos, _estadoCivil;
  DateTime? _fechaNacimiento;
  int? _edad;
  String _genero = 'Masculino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Registro de Usuario',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildCard(
                    child: _buildRow('Cédula', Icons.credit_card, (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su cédula';
                      }
                      return null;
                    }, (value) {
                      _cedula = value;
                    }),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildRow('Nombres', Icons.person, (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese sus nombres';
                      }
                      return null;
                    }, (value) {
                      _nombres = value;
                    }),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildRow('Apellidos', Icons.person_outline, (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese sus apellidos';
                      }
                      return null;
                    }, (value) {
                      _apellidos = value;
                    }),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildDatePickerRow(
                      'Fecha de nacimiento',
                      Icons.calendar_today,
                      _fechaNacimientoController,
                      (pickedDate) {
                        setState(() {
                          _fechaNacimiento = pickedDate;
                          _fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          _edad = DateTime.now().year - pickedDate.year;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildRow('Edad', Icons.cake, null, null, readOnly: true, controller: TextEditingController(text: _edad != null ? _edad.toString() : '')),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildDropdownRow('Género', _genero, ['Masculino', 'Femenino', 'Otro'], (newValue) {
                      setState(() {
                        _genero = newValue!;
                      });
                    }),
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    child: _buildDropdownRow('Estado Civil', _estadoCivil, ['Soltero', 'Casado', 'Divorciado', 'Viudo'], (newValue) {
                      setState(() {
                        _estadoCivil = newValue!;
                      });
                    }),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Aquí puedes manejar la acción de salir.
                        },
                        child: Text('Salir'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Aquí puedes manejar el envío de los datos.
                          }
                        },
                        child: Text('Siguiente'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget _buildRow(
      String label,
      IconData icon,
      String? Function(String?)? validator,
      void Function(String?)? onSaved,
      {bool readOnly = false,
      TextEditingController? controller}) {
    return Row(
      children: [
        Container(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.purple),
          ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
            ),
            validator: validator,
            onSaved: onSaved,
            readOnly: readOnly,
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerRow(
      String label,
      IconData icon,
      TextEditingController controller,
      Function(DateTime) onDateSelected) {
    return Row(
      children: [
        Container(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.purple),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                onDateSelected(pickedDate);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(
      String label,
      String? value,
      List<String> items,
      Function(String?)? onChanged) {
    return Row(
      children: [
        Container(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.purple),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.arrow_drop_down),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
