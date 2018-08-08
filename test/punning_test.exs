defmodule PunningTest do
  use ExUnit.Case
  use Punning
  doctest Punning

  defp punned_code(ast) do
    ast
    |> Punning.transform()
    |> Macro.to_string()
    |> Code.format_string!()
    |> to_string
    |> Kernel.<>("\n")
  end

  test "test punning function" do
    assert Macro.to_string(Punning.transform(quote do: %{bla})) == "%{bla: bla}"
  end

  test "test function head" do
    code =
      quote do
        def bla(%{name}), do: name
      end
      |> punned_code()

    assert code == """
           def(bla(%{name: name})) do
             name
           end
           """
  end

  test "test function body" do
    code =
      quote do
        def bla(test) do
          %{bla} = test
        end
      end
      |> punned_code()

    assert code == """
           def(bla(test)) do
             %{bla: bla} = test
           end
           """
  end

  def bla(%{bla}), do: bla

  test "real function" do
    assert bla(%{bla: "bla"}) == "bla"
  end
end
