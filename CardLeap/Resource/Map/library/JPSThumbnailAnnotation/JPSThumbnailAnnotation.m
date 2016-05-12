//
//  JPSThumbnailAnnotation.m
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import "JPSThumbnailAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation JPSThumbnailAnnotation

- (id)initWithThumbnail:(JPSThumbnail *)thumbnail {
    self = [super init];
    if (self) {
        _coordinate = thumbnail.coordinate;
        _thumbnail = thumbnail;
    }
    
    return self;
}

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!_view) {
        _view = (JPSThumbnailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"JPSThumbnailAnnotationView"];
        if (!_view) _view = [[JPSThumbnailAnnotationView alloc] initWithAnnotation:self];
    } else {
        _view.annotation = self;
    }
    
    [self updateThumbnail:_thumbnail animated:NO];
    return _view;
}

- (void)updateThumbnail:(JPSThumbnail *)thumbnail animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
            _coordinate = thumbnail.coordinate;
        }];
    } else {
        _coordinate = thumbnail.coordinate;
    }
    
    if (_view) {
        _view.tag = self.tag;
        _view.coordinate = self.coordinate;
        _view.titleLabel.text = thumbnail.title;
        _view.subtitleLabel.text = thumbnail.subtitle;
        _view.imageView.image = [UIImage imageNamed:@"store_map_smallimg_no.png"];
        [_view.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail.image] placeholderImage:nil];
        //[_view.imageView setImage:[UIImage imageNamed:@"store_unfold_no@2x.png"]];
        _view.disclosureBlock = thumbnail.disclosureBlock;
    }
}

@end
