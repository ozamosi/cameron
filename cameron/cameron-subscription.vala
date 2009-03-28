using GLib;

using GLib;

namespace Cameron {
	public class Subscription : GLib.Object {
		public signal void changed ();
		public string name {get; private set;}
		public string url {get; private set;}
		public string save_dir {get; private set;}
		public bool has_save_dir {get; private set;}
		public Subscription (string url, string? name, string? save_dir) {
			this.url = url;
			if (name == null || name == "")
				this.name = url; //FIXME: insane
			else
				this.name = name;
			if (save_dir == null || save_dir == "") {
				this.save_dir = GLib.Path.build_filename (
					Config.save_dir, name);
				has_save_dir = false;
			} else {
				this.save_dir = save_dir;
				has_save_dir = true;
			}
		}
		public void update (string url, string name, string? save_dir) {
			this.url = url;
			this.name = name;
			if (save_dir == null || save_dir == "") {
				this.save_dir = GLib.Path.build_filename (
					Config.save_dir, name);
				has_save_dir = false;
			} else {
				this.save_dir = save_dir;
				has_save_dir = true;
			}
			changed ();
		}
	}
}
