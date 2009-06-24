using GLib;
using Gee;

namespace Cameron {
	class SubscriptionManager : GLib.Object {
		[Description(nick="Subscriptions", 
			blurb="A list of feeds we're subscribed to")]
		public ArrayList<Subscription> subscriptions {get; private set;}
		public signal void subscription_added (Subscription subscription);
		public signal void subscription_deleted (Subscription subscription);
		public signal void subscription_changed (Subscription subscription);
	
		bool is_subscriptions = false;
		bool is_subscription = false;
		bool is_name = false;
		bool is_url = false;
		bool is_save_dir = false;
		string name = null;
		string url = null;
		string save_dir = null;

		private SubscriptionManager () {}
		private static SubscriptionManager mngr;

		public static SubscriptionManager instance () {
			if (mngr == null) {
				mngr = new SubscriptionManager ();
				mngr.ref ();
			}
			return mngr;
		}
	
		construct {
			if (!(subscriptions is ArrayList<Subscription>)) {
				subscriptions = new ArrayList<Subscription> ();
			}

			string config_contents;
			try {
				FileUtils.get_contents (
					Config.get_subscription_file (),
					out config_contents);

				MarkupParser markupParser = {
					(context, element_name, attribute_names, 
							attribute_values) => {
						if (element_name == "subscriptions")
							is_subscriptions = true;
						else if (element_name == "subscription")
							is_subscription = true;
						else if (element_name == "name")
							is_name = true;
						else if (element_name == "url")
							is_url = true;
						else if (element_name == "save_dir")
							is_save_dir = true;
					},
					(context, element_name) => {
						if (element_name == "subscriptions")
							is_subscriptions = false;
						else if (element_name == "subscription") {
							if (is_subscription && url != null) {
								var subscr = new Subscription (url, name, save_dir);
								subscr.changed += (subscr) => {
									subscription_changed (subscr);
								};
								this.subscriptions.add (subscr);
								url = name = save_dir = null;
							}
							is_subscription = false;
						}
						else if (element_name == "name")
							is_name = false;
						else if (element_name == "url")
							is_url = false;
						else if (element_name == "save_dir")
							is_save_dir = false;
					},
					(context, text, text_len) => {
						if (is_subscriptions && is_subscription && is_save_dir)
							save_dir = text;
						else if (is_subscriptions && is_subscription && is_url)
							url = text;
						else if (is_subscriptions && is_subscription && is_name)
							name = text;
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
					parser.parse (config_contents, config_contents.length);
					parser.end_parse ();
				} catch (GLib.MarkupError ex) {
					stdout.printf ("Error: %s\n", ex.message);
				}
			}
			catch (GLib.FileError ex) {
				stdout.printf ("Couldn't open config file: %s\n", ex.message);
			}
			subscription_added += (url) => {
				save_subscriptions ();
			};
			subscription_deleted += (url) => {
				save_subscriptions ();
			};
			subscription_changed += (url) => {
				save_subscriptions ();
			};
		}

		public void add_subscription (
				string url, 
				string name, 
				string? save_dir) {
			var subscr = new Subscription (url, name, save_dir);
			subscriptions.add (subscr);
			subscr.changed += (subscr) => {
				subscription_changed (subscr);
			};
			subscription_added (subscr);
		}

		public void save_subscriptions () {
			string filecontents = "<subscriptions>\n%s</subscriptions>\n";
			string[] subscription_elements = new string[subscriptions.size];
			for (int i = 0; i < subscriptions.size; i++) {
				subscription_elements[i] = subscriptions[i].to_xml ();
			}
			filecontents = filecontents.printf (
				string.joinv ("", subscription_elements));
			
			var file = File.new_for_path (Config.get_subscription_file () + "~");
			{
				var file_stream = file.replace (null, false, FileCreateFlags.NONE, null);
				var data_stream = new DataOutputStream (file_stream);
				data_stream.put_string (filecontents, null);
			}
			var real_file = File.new_for_path (Config.get_subscription_file ());
			file.move (real_file, FileCopyFlags.OVERWRITE, null, null);
		}
	}
}
