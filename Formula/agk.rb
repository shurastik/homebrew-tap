# Rendered by scripts/release.sh from agterm-kit's packaging/homebrew/agk.rb.tmpl; edit the template.
class Agk < Formula
  desc "Coding-agent workflow kit for agterm: codex reviews in companion sessions"
  homepage "https://github.com/shurastik/agterm-kit"
  url "https://github.com/shurastik/agterm-kit/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "794d046fdbf4f437e7ea5af65c93f0566b8b6a4e5b02b497da37e1e72df5e805"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/shurastik/agterm-kit/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/agk"
    pkgshare.install "skills"
  end

  def caveats
    <<~EOS
      Link the agent skills for Claude Code and Codex and add .agk/ to the global git ignore:
        agk setup
      Run it again after every `brew upgrade agk`.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/agk version").strip
    assert_path_exists pkgshare/"skills/agk-review/SKILL.md"
  end
end
