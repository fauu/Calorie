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

namespace Calorie.UI.Dialogs {
    public class AddFoodDialog : Granite.Widgets.LightWindow {
        public signal void entry_added ();

        List<Calorie.Model.Food?> food;
        Granite.Widgets.HintedEntry entry_name;
        Gtk.ListStore store_meals;
        Gtk.ComboBox combo_meal;
        Gtk.Label label_kcal;
        Gtk.Label label_per_serving;
        Gtk.Entry entry_kcal;
        Gtk.SpinButton spin_servings;

        DateTime date;

        public AddFoodDialog (Gtk.Window window, DateTime date) {
            title = _("Add Food Diary Entry");

            window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
            type_hint = Gdk.WindowTypeHint.DIALOG;
            transient_for = window;

            this.date = date;

            food = Calorie.Model.Food.get_all ();

            Gtk.EntryCompletion completion_name = new Gtk.EntryCompletion ();
            Gtk.ListStore store_names = new Gtk.ListStore
                (3, typeof (int), typeof (string), typeof (int)); 
            completion_name.set_model (store_names);
            completion_name.set_text_column (1);
            completion_name.set_inline_completion (true);
            Gtk.TreeIter iter_names;

            foreach (Calorie.Model.Food f in food) {
                store_names.append (out iter_names);
                store_names.set (iter_names, 0, f.id, 1, f.name, 2, f.kcal);
            }

            List<Calorie.Model.Meal?> meals = Calorie.Model.Meal.get_all ();
            store_meals = new Gtk.ListStore(2, typeof (int), typeof (string));
            Gtk.TreeIter iter_meals;

            foreach (Calorie.Model.Meal m in meals) {
                store_meals.append (out iter_meals);
                store_meals.set (iter_meals, 0, m.id, 1, m.name);
            }

            var grid = new Gtk.Grid ();
            grid.margin_left = 20;
            grid.margin_right = 20;
            grid.margin_top = 10;
            grid.margin_bottom = 20;
            grid.set_row_spacing (8);
            grid.set_column_spacing (15);

            var label_name = make_label(_("Name:"));
            label_name.halign = Gtk.Align.END;
            entry_name = new Granite.Widgets.HintedEntry 
                (_("Quick Added Calories"));
            entry_name.set_completion (completion_name);
            grid.attach (label_name, 0, 0, 1, 1);
            grid.attach (entry_name, 1, 0, 1, 1);

            var label_meal = make_label(_("Meal:"));
            label_meal.halign = Gtk.Align.END;
            combo_meal = new Gtk.ComboBox.with_model (store_meals);
            Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
            combo_meal.pack_start (renderer, true);
            combo_meal.add_attribute (renderer, "text", 1);
            combo_meal.active = 0;
            grid.attach (label_meal, 0, 1, 1, 1);
            grid.attach (combo_meal, 1, 1, 1, 1);

            var grid_kcal_per_serving = new Gtk.Grid ();
            label_kcal = make_label(_("Calories:"));
            label_kcal.halign = Gtk.Align.END;
            entry_kcal = new Gtk.Entry();
            entry_kcal.set_width_chars (4);
            label_per_serving = make_label (_("per serving"));
            label_per_serving.margin_left = 5;
            grid_kcal_per_serving.attach (entry_kcal, 0, 0, 1, 1);
            grid_kcal_per_serving.attach (label_per_serving, 1, 0, 1, 1);

            grid.attach (label_kcal, 0, 2, 1, 1);
            grid.attach (grid_kcal_per_serving, 1, 2, 1, 1);

            var label_servings = make_label (_("Servings:"));
            label_servings.halign = Gtk.Align.END;
            spin_servings = new Gtk.SpinButton.with_range (1, 999, 1);
            grid.attach (label_servings, 0, 3, 1, 1);
            grid.attach (spin_servings, 1, 3, 1, 1);

            var button_add = new Gtk.Button.with_label (_("Add"));
            grid.attach (button_add, 1, 4, 1, 1);

            add (grid);
            entry_kcal.grab_focus ();

            button_add.clicked.connect (on_add_button_click);
            entry_name.changed.connect (on_name_edit); 
            entry_name.focus_in_event.connect 
                (() => on_name_entry_focus_in ());
            entry_name.focus_out_event.connect 
                (() => on_name_entry_focus_out ());
            completion_name.match_selected.connect 
                ((model, iter) => on_name_match_selection (model, iter));

            show_all ();

            label_per_serving.hide ();
            spin_servings.sensitive = false;
        }  

        Gtk.Label make_label (string text) {
            var label = new Gtk.Label (text);
            label.use_markup = true;
            label.set_alignment (0.0f, 0.5f);

            return label;
        }

        void on_name_edit () {
            ;
        }

        bool on_name_entry_focus_in () {
            if (!label_per_serving.visible && !spin_servings.sensitive) {
                label_per_serving.show (); 
                spin_servings.sensitive = true;
            }

            return false;
        }

        bool on_name_entry_focus_out () {
            if (entry_name.get_text () == "" && label_per_serving.visible 
                && spin_servings.sensitive) {
                label_per_serving.hide (); 
                spin_servings.sensitive = false;
            }

            return false;
        }

        bool on_name_match_selection (Gtk.TreeModel model, Gtk.TreeIter iter) {
            Value kcal; 
            model.get_value (iter, 2, out kcal);
    
            entry_kcal.set_text ("%d".printf((int) kcal));

            return false;
        }

        void on_add_button_click () {
            string name = entry_name.get_text (); 
            int kcal = int.parse (entry_kcal.get_text ());
            Value meal_id;
            Gtk.TreeIter iter;

            combo_meal.get_active_iter (out iter);
            store_meals.get_value (iter, 0, out meal_id);

            if (kcal <= 0) {
                entry_kcal.grab_focus ();
            } else {
                var new_entry = new Calorie.Model.Entry ();

                new_entry.date = date;
                new_entry.meal_id = (int) meal_id;

                if (name == "") {
                    new_entry.kcal = kcal;
                    new_entry.food_id = 0;
                    new_entry.servings = 1;

                    new_entry.save ();
                } else {
                    int? food_id = null;
                    int? food_kcal = null;

                    foreach (Calorie.Model.Food f in food) {
                        if (name == f.name) {
                            food_id = f.id;
                            food_kcal = f.kcal;
                            break;
                        }
                    } 

                    if (food_id == null) {
                        var new_food = new Calorie.Model.Food ();  

                        new_food.name = name;
                        new_food.kcal = kcal;

                        new_food.save ();

                        new_entry.food_id = 
                            (int) Calorie.Database.get_instance ()
                                .last_insert_id;
                    } else {
                        if (food_kcal != kcal) {
                            var food_single = Calorie.Model.Food.get_one 
                                (food_id);

                            food_single.kcal = kcal;

                            food_single.save ();
                        }

                        new_entry.food_id = food_id;
                    }

                    new_entry.servings = 
                        int.parse (spin_servings.get_text ());

                    new_entry.save ();
                }

                entry_added ();

                destroy ();
            }
        }
    }
}
