# Punning

With this library you get language support for field punning in maps within Elixir.

The syntax is very simple, when you write

```elixir
%{field}
```

this will be transformed into:

```elixir
%{field: field}
```

For now it only works in function heads and bodies. You can enable punning by just use-ing this package:

```elixir
defmodule App
  use Punning

  def fun(%{field}), do: field
end
```

## Installation

The package can be installed by adding `punning` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:punning, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/punning](https://hexdocs.pm/punning).
