import 'package:flutter/material.dart';

import '../../data/services/google_drive_service.dart';

class GoogleDrivePicker extends StatefulWidget {
  const GoogleDrivePicker({
    required this.service,
    super.key,
  });

  final GoogleDriveService service;

  @override
  State<GoogleDrivePicker> createState() =>
      _GoogleDrivePickerState();
}

class _GoogleDrivePickerState
    extends State<GoogleDrivePicker> {
  final TextEditingController _searchController =
      TextEditingController();

  List<GoogleDriveFile> _files = [];

  bool _isLoading = true;
  String? _errorMessage;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await widget.service.authorizeDrive();

      if (!mounted) return;

      setState(() {
        _accessToken = token;
      });

      await _loadFiles();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // LOAD FILES
  // ============================================================

  Future<void> _loadFiles() async {
    final token = _accessToken;

    if (token == null || token.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final files = await widget.service.listFiles(
        accessToken: token,
        search: _searchController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _search() {
    _loadFiles();
  }

  // ============================================================
  // SELECT FILE
  // ============================================================

  void _selectFile(GoogleDriveFile file) {
    Navigator.of(context).pop(file);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 850,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF080E20),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF29344A),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        20,
        14,
        16,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF21104C),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: const Color(0xFF6D28D9),
              ),
            ),
            child: const Icon(
              Icons.cloud_outlined,
              color: Color(0xFFA78BFA),
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add from Google Drive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select a file from your Google Drive',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Close',
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        0,
        22,
        16,
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _search(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search your Drive...',
          hintStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF94A3B8),
            size: 21,
          ),
          suffixIcon: IconButton(
            tooltip: 'Search',
            onPressed: _search,
            icon: const Icon(
              Icons.arrow_forward,
              color: Color(0xFFA78BFA),
              size: 19,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFF0D1426),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF29344A),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF7C3AED),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFA78BFA),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Google Drive...',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_files.isEmpty) {
      return _buildEmptyState();
    }

    return _buildFileList();
  }

  // ============================================================
  // FILE LIST
  // ============================================================

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            4,
            22,
            12,
          ),
          child: Text(
            'Your Drive files',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              14,
              0,
              14,
              20,
            ),
            itemCount: _files.length,
            separatorBuilder: (_, index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (context, index) {
              final file = _files[index];

              return _buildFileTile(file);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileTile(GoogleDriveFile file) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectFile(file),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1325),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF1E293B),
            ),
          ),
          child: Row(
            children: [
              _buildFileIcon(file),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _fileType(file),
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                        if (file.modifiedTime != null) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '•',
                            style: TextStyle(
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(
                              file.modifiedTime!,
                            ),
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF21104C),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color(0xFF4C1D95),
                  ),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(
                    color: Color(0xFFD8B4FE),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILE ICON
  // ============================================================

  Widget _buildFileIcon(GoogleDriveFile file) {
    final String mime = file.mimeType.toLowerCase();

    IconData icon = Icons.insert_drive_file_outlined;
    Color iconColor = const Color(0xFFA78BFA);

    if (mime.startsWith('image/')) {
      icon = Icons.image_outlined;
      iconColor = const Color(0xFF38BDF8);
    } else if (mime.contains('pdf')) {
      icon = Icons.picture_as_pdf_outlined;
      iconColor = const Color(0xFFF87171);
    } else if (mime.contains('word') ||
        mime.contains('document')) {
      icon = Icons.description_outlined;
      iconColor = const Color(0xFF60A5FA);
    } else if (mime.contains('sheet') ||
        mime.contains('excel')) {
      icon = Icons.table_chart_outlined;
      iconColor = const Color(0xFF4ADE80);
    } else if (mime.contains('presentation') ||
        mime.contains('powerpoint')) {
      icon = Icons.slideshow_outlined;
      iconColor = const Color(0xFFFB923C);
    } else if (mime.startsWith('video/')) {
      icon = Icons.video_file_outlined;
      iconColor = const Color(0xFFC084FC);
    } else if (mime.startsWith('audio/')) {
      icon = Icons.audio_file_outlined;
      iconColor = const Color(0xFFF472B6);
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 21,
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF21104C),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                color: Color(0xFFA78BFA),
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No files found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Try another search or check your Google Drive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFF3F1721),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Color(0xFFF87171),
                size: 30,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Could not access Google Drive',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              _cleanError(_errorMessage),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _initialize,
              icon: const Icon(
                Icons.refresh,
                size: 18,
              ),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F16D8),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _fileType(GoogleDriveFile file) {
    final mime = file.mimeType.toLowerCase();

    if (mime.contains('pdf')) {
      return 'PDF';
    }

    if (mime.startsWith('image/')) {
      return 'Image';
    }

    if (mime.contains('document') ||
        mime.contains('word')) {
      return 'Document';
    }

    if (mime.contains('sheet') ||
        mime.contains('excel')) {
      return 'Spreadsheet';
    }

    if (mime.contains('presentation') ||
        mime.contains('powerpoint')) {
      return 'Presentation';
    }

    if (mime.startsWith('video/')) {
      return 'Video';
    }

    if (mime.startsWith('audio/')) {
      return 'Audio';
    }

    return 'File';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }

  String _cleanError(String? error) {
    if (error == null || error.isEmpty) {
      return 'Something went wrong while connecting to Google Drive.';
    }

    return error
        .replaceFirst('GoogleDriveException: ', '')
        .trim();
  }
}