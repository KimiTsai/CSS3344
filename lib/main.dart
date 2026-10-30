import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Lab02App());
}

class Lab02App extends StatelessWidget {
  const Lab02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02HomePage(),
    );
  }
}

class Lab02HomePage extends StatefulWidget {
  const Lab02HomePage({super.key});

  @override
  State<Lab02HomePage> createState() => _Lab02HomePageState();
}

class _Lab02HomePageState extends State<Lab02HomePage> {
  DateTime? _selectedDate;
  String _selectedRole = 'Student';

  static const List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  Future<void> _selectMaterialDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showCupertinoDatePicker() {
    DateTime temporaryDate = _selectedDate ?? DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    setState(() => _selectedDate = temporaryDate);
                    Navigator.of(popupContext).pop();
                  },
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: temporaryDate,
                  minimumDate: DateTime(1950),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    temporaryDate = newDate;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoRolePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(),
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: _roles.indexOf(_selectedRole),
                  ),
                  itemExtent: 36,
                  onSelectedItemChanged: (int index) {
                    setState(() => _selectedRole = _roles[index]);
                  },
                  children: _roles
                      .map((role) => Center(child: Text(role)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionMessage(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action button tapped')),
    );
  }

  Widget _buildStudentSection() {
    return const StudentDetailsSection(
      fullName: 'TSAI KIEN PING',
      studentId: 'BCS23090012',
      goal: 'My goal is to be healthy always.',
      photoPath: 'assets/images/profile.jpeg',
    );
  }

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitleSection(
          name: 'Oeschinen Lake',
          location: 'Kandersteg, Switzerland',
          starCount: 41,
        ),
        const ImageSection(imagePath: 'assets/images/lake.jpg'),
        ActionButtonsSection(onAction: _showActionMessage),
        const TextSection(),
        PickerSection(
          selectedDate: _selectedDate,
          selectedRole: _selectedRole,
          roles: _roles,
          onMaterialDate: _selectMaterialDate,
          onCupertinoDate: _showCupertinoDatePicker,
          onRoleChanged: (value) {
            if (value != null) {
              setState(() => _selectedRole = value);
            }
          },
          onCupertinoRole: _showCupertinoRolePicker,
        ),
      ],
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      children: [
        _buildStudentSection(),
        _buildInformationSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(children: [_buildStudentSection()]),
        ),
        Expanded(
          child: ListView(children: [_buildInformationSection()]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }
}

// Lab 01 profile, extracted as a reusable widget for Exercise 2.1.
class StudentDetailsSection extends StatelessWidget {
  final String fullName;
  final String studentId;
  final String goal;
  final String photoPath;

  const StudentDetailsSection({
    super.key,
    required this.fullName,
    required this.studentId,
    required this.goal,
    required this.photoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.indigo,
                backgroundImage: AssetImage(photoPath),
              ),
              const SizedBox(height: 14),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 6),
              Text('Student ID: $studentId'),
              const Divider(height: 28),
              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                '"$goal"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
              // Exercise 2.1 expected output: location details within
              // the student profile Material Card, as on PDF page 3.
              const Divider(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Location Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const TitleSection(
                name: 'Hogwarts School of Witchcraft and Wizardry',
                location: 'Hogsmeade, Scotland',
                starCount: 41,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exercise 2.1: reusable Row + Expanded + Column layout.
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;
  final bool compact;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: compact
          ? const EdgeInsets.symmetric(vertical: 12)
          : const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: compact ? 14 : 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 180,
            color: Colors.indigo.shade50,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.landscape, size: 48, color: Colors.indigo),
                SizedBox(height: 8),
                Text('Add assets/images/lake.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  final ValueChanged<String> onAction;

  const ActionButtonsSection({
    super.key,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _action(Icons.call, 'CALL'),
          _action(Icons.near_me, 'ROUTE'),
          _action(Icons.share, 'SHARE'),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          onPressed: () => onAction(label),
          icon: Icon(icon, color: Colors.indigo),
        ),
        Text(label, style: const TextStyle(color: Colors.indigo)),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'This section demonstrates Flutter layout decomposition with '
            'reusable widgets, Rows, Columns, and responsive scrolling.',
        textAlign: TextAlign.justify,
      ),
    );
  }
}

// Lab 02 pickers: Material date, Cupertino date,
// Material dropdown, and Cupertino wheel picker.
class PickerSection extends StatelessWidget {
  final DateTime? selectedDate;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onMaterialDate;
  final VoidCallback onCupertinoDate;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onCupertinoRole;

  const PickerSection({
    super.key,
    required this.selectedDate,
    required this.selectedRole,
    required this.roles,
    required this.onMaterialDate,
    required this.onCupertinoDate,
    required this.onRoleChanged,
    required this.onCupertinoRole,
  });

  String get _dateLabel {
    final date = selectedDate;
    if (date == null) return 'Not selected';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Interactive Pickers (Lab 2.2)',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              Text('Selected Date: $_dateLabel'),
              Text('Selected Role: $selectedRole'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onMaterialDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Material Date Picker'),
              ),
              OutlinedButton.icon(
                onPressed: onCupertinoDate,
                icon: const Icon(Icons.date_range),
                label: const Text('Cupertino Date Picker'),
              ),
              const SizedBox(height: 8),
              const Text('Material Dropdown'),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedRole,
                items: roles
                    .map(
                      (role) => DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  ),
                )
                    .toList(),
                onChanged: onRoleChanged,
              ),
              OutlinedButton.icon(
                onPressed: onCupertinoRole,
                icon: const Icon(Icons.view_carousel),
                label: const Text('Cupertino Wheel Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
