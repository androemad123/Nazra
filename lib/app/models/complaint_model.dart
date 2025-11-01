import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  final String id;
  final String userId;
  final String imageUrl;
  final String category;
  final String description;
  final GeoPoint location;
  final String address;
  final String status; // pending, in_progress, resolved, not_issue
  final String priority; // high, medium, low
  final String? assignedOfficerId;
  final String? communityId;
  final double aiConfidence;
  final String? resolutionNote;
  final int likes;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Complaint({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.location,
    required this.address,
    required this.status,
    required this.priority,
    this.assignedOfficerId,
    this.communityId,
    required this.aiConfidence,
    this.resolutionNote,
    this.likes = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ Convert Firestore document to Issue object
  factory Complaint.fromMap(Map<String, dynamic> map, String docId) {
    return Complaint(
      id: docId,
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? const GeoPoint(0, 0),
      address: map['address'] ?? '',
      status: map['status'] ?? 'pending',
      priority: map['priority'] ?? 'medium',
      assignedOfficerId: map['assignedOfficerId'],
      communityId: map['communityId'],
      aiConfidence: (map['aiConfidence'] ?? 0.0).toDouble(),
      resolutionNote: map['resolutionNote'],
      likes: map['likes'] ?? 0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
    );
  }

  /// ✅ Convert Issue object to Firestore-friendly map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'location': location,
      'address': address,
      'status': status,
      'priority': priority,
      'assignedOfficerId': assignedOfficerId,
      'communityId': communityId,
      'aiConfidence': aiConfidence,
      'resolutionNote': resolutionNote,
      'likes': likes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🧩 Dummy data for UI testing
  static List<Complaint> dummyData = [
    Complaint(
      id: '1',
      userId: 'user_001',
      imageUrl:
      'https://images.unsplash.com/photo-1581092334444-3a86b0b5a3b7?w=800',
      category: 'Garbage & Waste',
      description: 'Overflowing trash bins near the market area.',
      location: const GeoPoint(30.0444, 31.2357),
      address: 'Tahrir Square, Cairo',
      status: 'pending',
      priority: 'high',
      assignedOfficerId: 'officer_001',
      communityId: 'community_001',
      aiConfidence: 0.93,
      resolutionNote: null,
      likes: 12,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    ),
    Complaint(
      id: '2',
      userId: 'user_002',
      imageUrl:
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800',
      category: 'Road & Sidewalk Damage',
      description: 'Large pothole near the school entrance.',
      location: const GeoPoint(30.0595, 31.2234),
      address: 'Nasr City, Street 10',
      status: 'in_progress',
      priority: 'medium',
      assignedOfficerId: 'officer_002',
      communityId: 'community_002',
      aiConfidence: 0.87,
      resolutionNote: 'Repair scheduled for tomorrow.',
      likes: 9,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    ),
    Complaint(
      id: '3',
      userId: 'user_003',
      imageUrl:
      'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?w=800',
      category: 'Trees & Vegetation',
      description: 'Fallen tree blocking part of the sidewalk.',
      location: const GeoPoint(30.0611, 31.2184),
      address: 'Heliopolis, Abu Bakr St.',
      status: 'resolved',
      priority: 'high',
      assignedOfficerId: 'officer_003',
      communityId: 'community_003',
      aiConfidence: 0.95,
      resolutionNote: 'Tree removed by the cleanup team.',
      likes: 20,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    ),
  ];
}
