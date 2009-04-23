using Gtk;
using Gdk;
using WebKit;
using Summer;
using Sexy;

namespace Cameron {
	class InfoWindow : Gtk.VBox {
		UrlLabel label;
		WebView viewer;
		DownloadProxy dl = null;
		construct {
			label = new UrlLabel () as UrlLabel;
			viewer = new WebView () as WebView;
			this.pack_start ((Widget) label, false, false, 6);
			this.pack_start ((Widget) viewer, true, true, 6);
			this.show_all ();
			label.url_activated += (label, url) => {
				if (dl != null) {
					try {
						show_uri (null, 
							"file://%s".printf (dl.save_path),
							CURRENT_TIME);
					}
					catch (GLib.Error ex) {
						stdout.printf (
							"Couldn't open file: %s".printf (ex.message));
					}
				}
			};
		}

		public void set_download (DownloadProxy dl) {
			this.dl = dl;
			if (true)
				label.set_markup (("<big>%s</big> <a href=\"run\">" + _("Run") + "</a>").printf (dl.title));
			else
				label.set_markup ("<big>%s</big>".printf (dl.title));
			viewer.load_html_string (dl.description, "http://localhost");
		}
	}
}
