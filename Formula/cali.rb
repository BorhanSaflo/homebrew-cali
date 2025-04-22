class Cali < Formula
  desc "A terminal calculator with real-time evaluation, unit conversions, and natural language expressions."
  homepage "https://github.com/BorhanSaflo/cali#readme"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.7.0/cali-aarch64-apple-darwin.tar.xz"
      sha256 "695b897012280a0eef44c9e5a3532b793fb83550c5afa43d8e27069215f08294"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.7.0/cali-x86_64-apple-darwin.tar.xz"
      sha256 "4cf59e2a6931327817fa2682175ffe97735d7783076937d82aa4e93b7090dcf7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BorhanSaflo/cali/releases/download/v0.7.0/cali-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4e224befbed74070e97e4b0d4af9361973a81e333109b4dbfd2007c7b1af338a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cali" if OS.mac? && Hardware::CPU.arm?
    bin.install "cali" if OS.mac? && Hardware::CPU.intel?
    bin.install "cali" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
