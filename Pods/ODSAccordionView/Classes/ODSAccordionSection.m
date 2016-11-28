//
//  ODSAccordionSection.m
//  
//
//  Created by Johannes Seitz on 17/06/14.
//
//

#import "ODSAccordionSection.h"


@implementation ODSAccordionSection

-(id)initWithTitle:(NSString *)sectionTitle andView:(UIView *)sectionView andImage: (UIImage*)sectionImage {
    self = [super init];
    if (self){
        _title = sectionTitle;
        _view = sectionView;
        _image = sectionImage;
    }
    return self;
}

@end
