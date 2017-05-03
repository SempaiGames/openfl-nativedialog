#include <NativeDialog.h>
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

extern "C" void sendShowMessageClose();
extern "C" void sendConfirmMessageOk();
extern "C" void sendConfirmMessageCancel();
extern "C" void sendPromptOk( const char* str );
extern "C" void sendPromptCancel();

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface ShowController : UIViewController<UIAlertViewDelegate>
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface ConfirmController : UIViewController<UIAlertViewDelegate>
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface PromptController : UIViewController<UIAlertViewDelegate>
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

namespace openflNativeDialogExtension {

	ShowController* showVC = NULL;
	ConfirmController* confirmVC = NULL;
	PromptController* promptVC = NULL;

	ShowController* getShowVC(){
		if(showVC==NULL) showVC = [ShowController alloc];
		return showVC;
	}

	ConfirmController* getConfirmVC(){
		if(confirmVC==NULL) confirmVC = [ConfirmController alloc];
		return confirmVC;
	}

	PromptController* getPromptVC(){
		if(promptVC==NULL) promptVC = [PromptController alloc];
		return promptVC;
	}

	void showMessage(const char* title, const char* text, const char* buttonText){
		[[[UIAlertView alloc]
					initWithTitle:[[NSString alloc] initWithUTF8String:title]
					message:[[NSString alloc] initWithUTF8String:text]
					delegate:getShowVC()
					cancelButtonTitle:[[NSString alloc] initWithUTF8String:buttonText]
					otherButtonTitles:nil, nil] show];
	}

	void confirmMessage(const char* title, const char* text, const char* okButtonText, const char* cancelButtonText){
		[[[UIAlertView alloc]
					initWithTitle:[[NSString alloc] initWithUTF8String:title]
					message:[[NSString alloc] initWithUTF8String:text]
					delegate:getConfirmVC()
					cancelButtonTitle:[[NSString alloc] initWithUTF8String:cancelButtonText]
					otherButtonTitles:[[NSString alloc] initWithUTF8String:okButtonText], nil] show];
	}

	void prompt2(const char* title, const char* text, const char* okButtonText, const char* cancelButtonText){
		UIAlertView * alert = [[UIAlertView alloc]
					initWithTitle:[[NSString alloc] initWithUTF8String:title]
					message:[[NSString alloc] initWithUTF8String:text]
					delegate:getPromptVC()
					cancelButtonTitle:[[NSString alloc] initWithUTF8String:cancelButtonText]
					otherButtonTitles:[[NSString alloc] initWithUTF8String:okButtonText], nil];
		alert.alertViewStyle = UIAlertViewStylePlainTextInput;
		[alert show];
	}

}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation ShowController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
	sendShowMessageClose();
}

@end


@implementation ConfirmController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
	if (buttonIndex == 0)  {
		sendConfirmMessageCancel();
	} else if(buttonIndex == 1) {
		sendConfirmMessageOk();
	}
}

@end


@implementation PromptController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
	if (buttonIndex == 0)  {
		sendPromptCancel();
	} else if(buttonIndex == 1) {
		sendPromptOk( [[[alertView textFieldAtIndex:0] text] UTF8String] );
	}
}

@end