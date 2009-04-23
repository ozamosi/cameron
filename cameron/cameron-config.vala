using GLib;
using GConf;

namespace Cameron {
	public class Config {
		private static string _subscription_file;
		public static string subscription_file {
			get {
				_subscription_file = Path.build_filename (
					Environment.get_user_config_dir (),
					"cameron",
					"subscriptions.xml");
				return _subscription_file;
			}
		}

		private static string _downloads_file;
		public static string downloads_file {
			get {
				_downloads_file = Path.build_filename (
					Environment.get_user_cache_dir (),
					"cameron",
					"downloads.xml");
				return _downloads_file;
			}
		}

		private static string _save_dir;
		public static string save_dir {
			get {
				var gc = Client.get_default ();
				var root = "/apps/cameron/";
				_save_dir = gc.get_string (root + "save_dir");
				if (_save_dir == null) {
					_save_dir = Path.build_filename (
						Environment.get_user_data_dir (),
						"cameron");
				}
				return _save_dir;
			}
			set {
				var gc = Client.get_default ();
				var root = "/apps/cameron/";
				gc.set_string (root + "save_dir", value);
			}
		}
	
		private static string _cache_dir;
		public static string cache_dir {
			get {
				_cache_dir = Path.build_filename (
					Environment.get_user_cache_dir (),
					"cameron");
				return _cache_dir;
			}
		}

		private static string _tmp_dir;
		public static string tmp_dir {
			get {
				var gc = Client.get_default ();
				var root = "/apps/cameron/";
				_tmp_dir = gc.get_string (root + "tmp_dir");
				if (_tmp_dir == null) {
					_tmp_dir = Path.build_filename (
						Environment.get_user_cache_dir (),
						"cameron");
				}
				return _tmp_dir;
			}
			set {
				var gc = Client.get_default ();
				var root = "/apps/cameron/";
				gc.set_string (root + "tmp_dir", value);
			}
		}
	}
}
