defmodule Links.Parser do
    def parse(nil, _), do: []

    def parse(html, url) do
        IO.puts("----------")
        IO.inspect(html)
        IO.inspect(url)

        %{host: host_url} = URI.parse(url)

        IO.inspect(host_url)
        IO.puts("###########")

        Floki.find(html, "a")
        |> Floki.attribute("href")
        |> Stream.filter(&filter_other_domains(&1, host_url))
        |> Stream.filter(&filter_images(&1))
        |> Stream.map(&cut_query_params(&1))
        |> Stream.map(&cut_anchors(&1))
        |> Stream.map(&convert(&1, url))
        |> Enum.to_list()
        
    end

    defp relative?(href), do: !String.starts_with?(href, "http")

    defp convert(href, url) do
        if relative?(href) do
            %{scheme: scheme_url, host: host_url} = URI.parse(url)
            scheme_url <> "://" <> host_url <> href
        else
            href
        end
    end

    defp filter_images(url) do
        !String.ends_with?(url, [".png", ".jpg", "jpeg", "gif"])
    end

    defp filter_other_domains(href, host_url) do
        %{host: host_href} = URI.parse(href)
        host_href == nil || host_href ==  host_url
    end

    defp cut_query_params(href) do
        Regex.replace(~r/(\?.*)/, href, "")
    end
    defp cut_anchors(href) do
        Regex.replace(~r/(\#.*)/, href, "")
    end
end
