import 'package:flutter/material.dart';

class BookmarkLoadingWidget extends StatefulWidget {
  const BookmarkLoadingWidget({super.key});

  @override
  State<BookmarkLoadingWidget> createState() => _BookmarkLoadingWidgetState();
}

class _BookmarkLoadingWidgetState extends State<BookmarkLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.amber.shade50,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book Cover Shimmer
                        Container(
                          width: 85,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade300.withValues(
                              alpha: 0.3 + (_animation.value * 0.4),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Book Details Shimmer
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Shimmer
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300.withValues(
                                    alpha: 0.3 + (_animation.value * 0.4),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Author Shimmer
                              Container(
                                height: 16,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade300.withValues(
                                    alpha: 0.3 + (_animation.value * 0.4),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Subject Tags Shimmer
                              Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade300.withValues(
                                        alpha: 0.3 + (_animation.value * 0.4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade300.withValues(
                                        alpha: 0.3 + (_animation.value * 0.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Download Count and Language Shimmer
                              Row(
                                children: [
                                  Container(
                                    height: 22,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Colors.grey.shade300.withValues(
                                        alpha: 0.3 + (_animation.value * 0.4),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 22,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Colors.grey.shade300.withValues(
                                        alpha: 0.3 + (_animation.value * 0.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Bookmark Button Shimmer
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300.withValues(
                              alpha: 0.3 + (_animation.value * 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
