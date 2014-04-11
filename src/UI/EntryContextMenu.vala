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
    public class EntryContextMenu : Gtk.Menu {
        public signal void entry_remove_clicked ();

        public Gtk.MenuItem edit_item;
        public Gtk.MenuItem remove_item;

        public EntryContextMenu () {
            edit_item = new Gtk.MenuItem.with_label (_("Edit")); 
            remove_item = new Gtk.MenuItem.with_label (_("Remove")); 

            //edit_item.activate.connect(() => on_edit_click());
            //append (edit_item);

            remove_item.activate.connect(() => on_remove_click());
            append (remove_item);

            show_all ();
        } 

        void on_edit_click () {
        }

        void on_remove_click () {
            entry_remove_clicked ();
        }
    }
}
