cask "coffee" do
  version "1.0.0"
  sha256 "84570e2127b75b03f80f6e97edbcd9b00ae9703f46a223f66d9dd0e3aee6fed6"

  url "https://github.com/michaljach/coffee/releases/download/v#{version}/Coffee-#{version}.zip"
  name "Coffee"
  desc "Menu bar toggle to prevent sleep, even with the lid closed"
  homepage "https://github.com/michaljach/coffee"

  depends_on macos: :monterey

  app "Coffee.app"

  # Single sudo prompt at install: allow this user to run only `pmset -a disablesleep 0|1`
  # without a password, so toggling in the menu bar never prompts. Also clear quarantine,
  # since the app is ad-hoc signed rather than notarized.
  postflight_steps do
    write_file "coffee.sudoers",
               "{{user}} ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1",
               append_newline: true
    run "/usr/sbin/visudo", args: ["-cqf", "{{staged_path}}/coffee.sudoers"]
    run "/usr/bin/install",
        args: ["-m", "0440", "-o", "root", "-g", "wheel", "{{staged_path}}/coffee.sudoers", "/etc/sudoers.d/coffee"],
        sudo: true
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Coffee.app"],
        sudo:         true,
        must_succeed: false,
        print_stderr: false
  end

  uninstall quit:   "com.michaljach.coffee",
            script: {
              executable: "/usr/bin/pmset",
              args:       ["-a", "disablesleep", "0"],
              sudo:       true,
            },
            delete: "/etc/sudoers.d/coffee"
end
