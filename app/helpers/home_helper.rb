module HomeHelper
  def app_name
    ENV.fetch("APP_NAME", "Your app")
  end

  def github_repo_url
    ENV.fetch("GITHUB_REPO_URL", nil)
  end
end
