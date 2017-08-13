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
    class Database {
        static Database instance = null;
        Sqlite.Database db; 
        string db_path;

        public int64 last_insert_id {
            get {
                return db.last_insert_rowid ();
            }
        }

        Database () {
            int rc = -1;


            var calorie_dir = Environment.get_home_dir () + "/.local/share/calorie/";
            DirUtils.create_with_parents (calorie_dir, 0766);
            db_path = calorie_dir + "calorie.db";
                      

            if (create_tables () != Sqlite.OK) {
                stderr.printf 
                    ("Error creating DB table: %d, %s\n", rc, db.errmsg ()); 
            }

            rc = Sqlite.Database.open (db_path, out db);

            if (rc != Sqlite.OK) {
                stderr.printf 
                    ("Can't open database: %d, %s\n", rc, db.errmsg ());  
                Gtk.main_quit ();
            }
        }

        public static Database get_instance () {
            if (instance == null)
                instance = new Database ();

            return instance;
        }

        int create_tables () {
            Sqlite.Statement statement;
            int rc, result;

            rc = Sqlite.Database.open (db_path, out db);

            if (rc != Sqlite.OK) {
                stderr.printf 
                    ("Can't open database: %d, %s\n", rc, db.errmsg ());       
                Gtk.main_quit ();
            }

            rc = db.exec (Model.Meal.create_query, null, null);
            rc = db.exec (Model.Entry.create_query, null, null);
            rc = db.exec (Model.Food.create_query, null, null);
    
            result = db.prepare_v2 
                ("SELECT COUNT(*) FROM meals", -1, out statement);
            assert (result == Sqlite.OK);

            result = statement.step ();
            assert (result == Sqlite.ROW);

            if (statement.column_int(0) == 0) {
                rc = db.exec (Model.Meal.defaults_query, null, null);
            }

            return rc;
        }

        /*
        * ENTRY
        */

        public int get_kcal_total_by_date (DateTime date) {
            Sqlite.Statement statement;
            int result;

            string q = """
                SELECT 
                    SUM(
                        CASE WHEN e.kcal > 0 THEN 
                            e.kcal 
                        ELSE 
                            e.servings * f.kcal 
                        END
                    ) 
                FROM entries e 
                LEFT JOIN food f 
                    ON e.food_id = f.id
                WHERE date = ?
            """;
            
            result = db.prepare_v2 (q, -1, out statement);
            assert (result == Sqlite.OK);

            result = statement.bind_text (1, date.format ("%F"));
            assert (result == Sqlite.OK);

            result = statement.step ();
            assert (result == Sqlite.ROW);

            return statement.column_int (0);
        }

        public List<Model.Entry?> get_entries_by_date (DateTime date) {
            Sqlite.Statement statement;
            int result;
            List<Model.Entry?> entries = new List<Model.Entry?> ();

            string q = """
                SELECT
                    e.id,
                    COALESCE(f.name, '""" + _("Quick Added Calories") + """'),
                    e.meal_id,
                    e.date,
                    e.servings,
                    e.food_id,
                    CASE WHEN e.kcal > 0 THEN
                        e.kcal
                    ELSE
                        e.servings * f.kcal
                    END
                FROM entries e
                LEFT JOIN food f 
                    ON e.food_id = f.id
                WHERE date = ? 
                ORDER BY meal_id ASC
            """;

            result = db.prepare_v2 (q, -1, out statement);
            assert (result == Sqlite.OK);

            result = statement.bind_text (1, date.format ("%F"));
            assert (result == Sqlite.OK);

            while ((result = statement.step()) == Sqlite.ROW) {
                DateTime entry_date;
                string[] date_parts = (statement.column_text (3)).split("-");

                entry_date = new DateTime.local (int.parse(date_parts[0]), 
                                                 int.parse(date_parts[1]),
                                                 int.parse(date_parts[2]), 
                                                 0, 0, 0);
                
                Model.Entry entry = new Model.Entry ();
                
                entry.id = statement.column_int (0);
                entry.name = statement.column_text (1);
                entry.meal_id = statement.column_int (2);
                entry.date = entry_date;
                entry.servings = statement.column_int (4);
                entry.food_id = statement.column_int (5);
                entry.kcal = statement.column_int (6);

                entries.append (entry);
            } 

            return entries;
        }

        public void add_entry (Model.Entry entry) {
            Sqlite.Statement statement;
            int result;

            string q = """
                INSERT 
                INTO entries (kcal, date, meal_id, food_id, servings)
                VALUES (?, ?, ?, ?, ?)
            """;

            result = db.prepare_v2 (q, -1, out statement);
            assert (result == Sqlite.OK);

            result = statement.bind_int (1, entry.kcal);
            assert (result == Sqlite.OK);
            result = statement.bind_text (2, entry.date.format ("%F"));
            assert (result == Sqlite.OK);
            result = statement.bind_int (3, entry.meal_id);
            assert (result == Sqlite.OK);
            result = statement.bind_int (4, entry.food_id);
            assert (result == Sqlite.OK);
            result = statement.bind_int (5, entry.servings);
            assert (result == Sqlite.OK);

            result = statement.step ();
        }

        public void delete_entry (Model.Entry entry) {
            Sqlite.Statement statement;
            int result;

            string q = """
                DELETE 
                FROM entries 
                WHERE id = ?
            """;

            result = db.prepare_v2 (q, -1, out statement);
            assert (result == Sqlite.OK);

            result = statement.bind_int (1, entry.id);
            assert (result == Sqlite.OK);

            result = statement.step ();
        }

        /*
        * MEAL
        */

        public List<Model.Meal?> get_all_meals () {
            Sqlite.Statement statement;
            int result;

            string q = """
                SELECT * 
                FROM meals
            """;

            List<Model.Meal?> meals = new List<Model.Meal?> ();

            result = db.prepare_v2 (q, -1, out statement);

            while ((result = statement.step()) == Sqlite.ROW) {
                Model.Meal meal = new Model.Meal ();

                meal.id = statement.column_int (0);
                meal.name = statement.column_text (1);

                meals.append (meal);
            }

            return meals;
        }

        public Model.Meal get_meal_by_id (int id) {
            Sqlite.Statement statement;
            int result;
            
            string q = """
                SELECT *
                FROM meals
                WHERE id = ?
            """;

            result = db.prepare_v2 (q, -1, out statement);

            result = statement.bind_int (1, id);
            assert (result == Sqlite.OK);

            result = statement.step ();
            assert (result == Sqlite.ROW);

            Model.Meal meal = new Model.Meal ();
            meal.id = statement.column_int (0);
            meal.name = statement.column_text (1);

            return meal;
        }

        public void update_meal (Model.Meal meal) {
            Sqlite.Statement statement;
            int result;
            
            string q = """
                UPDATE meals
                SET name = ?
                WHERE id = ?
            """;

            result = db.prepare_v2 (q, -1, out statement);

            result = statement.bind_text (1, meal.name);
            assert (result == Sqlite.OK);
            result = statement.bind_int (2, meal.id);
            assert (result == Sqlite.OK);

            result = statement.step ();
        }

        /*
        * FOOD
        */

        public void add_food (Model.Food food) {
            Sqlite.Statement statement;
            int result;

            string q = """
                INSERT 
                INTO food (name, kcal)
                VALUES (?, ?)
            """;

            result = db.prepare_v2 (q, -1, out statement);

            result = statement.bind_text (1, food.name);
            assert (result == Sqlite.OK);
            result = statement.bind_int (2, food.kcal);
            assert (result == Sqlite.OK);

            result = statement.step ();
        }

        public void update_food (Model.Food food) {
            Sqlite.Statement statement;
            int result;

            string q = """
                UPDATE food
                SET
                    name = ?,
                    kcal = ?
                WHERE id = ?
            """;

            result = db.prepare_v2 (q, -1, out statement);

            result = statement.bind_text (1, food.name);
            assert (result == Sqlite.OK);
            result = statement.bind_int (2, food.kcal);
            assert (result == Sqlite.OK);
            result = statement.bind_int (3, food.id);
            assert (result == Sqlite.OK);

            result = statement.step ();
        }

        public Model.Food get_food_by_id (int id) {
            Sqlite.Statement statement;
            int result;
            
            string q = """
                SELECT *
                FROM food
                WHERE id = ?
            """;

            result = db.prepare_v2 (q, -1, out statement);

            result = statement.bind_int (1, id);
            assert (result == Sqlite.OK);

            result = statement.step ();
            assert (result == Sqlite.ROW);

            Model.Food food_single = new Model.Food ();
            food_single.id = statement.column_int (0);
            food_single.name = statement.column_text (1);
            food_single.kcal = statement.column_int (2);

            return food_single;
        }

        public List<Model.Food?> get_all_food () {
            Sqlite.Statement statement;
            int result;

            string q = """
                SELECT * 
                FROM food
            """;

            List<Model.Food?> food = new List<Model.Food?> (); 
            result = db.prepare_v2 (q, -1, out statement);

            while ((result = statement.step()) == Sqlite.ROW) {
                Model.Food single_food = new Model.Food ();
                
                single_food.id = statement.column_int (0);
                single_food.name = statement.column_text (1);
                single_food.kcal = statement.column_int (2);

                food.append (single_food);
            }

            return food;
        }
    }
}
