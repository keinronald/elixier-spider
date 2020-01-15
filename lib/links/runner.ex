defmodule Links.Runner do

  def run(seed_url \\ "https://stackoverflow.com/", depth \\ 3) do
    Links.Spider.start(seed_url, depth)
  end

end
