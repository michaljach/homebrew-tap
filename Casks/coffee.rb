cask "coffee" do
  version "1.1.0"
  sha256 "30f255fbd7386d070da779bbe18cb18f5f5700d2c1687f2f18fca9ae6307cbba"

  url "https://github.com/michaljach/coffee/releases/download/v#{version}/Coffee-#{version}.zip"
  name "Coffee"
  desc "Menu bar toggle to prevent sleep, even with the lid closed"
  homepage "https://github.com/michaljach/coffee"

  license "MIT"

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
