defmodule Board.Routes do
    use N2O, with: [:n2o]

    def finish(state, context), do: {:ok, state, context}

    def init(state, context) do
        %{path: path} = cx(context, :req)
        {:ok, state, cx(context, path: path, module: route_prefix(path))}
    end

    defp route_prefix(<<"/ws/", p::binary>>), do: route(p)
    defp route_prefix(<<"/", p::binary>>), do: route(p)
    defp route_prefix(path), do: route(path)

    def route(<<>>), do: :index
    def route(<<"index", _::binary>>), do: :index
    def route(<<"app/index", _::binary>>), do: :index
    def route(<<"login", _::binary>>), do: :login
    def route(_), do: :index
end
