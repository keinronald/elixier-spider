defmodule Links.Spider do

    def start(seed_url, depth \\ 5) do
        links_crawled_pid = Links.List.start_link()
        Links.Spider.crawl(seed_url, depth, links_crawled_pid)
        IO.inspect(length(get_list(links_crawled_pid)))
        get_list(links_crawled_pid)
    end

    def crawl(seed_url, depth, links_crawled_pid) do
        links_to_crawl_pid = Links.List.start_link()

        # One global list to store every visited links
        Links.Fetcher.fetch(seed_url)
        |> Links.Parser.parse(seed_url)
        |> Enum.each(fn(link) ->
            Links.List.add(links_to_crawl_pid, link)
        end)

        # adds seed_url to crawled pages list
        Links.List.add(links_crawled_pid, seed_url)

        links_to_crawl = get_list(links_to_crawl_pid)

        if depth >= 0 do
            Enum.each(links_to_crawl, fn(link) -> 
                if !Enum.member?(get_list(links_crawled_pid), link) do
                    IO.puts("...")
                    Links.Spider.crawl(link, depth - 1, links_crawled_pid)
                end
            end)
        end
    end

    def get_list(pid) do
        Links.List.all(pid, self())
        receive do
            {:list, list} -> list
        end
    end
end