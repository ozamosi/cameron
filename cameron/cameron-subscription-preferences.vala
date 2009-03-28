using GLib;
using Gtk;

namespace Cameron {
	class SubscriptionPreferences : GLib.Object {
		private const string UI = PkgConfig.PACKAGE_DATADIR + "/cameron.ui";
		private Dialog dialog;
		private Entry name;
		private Entry url;
		private CheckButton use_dir;
		private FileChooser save_dir;
		private weak SList<RadioButton> update;
		private SpinButton frequency;
		private Subscription subscription;
		public SubscriptionPreferences (Subscription subscr) {
			try {
				var builder = new Builder ();
				builder.add_from_file (UI);
				dialog = builder.get_object ("edit_subscription_dialog") as Dialog;
				name = builder.get_object ("edit_subscription_name_entry") as Entry;
				url = builder.get_object ("edit_subscription_url_entry") as Entry;
				use_dir = builder.get_object ("edit_subscription_download_use_dir") as CheckButton;
				save_dir = builder.get_object ("edit_subscription_download_button") as FileChooser;
				update = ((RadioButton) builder.get_object ("edit_subscription_update_default")).get_group ();
				frequency = builder.get_object ("edit_subscription_update_frequency") as SpinButton;
			} catch (Error e) {
				var msg = new MessageDialog (null, DialogFlags.MODAL,
					MessageType.ERROR, ButtonsType.CANCEL,
					_("Failed to load UI\n%s"), e.message);
				msg.run ();
				msg.destroy ();
			}

			subscription = subscr;
			name.set_text (subscr.name);
			url.set_text (subscr.url);
			
			use_dir.active = subscr.has_save_dir;
			save_dir.sensitive = subscr.has_save_dir;
			save_dir.set_filename (subscr.save_dir);

			use_dir.toggled += (button) => {
				save_dir.set_sensitive (button.active);
			};
		}

		public void run () {
			assert (dialog != null);
			if (dialog.run () == (int) ResponseType.APPLY) {
				subscription.update (
					url.get_text (),
					name.get_text (),
					use_dir.get_active () ? save_dir.get_filename () : null);
			}
			dialog.destroy ();
		}
	}
}
