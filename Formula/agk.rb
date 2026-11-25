# Rendered by scripts/release.sh from agterm-kit's packaging/homebrew/agk.rb.tmpl; edit the template.
class Agk < Formula
  desc "Applier and reviewer companions for coding agents in the agterm terminal"
  homepage "https://github.com/shurastik/agterm-kit"
  url "https://github.com/shurastik/agterm-kit/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8bace880764e271e1777333acb930d903c2be9fedd46b1ebbf2e983d42ee3d3a"
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
