using GLib;
using Gtk;

namespace Cameron {
	class DateRenderer : CellRendererText {
		private long _date;
		public long date {
			get {
				return _date;
			}
			set {
				_date = value;
				var timestamp = Time.gm (value);
				var now = TimeVal ();
				now.get_current_time ();
				if (now.tv_sec - 43200 < value) // Twelve hours ago
					text = timestamp.format (_("%H:%M"));
				else if (now.tv_sec - 518400 < value) // Six days ago
					text = timestamp.format (_("%a %H:%M"));
				else if (now.tv_sec - 28857600 > value) // Eleven months ago
					text = timestamp.format (_("%b %d %Y"));
				else
					text = timestamp.format (_("%b %d %H:%M"));
			}
		}

		public DateRenderer () {}
	}

	class PercentRenderer : CellRendererProgress {
		private float _percent;
		public float percent {
			get {
				return _percent;
			}
			set {
				_percent = value;
				if (value >= 0 && value <= 1)
					this.value = (int) (value * 100);
				else if (value < 0)
					this.value = 0;
				else
					this.value = 100;
				if (value < 0 || value > 1)
					text = "Unknown";
				else
					text = "%.2f%%".printf (value * 100);
			}
		}

		public PercentRenderer () {}
	}

	class SizeRenderer : CellRendererText {
		static string[] prefixes = {"B", "kiB", "MiB", "GiB", "TiB"};
		private uint64 _size;
		public new uint64 size {
			get {
				return _size;
			}
			set {
				_size = value;
				double v = (double) value;
				var i = 0;
				while (v >= 1000.0 && i < prefixes.length) {
					v = v / 1024;
					i++;
				}
				text = "%.2f %s".printf (v, prefixes[i]);
			}
		}
	}
}
