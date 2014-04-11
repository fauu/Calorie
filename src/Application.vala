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

namespace Calorie {
    public static int main (string[] args) {
        Gtk.init (ref args);

        return new Application ().run (args);
    }

    public class Application : Granite.Application {
        construct {
            program_name = "Calorie";
            exec_name = "calorie";
            app_years = "2013";
            app_icon = "calorie";
            app_launcher = "calorie.desktop";
            application_id = "org.pantheon.calorie";
            main_url = "https://launchpad.net/calorie";
            bug_url = "https://bugs.launchpad.net/calorie";
            help_url = "https://answers.launchpad.net/calorie";
            translate_url = "https://translations.launchpad.net/calorie";
            about_authors = {
                "Piotr Grabowski <fau999@gmail.com>"
            };
            about_artists = {};
            about_comments = null;
            about_documenters = {};
            about_translators = null;
            about_license_type = Gtk.License.GPL_3_0;
        }

        Gtk.Window window;
        UI.Toolbar toolbar;
        UI.DiaryView view_diary;
        UI.SummaryView view_summary;

        DateTime selected_date;

        protected override void activate () {
            if (get_windows () != null) {
                get_windows ().data.present ();
                return;
            } 
            
            /* Ugly workaround */
            var meal = new Model.Meal ();
            var entry = new Model.Entry ();
            var food = new Model.Food ();

            init_ui ();
            init_model ();

            update_view (true);

            Gtk.main ();
        }

        void init_ui () {
            window = new Gtk.Window ();
            window.title = "Calorie";
            window.set_size_request (360, 420);
            window.set_application (this);
            window.window_position = Gtk.WindowPosition.CENTER;
            Utils.apply_css 
                (window, "GtkWindow", "background-color: @base_color");

            toolbar = new UI.Toolbar ();
            toolbar.calorie_menu.item_about.activate.connect 
                (() => show_about (window));
            toolbar.calorie_menu.item_configure_meal_names.activate.connect
                (on_configure_meal_names_click);
            toolbar.date_picker.button_left.clicked.connect 
                (on_date_back_click);
            toolbar.date_picker.button_right.clicked.connect 
                (on_date_forward_click);
            toolbar.date_picker.date_picker.date_picked.connect 
                (on_date_pick);
            toolbar.button_add_food.clicked.connect 
                (on_add_food_click);

            var scrolled_window_view_diary = 
                new Gtk.ScrolledWindow (null, null);

            view_diary = new UI.DiaryView ();
            view_diary.button_add_entry.clicked.connect 
                (on_add_food_click);
            scrolled_window_view_diary.add_with_viewport (view_diary);

            view_summary = new UI.SummaryView ();

            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.add (toolbar);
            grid.add (scrolled_window_view_diary);
            grid.add (view_summary);

            window.add (grid);

            add_window (window);

            window.destroy.connect (Gtk.main_quit);

            window.show_all ();
        }

        void init_model () {
            selected_date = new DateTime.now_local ();
        }

        void update_view (bool? full = false) {
            if (full) {
                toolbar.date_picker.set_date (selected_date);
            }

            update_diary_view (full);
            update_summary_view ();
        }

        void update_diary_view (bool? full = false) {
            List<Model.Entry> entries = Model.Entry.get_by_date (selected_date);

            entries.foreach((e) => {
                e.deleted.connect (on_entry_removal);
            });

            if (full) {
                List<Model.Meal> meals = Model.Meal.get_all ();

                view_diary.update (entries, meals);
            } else {
                view_diary.update (entries);
            }
        }

        void update_summary_view () {
            view_summary.update 
                (Model.Entry.get_kcal_total_by_date (selected_date));
        }

        void on_date_back_click () {
            selected_date = selected_date.add_days (-1); 

            update_view (true);
        }

        void on_date_forward_click () {
            selected_date = selected_date.add_days (1); 

            update_view (true);
        }

        void on_date_pick () {
            update_view (true);
        }

        void on_add_food_click () {
            UI.Dialogs.AddFoodDialog dialog 
                = new UI.Dialogs.AddFoodDialog (window, selected_date);
            dialog.entry_added.connect (on_food_entry_addition);
        }

        void on_food_entry_addition () {
            update_view ();
        }

        void on_entry_removal () {
            update_view ();
        }

        void on_configure_meal_names_click() {
            UI.Dialogs.ConfigureMealNamesDialog dialog 
                = new UI.Dialogs.ConfigureMealNamesDialog 
                    (window, Model.Meal.get_all());
            dialog.meal_list_modified.connect (on_meal_list_modification);

            dialog.show_all ();
        }

        void on_meal_list_modification () {
            update_view (true);
        }
    }
}
