defmodule Links.Parser do
    def parse(nil, _), do: []

    def parse(html, url) do
        %{host: host_url} = URI.parse(url)
        
        Floki.find(html, "a")
        |> Floki.attribute("href")
        |> Stream.filter(&filter_href(&1, host_url))
        |> Stream.map(&cut_parameters(&1))
        |> Stream.map(&convert(&1, url))
        |> Enum.to_list()
    end

    defp relative?(href), do: !String.starts_with?(href, "http")

    defp convert(href, url) do
        if relative?(href) do
            %{scheme: scheme_url, host: host_url} = URI.parse(url)
            scheme_url <> "://" <> host_url
        else
            href
        end
    end

    defp filter_href(href, host_url) do
        %{host: host_href} = URI.parse(href)
        host_href == nil || host_href ==  host_url
    end

    defp cut_parameters(href) do
        Regex.replace(~r/(\?.*)/, href, "")
    end
end
