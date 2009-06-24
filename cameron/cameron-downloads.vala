using GLib;
using Gtk;

namespace Cameron {
	class Downloads : GLib.Object {
		ListStore store = null;

		bool is_items = false;
		bool is_item = false;
		bool is_date = false;
		bool is_name = false;
		bool is_progress = false;
		bool is_size = false;
		bool is_id = false;
		bool is_save_path = false;
		bool is_url = false;
		bool is_description = false;

		long date = 0;
		string name = null;
		float progress = -1.0;
		uint64 size = 0;
		string id = null;
		string save_path = null;
		string url = null;
		string description = null;

		public Downloads (ListStore store) {
			this.store = store;
			
			string downloads_contents;
			try {
				FileUtils.get_contents (
					Config.get_downloads_file (),
					out downloads_contents);
				MarkupParser markupParser = {
					(context, element_name, attribute_names, 
							attribute_values) => {
						if (element_name == "items")
							is_items = true;
						else if (element_name == "item")
							is_item = true;
						else if (element_name == "date")
							is_date = true;
						else if (element_name == "name")
							is_name = true;
						else if (element_name == "progress")
							is_progress = true;
						else if (element_name == "size")
							is_size = true;
						else if (element_name == "id")
							is_id = true;
						else if (element_name == "save_path")
							is_save_path = true;
						else if (element_name == "url")
							is_url = true;
						else if (element_name == "description")
							is_description = true;
					},
					(context, element_name) => {
						if (element_name == "items")
							is_items = false;
						else if (element_name == "item") {
							DownloadProxy dl = new DownloadProxy (null);
							dl.id = id;
							dl.save_path = save_path;
							dl.feed_url = url;
							dl.description = description;
							dl.title = name;

							TreeIter iter;
							this.store.append (out iter);
							this.store.set (iter,
								0, date,
								1, name,
								2, progress,
								3, size,
								4, dl,
								-1);
							is_item = false;
						} else if (element_name == "date")
							is_date = false;
						else if (element_name == "name")
							is_name = false;
						else if (element_name == "progress")
							is_progress = false;
						else if (element_name == "size")
							is_size = false;
						else if (element_name == "id")
							is_id = false;
						else if (element_name == "save_path")
							is_save_path = false;
						else if (element_name == "url")
							is_url = false;
						else if (element_name == "description")
							is_description = false;
					},
					(context, text, text_len) => {
						if (is_items && is_item && is_date)
							date = text.to_int ();
						else if (is_items && is_item && is_name)
							name = text;
						else if (is_items && is_item && is_progress)
							progress = text.to_int ();
						else if (is_items && is_item && is_size)
							size = text.to_int ();
						else if (is_items && is_item && is_id)
							id = text;
						else if (is_items && is_item && is_save_path)
							save_path = text;
						else if (is_items && is_item && is_url)
							url = text;
						else if (is_items && is_item && is_description)
							description = text;
					},
					null,
					null
				};

				MarkupParseContext parser = new MarkupParseContext (
					markupParser,
					MarkupParseFlags.TREAT_CDATA_AS_TEXT,
					this,
					null);

				try {
					parser.parse (downloads_contents, downloads_contents.length);
					parser.end_parse ();
				} catch (GLib.MarkupError ex) {
					stdout.printf ("Error: %s\n", ex.message);
				}
			}
			catch (GLib.FileError ex) {}
			
			store.row_changed += (model, path, iter) => {
				save ();
			};

			store.row_deleted += (model, path) => {
				save ();
			};

			/*store.row_inserted += (model, path, iter) => {
				save ();
			};*/
		}

		private void save () {
			TreeIter iter;
			if (!store.get_iter_first (out iter))
				return;
			var builder = new StringBuilder ();
			do {
				long date;
				string name;
				float progress;
				uint64 size;
				DownloadProxy dl;
				store.get (iter,
					0, out date,
					1, out name,
					2, out progress,
					3, out size,
					4, out dl,
					-1);
				builder.append ("\t<item>\n" +
					"\t\t<date>%li</date>\n".printf (date) +
					"\t\t<name>%s</name>\n".printf (
						Markup.escape_text (name != null ? name : "")) +
					"\t\t<progress>%f</progress>\n".printf (progress) +
					"\t\t<size>%llu</size>\n".printf (size) +
					"\t\t<id>%s</id>\n".printf (
						Markup.escape_text (dl.id != null ? dl.id : "")) +
					"\t\t<save_path>%s</save_path>\n".printf (
						Markup.escape_text (
							dl.save_path != null ? dl.save_path : "")) +
					"\t\t<url>%s</url>\n".printf (
						Markup.escape_text (
							dl.feed_url != null ? dl.feed_url : "")) +
					"\t\t<description>%s</description>\n".printf (
						Markup.escape_text (
							dl.description != null ? dl.description : "")) +
					"\t</item>\n");
			} while (store.iter_next (ref iter));

			builder.prepend ("<items>\n");
			builder.append ("</items>\n");
			var file = File.new_for_path (Config.get_downloads_file () + "~");
			{
				var file_stream = file.replace (null, false, FileCreateFlags.NONE, null);
				var data_stream = new DataOutputStream (file_stream);
				data_stream.put_string (builder.str, null);
			}
			var real_file = File.new_for_path (Config.get_downloads_file ());
			file.move (real_file, FileCopyFlags.OVERWRITE, null, null);
		}
	}
}
