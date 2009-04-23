using Summer;
using GLib;

namespace Cameron {
	class DownloadProxy : GLib.Object {
		public Download? download {private get; set;}
		private string? _id;
		private string? _save_path;
		private string? _feed_url;
		private string? _description;
		private string? _title;

		public DownloadProxy (Download? dl) {
			download = dl;
		}

		public string? id {
			get {
				if (download != null)
					return download.item.get_id ();
				else
					return _id;
			}
			set {
				_id = value;
			}
		}

		public string? save_path {
			get {
				if (download != null)
					return download.get_save_path ();
				else
					return _save_path;
			}
			set {
				_save_path = value;
			}
		}

		public string? feed_url {
			get {
				if (download != null)
					return download.item.feed.url;
				else
					return _feed_url;
			}
			set {
				_feed_url = value;
			}
		}

		public string? description {
			get {
				if (download != null)
					return download.item.description;
				else
					return _description;
			}
			set {
				_description = value;
			}
		}

		public string? title {
			get {
				if (download != null)
					return download.item.title;
				else
					return _title;
			}
			set {
				_title = value;
			}
		}

		public void abort () {
			if (download != null)
				download.abort ();
		}
	}
}
