/*
 * Copyright (C) 2013 Calorie Developers (http://launchpad.net/calorie)
 *
 * This software is licensed under the GNU General Public License
 * (version 3 or later). See the COPYING file in this distribution.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this software. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Piotr Grabowski <fau999@gmail.com>
 */

namespace Calorie.UI.Widgets {
    public class DatePickerWithButtons : Gtk.Grid {
        public Gtk.Button button_left { get; private set; }
        public DatePicker date_picker { get; private set; }
        public Gtk.Button button_right { get; private set; }
        
        public DatePickerWithButtons () {
            row_homogeneous = false;
            valign = Gtk.Align.CENTER;

            date_picker = new DatePicker.with_format ("%B %e, %Y");

            button_left = new Gtk.Button ();
            button_left.relief = Gtk.ReliefStyle.NONE;
            var arrow_left = new Gtk.Arrow
                (Gtk.ArrowType.LEFT, Gtk.ShadowType.NONE);
            arrow_left.margin_left = 3;
            button_left.add (arrow_left);

            button_right = new Gtk.Button ();
            button_right.relief = Gtk.ReliefStyle.NONE;
            var arrow_right = new Gtk.Arrow 
                (Gtk.ArrowType.RIGHT, Gtk.ShadowType.NONE);
            arrow_right.margin_left = 1;
            arrow_right.margin_right = 1;
            button_right.add (arrow_right);

            add (button_left);
            add (date_picker);
            add (button_right);
        }

        public void set_date (DateTime dt) {
            date_picker.date = dt; 
        }

        public DateTime get_date () {
            return date_picker.date;
        }
    }
}
