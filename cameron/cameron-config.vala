using GLib;
using GConf;

namespace Cameron {
	public class Config {
		private static string subscription_file;
		public static string get_subscription_file () {
			if (subscription_file == null)
				subscription_file = Path.build_filename (
					Environment.get_user_config_dir (),
					"cameron",
					"subscriptions.xml");

			return subscription_file;
		}

		private static string downloads_file;

		public static string get_downloads_file () {
			if (downloads_file == null)
				downloads_file = Path.build_filename (
					Environment.get_user_cache_dir (),
					"cameron",
					"downloads.xml");
			return downloads_file;
		}

		public static string get_save_dir () {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			string save_dir;
			try {
				save_dir = gc.get_string (root + "save_dir");
			} catch (GLib.Error e) {
				save_dir = null;
			}
			if (save_dir == null) {
				save_dir = Path.build_filename (
					Environment.get_user_data_dir (),
					"cameron");
			}
			return save_dir;
		}

		public static void set_save_dir (string dir) {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			try {
				gc.set_string (root + "save_dir", dir);
			} catch (GLib.Error e) {}
		}
		public static string get_cache_dir () {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			string cache_dir;
			try {
				cache_dir = gc.get_string (root + "cache_dir");
			} catch (GLib.Error e) {
				cache_dir = null;
			}
			if (cache_dir == null) {
				cache_dir = Path.build_filename (
					Environment.get_user_cache_dir (),
					"cameron");
			}
			return cache_dir;
		}
		public static void set_cache_dir (string dir) {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			try {
				gc.set_string (root + "cache_dir", dir);
			} catch (GLib.Error e) {}
		}

		public static string get_tmp_dir () {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			string tmp_dir;
			try {
				tmp_dir = gc.get_string (root + "tmp_dir");
			} catch (GLib.Error e) {
				tmp_dir = null;
			}
			if (tmp_dir == null) {
				tmp_dir = Path.build_filename (
					Environment.get_user_cache_dir (),
					"cameron");
			}
			return tmp_dir;
		}
		public static void set_tmp_dir (string dir) {
			var gc = Client.get_default ();
			var root = "/apps/cameron/";
			try {
				gc.set_string (root + "tmp_dir", dir);
			} catch (GLib.Error e) {}
		}
	}
}
