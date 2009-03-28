using GLib;
using Gtk;

namespace Cameron {
	class Add : GLib.Object {
		private Dialog dialog;
		private Entry url;
		private const string UI = PkgConfig.PACKAGE_DATADIR + "/cameron.ui";
		public Add () {
			try {
				var builder = new Builder ();
				builder.add_from_file (UI);
				dialog = builder.get_object ("add_dialog") as Dialog;
				url = builder.get_object ("url_entry") as Entry;
			} catch (Error e) {
				var msg = new MessageDialog (null, DialogFlags.MODAL,
					MessageType.ERROR, ButtonsType.CANCEL,
					_("Failed to load UI\n%s"), e.message);
				msg.run ();
				msg.destroy ();
			}
		}
		public void run () {
			assert (dialog != null);
			if (dialog.run () == (int) ResponseType.OK) {
				ref ();
				var feed = new Summer.Feed ();
				feed.frequency = 0;
				feed.new_entries += (feed) => {
					var subscr_man = SubscriptionManager.instance ();
					subscr_man.add_subscription (url.get_text (), feed.title, null);
					dialog.destroy ();
					unref ();
				};
				feed.start (url.get_text ());
			} else {
				dialog.destroy ();
			}
		}
	}
}
