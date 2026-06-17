#ifndef RUN_LOOP_H_
#define RUN_LOOP_H_

#include <flutter/engine.h>
#include <windows.h>
#include <chrono>

class RunLoop {
 public:
  RunLoop();
  ~RunLoop();

  RunLoop(const RunLoop &) = delete;
  RunLoop &operator=(const RunLoop &) = delete;

  void Run();

 private:
  std::chrono::steady_clock::time_point DoFlutterEvents(
      std::chrono::steady_clock::time_point start_time);
};

class WindowedWindow {
 public:
  WindowedWindow() : hwnd_(nullptr) {}
  virtual ~WindowedWindow() = default;

  static LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wparam,
                                   LPARAM lparam) {
    WindowedWindow *window = nullptr;
    if (message == WM_NCCREATE) {
      auto *create_struct = reinterpret_cast<CREATESTRUCT *>(lparam);
      window = reinterpret_cast<WindowedWindow *>(create_struct->lpCreateParams);
      SetWindowLongPtr(hwnd, GWLP_USERDATA,
                       reinterpret_cast<LONG_PTR>(window));
      window->hwnd_ = hwnd;
    } else {
      window = reinterpret_cast<WindowedWindow *>(
          GetWindowLongPtr(hwnd, GWLP_USERDATA));
    }

    if (window) {
      auto result = window->HandleMessage(message, wparam, lparam);
      if (result) {
        return result.value();
      }
    }
    return DefWindowProc(hwnd, message, wparam, lparam);
  }

  static void Run(HINSTANCE instance, int show_command) {
    MSG message;
    while (GetMessage(&message, nullptr, 0, 0)) {
      TranslateMessage(&message);
      DispatchMessage(&message);
    }
  }

  HWND hwnd() const { return hwnd_; }

 protected:
  virtual std::optional<LRESULT> HandleMessage(UINT message, WPARAM wparam,
                                                LPARAM lparam) = 0;

  HWND hwnd_;
};

#endif  // RUN_LOOP_H_
