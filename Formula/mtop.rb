class Mtop < Formula
  desc "Compact terminal dashboard for system, throughput, GPU and Docker"
  homepage "https://github.com/michaljach/mtop"
  url "https://github.com/michaljach/mtop/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d2b04789a5c0939869a44cad574a44eadeb1b177a86d7a8a7477cd9707bb4f52"
  head "https://github.com/michaljach/mtop.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/mtop"
  end

  test do
    assert_match "mtop v#{version}", shell_output("#{bin}/mtop -version")
    assert_match "SYSTEM", shell_output("#{bin}/mtop -once -demo")
  end
end
