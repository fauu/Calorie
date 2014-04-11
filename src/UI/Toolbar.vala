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
    public class Toolbar : Gtk.Toolbar {
        public Gtk.ToolButton button_add_food { get; private set; }
        public Widgets.DatePickerWithButtons date_picker { get; private set; }
        public ApplicationMenu calorie_menu { get; private set; }
        public Granite.Widgets.AppMenu app_menu { get; private set; }  

        public Toolbar () {
            hexpand = true;
            vexpand = false;

            button_add_food = new Gtk.ToolButton (null, null);
            button_add_food.icon_name = "list-add";
            button_add_food.tooltip_text = _("Add Food");

            var toolitem_date_picker = new Gtk.ToolItem();
            date_picker = new Widgets.DatePickerWithButtons ();
            toolitem_date_picker.add (date_picker);

            calorie_menu = new ApplicationMenu ();
            app_menu = new Granite.Widgets.AppMenu (calorie_menu);

            insert (button_add_food, -1);
            insert (make_spacer (), -1);
            insert (toolitem_date_picker, -1);
            insert (make_spacer (), -1);
            insert (app_menu, -1);
        }

        Gtk.ToolItem make_spacer () {
            var spacer = new Gtk.ToolItem ();
            spacer.set_expand (true);

            return spacer;
        }
    }
}
