defmodule SimpleGenServerMock do
  def start_link() do
    # runs in the caller context 🐌Alice
    spawn_link(__MODULE__, :init, [])
  end

  def call(pid, arguments) do
    # runs in the caller context 🐌Alice
    send pid, {:call, self(), arguments}
    receive
      {:response, data} -> data
    end
  end

  def cast(pid, arguments) do
    # runs in the caller context 🐌Alice
    send pid, {:cast, arguments}
  end

  def init() do
    # runs in the server context 🐨Bob
    initial_state = 1
    loop(initial_state)
  end

  def loop(state) do
    # runs in the server context 🐨Bob
    receive command do
      {:call, pid, :get_data} ->
        # do some work on data here and update state
        {new_state, response} = {state, state}
        send pid, {:response, data}
        loop(new_state)
      {:cast, :increment} ->
        # do some work on data here and update state
        new_state = state + 1
        loop(new_state)
    end
  end
end

pid = SimpleGenServerMock.start_link()
counter = SimpleGenServerMock.call(pid, :get_data)
IO.puts "Counter: #{counter}"
SimpleGenServerMock.cast(pid, :increment)
counter = SimpleGenServerMock.call(pid, :get_data)
IO.puts "Counter: #{counter}"
