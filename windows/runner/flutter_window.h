#ifndef FLUTTER_WINDOW_H_
#define FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <winuser.h>
#include "run_loop.h"

class FlutterWindow : public WindowedWindow {
 public:
  explicit FlutterWindow(const flutter::FlutterViewController &controller);
  virtual ~FlutterWindow();

  FlutterWindow(const FlutterWindow &) = delete;
  FlutterWindow &operator=(const FlutterWindow &) = delete;

 protected:
  std::optional<LRESULT> HandleMessage(UINT message, WPARAM wparam,
                                        LPARAM lparam) override;

 private:
  flutter::FlutterViewController controller_;
};

#endif  // FLUTTER_WINDOW_H_
