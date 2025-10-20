#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/stat.h>

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static void my_application_activate(GApplication* application) {
  GtkWindow* window = GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
  gtk_window_set_title(window, "Pharaoh Shell");
  gtk_window_set_default_size(window, 1920, 1080);
  gtk_widget_set_visible(GTK_WIDGET(window), TRUE);

  FlDartProject* project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, MY_APPLICATION(application)->dart_entrypoint_arguments);

  GtkWidget* flutter_view = fl_view_new(project);
  gtk_widget_set_hexpand(flutter_view, TRUE);
  gtk_widget_set_vexpand(flutter_view, TRUE);
  gtk_window_set_child(window, flutter_view);

  fl_register_plugins(FL_PLUGIN_REGISTRY(flutter_view));
}

static void my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  self->dart_entrypoint_arguments = g_strdupv(*arguments);
  G_APPLICATION_CLASS(my_application_parent_class)->local_command_line(application, arguments, exit_status);
}

static void my_application_class_init(MyApplicationClass* klass) {
  GApplicationClass* application_class = G_APPLICATION_CLASS(klass);
  application_class->activate = my_application_activate;
  application_class->local_command_line = my_application_local_command_line;
}

static void my_application_init(MyApplication* self) {
  self->dart_entrypoint_arguments = nullptr;
}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", "com.pharaoh.shell",
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}
