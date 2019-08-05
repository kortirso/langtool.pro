defmodule LangtoolProWeb.UserMailer do
  use Bamboo.Phoenix, view: LangtoolProWeb.UserMailerView
  alias LangtoolPro.{Users.User}
  alias LangtoolProWeb.LayoutView

  @doc """
  Sends welcome email with confirmation data

  ## Examples

      iex> LangtoolProWeb.UserMailer.welcome_email(user, "html")

  """
  def welcome_email(%User{} = user) do
    user
    |> prepare_text()
    |> put_html_layout({LayoutView, "email.html"})
    |> render("welcome_email.html", user: user)
    |> premail()
  end

  defp prepare_text(user) do
    new_email()
    |> to(user.email)
    |> from("support@langtool.pro")
    |> subject("Welcome!")
    |> put_text_layout({LayoutView, "email.text"})
    |> render("welcome_email.text", user: user)
  end

  defp premail(%Bamboo.Email{} = email) do
    email
    |> html_body(Premailex.to_inline_css(email.html_body))
    |> text_body(Premailex.to_text(email.html_body))
  end
end
