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
    public class ConfigureMealNamesDialog : Granite.Widgets.LightWindow {
        Gtk.ListStore store;
        Gtk.TreeIter iter;
        Gtk.TreeView view;
        Gtk.TreeViewColumn column;

        public signal void meal_list_modified ();

        public ConfigureMealNamesDialog (Gtk.Window window, List<Calorie.Model.Meal> meals) {
            title = _("Customize Meal Names");

            window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
            type_hint = Gdk.WindowTypeHint.DIALOG;
            transient_for = window;

            store = new Gtk.ListStore(2, typeof (int), typeof (string));

            foreach (Calorie.Model.Meal m in meals) {
                store.append (out iter);
                store.set (iter, 0, m.id, 1, m.name);
            }

            var renderer = new Gtk.CellRendererText ();
            renderer.editable = true;
            renderer.edited.connect ((row, val) => on_cell_edit(row, val));

            column = new Gtk.TreeViewColumn ();
            column.pack_start (renderer, true);
            column.add_attribute (renderer, "text", 1);

            view = new Gtk.TreeView.with_model (store);
            view.hexpand = true;
            view.vexpand = true;
            view.headers_visible = false;
            view.append_column (column);

            var view_window = new Gtk.ScrolledWindow (null, null);
            view_window.set_size_request (220, 158);
            view_window.shadow_type = Gtk.ShadowType.IN;
            view_window.add (view);

            var container = new Gtk.Grid ();
            container.margin_left = 20;
            container.margin_right = 20;
            container.margin_top = 10;
            container.set_row_spacing (8);
            container.set_column_spacing (10);
            container.hexpand = true;
            container.vexpand = true;
            container.add (view_window);

            add (container);

            var buttons_grid_tmp = new Gtk.Grid ();
            buttons_grid_tmp.margin_left = 20; buttons_grid_tmp.margin_right = 20;
            buttons_grid_tmp.margin_bottom = 10;
            buttons_grid_tmp.margin_top = 8;
            buttons_grid_tmp.set_row_spacing (5);
            buttons_grid_tmp.set_orientation (Gtk.Orientation.HORIZONTAL);
            buttons_grid_tmp.hexpand = true;
            buttons_grid_tmp.vexpand = false;

            var edit_button_label = new Gtk.Label (_("Edit"));
            edit_button_label.margin_top = 2;
            edit_button_label.margin_bottom = 2;
            edit_button_label.margin_left = 8;
            edit_button_label.margin_right = 8;
            var edit_button = new Gtk.Button ();
            edit_button.add (edit_button_label);

            var finish_button_label = new Gtk.Label (_("Finish"));
            finish_button_label.margin_top = 2;
            finish_button_label.margin_bottom = 2;
            finish_button_label.margin_left = 8;
            finish_button_label.margin_right = 8;
            var finish_button = new Gtk.Button ();
            finish_button.add (finish_button_label);
            finish_button.halign = Gtk.Align.END;
            finish_button.hexpand = true;

            buttons_grid_tmp.add (edit_button);
            buttons_grid_tmp.add (finish_button);

            /*
            var buttons_grid = new Gtk.Grid ();
            buttons_grid.margin_left = 12;
            buttons_grid.margin_right = 12;
            buttons_grid.margin_bottom = 12;
            buttons_grid.set_row_spacing (5);
            buttons_grid.set_orientation (Gtk.Orientation.HORIZONTAL);
            buttons_grid.hexpand = true;
            buttons_grid.vexpand = false;

            var addrem_grid = new Gtk.Grid ();
            addrem_grid.set_orientation (Gtk.Orientation.HORIZONTAL);
            var add_button_label = new Gtk.Label ("+");
            add_button_label.margin_left = 4;
            add_button_label.margin_right = 4;
            var add_button = new Gtk.Button ();
            add_button.add (add_button_label);
            var remove_button_label = new Gtk.Label ("-");
            remove_button_label.margin_left = 4;
            remove_button_label.margin_right = 4;
            var remove_button = new Gtk.Button ();
            remove_button.add (remove_button_label);
            addrem_grid.add (add_button);
            addrem_grid.add (remove_button);

            var save_button_label = new Gtk.Label (_("Save"));
            save_button_label.margin_left = 4;
            save_button_label.margin_right = 4;
            var save_button = new Gtk.Button ();
            save_button.add (save_button_label);
            save_button.hexpand = true;
            save_button.halign = Gtk.Align.END;

            buttons_grid.add (addrem_grid);
            buttons_grid.add (save_button);

            add (buttons_grid);
            */

            add (buttons_grid_tmp);

            //add_button.clicked.connect (() => on_add_button_click ());
            //remove_button.clicked.connect (() => on_remove_button_click ());
            edit_button.clicked.connect (() => on_edit_button_click ());
            finish_button.clicked.connect (() => on_finish_button_click ());
        }  

        void on_cell_edit (string row, string val) {
            Gtk.TreePath path = new Gtk.TreePath.from_string (row);

            store.get_iter (out iter, path);

            if (val == "") {
                //store.remove (iter);       
                ;
            } else {
                Value meal_id;

                store.set (iter, 1, val);

                store.get_value (iter, 0, out meal_id);

                Calorie.Model.Meal meal = Calorie.Model.Meal.get_one ((int) meal_id);

                if (meal.name == val)
                    return;

                meal.name = val; 
                        
                meal.save ();

                meal_list_modified ();
            }
        }

        void on_edit_button_click () {
            Gtk.TreeIter temp_iter;
            Gtk.TreeModel model;

            var selection = view.get_selection ();

            if (selection.get_selected (out model, out temp_iter)) {
                view.set_cursor (store.get_path (temp_iter), column, true);
            }
        }

        void on_finish_button_click () {
            destroy (); 
        }

        /*
        void on_add_button_click () {
            Gtk.TreePath path;
            store.append (out iter);
            store.set (iter, 0, 0, 1, "");

            path = store.get_path (iter);
            view.set_cursor (path, column, true);
        }

        void on_remove_button_click () {
            Gtk.TreeIter temp_iter;
            Gtk.TreeModel model; //

            var selection = view.get_selection ();

            if (selection.get_selected (out model, out temp_iter)) {
                store.remove (temp_iter);
            }
        }
        */
    }
}
