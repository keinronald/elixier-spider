defmodule Links.Spider do

    def start(seed_url, depth \\ 5) do
        links_crawled_pid = Links.List.start_link()
        crawl(seed_url, depth, links_crawled_pid)
        IO.inspect(get_list(links_crawled_pid))
        length(get_list(links_crawled_pid))
    end

    defp crawl(seed_url, depth, links_crawled_pid) do
        links_to_crawl_pid = Links.List.start_link()

        add_links_to_crawl(seed_url, links_to_crawl_pid)
        add_link_to_crawled(links_crawled_pid, seed_url)

        handle_recursion(depth, links_to_crawl_pid, links_crawled_pid)
    end

    defp handle_recursion(depth, links_to_crawl_pid, links_crawled_pid) do
        links_to_crawl = get_list(links_to_crawl_pid)
        if depth > 0 do
            Enum.each(links_to_crawl, fn(link) -> 
                if !Enum.member?(get_list(links_crawled_pid), link) do
                    IO.puts("...")
                    crawl(link, depth - 1, links_crawled_pid)
                end
            end)
        end
    end

    defp add_links_to_crawl(seed_url, links_to_crawl_pid) do
        Links.Fetcher.fetch(seed_url)
        |> Links.Parser.parse(seed_url)
        |> Stream.each(&Links.List.add(links_to_crawl_pid, &1))
        |> Enum.to_list()
    end

    defp add_link_to_crawled(links_crawled_pid, seed_url) do
        Links.List.add(links_crawled_pid, seed_url)
    end

    defp get_list(pid) do
        Links.List.all(pid, self())
        receive do
            {:list, list} -> list
        end
    end
end