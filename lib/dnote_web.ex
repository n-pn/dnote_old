defmodule DnoteWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use DnoteWeb, :controller
      use DnoteWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: DnoteWeb

      import Plug.Conn
      import DnoteWeb.Gettext
      alias DnoteWeb.Router.Helpers, as: Routes

      import DnoteWeb.WebHelpers
      import DnoteWeb.ControllerHelpers
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/dnote_web/templates",
        namespace: DnoteWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import DnoteWeb.ErrorHelpers
      import DnoteWeb.Gettext
      alias DnoteWeb.Router.Helpers, as: Routes

      import DnoteWeb.WebHelpers
      import DnoteWeb.ViewHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import DnoteWeb.Gettext
    end
  end

  def plug do
    quote do
      use Phoenix.Controller, namespace: DnoteWeb

      import Plug.Conn
      import DnoteWeb.Gettext
      alias DnoteWeb.Router.Helpers, as: Routes

      import DnoteWeb.IdentifyUser, only: [current_user: 1, logged_in?: 1]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
