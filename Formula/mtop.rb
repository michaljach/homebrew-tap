class Mtop < Formula
  desc "Compact terminal dashboard for system, throughput, GPU and Docker"
  homepage "https://github.com/michaljach/mtop"
  url "https://github.com/michaljach/mtop/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0a57f902418259ec12fa6def4408431248457a849a19b0f1cf1ff7c4802f3332"
  license "MIT"
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
