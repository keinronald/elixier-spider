defmodule Links.Fetcher do

    def fetch(url) do
        case HTTPoison.get!(url, [], follow_redirect: true) do
            %HTTPoison.Response{status_code: 200, body: html} ->
                html
            %HTTPoison.Error{reason: reason} ->
                IO.puts(reason)
                nil
        end
    end

end
