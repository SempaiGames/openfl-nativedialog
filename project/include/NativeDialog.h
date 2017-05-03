#ifndef OPENFLNATIVEDIALOG_H
#define OPENFLNATIVEDIALOG_H


namespace openflNativeDialogExtension {
	void showMessage(const char* title, const char* text, const char* buttonText);
	void confirmMessage(const char* title, const char* text, const char* okButtonText, const char* cancelButtonText);
  void prompt2(const char* title, const char* text, const char* okButtonText, const char* cancelButtonText);
}

#endif
