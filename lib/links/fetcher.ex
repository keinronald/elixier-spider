defmodule Links.Fetcher do

    def fetch(url) do
        case HTTPoison.get!(url) do
            %HTTPoison.Response{status_code: 200, body: html} ->
                html
            %HTTPoison.Response{status_code: 301, body: html} ->
                html
            %HTTPoison.Response{status_code: 302, body: html} ->
                html
            %HTTPoison.Error{reason: reason} ->
                IO.puts(reason)
                nil
            _ ->
                IO.puts("unwanted status code.")
                nil
        end
    end

end
