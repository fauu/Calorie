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
    public class ApplicationMenu : Gtk.Menu {
       public Gtk.MenuItem item_about { get; private set; }  
       public Gtk.MenuItem item_configure_meal_names { get; private set; }  

       public ApplicationMenu () {
           item_configure_meal_names = new Gtk.MenuItem.with_label (_("Customize Meal Names"));

           var separator = new Gtk.SeparatorMenuItem ();

           item_about = new Gtk.MenuItem.with_label (_("About"));

           append (item_configure_meal_names);
           append (separator);
           append (item_about);
       }
    }
}
