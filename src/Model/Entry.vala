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

namespace Calorie.Model {
    public class Entry {
        public signal void deleted ();

        public int? id { get; set; }
        public int meal_id { get; set; }
        public int food_id { get; set; }
        public string name { get; set; }
        public DateTime date { get; set; }
        public int kcal { get; set; } 
        public int servings { get; set; } 

        public static string create_query = """
            CREATE TABLE IF NOT EXISTS 
            entries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                meal_id INTEGER,
                food_id INTEGER,
                date TEXT,
                kcal INTEGER,
                servings INTEGER,
                FOREIGN KEY(meal_id) REFERENCES meals(id),
                FOREIGN KEY(food_id) REFERENCES food(id)
            )
       """; 

        public Entry () {
            ; 
        }

        public void save() {
            Calorie.Database.get_instance ().add_entry (this); 
        }

        public static List<Entry?> get_by_date (DateTime date) {
            return Calorie.Database.get_instance ().get_entries_by_date (date);
        }

        public static int get_kcal_total_by_date (DateTime date) {
            return Calorie.Database.get_instance ()
                .get_kcal_total_by_date (date); 
        }

        public void delete () {
            Calorie.Database.get_instance ().delete_entry (this);

            deleted ();
        }
    }
}
