package extension.nativedialog;

#if android
import openfl.utils.JNI;
#elseif (ios || blackberry)
import cpp.Lib;
#end

class NativeDialog {

	private static var callbackObject:NativeDialog=null;
	#if android
	private static var __showMessage : String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "showMessage", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __confirmMessage : String->String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "confirmMessage", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __prompt : String->String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "prompt", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __init : NativeDialog->Void = JNI.createStaticMethod ("nativedialog/NativeDialog", "init", "(Lorg/haxe/lime/HaxeObject;)V");
	#elseif blackberry
	private static var __showMessage : String->String->String->Void = Lib.load("openflNativeDialogExtension","show_message",3);
	private static var __confirmMessage : String->String->String->String->Void = Lib.load("openflNativeDialogExtension","confirm_message",4);
	private static var __init : Dynamic->Dynamic->Dynamic->Void =  Lib.load ("openflNativeDialogExtension", "set_callback", 3);
	#elseif ios
	private static var __showMessage : String->String->String->Void = Lib.load("openflNativeDialogExtension","show_message",3);
	private static var __confirmMessage : String->String->String->String->Void = Lib.load("openflNativeDialogExtension","confirm_message",4);
	private static var __prompt : String->String->String->String->Void = Lib.load("openflNativeDialogExtension","prompt",4);
	private static var __init : Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Void =  Lib.load ("openflNativeDialogExtension", "set_callback", 5);
	#end

	private static function init(){
		if(callbackObject != null) return;
		callbackObject = new NativeDialog();
		#if android
		__init(callbackObject);
		#elseif ios
		__init(callbackObject._onShowMessageClose, callbackObject._onConfirmMessageOk, callbackObject._onConfirmMessageCancel, callbackObject._onPromptOk, callbackObject._onPromptCancel);
		#end
		#elseif blackberry
		__init(callbackObject._onShowMessageClose, callbackObject._onConfirmMessageOk, callbackObject._onConfirmMessageCancel);
		#end
	}

	public static var onShowMessageClose:Void->Void = null;
	public static var onConfirmMessageOk:Void->Void = null;
	public static var onConfirmMessageCancel:Void->Void = null;
	public static var onPromptOk:String->Void = null;
	public static var onPromptCancel:Void->Void = null;

	public static function showMessage(title:String, text:String, buttonText:String) {
		init();
		try{
			#if ( android || ios || blackberry )
				__showMessage(title, text, buttonText);
			#elseif html5
				js.Browser.window.alert(title+"\n"+text);
				callbackObject._onShowMessageClose();
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}

	public static function confirmMessage(title:String, text:String, okButtonText:String, cancelButtonText:String) {
		init();
		try{
			#if ( android || ios || blackberry )
				__confirmMessage(title, text, okButtonText, cancelButtonText);
			#elseif html5
				if(js.Browser.window.confirm(title+"\n"+text)){
					callbackObject._onConfirmMessageOk();
				}else{
					callbackObject._onConfirmMessageCancel();
				}
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}

	public static function prompt(title:String, text:String, okButtonText:String, cancelButtonText:String) {
		init();
		try{
			#if ( android || ios )
				__prompt(title, text, okButtonText, cancelButtonText);
			#elseif html5
				var p = js.Browser.window.prompt(title+"\n"+text);
				if( p != null ){
					callbackObject._onPromptOk(p);
				}else{
					callbackObject._onPromptCancel();
				}
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}

	/////////////////////////// EVENT HANDLING ////////////////////////////

	private function new() {}
	private function _onShowMessageClose() { if(onShowMessageClose!=null) onShowMessageClose(); }
	private function _onConfirmMessageOk() { if(onConfirmMessageOk!=null) onConfirmMessageOk(); }
	private function _onConfirmMessageCancel() { if(onConfirmMessageCancel!=null) onConfirmMessageCancel(); }
	private function _onPromptOk(str:String) { if(onPromptOk!=null) onPromptOk(str); }
	private function _onPromptCancel() { if(onPromptCancel!=null) onPromptCancel(); }

}
