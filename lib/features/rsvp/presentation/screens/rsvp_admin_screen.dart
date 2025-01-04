import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../providers/rsvp_provider.dart';
import '../../data/models/rsvp.dart';

class RsvpAdminScreen extends StatefulWidget {
  const RsvpAdminScreen({super.key});

  @override
  State<RsvpAdminScreen> createState() => _RsvpAdminScreenState();
}

class _RsvpAdminScreenState extends State<RsvpAdminScreen> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRsvps();
  }

  Future<void> _loadRsvps() async {
    setState(() => _isLoading = true);
    try {
      final rsvpProvider = context.read<RsvpProvider>();
      await rsvpProvider.fetchRsvps();
      if (rsvpProvider.error != null) {
        _showErrorSnackbar(rsvpProvider.error!);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Prøv igjen',
          textColor: Colors.white,
          onPressed: _loadRsvps,
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, RSVP rsvp) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.neutral50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Slett RSVP',
          style: TextStyle(color: CustomColors.textPrimary),
        ),
        content: Text(
          'Er du sikker på at du vil slette RSVP fra ${rsvp.name}?',
          style: TextStyle(color: CustomColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Avbryt',
              style: TextStyle(color: CustomColors.neutral600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (rsvp.id != null) {
                await _deleteRsvp(rsvp.id!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Slett'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRsvp(int id) async {
    final rsvpProvider = context.read<RsvpProvider>();
    try {
      await rsvpProvider.deleteRsvp(id);
      if (rsvpProvider.error != null) {
        _showErrorSnackbar(rsvpProvider.error!);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('RSVP ble slettet'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackbar('Kunne ikke slette RSVP: $e');
    }
  }

  Future<void> _showUpdateDialog(BuildContext context, RSVP rsvp) {
    bool attending = rsvp.attending;
    final allergiesController = TextEditingController(text: rsvp.allergies);

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: CustomColors.neutral50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Oppdater RSVP',
            style: TextStyle(color: CustomColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Navn: ${rsvp.name}',
                style: TextStyle(color: CustomColors.textSecondary),
              ),
              Text(
                'E-post: ${rsvp.email}',
                style: TextStyle(color: CustomColors.textSecondary),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Kommer'),
                value: attending,
                onChanged: (value) => setState(() => attending = value),
                activeColor: CustomColors.success,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergier',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Avbryt',
                style: TextStyle(color: CustomColors.neutral600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                if (rsvp.id != null) {
                  await _updateRsvp(
                    rsvp.id!,
                    attending: attending,
                    allergies: allergiesController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Oppdater'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateRsvp(
    int id, {
    required bool attending,
    required String allergies,
  }) async {
    final rsvpProvider = context.read<RsvpProvider>();
    try {
      await rsvpProvider.updateRsvp(
        id,
        attending: attending,
        allergies: allergies.trim(),
      );
      if (rsvpProvider.error != null) {
        _showErrorSnackbar(rsvpProvider.error!);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('RSVP ble oppdatert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackbar('Kunne ikke oppdatere RSVP: $e');
    }
  }

 Future<void> _sendEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': 'Angående din RSVP til bryllupet',
    },
  );
  
  if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kunne ikke åpne e-postklient')),
      );
    }
  }
}


  Widget _buildRsvpCard(BuildContext context, RSVP rsvp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        key: ValueKey(rsvp.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _sendEmail(rsvp.email),
              backgroundColor: CustomColors.info,
              foregroundColor: Colors.white,
              icon: Icons.email,
              label: 'Send e-post',
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            SlidableAction(
              onPressed: (_) => _showDeleteConfirmation(context, rsvp),
              backgroundColor: CustomColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Slett',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: CustomColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: rsvp.attending 
                ? CustomColors.success.withAlpha(77) // Byttet fra withOpacity
                : CustomColors.error.withAlpha(77),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => _showUpdateDialog(context, rsvp),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Navn + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          rsvp.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CustomColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: rsvp.attending 
                            ? CustomColors.success.withAlpha(26) // 0.1 opacity * 255 ≈ 26
                            : CustomColors.error.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rsvp.attending ? 'Kommer' : 'Kommer ikke',
                          style: TextStyle(
                            color: rsvp.attending 
                              ? CustomColors.success 
                              : CustomColors.error,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// E-post
                  InkWell(
                    onTap: () => _sendEmail(rsvp.email),
                    child: Text(
                      rsvp.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.info,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  /// Allergier
                  if (rsvp.allergies?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Allergier:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rsvp.allergies ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColors.textPrimary,
                      ),
                    ),
                  ],

                  /// Opprettelsesdato
                  if (rsvp.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Registrert: ${_formatDate(rsvp.createdAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CustomColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final rsvpProvider = context.watch<RsvpProvider>();
    final rsvps = rsvpProvider.rsvps;

    final filteredRsvps = rsvps.where((rsvp) {
      final searchLower = _searchQuery.toLowerCase();
      return rsvp.name.toLowerCase().contains(searchLower) ||
             rsvp.email.toLowerCase().contains(searchLower) ||
             (rsvp.allergies?.toLowerCase() ?? '').contains(searchLower);
    }).toList();

    // Eksempel på en liten statistikk
    final totalAttending = rsvps.where((rsvp) => rsvp.attending).length;
    final totalNotAttending = rsvps.length - totalAttending;

    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      title: 'RSVP Administrasjon',
      child: Column(
        children: [
          /// Søkefelt
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Søk etter navn, e-post eller allergier...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: CustomColors.border),
                ),
                filled: true,
                fillColor: CustomColors.surface,
              ),
            ),
          ),

          /// Liste av RSVP-er
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRsvps.isEmpty
                    ? Center(
                        child: Text(
                          'Ingen RSVP-er funnet',
                          style: TextStyle(color: CustomColors.textSecondary),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadRsvps,
                        child: ListView.builder(
                          itemCount: filteredRsvps.length,
                          itemBuilder: (context, index) =>
                              _buildRsvpCard(context, filteredRsvps[index]),
                        ),
                      ),
          ),

          /// Enkel statistikk (eller hva du måtte ønske)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Totalt: ${rsvps.length}',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kommer: $totalAttending',
                  style: TextStyle(
                    color: CustomColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Kommer ikke: $totalNotAttending',
                  style: TextStyle(
                    color: CustomColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
