defmodule Mdg.Password.Tests do
  @moduledoc """
  Tests
  """
  import Mdg.Password.Helpers

  @doc """
  Checks for ulds pattern as it's a common topology
  ulns means a password that starts with [u]ppercase,
  followed by a few [l]owercase, followed by a few [n]umbers,
  followed by a one or a few [s]pecial characters
  ## Example

    iex> Mdg.Password.Tests.ulds_pattern?("Capitalized123!")
    true
    iex> Mdg.Password.Tests.ulds_pattern?("password")
    false
    iex> Mdg.Password.Tests.ulds_pattern?("password123")
    true
  """
  def ulds_pattern?(pw) do
    Regex.match?(~r/^[A-Z|a-z][a-z]{2,15}[0-9]{1,15}([^a-zA-Z0-9]{1,5}|\z)$/, pw)
  end

  @doc """
  Checks two chars to see if they're in qwerty sequence

  ## Examples

    iex> Mdg.Password.Tests.is_qwerty_sequence?("q", "w")
    true
    iex> Mdg.Password.Tests.is_qwerty_sequence?("a", "b")
    false
  """
  def is_qwerty_sequence?(a, b) do
    if Regex.match?(~r/[a-z]$/i, a) and Regex.match?(~r/[a-z]$/i, b) do
      ia = a |> String.downcase |> qwerty_index!
      ib = b |> String.downcase |> qwerty_index!
      is_sequence?(ia, ib)
    else
      false
    end
  end

  @doc """
  Check two digits to see if they're in numerical sequence

  ## Examples

    iex> Mdg.Password.Tests.is_numerical_sequence?("1", "2")
    true
  """
  def is_numerical_sequence?(a, b) do
    if Regex.match?(~r/[0-9]/, a) and Regex.match?(~r/[0-9]/, b) do
      is_sequence?(String.to_integer(a), String.to_integer(b))
    else
      false
    end
  end

  @doc """
  Checks two chars to see if they're in alphabetic sequence

  ## Examples

    iex> Mdg.Password.Tests.is_alphabetical_sequence?("a","b")
    true
    iex> Mdg.Password.Tests.is_alphabetical_sequence?("b","a")
    true
    iex> Mdg.Password.Tests.is_alphabetical_sequence?("a", "c")
    false
  """
  def is_alphabetical_sequence?(a, b) do
    if Regex.match?(~r/[a-z]$/i, a) and Regex.match?(~r/[a-z]$/i, b) do
      is_sequence?(get_charcode!(b), get_charcode!(a))
    else
      false
    end
  end

  @doc """
  Checks if two numbers are in sequence or reversed sequence
  ## Examples

    iex> Mdg.Password.Tests.is_sequence?(1, 2)
    true
    iex> Mdg.Password.Tests.is_sequence?(2, 1)
    true
  """
  def is_sequence?(a, b) do
    (a == (b+1)) or (a == (b-1))
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Tests.has_number?("d0es t00")
    true
    iex> Mdg.Password.Tests.has_number?("not")
    false
  """
  def has_number?(pw) do
    Regex.match?(~r/[0-9]/, pw)
  end
  @doc """
  ## Examples

      iex> Mdg.Password.Tests.has_special_char?("têm")
      true
      iex> Mdg.Password.Tests.has_special_char?("nop")
      false
  """
  def has_special_char?(pw) do
    not Regex.match?(~r/^[a-z0-9]+$/i, pw)
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Tests.has_uppercase?("Yes")
    true
    iex> Mdg.Password.Tests.has_uppercase?("nop")
    false
  """
  def has_uppercase?(pw) do
    Regex.match?(~r/[A-Z]/, pw)
  end

  @doc """
  ## Examples

    iex> Mdg.Password.Tests.has_lowercase?("always")
    true
    iex> Mdg.Password.Tests.has_lowercase?("0")
    false
  """
  def has_lowercase?(pw) do
    Regex.match?(~r/[a-z]/, pw)
  end
end