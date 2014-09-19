require 'test_helper'

class OpenUriRedirectionPatchTest < Crawler::TestCase
  def test_allow_redirection_from_http_to_https
    assert OpenURI.redirectable?(
      URI.parse("http://localhost"),
      URI.parse("https://localhost")
    )
  end

  def test_allow_redirection_from_https_to_http
    assert OpenURI.redirectable?(
      URI.parse("https://localhost"),
      URI.parse("http://localhost")
    )
  end
end
