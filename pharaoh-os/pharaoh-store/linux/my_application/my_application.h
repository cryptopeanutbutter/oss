#ifndef PHARAOH_STORE_MY_APPLICATION_H_
#define PHARAOH_STORE_MY_APPLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, my_application, MY, APPLICATION, GtkApplication)

MyApplication* my_application_new();

#endif  // PHARAOH_STORE_MY_APPLICATION_H_
