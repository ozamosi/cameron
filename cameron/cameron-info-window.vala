using Gtk;
using Gdk;
using WebKit;
using Summer;
using Sexy;

namespace Cameron {
	class DownloadWidget : Gtk.VBox {
		UrlLabel label;
		WebView viewer;
		Download dl = null;
		construct {
			label = new UrlLabel () as UrlLabel;
			viewer = new WebView () as WebView;
			this.pack_start ((Widget) label, false, false, 6);
			this.pack_start ((Widget) viewer, true, true, 6);
			this.show_all ();
			label.url_activated += (label, url) => {
				if (dl != null)
					show_uri (null, "file://%s".printf (dl.get_save_path ()), CURRENT_TIME);
			};
		}

		public void set_download (Download dl) {
			this.dl = dl;
			if (dl.completed)
				label.set_markup (("<big>%s</big> <a href=\"run\">" + _("Run") + "</a>").printf (dl.item.title));
			else
				label.set_markup ("<big>%s</big>".printf (dl.item.title));
			viewer.load_html_string (dl.item.description, "http://localhost");
		}
	}
}
