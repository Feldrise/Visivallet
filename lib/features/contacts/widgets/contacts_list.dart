import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visivallet/core/providers.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/shimmers/square_shimmer.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/features/contacts/models/contact/contact.dart';
import 'package:visivallet/features/contacts/services/contact_sharing_service.dart';
import 'package:visivallet/features/contacts/widgets/contact_card.dart';
import 'package:visivallet/features/event/models/event/event.dart';
import 'package:visivallet/theme/screen_helper.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({
    super.key,
    this.event,
    this.searchQuery,
  });

  final Event? event;
  final String? searchQuery;

  @override
  ConsumerState<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList> {
  bool _selectionMode = false;
  final Set<Contact> _selectedContacts = {};

  // Variables to store contacts data to prevent reloading
  List<Contact>? _cachedContacts;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    // Defer loading contacts to after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  @override
  void didUpdateWidget(ContactsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload contacts only when search query or event changes
    if (oldWidget.searchQuery != widget.searchQuery || oldWidget.event?.id != widget.event?.id) {
      _loadContacts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set up listeners for provider changes
    _setupProviderListeners();
  }

  void _setupProviderListeners() {
    // Remove this method call if you experience excessive rebuilds
    // Instead of listeners, you could use ref.listen in the build method
    if (widget.event == null) {
      if ((widget.searchQuery ?? "").isEmpty) {
        ref.listenManual(contactsProvider, (previous, next) {
          if (next.valueOrNull != null && next.hasValue) {
            _refreshContactsList();
          }
        });
      } else {
        ref.listenManual(filteredContactsProvider(widget.searchQuery!), (previous, next) {
          if (next.valueOrNull != null && next.hasValue) {
            _refreshContactsList();
          }
        });
      }
    } else {
      if ((widget.searchQuery ?? "").isEmpty) {
        ref.listenManual(eventContactsProvider(widget.event!.id!), (previous, next) {
          if (next.valueOrNull != null && next.hasValue) {
            _refreshContactsList();
          }
        });
      } else {
        ref.listenManual(
            filteredEventContactsProvider({
              "eventId": widget.event!.id!,
              "filter": widget.searchQuery!,
            }), (previous, next) {
          if (next.valueOrNull != null && next.hasValue) {
            _refreshContactsList();
          }
        });
      }
    }
  }

  void _refreshContactsList() {
    if (!mounted) return;
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Now fetch the data from the providers
      final contactsFuture = widget.event == null
          ? (widget.searchQuery ?? "").isEmpty
              ? ref.read(contactsProvider.future)
              : ref.read(filteredContactsProvider(widget.searchQuery!).future)
          : (widget.searchQuery ?? "").isEmpty
              ? ref.read(eventContactsProvider(widget.event!.id!).future)
              : ref.read(filteredEventContactsProvider({
                  "eventId": widget.event!.id!,
                  "filter": widget.searchQuery!,
                }).future);

      final contacts = await contactsFuture;

      if (mounted) {
        setState(() {
          _cachedContacts = contacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedContacts.clear();
      }
    });
  }

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }

      // Exit selection mode if no contacts selected
      if (_selectedContacts.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  Future<void> _shareSelectedContacts() async {
    if (_selectedContacts.isEmpty) return;

    LoadingOverlay.of(context).show();
    try {
      await ref.read(contactSharingServiceProvider).shareMultipleContacts(_selectedContacts.toList());

      if (mounted) {
        SuccessSnackbar.show(context, "Contacts partagés avec succès");
      }
      _toggleSelectionMode(); // Exit selection mode after sharing
    } finally {
      if (mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using cached contacts instead of rebuilding the Future on each selection change
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < 5; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
              child: const SquareShimmer(height: 80),
            ),
          ],
        ],
      );
    }

    if (_error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
        child: Center(
          child: Text(
            "Une erreur est survenue : $_error",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final List<Contact> contacts = _cachedContacts ?? [];

    if (contacts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenHelper.instance.horizontalPadding, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.contacts_outlined,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              "Aucun contact trouvé",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _loadContacts,
          child: ListView(
            children: [
              for (final contact in contacts) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenHelper.instance.horizontalPadding,
                  ),
                  child: InkWell(
                    onLongPress: () {
                      if (!_selectionMode) {
                        _toggleSelectionMode();
                        _toggleContactSelection(contact);
                      }
                    },
                    child: Stack(
                      children: [
                        ContactCard(
                          contact: contact,
                          onUpdated: () {
                            setState(() {
                              _cachedContacts = null; // Invalidate cached contacts to force reload
                            });
                            _loadContacts();
                          },
                        ),
                        if (_selectionMode)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () => _toggleContactSelection(contact),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _selectedContacts.contains(contact) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: _selectedContacts.contains(contact) ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              // Add extra space at the bottom for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
        if (_selectionMode)
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'shareButton',
                  onPressed: _shareSelectedContacts,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.share),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'cancelButton',
                  onPressed: _toggleSelectionMode,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
