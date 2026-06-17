#include "run_loop.h"

#include <flutter/standard_message_codec.h>
#include <windows.h>
#include <algorithm>
#include <chrono>

RunLoop::RunLoop() = default;
RunLoop::~RunLoop() = default;

void RunLoop::Run() {
  auto const start_time = std::chrono::high_resolution_clock::now();
  MSG message;
  bool quit = false;

  while (!quit) {
    auto const next_time = DoFlutterEvents(start_time);
    auto const timeout = std::chrono::duration_cast<std::chrono::milliseconds>(
        next_time - std::chrono::steady_clock::now());

    DWORD wait = timeout.count() > 0
                     ? static_cast<DWORD>(
                           std::min(timeout.count(), static_cast<long long>(100)))
                     : 0;

    if (MsgWaitForMultipleObjects(0, nullptr, FALSE, wait, QS_ALLINPUT) ==
        WAIT_OBJECT_0) {
      while (PeekMessage(&message, nullptr, 0, 0, PM_REMOVE)) {
        if (message.message == WM_QUIT) {
          quit = true;
          break;
        }
        TranslateMessage(&message);
        DispatchMessage(&message);
      }
    }
  }
}

std::chrono::steady_clock::time_point RunLoop::DoFlutterEvents(
    std::chrono::steady_clock::time_point start_time) {
  auto next_time = std::chrono::steady_clock::now();
  auto wake_time = flutter::Engine::ProcessMessages();
  if (wake_time.has_value()) {
    next_time = std::max(next_time, wake_time.value());
  }
  return next_time;
}
