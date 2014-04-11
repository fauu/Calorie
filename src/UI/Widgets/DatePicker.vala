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

namespace Calorie.UI.Widgets {
    public class DatePicker : Granite.Widgets.DatePicker {
        public signal void date_picked ();

        construct {
            calendar.day_selected_double_click.connect
                (on_calendar_day_selection); 
        }

        public DatePicker () {
            base ();
        } 

        public DatePicker.with_format (string format) {
            base.with_format (format); 
        }

        void on_calendar_day_selection () {
            date = new DateTime.local (calendar.year, calendar.month + 1, calendar.day, 0, 0, 0);

            date_picked ();
        }
    }
}
