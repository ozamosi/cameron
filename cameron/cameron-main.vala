using GLib;
using Summer;
using PkgConfig;

namespace Cameron {
	class Main : GLib.Object {
		private SubscriptionManager subscription_manager;
		private Window window;
		construct {
			window = new Window ();

			if (subscription_file != null)
				Config.subscription_file = subscription_file;

			subscription_manager = SubscriptionManager.instance ();

			Summer.Download.set_default (Config.tmp_dir, Config.save_dir);
			if (no_cache)
				Summer.Feed.set_default (null, 900);
			else
				Summer.Feed.set_default (Config.cache_dir, 900);

			foreach (var subscription in subscription_manager.subscriptions) {
				window.add_subscription (subscription);
				new_feed (subscription.url);
			}
			subscription_manager.subscription_added += (subscr_man, subscr) => {
				window.add_subscription (subscr);
				new_feed (subscr.url);
			};
			subscription_manager.subscription_changed += (subscr_man, subscr) => {
				window.update_subscription (subscr);
			};
		}

		public void run () {
			window.run ();
		}

		private void new_feed (string url) {
			var feed = new Summer.Feed ();
			feed.new_entries += (feed) => {
				foreach (var item in feed.get_items ()) {
					var dl = Summer.create_download (item);
					if (dl == null) {
						continue;
					}
					foreach (var s in subscription_manager.subscriptions) {
						if (s.url == feed.url) {
							dl.save_dir = s.save_dir;
						}
					}
					
					dl.download_started += (dl) => {
						window.add_download (dl);
					};

					dl.download_update += (dl, completed, length) => {
						double progress = 0;
						if (length != 0)
							progress = completed / (double) length;
						window.update_download (dl, progress);
					};
					dl.download_complete += (dl) => {
						window.update_download (dl, 1.0);
					};
					dl.start ();
				}
			};
			feed.start (url);
		}

		public static void shutdown () {
			Summer.shutdown ();
			Gtk.main_quit ();
		}

		static string subscription_file = null;
		static bool no_cache = false;
		static const OptionEntry[] options = {
			{"subscriptions", 0, 0, OptionArg.STRING, out subscription_file, N_("Select which subscription configuration file to use"), null},
			{"no-cache", 0, 0, OptionArg.NONE, out no_cache, N_("Disable the use of a cache file for previously downloaded items"), null},
			{null}
   };



		public static int main (string[] args) {
			Intl.bindtextdomain (
				PkgConfig.GETTEXT_PACKAGE,
				PkgConfig.PACKAGE_LOCALEDIR);
			Intl.bind_textdomain_codeset (PkgConfig.GETTEXT_PACKAGE, "UTF-8");
			Intl.textdomain (PkgConfig.GETTEXT_PACKAGE);

			var context = new OptionContext (_("- Broadcatching application"));
			context.add_main_entries(options, PkgConfig.GETTEXT_PACKAGE);
			context.add_group (Gtk.get_option_group (true));
			try {
				context.parse (ref args);
			} catch (Error e) {
				stdout.printf (_("Couldn't parse command line arguments: %s\n"),
					e.message);
				return 1;
			}
			var cameron = new Cameron.Main ();
			cameron.run ();
			Gtk.main ();
			return 0;
		}
	}
}
