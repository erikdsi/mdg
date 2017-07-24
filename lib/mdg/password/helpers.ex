defmodule Mdg.Password.Helpers do
  @moduledoc """
  Misc utilities that I didn't know where to put
  """

  @doc """
  Returns the qwerty index for a given string char

  ##Examples

    iex> Mdg.Password.Helpers.qwerty_index!("q")
    0
  """
  def qwerty_index!(string_char) do
    kb = ["q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"]
    get_index!(kb, string_char)
  end
  @doc """
  ## Examples

    iex> Mdg.Password.Helpers.is_alphanumeric?("a")
    true
    iex> Mdg.Password.Helpers.is_alphanumeric?("$")
    false
  """
  def is_alphanumeric?(string_char) do
    Regex.match?(~r/^[a-z0-9]+$/i, string_char)
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Helpers.get_charcode!("a")
    97
  """
  def get_charcode!(string_char) do
    <<charcode::utf8>> = string_char
    charcode
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Helpers.get_index!([1,2,3], 3)
    2
    iex> Mdg.Password.Helpers.get_index!(["a", "b", "c"], 3)
    nil
  """
  def get_index!(list, value) do
    list
    |> Enum.with_index
    |> Enum.filter_map(fn {v, _} -> v == value end,
                       fn {_, i} -> i end)
    |> Enum.at(0)
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Helpers.get_index([1,2,3], 3)
    {:ok, 2}
    iex> Mdg.Password.Helpers.get_index(["a", "b", "c"], 3)
    {:error, "element not found"}
  """
  def get_index(list, value) do
    case get_index!(list, value) do
      nil -> {:error, "element not found"}
      index -> {:ok, index}
    end
  end

end