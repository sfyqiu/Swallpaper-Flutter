#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include "flutter_window.h"
#include "run_loop.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance,
                      _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line,
                      _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run')
  if (::AttachConsole(ATTACH_PARENT_PROCESS) || ::AllocConsole()) {
    ::AttachConsole(ATTACH_PARENT_PROCESS);
    FILE *unused;
    if (freopen_s(&unused, "CONOUT$", "w", stdout)) {
      _dup2(_fileno(stdout), 1);
    }
    if (freopen_s(&unused, "CONOUT$", "w", stderr)) {
      _dup2(_fileno(stderr), 2);
    }
  }

  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  RunLoop run_loop;

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(flutter::FlutterViewController(
      kDesktopWindowWidth, kDesktopWindowHeight, project));
  WindowedWindow::Run(instance, show_command);

  ::CoUninitialize();
  return 0;
}
