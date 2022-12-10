//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <local_auth_windows/local_auth_plugin.h>
#include <realm/realm_plugin.h>
#include <smart_auth/smart_auth_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  RealmPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RealmPlugin"));
  SmartAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SmartAuthPlugin"));
}
