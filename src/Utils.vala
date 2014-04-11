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

namespace Calorie.Utils {
    public static void apply_css (Gtk.Widget widget, string css_class,
                                  string css) {
        string full_css = css_class + """ {
            """ + css + """
        } """;

        Granite.Widgets.Utils.set_theming (widget, full_css, null, 999);
    }
}
