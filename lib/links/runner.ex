defmodule Links.Runner do

  def run do
    Links.Spider.start("https://stackoverflow.com/", 3)
  end

end
