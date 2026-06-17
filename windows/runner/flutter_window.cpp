#include "flutter_window.h"

#include <optional>
#include <winuser.h>
#include "flutter/generated_plugin_registrant.h"

static constexpr int kDesktopWindowWidth = 1280;
static constexpr int kDesktopWindowHeight = 800;

FlutterWindow::FlutterWindow(const flutter::FlutterViewController &controller)
    : controller_(controller) {}

FlutterWindow::~FlutterWindow() = default;

std::optional<LRESULT> FlutterWindow::HandleMessage(UINT const message,
                                                     WPARAM const wparam,
                                                     LPARAM const lparam) {
  switch (message) {
    case WM_DESTROY:
      PostQuitMessage(0);
      return 0;
    case WM_SIZE: {
      if (controller_.view() && controller_.view()->GetRenderTarget()) {
        RECT rect;
        GetClientRect(hwnd(), &rect);
        controller_.view()->GetRenderTarget()->Resize(
            rect.right - rect.left, rect.bottom - rect.top);
      }
      return 0;
    }
  }
  return std::nullopt;
}
