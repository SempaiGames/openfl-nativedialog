package nativedialog;

import android.content.DialogInterface;
import android.app.AlertDialog;
import android.widget.EditText;
import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;
import org.haxe.extension.Extension;

public class NativeDialog {

	private static HaxeObject callback = null;

	public static void init( HaxeObject callback ) {
		NativeDialog.callback = callback;
	}

	public static void showMessage( final String title, final String text, final String buttonText) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback!=null) NativeDialog.callback.call ("_onShowMessageClose",null);
					}
				};
				dialog.setTitle(title);
				dialog.setMessage(text);
				dialog.setNeutralButton(buttonText, onClickListener);
				dialog.setCancelable(false);
				dialog.show();
			}
		});
	}

	public static void confirmMessage( final String title, final String text, final String okText, final String cancelText) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback==null) return;
						if(which == DialogInterface.BUTTON_POSITIVE) NativeDialog.callback.call ("_onConfirmMessageOk",null);
						if(which == DialogInterface.BUTTON_NEGATIVE) NativeDialog.callback.call ("_onConfirmMessageCancel",null);
					}
				};
				dialog.setTitle(title);
				dialog.setMessage(text);
				dialog.setPositiveButton(okText, onClickListener);
				dialog.setNegativeButton(cancelText, onClickListener);
				dialog.setCancelable(false);
				dialog.show();
			}
		});
	}

	public static void prompt( final String title, final String text, final String okText, final String cancelText) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				final EditText input = new EditText(Extension.mainContext);

				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback==null) return;
						if(which == DialogInterface.BUTTON_POSITIVE) NativeDialog.callback.call ("_onPromptOk", new Object[] {input.getText().toString()});
						if(which == DialogInterface.BUTTON_NEGATIVE) NativeDialog.callback.call ("_onPromptCancel",null);
					}
				};

				//input.setHint("Some default text");
				//input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
				dialog.setView(input);

				dialog.setTitle(title);
				dialog.setMessage(text);
				dialog.setPositiveButton(okText, onClickListener);
				dialog.setNegativeButton(cancelText, onClickListener);
				dialog.setCancelable(false);
				dialog.show();
			}
		});
	}
}
