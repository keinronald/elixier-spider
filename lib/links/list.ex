defmodule Links.List do

    def start_link do
        pid = spawn(fn -> loop([]) end)
        pid
    end

    def all(link_list_pid, parent_pid) do
        send link_list_pid, {:all, parent_pid}
    end

    def add(link_list_pid, item) do
        send(link_list_pid, {:add, item})
    end

    def loop(list) do
        receive do 
        {:all, pid} ->
            send(pid, {:list, list})
            loop(list)
        {:add, item} ->
            list = [item | list]
            loop(list)
        end
    end
end
