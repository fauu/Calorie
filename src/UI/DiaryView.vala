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
    public class DiaryView : Gtk.Grid {
        public Gtk.Button button_add_entry { get; private set; }

        List<MealView> views_meal = new List<MealView> ();
        Gtk.Grid grid_empty_msg;

        public DiaryView () {
            orientation = Gtk.Orientation.VERTICAL;
            hexpand = true;
            vexpand = true;
            row_spacing = 11;
            margin_top = 8;
            margin_right = 10;
            margin_bottom = 8;
            margin_left = 10;

            build_empty_msg ();
            add (grid_empty_msg);
        }  

        public void update (List<Calorie.Model.Entry> entries, 
                            List<Calorie.Model.Meal>? meals = null) {
            if (meals != null)
                update_meal_names (meals); 

            views_meal.foreach ((vm) => {
                vm.clear ();      
            });

            if (entries.length() > 0) {
                grid_empty_msg.hide ();

                entries.foreach ((e) => {
                    /* This is bad, meal_ids wont't prob. always start at 0 */
                    (views_meal.nth_data (e.meal_id  - 1)).add_entry_view (e);
                });
            } else {
                grid_empty_msg.show ();
            }

            views_meal.foreach ((vm) => {
                vm.hide ();

                if (vm.views_entry.length() > 0)
                    vm.show_all();
            });
        }

        void build_empty_msg () {
            grid_empty_msg = new Gtk.Grid ();
            grid_empty_msg.orientation = Gtk.Orientation.VERTICAL;
            grid_empty_msg.hexpand = true;
            grid_empty_msg.vexpand = true;
            grid_empty_msg.halign = Gtk.Align.CENTER;
            grid_empty_msg.valign = Gtk.Align.CENTER;
            grid_empty_msg.row_spacing = 25;

            var label_empty_msg = new Gtk.Label ("<span font_size='larger'>"
                    + _("There are no entries for the selected day yet.") 
                    + "</span>");
            label_empty_msg.use_markup = true;

            var label_add_entry = new Gtk.Label (_("Add Entry"));
            label_add_entry.margin_left = 8;
            label_add_entry.margin_right = 8;
            label_add_entry.margin_top = 2;
            label_add_entry.margin_bottom = 2;
            button_add_entry = new Gtk.Button ();
            button_add_entry.add (label_add_entry);
            button_add_entry.halign = Gtk.Align.CENTER;

            grid_empty_msg.add (label_empty_msg);
            grid_empty_msg.add (button_add_entry);

            grid_empty_msg.show_all ();
        }

        void update_meal_names (List<Calorie.Model.Meal> meals) {
            views_meal.foreach ((vm) => {
                views_meal.remove (vm);
                vm.destroy ();
            });

            meals.foreach ((m) => {
                views_meal.append (new MealView (m));      
            });

            views_meal.foreach ((vm) => {
                add (vm);      
                vm.hide ();
            });
        }
    }
}
