class Chaossubs < Formula
  include Language::Python::Virtualenv

  desc "Video subtitle extraction & Chinese translation"
  homepage "https://github.com/Chaos0129/ChaosSubs"
  url "https://github.com/Chaos0129/ChaosSubs/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f9f55f64ddd23e4380e063260e0753e442a10b0ac8018ee07bdcf73c2c4f8dc6"
  license "MIT"

  depends_on "python@3.12"
  depends_on "ffmpeg"
  depends_on "ollama"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install "setuptools"
    venv.pip_install_and_link buildpath

    # Copy static files
    (libexec/"static").install Dir["static/*"]

    # Create wrapper script
    (bin/"chaossubs").write <<~EOS
      #!/bin/bash
      cd "#{libexec}" && exec "#{libexec}/bin/python" -m cli "$@"
    EOS
  end

  def caveats
    <<~EOS
      ChaosSubs v0.1.1 安装完成！

      首次使用前请运行:
        chaossubs check

      如需下载模型:
        ollama pull qwen2.5:14b

      启动服务:
        chaossubs start
    EOS
  end

  test do
    assert_match "ChaosSubs", shell_output("#{bin}/chaossubs version")
  end
end
