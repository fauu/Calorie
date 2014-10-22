#Calorie

##What is it?
Calorie is a simple calorie tracker application for elementary OS.

##Utilised technologies
* **Vala** programming language with **Libgee** collection library
* **GTK+** GUI toolkit with **Granite** extension
* **SQLite** database engine
* **CMake** build system

##Current version
Calorie is  currently under development so there is no official release of any kind apart from snapshots.

##Screenshots
* [Main view](http://i.imgur.com/KcDQn6a.png)
* [Adding food diary entry](http://i.imgur.com/WWeoTDu.png)
* [Customizing meal names](http://i.imgur.com/y0db9Nc.png)

##Future plans
* Proper release
* i18n
* Daily/weekly/monthly goals
* Saving predefined meals
* Calorie intake history chart
* Integration with [USDA National Nutrient Database for Standard Reference](http://www.ars.usda.gov/Services/docs.htm?docid=8964)
* ...

##Installation
As there hasn't been an official release yet, the only way to get Calorie is to compile it from sources.

###Dependencies
* valac
* libgee-0.8-dev
* libgtk-3.0-dev
* libgranite-dev
* libsqlite3-dev

###Compilation
Refer to the [build_and_run_local.sh](https://github.com/fauu/Calorie/blob/master/build_and_run_local.sh) bash script.

You might need to create *~/.local/share/calorie* directory as a temporary fix if the application reports that it has failed to create the database.

##Licensing
See the [COPYING](https://github.com/fauu/Calorie/blob/master/COPYING) file.

##Authors
See the [AUTHORS](https://github.com/fauu/Calorie/blob/master/AUTHORS) file.
