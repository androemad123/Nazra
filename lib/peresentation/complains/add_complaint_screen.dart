import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nazra/peresentation/resources/color_manager.dart';
import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/peresentation/widgets/app_text_btn.dart';

import '../../app/services/image_picker_service.dart';
import '../../app/services/cloudinary_service.dart';
import '../../app/services/ml_api_service.dart';
import '../../app/repositories/complaint_repository.dart';
import '../../app/bloc/location_bloc/location_bloc.dart';
import 'map_sample.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedProblemType;

  List<File> _imageFiles = [];
  final ImagePickerService _imageService = ImagePickerService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final MlApiService _mlApiService = MlApiService();
  final ComplaintRepository _complaintRepository = ComplaintRepository();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize location when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationBloc = context.read<LocationBloc>();
      if (locationBloc.state is LocationInitial) {
        locationBloc.add(FetchLocation());
      }
    });
  }

  void _showPickerDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final image = await _imageService.pickFromGallery();
                  if (image != null) setState(() => _imageFiles.add(image));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final image = await _imageService.pickFromCamera();
                  if (image != null) setState(() => _imageFiles.add(image));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  final List<String> problemTypes = [
    'Electricity issue',
    'Water leakage',
    'Garbage collection',
    'Road damage',
  ];

  /// Handles the submission of the complaint
  /// 
  /// 1. Validates all required fields
  /// 2. Gets the current location from LocationBloc
  /// 3. Uploads images to Cloudinary with metadata
  /// 4. Sends image URLs to ML API for analysis
  /// 5. Saves everything to Firestore
  Future<void> _handleSubmit() async {
    // Validate fields
    if (_selectedProblemType == null || _selectedProblemType!.isEmpty) {
      _showSnackBar('Please select a problem type', isError: true);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter a description', isError: true);
      return;
    }

    if (_imageFiles.isEmpty) {
      _showSnackBar('Please add at least one photo', isError: true);
      return;
    }

    // Get location from LocationBloc
    final locationBloc = context.read<LocationBloc>();
    final locationState = locationBloc.state;
    
    if (locationState is! LocationLoaded) {
      // Try to fetch location if not loaded
      locationBloc.add(FetchLocation());
      _showSnackBar('Please wait for location to load', isError: true);
      return;
    }

    final position = locationState.position;
    final address = locationState.address;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Step 1: Upload images to Cloudinary with metadata
      _showSnackBar('Uploading images...');
      
      final imageUrls = await _cloudinaryService.uploadImages(
        imageFiles: _imageFiles,
        description: _descriptionController.text.trim(),
        category: _selectedProblemType!,
      );

      if (imageUrls.isEmpty) {
        throw Exception('Failed to upload images. Please try again.');
      }

      // Step 2: Send image URLs to ML API for analysis
      _showSnackBar('Analyzing image with AI...');
      
      final mlResult = await _mlApiService.analyzeImages(
        imageUrls: imageUrls,
        description: _descriptionController.text.trim(),
        category: _selectedProblemType!,
      );

      Map<String, dynamic>? normalizedMlResult;
      if (mlResult != null) {
        final aiData = mlResult['data'];
        normalizedMlResult = {
          'is_issue': mlResult['is_issue'] ?? true,
          'data': aiData is Map<String, dynamic>
              ? Map<String, dynamic>.from(aiData)
              : <String, dynamic>{},
        };
      }

      // Step 3: Save to Firestore
      _showSnackBar('Saving complaint...');
      
      final complaintId = await _complaintRepository.addComplaint(
        imageUrls: imageUrls,
        description: _descriptionController.text.trim(),
        category: _selectedProblemType!,
        location: position,
        address: address,
        mlAnalysisResult: normalizedMlResult,
      );

      if (complaintId != null) {
        // Success!
        _showSnackBar('Complaint submitted successfully!');
        
        // Clear form
        _descriptionController.clear();
        setState(() {
          _selectedProblemType = null;
          _imageFiles.clear();
        });

        // Optionally navigate back after a short delay
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        throw Exception('Failed to save complaint. Please try again.');
      }
    } catch (e) {
      _showSnackBar(
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a complaint'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem type dropdown
            Text(
              "Type of problem",
              style: regularStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorManager.lighterBeige,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select the type of problem',
                      style: regularStyle(
                          fontSize: 16, color: Colors.grey.shade600)),
                  value: _selectedProblemType,
                  isExpanded: true,
                  dropdownColor: ColorManager.lighterBeige,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: problemTypes
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: regularStyle(
                                  fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedProblemType = val),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Description
            Text(
              "Problem description",
              style: regularStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: ColorManager.lighterBeige,
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 200,
                // ✅ Limit to 500 characters
                style: regularStyle(fontSize: 14, color: Colors.black87),
                decoration: InputDecoration(
                  counterText: "", // ✅ Hide the character counter if you prefer
                  border: InputBorder.none,
                  hintText: 'Write a description of the problem...',
                  hintStyle: regularStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Add Photo
            // Add Photo
            Text(
              "Add photos",
              style: regularStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 8.h),

            GestureDetector(
              onTap: _showPickerDialog,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(12),
                  color: Colors.black12,
                  dashPattern: [10, 5],
                  strokeWidth: 2,
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF8F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: _imageFiles.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 40.sp,
                        color: Colors.brown.shade300,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Click to add images",
                        style: regularStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        "Attaching photos helps resolve the issue faster.",
                        style: regularStyle(fontSize: 12, color: Colors.black38),
                      ),
                    ],
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _imageFiles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _imageFiles.length) {
                        // Add more button
                        return GestureDetector(
                          onTap: _showPickerDialog,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.brown.shade200),
                            ),
                            child: Center(
                              child: Icon(Icons.add_a_photo,
                                  color: Colors.brown.shade300),
                            ),
                          ),
                        );
                      }

                      final image = _imageFiles[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _imageFiles.removeAt(index)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),


            SizedBox(height: 20.h),

            // Location
            Text(
              "Location",
              style: regularStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20.h),
            MapSample(),
            SizedBox(height: 20.h),

            // Submit Button
            AppTextBtn(
              buttonText: _isSubmitting ? "Submitting..." : "Submit",
              textStyle: semiBoldStyle(fontSize: 16, color: Colors.white),
              onPressed: _isSubmitting ? () {} : () => _handleSubmit(),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
