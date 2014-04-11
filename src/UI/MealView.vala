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
    public class MealView : Gtk.Grid {
        public Calorie.Model.Meal meal { get; private set; }
        public List<EntryView> views_entry = new List<EntryView> ();

        public MealView (Calorie.Model.Meal meal) {
            orientation = Gtk.Orientation.VERTICAL;
            hexpand = true;

            var grid_header = new Gtk.Grid ();
            grid_header.margin_bottom = 6;

            var label_name = new Gtk.Label
                ("<span weight='bold' font_size='larger'>" 
                 + meal.name + 
                 "</span>");
            label_name.use_markup = true;
            label_name.set_alignment (0.0f, 0.5f);
            label_name.margin_right = 10;
            grid_header.add (label_name);

            var horizontal_line = new Gtk.Separator 
                (Gtk.Orientation.HORIZONTAL);
            horizontal_line.hexpand = true;
            grid_header.add (horizontal_line);

            add(grid_header);
        } 
        
        public void add_entry_view(Calorie.Model.Entry entry) {
            EntryView view_entry = new EntryView (entry);

            Calorie.Utils.apply_css 
                (view_entry, "GtkEventBox", "background-color: @base_color");

            views_entry.append (view_entry); 
            add (view_entry);
        }

        public void clear () {
            views_entry.foreach ((ve) => {
                views_entry.remove (ve);
                remove (ve);
                ve.destroy ();
            });
        }
    }
}
