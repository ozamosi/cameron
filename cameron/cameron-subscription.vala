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

		public string to_xml () {
			return "\t<subscription>\n" +
				"\t\t<name>%s</name>\n".printf (Markup.escape_text (name)) +
				"\t\t<url>%s</url>\n".printf (Markup.escape_text (url)) +
				"\t\t<save_dir>%s</save_dir>\n".printf (
					has_save_dir ? Markup.escape_text (save_dir) : "") +
				"\t</subscription>\n";
		}
	}
}
