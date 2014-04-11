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
    public class Food : Object {
        public int id { get; set; }
        public string name { get; set; }
        public int kcal { get; set; }

        public static string create_query = """
            CREATE TABLE IF NOT EXISTS 
            food (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                kcal INTEGER
            )
        """;

        public Food () {
            ; 
        }    

        public static List<Food> get_all () {
            return Calorie.Database.get_instance ().get_all_food ();
        }

        public static Food get_one (int id) {
            return Calorie.Database.get_instance ().get_food_by_id (id);
        }

        public void save () {
            if (id == 0) {
                Calorie.Database.get_instance ().add_food (this);
            } else {
                Calorie.Database.get_instance ().update_food (this); 
            }
        }
    }
}
