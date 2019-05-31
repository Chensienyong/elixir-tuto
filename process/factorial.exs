defmodule Factorial do
  def spawn(n) when n < 4 do
    calc_product(n)
  end

  def spawn(n) do
    1..n
    |> Enum.chunk_every(4)
    |> Enum.map(fn(list) ->
      spawn(Factorial, :_spawn_function, [list])
      |> send(self())

      receive do
        n -> n
      end
    end)
    |> calc_product()
  end

  def _spawn_function(list) do
    receive do
      sender ->
        product = calc_product(list)
        send(sender, product)
    end
  end

  # used on the single process
  def calc_product(n) when is_integer(n) do
    Enum.reduce(1..n, 1, &(&1 * &2))
  end

  # used with multiple processes
  def calc_product(list) do
    Enum.reduce(list, 1, &(&1 * &2))
  end
end
