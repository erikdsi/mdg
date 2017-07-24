defmodule Mdg.Password do
  @moduledoc """
  Measures strenght of a password based on OWASP guidelines:
  https://www.owasp.org/index.php/Authentication_Cheat_Sheet#Implement_Proper_Password_Strength_Controls

  Minimum score for a strong password should be around 620
  """
  alias Mdg.Password.Tests


  def strength_score(password) do
    {score, _} = check_strength(password)
    score
  end
  @doc """
  Takes a password and return an integer representing it's strenght and a list of atoms
  that represent hints to improve it

  ## Examples

    iex> Mdg.Password.check_strength("Phrases are good passwords?")
    {2295, [:no_number]}
  """
  def check_strength(password) do
    len = String.length(password)
    tips = if len < 10, do: [:small_length], else: []

    {search_space, tips} = {0, tips}
    |> has_number?(password)
    |> has_special_char?(password)
    |> has_uppercase?(password)
    |> has_lowercase?(password)

    strength = (:math.pow(len, 2) + search_space)

    charlist = password
    |> String.split("")
    |> Enum.drop(-1)

    [curr | tail] = charlist
    [next | _] = tail

    calc_strength(strength, tips, nil, curr, next, tail)
  end

  defp calc_strength(strength, tips, prev, curr, next, tail) do

    {strength, tips} = sequence?(strength, tips, prev, curr, next)
    {strength, tips} = repetition?(strength, tips, prev, curr, next)

    len = length(tail)

    {strength, tips} = cond do
      len > 1 ->
        prev = curr
        [curr | tail] = tail
        [next | _] = tail
        calc_strength(strength, tips, prev, curr, next, tail)
      len == 1 ->
        prev = curr
        [curr] = tail
        calc_strength(strength, tips, prev, curr, nil, [])
      len == 0 ->
        {strength, tips}
    end
    {strength, tips}
  end

  defp repetition?(strength, tips, p, c, n) do
    if p == c == n do
      {strength-95, tips ++ [:avoid_repetition]}
    else
      {strength, tips}
    end
  end

  defp sequence?(strength, tips, p, c, n) do
    penalty = 0
    #alphabetical
    penalty = if p && Tests.is_alphabetical_sequence?(p, c), do: penalty - 26, else: penalty
    penalty = if n && Tests.is_alphabetical_sequence?(c, n), do: penalty - 26, else: penalty
    #alphabetical alternated
    penalty = if p && n && Tests.is_alphabetical_sequence?(p, n), do: penalty - 26, else: penalty
    #numerical
    penalty = if p && Tests.is_numerical_sequence?(p, c), do: penalty - 10, else: penalty
    penalty = if n && Tests.is_numerical_sequence?(c, n), do: penalty - 10, else: penalty
    #numerical alternated
    penalty = if p && n && Tests.is_numerical_sequence?(p, n), do: penalty - 10, else: penalty
    #qwerty
    penalty = if p && Tests.is_qwerty_sequence?(p, c), do: penalty - 26, else: penalty
    penalty = if n && Tests.is_qwerty_sequence?(c, n), do: penalty - 26, else: penalty
    #qwerty alternated
    penalty = if p && n && Tests.is_qwerty_sequence?(p, n), do: penalty - 26, else: penalty
    if penalty > 0 do
      {strength - penalty, tips ++ [:avoid_sequences]}
    else
      {strength, tips}
    end
  end

  defp has_number?({search_space, tips}, password) do
    if Tests.has_number?(password) do
      {search_space + 10, tips}
    else
      {search_space, tips ++ [:no_number]}
    end
  end

  defp has_special_char?({search_space, tips}, password) do
    if Tests.has_special_char?(password) do
      {search_space + 33, tips}
    else
      {search_space, tips ++ [:no_special]}
    end
  end

  defp has_uppercase?({search_space, tips}, password) do
    if Tests.has_uppercase?(password) do
      {search_space + 26, tips}
    else
      {search_space, tips ++ [:no_upper]}
    end
  end

  defp has_lowercase?({search_space, tips}, password) do
    if Tests.has_lowercase?(password) do
      {search_space + 26, tips}
    else
      {search_space, tips ++ [:no_lower]}
    end
  end
end