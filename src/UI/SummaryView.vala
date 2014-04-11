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

namespace Calorie.UI {
    Gtk.Label kcal_total_name_label;
    Gtk.Label kcal_total_value_label;
    Gtk.Label kcal_total_unit_label;

    public class SummaryView : Gtk.Grid {
        public SummaryView () {
            orientation = Gtk.Orientation.HORIZONTAL;
            hexpand = true;
            vexpand = false;
            margin_top = 8;
            margin_bottom = 8;
            margin_left = 10;
            margin_right = 10;
        }

        public void update (int kcal_total) {
            remove (kcal_total_name_label);
            remove (kcal_total_value_label);
            remove (kcal_total_unit_label);

            if (kcal_total <= 0)
                return;

            kcal_total_name_label = new Gtk.Label 
                        ("<span font_size='x-large'>" + _("Total:") + "</span>");
            kcal_total_name_label.use_markup = true;
            kcal_total_name_label.hexpand = true;
            kcal_total_name_label.halign = Gtk.Align.START;

            kcal_total_value_label = new Gtk.Label 
                        ("<span weight='bold' font_size='xx-large'>" +  "%d".printf(kcal_total) + "</span>");
            kcal_total_value_label.use_markup = true;
            kcal_total_value_label.valign = Gtk.Align.END;
            kcal_total_value_label.margin_right = 5;
            
            kcal_total_unit_label = new Gtk.Label 
                        ("<span font_size='larger'>" + "kcal" + "</span>");
            kcal_total_unit_label.use_markup = true;
            kcal_total_unit_label.margin_bottom = 1;
            kcal_total_unit_label.valign = Gtk.Align.END;

            add (kcal_total_name_label);
            add (kcal_total_value_label);
            add (kcal_total_unit_label);
            
            show_all ();
        }
    }
}
