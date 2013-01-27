

#import "REVKActivityViewController.h"
#import "AppDelegate.h"
#import "REAuthCell.h"

@interface REVKActivityViewController ()

@end

@implementation REVKActivityViewController

- (id)initWithClientId:(NSString *)clientId
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"VK Log In";
        self.clientId = clientId;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=wall,photos&redirect_uri=http://oauth.vk.com/blank.html&display=touch&response_type=token", _clientId]]];
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = CGPointMake(22, 22);
        [_indicatorView startAnimating];
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [view addSubview:_indicatorView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange searchRange = NSMakeRange(0, url.length);
    NSRange foundRange = [url rangeOfString:@"access_token" options:0 range:searchRange];
    if (foundRange.location != NSNotFound) {
        NSArray *items = [url componentsSeparatedByString:@"="];
        items = [[items objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSString *token = [items objectAtIndex:0];
        
        NSArray *userAr = [url componentsSeparatedByString:@"&user_id="];
        NSString *userId = [userAr lastObject];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"REVKActivity_Token"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"REVKActivity_UserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:^{
            [_activity share];
        }];
        
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _indicatorView.hidden = YES;
}

@end
