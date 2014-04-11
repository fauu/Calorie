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
    public class Meal {
        public int id { get; set; }
        public string name { get; set; }

        public static string create_query = """
            CREATE TABLE IF NOT EXISTS 
            meals (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT
            )
        """;
            
        public static string defaults_query = """
            INSERT INTO meals (name)
            VALUES ('Breakfast'); 
            INSERT INTO meals (name)
            VALUES ('Second Breakfast');
            INSERT INTO meals (name)
            VALUES ('Lunch');
            INSERT INTO meals (name)
            VALUES ('Dinner');
            INSERT INTO meals (name)
            VALUES ('Supper');
            INSERT INTO meals (name)
            VALUES ('Snacks');
        """;

        public Meal () {
            ;
        }

        public void save () {
            if (id != 0) { // Update, not an insert
                Calorie.Database.get_instance ().update_meal (this); 
            }
        }

        public static List<Meal?> get_all () {
            return Calorie.Database.get_instance ().get_all_meals ();
        }

        public static Meal get_one (int id) {
            return Calorie.Database.get_instance ().get_meal_by_id (id);
        }
    }
}
