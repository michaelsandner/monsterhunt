import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';

class PropertyInputForm extends StatefulWidget {
  const PropertyInputForm({required this.monster, super.key});
  final Monster monster;

  @override
  State<PropertyInputForm> createState() => _PropertyInputFormState();
}

class _PropertyInputFormState extends State<PropertyInputForm> {
  late MonsterProperty selectedProperty;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedProperty = widget.monster.properties.first;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final input = double.tryParse(_inputController.text);

    if (input == null || input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib einen gültigen Wert ein!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<MonsterCubit>().reducePropertyValue(
      selectedProperty.name,
      input,
    );

    _inputController.clear();
  }

  @override
  Widget build(final BuildContext context) => Card(
    elevation: 4,
    color: Colors.amber.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Fortschritt eintragen',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDropdown(),
          const SizedBox(height: 16),
          _buildTextField(),
          const SizedBox(height: 16),
          _buildSubmitButton(),
        ],
      ),
    ),
  );

  Widget _buildDropdown() => DropdownButtonFormField<MonsterProperty>(
    initialValue: selectedProperty,
    decoration: const InputDecoration(
      labelText: 'Aktivität auswählen',
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    ),
    items: widget.monster.properties
        .map(
          (final property) => DropdownMenuItem(
            value: property,
            child: Text('${property.name} (${property.unit})'),
          ),
        )
        .toList(),
    onChanged: (final value) {
      if (value != null) {
        setState(() {
          selectedProperty = value;
        });
      }
    },
  );

  Widget _buildTextField() => TextField(
    controller: _inputController,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: 'Wert in ${selectedProperty.unit}',
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      suffixText: selectedProperty.unit,
    ),
    onSubmitted: (_) => _handleSubmit(),
  );

  Widget _buildSubmitButton() => ElevatedButton.icon(
    onPressed: widget.monster.isDefeated ? null : _handleSubmit,
    icon: const Icon(Icons.check),
    label: const Text('Eintragen'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(16),
      textStyle: const TextStyle(fontSize: 18),
    ),
  );
}
