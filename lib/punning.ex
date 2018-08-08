defmodule Punning do
  @moduledoc """
  # Punning

  With this library you get language support for field punning in maps within Elixir.

  The syntax is very simple, when you write

    %{field}

  this will be transformed into:

    %{field: field}

  For now it only works in function heads and bodies. You can enable punning by just use-ing this package:

    defmodule App
      use Punning

      def fun(%{field}), do: field
    end
  """

  import Kernel, except: [def: 2, defp: 2]

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2, defp: 2]
      import Punning
    end
  end

  Kernel.defp(impute_puns(ast, acc \\ []))
  Kernel.defp(impute_puns([], acc) when length(acc) > 0, do: Enum.reverse(acc))
  Kernel.defp(impute_puns([], []), do: [])

  Kernel.defp impute_puns([{name, meta, ctx} | rest], acc) when is_atom(name) and is_atom(ctx) do
    impute_puns(rest, [{name, {name, meta, ctx}} | acc])
  end

  Kernel.defp(
    impute_puns([{identifier, ctx, args} | rest], acc),
    do: impute_puns(rest, [{identifier, ctx, transform(args)} | acc])
  )

  @doc """
  Hello world.
  """
  Kernel.def(transform(ast, acc \\ []))

  Kernel.def transform({:%{}, ctx, args}, _) do
    {:%{}, ctx, impute_puns(args)}
  end

  Kernel.def transform({identifier, ctx, args}, _) when is_list(args) do
    {identifier, ctx, transform(args)}
  end

  Kernel.def(transform([], acc) when length(acc) > 0, do: Enum.reverse(acc))
  Kernel.def(transform([], []), do: [])

  Kernel.def transform([el | rest], acc) do
    transform(rest, [transform(el) | acc])
  end

  Kernel.def transform(term, _) when is_tuple(term) do
    term
    |> Tuple.to_list()
    |> transform()
    |> List.to_tuple()
  end

  Kernel.def transform(ast, _) do
    ast
  end

  defmacro def(call, exp) do
    quote do
      Kernel.def(unquote(transform(call)), unquote(transform(exp)))
    end
  end

  defmacro defp(call, exp) do
    quote do
      Kernel.defp(unquote(transform(call)), unquote(transform(exp)))
    end
  end
end
