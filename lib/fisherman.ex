defmodule Fisherman do
  defmacro hook({name, _, args}, do: body) do
    arity = Enum.count(args)

    quote do
      def unquote(name)(unquote_splicing(args)) do
        mod = Fisherman.module_get(__MODULE__)

        cond do
          mod && Fisherman.exported?(mod, unquote(name), unquote(arity)) ->
            apply(mod, unquote(name), unquote(args))

          mod && Fisherman.exported?(mod, :hook_catch, 2) ->
            apply(mod, :hook_catch, [unquote(name), unquote(args)])

          true ->
            unquote(body)
        end
      end
    end
  end

  def module_get(mod) do
    Application.get_env(:fisherman, mod)
  end

  def module_set(left, right) do
    Application.put_env(:fisherman, left, right)
  end

  def exported?(mod, fun, arity) do
    mod.__info__(:functions)
    |> Enum.member?({fun, arity})
  end
end

defmodule Fisherman.Example do
  import Fisherman

  hook foo(a, b) do
  end

  hook bar() do
  end
end

defmodule Fisherman.Example.Override do
  def bar() do
    "Hello"
  end
end
