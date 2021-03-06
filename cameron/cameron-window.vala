using GLib;
using Gtk;
using Gdk;
using Gee;
using Summer;

namespace Cameron {
	class Window : GLib.Object {
		private const string UI = PkgConfig.PACKAGE_DATADIR + "/cameron.ui";
		private Gtk.Window window;
		private SubscriptionView subscriptions;
		private DownloadView downloads;
		private InfoWindow info_window;

		public Window () {
			try {
				var builder = new Builder ();
				builder.add_from_file (UI);
				window = builder.get_object ("window") as Gtk.Window;
				window.destroy += Main.shutdown;
				
				subscriptions = new SubscriptionView (
					builder.get_object ("subscription_view") as TreeView);
				subscriptions.selected_changed += (subscrview, subscr) => {
					downloads.set_filter (subscr);
				};
				
				downloads = new DownloadView (
					builder.get_object ("downloads") as TreeView);
				downloads.selected_changed += (dlview, dl) => {
					info_window.set_download (dl);
				};

				var container = builder.get_object ("info_widget_scrolled") as ScrolledWindow;
				info_window = new InfoWindow ();
				container.add_with_viewport (info_window);

				var about = builder.get_object ("about") as MenuItem;
				about.activate += (action) => {
					var dialog = new AboutDialog ();
					dialog.program_name = "Cameron";
					dialog.version = "0.1.0";
					dialog.website = "http://wrya.net/services/trac/summer";
					dialog.authors = {"Robin Sonefors <ozamosi@flukkost.nu>"};
					dialog.translator_credits = N_("translator-credits");
					dialog.run ();
					dialog.destroy ();
				};

				var add = builder.get_object ("add") as MenuItem;
				add.activate += (action) => {
					var dialog = new Add ();
					dialog.run ();
				};
			} catch (Error e) {
				var msg = new MessageDialog (null, DialogFlags.MODAL,
					MessageType.ERROR, ButtonsType.CANCEL,
					_("Failed to load UI\n%s"), e.message);
				msg.run ();
				msg.destroy ();
				error (e.message);
			}
		}

		public void run () {
			window.show_all ();
		}

		public void add_download (Download dl) {
			downloads.add (dl);
		}

		public void update_download (Download dl, double progress) {
			downloads.update (dl, progress);
		}
	}
}
