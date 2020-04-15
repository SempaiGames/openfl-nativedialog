#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "NativeDialog.h"

using namespace openflNativeDialogExtension;

AutoGCRoot* onShowMessageClose = 0;
AutoGCRoot* onSendConfirmMessageOk = 0;
AutoGCRoot* onSendConfirmMessageCancel = 0;
AutoGCRoot* onSendPromptOk = 0;
AutoGCRoot* onSendPromptCancel = 0;

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

static value show_message(value title, value text, value buttonText){
	showMessage(val_string(title), val_string(text), val_string(buttonText));
	return alloc_null();
}
DEFINE_PRIM(show_message,3);

static value confirm_message(value title, value text, value okButtonText, value cancelButtonText){
	confirmMessage(val_string(title), val_string(text), val_string(okButtonText), val_string(cancelButtonText));
	return alloc_null();
}
DEFINE_PRIM(confirm_message,4);

static value prompt(value title, value text, value okButtonText, value cancelButtonText){
  prompt2(val_string(title), val_string(text), val_string(okButtonText), val_string(cancelButtonText));
  return alloc_null();
}
DEFINE_PRIM(prompt,4);

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

static value set_callback(value _onShowMessageClose, value _onSendConfirmMessageOk, value _onSendConfirmMessageCancel, value _onSendPromptOk, value _onSendPromptCancel)
{
	onShowMessageClose = new AutoGCRoot(_onShowMessageClose);
	onSendConfirmMessageOk = new AutoGCRoot(_onSendConfirmMessageOk);
	onSendConfirmMessageCancel = new AutoGCRoot(_onSendConfirmMessageCancel);
  onSendPromptOk = new AutoGCRoot(_onSendPromptOk);
  onSendPromptCancel = new AutoGCRoot(_onSendPromptCancel);
	return alloc_null();
}
DEFINE_PRIM(set_callback, 5);

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

extern "C" void sendShowMessageClose() {
    val_call0(onShowMessageClose->get());
}

extern "C" void sendConfirmMessageOk() {
    val_call0(onSendConfirmMessageOk->get());
}

extern "C" void sendConfirmMessageCancel() {
    val_call0(onSendConfirmMessageCancel->get());
}

extern "C" void sendPromptOk( const char* str ) {
    val_call1(onSendPromptOk->get(), alloc_string(str));
}

extern "C" void sendPromptCancel() {
    val_call0(onSendPromptCancel->get());
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

extern "C" void nativedialog_main () {
	val_int(0); // Fix Neko init

}
DEFINE_ENTRY_POINT (nativedialog_main);


extern "C" int openflNativeDialogExtension_register_prims () { return 0; }
