defmodule Links.Parser do
    def parse(html, url) do
        %{scheme: scheme_url, host: host_url} = URI.parse(url)
        
        Floki.find(html, "a")
        |> Floki.attribute("href")
        |> Enum.filter(fn(href) -> 
            %{host: host_href} = URI.parse(href)
            host_href == nil || host_href ==  host_url
            end)
        |> Enum.map(fn(href) -> Regex.replace(~r/(\?.*)/, href, "") end)
        |> Enum.map(fn(href) -> case is_relative(href) do
            true ->
                convert(href, url)
            false ->
                href
            end
        end)
    end

    def is_relative(href) do 
        !String.starts_with?(href, "http")
    end

    def convert(relative_link, url) do
        %{scheme: scheme_url, host: host_url} = URI.parse(url)
        scheme_url <> "://" <> host_url
    end
end
