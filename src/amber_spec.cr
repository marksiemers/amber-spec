require "spec"
require "./amber_spec/system/**"
require "./amber_spec/controller/*"
require "./amber_spec/selenium_server"
require "./amber_spec/spec"

# System Testing is a level of the software testing where a
# complete and integrated software is tested. The purpose of this
# test is to evaluate the system's compliance with the specified requirements
module AmberSpec
  # Not all server implementations will support every WebDriver feature.
  # Therefore, the client and server should use JSON objects with the properties
  # listed below when describing which features a session supports.
  class_property capabilities = {
    browserName:              "chrome",
    version:                  "",
    platform:                 "ANY",
    javascriptEnabled:        true,
    takesScreenshot:          true,
    handlesAlerts:            true,
    databaseEnabled:          true,
    locationContextEnabled:   true,
    applicationCacheEnabled:  true,
    browserConnectionEnabled: true,
    cssSelectorsEnabled:      true,
    webStorageEnabled:        true,
    rotatable:                true,
    acceptSslCerts:           true,
    nativeEvents:             true,
  }
end
