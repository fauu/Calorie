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
    public class EntryView : Gtk.EventBox {
        Calorie.Model.Entry entry;
        Gtk.Grid grid;
        Gtk.Label label_name;
        EntryContextMenu context_menu;

        public EntryView (Calorie.Model.Entry entry) {
            grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.HORIZONTAL;

            this.entry = entry;

            var grid_name = new Gtk.Grid ();
            grid_name.hexpand = true;

            label_name = new Gtk.Label (entry.name);
            label_name.halign = Gtk.Align.START;
            label_name.margin_top = 6;
            label_name.margin_bottom = 6;

            var label_servings = new Gtk.Label 
                ("×" + "%d".printf(entry.servings));
            label_servings.margin_left = 5;
            Utils.apply_css 
                (label_servings, "GtkLabel", "color: @insensitive_color");

            grid_name.add (label_name);
            if (entry.food_id > 0) 
                grid_name.add (label_servings);

            var grid_kcal = new Gtk.Grid ();
            grid_kcal.margin_top = 6;
            grid_kcal.margin_bottom = 6;

            var label_kcal_val = new Gtk.Label 
                ("<b>" + "%d".printf(entry.kcal) + "</b>");
            label_kcal_val.use_markup = true;
            label_kcal_val.margin_right = 3;

            var label_kcal_unit = new Gtk.Label ("<small>kcal</small>");
            label_kcal_unit.valign = Gtk.Align.END;
            label_kcal_unit.use_markup = true;

            grid_kcal.add (label_kcal_val);
            grid_kcal.add (label_kcal_unit);

            grid.add (grid_name);
            grid.add (grid_kcal);

            add (grid);

            button_press_event.connect
                ((widget, event) => on_button_press (widget, event));
            enter_notify_event.connect (on_mouse_enter);
            leave_notify_event.connect (on_mouse_leave);
        } 

        bool on_button_press (Gtk.Widget widget, Gdk.EventButton event) {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                var event_button = (Gdk.EventButton) event;
                
                if (event_button.button == 3) {
                    if (context_menu == null)
                        context_menu = new EntryContextMenu ();

                    context_menu.entry_remove_clicked.connect
                        (on_entry_remove_click);

                    context_menu.popup (null, null, null, event_button.button,
                                        event_button.time);

                    return true;
                }
            }
            
            return false;
        }
        
        bool on_mouse_enter () {
            Utils.apply_css 
                (label_name, "GtkLabel", "color: @selected_bg_color");

            return true;
        }

        bool on_mouse_leave () {
            Utils.apply_css 
                (label_name, "GtkLabel", "color: @fg_color");

            return true; 
        }

        void on_entry_remove_click () {
            entry.delete (); 
        }
    }
}
