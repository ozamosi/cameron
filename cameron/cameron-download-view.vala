using GLib;
using Gtk;
using Gdk;
using Summer;

namespace Cameron {
	class DownloadView : GLib.Object {
		public signal void selected_changed (Download dl);
		private TreeModelSort store;
		private TreeView view;
		private Subscription? currently_selected;
		private Download tmp_dl;
		
		public DownloadView (TreeView view) {
			this.view = view;
			setup ();

			view.button_press_event += (view, event) => {
				if (event.type == EventType.2BUTTON_PRESS && event.button == 1)
					return on_doubleclick (view, event);
				if (event.type == EventType.BUTTON_PRESS && event.button == 3)
					return on_rightclick (view, event);
				return false;
			};

			view.cursor_changed += (view) => {
				var selection = view.get_selection ();
				TreeIter? iter;
				ListStore? store;
				if (!selection.get_selected (out store, out iter))
					return;
				Download dl;
				store.get (iter, 4, out dl, -1);
				selected_changed (dl);
			};
		}

		public void add (Download dl) {
			TreeIter iter;
			weak ListStore real_store = ((TreeModelFilter) store.get_model ()).get_model () as ListStore;
			real_store.append (out iter);
			real_store.set (iter,
				0, dl.item.updated,
				1, dl.item.title,
				2, -1.0,
				3, dl.downloadable.length,
				4, dl,
				-1);
		}

		public void update (Download dl, double progress) {
			weak ListStore real_store = ((TreeModelFilter) store.get_model ()).get_model () as ListStore;
			TreeIter iter;
			real_store.get_iter_first (out iter);
			do {
				Download row_dl;
				real_store.get (iter, 4, out row_dl, -1);
				if (row_dl.item.get_id () == dl.item.get_id ()) {
					real_store.set (iter, 
						2, (float) progress,
						-1);
					break;
				}
			} while (real_store.iter_next (ref iter));
		}

		public void set_filter (Subscription? subscription) {
			currently_selected = subscription;
			((TreeModelFilter) store.get_model ()).refilter ();
		}

		private void setup () {
			store = new TreeModelSort.with_model (new TreeModelFilter (
				new ListStore (5,
					typeof (long), 
					typeof (string), 
					typeof (float), 
					typeof (uint64), 
					typeof (Download)), 
				null));
			((TreeModelFilter) store.get_model ()).set_visible_func (filter);
			view.set_model (store);

			var column = new TreeViewColumn.with_attributes (
				_("Date"), new DateRenderer (),
				"date", 0, 
				null);
			column.set_sort_column_id (0);
			column.resizable = true;
			column.expand = false;
			column.min_width = 5;
			view.insert_column (column, -1);
			column = new TreeViewColumn.with_attributes (
				_("Name"), new CellRendererText (), 
				"text", 1, 
				null);
			column.set_sort_column_id (1);
			column.resizable = true;
			column.expand = true;
			column.min_width = 5;
			view.insert_column (column, -1);
			column = new TreeViewColumn.with_attributes (
				_("Progress"), new PercentRenderer (), 
				"percent", 2, 
				null);
			column.set_sort_column_id (2);
			column.resizable = true;
			column.expand = false;
			column.min_width = 5;
			view.insert_column (column, -1);
			column = new TreeViewColumn.with_attributes (
				_("Size"), new SizeRenderer (),
				"size", 3,
				null);
			column.set_sort_column_id (3);
			column.resizable = true;
			column.expand = false;
			column.min_width = 5;
			view.insert_column (column, -1);
		}

		private bool on_rightclick (TreeView view, EventButton event) {
			TreePath path = new TreePath ();
			int x, y;
			view.get_path_at_pos ((int) event.x, (int) event.y, 
				out path, null, out x, out y);
			if (path == null)
				return false;
			TreeIter iter;
			store.get_iter_from_string (out iter, path.to_string ());
			store.get (iter, 4, out tmp_dl);
			if (tmp_dl == null)
				return false;

			Menu menu = new Menu ();
			menu.ref ();

			MenuItem item = new MenuItem.with_label (_("Abort"));
			item.activate += (item) => {
				ListStore real_store = ((TreeModelFilter) store.get_model ()).get_model () as ListStore;
				TreeIter it;
				real_store.get_iter_first (out it);
				do {
					Download dl;
					real_store.get (it, 4, out dl, -1);
					if (dl == tmp_dl) {
						real_store.remove (it);
						break;
					}
				} while (real_store.iter_next (ref it));
				tmp_dl.abort ();
				tmp_dl = null;
			};
			menu.append (item);
			menu.show_all ();
			menu.popup (null, null, null, event.button, event.time);
			return true;
		}

		private bool on_doubleclick (TreeView view, EventButton event) {
			TreePath path = new TreePath ();
			int x, y;
			view.get_path_at_pos ((int) event.x, (int) event.y, 
				out path, null, out x, out y);
			if (path == null)
				return false;
			TreeIter iter;
			store.get_iter_from_string (out iter, path.to_string ());
			Download dl;
			store.get (iter, 4, out dl);
			if (dl.completed) {
			show_uri (null, 
					"file://%s".printf (dl.get_save_path ()), event.time);
			}
			return true;
		}

		private bool filter (TreeModel model, TreeIter iter) {
			if (currently_selected == null)
				return true;
			Download? dl;
			ListStore real_store = model as ListStore;
			real_store.get (iter, 4, out dl, -1);
			if (dl != null && dl.item.feed.url == currently_selected.url)
				return true;
			return false;
		}
	}
}
