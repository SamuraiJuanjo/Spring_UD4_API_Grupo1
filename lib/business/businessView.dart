import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spring_ud4_grupo1_app/business/businessCards.dart';
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/ServicioModel.dart';

import '../services/businessService.dart';
import '../services/proFamilyService.dart';

class BusinessView extends StatefulWidget {
  final String token;

  BusinessView({Key? key, required this.token}) : super(key: key);

  @override
  _BusinessViewState createState() => _BusinessViewState();
}

class _BusinessViewState extends State<BusinessView> {
  late BusinessService _businessService;
  late ProFamilyService
      _proFamilyService; // Servicio para las familias profesionales
  List<ServicioModel> _services = [];
  List<ProFamilyModel> _profesionalFamilies = [];
  ProFamilyModel? _selectedProfesionalFamily;

  @override
  void initState() {
    super.initState();
    _businessService = BusinessService();
    _proFamilyService = ProFamilyService();
    _loadProFamilies();
  }

  void _loadProFamilies() async {
    final families = await _proFamilyService.getProfesionalFamilies(
        'Bearer${widget.token}'); // Asume que tienes este método
    setState(() {
      _profesionalFamilies = families;
    });
  }

  void _businessServices() async {
    try {
      final services = await _businessService.getBusinessServices(widget.token);
      if (services != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: services),
          ),
        );
        print("$services");
      } else {
        // Mostrar mensaje de error si no hay servicios
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No se pudieron recuperar los servicios")),
        );
      }
    } catch (e) {
      // Manejar cualquier otro error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _businessSpecificServices(int serviceId) async {
    try {
      final service = await _businessService.getBusinessSpecificService(
          widget.token, serviceId);
      if (service != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessCards(servicios: [service]),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo recuperar el servicio")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showSpecificServicesPanel() async {
    final services = await _businessService.getBusinessServices(widget.token);
    if (services != null) {
      showDialog(
        context: context,
        builder: (BuildContext localContext) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(localContext).size.height * 0.5,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(services[index].title ?? "Sin título"),
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Usamos el context del builder
                            // Corregido para llamar al método con el contexto correcto y el ID de servicio
                            _showSpecificServiceDetailsPanel(
                                services[index].id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudieron cargar los servicios")),
      );
    }
  }

  void _showSpecificServiceDetailsPanel(int? serviceId) async {
    if (serviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID de servicio no válido")),
      );
      return;
    }

    final serviceDetails = await _businessService.getBusinessSpecificService(
        widget.token, serviceId);

    if (serviceDetails != null) {
      showDialog(
        context: context,
        builder: (BuildContext localContext) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Título: ${serviceDetails.title}"),
                  SizedBox(height: 10),
                  Text("Descripción: ${serviceDetails.description}"),
                  // Agrega aquí más detalles que quieras mostrar
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo cargar el detalle del servicio")),
      );
    }
  }

  void _showCreateServicePanel() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create New Service"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButton<ProFamilyModel>(
                  value: _selectedProfesionalFamily,
                  hint: Text("Select Professional Family"),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProfesionalFamily = newValue!;
                    });
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    _showCreateServicePanel(); // Vuelve a mostrar el diálogo para reflejar el cambio
                  },
                  items: _profesionalFamilies.map((ProFamilyModel family) {
                    return DropdownMenuItem<ProFamilyModel>(
                      value: family,
                      child: Text(family.name ?? 'Nombre no disponible'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Accept'),
              onPressed: () async {
                try {
                  final business = await _businessService
                      .obtenerEmpresaLogueada(widget.token);
                  final newService = ServicioModel(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    businessId: business,
                    profesionalFamilyId: _selectedProfesionalFamily,
                  );
                  final createdService = await _businessService.createService(
                      widget.token, newService);
                  Navigator.pop(
                      context); // Cierra el diálogo después de la operación exitosa
                } catch (e) {
                  Navigator.pop(
                      context); // También cierra el diálogo si hay un error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Page'),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButtonWithIconAndText(
                    Icons.add,
                    'Crear nuevo servicio por parte de la empresa logueada',
                    () => _showCreateServicePanel(),
                  ),
                  _buildButtonWithIconAndText(
                      Icons.search,
                      'Recuperar un determinado servicio de la empresa logueada',
                      _showSpecificServicesPanel),
                  _buildButtonWithIconAndText(
                    Icons.list,
                    'Recuperar todos los servicios de la empresa logueada',
                    _businessServices,
                  ),
                  _buildButtonWithIconAndText(
                      Icons.edit,
                      'Actualizar un servicio de la empresa logueada',
                      () => {}),
                  _buildButtonWithIconAndText(Icons.delete,
                      'Eliminar un servicio de la empresa logueada', () => {}),
                  _buildButtonWithIconAndText(
                      Icons.filter_list,
                      'Recuperar los servicios de una empresa filtrando por familia profesional',
                      () => {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithIconAndText(
      IconData icon, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 30, color: Colors.white),
            onPressed: onPressed,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
