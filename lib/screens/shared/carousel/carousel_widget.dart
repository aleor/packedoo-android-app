import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:packedoo_app_material/models/photo.dart';
import 'package:packedoo_app_material/screens/shared/carousel/carousel_images.dart';
import 'package:packedoo_app_material/screens/shared/carousel/full_page_carousel.dart';
import 'package:packedoo_app_material/screens/shared/carousel/page_indicator.dart';

class Carousel extends StatefulWidget {
  final List<Photo> children;
  final String title;
  final bool fullScreenMode;
  final int startPageIndex;
  final double height;

  Carousel(
      {this.children,
      this.title,
      this.height = 250,
      this.fullScreenMode = false,
      this.startPageIndex = 0});

  @override
  State createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  final PageController _controller = PageController();
  List<Widget> _carouselItems;
  int _currentPage;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.startPageIndex;
    _carouselItems =
        CarouselImages.get(photos: widget.children, height: widget.height);
    _controller.addListener(controllerListener);

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _controller.jumpToPage(_currentPage));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _fullScreenMode,
      child: Container(
        height: widget.fullScreenMode
            ? MediaQuery.of(context).size.height
            : widget.height,
        child: Stack(
          children: <Widget>[
            PageView(
              physics: AlwaysScrollableScrollPhysics(),
              children: _carouselItems,
              controller: _controller,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: widget.fullScreenMode ? 50 : 15),
                child: PageIndicator(
                  max: widget.children.length,
                  current: _currentPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(controllerListener);
    super.dispose();
  }

  controllerListener() {
    if (_controller.page.round() != _currentPage)
      setState(() => _currentPage = _controller.page.round());
  }

  _fullScreenMode() {
    if (widget.fullScreenMode) {
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => FullPageCarousel(
            carouselItems: widget.children,
            title: widget.title,
            startPageIndex: _currentPage,
          ),
        ));
  }
}
