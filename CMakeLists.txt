project (calorie)

cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${CMAKE_PROJECT_NAME})
set (RELEASE_NAME "Play A Strawberry On The Drums")
set (VERSION "0.1")
set (VERSION_INFO "Indev")
set (SRC_TARGET ${CMAKE_PROJECT_NAME})

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

install (PROGRAMS ${CMAKE_CURRENT_SOURCE_DIR}/data/calorie.desktop DESTINATION ${DATADIR}/applications/)

add_subdirectory (po)

add_definitions("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED gtk+-3.0 gee-0.8 granite sqlite3)

add_definitions(${DEPS_CFLAGS})

link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Application.vala
    src/Utils.vala
    src/UI/Toolbar.vala
    src/UI/ApplicationMenu.vala
    src/UI/EntryContextMenu.vala
    src/UI/DiaryView.vala
    src/UI/MealView.vala
    src/UI/EntryView.vala
    src/UI/SummaryView.vala
    src/UI/Widgets/DatePickerWithButtons.vala
    src/UI/Widgets/DatePicker.vala
    src/UI/Dialogs/AddFoodDialog.vala
    src/UI/Dialogs/ConfigureMealNamesDialog.vala
    src/Model/Entry.vala
    src/Model/Meal.vala
    src/Model/Food.vala
    src/Database.vala
PACKAGES 
    gtk+-3.0
    gee-0.8
    granite
    sqlite3
OPTIONS
    --define=USE_GRANITE_DECORATED_WINDOW
)

add_executable(${EXEC_NAME} ${VALA_C})

foreach(size 16 24 32 48 64 128)
    install(FILES icons/${size}x${size}/calorie.png
            DESTINATION ${DATADIR}/icons/hicolor/${size}x${size}/apps)
endforeach()

install(CODE "execute_process (COMMAND gtk-update-icon-cache -t -f ${DATADIR}/icons/hicolor)")

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
