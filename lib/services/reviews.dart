import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packedoo_app_material/models/review.dart';
import 'package:packedoo_app_material/services/auth.dart';
import 'package:packedoo_app_material/services/google_analytics.dart';

final ReviewsService reviewsService = ReviewsService();

class ReviewsService {
  AuthService _authService = authService;

  Future<DocumentReference> addReview(Review review) async {
    GoogleAnalytics().reviewAdd();

    review.createdOn = DateTime.now();
    review.reviewerId = _authService.currentUserId;

    final reviewId =
        await Firestore.instance.collection('reviews').add(review.toMap());

    return reviewId;
  }

  Future<Review> getReviewFor(String lotId) async {
    final query = await Firestore.instance
        .collection('reviews')
        .where('reviewerId', isEqualTo: _authService.currentUserId)
        .where('lotId', isEqualTo: lotId)
        .getDocuments();

    return query.documents.isNotEmpty
        ? Review.fromMap(query.documents.first.data)
        : Review();
  }

  Future<List<Review>> getReviewsForUser(String userId) async {
    final query = await Firestore.instance
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .getDocuments();

    if (query.documents.isEmpty) return List<Review>();

    var reviews =
        List<Review>.from(query.documents.map((d) => Review.fromMap(d.data)));

    return reviews;
  }
}
