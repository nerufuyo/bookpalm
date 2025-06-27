import 'package:flutter/material.dart';

class BookCardShimmer extends StatefulWidget {
  const BookCardShimmer({super.key});

  @override
  State<BookCardShimmer> createState() => _BookCardShimmerState();
}

class _BookCardShimmerState extends State<BookCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment(_animation.value - 1, 0),
                      end: Alignment(_animation.value, 0),
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(width: 16),
            
            // Book Details Shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment(_animation.value - 1, 0),
                            end: Alignment(_animation.value, 0),
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[100]!,
                              Colors.grey[300]!,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Author shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        height: 14,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment(_animation.value - 1, 0),
                            end: Alignment(_animation.value, 0),
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[100]!,
                              Colors.grey[300]!,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tags shimmer
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment(_animation.value - 1, 0),
                                end: Alignment(_animation.value, 0),
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[100]!,
                                  Colors.grey[300]!,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            height: 20,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment(_animation.value - 1, 0),
                                end: Alignment(_animation.value, 0),
                                colors: [
                                  Colors.grey[300]!,
                                  Colors.grey[100]!,
                                  Colors.grey[300]!,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Download count shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment(_animation.value - 1, 0),
                            end: Alignment(_animation.value, 0),
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[100]!,
                              Colors.grey[300]!,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Bookmark Button Shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment(_animation.value - 1, 0),
                      end: Alignment(_animation.value, 0),
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
