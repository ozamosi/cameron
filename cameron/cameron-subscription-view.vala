using GLib;
using Gtk;
using Gdk;

namespace Cameron {
	class SubscriptionView : GLib.Object {
		public signal void selected_changed (Subscription? subscription);
		private ListStore store;
		private TreeView view;
		private Subscription? tmp_subscr;
		public SubscriptionView (TreeView view) {
			this.view = view;
			setup ();

			view.button_press_event += on_rightclick;
			view.cursor_changed += (view) => {
				var selection = view.get_selection ();
				TreeIter? iter;
				ListStore? store;
				if (!selection.get_selected (out store, out iter))
					return;
				Subscription? subscr;
				store.get (iter, 1, out subscr, -1);
				selected_changed (subscr);
			};
		}

		public void add (Subscription subscription) {
			TreeIter iter;
			store.append (out iter);
			store.set (iter, 
				0, subscription.name, 
				1, subscription, 
				-1);
		}

		public void update (Subscription subscription) {
			TreeIter iter;
			store.get_iter_first (out iter);
			do {
				Subscription s;
				store.get (iter, 1, out s, -1);
				if (s == subscription) {
					store.set (iter, 0, s.name);
					break;
				}
			} while (store.iter_next (ref iter));
		}

		private void setup () {
			store = new ListStore (2, typeof (string), typeof (Subscription?));
			view.set_model (store);
			view.insert_column_with_attributes (
				-1, _("Subscription"), new CellRendererText (),
				"text", 0,
				null);
			TreeIter iter;
			store.append (out iter);
			store.set (iter, 0, _("All"), 1, null, -1);
		}

		private bool on_rightclick (TreeView view, EventButton event) {
			if (event.type == EventType.BUTTON_PRESS && event.button == 3) {
				TreePath path = new TreePath ();
				int x, y;
				view.get_path_at_pos ((int) event.x, (int) event.y, out path, null, out x, out y);
				if (path == null)
					return false;
				TreeIter iter;
				store.get_iter_from_string (out iter, path.to_string ());
				store.get (iter, 1, out tmp_subscr);
				if (tmp_subscr == null)
					return false;

				Menu menu = new Menu ();
				menu.ref ();

				MenuItem item = new MenuItem.with_label (_("Properties"));
				item.activate += (item) => {
					var subscr_prefs = new SubscriptionPreferences (tmp_subscr);
					subscr_prefs.run ();
					tmp_subscr = null;
				};
				menu.append (item);

				menu.show_all ();
				menu.popup (null, null, null, event.button, event.time);
				return true;
			}
			return false;
		}
	}
}
