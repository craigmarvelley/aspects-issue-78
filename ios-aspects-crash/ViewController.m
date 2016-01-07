//
//  ViewController.m
//  ios-aspects-crash
//
//  Created by Craig Marvelley on 07/01/2016.
//

#import "ViewController.h"
#import <Aspects/Aspects.h>

@interface ViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    [self loadEditorResources];
    [self alterKeyCommands];
    
}

- (void)loadEditorResources {
    
    NSString *editorHtmlFilePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    NSString *editorHtml = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:editorHtmlFilePath] encoding:NSUTF8StringEncoding];
    
    [_webView loadHTMLString:editorHtml baseURL:nil];
    
}

- (UIView *)contentViewInWebView:(WKWebView *)webView {
    
    for (UIView *view in _webView.scrollView.subviews) {
        if([[view.class description] hasPrefix:@"WKContent"]) {
            return view;
        }
    }
    
    return nil;
    
}

- (void)alterKeyCommands {
    
    UIView *contentView = [self contentViewInWebView:_webView];
    SEL focusSelector = NSSelectorFromString(@"keyCommands");
    
    [contentView aspect_hookSelector:focusSelector withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        
        NSArray *keyCommands;
        
        NSInvocation *invocation = info.originalInvocation;
        [invocation invoke];
        [invocation getReturnValue:&keyCommands];
        
    } error:nil];
    
}

@end
