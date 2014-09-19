# A monkey patch over open-uri's redirectable method to allow
# unsafe redirection since we are not concerned about the
# data in our cookies
module OpenURI
  def OpenURI.redirectable?(uri1, uri2)
    uri1.scheme.downcase == uri2.scheme.downcase ||
      (/\A(?:https?|ftp)\z/i =~ uri1.scheme && /\A(?:https?|ftp)\z/i =~ uri2.scheme)
  end
end
